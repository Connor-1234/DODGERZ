--table to score functions associated with the death screen.
death = {}

function death.load()
  --Load dead screen font.
  love.graphics.setFont(love.graphics.newFont(32))
end

function death.draw()
  --draw phrase (continue? y/n)
  love.graphics.print("CONTINUE? Y/N", love.graphics.getWidth()/2 - 110, love.graphics.getHeight()/2 - 20)
end
