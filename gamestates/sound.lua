local LEDsController = require "lib.LEDsController.LEDsController"
local upack = LEDsController.upack

local sound = {}

function sound:init() -- Called once, and only once, before entering the state the first time
end

function sound:enter(previous) -- Called every time when entering the state
	devices = love.audio.getRecordingDevices()
	for k,v in ipairs(devices) do
		print(
			k,
			-- v,
			v:getName(),
			v:getSampleCount(),
			v:getSampleRate(),
			v:getChannelCount(),
			v:getBitDepth(),
			v:getData()
		)
	end

	devices[1]:start(8000)

end

function sound:leave() -- Called when leaving a state.
end

function sound:resume() -- Called when re-entering a state by Gamestate.pop()
end

function sound:update(dt)
	local data = devices[1]:getData()
end

function sound:draw()
end

function sound:focus(focus)
end

function sound:quit()
end



function sound:keypressed(key, scancode)
end

function sound:mousepressed(x,y, mouse_btn)
end

function sound:joystickpressed(joystick, button )
end

return sound
