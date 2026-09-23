Grid grid;
Agent agent;

void setup(){
  frameRate(60);
  size(800, 800);
  grid = new Grid(10, 20, 20, min(width, height) - 200);
  
  try{
    grid.loadGrid();
  }
  catch(Exception e) {
    print(e.toString());
  }
  
  agent = new Agent(grid, 3, 6, 0.9);
  grid.agents.add(agent);
}

void draw(){
  background(255);
  grid.drawAgentTileValues(agent);
  grid.draw();
  grid.drawButtons();
  grid.drawMouseSelector();
  
  if (frameCount % 5 == 0){
    grid.updateAgents();
  }
}

void exit(){
  grid.saveGrid();
}

void mouseClicked(){
  grid.checkMouseClick();
}

void makeCustomGrid(Grid grid){
  grid.tiles[5][5] = TileType.Miner;
  grid.tiles[3][7] = TileType.Wall;
  grid.tiles[4][7] = TileType.Wall;
  grid.tiles[5][7] = TileType.Wall;
  grid.tiles[6][7] = TileType.Wall;
  grid.tiles[6][9] = TileType.GoldOre;
}
