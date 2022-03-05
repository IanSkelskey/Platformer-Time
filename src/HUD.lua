HUD = Class{}

function HUD:init()

  self.coins = {}
  self.coins.image = love.graphics.newImage("assets/images/jakoin_front.png")
  self.coins.width = self.coins.image:getWidth()
  self.coins.height = self.coins.image:getHeight()
  self.coins.scale = 1
  self.coins.x = 8
  self.coins.y = 8

  self.hearts = {}
  self.hearts.image = love.graphics.newImage("assets/images/heart.png")
  self.hearts.width = self.coins.image:getWidth()
  self.hearts.height = self.coins.image:getHeight()
  self.hearts.scale = 1
  self.hearts.x = VIRTUAL_WIDTH
  self.hearts.y = 8
  self.hearts.spacing = self.hearts.width * self.hearts.scale
end

function HUD:render()
  self:displayCoins()
  self:displayHealth()
  self:displayScore()
end

function HUD:update(dt)

end

function HUD:displayCoins()
  love.graphics.setColor(0,0,0,0.25)
  love.graphics.draw(self.coins.image, self.coins.x + 1, self.coins.y + 1, 0, self.coins.scale, self.coins.scale)
  love.graphics.print(" : "..hero.coins, self.coins.x + self.coins.width *self.coins.scale + 1, self.coins.y + 2)
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(self.coins.image, self.coins.x, self.coins.y, 0, self.coins.scale, self.coins.scale)
  love.graphics.print(" : "..hero.coins, self.coins.x + self.coins.width *self.coins.scale, self.coins.y + 1)
end

function HUD:displayHealth()
  for i = 1, hero.health.current do
    local x = self.hearts.x - (self.hearts.spacing) * i
    love.graphics.setColor(0,0,0,0.25)
    love.graphics.draw(self.hearts.image, x + 2, self.hearts.y + 2, 0, self.hearts.scale, self.hearts.scale)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.hearts.image, x, self.hearts.y, 0, self.hearts.scale, self.hearts.scale)
  end
end

function HUD:displayScore()
  love.graphics.setColor(0,0,0,0.25)
  love.graphics.print("Score : "..hero.score, 9, 33)
  love.graphics.setColor(1,1,1,1)
  love.graphics.print("Score : "..hero.score, 8, 32)
end
