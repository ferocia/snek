<div align="center">
  <h1>🐍✨<br>Snek</h1>
  <h3>Just like on the Nokia 3210</h3>
</div>

## What

A programming game made with love for Railscamp in the tradition of [treasure wars](https://gist.github.com/mtcmorris/4071163), [brains](https://github.com/chrislloyd/brains), ant wars etc etc.

> You are snake (snek).  Your want to be biggest snek.  Avoid other snek.  Walls too.

---

## Rules

You spawn at a random location.

Every 1 second you get a chance to submit a move `["N", "S, "E", "W"]`.  If you don't submit a move, you will move forward.

Every 5 ticks you will grown by one

If you hit a wall, your snek dies.  If you crash into yourself, your snek dies.  If you hit another snek, your snek dies.  If another snek hits you, that snek dies.  If you head on collide with another snek, both sneks die.

Become the biggest snek.

## How to do it

You connect to the server via websockets - there's a sample client and utility code in `/client`


## Quick start

You need to run 3 processes: the server, the client, and the game.

```
cd server
bundle && yarn && rake db:create db:schema:load
bundle exec rails server

[new tab]
cd server && bundle exec game:run

[new tab]
cd client
bundle && yarn
bundle exec ruby runner.rb
```

## PR's Welcome!

If you feel like chipping in there's loads of things you could do.  Maybe:

  - Add some better obstacles to the map
  - Improve the styling of the front end
  - Make the snakes look better
  - Add food
  - Improve the error handling of the client code
  - Surely it needs sound effects right?
