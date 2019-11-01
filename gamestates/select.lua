local LEDsController = require "lib.LEDsController.LEDsController"
local upack = LEDsController.upack

local ftp = require("lib.ftp")
local ltn12 = require("ltn12")
local url = require("socket.url")

local ip = "192.168.1.189"
local user = "LED"
local pass = "LED"

-- a function that returns a directory listing
function list()
	local t = {}
	local r, e = ftp.get({
		host = ip,
		user = user,
		password = pass,
		command = "nlst",
		sink = ltn12.sink.table(t),
	})
	if r then
		local str = table.concat(t)
		-- print(r,str)
		local files = {}
		for v in string.gmatch(str, "%S+") do
			table.insert(files, v)
		end
		return files
	else
		return false, e
	end
end

function download(file)
	local t = {}
	print("download",file)
	local r, e = ftp.get{
		host = ip,
		user = user,
		password = pass,
		argument = file,
		type = "I",
		sink = ltn12.sink.table(t),
	}
	return r and table.concat(t), e
end

function upload(filename)
	local file = io.open("animation/compress/"..filename..".BRO888", "r")
	print(filename, file)

	local f, e = ftp.put({
		host = ip,
		user = user,
		password = pass,
		command = "STOR",
		argument = filename,
		source = ltn12.source.file(file)
	})
	file:close()
	return f, e
end

local select = {}

function select:init() -- Called once, and only once, before entering the state the first time
end

function select:enter(previous) -- Called every time when entering the state
	-- local files = list()
	-- self.files = {}
	-- for k,v in ipairs(files) do
	-- 	t  = {}
	-- 	t.name = v
	-- 	t.data = download(v)
	-- 	t.size = #t.data
	-- 	table.insert(self.files, t)
	-- end
	upload("4X")
end

function select:leave() -- Called when leaving a state.
end

function select:resume() -- Called when re-entering a state by Gamestate.pop()
end

function select:update(dt)
end

function select:draw()
	-- for k,v in ipairs(self.files) do
	-- 	love.graphics.print(k..": "..v.name..", size: "..math.floor(v.size/1024), 10, k*15)
	-- end
end

function select:focus(focus)
end

function select:quit()
end



function select:keypressed(key, scancode)
end

function select:mousepressed(x,y, mouse_btn)
end

function select:joystickpressed(joystick, button )
end

return select
