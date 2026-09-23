enum TileType{
  Empty, Wall, Miner, GoldOre, IronOre, CopperOre, Wagon
}

class Grid{
  TileType selectedTileType;
  boolean tileSelected = false;
  boolean removeTile = false;
  
  int size;
  
  TileType[][] tiles;
  PImage minerImage;
  PImage goldOreImage;
  PImage ironOreImage;
  PImage copperOreImage;
  PImage wagonImage;
  PImage crossImage;
  
  int wallR, wallG, wallB;
  int gridX, gridY;
  int gridWidth;
  int tileSize;

  
  Button minerButton;
  Button goldOreButton;
  Button ironOreButton;
  Button copperOreButton;
  Button wagonButton;
  Button wallButton;
  Button crossButton;
  
  String savePath = "grid_save.json";
  
  ArrayList<Agent> agents;
  
  Grid(int _size, int _x, int _y, int _gridWidth){
    size = _size;
    gridX = _x;
    gridY = _y;
    gridWidth = _gridWidth;
    tileSize = gridWidth / size;
    
    tileSelected = false;
    
    tiles = new TileType[size][];
    for (int i = 0; i < size; i++){
      tiles[i] = new TileType[size];
      for (int j = 0; j < size; j++){
        tiles[i][j] = TileType.Empty;
      }
    }
    
    agents = new ArrayList<Agent>();
    
    String folder = "imports/";
    minerImage = loadImage(folder + "miner.png");
    goldOreImage = loadImage(folder + "gold-ore.png");
    ironOreImage = loadImage(folder + "iron-ore.png");
    copperOreImage = loadImage(folder + "copper-ore.png");
    wagonImage = loadImage(folder + "mining.png");
    crossImage = loadImage(folder + "cross.png");
    
    // Buttons
    int interfaceWidth = 100;
    int buttonSpacing = 20;
    int buttonSize = 50;
    int x = width - interfaceWidth;
    int y = 15;
    minerButton = new Button(x, y, buttonSize);
    y += buttonSpacing + buttonSize;
    goldOreButton = new Button(x, y, buttonSize);
    y += buttonSpacing + buttonSize;
    ironOreButton = new Button(x, y, buttonSize);
    y += buttonSpacing + buttonSize;
    copperOreButton = new Button(x, y, buttonSize);
    y += buttonSpacing + buttonSize;
    wagonButton = new Button(x, y, buttonSize);
    y += buttonSpacing + buttonSize;
    wallButton = new Button(x, y, buttonSize);
    y += buttonSpacing + buttonSize;
    crossButton = new Button(x, y, buttonSize);

    // Walls color
    wallR = 200;
    wallG = 200;
    wallB = 200;
  }
  
  void updateAgents(){
    for (Agent agent : agents){
      agent.move();
    }
  }
  
  void drawAgentTileValues(Agent agent){
    colorMode(RGB, 1.0);
    for (int i = 0; i < size; i++){
      for (int j = 0; j < size; j++){       
        int x = gridX + i * gridWidth / size;
        int y = gridY + j * gridWidth / size;
        float c = 1 - agent.tilesValues[i][j] / 10;
        fill(c, 1, 1);
        rect(x, y, tileSize, tileSize);
        }
      }
    colorMode(RGB, 256);
  }
  
  void draw(){
    stroke(230);
    //strokeWeight(255);
    
    // outlines
    push();
    translate(gridX, gridY);
    
    line(0, 0, gridWidth, 0);
    line(0, gridWidth, gridWidth, gridWidth);
    line(0, 0, gridWidth, 0);
    line(gridWidth, 0, gridWidth, gridWidth);
    
    // main lines
    for (int i = 0; i < size; i++){
      line(i * tileSize, 0, i * tileSize, gridWidth);
      line(0, i * tileSize, gridWidth, i * tileSize);
    }
    
    for (int i = 0; i < size; i++){
      for (int j = 0; j < size; j++){       
        int x = i * gridWidth / size;
        int y = j * gridWidth / size;
        switch(tiles[i][j]){
          case GoldOre:
            image(goldOreImage, x, y, tileSize, tileSize);
            break;
          case IronOre:
            image(ironOreImage, x, y, tileSize, tileSize);
            break;
          case CopperOre:
            image(copperOreImage, x, y, tileSize, tileSize);
            break;
          case Wagon:
            image(wagonImage, x, y, tileSize, tileSize);
            break;
          case Wall:
            fill(wallR, wallG, wallB);
            rect(x, y, tileSize, tileSize);
            break;
          default:
            break;
        }
      }
    }
    
    for (Agent agent : agents){
      image(minerImage, agent.pos.x * gridWidth / size, agent.pos.y * gridWidth / size, tileSize, tileSize);
    }
    
    pop();
  }
  
