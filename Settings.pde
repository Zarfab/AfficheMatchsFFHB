StringList clubNames = new StringList();
StringList ignoreWords = new StringList();
color[] colors;
int nbColors = 0;

int renderW, renderH;


public void loadSettings() {
  XML settings = loadXML("settings.xml");
  XML resolution = settings.getChild("render").getChild("resolution");
  renderW = resolution.getInt("width");
  renderH = resolution.getInt("height");
  
  XML[] nameVariants = settings.getChild("club").getChild("name").getChildren("nameVariant");
  for(XML var : nameVariants) {
    clubNames.append(var.getContent());
  }
  XML[] nameIgnore = settings.getChild("club").getChild("name").getChildren("ignore");
  for(XML ni : nameIgnore) {
    ignoreWords.append(ni.getContent());
  }
  XML[] colorsXml = settings.getChild("club").getChild("colors").getChildren("color");
  nbColors = colorsXml.length;
  colors = new color[nbColors];
  for(int i = 0; i < nbColors; i++) {
    XML c = colorsXml[i];
    colors[i] = color(c.getInt("r"), c.getInt("g"), c.getInt("b"));
  }
}


public boolean isClubName(String str) {
  boolean out = false;
  for(String s : clubNames) {
    if(str.indexOf(s) >= 0) out = true;
  }
  return out;
}


public boolean shouldIgnore(String str) {
  boolean out = false;
  for(String s : ignoreWords) {
    if(str.indexOf(s) >= 0) out = true;
  }
  return out;
}
