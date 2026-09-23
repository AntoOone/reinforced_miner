class Pos{
  int x, y;
  
  Pos(int x, int y){
    this.x = x;
    this.y = y;
  }
}

class Agent{  
  Grid grid;
  
  Pos startPos;
  Pos pos;
  
  ArrayList<Pos> availablePos;
  float[][] tilesValues;
  float learningRatio; // between 0 and 1
  
  Agent(Grid grid, int x, int y, float learningRatio){
    this.grid = grid;
    startPos = new Pos(x, y);
    pos = new Pos(x, y);
    this.learningRatio = learningRatio;
    
    availablePos = new ArrayList<Pos>();
    tilesValues = new float[grid.size][];
    for (int i = 0; i < grid.size; i++){
      tilesValues[i] = new float[grid.size];
      for (int j = 0; j < grid.size; j++){
        tilesValues[i][j] = 0;
      }
    }
  }
  
  void setAccessiblePos(){
    availablePos.clear();
    if (pos.y+1 < grid.size && grid.tiles[pos.x][pos.y+1] != TileType.Wall){
      availablePos.add(new Pos(pos.x, pos.y+1));
    }
    if (pos.x+1 < grid.size && grid.tiles[pos.x+1][pos.y] != TileType.Wall){
      availablePos.add(new Pos(pos.x+1, pos.y));
    }
    if (pos.y > 0 && grid.tiles[pos.x][pos.y-1] != TileType.Wall){
      availablePos.add(new Pos(pos.x, pos.y-1));
    }
    if (pos.x > 0 && grid.tiles[pos.x-1][pos.y] != TileType.Wall){
      availablePos.add(new Pos(pos.x-1, pos.y));
    }
  }
  
  void resetPos(){
    pos.x = startPos.x;
    pos.y = startPos.y;
  }
  
  void move(){
    boolean willReset = false;
    
    setAccessiblePos();
    int randI = (int)random(0, availablePos.size());
    int bestX = availablePos.get(randI).x;
    int bestY = availablePos.get(randI).y;
    float bestTileValue = 0;
    
    shuffleList(availablePos);
    
    for(Pos p : availablePos){
      float value = tilesValues[p.x][p.y];
      if (value > bestTileValue){
        bestX = p.x;
        bestY = p.y;
        bestTileValue = value;
      }
    }
    
    float realValue = grid.getTileValue(bestX, bestY);
    if (realValue > 0){
      willReset = true;
      bestTileValue = realValue;
      tilesValues[bestX][bestY] = realValue;
    }
    
    tilesValues[pos.x][pos.y] = learningRatio * bestTileValue + (1-learningRatio) * tilesValues[pos.x][pos.y];
    pos.x = bestX;
    pos.y = bestY;
    
    if (willReset){
      resetPos();
    }
  }
}

void shuffleList(ArrayList<Pos> list){
  ArrayList<Pos> newList = (ArrayList<Pos>)list.clone();
  while (newList.size() != 0){
    int i = (int)random(0, newList.size());
    list.add(newList.get(i));
    newList.remove(i);
  }
}
