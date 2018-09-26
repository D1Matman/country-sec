-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- this our main file for Global Security & Laws Travel Companion app
--
-----------------------------------------------------------------------------------------

-- we will use the composer library, we have multiple scenes

local composer = require( "composer" )

-- Code to initialize the app can go here

-- Now load the opening scene

-- Assumes that "questionScene.lua" exists and is configured as a Composer scene
composer.gotoScene( "mainmenuScene", { time=800, effect="crossFade" } )