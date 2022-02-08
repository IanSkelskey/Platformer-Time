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
  self.hearts.scale = 2
  self.hearts.x = VIRTUAL_WIDTH - 24
  self.hearts.y = 8
end

function HUD:render()
  self:displayCoins()
  self:displayHealth()
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
  love.graphics.setColor(0,0,0,0.25)
  love.graphics.draw(self.hearts.image, self.hearts.x + 1, self.hearts.y + 1, 0, self.hearts.scale, self.hearts.scale)
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(self.hearts.image, self.hearts.x, self.hearts.y, 0, self.hearts.scale, self.hearts.scale)
end
