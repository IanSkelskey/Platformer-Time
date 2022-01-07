--[[
    Hero Class
    Author: Ian Skelskey
    ianskelskey@gmail.com

    The hero is the controllable character in a platformer.
    A hero can:
      - idle
      - walk
      - run
      - jump
      - skid
      - spin
      - attack
      - die
      - hurt
]]

Hero = Class{}

-- Constants that define a hero
-- Physics constants
local WALK_SPEED = 40
local RUN_SPEED = 80
local JUMP_SPEED = -4.5
local GRAVITY = 20
-- Collision boundaries
local BOUNDING_WIDTH = 12
local BOUNDING_HEIGHT = 16

function Hero:init()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    -- self.image = gCharFrames['finn'][1]
    self.x = VIRTUAL_WIDTH / 2 - 16
    self.y = VIRTUAL_HEIGHT / 2 - 16

    self.width = 32
    self.height = 32

    self.current_frame = 1
    -- self.dx = 0
    -- self.dy = 0

    self.speeds = {dx = 0, dy = 0}

    -- Player starts in an idle state and facing to the right
    self.state = 'idle'
    self.direction = 1  -- to the right

    -- Table that stores animations consider reorganizing
    --  - Store in a single sprite sheet and slice with quads (see Util.lua)
    self.animations = {
      ['idle'] = newAnimation(love.graphics.newImage("images/finn_idle.png"), 32, 32, 2.5),
      ['walk'] = newAnimation(love.graphics.newImage("images/finn_walk.png"), 32, 32, .7),
      ['run'] = newAnimation(love.graphics.newImage("images/finn_run.png"), 32, 32, .7),
      ['jump'] = newAnimation(love.graphics.newImage("images/finn_jump.png"), 32, 32, 1),
      -- ['jump-anticip'] = newAnimation(love.graphics.newImage("images/finn_jump_anticip.png"), 32, 32, .07),
      ['attack'] = newAnimation(love.graphics.newImage("images/finn_attack.png"), 32, 32, .5),
      ['hurt'] = newAnimation(love.graphics.newImage("images/finn_hurt.png"), 32, 32, .3),
      ['death'] = newAnimation(love.graphics.newImage("images/finn_death.png"), 32, 32, .7),
      ['skid'] = newAnimation(love.graphics.newImage("images/finn_turn.png"), 32, 32, .4),      -- CHANGE SKID: tween to top speed when you press the run button and only skid from top speed
                                                                                                -- Something like this: Timer.tween(1, self.speeds, {dx = RUN_SPEED}, 'quad', function() self.speeds.dx = RUN_SPEED end)
                                                                                                -- Needs to only happen once, not continuously e.g. wasPressed not isDown
      ['spin'] = newAnimation(love.graphics.newImage("images/finn_spin.png"), 32, 32, .7),
      ['turning'] = newAnimation(love.graphics.newImage("images/finn_midturn.png"), 32, 32, .2)
    }

    self.sounds = {
      ['jump'] = love.audio.newSource('sounds/jump.wav', 'static')
    }

end

