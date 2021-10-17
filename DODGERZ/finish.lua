--table to score all of finish's functionality.
finish ={}

--draw the finish portal at set x,y coordinates. use saved image file.
function finish:load()
  self.width = 85
  self.height = 100
  self.x = love.graphics.getWidth() - 150
  self.y = love.graphics.getHeight() - 150
  self.img = love.graphics.newImage("assets/finishIMG.png")
end

function finish:draw()
  love.graphics.draw(self.img, self.x, self.y, 0, 2) --https://www.pngaaa.com/detail/3113906 portal image!
end

--call check collision to see if the finish and the player collide. if so, incrament the level, and check if they have reached a highscore.
--after collision, reset player position.
function finish:collide()
  if checkCollision (finish, Player) then
    level.current = level.current + 1
    if level.current > level.highscore then
      level.highscore = level.highscore + 1
    end
    Player.x = 50
    Player.y = 50
  end
end
