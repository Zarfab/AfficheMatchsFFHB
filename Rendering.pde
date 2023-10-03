ArrayList<PFont> fonts;

/***********************************************/
/************* FONT MANAGEMENT *****************/
/***********************************************/
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
      if(fonts.size() > 1) return fonts.get(1);
      break;
    case TEAM_NAME :
    case PLACE :
    case TIME :
      if(fonts.size() > 2) return fonts.get(2);
      break;
    case SCORE :
      if(fonts.size() > 3) return fonts.get(3);
      break;
    default : break;
    
  }
  return fonts.get(0);
}


/***********************************************/
/************ ALL POSTER DRAWING ***************/
/***********************************************/
public PImage getPoster() {
  int modeInt = (mode == Mode.TO_BE_PLAYED)? TO_BE_PLAYED : RESULTS;
  
  // sort matchs 
  ArrayList<MatchModel> homeMatchs = new ArrayList<MatchModel>();
  ArrayList<MatchModel> awayMatchs = new ArrayList<MatchModel>();
  ArrayList<MatchModel> allMatchs = new ArrayList<MatchModel>();
  int i = 0;
  MatchModel m;
  while((m = matchTableModel.getMatch(i)) != null) {
    if(m.toBeDisplayed) {
      allMatchs.add(m);
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
  java.util.Collections.sort(allMatchs);
  
  if(modeInt == TO_BE_PLAYED) {
    return getPosterToBePlayed(homeMatchs, awayMatchs);
  }
  else if (modeInt == RESULTS) {
    return getPosterResults(allMatchs);
  }
  else {
    return null;
  }
}


public PImage getPosterToBePlayed(ArrayList<MatchModel> homeMatchs, ArrayList<MatchModel> awayMatchs) { 
  int logoSize = modeSet[TO_BE_PLAYED].renderW / 8;
  if(logo.width > logo.height) 
    logo.resize(logoSize, 0);
  else
    logo.resize(0, logoSize);
    
  // create PGraphics with dimensions from Settings
  PGraphics pg = createGraphics(modeSet[TO_BE_PLAYED].renderW, modeSet[TO_BE_PLAYED].renderH);
  pg.beginDraw();
  
  PImage bg = modeSet[TO_BE_PLAYED].bg;
  if(bg != null)
    pg.background(bg);
  else
    pg.background(colors[TO_BE_PLAYED]);
    
  pg.imageMode(CENTER);
  //pg.image(logo, pg.width/2, pg.height - (logo.height * 0.75));
  
  int fontBaseSize = modeSet[TO_BE_PLAYED].fontBaseSize;
  // Title and subtitle
  pg.fill(colors[1]);
  pg.textAlign(CENTER);
  pg.textFont(getFont(FontUse.TITLE));
  pg.textSize(fontBaseSize);
  pg.text("MATCHS DU WEEKEND\n" + getWeekendString(), pg.width/2, pg.height * 0.1);
  pg.textFont(getFont(FontUse.SUBTITLE));
  pg.textSize(fontBaseSize*0.8);
  float titleHeight = 0.22;
  float logoHeight = 0.18;
  float remainingHeight = pg.height 
            - pg.height * titleHeight
            - pg.height * logoHeight;
  int matchW, matchH;
  //int matchH = int((remainingHeight / allMatchs.size()) * 0.8);
  //int y = int (pg.height * 0.2 + matchH/2 + matchH*0.2);
  if(homeMatchs.size() > 0 && awayMatchs.size() == 0) {
    pg.text("DOMICILE", pg.width * 0.5, pg.height * 0.28);
    matchW = int(pg.width * 0.75);
    matchH = int((remainingHeight / homeMatchs.size()) * 0.8);
    int y = int (pg.height * titleHeight + matchH/2 + matchH*0.2);
    for(MatchModel m : homeMatchs) {
      pg.image(getMatchToBePlayedImage(m, matchW, matchH), pg.width/2, y);
      y += matchH / 0.8;
    }
  }
  else if(homeMatchs.size() == 0 && awayMatchs.size() > 0) {
    pg.text("EXTÉRIEUR", pg.width * 0.5, pg.height * 0.28);
    matchW = int(pg.width * 0.75);
    matchH = int((remainingHeight / awayMatchs.size()) * 0.8);
    int y = int (pg.height * titleHeight + matchH/2 + matchH*0.2);
    for(MatchModel m : awayMatchs) {
      pg.image(getMatchToBePlayedImage(m, matchW, matchH), pg.width/2, y);
      y += matchH / 0.8;
    }
  }
  else if(homeMatchs.size() > 0 && awayMatchs.size() > 0) {
    pg.text("DOMICILE", pg.width * 0.25, pg.height * 0.28);
    pg.text("EXTÉRIEUR", pg.width * 0.75, pg.height * 0.28);
    
    matchW = int(pg.width * 0.40);
    matchH = int(remainingHeight / max(homeMatchs.size(), awayMatchs.size()) * 0.8);
    int y;
    int yInc = int(matchH / 0.8);;
    
    if(homeMatchs.size() >= awayMatchs.size()) {
      y = int (pg.height * titleHeight + matchH/2 + matchH*0.2);
    }
    else {
      y = int (pg.height * titleHeight + matchH/2 + matchH*0.2 +  (awayMatchs.size() - homeMatchs.size())/2 * yInc);
    }
    for(MatchModel m : homeMatchs) {
      pg.image(getMatchToBePlayedImage(m, matchW, matchH), pg.width * 0.25, y);
      y += yInc;
    }
    
    if(awayMatchs.size() >= homeMatchs.size()) {
      y = int (pg.height * titleHeight + matchH/2 + matchH*0.2);
    }
    else {
      y = int (pg.height * titleHeight + matchH/2 + matchH*0.2 +  (homeMatchs.size() - awayMatchs.size())*0.5 * yInc);;
    }
    for(MatchModel m : awayMatchs) {
      pg.image(getMatchToBePlayedImage(m, matchW, matchH), pg.width * 0.75, y);
      y += yInc;
    }
  }
  else {
    pg.text("PAS DE MATCH A AFFICHER", pg.width * 0.5, pg.height * 0.28);
  }
  pg.endDraw();
  return pg.get();
}


public PImage getPosterResults(ArrayList<MatchModel> allMatchs) {
  int logoSize = modeSet[RESULTS].renderW / 8;
  if(logo.width > logo.height) 
    logo.resize(logoSize, 0);
  else
    logo.resize(0, logoSize);
    
  // create PGraphics with dimensions from Settings
  PGraphics pg = createGraphics(modeSet[RESULTS].renderW, modeSet[RESULTS].renderH);
  pg.beginDraw();
  
  PImage bg = modeSet[RESULTS].bg;
  if(bg != null)
    pg.background(bg);
  else
    pg.background(colors[RESULTS]);
    
  pg.imageMode(CENTER);
  pg.image(logo, pg.width/2, pg.height - (logo.height * 0.75));
  
  int fontBaseSize = modeSet[RESULTS].fontBaseSize;
  // Title
  pg.fill(colors[RESULTS+1]);
  pg.textAlign(CENTER);
  pg.textFont(getFont(FontUse.TITLE));
  pg.textSize(fontBaseSize);
  pg.text("RÉSULTATS DU WEEKEND\n" + getWeekendString(), pg.width/2, pg.height * 0.1);
  if(allMatchs.size() == 0) {
    pg.text("PAS DE MATCH A AFFICHER", pg.width * 0.5, pg.height * 0.3);
  }
  
  float remainingHeight = pg.height - logo.height * 1.5 - pg.height * 0.2;
  int matchW = int(pg.width * 0.75);
  int matchH = int((remainingHeight / allMatchs.size()) * 0.8);
  int y = int (pg.height * 0.2 + matchH/2 + matchH*0.2);
  for(MatchModel m : allMatchs) {
    pg.image(getMatchResultImage(m, matchW, matchH), pg.width/2, y);
    y += matchH / 0.8;
  }
  pg.endDraw();
  return pg.get();
}


/***********************************************/
/************ SINGLE MATCH DRAWING *************/
/***********************************************/
public PImage getMatchToBePlayedImage(MatchModel match, int w, int h) {
  PGraphics pg = createGraphics(w, h);
  pg.beginDraw();
  pg.background(colors[1]);
  pg.fill(colors[2]);
  pg.textAlign(CENTER);
  pg.text(match.toString(), w/2, h/2);
  pg.endDraw();
  return pg.get();
}


public PImage getMatchResultImage(MatchModel match, int w, int h) {
  PGraphics pg = createGraphics(w, h);
  pg.beginDraw();
  pg.background(colors[2]);
  pg.fill(colors[1]);
  pg.textAlign(CENTER);
  pg.text(match.toString(), w/2, h/2);
  pg.endDraw();
  return pg.get();
}


/***********************************************/
/********* TEXT FORMATING FOR POSTER ***********/
/***********************************************/
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
