Player = {} --table to store all the player's functionality

function Player:load()
  --all characteristics of the player.
  self.x = 40
  self.y = 40
  self.width = 59
  self.height = 59
  self.speed = 600
  self.img = love.graphics.newImage("assets/playerIMGRIGHT.png")
  --player image https://www.shutterstock.com/search/8+bit+spaceship
end

function Player:update(dt)
  --update players movement, as well as containment.
  self:move(dt)
  self:contain()
end

function Player:move(dt)
  --check for key inputs, and adjust player coordinates based on player speed. Account for deltatime
  if love.keyboard.isDown("w") then
    self.y = self.y - self.speed * love.timer.getDelta()
    self.img = love.graphics.newImage("assets/playerIMGUP.png")
  elseif love.keyboard.isDown("s") then
    self.y = self.y + self.speed * love.timer.getDelta()
    self.img = love.graphics.newImage("assets/playerIMGDOWN.png")
  elseif love.keyboard.isDown("d") then
    self.x = self.x + self.speed * love.timer.getDelta()
    self.img = love.graphics.newImage("assets/playerIMGRIGHT.png")
  elseif love.keyboard.isDown("a") then
    self.x = self.x - self.speed * love.timer.getDelta()
    self.img = love.graphics.newImage("assets/playerIMGLEFT.png")
  end
end

function Player:contain()
  if self.y == nil then
    Player:load()
  else
    --if the player's y or x coordinates go past 0, set them to 0. this keeps the player from leaving the left and top of screen.
    --if the player's y+height is greater than the resolution height, set the players y coordinate to the resolutionH-playerH. This keeps the player from leaving the bottom of the screen.
    --if the player's x+width is greater than the resolution width, set x to resolutionW - playerW. this keeps the player from leaving the right of the screen.
    if self.y < 0 then
      self.y = 0
    elseif self.x < 0 then
      self.x = 0
    elseif self.y + self.height > love.graphics.getHeight() then
      self.y = love.graphics.getHeight() - self.height
    elseif self.x + self.width > love.graphics.getWidth() then
      self.x = love.graphics.getWidth() - self.width
    end
  end
end

function Player:draw()
  love.graphics.draw(self.img, self.x, self.y, 0, 2)
end
