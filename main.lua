--[[
    01/02/2022
    Platformer Time

    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer Time is a way for me to practice developing platformers.
]]

require 'src/Dependencies'

-- virtual resolution dimensions
VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

hero = Hero()

-- Table of fonts
gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}

-- Table of character sprites
gChars = {
    ['finn'] = love.graphics.newImage('images/FinnSprite.png')
}


gCharFrames = {
    ['finn'] = GenerateQuads(gChars['finn'], 32, 32)
}

local background = love.graphics.newImage('images/TEST SKY 1.png')
local ground = love.graphics.newImage('images/ground.png')



function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('Platformer Time')


    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize input table
    love.keyboard.keysPressed = {}

    -- initialize mouse input table
    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    LÖVE2D callback fired each time a mouse button is pressed; gives us the
    X and Y of the mouse, as well as the button in question.
]]
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

--[[
    Custom function to extend LÖVE's input handling; returns whether a given
    key was set to true in our input table this frame.
]]
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--[[
    Equivalent to our keyboard function from before, but for the mouse buttons.
]]
function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    hero:update(dt)
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

--[[
    Renders the current FPS.
    Renders the current FPS.draw
]]
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 15, 5)
end

function love.draw()
    push:start()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)
    hero:render()
    love.graphics.printf('Its Platformer Time!', 0, 64, VIRTUAL_WIDTH, 'center')
    displayFPS()
    push:finish()
end
