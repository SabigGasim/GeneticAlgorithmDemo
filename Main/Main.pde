final int NUMBER_OF_STEPS = 1000;
final int NUMBER_OF_PLAYERS = 1000;
final int NUMBER_OF_PARENTS = 1;
final float MUTATION_RATE = 0.01;
Boolean GOAL_REACHED = false;
Boolean SOLUTION_FOUND = false;
int currentStep;
Border[] _borders;
Border[] _correctPath;
Player[] _players;
Player[] _mostFitPlayers = new Player[6];
int[] _mostFitPlayersIndices = new int[6];
Border _goal;
PVector _startingPoint = new PVector(740, 80);


void setup() {
  size(900, 600);
  textAlign(CENTER, CENTER);
  frameRate(2000);
  textSize(40);
  InitializeBorders();

  InitializePopulation();
}

void draw() {
  background(255, 255, 255);

  if (GOAL_REACHED || currentStep >= NUMBER_OF_STEPS)
  {
    CalculateFitness();
    NaturalSelection();
    Crossover();
    Mutation();
    currentStep = 0;
  }
  
  DrawCorrectPath();

  DrawMap();
  text(Integer.toString(mouseX) + ", " + Integer.toString(mouseY), width/2, height/2);
  CheckIntersectionsAndDrawAccordingly();
}



void InitializeBorders() {
  _borders = new Border[]{
    new Border(0, 0, width, 20, color(150, 0, 0), color(150, 0, 0)),             //Top Border
    new Border(0, height-20, width, 20, color(150, 0, 0), color(150, 0, 0)),       //Bottom Border
    new Border(width - 20, 20, 20, height-40, color(150, 0, 0), color(150, 0, 0)), //Right Border
    new Border(0, 20, 20, height-40, color(150, 0, 0), color(150, 0, 0)),           //Left Border

    new Border(688, 230, width - 687, 10, color(150, 0, 0), color(150, 0, 0)),
    new Border(570, 20, 10, 376, color(150, 0, 0), color(150, 0, 0)),
    new Border(570, 396, 170, 10, color(150, 0, 0), color(150, 0, 0)),
    new Border(420, 300, 10, 320, color(150, 0, 0), color(150, 0, 0)),
    new Border(380, 160, 190, 10, color(150, 0, 0), color(150, 0, 0)),
    new Border(260, 160, 10, height-20, color(150, 0, 0), color(150, 0, 0)),
    new Border(140, 390, 10, 190, color(150, 0, 0), color(150, 0, 0)),
    new Border(140, 160, 120, 10, color(150, 0, 0), color(150, 0, 0)),
    new Border(20, 280, 120, 10, color(150, 0, 0), color(150, 0, 0))
  };
  
  color c = color(255,255,255,0);
  //color c = color(0,0,0,0);

  
  _correctPath = new Border[] {
            new Border(580, 245, 300, 155, c, c),
            new Border(570, 400, 310, 175, c, c),
            new Border(430, 300, 140, 280, c, c),
            new Border(270, 170, 300, 130, c, c),
            new Border(130, 20, 257, 140, c, c),
            new Border(20, 20, 120, 260, c, c),
            new Border(141, 170, 119, 220, c, c),
            new Border(20, 290, 120, 169, c, c)
        };

  _goal = new Border(20, 460, 120, 120, color(50, 255, 50), color(50, 255, 50));
}

void DrawCorrectPath(){
  
  for(var border : _correctPath){
    border.Draw();
  }
        
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
    _players[i].Draw();

    if (_players[i].HasReachedGoal)
    {
      text("Win!", width/2, height/2);
      continue;
    }
  }
  
  for(var fitPlayer : _mostFitPlayers){
    if(fitPlayer == null){
      continue;
    }
    fitPlayer.Color = color(0,255,100);
    fitPlayer.BorderColor = fitPlayer.Color;
    fitPlayer.Draw();
  }

  currentStep++;
}
