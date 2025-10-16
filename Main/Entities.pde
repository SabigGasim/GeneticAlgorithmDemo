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
    Fill();

    noStroke();
    float rectX = this.Position.x;
    float rectY = this.Position.y;
    float rectW = this.Width;
    float rectH = this.Height;

    if (this.BorderColor != this.Color) {
      float strokeWeight = 2.0;
      stroke(this.BorderColor);
      strokeWeight(strokeWeight);

      float halfWeight = strokeWeight / 2.0;
      rectX = this.Position.x + halfWeight;
      rectY = this.Position.y + halfWeight;
      rectW = this.Width - strokeWeight;
      rectH = this.Height - strokeWeight;
    }

    rect(rectX, rectY, rectW, rectH);
  }
  
  protected void Fill()
  {
    fill(this.Color);
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
  public Boolean IsParent = false;
  public float Fitness = 0.0;
  public int CurrentStep = 0;
  public final color ParentColor = color(10, 194, 34);

  public Player(float x, float y, int wid, int hei, color colour, color borderColour)
  {
    super(x, y, wid, hei, colour, borderColour);
    InitSteps();
  }
  
  public float GetFitness(){
    return this.Fitness;
  }
  
  @Override
  protected void Fill(){
    fill(this.IsParent ? this.ParentColor : this.Color);
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
    this.Velocity = new PVector(0,0);
    this.Acceleration = new PVector(0,0);
    this.Position = _startingPoint.copy();
  }

  public void InheritStepsFrom(Player player)
  {
    if (player == this) {
      return;
    }

    for (int i = 0; i < player.Steps.length; i++) {
      this.Steps[i] = player.Steps[i].copy();
    }
  }
}