  void drawButtons(){
    minerButton.drawImage(minerImage);
    goldOreButton.drawImage(goldOreImage);
    ironOreButton.drawImage(ironOreImage);
    copperOreButton.drawImage(copperOreImage);
    wagonButton.drawImage(wagonImage);
    wallButton.drawRect(wallR, wallG, wallB);
    crossButton.drawImage(crossImage);
  }
  
  void drawMouseSelector(){
    
    int sWidth = 15;
    int x = mouseX + 5;
    int y = mouseY + 5;
    
    if (removeTile){
      image(crossImage, x, y, sWidth, sWidth);
      return;
    }
    
    if (!tileSelected) return;

    switch(selectedTileType){
      case Empty:
        break;
      case Wall:
        fill(wallR, wallG, wallB);
        rect(x, y, sWidth, sWidth);
        break;
      case Miner:
        image(minerImage, x, y, sWidth, sWidth);
        break;
      case GoldOre:
        image(goldOreImage, x, y, sWidth, sWidth);
        break;
      case IronOre:
        image(ironOreImage, x, y, sWidth, sWidth);
        break;
      case CopperOre:
        image(copperOreImage, x, y, sWidth, sWidth);
        break;
      case Wagon:
        image(wagonImage, x, y, sWidth, sWidth);
        break;
    }
  }
  
  void saveGrid(){
    JSONArray jsonGrid = new JSONArray();
    for (int i = 0; i < size; i++){
      JSONArray jsonLine = new JSONArray();
      for (int j = 0; j < size; j++){
        JSONObject obj = new JSONObject();
        obj.setInt("value", tiles[i][j].ordinal());
        jsonLine.append(obj); 
      }
      jsonGrid.append(jsonLine);
    }
    
    saveJSONArray(jsonGrid, savePath); //<>//
  }
  
  
  void loadGrid(){
    JSONArray jsonGrid = loadJSONArray(savePath);
    size = jsonGrid.size();
    
    tiles = new TileType[size][];
    for (int i = 0; i < size; i++){
      tiles[i] = new TileType[size];
      JSONArray jsonLine = jsonGrid.getJSONArray(i);
      for (int j = 0; j < size; j++){ //<>//
        JSONObject obj = jsonLine.getJSONObject(j);
        int tileInt = obj.getInt("value");
        switch(tileInt){
          case 0:
            tiles[i][j] = TileType.Empty;
            break;
          case 1:
            tiles[i][j] = TileType.Wall;
            break;
          case 2:
            tiles[i][j] = TileType.Miner;
            break;
          case 3:
            tiles[i][j] = TileType.GoldOre;
            break;
          case 4:
            tiles[i][j] = TileType.IronOre;
            break;
          case 5:
            tiles[i][j] = TileType.CopperOre;
            break;
          case 6:
            tiles[i][j] = TileType.Wagon;
            break;
        }
      }
    }
  }
  
  void checkMouseClick(){
    if (grid.copperOreButton.isOnButton(mouseX, mouseY)){
      selectedTileType = TileType.CopperOre;
      removeTile = false;
      tileSelected = true;
    }
    else if (grid.goldOreButton.isOnButton(mouseX, mouseY)){
      selectedTileType = TileType.GoldOre;
      removeTile = false;
      tileSelected = true;
    }
    else if (grid.ironOreButton.isOnButton(mouseX, mouseY)){
      selectedTileType = TileType.IronOre;
      removeTile = false;
      tileSelected = true;
    }
    else if (grid.minerButton.isOnButton(mouseX, mouseY)){
      selectedTileType = TileType.Miner;
      removeTile = false;
      tileSelected = true;
    }
    else if (grid.wagonButton.isOnButton(mouseX, mouseY)){
      selectedTileType = TileType.Wagon;
      removeTile = false;
      tileSelected = true;
    }
    else if (grid.wallButton.isOnButton(mouseX, mouseY)){
      selectedTileType = TileType.Wall;
      removeTile = false;
      tileSelected = true;
    }
    else if (grid.crossButton.isOnButton(mouseX, mouseY)){
      selectedTileType = TileType.Empty;
      removeTile = true;
      tileSelected = true;
    }
    else if (tileSelected){
      int dx = mouseX - gridX;
      int dy = mouseY - gridY;
      if (0 <= dx && dx <= gridWidth && dy <= gridWidth && 0 <= dy){
        int x = dx / tileSize;
        int y = dy / tileSize;
        tiles[x][y] = selectedTileType;
      }
      else{
        tileSelected = false;
        removeTile = false;
      }
    }
  }
  
  // Agent related
  
  float getTileValue(int x, int y){
    TileType tile = tiles[x][y];
    float value;
    switch(tile){
      case GoldOre:
        value = 15;
        break;
      case IronOre:
        value = 4;
        break;
      case CopperOre:
        value = 1;
        break;
      default:
        value = 0;
        break;
    }
    return value;
  }
}
