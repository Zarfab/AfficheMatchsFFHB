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
    //return getPosterToBePlayed(homeMatchs, awayMatchs);
    return getPosterToBePlayed(allMatchs);
  }
  else if (modeInt == RESULTS) {
    return getPosterResults(allMatchs);
  }
  else {
    return null;
  }
}

/*
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
*/

public PImage getPosterToBePlayed(ArrayList<MatchModel> allMatchs) {
  int logoSize = modeSet[TO_BE_PLAYED].renderW / 6;
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
  pg.image(logo, pg.width/2, pg.height - (logo.height * 0.75));
  
  int fontBaseSize = modeSet[TO_BE_PLAYED].fontBaseSize;
  // Title and subtitle
  pg.fill(colors[1]);
  pg.textAlign(CENTER);
  pg.textFont(getFont(FontUse.TITLE));
  pg.textSize(fontBaseSize);
  pg.text("MATCH"+ (allMatchs.size() > 1 ? "S" : "") + " DU WEEKEND", pg.width/2, pg.height * 0.10);
  pg.text(getWeekendString(), pg.width/2, pg.height * 0.18);
  pg.textFont(getFont(FontUse.SUBTITLE));
  pg.textSize(fontBaseSize);
  float titleHeight = 0.22 * pg.height;
  float logoHeight = logo.height * 1.5;
  float matchImageProp = 0.8;
  float remainingHeight = pg.height 
            - titleHeight
            - logoHeight;
  int matchW = int(pg.width * 0.82);
  int matchH = min(int((remainingHeight / allMatchs.size()) * matchImageProp), 
                    int((remainingHeight / 4) * matchImageProp));
  int y = int (titleHeight + matchH/2 + matchH*0.2);
  if(allMatchs.size() == 0) {
    pg.text("PAS DE MATCH A AFFICHER", pg.width * 0.5, pg.height * 0.3);
  }
  
  for(MatchModel m : allMatchs) {
    pg.image(getMatchToBePlayedImage(m, matchW, matchH), pg.width/2, y);
    y += matchH / matchImageProp; // * 4/(min(allMatchs.size(), 4));
  }
  pg.endDraw();
  return pg.get();
}


public PImage getPosterResults(ArrayList<MatchModel> allMatchs) {
  int logoSize = modeSet[RESULTS].renderW / 6;
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
  pg.fill(colors[1]);
  pg.textAlign(CENTER);
  pg.textFont(getFont(FontUse.TITLE));
  pg.textSize(fontBaseSize);
  pg.text("RÉSULTAT" + (allMatchs.size() > 1 ? "S" : "") + " DU WEEKEND", pg.width/2, pg.height * 0.1);
  pg.text(getWeekendString(), pg.width/2, pg.height * 0.18);
  if(allMatchs.size() == 0) {
    pg.text("PAS DE MATCH A AFFICHER", pg.width * 0.5, pg.height * 0.3);
  }
  float titleHeight = 0.22 * pg.height;
  float logoHeight = logo.height * 1.5;
  float matchImageProp = 0.7;
  float remainingHeight = pg.height 
            - titleHeight
            - logoHeight;
  int matchW = int(pg.width * 0.92);
  int matchH = min(int((remainingHeight / allMatchs.size()) * matchImageProp), 
                    int((remainingHeight / 6) * matchImageProp));
  int y = int (titleHeight + matchH/2 + matchH*0.2);
  for(MatchModel m : allMatchs) {
    pg.image(getMatchResultImage(m, matchW, matchH), pg.width/2, y);
    y += (matchH / matchImageProp) * 6/(min(allMatchs.size(), 6));
  }
  pg.endDraw();
  return pg.get();
}


