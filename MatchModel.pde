import java.text.SimpleDateFormat;
import java.util.*;

public class MatchModel implements Comparable {
  public boolean atHome = false;
  public boolean toBeDisplayed = false;
  public String numPoule = "";
  public String compet = "";
  public String homeTeam = "";
  public int homeScore = 0;
  public String awayTeam = "";
  public int awayScore = 0;
  private Calendar cal;
  public String dateStr = "";
  public String hourStr = "";
  public String hallName = "";
  public String street = "";
  public String city = "";
  
  public MatchModel(String url) {
    cal = Calendar.getInstance();
    toBeDisplayed = false;

    int urlIndex = url.indexOf("https://");
    if(urlIndex >=0) {
        String cleanUrl = url.substring(urlIndex);
        String teamName = "<html><font color=orange>";
        // try to find team name from parsing URL
        String[] splitUrl = cleanUrl.split("/");
        int compIndex = 0;
        for(int i = 0; i < splitUrl.length; i++) {
          String urlPart = splitUrl[i];
          if(urlPart.indexOf("departemental") >= 0 ||
            urlPart.indexOf("regional") >= 0 ||
            urlPart.indexOf("national") >= 0 ||
            urlPart.indexOf("coupe-de-france") >= 0 ) {
            compIndex = i+1;
            break;
          }
        }
        
        String s = splitUrl[compIndex];
         if(s.indexOf("moins-de-11") >= 0 || s.indexOf("11-ans") >= 0 || s.indexOf("u11") >= 0) teamName += "U11";
         else if(s.indexOf("moins-de-13") >= 0 || s.indexOf("13-ans") >= 0 || s.indexOf("u13") >= 0) teamName += "U13";
         else if(s.indexOf("moins-de-15") >= 0 || s.indexOf("15-ans") >= 0 || s.indexOf("u15") >= 0) teamName += "U15";
         else if(s.indexOf("moins-de-18") >= 0 || s.indexOf("18-ans") >= 0 || s.indexOf("u18") >= 0) teamName += "U18";
         else teamName += "SENIORS";
         
         if(s.indexOf("fem") >= 0) teamName += " F";
         else if(s.indexOf("mas") >= 0) teamName += " M";
         else if(s.indexOf("mixte") >= 0) teamName += " MIXTE";
         
         if(s.indexOf("coupe") >= 0) teamName += " (Coupe)";

        println("Load data from URL : " + cleanUrl + ", detected team : " + removeHTML(teamName));
        loadFromURL(cleanUrl, teamName);
    }
    else {
      System.err.println("Can't load from " + url);
      cal.set(Calendar.YEAR, 2020);
      cal.set(Calendar.MONTH, 1);        
      cal.set(Calendar.DAY_OF_MONTH, 1);
      cal.set(Calendar.HOUR, 0);
      cal.set(Calendar.MINUTE, 0);
    }
  }
  
