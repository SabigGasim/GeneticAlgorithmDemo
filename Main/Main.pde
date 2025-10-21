int FrameRate = 120;

void setup() {
  size(600, 800);
  textAlign(CENTER, CENTER);
  frameRate(FrameRate);
  textSize(40);
  _Game.InitializePopulation();
}

Game _Game = new Game();
int iterations = 0;

void draw() {
  background(92, 65, 25);

  if (_Game.HasEnded() && iterations < 50)
  {
    _Game.CalculateFitness();
    _Game.NaturalSelection();
    _Game.Crossover();
    _Game.MutateBabies();
    _Game.PopulateNewGeneration();
    iterations++;
  }

  _Game.DrawMap();
  _Game.TakeNextStep();
}


final float SCROLL_FACTOR = 1.1;

void mouseWheel(MouseEvent event) {
  float scrollCount = event.getCount();
  
  if (scrollCount < 0) {
    FrameRate *= SCROLL_FACTOR; 
  } else if (scrollCount > 0) {
    FrameRate /= SCROLL_FACTOR;
  }
  FrameRate = constrain(FrameRate, 5, 2000);
  println("Frame rate: " + FrameRate);
  frameRate(FrameRate);
}

void mousePressed() {
  if (mouseButton == LEFT) 
  {
    noLoop();
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) 
  {
    loop();
  }
}
