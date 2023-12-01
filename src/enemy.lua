Enemy = Class:extend()

local window_height = love.graphics.getHeight()


function Enemy:new(x, y, _speed, _health, img)
    self.x = x
    self.y = y
    self.speed = _speed
    self.health = _health
    self.image = img
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.pointsgiven = 1
end

local function checkWindowCollision(self)
    if self.y < 0 then
        self.y = 0
    elseif self.y > window_height then
        self.y = 0
    end
end

function Enemy:update(dt)
    self.y = self.y + self.speed * dt
    Timer = Timer - dt

    checkWindowCollision(self)
end

function Enemy:CheckCollision(player)
    local self_left = self.x
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y + self.height

    local object_left = player.x
    local object_right = player.x + player.width
    local object_top = player.y
    local object_bottom = player.y + player.height

    if self_left < object_right and
        self_right > object_left and
        self_top < object_bottom and
        self_bottom > object_top then

    end
end

function Enemy:draw()
    love.graphics.draw(self.image, self.x, self.y)
end
