io.stdout:setvbuf('no')

GameplayState = false
MenuState = true

function love.load()
    if arg[#arg] == "vsc_debug" then require("lldebugger").start() end
    love.window.setTitle("Space-Strike_Game-Off-23")
    love.window.setMode(600, 920)
    math.randomseed(os.time())

    font = love.graphics.newFont("/assets/fonts/Kenney Blocks.ttf", 25)
    love.graphics.setFont(font)


    Class = require "/libs/classic-master/classic"
    require "/src/player"
    require "/src/enemy"
    require "/src/bigenemy"
    require "/src/bullet"
    require "/src/targetpoint"
    require "/src/Spawner"
    require "/src/enemybullet"
    Background = love.graphics.newImage("/assets/sprites/darkpurple.png")
    Background_Speed = 1000
    Background_y = 0


    Spawn = 2
    Wave = 0

    Difficulty_Scale = 1
    FirstWave = true

    local player_health = 5
    local player_speed = 450
    Player_Score = 0

    player = Player(love.graphics.getWidth() / 2, love.graphics.getHeight(),
        player_speed, player_health)



    Enemies_Images = { love.graphics.newImage("/assets/sprites/enemyBlack1.png"), love.graphics.newImage(
        "/assets/sprites/enemyBlack2.png"), love.graphics.newImage("/assets/sprites/enemyBlack3.png") }

    Bullet_Speed = 1600
    Enemies = {}
    ListOfBullets_Enemies = {}


    ListOfBullets = {}

    background_music = love.audio.newSource("/assets/audio/POL-crime-fighter-short.wav", 'stream')
    background_music:setVolume(0.06)
    background_music:setLooping(true)
    love.audio.play(background_music)
end

function love.keypressed(key)
    if MenuState and key == "space" then
        GameplayState = true
        MenuState = false
    else
        player:keypressed(key)
    end
end

function love.update(dt)
    if GameplayState then
        if player.health > 0 then
            player:update(dt)
        end
        local next = next

        if next(Enemies) == nil then
            for i = 1, Spawn, 1 do
                if math.random(1, Difficulty_Scale) % 2 == 0 then
                    table.insert(Enemies,
                        BigEnemy(math.random(0, love.graphics.getWidth() - Enemies_Images[3]:getWidth()),
                            math.random(0, love.graphics.getHeight() / 2), 300, 5, Enemies_Images[3]))
                else
                    table.insert(Enemies,
                        Enemy(math.random(0, love.graphics.getWidth() - Enemies_Images[1]:getWidth()), 0, 500, 1,
                            Enemies_Images[1]))
                end
            end
            if Wave % 2 and Spawn ~= 10 then
                Spawn = Spawn + 1
            end
            Wave = Wave + 1
        end

        for index, e in ipairs(Enemies) do
            e:update(dt)
            player:CheckCollision(e)
            if e.health <= 0 then
                table.remove(Enemies, index)
                Player_Score = Player_Score + e.pointsgiven
            end
        end

        for index, bullet in ipairs(ListOfBullets) do
            bullet:update(dt)
            bullet:CheckCollision(Enemies)

            if bullet.y < 0 or bullet.dead then
                table.remove(ListOfBullets, index)
            end
        end

        for index, enemy_bullet in ipairs(ListOfBullets_Enemies) do
            enemy_bullet:update(dt)
            enemy_bullet:CheckCollision(player)

            if enemy_bullet.dead or enemy_bullet.y < 0 then
                table.remove(ListOfBullets_Enemies, index)
            end
        end

        Background_y = Background_y + Background_Speed * dt
        if Background_y >= Background:getHeight() then
            Background_y = 0
        end


        if Player_Score % 2 == 0 then
            Difficulty_Scale = Difficulty_Scale + 2
        end
    end
end

function love.draw()
    -- Draw Background image
    for x = 0, love.graphics.getWidth() / Background:getWidth() do
        for y = 0, love.graphics.getHeight() / Background:getHeight() do
            love.graphics.draw(Background, x * Background:getWidth(), y * Background:getHeight())
            love.graphics.draw(Background, x * Background:getWidth(),
                (y * Background:getHeight()) + Background_y - Background:getHeight())
        end
    end

    if GameplayState then
        -- Draw objects above background
        for index, e in ipairs(Enemies) do
            e:draw()
        end
        player:draw()
        for index, bullet in ipairs(ListOfBullets) do
            bullet:draw()
        end
        for index, enemy_bullet in ipairs(ListOfBullets_Enemies) do
            enemy_bullet:draw()
        end

        love.graphics.print("Score:" .. tostring(Player_Score))
        love.graphics.print("Wave:" .. tostring(Wave), 0, 25)
    else
        love.graphics.print("Space Strike", (love.graphics.getWidth() / 2) - 100, love.graphics.getHeight() / 2)
        love.graphics.print("Press spacebar to start!", (love.graphics.getWidth() / 2) - 200,
            (love.graphics.getHeight() / 2) + 50)
    end
end
