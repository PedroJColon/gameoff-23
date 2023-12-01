Bullet = Class:extend()

function Bullet:new(x, y, _speed)
    self.x = x or 0
    self.y = y or 0
    self.speed = _speed or 500
    self.image = love.graphics.newImage("/assets/sprites/laserBlue01.png")

    -- Collision Checking
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Bullet:update(dt)
    self.y = self.y - self.speed * dt
end

function Bullet:CheckCollision(obj)
    for index, object in ipairs(obj) do
        local self_left = self.x
        local self_right = self.x + self.width
        local self_top = self.y
        local self_bottom = self.y + self.height

        local object_left = object.x
        local object_right = object.x + object.width
        local object_top = object.y
        local object_bottom = object.y + object.height

        if self_left < object_right and
            self_right > object_left and
            self_top < object_bottom and
            self_bottom > object_top then
            self.dead = true
            local hitSfx = love.audio.newSource("/assets/audio/hit1.ogg", "stream")
            hitSfx:setVolume(0.025)
            love.audio.play(hitSfx)
            object.health = object.health - 1
        end
    end
end

function Bullet:draw()
    love.graphics.draw(self.image, self.x, self.y)
end
