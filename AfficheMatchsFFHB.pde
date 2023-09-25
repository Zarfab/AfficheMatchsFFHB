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
  
  size(1000, 800);
  textSize(16);
  
  booster = new UiBooster(UiBoosterOptions.Theme.SWING);
  
  loadSettings();
  loadPoolToTeam();

  matchTableModel = new MatchTableModel();
  settingsFrame = new SettingsFrame(matchTableModel);
  settingsFrame.showMatchTable();
}


void draw() {
  if(mode == Mode.TO_BE_PLAYED) {
    background(0);
    fill(255);
  }
  else {
    background(255);
    fill(0);
  }

  int i = 0;
  MatchModel m;
  while((m = matchTableModel.getMatch(i)) != null) {
    text(m.toString(), 20, 20 + i * 60);
    i++;
  }
  
}
