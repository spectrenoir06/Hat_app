local LEDsController = require "lib.LEDsController.LEDsController"
local upack = LEDsController.upack

local stream = {}

function load_anim(name)

	local lx = 64
	local ly = 8

	local t = {}
	local anim_data = love.filesystem.read(name)
	local _, type, fps, nb_led = upack(anim_data, "BHH")

	print("Load animation:", name, type, fps, nb_led)

	local prev = 6
	t = {
		type = type,
		fps = fps,
		nb_led,
		data = {},
		frame = {}
	}

	local ctn = 1
	while(#anim_data - prev >= 0) do
		t.data[ctn] = {}
		for i=0,nb_led-1 do
			-- print(i)
			_,r,g,b = upack(anim_data, "BBB", prev)
			t.data[ctn][(i)%512+1] = {r,g,b}
			prev = prev + 3
		end
		-- controller.leds = t.data[ctn]
		-- controller:dump()
		ctn = ctn + 1
	end
	t.nb_frame = ctn

	for i=1, t.nb_frame do
		local ctn = 1
		local data = t.data[(i%#t.data)+1]
		local img_data = love.image.newImageData(64, 8)
		for x=lx-1,0,-1 do
			if (x % 2 == 0) then
				for y = 0, ly-1 do
					img_data:setPixel((x+15)%64, y, data[ctn][1]/255, data[ctn][2]/255, data[ctn][3]/255)
					ctn = ctn + 1
				end
			else
				for y=ly-1,0,-1 do
					-- print(x,y,ctn, data[ctn])
					img_data:setPixel((x+15)%64, y, data[ctn][1]/255, data[ctn][2]/255, data[ctn][3]/255)
					ctn = ctn + 1
				end
			end
		end
		t.frame[i] = love.graphics.newImage(img_data)
		t.frame[i]:setFilter("nearest", "nearest")
		-- v.img:replacePixels(v.img_data)
	end
	return t
end

function stream:init() -- Called once, and only once, before entering the state the first time
end

function stream:enter(previous, lx, ly, protocol, ip, port) -- Called every time when entering the state
	self.timer		= 0
	self.timer_poll	= 5
	self.fps		= 25
	self.counter	= 0
	self.lx			= lx
	self.ly			= ly
	self.anim		= 0

	self.controller = LEDsController:new(lx * ly, protocol, ip, port)

	if not self.anims then
		self.anims = {}
		for k,v in ipairs(love.filesystem.getDirectoryItems("animation/")) do
			if v:match("[^.]+$") == "RGB888" then
				table.insert(self.anims, load_anim("animation/"..v))
				-- controller:start_dump("BRO888", v)
			end
		end
	end
end

function stream:leave() -- Called when leaving a state.
end

function stream:resume() -- Called when re-entering a state by Gamestate.pop()
end

function stream:update(dt)
	local anim = self.anims[self.anim+1]
	if self.timer > 1 / anim.fps then
		self.controller.leds = anim.data[(self.counter%#anim.data)+1]
		self.controller:send(0)
		self.counter = self.counter + 1
		self.timer = 0
	end

	if self.timer_poll > 5 then
		self.controller:sendArtnetPoll()
		self.timer_poll = 0
	end

	local receive_data, remote_ip, remote_port = self.controller.udp:receivefrom()
	if receive_data then
		self.controller:receiveArtnet(receive_data, remote_ip, remote_port)
	end
	self.timer = self.timer + dt
	self.timer_poll = self.timer_poll + dt
end

function stream:draw()
	local s = love.graphics.getWidth() / 64
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(love.timer.getFPS() ,10,30)
	for k,v in ipairs(self.anims) do
		-- print(k,v)
		if self.anim+1 == k then
			love.graphics.setColor(1, 1, 1)
		else
			love.graphics.setColor(.25, .25, .25)
		end
		love.graphics.draw(
			v.frame[(self.counter%#v.data)+1],
			0,
			k*8*s + k*5,
			0,s,s
		);
	end
end

function stream:focus(focus)
end

function stream:quit()
end



function stream:keypressed(key, scancode)
end

function stream:mousepressed(x,y, mouse_btn)
	local s = love.graphics.getWidth() / 64
	local p = y / (8*s+5)-1
	-- print(p)
	self.anim = math.floor(p)

	if self.anim > #self.anims - 1 then
		self.anim = #self.anims - 1
	end
	if self.anim < 0 then
		self.anim = 0
	end
end

function stream:joystickpressed(joystick, button )
end

return stream
