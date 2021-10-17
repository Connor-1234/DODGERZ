--table storing all the menu's functionality
menu = {}

function menu.load()
  --set menu font size. load background and audio to be played.
  --alltimehighjump. Thanks for the audio
  --https://www.wallpaperflare.com/asteroids-wallpaper-digital-art-space-universe-pixels-pixel-art-wallpaper-edc/download/1280x720 (MENU1 background)
  love.graphics.setFont(love.graphics.newFont(32))
  background = love.graphics.newImage("assets/menuBackground1.png")
  audio = love.audio.newSource("assets/menuAudio.mp3", "stream")
end

function menu.update()
  --reset font size to prevent in game font size from being used.
  --check if audio is not playing. If it's not then play it, but at a reduced volume and pitch.
  love.graphics.setFont(love.graphics.newFont(32))
  if not audio:isPlaying() then
    love.audio.play(audio)
    audio:setVolume(0.04)
    audio:setPitch(0.9)
  else
    return
  end
end

function menu.draw()
  --draw our menu with the background, and commands for the player.
  love.graphics.draw(background)
  love.graphics.print("Press SPACE to play", 50, 50)
  love.graphics.print("Press ESCAPE to quit", love.graphics.getWidth() - 400, love.graphics.getHeight() - 100)
end
