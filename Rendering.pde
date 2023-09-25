public PImage getPoster() {
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
  
  int logoSize = renderW / 8;
  if(logo.width > logo.height) 
    logo.resize(logoSize, 0);
  else
    logo.resize(0, logoSize);
  
  // create PGraphics with dimensions from Settings
  PGraphics pg = createGraphics(renderW, renderH);
  pg.beginDraw();
  int modeInt = (mode == Mode.TO_BE_PLAYED)? TO_BE_PLAYED : RESULTS;
  PImage bg = bgImgs[modeInt];
  if(bg != null)
    pg.background(bg);
  else
    pg.background(colors[modeInt]);
    
  pg.imageMode(CENTER);
  pg.image(logo, pg.width/2, pg.height - (logo.height * 0.75));
  
  pg.fill(0, 0, 172);
  pg.textAlign(CENTER);
  pg.textFont(potato);
  pg.textSize(80);
  
  float heightForMatchs = pg.height - logo.height * 1.5 - pg.height * 0.1;
  
  pg.endDraw();
  return pg.get();
}
