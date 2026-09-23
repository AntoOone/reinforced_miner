class Button{
  int x, y, buttonWidth;
  
  Button(int x, int y, int buttonWidth){
    this.x = x;
    this.y = y;
    this.buttonWidth = buttonWidth;
  }
  
  void drawImage(PImage image){
    image(image, x, y, buttonWidth, buttonWidth);
  }
  
  void drawRect(int r, int g, int b){
    fill(r, g, b);
    rect(x, y, buttonWidth, buttonWidth);
  }
  
  boolean isOnButton(int _x, int _y){
    int dx = _x - x;
    int dy = _y - y;
    return 0 <= dx && dx <= buttonWidth && dy <= buttonWidth && 0 <= dy;
  }
}
