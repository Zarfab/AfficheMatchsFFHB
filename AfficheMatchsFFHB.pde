import uibooster.*;
import uibooster.model.*;

UiBooster booster;

MatchTableModel matchTableModel;
SettingsFrame settingsFrame;

Mode mode = Mode.TO_BE_PLAYED;

int week, year;
StringDict poolToTeam;
String csvFilePath, csvFileFolder;


void setup() {
  
  size(720, 720);
  imageMode(CENTER);
  
  booster = new UiBooster(UiBoosterOptions.Theme.SWING);
  
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
    poster.resize(width, int(width*imageAspectRatio));
  }
  else {
    poster.resize(int(height*imageAspectRatio), height);
  }
  image(poster, width/2, height/2);  
}
