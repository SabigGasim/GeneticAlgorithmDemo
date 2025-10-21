int FrameRate = 120;
Game _Game = new Game();

void setup() {
  size(600, 800);
  textAlign(CENTER, CENTER);
  frameRate(FrameRate);
  textSize(40);
  _Game.InitializePopulation();
}

int iterations = 0;

void draw()
{
  if (iterations == 50)
  {
    fill(color(252, 194, 3));
    text("Steps optimization complete!", width/2, height/2);
    return;
  }
  
  background(92, 65, 25);

  if (_Game.HasEnded())
  {
    _Game.CalculateFitness();
    _Game.NaturalSelection();
    _Game.Crossover();
    _Game.MutateBabies();
    _Game.PopulateNewGeneration();
    print("Iterations: " + ++iterations);
  }

  _Game.DrawMap();
  _Game.TakeNextStep();
}
