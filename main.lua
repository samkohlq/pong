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
  math.randomseed(os.time()) -- feed randomiser with time now as seed, since that will keep changing
  love.graphics.setDefaultFilter('nearest', 'nearest') -- set 'Point' filtering for retro aesthetic
  
  love.window.setTitle('Pong') -- set window title

  -- set fonts
  smallFont = love.graphics.newFont('04B_03__.ttf', 8)
  scoreFont = love.graphics.newFont('04B_03__.ttf', 32)
  victoryFont = love.graphics.newFont('04B_03__.ttf', 20)

  -- set audio objects
  sounds = {
    ['paddle-hit'] = love.audio.newSource('/sounds/paddle-hit.wav', 'static'),
    ['score'] = love.audio.newSource('/sounds/score.wav', 'static'),
    ['wall-hit'] = love.audio.newSource('/sounds/wall-hit.wav', 'static'),
    ['victory'] = love.audio.newSource('/sounds/victory.wav', 'static')
  }

  -- initialise starting scores
  playerOneScore = 0 
  playerTwoScore = 0

  -- instantiate paddles and ball
  paddle1 = Paddle(5, 20, 5, 20)
  paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

  -- send ball either left or right depending on whose turn it is to serve
  servingPlayer = math.random(2) == 1 and 1 or 2
  if servingPlayer == 1 then
    ball.dx = 100
  else
    ball.dx = -100
  end

  winningPlayer = 0
 
  PADDLE_SPEED = 200 -- initialise speed at which paddle moves 

  gameState = 'start' -- set game's state

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = true
  })
end

function love.resize(w, h) -- allow user to resize window
  push:resize(w, h)
end

function love.update(dt)
  if gameState == 'start' then
    playerOneScore = 0
    playerTwoScore = 0
  end
  
  if gameState == 'play' then
    
    -- keep track of scores
    if ball.x <= 0 then
      playerTwoScore = playerTwoScore + 1
      servingPlayer = 1
      ball:reset()
      ball.dx = 100

      sounds['score']:play()

      if playerTwoScore >= 3 then
        gameState = 'victory'
        winningPlayer = 2

        sounds['victory']:play()
      else
        gameState = 'serve'
      end
    end 

    if ball.x >= VIRTUAL_WIDTH - 4 then
      playerOneScore = playerOneScore + 1
      servingPlayer = 2
      ball:reset()
      ball.dx = -100

      sounds['score']:play()
      
      if playerOneScore >= 3 then
        gameState = 'victory'
        winningPlayer = 1

        sounds['victory']:play()
      else
        gameState = 'serve'
      end
    end

    -- deflect ball if it hits either paddle
    if ball:collides(paddle1) then
      ball.dx = -ball.dx
      sounds['paddle-hit']:play()
    end

    if ball:collides(paddle2) then
      ball.dx = -ball.dx
      sounds['paddle-hit']:play()
    end

    -- make sure ball does not go out of screen's vertical boundaries
    if ball.y <= 0 then
      ball.dy = -ball.dy
      ball.y = 0

      sounds['wall-hit']:play()
    end

    if ball.y >= VIRTUAL_HEIGHT - 4 then
      ball.dy = -ball.dy
      ball.y = VIRTUAL_HEIGHT - 4

      sounds['wall-hit']:play()
    end

    -- move player paddles when keys are pressed
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

    -- allow user to play against player 2 (computer)
    if ball.dx > 0 then 
      paddle2.dy = ball.dy
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
      gameState = 'serve'
    elseif gameState == 'serve' then
      gameState = 'play'
    elseif gameState == 'victory' then
      gameState = 'start'
    end
  end
end

-- update the screen
function love.draw()
  push:apply('start') -- draw things the 'push' way

  love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255) -- divide by 255 because function takes decimal values

  love.graphics.setFont(smallFont)

  if gameState == 'start' then -- show when game has not started
    love.graphics.printf("Welcome to Pong!", 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press Enter to play!", 0, 32, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'serve' then
    love.graphics.printf("Player " .. tostring(servingPlayer) .. "'s turn to serve!", 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press Enter to start!", 0, 32, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'victory' then
    love.graphics.setFont(victoryFont)
    love.graphics.printf("Player " .. tostring(winningPlayer) .. " won!", 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf("Press Enter to play again!", 0, 48, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'play' then -- show when game is in play
    love.graphics.printf(
      "Here we go!", -- text to render
      0, -- starting X position; 0 since we centre the text based on width
      20, -- starting Y position;
      VIRTUAL_WIDTH, -- number of pixels to centre within entire screen
      'center') -- alignment mode
  end

  displayScore()

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

function displayScore()
  -- show current score 
  love.graphics.setFont(scoreFont)
  love.graphics.print(playerOneScore, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(playerTwoScore, VIRTUAL_WIDTH / 2 + 35, VIRTUAL_HEIGHT / 3)
end