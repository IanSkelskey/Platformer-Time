--[[
  Animation

  Contains useful functions for sprite animation.
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
  -- slight adjustment for off center sprite... this will need to change
  -- consider adding parameter for offset to replace the hardcoded 4
  if direction == -1 then
    x = x + animation.frame_width - 4
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
