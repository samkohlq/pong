WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push' -- import functions from push.lua

-- initialise the game when it first starts
function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest') -- set 'Point' filtering for retro aesthetic
  
  -- set font
  smallFont = love.graphics.newFont('04B_03__.ttf', 8)
  love.graphics.setFont(smallFont)

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

  love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255) -- divide by 255 because range of each is from 0 - 1

  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 3, VIRTUAL_HEIGHT / 2 - 3, 6, 6) -- draw the ball and centre it

  love.graphics.rectangle('line', 5, 20, 5, 20) -- draw player 1's paddle

  love.graphics.rectangle('line', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40, 5, 20) -- draw player 2's paddle

  love.graphics.printf(
    "hello world", -- text to render
    0, -- starting X position; 0 since we centre the text based on width
    20, -- starting Y position;
    VIRTUAL_WIDTH, -- number of pixels to centre within entire screen
    'center') -- alignment mode
  
  push:apply('end')
end