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

Every 5 seconds you will grown by one

If you hit a wall, your snek dies.  If you crash into yourself, your snek dies.  If you hit another snek, your snek dies.  If another snek hits you, that snek dies.  If you head on collide with another snek, both sneks die.

Become the biggest snek.

## How to do it

You connect to the server via websockets - there's a sample client and utility code in `/client`