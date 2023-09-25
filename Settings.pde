StringList clubNames = new StringList();
StringList ignoreWords = new StringList();
color[] colors;
int nbColors = 0;

PImage logo;
PImage[] bgImgs = new PImage[2];
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
  IntList usedIds = new IntList();
  for(int i = 0; i < nbColors; i++) {
    XML c = colorsXml[i];
    int id = c.getInt("id");
    if(id < 0 && id >= nbColors) {
      println("In 'settings.xml' : Color id not valid : " + id + ", will be ignored");
    }
    else if(usedIds.hasValue(id)) {
      println("In 'settings.xml' : Color id already used : " + id + ", will be ignored");
    }
    else {
      colors[id] = color(c.getInt("r"), c.getInt("g"), c.getInt("b"));
      usedIds.append(id);
    }
  }
  String logoPath = settings.getChild("club").getChild("logo").getContent();
  logo = loadImage(logoPath);
  XML[] backgrounds = settings.getChild("club").getChildren("background");
  for(XML bg : backgrounds) {
    String bgPath = bg.getContent();
    int modeInt = bg.getInt("mode");
    if(bgPath != null && bgPath != "") {
      bgImgs[modeInt] = loadImage(bgPath);
      bgImgs[modeInt].resize(renderW, renderH);
    }
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
