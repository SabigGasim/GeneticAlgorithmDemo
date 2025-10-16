public abstract class Box {
  public PVector Position;
  public int Width;
  public int Height;
  public color Color;
  public color BorderColor;

  public Box(float x, float y, int wid, int hei, color colour, color borderColour) {
    this.Position = new PVector(x, y);
    this.Width = wid;
    this.Height = hei;
    this.Color = colour;
    this.BorderColor = borderColour;
  }

  public Boolean IntersectsWith(Box box) {
    return this.Position.x < box.Position.x + box.Width &&
      this.Position.x + this.Width > box.Position.x &&
      this.Position.y < box.Position.y + box.Height &&
      this.Position.y + this.Height > box.Position.y;
  }

  public void Draw() {
    color c = this.Color;
    color borderC = this.BorderColor;
    for(var player : _mostFitPlayers){
      if(this == player){
         c = color(0,255,75);
         borderC = c;
         break;
      }
    }
    fill(c);

    noStroke();
    float rectX = this.Position.x;
    float rectY = this.Position.y;
    float rectW = this.Width;
    float rectH = this.Height;

    if (borderC != c) {
      float strokeWeight = 2.0;
      stroke(borderC);
      strokeWeight(strokeWeight);

      float halfWeight = strokeWeight / 2.0;
      rectX = this.Position.x + halfWeight;
      rectY = this.Position.y + halfWeight;
      rectW = this.Width - strokeWeight;
      rectH = this.Height - strokeWeight;
    }

    rect(rectX, rectY, rectW, rectH);
  }
}

public class Border extends Box {

  public Border(int x, int y, int wid, int hei, color colour, color borderColour) {
    super(x, y, wid, hei, colour, borderColour);
  }
}

public class Player extends Box {
  public PVector[] Steps = new PVector[NUMBER_OF_STEPS];
  public PVector Velocity = new PVector(0,0);
  public PVector Acceleration = new PVector(0,0);
  public Boolean IsAlive = true;
  public Boolean HasReachedGoal = false;
  public float Fitness = 0.0;
  public int CurrentStep = 0;

  public Player(float x, float y, int wid, int hei, color colour, color borderColour) {
    super(x, y, wid, hei, colour, borderColour);
    InitSteps();
  }

  public void TakeNextStep() {
    if (this.CurrentStep >= NUMBER_OF_STEPS)
    {
      return;
    }

    Boolean moved = this.Move(this.Steps[this.CurrentStep]);
    this.CurrentStep += moved ? 1 : 0;
  }

  public Boolean Move(PVector acc)
  {
    if (!this.IsAlive || this.HasReachedGoal)
    {
      return false;
    }

    Acceleration = acc;
    Velocity.add(Acceleration);
    Velocity.limit(3.5);
    Position.add(Velocity);

    if (this.IntersectsWith(_goal))
    {
      this.HasReachedGoal = true;
      GOAL_REACHED = true;
      SOLUTION_FOUND = true;
      return true;
    }

    for (var border : _borders)
    {
      if (this.IntersectsWith(border))
      {
        this.IsAlive = false;
        break;
      }
    }

    return true;
  }

  public void InitSteps() {
    for (int i = 0; i < NUMBER_OF_STEPS; i++) {
      this.Steps[i] = PVector.fromAngle(random(2*PI));
    }
  }

  public void Reset() {
    this.CurrentStep = 0;
    this.IsAlive = true;
    this.HasReachedGoal = false;
    this.Position = _startingPoint.copy();
  }

  public void InheritStepsFrom(Player player)
  {
    if (player == this) {
      return;
    }

    for (int i = 0; i < player.Steps.length; i++) {
      if (player.CurrentStep < i){
        this.Steps[i] = player.Steps[i].copy();
        continue;
      }
      
      this.Steps[i] = PVector.fromAngle(random(2*PI));
    }
  }
}
