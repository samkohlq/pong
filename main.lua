WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push' -- import functions from push.lua

-- initialise the game when it first starts
function love.load()
  math.randomseed(os.time())
  love.graphics.setDefaultFilter('nearest', 'nearest') -- set 'Point' filtering for retro aesthetic
  
  -- set font
  smallFont = love.graphics.newFont('04B_03__.ttf', 8)
  scoreFont = love.graphics.newFont('04B_03__.ttf', 32)

  -- initialise starting scores
  playerOneScore = 0 
  playerTwoScore = 0

  -- initialise paddles' starting positions
  player1X = 10
  player1Y = 30
  player2X = VIRTUAL_WIDTH - 10
  player2Y = VIRTUAL_HEIGHT - 50

  -- initialise speed at which paddle moves
  PADDLE_SPEED = 200

  -- initialise ball's starting position
  ballX = VIRTUAL_WIDTH / 2 - 2
  ballY = VIRTUAL_HEIGHT / 2 - 2

  ballDX = math.random(2) == 1 and -100 or 100 -- tenary operator to randomly return -100 or 100
  ballDY = math.random(-50, 50) -- return random values between -50 and 50

  gameState = 'start'

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
  })
end

-- move player paddles when keys are pressed
function love.update(dt)
  if love.keyboard.isDown('w') then
    player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
  elseif love.keyboard.isDown('s') then
    player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
  end

  if love.keyboard.isDown('up') and player2Y > 5 then
    player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
  elseif love.keyboard.isDown('down') and player2Y < VIRTUAL_HEIGHT - 25 then
    player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
  end

  if gameState == 'play' then
    ballX = ballX + ballDX * dt
    ballY = ballY + ballDY * dt
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit() -- allow user to quit game by pressing 'escape' key
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'play'
    elseif gameState == 'play' then
      gameState = 'start'
      ballX = VIRTUAL_WIDTH / 2 - 2
      ballY = VIRTUAL_HEIGHT / 2 - 2
    
      ballDX = math.random(2) == 1 and -100 or 100 -- tenary operator to randomly return -100 or 100
      ballDY = math.random(-50, 50) -- return random values between -50 and 50
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

  love.graphics.rectangle('line', player1X, player1Y, 5, 20) -- draw player 1's paddle

  love.graphics.rectangle('line', player2X, player2Y, 5, 20) -- draw player 2's paddle

  love.graphics.rectangle('fill', ballX, ballY, 4, 4) -- draw the ball and centre it

  push:apply('end')
end