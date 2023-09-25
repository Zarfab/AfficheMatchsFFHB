public enum Mode {
  TO_BE_PLAYED, 
  RESULTS
};

final static int TO_BE_PLAYED = 0;
final static int RESULTS = 1;

public String capitalize(String input, boolean allWords) {
  if(input.length() <= 0) return input;
  if(allWords) {
    String trimmed = input.trim();
    String words[] = trimmed.split(" ");
    for(int i = 0; i < words.length; i++) {
      if( words[i].indexOf('.') < 0) {
        char firstChar = words[i].toUpperCase().charAt(0);
        words[i] = firstChar +  words[i].toLowerCase().substring(1);
      }
    }
    return join(words, " ");
  }
  else {
    char firstChar = input.toUpperCase().charAt(0);
    return firstChar + input.toLowerCase().substring(1);
  }
}

public void loadPoolToTeam () {
  poolToTeam = new StringDict();
  File f = new File(dataPath("PoolToTeam.txt"));
  if(!f.exists()) {
    // create the file
    String[] empty = {""};
    saveStrings(dataPath("PoolToTeam.txt"), empty);
  }
  String poolTeam[] = loadStrings(dataPath("PoolToTeam.txt"));
  for(String pt : poolTeam) {
    if(pt.length() > 0 && pt.charAt(0) != '#') {
      String p_t[] = pt.split("=");
      poolToTeam.set(p_t[0], p_t[1]);
    }
  }
}


public void savePoolToTeam() {
  String[] output = new String[poolToTeam.size()];
  int i = 0;
  for (String pool : poolToTeam.keys()) {
    output[i] = pool + "=" + poolToTeam.get(pool);
    i++;
  }
  saveStrings(dataPath("PoolToTeam.txt"), output);
}


public String removeHTML(String input) {
  String output = "";
  if(input.indexOf("<html>") >= 0) {
    output = input.substring(input.lastIndexOf(">")+1);
  }
  else output = input;
  return output;
}

public boolean isSameDay(Calendar cal1, Calendar cal2) {
    if (cal1 == null || cal2 == null)
        return false;
    return (cal1.get(Calendar.ERA) == cal2.get(Calendar.ERA)
            && cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR) 
            && cal1.get(Calendar.DAY_OF_YEAR) == cal2.get(Calendar.DAY_OF_YEAR));
}

// This function returns all the files in a directory as an array of Strings  
public String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return sort(names);
  } else {
    // If it's not a directory
    return null;
  }
}
