final int NUMBER_OF_STEPS = 1000;
final int NUMBER_OF_PLAYERS = 1000;
final int NUMBER_OF_PARENTS = 6;
final float MUTATION_RATE = 0;
Boolean GOAL_REACHED = false;
Boolean SOLUTION_FOUND = false;
int currentStep;
Border[] _borders;
Player[] _players;
Player[] _mostFitPlayers = new Player[NUMBER_OF_PARENTS];
int[] _mostFitPlayersIndices = new int[NUMBER_OF_PARENTS];
Border _goal;
PVector _startingPoint = new PVector(297, 760);


void setup() {
  size(600, 800);
  textAlign(CENTER, CENTER);
  frameRate(2000);
  textSize(40);
  InitializeBorders();

  InitializePopulation();
}

void mousePressed() {
  if (mouseButton == LEFT) {
    noLoop();
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    loop();
  }
}

void draw() {
  background(92, 65, 25);

  if (GOAL_REACHED || currentStep >= NUMBER_OF_STEPS)
  {
    CalculateFitness();
    NaturalSelection();
    Crossover();
    Mutation();
    PopulateNewGeneration();
    currentStep = 0;
  }

  DrawMap();
  text(Integer.toString(mouseX) + ", " + Integer.toString(mouseY), width/2, height/2);
  CheckIntersectionsAndDrawAccordingly();
}



void InitializeBorders() {
  final int borderSize = 20;
  color c = color(161, 110, 34);
  
  _borders = new Border[]{
    new Border(0, 0, width, borderSize, c, c),             //Top Border
    new Border(0, height-borderSize, width, borderSize, c, c),       //Bottom Border
    new Border(width - borderSize, borderSize, borderSize, height-borderSize*2, c, c), //Right Border
    new Border(0, borderSize, borderSize, height-borderSize*2, c, c),           //Left Border
    new Border(borderSize, height/3, (int)(width*0.625), borderSize, c, c),
    new Border(width*3/8 + 1, height*2/3 + 1, width*5/8, borderSize, c, c)
  };
  
  _goal = new Border(290, 40, 20, 20, color(50, 255, 50), color(50, 255, 50));
}

void DrawMap() {
  for (var border : _borders) {
    border.Draw();
  }

  _goal.Draw();
}

void CheckIntersectionsAndDrawAccordingly()
{
  for (int i = 0; i < NUMBER_OF_PLAYERS; i++)
  {
    _players[i].TakeNextStep();
    if(!_players[i].IsParent)
    {
      _players[i].Draw();
    }

    if (_players[i].HasReachedGoal)
    {
      text("Win!", width/2, height/2);
      continue;
    }
  }
  
  for(var player : _mostFitPlayers)
  {
    if(player != null){
      player.Draw();
    }
  }

  currentStep++;
}
