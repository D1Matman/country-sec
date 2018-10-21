-----------------------------------------------------------------------------------------
--
-- mainmenuScene.lua -- SCENE --
--
-- This is the scene in which main menu is presented and gives user two option buttons
-- User will choose:
-- View by Country or View by Ranking
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- Load in menu button sound fx to be used globally by all screens
soundTable = {
	soundSelect = audio.loadSound( "button-select.wav" ),
	soundBack = audio.loadSound( "button-back.wav" ),
	soundSwipe = audio.loadSound( "swipe.wav" )
}

-- Functions for each button on screen
local function gotoCountryList()
	system.vibrate()
	audio.play( soundTable["soundSelect"] )
	composer.gotoScene( "ViewByCountry", { time=800, effect="crossFade" } )
end

local function gotoCategoryMenu()
	system.vibrate()
	audio.play( soundTable["soundSelect"] )
	composer.gotoScene( "categoryMenuScene", { time=800, effect="crossFade" } )
end


--------------------------------------------------------------------------------------
-- user interface stuff
--------------------------------------------------------------------------------------

local widget = require( "widget" )

local bg2, bg
local titleHeader1a, titleHeader2a, titleHeader1b, titleHeader2b
local viewCountryButton, viewRankingButton

local uiGroup


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
	Runtime:removeEventListener( "touch", touchListener )
	--make the device vibrate
    system.vibrate()
	-- Code here runs when the scene is first created but has not yet appeared on screen

	-- Set up display group for UI objects
	uiGroup = display.newGroup()

	-- Display blue background image
	bg2X,bg2Y = display.contentCenterX, display.contentCenterY
	bg2 = display.newRect( uiGroup, bg2X, bg2Y, display.contentWidth, display.contentHeight + 100 )
	bg2.fill = { type="image", filename="bg_blue.jpg" }

	-- Display background image of 'dotted' world map on top of blue background
	bgX,bgY = display.contentCenterX, display.contentCenterY - 8
	bg = display.newRect( uiGroup, bgX, bgY, display.contentWidth, display.contentHeight - 240 )
	bg.fill = { type="image", filename="bg_map_dotted.png" }

	-- Text widget for screen header
	titleHeader1a = display.newText( uiGroup, "Global Security & Laws", 158, 32,	"Arial", 29 )
	titleHeader1a:setFillColor( 0, 0, 0 )

	titleHeader2a = display.newText( uiGroup, "Travel Companion", 158, 77,	"Arial", 29 )
	titleHeader2a:setFillColor( 0, 0, 0 )

	-- Text widget for screen header
	titleHeader1b = display.newText( uiGroup, "Global Security & Laws", 160, 30,	"Arial", 29 )
	titleHeader1b:setFillColor( 1, 0.8, 0 )

	titleHeader2b = display.newText( uiGroup, "Travel Companion", 160, 75,	"Arial", 29 )
	titleHeader2b:setFillColor( 1, 1, 1 )

	-- Button widget for the view country button
	viewCountryButton = widget.newButton(
		{
			label = "View By\nCountry",
			labelColor = { default= {1, 1, 1, 1}, over={1, 1, 1, 0.5} },
			fontSize = 24,
			font = "Arial",
			onRelease = gotoCountryList,
			emboss = true,
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
	viewRankingButton = widget.newButton(
		{
			label = "View By\nRanking",
			labelColor = { default= {1, 1, 1, 1}, over={1, 1, 1, 0.5} },
			fontSize = 24,
			onRelease = gotoCategoryMenu,
			emboss = true,
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
	
	-- insert the widget buttons into the display group "uiGroup", as there is no way to directly insert them while creating them, unlike other display objects.
	uiGroup:insert ( viewCountryButton )
	uiGroup:insert ( viewRankingButton )
	
	-- insert my display objects (grouped as "uiGroup") into the "sceneGroup"
	sceneGroup:insert( uiGroup )
	
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
	
--[	
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
		

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
--]
end

-- hide()
function scene:hide( event )

    local sceneGroup = self.view
	
--[	
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
				
    end
--]	

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