function Hero:update(dt)

      -- Update global timer found in dependencies. This is used for timing and tweening
      Timer.update(dt)

    -- Temporary way to stop at floor of 'level'
    -- need to define actual collision
      if self.y > VIRTUAL_HEIGHT - 40 then -- Below the ground
        self.speeds.dy = 0
        self.y = VIRTUAL_HEIGHT - 40
      elseif self.y == VIRTUAL_HEIGHT - 40 then -- On the ground
        self.speeds.dy = 0
      else
        -- Apply gravity always
        self.speeds.dy = self.speeds.dy + GRAVITY * dt -- Above the ground (room to fall)
      end

      -- Update x position based on dx and dt
      self.x = self.x + self.speeds.dx*dt

      -- If not moving or attacking Hero is in the idle state
      if self.speeds.dx == 0 and self.speeds.dy == 0 and self.state ~= 'attack' then
        self.state = 'idle'
      end

    -- Keyboard input logic

    -- Press 'Up' to jump!
    if love.keyboard.wasPressed('up') then
      self.sounds['jump']:stop()
      if self.state ~= 'double-jump' then -- Can only jump twice
        if self.state == 'jump' then
          self.state = 'double-jump'
        else
          self.state = 'jump'
        end
        self.sounds['jump']:play()
        self.speeds.dy = JUMP_SPEED
      end
    end

    -- Use the arrow keys to move right and left
    if love.keyboard.isDown('right') then
      local wait = 0
      if self.state ~= 'skid' then
        if self.direction == -1 then
          self.state = 'turning'
          wait = .07
        end
      end
      Timer.after(wait, function()
        if self.state ~= 'skid' then
          if not love.keyboard.isDown('r') then
            self.speeds.dx = WALK_SPEED
            if self.speeds.dy == 0 then
              self.state = 'walk'
            end
            self.direction = 1
          else
            self.speeds.dx = RUN_SPEED
            if self.speeds.dy == 0 then
              self.state = 'run'
            end
            self.direction = 1
          end
        end
      end)


    elseif love.keyboard.isDown('left') then
      local wait = 0
      if self.state ~= 'skid' then
        if self.direction == 1 then
          self.state = 'turning'
          wait = .07
        end
      end
      Timer.after(wait, function()
        if self.state ~= 'skid' then
          if not love.keyboard.isDown('r') then

            self.speeds.dx = -WALK_SPEED
            if self.speeds.dy == 0 then
              self.state = 'walk'
            end
            self.direction = -1
          else
            self.speeds.dx = -RUN_SPEED
            if self.speeds.dy == 0 then
              self.state = 'run'
            end
            self.direction = -1
          end
        end
      end)
    else
      --self.speeds.dx = 0
    end

    -- Attack with 'space'
    if love.keyboard.wasPressed('space') then
      if self.state ~= 'attack' then
        self.state = 'attack'
        Timer.after(.5, function() self.state = 'idle' end)
      end
    end

    -- Test buttons for remaining Animations
    if love.keyboard.isDown('h') then
      self.state = 'hurt'
    elseif love.keyboard.isDown('d') then
      self.state = 'death'
    elseif love.keyboard.isDown('s') then
      self.state = 'spin'
    end

    self.y = self.y + self.speeds.dy

    -- Key released function. Used only for skidding out of run at the moment
    function love.keyreleased(key)
      if key == 'right' then
        if self.state == 'run' and self.direction == 1 then
          self.state = 'skid'
        end
        Timer.tween(.4, self.speeds, {dx = 0}, 'quad', function() self.speeds.dx = 0 end)
      elseif key == 'left' then
        if self.state == 'run' and self.direction == -1 then
          self.state = 'skid'
        end
        Timer.tween(.4, self.speeds, {dx = 0}, 'quad', function() self.speeds.dx = 0 end)
      end
    end

    -- Deciedes on animation based on player state.
    -- Condense this into a function that accepts states

    if self.state == 'idle' then
      updateAnimation(self.animations['idle'], dt)
    elseif self.state == 'walk' then
      updateAnimation(self.animations['walk'], dt)
    elseif self.state == 'run' then
      updateAnimation(self.animations['run'], dt)
    elseif self.state == 'turning' then
      updateAnimation(self.animations['turning'], dt)
    elseif self.state == 'jump' or self.state == 'double-jump' then
      updateAnimation(self.animations['jump'], dt)
    elseif self.state == 'jump-anticip' then
      updateAnimation(self.animations['jump-anticip'], dt)
    elseif self.state == 'attack' then
      updateAnimation(self.animations['attack'], dt)
    elseif self.state == 'hurt' then
      updateAnimation(self.animations['hurt'], dt)
    elseif self.state == 'death' then
      updateAnimation(self.animations['death'], dt)
    elseif self.state == 'skid' then
      updateAnimation(self.animations['skid'], dt)
    elseif self.state == 'spin' then
    updateAnimation(self.animations['spin'], dt)
    end
end


-- Renders player based on state

function Hero:render()
  if self.state == 'idle' then
    renderAnimation(self.animations['idle'], self.x, self.y, self.direction)
  elseif self.state == 'walk' then
    renderAnimation(self.animations['walk'], self.x, self.y, self.direction)
  elseif self.state == 'run' then
    renderAnimation(self.animations['run'], self.x, self.y, self.direction)
  elseif self.state == 'turning' then
    renderAnimation(self.animations['turning'], self.x, self.y, self.direction)
  elseif self.state == 'jump' or self.state == 'double-jump' then
    renderAnimation(self.animations['jump'], self.x, self.y, self.direction)
  elseif self.state == 'jump-anticip' then
    renderAnimation(self.animations['jump-anticip'], self.x, self.y, self.direction)
  elseif self.state == 'attack' then
    renderAnimation(self.animations['attack'], self.x, self.y, self.direction)
  elseif self.state == 'hurt' then
    renderAnimation(self.animations['hurt'], self.x, self.y, self.direction)
  elseif self.state == 'death' then
    renderAnimation(self.animations['death'], self.x, self.y, self.direction)
  elseif self.state == 'skid' then
    renderAnimation(self.animations['skid'], self.x, self.y, self.direction)
  elseif self.state == 'spin' then
    renderAnimation(self.animations['spin'], self.x, self.y, self.direction)
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
    x = x + animation.frame_width - 5
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

--[[
    Unused and fragmented code. For future use or deletion
]]

--[[
    AABB collision that expects a tile, which will have an X, Y, WIDTH & HEIGHT
    Pulled straight from flappy bird. Needs reworking for platformer gameplay
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


-- Place holders for player action functions... we will see
function Hero:walks(direction)

end

function Hero:runs(direction)

end

function Hero:jumps()

end