  private void loadFromURL(String url, String teamName) {
    String[] html = loadStrings(url);
    
    // extract data from HTML content
    String clubRec = "", clubVis = "";
    String dateInHtml = "";

    for(String line : html) {
      if(line.indexOf("competitions---rematch") > 0) {
        int dateIndex = line.indexOf("&quot;date&quot;:&quot;");
        if(dateIndex > 0) {
          dateInHtml = line.substring(dateIndex+23, dateIndex+42);
          //println("Date : " + dateInHtml);
        }
        int teamIndex = line.indexOf("&quot;equipe1&quot;:{&quot;libelle&quot;:&quot;");
        if(teamIndex > 0) {
          clubRec = line.substring(teamIndex+47, line.indexOf("&quot;", teamIndex+47));
        }
        teamIndex = line.indexOf("&quot;equipe2&quot;:{&quot;libelle&quot;:&quot;");
        if(teamIndex > 0) {
          clubVis = line.substring(teamIndex+47, line.indexOf("&quot;", teamIndex+47));
        }
      }
      if(line.indexOf("name='score'") >= 0) {
          int scoreIndex = line.indexOf("&quot;score&quot;:&quot;");
          if(scoreIndex >= 0) {
            String scoreStr = line.substring(scoreIndex+24, line.indexOf("&quot;", scoreIndex + 25));
            homeScore = int(scoreStr);
        }
        scoreIndex = line.indexOf("&quot;score&quot;:&quot;", scoreIndex + 25);
          if(scoreIndex >= 0) {
            String scoreStr = line.substring(scoreIndex+24, line.indexOf("&quot;", scoreIndex + 25));
            awayScore = int(scoreStr);
        }
      }
      if(line.indexOf("competitions---rencontre-salle") > 0) {
        int addressIndex = line.indexOf("&quot;libelle&quot;:&quot;");
        if(addressIndex > 0) {
          hallName = capitalize(line.substring(addressIndex+26, line.indexOf("&quot;", addressIndex+26)), true);
        }
        addressIndex = line.indexOf("&quot;rue&quot;:&quot;");
        if(addressIndex > 0) {
          street = capitalize(line.substring(addressIndex+22, line.indexOf("&quot;", addressIndex+22)), true);
        }
        addressIndex = line.indexOf("&quot;ville&quot;:&quot;");
        if(addressIndex > 0) {
          city = capitalize(line.substring(addressIndex+24, line.indexOf("&quot;", addressIndex+24)), true);
        }
      }
    }
    
    // refine data for presentation
    atHome = isHomeClubName(clubRec.toLowerCase()) && !shouldIgnore(clubRec.toLowerCase());
    homeTeam = atHome? teamName : clubRec;
    awayTeam = atHome? clubVis : teamName;
    
    dateStr = "-";
    hourStr = "-";
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    try {
      cal.setTime(sdf.parse(dateInHtml));
      if(teamName.indexOf("SENIORS") >=0) {
        cal.set(Calendar.SECOND, 1);
      }
      sdf = new SimpleDateFormat("EEEE d MMMM");
      dateStr = capitalize(sdf.format(cal.getTime()), false);
      sdf = new SimpleDateFormat("H'h'mm");
      hourStr = sdf.format(cal.getTime());
      int urlWeek = cal.get(Calendar.WEEK_OF_YEAR);
      if(urlWeek != week && week > 0) {
        System.err.println("Warning in " + url + " : week (" + urlWeek + ") do not seem to correspond to csv file content (" + week + ")");
        //throw(new IllegalArgumentException());
      }
    } catch(Exception e) {
      System.err.println(e);
      println(this);
    }
    toBeDisplayed = true;
  }
  
  
  public MatchModel(TableRow line) {
    if(line.getString("semaine").charAt(0) != '2') {
      System.err.println("line commented, will be ignored:");
      println(line.getString("competition"));
      cal = Calendar.getInstance();
      cal.set(Calendar.YEAR, 2000);
      return;
    }
    numPoule = line.getString("num poule");
    compet = line.getString("competition");
    String teamName = poolToTeam.get(numPoule);
    if(teamName == null) {
      System.err.println("WARNING : Unknown pool '" + numPoule + "' : " + line.getString("competition")
                        + " - " + line.getString("club rec") + " / " + line.getString("club vis"));
      teamName = "<html><font color=red>"+numPoule;
    }
    String clubRec = line.getString("club rec");
    String clubVis = line.getString("club vis");
    atHome = isHomeClubName(clubRec.toLowerCase()) && !shouldIgnore(clubRec.toLowerCase());
    if(atHome) {
      awayTeam = clubVis; 
      if(removeHTML(teamName).isEmpty()) {
        homeTeam = teamName + clubRec;
      }
      else {
        homeTeam = teamName;
      }
    }
    else {
      homeTeam = clubRec;
      if(removeHTML(teamName).isEmpty()) {
        awayTeam = teamName + clubVis;
      }
      else {
        awayTeam = teamName;
      }
    }
    
    try {
      homeScore = line.getInt("fdme rec");
      if(homeScore == 0) homeScore = line.getInt("sc rec");
      awayScore = line.getInt("fdme vis");
      if(awayScore == 0) awayScore = line.getInt("sc vis");
    }
    catch(Exception e) {
      //println(e);
    }

    try {
      city = capitalize(line.getString("Ville"), true);
      street = capitalize(line.getString("adresse salle"), true);
      hallName = capitalize(line.getString("nom salle"), true);
    }
    catch(Exception e) {
      //println(e);
    }
    
    dateStr = "-";
    hourStr = "-";
    cal = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    try {
      cal.setTime(sdf.parse(line.getString("le") + " " + line.getString("horaire")));
      if(teamName.indexOf("SENIORS") >=0) {
        cal.set(Calendar.SECOND, 1);
      }
      if(cal.get(Calendar.DAY_OF_MONTH) > 1) {
        sdf = new SimpleDateFormat("EEEE d MMMM");
        dateStr = capitalize(sdf.format(cal.getTime()), false);
      }
      else {
        sdf = new SimpleDateFormat("EEEE d");
        dateStr = capitalize(sdf.format(cal.getTime()), false);
        dateStr += "er ";
        sdf = new SimpleDateFormat("MMMM");
        dateStr += sdf.format(cal.getTime());
      }
      sdf = new SimpleDateFormat("H'h'mm");
      hourStr = sdf.format(cal.getTime());
    } catch(Exception e) {
      System.err.println(e);
      println(this);
    }
    toBeDisplayed = true;
    /*
    println(dateStr);
    println(homeTeam + " / " + awayTeam + "\t(" + compet + ")\t" + hourStr);
    println("Salle " + hallName + ", " + city);*/
  }  
  
