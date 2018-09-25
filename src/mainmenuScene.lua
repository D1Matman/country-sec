-----------------------------------------------------------------------------------------
--
-- mainmenuScene.lua -- SCENE --
--
-- This is the scene in which main menu is presented and gives user two option buttons
-- User will choose:
-- View by Country or View by Ranking
--
-----------------------------------------------------------------------------------------

-- ***** NOTE: scene functionality still to be hooked up .. hence commented out all scene functions.

--local composer = require( "composer" )

--local scene = composer.newScene()


--------------------------------------------------------------------------------------
-- user interface stuff
--------------------------------------------------------------------------------------

local widget = require( "widget" )

-- Set default screen background color
-- display.setDefault( "background", 0.46, 0.62, 1 )

-- Display blue background image
local bg2X,bg2Y = display.contentCenterX, display.contentCenterY
local bg2 = display.newRect( bg2X, bg2Y, display.contentWidth, display.contentHeight + 100 )
bg2.fill = { type="image", filename="bg_blue.jpg" }

-- Display background image of 'dotted' world map on top of blue background
local bgX,bgY = display.contentCenterX, display.contentCenterY - 8
local bg = display.newRect( bgX, bgY, display.contentWidth, display.contentHeight - 240 )
bg.fill = { type="image", filename="bg_map_dotted.png" }

-- Text widget for screen header foreground
local titleHeader1 = display.newText("Global Security & Laws", 158, 32,	"Arial Narrow", 29)
titleHeader1:setFillColor( 0, 0, 0 )

local titleHeader2 = display.newText("Travel Companion", 158, 77,	"Arial", 29)
titleHeader2:setFillColor( 0, 0, 0 )

-- Text widget for screen header shadow
local titleHeader1 = display.newText("Global Security & Laws", 160, 30,	"Arial Narrow", 29)
titleHeader1:setFillColor( 1, 0.8, 0 )

local titleHeader2 = display.newText("Travel Companion", 160, 75,	"Arial", 29)
titleHeader2:setFillColor( 1, 1, 1 )

-- Button widget for the view country button
local viewCountryButton = widget.newButton(
	{
		label = "View By\nCountry",
		labelColor = { default= {1, 1, 1, 1}, over={1, 1, 1, 0.5} },
		fontSize = 24,
		font = "Arial",
		--onRelease = ... goto ... CountryFlagListScreen,
		emboss = false,
		shape = "roundedRect",
		x = 82,
		y = 420,
		width = 140,
		height = 90,
		cornerRadius = 9,
		fillColor = { default= {0.11, 0.43, 0.95, 1}, over={0.11, 0.43, 0.95, 0.5} },
		strokeColor = { default={0.05, 0.23, 0.53, 1}, over={0.05, 0.23, 0.53, 0.5} },
		strokeWidth = 6
	}
)

-- Button widget for the view ranking button
local viewCountryButton = widget.newButton(
	{
		label = "View By\nRanking",
		labelColor = { default= {1, 1, 1, 1}, over={1, 1, 1, 0.5} },
		fontSize = 24,
		--onRelease = ... goto ... RankingCategoriesMenuScreen,
		emboss = false,
		shape = "roundedRect",
		x = 238,
		y = 420,
		width = 140,
		height = 90,
		cornerRadius = 9,
		fillColor = { default= {0.11, 0.43, 0.95, 1}, over={0.11, 0.43, 0.95, 0.5} },
		strokeColor = { default={0.05, 0.23, 0.53, 1}, over={0.05, 0.23, 0.53, 0.5} },
		strokeWidth = 6
	}
)

--[[

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene

--]]