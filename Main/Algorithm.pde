void InitializePopulation() { //<>//
  _players = new Player[NUMBER_OF_PLAYERS];
  for (int i = 0; i < NUMBER_OF_PLAYERS; i++)
  {
    _players[i] = new Player(_startingPoint.x, _startingPoint.y, 7, 7, color(0, 0, 0), color(0, 0, 0));
  }
}

void CalculateFitness()
{
    float GOAL_BONUS = 10000.0f;
    float EFFICIENCY_BONUS = 5000.0f;
    float CHECKPOINT_REWARD = 1000.0f;
    float PROXIMITY_SCALAR = 500.0f;

    for (var player : _players)
    {
        player.Fitness = 0;

        if (player.HasReachedGoal)
        {
            player.Fitness = GOAL_BONUS + (EFFICIENCY_BONUS / player.CurrentStep);
            continue;
        }

        var hasReachedCheckpoint = false;

        for (int i = _correctPath.length - 1; i >= 0; i--)
        {
            if (player.IntersectsWith(_correctPath[i]))
            {
                player.Fitness = CHECKPOINT_REWARD * (i + 1);
                float distanceToNextTarget;
                if (i + 1 < _correctPath.length)
                {
                    distanceToNextTarget = dist(player.Position.x, player.Position.y, _correctPath[i + 1].Position.x, _correctPath[i + 1].Position.y);
                }
                else
                {
                    distanceToNextTarget = dist(player.Position.x, player.Position.y, _goal.Position.x, _goal.Position.y);
                }

                player.Fitness += PROXIMITY_SCALAR / (1.0f + distanceToNextTarget);
                
                hasReachedCheckpoint = true;
                break;
            }
        }

        if (!hasReachedCheckpoint)
        {
            float distanceToGoal = dist(player.Position.x, player.Position.y, _goal.Position.x, _goal.Position.y);
            player.Fitness = PROXIMITY_SCALAR / (1.0f + distanceToGoal);
        }
    }
}

void NaturalSelection() {
  for (int i = 0; i < NUMBER_OF_PARENTS; i++) {

    _mostFitPlayers[i] = null;
    _mostFitPlayersIndices[i] = 0;

    for (int y = 0; y < _players.length; y++) {
      Boolean shouldSelectPlayer = SOLUTION_FOUND
        ? _players[y].HasReachedGoal
          ? _mostFitPlayers[i] != null
            ? _players[y].Fitness > _mostFitPlayers[i].Fitness
            : false
          : true
        : _mostFitPlayers[i] != null
          ? _players[y].Fitness > _mostFitPlayers[i].Fitness
          : true
          ;

      if (shouldSelectPlayer) {
        _mostFitPlayers[i] = _players[y];
        _mostFitPlayersIndices[i] = y;
        println(_mostFitPlayersIndices[i]);
      }
    }
  }
}

void Crossover() {
  for (int i = 0; i < NUMBER_OF_PLAYERS; i++)
  {
    var parentIndex = i % NUMBER_OF_PARENTS;
    for(int y = 0; y < _mostFitPlayers.length; y++){
      if(i == _mostFitPlayersIndices[y])
      {
        continue; //<>//
      }
    }
    _players[i].InheritStepsFrom(_mostFitPlayers[parentIndex]);
    _players[i].Reset();
  }

  GOAL_REACHED = false;
}

void Mutation() {
  for (var player : _players)
  {
    if (PlayerIsParent(player))
    {
      continue;
    }

    for (int i = 0; i < player.Steps.length; i++)
    {
      if (random(0, 1) <= MUTATION_RATE)
      {
        player.Steps[i] = PVector.fromAngle(2*PI);
      }
    }
  }
}

Boolean PlayerIsParent(Player player) {
  for (var p : _mostFitPlayers)
  {
    if (p == player) {
      return true;
    }
  }

  return false;
}
