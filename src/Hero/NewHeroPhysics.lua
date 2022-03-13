NewHeroPhysics = Class{}

local GRAVITY = 1000

local controlled = nil

function NewHeroPhysics:init(char)
  controlled = char
end

function NewHeroPhysics:update(dt)
  controlled.body_center_x, controlled.body_center_y = controlled.physics.body:getPosition()
  controlled.physics.body:setLinearVelocity(controlled.speeds.dx, controlled.speeds.dy)

  if not controlled.grounded then self:applyGravity(dt) else controlled.speeds.dy = 0 end
end

function NewHeroPhysics:applyGravity(dt)
  controlled.speeds.dy = controlled.speeds.dy + GRAVITY * dt -- Above the ground (room to fall)
end
