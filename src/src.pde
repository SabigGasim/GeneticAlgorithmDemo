
void setup(){
  size(900, 500);
  
  _borders = new Border[]{
    new Border(0, 0, width, 20, color(255,0,0), color(255,0,0)),
    new Border(width - 20, 20, height-40, 20, color(255,0,0), color(255,0,0)),
    new Border(0, height-20, width-20, 20, color(255,0,0), color(255,0,0)),
    new Border(0, 20, 20, height-40, color(255,0,0), color(255,0,0)),
  };
}

Border[] _borders;

void draw(){
  background(255, 255, 255);
  
  for(var border : _borders){
    border.Draw();
  }
}


abstract class Box{
  public Point2D Position;
  public int Width;
  public int Height;
  public color Color;
  public color BorderColor;
  
  public Box(int x, int y, int wid, int hei, color colour, color borderColour){
    this.Position = new Point2D(x, y);
    this.Width = wid;
    this.Height = hei;
    this.Color = colour;
    this.BorderColor = borderColour;
  }
  
  public Boolean IntersectsWith(Box box){
    return this.Position.X < box.Position.X + box.Width &&
      this.Position.X + this.Width > box.Position.X && 
      this.Position.Y < box.Position.Y + box.Height && 
      this.Position.Y + this.Height > box.Position.Y;
  }
  
  public void Draw(){
    fill(this.Color);

    noStroke();
    float rectX = this.Position.X;
    float rectY = this.Position.Y;
    float rectW = this.Width;
    float rectH = this.Height;
  
    if (this.BorderColor != this.Color) {
      float strokeWeight = 2.0;
      stroke(this.BorderColor);
      strokeWeight(strokeWeight);
    
      float halfWeight = strokeWeight / 2.0;
      rectX = this.Position.X + halfWeight;
      rectY = this.Position.Y + halfWeight;
      rectW = this.Width - strokeWeight;
      rectH = this.Height - strokeWeight;
    }

    rect(rectX, rectY, rectW, rectH);
  }
}

public class Border extends Box{
  
  public Border(int x, int y, int wid, int hei, color colour, color borderColour){
    super(x, y, wid, hei, colour, borderColour);
  }
}

public class Player extends Box{
  
  public Player(int x, int y, int wid, int hei, color colour, color borderColour){
    super(x, y, wid, hei, colour, borderColour);
  }
  
  public void MovePlayer(int xChange, int yChange){
    this.Position.X += xChange;
    this.Position.Y += yChange;
  }
}

public class Point2D {
  public int X, Y;
  
  public Point2D(int x, int y){
    this.X = x;
    this.Y = y;
  }
}
