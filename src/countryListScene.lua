-----------------------------------------------------------------------------------------
--
-- countryListScene.lua -- SCENE -- Placeholder
--
-- Mark's country/flag screen stuff goes in here...

-- screen header can be turfed... just keep the background and BACK button stuff.

-----------------------------------------------------------------------------------------

local composer = require( "composer" )

local scene = composer.newScene()

local function goBack()
	composer.gotoScene( "mainmenuScene", { time=800, effect="crossFade" } )
end

--------------------------------------------------------------------------------------
-- user interface stuff
--------------------------------------------------------------------------------------

local widget = require( "widget" )

local bg2
local titleHeader
local backButton

local uiGroup


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    
	-- Code here runs when the scene is first created but has not yet appeared on screen

	-- Set up display groups
	uiGroup = display.newGroup()    -- Display group for UI objects
	
	-- Display blue background image
	bg2X,bg2Y = display.contentCenterX, display.contentCenterY
	bg2 = display.newRect( uiGroup, bg2X, bg2Y, display.contentWidth, display.contentHeight + 100 )
	bg2.fill = { type="image", filename="bg_blue.jpg" }

	-- Display header text
	titleHeader = display.newText( uiGroup, "Country 'Flag' List Screen\nPlaceholder Scene", 160, 75,	"Arial", 20)
	titleHeader:setFillColor( 0.8, 0.5, 0.5 )	

	-- Button widget for the Go Back button
	backButton = widget.newButton(
		{
			onRelease = goBack,
			x = 29,
			y = 496,
			width = 40,
			height = 40,
			defaultFile = "backButtonDefault.png",
			overFile = "backButtonPressed.png"
		}
	)
	
	-- insert the widget buttons into the display group "uiGroup", as there is no way to directly insert them while creating them, unlike other display objects.
	uiGroup:insert ( backButton )	
	
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