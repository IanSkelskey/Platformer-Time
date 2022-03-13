--[[
    01/02/2022
    Platformer Time

    Author: Ian Skelskey
    ianskelskey@gmail.com

    Platformer Time is a way for me to practice developing platformers.
]]

love.graphics.setDefaultFilter('nearest', 'nearest')

require 'src/Dependencies'

local GUI = nil

-- Sounds Table
local gSounds = {
  ['theme'] = love.audio.newSource('assets/sounds/AdventureTime.mp3', 'static')
}

local background = love.graphics.newImage('assets/images/test_sky_3.png')

function love.load()


  love.window.setTitle('Platformer Time')

  Map:load()

  GUI = HUD(hero)

  -- gSounds['theme']:play()

  -- initialize our virtual resolution
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
      vsync = true,
      fullscreen = false,
      resizable = true
  })

  love.keyboard.keysPressed = {}
  love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end


-- Should move a lot of this into a GameController.lua file
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'f11' then
      fullscreen = not fullscreen
      love.window.setFullscreen(fullscreen, fstype)
      love.resize(love.graphics.getDimensions())
    end

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
    Timer.update(dt)
    World:update(dt)
    Map:updateEntities(dt)
    hero:update(dt)
    GUI:update(dt)
    HeroCam:setPosition(hero.body_center_x, hero.body_center_y - VIRTUAL_WIDTH/ 4)
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()

    love.graphics.setFont(gFonts['medium'])
    love.graphics.draw(background, 0, 0, 0, 2, 2)
    Map.tiled_map:draw(-HeroCam.x, -HeroCam.y, 1, 1)

    HeroCam:apply()
    Map:renderEntities()
    hero:render()
    HeroCam:clear()

    GUI:render()

    push:finish()
end

function beginContact(a, b, collision)
  if Coin:beginContact(a, b, collision) then return end
  if End:beginContact(a, b, collision) then return end
  if Spike:beginContact(a, b, collision) then return end
  Ogre:beginContact(a, b, collision)
  hero:beginContact(a, b, collision)
end

function endContact(a, b, collision)
  hero:endContact(a, b, collision)
end
