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
  public PVector[] Steps = new PVector[Game.NUMBER_OF_STEPS];
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
    if(this.HasReachedGoal)
    { //<>//
      
    }
    
    if (this.CurrentStep >= Game.NUMBER_OF_STEPS)
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
    Velocity.limit(4);
    Position.add(Velocity);

    return true;
  }

  public void InitSteps() {
    for (int i = 0; i < Game.NUMBER_OF_STEPS; i++) {
      this.Steps[i] = PVector.fromAngle(random(2*PI));
    }
  }

  public void Reset() {
    this.CurrentStep = 0;
    this.IsAlive = true;
    this.HasReachedGoal = false;
    this.Velocity = new PVector(0,0);
    this.Acceleration = new PVector(0,0);
    this.Position = _Game.StartingPoint.copy();
  }

  public void InheritStepsFrom(Player[] parents) {
    float totalFitness = 0;
    for (Player parent : parents) {
      totalFitness += parent.Fitness;
    }
    
    for (int i = 0; i < Game.NUMBER_OF_STEPS; i++) {
      float randomPick = random(totalFitness);
      float runningSum = 0;
      Player chosenParent = null;
      for (Player parent : parents) {
        runningSum += parent.Fitness;
          
        if (runningSum >= randomPick) {
          chosenParent = parent;
          break;
        }
      }
        
      if (chosenParent == null) {
          chosenParent = parents[0];
      }
        
      this.Steps[i] = chosenParent.Steps[i].copy();
    }
  }
}
