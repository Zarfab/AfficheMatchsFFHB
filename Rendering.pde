public PImage getPoster(MatchTableModel table, Mode mode) {
  // create PGraphics with dimensions from Settings
  PGraphics pg = createGraphics(renderW, renderH);
  
  return pg.get();
}
