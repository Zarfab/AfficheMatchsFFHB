import uibooster.*;
import uibooster.model.*;

UiBooster booster;

MatchTableModel matchTableModel;
SettingsFrame settingsFrame;

Mode mode = Mode.TO_BE_PLAYED;

int week, year;
StringDict poolToTeam;
String csvFilePath, csvFileFolder;

PFont potato, arial, impact;


void setup() {
  
  size(720, 720);
  imageMode(CENTER);
  
  booster = new UiBooster(UiBoosterOptions.Theme.SWING);
  
  potato = createFont("fonts/Potato_sans-Black.otf", 24);
  arial = createFont("fonts/arlrdbd.ttf", 24);
  impact = createFont("Impact", 24);

  
  loadSettings();
  loadPoolToTeam();

  matchTableModel = new MatchTableModel();
  settingsFrame = new SettingsFrame(matchTableModel);
  settingsFrame.showMatchTable();
}


void draw() {
  background(0);
  PImage poster = getPoster();
  // resize to fit inside display window and keep original aspect ratio
  float imageAspectRatio = float(poster.width) / poster.height;
  float displayAspectRatio = float(width)/height;
  if(imageAspectRatio > displayAspectRatio) {
    poster.resize(width, 0);
  }
  else {
    poster.resize(0, height);
  }
  image(poster, width/2, height/2);  
}
