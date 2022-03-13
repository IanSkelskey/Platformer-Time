local Map = {}

function Map:load()
    self.currentLevel = 1
    self:init()
end

function Map:init()

  World = love.physics.newWorld(0,2000)
  World:setCallbacks(beginContact, endContact)

  self.tiled_map = STI('maps/levels/'..self.currentLevel..'.lua', {'box2d'})
  self.tiled_map:box2d_init(World)
  self.tiled_map.layers.Solids.visible = false
  self.tiled_map.layers.Entities.visible = false
  MapWidth = self.tiled_map.layers.ground.width * 16

  self:spawnEntities()
end

function Map:updateEntities(dt)
  Coin:updateAll(dt)
  Spike:updateAll(dt)
  Stone:updateAll(dt)
  Ogre:updateAll(dt)
  End:updateAll(dt)
end

function Map:renderEntities()
  Coin:renderAll()
  Spike:renderAll()
  Stone:renderAll()
  Ogre:renderAll()
  End:renderAll()
end

function Map:next()
  self:clean()
  self.currentLevel = self.currentLevel + 1
  self:init()
end

function Map:clean()
  self.tiled_map:box2d_removeLayer("Solids")
  Coin:removeAll()
  Ogre:removeAll()
  Stone:removeAll()
  Spike:removeAll()
  End:removeAll()
end

function Map:spawnEntities()

  for i, v in ipairs(self.tiled_map.layers.Entities.objects) do
    if v.type == 'hero_spawn' then
      hero = Hero(v.x, v.y)
      heroController = NewHeroController(hero)
      heroPhysics = NewHeroPhysics(hero)
    end
  end

  for i, v in ipairs(self.tiled_map.layers.Entities.objects) do
    if v.type == 'ogre' then
      Ogre(v.x, v.y)
    end
  end

  for i, v in ipairs(self.tiled_map.layers.Entities.objects) do
    if v.type == 'end' then
      End(v.x, v.y)
    end
  end

  for i, v in ipairs(self.tiled_map.layers.Entities.objects) do
    if v.type == 'coin' then
      Coin(v.x, v.y)
    end
  end

  for i, v in ipairs(self.tiled_map.layers.Entities.objects) do
    if v.type == 'spike' then
      Spike(v.x, v.y)
    end
  end

  for i, v in ipairs(self.tiled_map.layers.Entities.objects) do
    if v.type == 'stone' then
      Stone(v.x, v.y)
    end
  end

end

return Map
