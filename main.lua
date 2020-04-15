WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push' -- import functions from push.lua

-- initialise the game when it first starts
function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest') -- set 'Point' filtering for retro aesthetic
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
  })
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit() -- allow user to quit game by pressing 'escape' key
  end
end

-- update the screen
function love.draw()
  push:apply('start') -- draw things the 'push' way

  love.graphics.printf(
    "hello world", -- text to render
    0, -- starting X position; 0 since we centre the text based on width
    VIRTUAL_HEIGHT / 2 - 6, -- starting Y position; height divided by two and moved up 6 pixels, the height of the text
    VIRTUAL_WIDTH, -- number of pixels to centre within entire screen
    'center') -- alignment mode
  
  push:apply('end')
end