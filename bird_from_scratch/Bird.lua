--[[
    Bird Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Bird is what we control in the game via clicking or the space bar; whenever we press either,
    the bird will flap and go up a little bit, where it will then be affected by gravity. If the bird hits
    the ground or a pipe, the game is over.
]]

Bird = Class{}
local anim8 = require 'anim8'

local GRAVITY = 20*(60/400)
local flyingImage, animation

function Bird:init()
    -- load bird image from disk and assign its width and height
    self.image = love.graphics.newImage('assets/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    flyingImage = love.graphics.newImage('assets/animatedbird.png')
    local g = anim8.newGrid(self.width, self.height, flyingImage:getWidth(), flyingImage:getHeight())
    animation = anim8.newAnimation(g('1-6',1), 0.01)

    -- position bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- Y velocity; gravity
    self.dy = 0
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values.
]]
function Bird:collides(pipe)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 4) + (self.width - 4) >= pipe.x and self.x + 4 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt)
    -- apply gravity to velocity
    self.dy = self.dy + GRAVITY * dt
    

    -- add a sudden burst of negative gravity if we hit space
    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        sounds['jump']:play()
        self.dy = -5*(60/450)
    end

    -- apply current velocity to Y position
    self.y = self.y + self.dy
    if(self.dy < 0) then
        animation:update(dt)
    end
end

function Bird:render()
    if(self.dy > 0) then
        love.graphics.draw(self.image, self.x, self.y)
    else
        animation:draw(flyingImage, self.x, self.y)
    end
end
