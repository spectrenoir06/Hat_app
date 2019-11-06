local LEDsController = require "lib.LEDsController.LEDsController"
local upack = LEDsController.upack

local remote = {}

function remote:init() -- Called once, and only once, before entering the state the first time
end

function remote:enter(previous) -- Called every time when entering the state
end

function remote:leave() -- Called when leaving a state.
end

function remote:resume() -- Called when re-entering a state by Gamestate.pop()
end

function remote:update(dt)
end

function remote:draw()
end

function remote:focus(focus)
end

function remote:quit()
end



function remote:keypressed(key, scancode)
end

function remote:mousepressed(x,y, mouse_btn)
end

function remote:joystickpressed(joystick, button )
end

return remote