  public Calendar calendar() {
    return cal;
  }
  
  public void setHomeTeam(String team) {
    if(numPoule.length() > 0 && atHome) {
      poolToTeam.set(numPoule, team);
      savePoolToTeam();
    }
    homeTeam = team;
  }
  
  public void setAwayTeam(String team) {
    if(numPoule.length() > 0 && !atHome) {
      poolToTeam.set(numPoule, team);
      savePoolToTeam();
    }
    awayTeam = team;
  }
  
  public void setDateString(String dStr) {
    // parse input and update calendar
    SimpleDateFormat sdf;
    String toParse = dStr + " " + year;
    if(hourStr != "") toParse += " " + hourStr;
    else toParse += " 0h00";
    try {
      sdf = new SimpleDateFormat("EEEE d MMMM yyyy H'h'mm");
      cal.setTime(sdf.parse(toParse));
      //sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
      //println(sdf.format(cal.getTime()));
      dateStr = dStr;
    }
    catch(Exception e) {
      System.err.println(e);
    }
  }
  
  
  public void setHourString(String hStr) {
    // parse input and update calendar
    SimpleDateFormat sdf;
    String toParse = "";
    if(dateStr != "") toParse += dateStr + " " + year;
    else toParse = "Mercredi 1 janvier 2020";
    toParse += " " + hStr;
    try {
      sdf = new SimpleDateFormat("EEEE d MMMM yyyy H'h'mm");
      cal.setTime(sdf.parse(toParse));
      //sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
      //println(sdf.format(cal.getTime()));
      hourStr = hStr;
    }
    catch(Exception e) {
      System.err.println(e);
    }
  }
  
  public void addRowToTable(Table table) {
    TableRow row = table.addRow();
    row.setString("semaine", year + "-" + nf(week, 2));
    row.setString("num poule", numPoule);
    row.setString("competition", compet);
    row.setString("le", getDateString());
    row.setString("horaire", getTimeString());  
    row.setString("club rec", getHomeTeamForCsv());
    row.setString("club vis", getAwayTeamForCsv());
    row.setString("nom salle", hallName);
    row.setString("adresse salle", street);
    row.setString("Ville", city);
    row.setInt("fdme rec", homeScore);
    row.setInt("fdme vis", awayScore);
  }
  
  public String getDateString() {
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    return  sdf.format(cal.getTime());
  }
  
  public String getTimeString() {
    SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
    return  sdf.format(cal.getTime());
  }
  
  public String getHomeTeamForCsv() {
    if(!atHome) return homeTeam;
    else return clubNames.get(0) + " " + removeHTML(homeTeam);
  }
  
  public String getAwayTeamForCsv() {
    if(atHome) return awayTeam;
    else return clubNames.get(0) + " " + removeHTML(awayTeam);
  }
  
  
  @Override
  public int compareTo(Object other) {
    MatchModel otherMatchModel = (MatchModel)(other);
    int calComp = cal.compareTo(otherMatchModel.cal);
    return calComp;
  }
  
  
  @Override
  public String toString() {
    SimpleDateFormat sdf = new SimpleDateFormat("EEEE d MMMM yyyy");
    String matchStr = removeHTML(homeTeam) + " | " + nfs(homeScore, 2) + " | " 
      + nfs(awayScore, 2) + " | " + removeHTML(awayTeam) + "    " + hourStr + "\n"
      + "le " + sdf.format(cal.getTime()) + " @  " + hallName + ", " + city;
    return matchStr;
  }
}
