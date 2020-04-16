WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

Class = require 'class' -- import functions from class.lua
push = require 'push' -- import functions from push.lua

require 'Ball'
require 'Paddle'

-- initialise the game when it first starts
function love.load()
  math.randomseed(os.time())
  love.graphics.setDefaultFilter('nearest', 'nearest') -- set 'Point' filtering for retro aesthetic
  
  love.window.setTitle('Pong')

  -- set font
  smallFont = love.graphics.newFont('04B_03__.ttf', 8)
  scoreFont = love.graphics.newFont('04B_03__.ttf', 32)

  -- initialise starting scores
  playerOneScore = 0 
  playerTwoScore = 0

  -- instantiate paddles and ball
  paddle1 = Paddle(5, 20, 5, 20)
  paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
 
  -- initialise speed at which paddle moves
  PADDLE_SPEED = 200

  gameState = 'start'

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
  })
end

-- move player paddles when keys are pressed
function love.update(dt)
  if gameState == 'play' then
    
    -- keep track of scores
    if ball.x <= 0 then
      playerTwoScore = playerTwoScore + 1
      ball:reset()
      gameState = 'start'
    end 

    if ball.x >= VIRTUAL_WIDTH - 4 then
      playerOneScore = playerOneScore + 1
      ball:reset()
      gameState = 'start'
    end

    -- deflect ball if it hits either paddle
    if ball:collides(paddle1) then
      ball.dx = -ball.dx
    end

    if ball:collides(paddle2) then
      ball.dx = -ball.dx
    end

    -- make sure ball does not go out of screen's vertical boundaries
    if ball.y <= 0 then
      ball.dy = -ball.dy
      ball.y = 0
    end

    if ball.y >= VIRTUAL_HEIGHT - 4 then
      ball.dy = -ball.dy
      ball.y = VIRTUAL_HEIGHT - 4
    end

    if love.keyboard.isDown('w') then
      paddle1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
      paddle1.dy = PADDLE_SPEED
    else
      paddle1.dy = 0
    end

    if love.keyboard.isDown('up') then
      paddle2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
      paddle2.dy = PADDLE_SPEED
    else
      paddle2.dy = 0
    end

    ball:update(dt)
    paddle1:update(dt)
    paddle2:update(dt)
  end
  
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit() -- allow user to quit game by pressing 'escape' key
  elseif key == 'enter' or key == 'return' then -- allow user to start game by pressing 'enter' or 'return'
    if gameState == 'start' then
      gameState = 'play'
    end
  end
end

-- update the screen
function love.draw()
  push:apply('start') -- draw things the 'push' way

  love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255) -- divide by 255 because function takes decimal values

  love.graphics.setFont(smallFont)
  if gameState == 'start' then -- show when game has not started
    love.graphics.printf(
      "start", -- text to render
      0, -- starting X position; 0 since we centre the text based on width
      20, -- starting Y position;
      VIRTUAL_WIDTH, -- number of pixels to centre within entire screen
      'center') -- alignment mode
  elseif gameState == 'play' then -- show when game is in play
    love.graphics.printf(
      "play", -- text to render
      0, -- starting X position; 0 since we centre the text based on width
      20, -- starting Y position;
      VIRTUAL_WIDTH, -- number of pixels to centre within entire screen
      'center') -- alignment mode
  end

  -- show current score 
  love.graphics.setFont(scoreFont)
  love.graphics.print(playerOneScore, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(playerTwoScore, VIRTUAL_WIDTH / 2 + 35, VIRTUAL_HEIGHT / 3)

  paddle1:render()
  paddle2:render()
  ball:render()

  displayFPS()

  push:apply('end')
end

function displayFPS()
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.setFont(smallFont)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20) -- concatenate two strings with '..'
  love.graphics.setColor(1, 1, 1, 1)
end