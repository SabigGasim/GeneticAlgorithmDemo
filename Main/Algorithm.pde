import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import java.util.InputMismatchException;
import java.util.Scanner;

void InitializePopulation() {
  _players = new Player[NUMBER_OF_PLAYERS];
  color playerColor = color(202, 209, 13);
  for (int i = 0; i < NUMBER_OF_PLAYERS; i++)
  {
    _players[i] = new Player(_startingPoint.x, _startingPoint.y, 10, 10, playerColor, color(0, 0, 0));
  }
}

void CalculateFitness(){
  for(var player : _players){
    player.Fitness = 10/dist(_goal.Position.x, _goal.Position.y, player.Position.x, player.Position.y);
  }
}

void NaturalSelection(){
  for(var parent : _mostFitPlayers)
  {
    if(parent != null)
    {
      parent.IsParent = false;
    }
  }
  
  _mostFitPlayers = Arrays.stream(_players)
    .sorted(Comparator.comparingDouble(Player::GetFitness).reversed())
    .limit(NUMBER_OF_PARENTS)
    .toArray(Player[]::new);
    
  for(var player : _mostFitPlayers)
  {
    player.IsParent = true;
  }
}

void Crossover(){
  for(int x = 0; x < _players.length; x++)
  {
    if(_players[x].IsParent)
    {
      continue;
    }
    
    _players[x].InheritStepsFrom(_mostFitPlayers[x % NUMBER_OF_PARENTS]);
    println(x % NUMBER_OF_PARENTS);
  }
}

void Mutation()
{
  for(var player : _players)
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

void PopulateNewGeneration()
{
  for(var player : _players)
  {
    player.Reset();
  }
}
