--[[
    Hero Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    The hero is the controllable character in a platformer.
]]

Hero = Class{}

-- Constants that define a hero
local HERO_SPEED = 80
local GRAVITY = 20

function Hero:init()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    -- self.image = gCharFrames['finn'][1]
    self.x = VIRTUAL_WIDTH / 2 - 16
    self.y = VIRTUAL_HEIGHT / 2 - 16

    self.width = 32
    self.height = 32

    self.current_frame = 1
    self.dx = 0
    self.dy = 0

    self.state = 'idle'
    self.direction = 1  -- to the right

    self.animations = {
      ['idle'] = newAnimation(love.graphics.newImage("images/finn_idle.png"), 32, 32, 2.5),
      ['run'] = newAnimation(love.graphics.newImage("images/finn_run.png"), 32, 32, 1),
      ['jump'] = newAnimation(love.graphics.newImage("images/finn_jump.png"), 32, 32, 1)
    }

end


--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values.
]]
function Hero:collides(tile)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 2) + (self.width - 4) >= tile.x and self.x + 2 <= tile.x + tile.width then
        if (self.y + 2) + (self.height - 4) >= tile.y and self.y + 2 <= tile.y + object.height then
            return true
        end
    end

    return false
end

function Hero:walks(direction)

end

function Hero:runs(direction)

end

function Hero:jumps()

end

function Hero:update(dt)

    -- Temporary way to stop at floor of 'level'
      if self.y > VIRTUAL_HEIGHT - 40 then -- Below the ground
        self.dy = 0
        self.y = VIRTUAL_HEIGHT - 40
      elseif self.y == VIRTUAL_HEIGHT - 40 then -- On the ground
        self.dy = 0
      else
        self.dy = self.dy + GRAVITY * dt -- Above the ground (room to fall)
      end

      if self.dy < 0 then
        self.state = 'jump'
        updateAnimation(self.animations['jump'], dt)
      end

      if self.dx == 0 and self.dy == 0 then
        self.state = 'idle'
        updateAnimation(self.animations['idle'], dt)
      end

    -- Keyboard input logic
    if love.keyboard.wasPressed('up') then
      if self.state ~= 'jump' then -- Can only jump if you're not already jumping
        self.dy = -4
      end
    elseif love.keyboard.isDown('right') then
      self.dx = HERO_SPEED
      if self.dy == 0 then
        self.state = 'run'
      end
      self.direction = 1
        self.x = self.x + HERO_SPEED*dt
        updateAnimation(self.animations['run'], dt)
    elseif love.keyboard.isDown('left') then
      self.dx = -HERO_SPEED
      if self.dy == 0 then
        self.state = 'run'
      end
      self.direction = -1
        self.x = self.x - HERO_SPEED*dt
        updateAnimation(self.animations['run'], dt)
    else
      self.dx = 0

    end

    self.y = self.y + self.dy
end

function Hero:render()
  if self.state == 'idle' then
    renderAnimation(self.animations['idle'], self.x, self.y, self.direction)
  elseif self.state == 'run' then
    renderAnimation(self.animations['run'], self.x, self.y, self.direction)
  elseif self.state == 'jump' then
    renderAnimation(self.animations['jump'], self.x, self.y, self.direction)
  end
end

--[[
  Consider creating animate.lua to encapsulate the functionality below
    and separate it from Hero functions...
]]

-- newAnimation() from https://love2d.org/wiki/Tutorial:Animation
function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {}

    -- Added attributes for frame width and height
    -- This is used when mirroring sprites for changing direction
    animation.frame_width = width
    animation.frame_height = height

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end

-- Supplemental functions written by me and based on material from:
-- https://love2d.org/wiki/Tutorial:Animation
function renderAnimation(animation, x, y, direction)
  if direction == -1 then
    x = x + animation.frame_width
  end
  local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], x, y, 0, direction, 1)
end

function updateAnimation(animation, dt)
  animation.currentTime = animation.currentTime + dt
  if animation.currentTime >= animation.duration then
      animation.currentTime = animation.currentTime - animation.duration
  end
end
