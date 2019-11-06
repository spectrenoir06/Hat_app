love.filesystem.setRequirePath("?.lua;?/init.lua;lib/?.lua")

Gamestate = require "lib.gamestate"
states = {}

states.ftp_client	= require "gamestates.ftp_client"
states.stream		= require "gamestates.stream"
states.sound 		= require "gamestates.sound"
states.remote 		= require "gamestates.remote"

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(states.stream, 64, 8, "BRO888", "192.168.1.137", 6454)
	-- Gamestate.switch(states.sound)
end
