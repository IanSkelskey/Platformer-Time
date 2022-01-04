--[[
    Hero Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    The hero is the controllable character in a platformer.
]]

Hero = Class{}

-- Constants that define a hero
local HERO_SPEED = 100
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
    self.dy = 0

    self.state = 'idle'
    self.direction = 1  -- to the right

    idle_animation = newAnimation(love.graphics.newImage("images/finn_idle.png"), 32, 32, 2.5)
    run_animation = newAnimation(love.graphics.newImage("images/finn_run.png"), 32, 32, 1)
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




      if self.y > VIRTUAL_HEIGHT - 40 then
        self.dy = 0
        self.y = VIRTUAL_HEIGHT - 40
      else
        self.dy = self.dy + GRAVITY * dt
      end

    if love.keyboard.wasPressed('space') then
      self.state = 'jump'
        self.dy = -4
    elseif love.keyboard.isDown('right') then
      self.state = 'run'
      self.direction = 1
        self.x = self.x + HERO_SPEED*dt
        updateAnimation(run_animation, dt)
    elseif love.keyboard.isDown('left') then
      self.state = 'run'
      self.direction = -1
        self.x = self.x - HERO_SPEED*dt
        updateAnimation(run_animation, dt)
    else
      -- No input means idle character
      self.state = 'idle'
      updateAnimation(idle_animation, dt)

    end

    self.y = self.y + self.dy
end

function Hero:render()
  if self.state == 'idle' then
    renderAnimation(idle_animation, self.x, self.y, self.direction)
  elseif self.state == 'run' then
    renderAnimation(run_animation, self.x, self.y, self.direction)
  end
end

-- newAnimation() from https://love2d.org/wiki/Tutorial:Animation
function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end


function renderAnimation(animation, x, y, direction)
  if direction == -1 then
    x = x + 32
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
