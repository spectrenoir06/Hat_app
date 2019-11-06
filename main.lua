love.filesystem.setRequirePath("?.lua;?/init.lua;lib/?.lua")

Gamestate = require "lib.gamestate"
states = {}

states.ftp_client	= require "gamestates.ftp_client"
states.stream		= require "gamestates.stream"
states.sound 		= require "gamestates.sound"
states.remote 		= require "gamestates.remote"
states.menu 		= require "gamestates.menu"

ip	= "192.168.1.137" -- 192.168.4.1
port	= 6454

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(states.menu)
end
