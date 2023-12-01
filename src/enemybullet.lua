EnemyBullet = Class:extend()

function EnemyBullet:new(x, y, _speed)
    self.x = x
    self.y = y
    self.speed = _speed
    self.image = love.graphics.newImage("/assets/sprites/laserRed01.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function EnemyBullet:update(dt)
    self.y = self.y + self.speed * dt
end

function EnemyBullet:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function EnemyBullet:CheckCollision(player)
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
        self.dead = true
        player.health = player.health - 1
    end
end