/***********************************************/
/************ SINGLE MATCH DRAWING *************/
/***********************************************/
public PImage getMatchToBePlayedImage(MatchModel match, int w, int h) {
  PGraphics pg = createGraphics(w, h);
  float rectPadding = 0;
  float rectTop = 0.5 * h;
  float rectBottom = h;
  float vsTriangle = 0.12 * h;
  pg.beginDraw();
  pg.noStroke();
  if(match.atHome) {
    pg.fill(colors[2]);
    pg.quad(w/2-vsTriangle, rectTop, w-2*vsTriangle, rectTop, w, rectBottom, w/2+vsTriangle, rectBottom);
    pg.fill(colors[1]);
    pg.quad(0, rectTop, w/2-vsTriangle, rectTop, w/2+vsTriangle, rectBottom, 2*vsTriangle, rectBottom);
  }
  else {
    pg.fill(colors[2]);
    pg.quad(0, rectTop, w/2-vsTriangle, rectTop, w/2+vsTriangle, rectBottom, 2*vsTriangle, rectBottom);
    pg.fill(colors[1]);
    pg.quad(w/2-vsTriangle, rectTop, w-2*vsTriangle, rectTop, w, rectBottom, w/2+vsTriangle, rectBottom);
  }
   
  int textSize = int((rectBottom-rectTop) * 0.5); 
  String homeTeam = removeHTML(match.homeTeam);
  String awayTeam = removeHTML(match.awayTeam);
  int widthForTeamNames = int(w/2 - 2*vsTriangle);
  pg.textFont(getFont(FontUse.TEAM_NAME));
  if(match.atHome) pg.fill(colors[0]);
  else pg.fill(colors[1]);
  pg.textSize(fitTextInSpace(pg, homeTeam, textSize, widthForTeamNames, h));
  pg.textAlign(CENTER, CENTER);
  pg.text(homeTeam, w/4+rectPadding, (rectBottom+rectTop) / 2);
  if(match.atHome) pg.fill(colors[1]);
  else pg.fill(colors[0]);
  pg.textSize(fitTextInSpace(pg, awayTeam, textSize, widthForTeamNames, h));
  pg.textAlign(CENTER, CENTER);
  pg.text(awayTeam, 3*w/4-rectPadding, (rectBottom+rectTop) / 2);
  
  pg.fill(colors[1]);
  pg.textFont(getFont(FontUse.TIME));
  String placeAndDateStr = match.dateStr.toUpperCase() + " | " 
                           + match.hourStr + " | "
                           + match.hallName.toUpperCase() + ", "
                           + match.city.toUpperCase();
  int placeAndDateSize = fitTextInSpace(pg, placeAndDateStr, textSize, int(w-4*vsTriangle), int(rectTop));
  pg.textSize(placeAndDateSize);
  pg.textAlign(CENTER);
  pg.text(placeAndDateStr, w/2, rectTop-vsTriangle);
  
  pg.endDraw();
  return pg.get();
}


public PImage getMatchResultImage(MatchModel match, int w, int h) {
  PGraphics pg = createGraphics(w, h);
  float vsTriangle = 0.15 * h;						  
  pg.beginDraw();
  //pg.background(colors[2]);
  pg.noStroke();
  if(match.atHome) {
    pg.fill(colors[3]);
    pg.quad(w/2-vsTriangle, 0, w-2*vsTriangle, 0, w, h, w/2+vsTriangle, h);
    pg.fill(colors[1]);
    pg.quad(0, 0, w/2-vsTriangle, 0, w/2+vsTriangle, h, 2*vsTriangle, h);
  }
  else {
    pg.fill(colors[3]);
    pg.quad(0, 0, w/2-vsTriangle, 0, w/2+vsTriangle, h, 2*vsTriangle, h);
    pg.fill(colors[1]);
    pg.quad(w/2-vsTriangle, 0, w-2*vsTriangle, 0, w, h, w/2+vsTriangle, h);
  }
  
  // display score
  float scoreRectH = h * 0.8;
  float scoreRectW = scoreRectH*1.2;
  pg.stroke(0);
  pg.strokeWeight(4);
  pg.rectMode(CENTER);
  pg.fill(colors[2]);
  pg.rect(w/2-scoreRectW*0.75, h/2, scoreRectW, scoreRectH);
  pg.rect(w/2+scoreRectW*0.75, h/2, scoreRectW, scoreRectH);
  pg.noStroke();
  
  int textSize = int((h) * 0.42);
  pg.textFont(getFont(FontUse.SCORE));
  pg.fill(0);
  pg.textSize(fitTextInSpace(pg, "44", 100, int(scoreRectW*0.8), int(scoreRectH*0.8)));
  pg.textAlign(CENTER, CENTER);
    // home score
  if(match.homeScore >= match.awayScore) pg.fill(colors[1]);
  else pg.fill(colors[4]);
  pg.text(match.homeScore, w/2-scoreRectW*0.75, h/2);
  // away score
  if(match.awayScore >= match.homeScore) pg.fill(colors[1]);
  else pg.fill(colors[4]);
  pg.text(match.awayScore, w/2+scoreRectW*0.75, h/2);
  
  pg.fill(colors[3]);
  pg.textFont(getFont(FontUse.TEAM_NAME));

  
  String homeTeam = removeHTML(match.homeTeam);
  String awayTeam = removeHTML(match.awayTeam);
  int widthForTeamNames = int(w/2 - scoreRectW*1.8);
  if(match.atHome) pg.fill(colors[3]);
  else pg.fill(colors[1]);
  pg.textSize(fitTextInSpace(pg, homeTeam, textSize, widthForTeamNames, int(h*0.8)));
  pg.textAlign(CENTER, CENTER);
  pg.text(homeTeam, w/4-scoreRectW*0.5, h*0.5);
  if(match.atHome) pg.fill(colors[1]);
  else pg.fill(colors[3]);
  pg.textSize(fitTextInSpace(pg, awayTeam, textSize, widthForTeamNames, int(h*0.8)));
  pg.textAlign(CENTER, CENTER);
  pg.text(awayTeam, 3*w/4+scoreRectW*0.5, h*0.5);
  
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


public int fitTextInSpace(PGraphics pg, String text, int sizeInit, int w, int h) {
  int fitSizeW = sizeInit;
  pg.pushStyle();
  pg.textSize(sizeInit);
  while(pg.textWidth(text) > w) {
    fitSizeW--;
    pg.textSize(fitSizeW);
  }
  pg.popStyle();
  int fitSize = min(h, fitSizeW);
  return fitSize;
}
