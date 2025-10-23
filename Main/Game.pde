import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import java.util.InputMismatchException;
import java.util.Scanner;

public class Game
{
  public Player[] Players;
  public Player[] MostFitPlayers;
  public PVector StartingPoint;
  public static final int Width = 600;
  public static final int Height = 800;
  public static final int NUMBER_OF_STEPS = 1000;
  public static final int NUMBER_OF_PLAYERS = 1000;
  public static final int NUMBER_OF_PARENTS = 5;
  public static final float MUTATION_RATE = 0.01;
  public Boolean GOAL_REACHED = false;
  public Boolean SOLUTION_FOUND = false;
  public int CurrentStep = 0;
  private Border[] Borders;
  private Border Goal;
  private static final int BorderSize = 20;
  private static final int BorderColor = 0xFFA16E22;
  private int DeathCount = 0;
  private int GenerationNumber = 1;
  
  public Game()
  {
    final int borderSize = 20;
    int c = BorderColor;

    Borders = new Border[]{
      new Border(0, 0, Width, BorderSize, c, c),             //Top Border
      new Border(0, Height-BorderSize, Width, borderSize, c, c),       //Bottom Border
      new Border(Width - borderSize, borderSize, borderSize, Height-borderSize*2, c, c), //Right Border
      new Border(0, borderSize, borderSize, Height-borderSize*2, c, c),           //Left Border
      new Border(borderSize, Height/3, (int)(Width*0.625), borderSize, c, c),
      new Border(Width*3/8 + 1, Height*2/3 + 1, Width*5/8, borderSize, c, c)
    };
    
    Goal = new Border(290, 50, 10, 10, color(50, 255, 50), color(0, 0, 0));
    
    StartingPoint = new PVector(297, 760);
  }
  
  public void DrawMap()
  {
    for (var border : Borders) 
    {
      border.Draw();
    }

    fill(Goal.Color);
    stroke(Goal.BorderColor);
    circle(Goal.Position.x, Goal.Position.y, Goal.Width*2);
  }
  
  public void InitializePopulation() 
  {
    Players = new Player[NUMBER_OF_PLAYERS];
    MostFitPlayers = new Player[NUMBER_OF_PARENTS];
    color playerColor = color(202, 209, 13);
    for (int i = 0; i < NUMBER_OF_PLAYERS; i++)
    {
      Players[i] = new Player(StartingPoint.x, StartingPoint.y, 20, 20, playerColor, color(0, 0, 0));
    }
  }
  
  public void CalculateFitness()
  {
    for(var player : Players)
    {
      if(!player.HasReachedGoal)
      {
        player.Fitness = 10/dist(Goal.Position.x, Goal.Position.y, player.Position.x, player.Position.y);
        continue;
      }
      
      player.Fitness = NUMBER_OF_STEPS/(float)player.CurrentStep/5 + 0.9;
    }
  }
  
  public void NaturalSelection()
  {
    for(var player : MostFitPlayers)
    {
      if(player != null) 
      {
        player.IsParent = false;
      }
    }

    final float FITNESS_TOLERANCE = 0.00001f;
    var distinctTopPlayers = new ArrayList<Player>();
  
    Player[] sortedPlayers = Arrays.stream(Players)
      .sorted(Comparator.comparingDouble(Player::GetFitness).reversed())
      .toArray(Player[]::new);
  
    if (sortedPlayers.length > 0) 
    {
      distinctTopPlayers.add(sortedPlayers[0]);
  
      for (int i = 1; i < sortedPlayers.length; i++) 
      {
        if (distinctTopPlayers.size() >= NUMBER_OF_PARENTS)
        {
          break;
        }
  
        float lastAddedFitness = distinctTopPlayers.get(distinctTopPlayers.size() - 1).GetFitness();
        float currentFitness = sortedPlayers[i].GetFitness();
  
        if (lastAddedFitness - currentFitness > FITNESS_TOLERANCE) 
        {
          distinctTopPlayers.add(sortedPlayers[i]);
        }
      }
    }
    
    MostFitPlayers = distinctTopPlayers.toArray(new Player[0]);
    
    for(var parent : MostFitPlayers)
    {
      parent.IsParent = true;
      println("Fitness: " + parent.Fitness);
    }
  }
  
  public void Crossover(){
    for(int x = 0; x < Players.length; x++)
    {
      if(Players[x].IsParent)
      {
        continue;
      }
      
      Players[x].InheritStepsFrom(MostFitPlayers);
    }
  }
  
  public void MutateBabies()
  {
    for(var player : Players)
    { 
      if(player.IsParent)
      {
        continue;
      }
      
      for(int i = 0; i < player.Steps.length; i++)
      {
        if(random(0, 1) <= MUTATION_RATE)
        {
          player.Steps[i] = PVector.fromAngle(2*PI);
        }
      }
    }
  }

  public void PopulateNewGeneration()
  {
    var generationLog = SOLUTION_FOUND 
      ? "Generation: " + GenerationNumber++ + ", Steps: " + CurrentStep
      : "Generation: " + GenerationNumber++ + ", Solution not yet found";
    
    println(generationLog);
    
    for(var player : Players)
    {
      player.Reset();
    }
    
    DeathCount = 0;
    CurrentStep = 0;
    GOAL_REACHED = false;
  }
  
  public void TakeNextStep() 
  {
    for (int i = 0; i < NUMBER_OF_PLAYERS; i++)
    {
      if(Players[i].HasReachedGoal)
      {
        continue;
      }
      
      Players[i].TakeNextStep();
      if(!Players[i].IsParent)
      {
        Players[i].Draw();
      }
      
      if (Players[i].IntersectsWith(Goal))
      {
        Players[i].HasReachedGoal = true;
        GOAL_REACHED = true;
        SOLUTION_FOUND = true;
        continue;
      }
      for (var border : Borders)
      {
        if (Players[i].IsAlive && Players[i].IntersectsWith(border))
        {
          Players[i].IsAlive = false;
          DeathCount++;
          break;
        }
      }
      
    }
    
    for(var player : MostFitPlayers)
    {
      if(player != null)
      {
        player.Draw();
      }
    }
  
    CurrentStep++;
  }
  
  public Boolean HasEnded()
  {
    return GOAL_REACHED || CurrentStep >= NUMBER_OF_STEPS || DeathCount >= NUMBER_OF_PLAYERS;
  }
}
