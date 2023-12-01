BigEnemy = Class:extend()

local window_width = love.graphics.getWidth()
RemainingTime = 1.5
Fire = false

function BigEnemy:new(x, y, _speed, _health, img)
    self.x = x
    self.y = y
    self.speed = _speed
    self.health = _health
    self.image = img
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.pointsgiven = 5
end

local function checkWindowCollision(self)
    if self.x < 0 then
        self.x = 0
        self.speed = -self.speed
    elseif self.x > window_width - self.image:getWidth() then
        self.x = window_width - self.image:getWidth()
        self.speed = -self.speed
    end
end

function BigEnemy:update(dt)
    self.x = self.x + self.speed * dt

    RemainingTime = RemainingTime - dt
    if RemainingTime <= 0 then
        Fire = true
    end
    if Fire then
        table.insert(ListOfBullets_Enemies, EnemyBullet(self.x, self.y, 400))
        Fire = false
        RemainingTime = 1.5
    end

    checkWindowCollision(self)
end

function BigEnemy:draw()
    love.graphics.draw(self.image, self.x, self.y)
end
