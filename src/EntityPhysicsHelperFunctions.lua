function initializeStaticPhysicsBodyShapeAndFixture()
  self.physics.body = love.physics.newBody(World, self.center_x, self.center_y, 'static')
  self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end

function initializeDynamicPhysicsBodyShapeAndFixture()
  self.physics.body = love.physics.newBody(World, self.center_x, self.center_y, 'dynamic')
  self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end

function additionalPhysicsProperties()
  local physics = {}
  -- Situational...
  physics.body:setFixedRotation(true)
  physics.body:setGravityScale(0)
  physics.fixture:setUserData('Hero')
  physics.fixture:setSensor(true)
  physics.body:setMass(0.5)
  return physics
end
