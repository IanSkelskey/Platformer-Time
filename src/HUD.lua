HUD = Class{}

local controlled = nil

function HUD:init(char)
  controlled = char
  self.coins = self:setupCoins()
  self.hearts = self:setupHearts()
end

function HUD:render()
  self:displayCoins()
  self:displayHearts()
  self:displayScore()

end

function HUD:update(dt)

end

function HUD:setupCoins()
  local coins = {}

  coins.image = love.graphics.newImage("assets/images/jakoin_front.png")
  coins.width = coins.image:getWidth()
  coins.height = coins.image:getHeight()
  coins.scale = 1
  coins.y = 8
  coins.x = 8

  return coins
end

function HUD:setupHearts()
  local hearts = {}

  hearts = {}
  hearts.image = love.graphics.newImage("assets/images/heart.png")
  hearts.width = hearts.image:getWidth()
  hearts.height = hearts.image:getHeight()
  hearts.scale = 1
  hearts.x = VIRTUAL_WIDTH
  hearts.y = 8
  hearts.spacing = hearts.width * hearts.scale * 2

  return hearts
end

function HUD:displayCoins()
  love.graphics.setColor(0,0,0,0.25)
  love.graphics.draw(self.coins.image, self.coins.x + 1, self.coins.y + 1, 0, self.coins.scale, self.coins.scale)
  love.graphics.print(" : "..hero.coins, self.coins.x + self.coins.width *self.coins.scale + 1, self.coins.y + 2)
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(self.coins.image, self.coins.x, self.coins.y, 0, self.coins.scale, self.coins.scale)
  love.graphics.print(" : "..hero.coins, self.coins.x + self.coins.width *self.coins.scale, self.coins.y + 1)
end

function HUD:displayHearts()
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
