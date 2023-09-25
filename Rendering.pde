public PImage getPoster() {
  // sort matchs 
  ArrayList<MatchModel> homeMatchs = new ArrayList<MatchModel>();
  ArrayList<MatchModel> awayMatchs = new ArrayList<MatchModel>();
  int i = 0;
  MatchModel m;
  while((m = matchTableModel.getMatch(i)) != null) {
    i++;
  }
  
  // create PGraphics with dimensions from Settings
  PGraphics pg = createGraphics(renderW, renderH);
  pg.beginDraw();
  //pg.background();
  
  pg.endDraw();
  return pg.get();
}
