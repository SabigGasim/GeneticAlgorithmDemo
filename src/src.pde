
void setup(){
  size(900, 600);
  textAlign(CENTER, CENTER);
  frameRate(120);
  textSize(25);
  
  _borders = new Border[]{
    new Border(0, 0, width, 20, color(150,0,0), color(150,0,0)),                //Top Border
    new Border(0, height-20, width, 20, color(150,0,0), color(150,0,0)),        //Bottom Border
    new Border(width - 20, 20, 20, height-40, color(150,0,0), color(150,0,0)),  //Right Border
    new Border(0, 20, 20, height-40, color(150,0,0), color(150,0,0)),           //Left Border
    
    new Border(688, 230, width - 687, 10, color(150,0,0), color(150,0,0)),
    new Border(570, 20, 10, 376, color(150,0,0), color(150,0,0)),
    new Border(570, 396, 170, 10, color(150,0,0), color(150,0,0)),
    new Border(420, 300, 10, 320, color(150,0,0), color(150,0,0)),
    new Border(380, 160, 190, 10, color(150,0,0), color(150,0,0)),
    new Border(260, 160, 10, height-20, color(150,0,0), color(150,0,0)),
    new Border(140, 390, 10, 190, color(150,0,0), color(150,0,0)),
    new Border(140, 160, 120, 10, color(150,0,0), color(150,0,0)),
    new Border(20, 280, 120, 10, color(150,0,0), color(150,0,0))
  };
  
  _goal = new Border(20, 460, 120, 120, color(50, 255, 50), color(50, 255, 50));
  _players = new Player[NUMBER_OF_PLAYERS];
}

final int NUMBER_OF_STEPS = 1000;
final int NUMBER_OF_PLAYERS = 100;
int currentStep;
Border[] _borders;
Player[] _players;
Border _goal;

void draw(){
  background(255, 255, 255);
  
  DrawMap();
  CheckIntersectionsAndDrawAccordingly();
}

void DrawMap(){
  for(var border : _borders){
    border.Draw();
  }
  
  _goal.Draw();
}

void CheckIntersectionsAndDrawAccordingly()
{
  for(int i = 0; i < NUMBER_OF_PLAYERS; i++)
  {
    if(_players[i].IntersectsWith(_goal))
    {
      text("Win!", width/2, height/2);
      _players[i].Draw();
      break;
    }
    
    for(var border : _borders)
    {
      if(_players[i].IntersectsWith(border))
      {
        _players[i].Draw();
        break;
      }
    }
    
    if(currentStep < NUMBER_OF_STEPS)
    {
      var move = _players[i].Steps[currentStep++];
      _players[i].Move(move.X, move.Y);
    }
    
    _players[i].Draw();
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
  public Point2D[] Steps;
  public Boolean IsAlive = true;
  
  public Player(int x, int y, int wid, int hei, color colour, color borderColour){
    super(x, y, wid, hei, colour, borderColour);
    InitSteps();
  }
  
  public void Move(int xChange, int yChange){
    this.Position.X += xChange;
    this.Position.Y += yChange;
  }
  
  public void MoveTo(int x, int y){
    this.Position.X = x;
    this.Position.Y = y;
  }
  
  public void InitSteps(){
    Steps = new Point2D[NUMBER_OF_STEPS];
    for(int i = 0; i < NUMBER_OF_STEPS; i++){
      Steps[i] = new Point2D((int)random(1, 10), (int)random(1, 10));
    }
  }
}

public class Point2D {
  public int X, Y;
  
  public Point2D(int x, int y){
    this.X = x;
    this.Y = y;
  }
}
