Player = Class:extend()

-- Private

local window_width = love.graphics.getWidth()
local window_height = love.graphics.getHeight()

local function checkWindowCollision(self)
    if self.x < 0 then
        self.x = 0
    elseif self.x > window_width - self.width then
        self.x = window_width - self.width
    end

    if self.y < 0 then
        self.y = 0
    elseif self.y > window_height - self.height then
        self.y = window_height - self.height
    end
end

Timer = 5

-- public

function Player:new(x, y, _speed, _health)
    self.x = x
    self.y = y
    self.image = love.graphics.newImage("/assets/sprites/playerShip1_blue.png")
    self.speed = _speed or 100
    self.health = _health or 3
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.lasersfx = love.audio.newSource("/assets/audio/laserSmall_001.ogg", "stream")
    self.lasersfx:setVolume(0.2)

    self.targetpoint = { Target(self.x, self.y), Target(self.x + self.width - 10, self.y) }
    self.pointoffset = 10
end

function Player:keypressed(key)
    if key == "space" and self.health > 0 then
        love.audio.play(self.lasersfx)
        table.insert(ListOfBullets, Bullet(self.targetpoint[1].x, self.targetpoint[1].y, Bullet_Speed))
        table.insert(ListOfBullets, Bullet(self.targetpoint[2].x, self.targetpoint[2].y, Bullet_Speed))
    end
    if key == "tab" and self.health <= 0 then
        love.audio.stop(background_music)
        MenuState = true
        GameplayState = false
        love.load()
    end
end

function Player:update(dt)
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown("right") then
        self.x = self.x + self.speed * dt
    end

    self.targetpoint[1].x = self.x
    self.targetpoint[1].y = self.y
    self.targetpoint[2].x = self.x + self.width - self.pointoffset
    self.targetpoint[2].y = self.y

    Timer = Timer - dt

    checkWindowCollision(self)
end

function Player:CheckCollision(obj)
    local self_left = self.x
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y + self.height

    local obj_left = obj.x
    local obj_right = obj.x + obj.width
    local obj_top = obj.y
    local obj_bottom = obj.y + obj.height

    if self_left < obj_right and
        self_right > obj_left and
        self_top < obj_bottom and
        self_bottom > obj_top then
        if Timer <= 0 then
            player.health = player.health - 1
            Timer = 2.75
        end
    end
end

function Player:draw()
    if self.health > 0 then
        love.graphics.draw(self.image, self.x, self.y)
        
        love.graphics.print("Lives: " .. self.health, window_width - 145, window_height - 50)
    end

    if self.health <= 0 then
        love.graphics.print("DEAD!", (window_width / 2) - 30, (window_height / 2) - 50)
        love.graphics.print("Press Tab to Retry!", (window_width / 2) - 150, window_height / 2)
    end
end
