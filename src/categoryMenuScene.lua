-----------------------------------------------------------------------------------------
--
-- categoryMenuScene.lua -- SCENE
--
-- This is the scene in which ranking categories menu is presented and gives user six option buttons
-- User will choose from:
-- (1) overall ranking, (2) government accountability, (3) absence of corruption, (4) fundamental rights, 
-- (5) public order & securityButton, (6) civil & criminal justice.
--
-- Once the user picks, we take them to the Rankings List scene, where we show them how countries compare
-- in the chosen high-level category (as per the ratings provided in db).

-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------------------------------------------------
-- Functions for each button on screen
--------------------------------------------------------------------------------------
local function gotoViewByRanking(event,self)
	print("****************************"..event.target.id)
	composer.setVariable( "LineNumber", event.target.id )
	composer.gotoScene( "ViewByRanking", { time=800, effect="crossFade" } )
	composer.removeScene( "categoryMenuScene" )
end

--------------------------------------------------------------------------------------
-- Go back to Main Menu Scene
--------------------------------------------------------------------------------------
local function goBack()
	composer.gotoScene( "mainmenuScene", { time=800, effect="crossFade" } )
end

--------------------------------------------------------------------------------------
-- user interface stuff
--------------------------------------------------------------------------------------

local widget = require( "widget" )
local bg2
local overallButton, governmentButton, corruptionButton, rightsButton, securityButton, justiceButton 
local backButton

local uiGroup

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
-- create()
--------------------------------------------------------------------------------------
function scene:create( event )

    local sceneGroup = self.view
    
	-- Code here runs when the scene is first created but has not yet appeared on screen

	-- Set up display groups
	uiGroup = display.newGroup()    -- Display group for UI objects
	
	-- Display blue background image
	bg2X,bg2Y = display.contentCenterX, display.contentCenterY
	bg2 = display.newRect( uiGroup, bg2X, bg2Y, display.contentWidth, display.contentHeight + 100 )
	bg2.fill = { type="image", filename="bg_blue.jpg" }

	-- Button widget for Overall Ranking category choice
	overallButton = widget.newButton(
		{
			label = "Overall Ranking",
			id = 2,
			labelColor = { default= {1, 1, 1, 1}, over={1, 1, 1, 0.5} },
			fontSize = 24,
			font = "Arial",
			onRelease = gotoViewByRanking,
			emboss = true,
			shape = "roundedRect",
			x = display.contentCenterX,
			y = 24,
			width = 296,
			height = 64,
			cornerRadius = 9,
			fillColor = { default= {0.11, 0.43, 0.95, 1}, over={0.11, 0.43, 0.95, 0.5} },
			strokeColor = { default={0.05, 0.23, 0.53, 1}, over={0.05, 0.23, 0.53, 0.5} },
			strokeWidth = 6
		}
	)	
	
	-- Button widget for Government Accountability category choice
	governmentButton = widget.newButton(
		{
			label = "Government Accountability",
			id = 3,
			labelColor = { default= {1, 1, 1, 1}, over={1, 1, 1, 0.5} },
			fontSize = 23,
			font = "Arial",
			onRelease = gotoViewByRanking,
			emboss = true,
			shape = "roundedRect",
			x = display.contentCenterX,
			y = 104,
			width = 296,
			height = 64,
			cornerRadius = 9,
			fillColor = { default= {0.11, 0.43, 0.95, 1}, over={0.11, 0.43, 0.95, 0.5} },
			strokeColor = { default={0.05, 0.23, 0.53, 1}, over={0.05, 0.23, 0.53, 0.5} },
			strokeWidth = 6
		}
	)	
	
	-- Button widget for Absence of Corruption category choice
	corruptionButton = widget.newButton(
		{
			label = "Absence of Corruption",
			id = 14,
			labelColor = { default= {1, 1, 1, 1}, over={1, 1, 1, 0.5} },
			fontSize = 24,
			font = "Arial",
			onRelease = gotoViewByRanking,
			emboss = true,
			shape = "roundedRect",
			x = display.contentCenterX,
			y = 184,
			width = 296,
			height = 64,
			cornerRadius = 9,
			fillColor = { default= {0.11, 0.43, 0.95, 1}, over={0.11, 0.43, 0.95, 0.5} },
			strokeColor = { default={0.05, 0.23, 0.53, 1}, over={0.05, 0.23, 0.53, 0.5} },
			strokeWidth = 6
		}
	)	
	
	-- Button widget for Fundamental Rights category choice
	rightsButton = widget.newButton(
		{
			label = "Fundamental Rights",
			id = 19,
			labelColor = { default= {1, 1, 1, 1}, over={1, 1, 1, 0.5} },
			fontSize = 24,
			font = "Arial",
			onRelease = gotoViewByRanking,			emboss = true,
			shape = "roundedRect",
			x = display.contentCenterX,
			y = 264,
			width = 296,
			height = 64,
			cornerRadius = 9,
			fillColor = { default= {0.11, 0.43, 0.95, 1}, over={0.11, 0.43, 0.95, 0.5} },
			strokeColor = { default={0.05, 0.23, 0.53, 1}, over={0.05, 0.23, 0.53, 0.5} },
			strokeWidth = 6
		}
	)	
	
	-- Button widget for Public Order & Security category choice
	securityButton = widget.newButton(
		{
			label = "Public Order & Security",
			id = 28,
			labelColor = { default= {1, 1, 1, 1}, over={1, 1, 1, 0.5} },
			fontSize = 24,
			font = "Arial",
			onRelease = gotoViewByRanking,
			emboss = true,
			shape = "roundedRect",
			x = display.contentCenterX,
			y = 344,
			width = 296,
			height = 64,
			cornerRadius = 9,
			fillColor = { default= {0.11, 0.43, 0.95, 1}, over={0.11, 0.43, 0.95, 0.5} },
			strokeColor = { default={0.05, 0.23, 0.53, 1}, over={0.05, 0.23, 0.53, 0.5} },
			strokeWidth = 6
		}
	)	
	
	-- Button widget for Civil & Criminal Justice category choice
	justiceButton = widget.newButton(
		{
			label = "Civil & Criminal Justice",
			id = 32,
			labelColor = { default= {1, 1, 1, 1}, over={1, 1, 1, 0.5} },
			fontSize = 24,
			font = "Arial",
			onRelease = gotoViewByRanking,
			emboss = true,
			shape = "roundedRect",
			x = display.contentCenterX,
			y = 424,
			width = 296,
			height = 64,
			cornerRadius = 9,
			fillColor = { default= {0.11, 0.43, 0.95, 1}, over={0.11, 0.43, 0.95, 0.5} },
			strokeColor = { default={0.05, 0.23, 0.53, 1}, over={0.05, 0.23, 0.53, 0.5} },
			strokeWidth = 6
		}
	)	
	
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
	uiGroup:insert ( overallButton )
	uiGroup:insert ( governmentButton )
	uiGroup:insert ( corruptionButton )
	uiGroup:insert ( rightsButton )
	uiGroup:insert ( securityButton )
	uiGroup:insert ( justiceButton )
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