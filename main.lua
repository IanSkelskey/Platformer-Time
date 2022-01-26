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

Map = STI('maps/ian_test.lua', {'box2d'})
World = love.physics.newWorld(0,0)
World:setCallbacks(beginContact, endContact)
Map:box2d_init(World)
if debug_active then
  Map.layers.Solids.visible = true
else
  Map.layers.Solids.visible = false
end

hero = Hero()

-- Table of fonts
gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}

gSounds = {
  ['theme'] = love.audio.newSource('sounds/AdventureTime.mp3', 'static')
}

local background = love.graphics.newImage('images/TEST SKY 2.png')

function love.load()
    --gSounds['theme']:play()
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

    if key == 'f11' then
      fullscreen = not fullscreen
      love.window.setFullscreen(fullscreen, fstype)
      love.resize(love.graphics.getDimensions())
    end

    -- Add Debug Keybind?
    if key == 'tab' then
      debug_active = not debug_active
    end

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
    World:update(dt)
    hero:update(dt)
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

--[[
    Renders the current FPS.
    Renders the current FPS.draw
]]
function debugMode()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 15, 5)
    love.graphics.print('Hero state: ' .. tostring(hero.states.current.NAME), 15, 15)
    love.graphics.print('grounded?: ' .. tostring(hero.grounded), 15, 25)

    love.graphics.print('Hero dx: ' .. tostring(hero.speeds.dx), 108, 5)
    love.graphics.print('Hero dy: ' .. tostring(math.ceil(hero.speeds.dy)), 108, 15)
    love.graphics.print('Hero x: ' .. tostring(hero.x), 170, 5)
    love.graphics.print('Hero y: ' .. tostring(hero.y), 170, 15)
    love.graphics.print('Body x: ' .. tostring(hero.physics.body:getX()), 170, 25)
    love.graphics.print('Body y: ' .. tostring(hero.physics.body:getY()), 170, 35)
    love.graphics.setColor(1, 1, 1, 1)
end

function love.draw()
    push:start()
    love.graphics.setFont(gFonts['medium'])
    -- Draw Background Layer
    love.graphics.draw(background, 0, 0)
    -- Draw Map on Top of Background
    Map:draw(0, 0, 1, 1)

    --love.graphics.printf('Its Platformer Time!', 0, 52, VIRTUAL_WIDTH, 'center')
    hero:render()

    if debug_active then
      debugMode()
    end
    push:finish()
end

function beginContact(a, b, collision)
  print("attempting to Hero:beginContact()")
  hero:beginContact(a, b, collision)
end

function endContact(a, b, collision)
  hero:endContact(a, b, collision)
end
