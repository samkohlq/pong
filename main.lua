WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720


function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    -- sync to monitor's refresh rate
    vsync = true,
    -- prevent user from scaling window after programme has started
    resizable = false
  })
end

function love.draw()
  -- centre vertically by dividing height by two and moving up 6 pixels, the height of the text
  love.graphics.printf("hello world", 0, WINDOW_HEIGHT / 2 - 6, WINDOW_WIDTH, 'center')
end