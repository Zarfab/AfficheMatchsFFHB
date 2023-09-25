ArrayList<PFont> fonts;

public enum FontUse {
  TITLE,
  SUBTITLE,
  TEAM_NAME,
  SCORE,
  PLACE,
  TIME
};

public void loadFonts() {
  fonts = new ArrayList<PFont>();
  fonts.add(createFont(dataPath("fonts/arlrdbd.ttf"), 24)); // Arial
  String[] fontFileNames = listFileNames(dataPath("fonts"));
  for(String f : fontFileNames) {
    if(f.indexOf("arlrdbd") < 0)
      fonts.add(createFont(dataPath("fonts") + "/" + f, 24));
  }
}


public PFont getFont(FontUse use) {
  switch (use) {
    case TITLE :
    case SUBTITLE :
    case TEAM_NAME :
      if(fonts.size() > 1) return fonts.get(1);
      break;
    case SCORE :
      if(fonts.size() > 2) return fonts.get(2);
      break;
    case PLACE :
    case TIME :
      if(fonts.size() > 3) return fonts.get(3);
      break;
    default : break;
    
  }
  return fonts.get(0);
}


public PImage getPoster() {
  int modeInt = (mode == Mode.TO_BE_PLAYED)? TO_BE_PLAYED : RESULTS;
  
  // sort matchs 
  ArrayList<MatchModel> homeMatchs = new ArrayList<MatchModel>();
  ArrayList<MatchModel> awayMatchs = new ArrayList<MatchModel>();
  int i = 0;
  MatchModel m;
  while((m = matchTableModel.getMatch(i)) != null) {
    if(m.toBeDisplayed) {
      if(m.atHome)
        homeMatchs.add(m);
      else
        awayMatchs.add(m);
    }
    i++;
  }
  // sort by dates and hour
  java.util.Collections.sort(homeMatchs);
  java.util.Collections.sort(awayMatchs);
  
  int logoSize = modeSet[modeInt].renderW / 8;
  if(logo.width > logo.height) 
    logo.resize(logoSize, 0);
  else
    logo.resize(0, logoSize);
  
  // create PGraphics with dimensions from Settings
  PGraphics pg = createGraphics(modeSet[modeInt].renderW, modeSet[modeInt].renderH);
  pg.beginDraw();
  
  PImage bg = modeSet[modeInt].bg;
  if(bg != null)
    pg.background(bg);
  else
    pg.background(colors[modeInt]);
    
  pg.imageMode(CENTER);
  pg.image(logo, pg.width/2, pg.height - (logo.height * 0.75));
  
  int fontBaseSize = modeSet[modeInt].fontBaseSize;
  pg.fill(colors[modeInt+1]);
  pg.textAlign(CENTER);
  pg.textFont(getFont(FontUse.TITLE));
  pg.textSize(fontBaseSize);
  pg.text("MATCHS DU WEEKEND\n" + getWeekendString(), pg.width/2, pg.height * 0.1);
  pg.textFont(getFont(FontUse.SUBTITLE));
  pg.textSize(fontBaseSize*0.8);
  pg.text("DOMICILE", pg.width * 0.25, pg.height * 0.3);
  pg.text("EXTÉRIEUR", pg.width * 0.75, pg.height * 0.3);
  
  pg.endDraw();
  return pg.get();
}


public PImage getMatchToBePlayedImage(MatchModel match, int w, int h) {
  PGraphics pg = createGraphics(w, h);
  pg.beginDraw();
  pg.background(colors[1]);
  
  pg.endDraw();
  return pg.get();
}


public PImage getMatchResultImage(MatchModel match, int w, int h) {
  PGraphics pg = createGraphics(w, h);
  pg.beginDraw();
  pg.background(colors[2]);
  
  pg.endDraw();
  return pg.get();
}


public String getWeekendString() {
  SimpleDateFormat sdf = new SimpleDateFormat("dd");
  Calendar cal = Calendar.getInstance();
  cal.set(Calendar.YEAR, year);
  cal.set(Calendar.WEEK_OF_YEAR, week);        
  cal.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY);
  String weekendString = sdf.format(cal.getTime()) + "/";
  cal.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
  if(cal.get(Calendar.DAY_OF_MONTH) == 1) {
    weekendString += (cal.get(Calendar.MONTH)) + " - ";
    sdf = new SimpleDateFormat("dd/LL yyyy");
  }
  else {
    sdf = new SimpleDateFormat("dd LLLL yyyy");
  }
  weekendString += sdf.format(cal.getTime());
  return weekendString;
}
