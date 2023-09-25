public PImage getPoster() {
  // sort matchs 
  int i = 0;
  MatchModel m;
  while((m = matchTableModel.getMatch(i)) != null) {
    i++;
  }
  
  // create PGraphics with dimensions from Settings
  PGraphics pg = createGraphics(renderW, renderH);
  pg.beginDraw();
  pg.background(colors[0]);
  
  pg.endDraw();
  return pg.get();
}
