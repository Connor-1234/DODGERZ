require("player")
require("finish")
require("Menu")
require("dead")


math.randomseed(os.time()) -- for random spawn locations.
love.graphics.setDefaultFilter( "nearest" )
--love.window.setVSync(1)

currentState = 0 -- Menu

--check if keys are pressed. Used for switching between different game states(game,menu,death)
function love.keypressed(key)
  if currentState == 0 then
    if key == "space" then
      currentState = 1 -- game state. load game
      boom = 0
      Player:load()
      finish:load()
      spawn_meteor()
    elseif key == "escape" then -- quit the game.
      love.event.quit(0)
    else --prevent keys from repeatedly being pressed across states.
      return
    end
  elseif currentState == 2 then -- death state.
    if key == "y" then
      currentState = 0 --if user says yes to continue, switch to menu. keep playing.
    elseif key == "n" then
      love.event.quit(0)
    end
    else
      return
  end
end

--table to score all of the spawned meteors.
local meteors = {}
--table to track current level, and max level reached(highscore). objects tracks number of meteors.
level = {current = 1, highscore = 1}
objects = 1
--spawn_meteor contains characteristics of each meteor stored in a local table, meteor(speed, coordinates, size, image)
--This function also contains drawing, movement, and collision functionalities of each meteor.
function spawn_meteor(x, y, width, height, speed, xVel, yVel)
  local meteor = {
      x = math.random(100, love.graphics.getWidth() - 100),
      y = math.random(100, love.graphics.getHeight() - 100),
      width = 65,
      height = 65,
      speed = 300,
      xVel = -380,
      yVel = -380,
      img = love.graphics.newImage("assets/meteorIMG.png")
  }

  function meteor.draw()
    love.graphics.draw(meteor.img, meteor.x, meteor.y, 0, 6.6)
  end
  --similar to player.move function..
  function meteor.move(dt)
    meteor.x = meteor.x + meteor.xVel * love.timer.getDelta()
    meteor.y = meteor.y + meteor.yVel * love.timer.getDelta()
  end

  function meteor.collide()
    --if player and meteor collide, clear meteors table, and mannually collect garbage.
    if checkCollision (meteor, Player) then
      for k,v in ipairs(meteors) do
        meteors[k] = nil
        collectgarbage("step")
      end
      currentState = 2 -- you have died. showing death screen.
      level.current = 1 --reset level, and # of meteors.
      objects = 1
    end
    --the following keeps the meteor in the resolution dimensions.
    --it also adjusts velocity after boarder collision, reversing it. This gives the appearance of a bounce.
    if meteor.y < 0 then
      meteor.y = 0
      meteor.yVel = -meteor.yVel
      collectgarbage("step")
    elseif meteor.y + meteor.height > love.graphics.getHeight() then
      meteor.y = love.graphics.getHeight() - meteor.height
      meteor.yVel = -meteor.yVel
      collectgarbage("step")
    end
    if meteor.x < 0 then
      meteor.x = 0
      meteor.xVel = -meteor.xVel
      collectgarbage("step")
    end
    if meteor.x + meteor.width > love.graphics.getWidth() then
      meteor.x = love.graphics.getWidth() - meteor.width
      meteor.xVel = -meteor.xVel
      collectgarbage("step")
    end
  end
  --append a meteor to the meteors table, this will include all functionality in spawn_meteor.
  --ensures multiple projectiles are spawned.
  meteors[#meteors + 1] = meteor
  return meteor
end

function love.load()
  if currentState == 1 then -- game state. Load game objects.
    Player:load()
    finish:load()
    spawn_meteor()
  elseif currentState == 2 then -- death state. Load player death screen
    death.load()
  else --menu state. load menu
    menu.load()
  end
end

function love.update(dt)
  if currentState == 1 then -- game state.
    love.graphics.setFont(love.graphics.newFont(16))
    gameBackground = love.graphics.newImage("assets/gameBackground.png")
    --https://unsplash.com/photos/uhjiu8FjnsQ (game background)
    Player:update()
    finish:collide()
    levelup()
    --use a loop to update movement and collision for each meteor in our meteors table (all spawned meteors)
    for i = 1, #meteors do
      local current_meteor = meteors[i]
      if meteors[i] == nil then
        return
      else
        meteors[i].move()
        meteors[i].collide()
      end
      collectgarbage("step")
    end
  else -- menu state
    menu.update(dt)
  end
end

function love.draw() --display graphics
  if currentState == 1 then --game state.
    love.graphics.draw(gameBackground, 0, 0, 0, 3.3)
    Player:draw()
    finish:draw()
    --use a loop to call meteor.draw on each meteor in our meteors table.
    for i = 1, #meteors do
      meteors[i].draw();
    end
    love.graphics.print("Level: "..level.current, love.graphics.getWidth()/2 - 30, 50)
    love.graphics.print("HighScore: "..level.highscore, love.graphics.getWidth()/2 - 50, 75)
  elseif currentState == 2 then --death state.
    death.draw()
    collectgarbage("collect")
  else -- menu state.
    menu.draw()
  end
end


function levelup()
  --spawn a meteor everytime the player gets to the next level. incrament # of meteors(objects+1)
  if level.current > objects then
    spawn_meteor(math.random(0, love.graphics.getWidth()), math.random(0, love.graphics.getHeight()), 300, -300, math.random(-110, -300))
    objects = objects + 1
  end
end

function checkCollision(a, b)
  if a.x == nil or b.x == nil or a.y == nil or b.y == nil then
    return
  else
    --check if an objects image overlaps with another object's image. if so they have collided. (uses x coordinate and width, y cooridnate and height)
    if a.x + a.width - 15 > b.x and a.x < b.x + b.width - 15 and a.y + a.height - 15 > b.y and a.y < b.y + b.height - 15 then
      return true
    else
      return false
    end
  end
end
