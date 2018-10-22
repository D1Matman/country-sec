local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

local prevScene = composer.getSceneName("previous") -- Get the last scene

ButtonGroup1 = display.newGroup()
	--debugGroup1 = display.newGroup()
	backButton1 = ""

	flagGroup1 = display.newGroup()
	backLayer1 = display.newGroup()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 --defaultField:removeSelf()
 
 
function goPrev()
	system.vibrate()
	audio.play( soundTable["soundBack"] )
	-- Completely remove the scene, including its scene object
    composer.removeScene( "ViewByCountrySearch" )
	composer.gotoScene( prevScene, { time=800, effect="crossFade" } )
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
	defaultField1 = display.newGroup()
	
	sceneGroup1 = display.newGroup()
    local sceneGroup1 = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen


	
local function gotoViewByCountryData1()
	Runtime:removeEventListener( "touch", touchListener )
		
    audio.play( soundTable["soundSelect"] )
	defaultField1:removeSelf()
	--composer.removeScene( "ViewByCountry" )
	composer.gotoScene( "ViewByCountryInfo", { time=800, effect="crossFade" } )
end
	
function handleFlagButton (event,self)
	Runtime:removeEventListener( "touch", touchListener )
	system.vibrate()
	print(event.target.id)
	print(CountryArray[event.target.id])
	composer.setVariable( "countryID", event.target.id )
	composer.setVariable( "countryString", CountryArray[event.target.id] )
	composer.setVariable( "countryDisplayString", displayArray[event.target.id] )
	gotoViewByCountryData1()		
end

function displayFSearch(arr)
	Runtime:removeEventListener( "touch", touchListener )
	local posiArray = {	display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100,
						display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100,
						display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100,
						display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100,
						display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100} 	
	
	CountryArray = makeArray(country)
	displayArray = rawArray(country)
	display.remove( flagGroup1 )
	flagGroup1 = nil
	flagGroup1 = display.newGroup()
		
	for i = 1, #arr   do

		if (i < 4) then
			yaxis = 80
		end
		if(i > 3 and i < 7)then
			yaxis = 160
		end
		if(i > 6 and i < 10)then
			yaxis = 240
		end
		if(i > 9 and i < 13)then
			yaxis = 320
		end
		if(i > 12 )then
			yaxis = 420
		end
		--print(CountryArray[arr[i]])
		someString = "flags/"..CountryArray[arr[i]]..".png"
		image3 = display.newImageRect(flagGroup1,someString, 50, 50)
		text3 = display.newEmbossedText(flagGroup1,displayArray[arr[i]],posiArray[i] +20,yaxis + 35,90,0,native.systemFont,13)
		image3.x = (posiArray[i])
		image3.y = yaxis
		--print(someString)
	
		image3.id = arr[i]
		print("ARRAY I "..arr[i])
		image3:addEventListener( "tap", handleFlagButton )
		flagGroup1:insert(image3)
		flagGroup1:insert(text3)
		i = i + 1	
	end
	sceneGroup1:insert( flagGroup1 )
end

local bg2X,bg2Y = display.contentCenterX, display.contentCenterY
local bg2 = display.newRect( bg2X, bg2Y, display.contentWidth, display.contentHeight + 100 )
bg2.fill = { type="image", filename="bg_blue.jpg" }
local background = display.newImage(backLayer1, "bg_map_dotted.png", 30, 140)

backLayer1:insert(bg2)
backLayer1:insert( background )
rowTitle = display.newEmbossedText(backLayer1, "Search Results", bg2X, bg2Y - 224,0,0,native.systemFontBold, 20 )
rowTitle:setFillColor( 1, 1, 1 ) -- major category
backLayer1:insert( rowTitle )

sceneGroup1:insert( backLayer1 ) -- One to rule them ALL !

local arr = composer.getVariable("foundItArray")
print(arr)

	backButton1 = widget.newButton(
		{
			--onRelease = goBack,
			x = 29,
			y = 500,
			width = 40,
			height = 40,
			defaultFile = "backButtonDefault.png",
			overFile = "backButtonPressed.png"
		}
	)
	backLayer1:insert(backButton1)


	displayFSearch(arr)	
	sceneGroup1:insert( backLayer1 )
	sceneGroup1:insert( flagGroup1 )		

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup1 = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
		backButton1:addEventListener("tap", goPrev)
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup1 = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup1 = self.view
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