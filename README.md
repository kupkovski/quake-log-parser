# Quake Log Parser

## Purpose

The purpouse of this project is read and parse a log file containing information about a series of Quake 3 games, and display a report containing number of kills, names of the players and an overall number of kills on each game.

Log examples can be found on the `logs/` folder.

The report looks like this:
``` JSON
[
  {
    "game_1": {
      "total_kills": 0,
      "players": [],
      "kills": {}
    }
  },
  {
    "game_2": {
      "total_kills": 11,
      "players": [
        "Isgalamido",
        "Mocinha"
      ],
      "kills": {
        "Isgalamido": -5
      }
    }
  }
]
```
### The rules

The main rules are:

    1. When <world> kill a player, that player loses -1 kill score.
    2. Since <world> is not a player, it should not appear in the list of players or in the dictionary of kills.
    3. The counter total_kills includes player and world deaths.


## Code structure

The source files are located under the `lib/` folder. Listed here in order of calls:

### parser.rb

Contains the `Parser` class which starts all the process, it gets an log filename as parameter, do some checks and start processing the log file.

Whenever it finds a line starting with the string `"InitGame:"` it instantiates a `Game` object (listed below) and store it on a list of games
When it finds a line containing `"killed"` it parses the line to find who killed who instantiating `Player` objects for both. Then it instantiates a `Kill` object (listed below) containing both players: One called `Killer` and the other one called `Victim`.

And at last it creates a `GameReporter` object which is responsible for handling the output of each game from the file.

### game.rb 

Contains some logic on how to handle and create `Kills`, `Players` and `Report`

### player.rb

A simpler class, to be used as Data Transfer between other objects, and helps determine if the player is the `<world>` or not.

### kill.rb

A simple class that is used as Data Transfer, and which makes it easier to deal with the abstraction of a kill, mainly for the report.

### game_reporter.rb

The class responsible for handling the logic of building the final report, containing some of the logic to increment/decrement deaths based on the rules.


## Some considerations

I built the project focusing on the idea that the most important thing is the report to be shown at the end. 

If I had more time, I could consider re-think the strategy of building it focusing more on the `Game` idea itself. 

I mean, instead of applying the rules on the report, apply it on the moment of parsing the lines, on the game object itself. For instance: instead of decrementing calls from the player who got killed by `<world>` directly on the report generation, I could have done this while parsing, when I detect some player was killed by `<world>` and do something like: ``` game.decrement_kill_from(player: victim) ```, or something similar.


I didn't see on the rules gave to me any mentions of show/hiding negative kills. For example, if `Player 1` got killed by `<world>` 5 times, and did not kill any other players, he's score is currently `-5`

## Running the project

I put in a script to help running it via CLI, which is located on `bin/parse_quake_log`. It can be run like the following:

``` 
$ bundle install 
$ bin/parse_quake_log log/log.txt
```

## Running the tests

```
$ bundle install 
$ bin/rspec spec
```
