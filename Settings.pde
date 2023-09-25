StringList clubNames = new StringList();
StringList ignoreWords = new StringList();
color[] colors;
int nbColors = 0;

PImage logo;

public class ModeSettings {
  public PImage bg;
  public int renderW, renderH;
  public int fontBaseSize;
}

ModeSettings[] modeSet;


public void loadSettings() {
  XML settings = loadXML("settings.xml");
  modeSet = new ModeSettings[2];
  modeSet[0] = new ModeSettings();
  modeSet[1] = new ModeSettings();
  
  XML[] resolutions = settings.getChild("render").getChildren("resolution");
  for(XML resolution : resolutions) {
    int modeInt = resolution.getInt("mode");
    modeSet[modeInt].renderW = resolution.getInt("width");
    modeSet[modeInt].renderH = resolution.getInt("height");
    modeSet[modeInt].fontBaseSize = resolution.getInt("fontBaseSize");
  }
  
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
      modeSet[modeInt].bg = loadImage(bgPath);
      modeSet[modeInt].bg.resize(modeSet[modeInt].renderW, modeSet[modeInt].renderH);
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
