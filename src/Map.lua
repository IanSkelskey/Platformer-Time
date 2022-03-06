local Map = {}

function Map:load()
    self.currentLevel = 1



    self:init()
end

function Map:init()
  World = love.physics.newWorld(0,2000)
  World:setCallbacks(beginContact, endContact)

  -- Create Level.lua to describe levels: name, place in sequence.. etc
  self.level = STI('maps/levels/'..self.currentLevel..'.lua', {'box2d'})
  self.level:box2d_init(World)
  self.level.layers.Solids.visible = false
  self.level.layers.Entities.visible = false
  MapWidth = self.level.layers.ground.width * 16

  self:spawnEntities()
end

function Map:next()
  self:clean()
  self.currentLevel = self.currentLevel + 1
  self:init()
end

function Map:clean()
  self.level:box2d_removeLayer("Solids")
  Coin:removeAll()
  Enemy:removeAll()
  Stone:removeAll()
  Spike:removeAll()
  End:removeAll()
end

function Map:spawnEntities()

  for i, v in ipairs(self.level.layers.Entities.objects) do
    if v.type == 'hero_spawn' then
      hero = Hero(v.x, v.y)
      heroController = NewHeroController(hero)
      heroPhysics = NewHeroPhysics(hero)
    end
  end

  for i, v in ipairs(self.level.layers.Entities.objects) do
    if v.type == 'enemy' then
      Enemy(v.x, v.y)
    end
  end

  for i, v in ipairs(self.level.layers.Entities.objects) do
    if v.type == 'end' then
      End(v.x, v.y)
    end
  end

  for i, v in ipairs(self.level.layers.Entities.objects) do
    if v.type == 'coin' then
      Coin(v.x, v.y)
    end
  end

  for i, v in ipairs(self.level.layers.Entities.objects) do
    if v.type == 'spike' then
      Spike(v.x, v.y)
    end
  end

  for i, v in ipairs(self.level.layers.Entities.objects) do
    if v.type == 'stone' then
      Stone(v.x, v.y)
    end
  end

end

return Map
