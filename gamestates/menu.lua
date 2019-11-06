local menu = {}

function rgb(r,g,b)
	return r/255, g/255, b/255
end

function menu:draw_button(y,txt)
	local lx = love.graphics.getWidth()
	local button_w = self.button:getWidth()

	love.graphics.setColor(1,1,1)
	love.graphics.draw(self.button, lx/2 - button_w/2, y)
	love.graphics.setColor(rgb(150,115,0))
	love.graphics.printf(txt, lx/2 - button_w/2, y+13, button_w, "center")
end

function menu:init() -- Called once, and only once, before entering the state the first time
	self.button = love.graphics.newImage("ressource/Image/button.png")
	self.button:setFilter("nearest","nearest")
	self.font = love.graphics.newFont("ressource/Font/kenvector_future.ttf", 40)
	love.graphics.setFont(self.font)
	self.font:setFilter( "nearest", "nearest")

	self.bg = love.graphics.newVideo("ressource/video/bg.ogv")
	self.bg:play()
end

function menu:enter(previous) -- Called every time when entering the state
end

function menu:leave() -- Called when leaving a state.
end

function menu:resume() -- Called when re-entering a state by Gamestate.pop()
end

function menu:update(dt)
	if not self.bg:isPlaying() then self.bg:rewind() end
end

function menu:draw()
	local lx = love.graphics.getWidth()

	love.graphics.setColor(0.3,0.3,0.3)
	love.graphics.draw(self.bg, 0, 0, 0, 0.3, 1)

	self:draw_button(300, "Stream")
	self:draw_button(450, "Test")
	self:draw_button(600, "Test2")

end

function menu:focus(focus)
end

function menu:quit()
end



function menu:keypressed(key, scancode)
end

function menu:mousepressed(x,y, mouse_btn)
	local lx = love.graphics.getWidth()
	local button_w = self.button:getWidth()
	local button_h = self.button:getHeight()

	if x > lx/2 - button_w/2 and x < lx/2 + button_w/2
	and y > 300 and y < 300 + button_h
	then
		Gamestate.push(states.stream, 64, 8, "BRO888", ip, port)
	end
end

function menu:joystickpressed(joystick, button )
end

return menu
