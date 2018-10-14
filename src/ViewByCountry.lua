local composer = require( "composer" )
local scene = composer.newScene()local widget = require( "widget" )

defaultField = display.newGroup()
counter = 0
lastValue = 0
backButton = ""
sceneGroup = display.newGroup()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
--***************************************Needs Memory Control!!!
local function gotoViewByCountryData()
    audio.play( soundTable["soundSelect"] )
	defaultField:removeSelf()
	--composer.removeScene( "ViewByCountry" )
	composer.gotoScene( "ViewByCountryInfo", { time=800, effect="crossFade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
 ----------------------
-- GoBack
--
local function goBack()
	system.vibrate()
	audio.play( soundTable["soundBack"] )
	defaultField:removeSelf()
	-- Completely remove the scene, including its scene object
	Runtime:removeEventListener( "touch", touchListener )
    composer.removeScene( "ViewByCountry" )
	composer.gotoScene( "mainmenuScene", { time=800, effect="crossFade" } )
end

---------------------------------------------------------------------FUNCTIONS--------------------------------------------
-------------------------
-- Handle Next Button
--
function handleFlagButton (event,self)
	system.vibrate()
	Runtime:removeEventListener( "touch", touchListener )
	print(event.target.id)
	print(CountryArray[event.target.id])
	composer.setVariable( "countryID", event.target.id )
	composer.setVariable( "countryString", CountryArray[event.target.id] )
	composer.setVariable( "countryDisplayString", displayArray[event.target.id] )
	gotoViewByCountryData()		
end



------------------------
--Swipe
--
local function touchListener(event)
	local phase=event.phase
	
	if phase == "began" then
	
	elseif phase == "moved" then
		--print("event.x = "..event.x)
		--print("event.y = "..event.y)
	elseif phase == "ended" then
		local eventXMove = (event.xStart - event.x)*-1
		local eventYMove = (event.yStart - event.y)*-1
		if (eventXMove ~= lastValue)then
			if(eventXMove > 130) then
				print("Over 130 -- Move LEFT"..eventXMove)
				lastValue = eventXMove
				print(counter)
				counter = counter - 30
				if (counter == 85)then
					counter = 92
				end
				if (counter < 2)then
					counter = 107
				end
				if (counter < 14)then
					counter = 2
				end
				audio.play( soundTable["soundSwipe"] )
				print(counter)
				displayFlags()
			end
			if(eventXMove < -130 ) then
				print("Over -130 -- Move RIGHT"..eventXMove)
				lastValue = eventXMove
				if (counter > 113)then
					counter = 2
				end
				audio.play( soundTable["soundSwipe"] )
				print(counter)
				displayFlags()
			end
		end
	end
end

--Get the text from the textbox ie the search term, TEXT TERM ENTERED
--Call findChars to get results 
-- Should: Clear Buttons, Clear Rows, Clear Debug
--
local function textListener( event )
	Runtime:removeEventListener( "touch", touchListener )
	-- Clear Debug Group Remove form display
	display.remove( debugGroup )
	dubugGroup = nil
	debugGroup = display.newGroup()
	--Clear Button Group Remove form display
	display.remove( ButtonGroup )
	ButtonGroup = nil
	ButtonGroup = display.newGroup()
		
		-- If there is a tableView on the screen at the moment. 
		--Kill It/Remove it
	if (FirstTimeFlag == 1) then
		tableView:deleteAllRows()
	end
	-- Enter letter is entered on the phone keyboard.
	if (  event.phase == "submitted" ) then

		--Remove ButtonGroup and start another. Clears the results text. 
		display.remove( ButtonGroup )
		ButtonGroup = nil
		ButtonGroup = display.newGroup()
		
		-- Get text string from text box
		local someString = event.target.text
		if someString ~= "" then
			anotherString = string.lower(someString)
			--Search Chars
			findChars(CountryArray, anotherString)
			defaultField.text = ""
	
			else -- Text box is empty
				counter = 2
				Runtime:addEventListener("touch", touchListener)
				displayFlags()
		end	

	end
end

---------------------------
--Make a Country Array
--Ignors commas, "
--Convers Case to lower
function makeArray (aString)
	local constring = ""
	local array = {}
	for i = 0, #aString + 1 do
		local c = aString:sub(i,i)
		if (c~= "," and c ~= "\"") then --CSV separator and errors in Flat File
			constring = string.lower(constring..c)
		else
			if(constring ~= "")then -- I am leaving this but it does nothing
				array[#array + 1] = constring
				constring = ""
			else
				constring = ""
			end
		end
	end
	array[#array + 1] = constring --One left in the array
	return array
end

-------------------------------------
--Make an Array - contains capitals
--Ignors commas, "
--
function rawArray (aString)
	local constring = ""
	local array = {}
	for i = 0, #aString + 1 do
		local c = aString:sub(i,i)
		if (c~= "," and c ~= "\"") then --CSV separator and errors in Flat File
			constring = (constring..c)
		else
			if(constring ~= "")then -- I am leaving this but it does nothing
				array[#array + 1] = constring
				constring = ""
			else
				constring = ""
			end
		end
	end
	array[#array + 1] = constring --One left in the array
	return array
end

-------------------------------------------------------------------
--Search partial string, not case sensitive. ie "A" or "Aust" etc
--Display results as Buttons
--
function findChars(array,search) 
	
	local someString = ""
	local startpos = 200
	Poscounter = 0 
	local flag = 0
	local foundArray= {}
	k = 1
	--Comapare each charater in the string, count the matches
	for i = 2, #array  do --Start at index 2 to disclude the headers ie Country, Country Code etc.**WALK AROUND!!
		local success = 0
		someString = array[i]
		for k = 1, #someString do
			local c = someString:sub(k,k)--Get the chars to compare
			local d = search:sub(k,k)
			if (c == d) then --If chars the same increment match count
				success = success + 1
			else 
				success = success + 0	
			end
		end
		--If the matches are the lenght of the string
		--Create a Country button.

		if (success == #search)then		
			Poscounter = Poscounter + 1 -- For button Spacing on Y axis.See var 'top' below
			print("Found "..array[i].. " at index position "..i) --Debug	
			foundArray[k] = i
			k = k +1
			flag = 1 -- Found search term Flag		
		end		
	end

	Runtime:removeEventListener( "touch", touchListener )
	displayFSearch(foundArray)
	
	audio.play( soundTable["soundSelect"] ) -- affirmative sound that users search is complete
	
	if(flag ~= 1) then --Search term Not Found.
		myText = display.newEmbossedText(debugGroup,"No results found.", 200, 200, 240, 300, native.systemFont, 22)
		myText:setFillColor( 1, 1, 1 )
		debugGroup:insert(myText)
		sceneGroup:insert(debugGroup)
	end
end

----------------------------
--Display flags from search
--
function displayFSearch(arr)
Runtime:removeEventListener( "touch", touchListener )
local posiArray = {	display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100,
					display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100,
					display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100,
					display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100,
					display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100} 	
Runtime:removeEventListener( "touch", touchListener )
CountryArray = makeArray(country)
displayArray = rawArray(country)
display.remove( flagGroup )
flagGroup = nil
flagGroup = display.newGroup()
		
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
		image3 = display.newImageRect(flagGroup,someString, 50, 50)
		text3 = display.newEmbossedText(flagGroup,displayArray[arr[i]],posiArray[i] +20,yaxis + 35,90,0,native.systemFont,13)
		image3.x = (posiArray[i])
		image3.y = yaxis
		--print(someString)
		
		image3.id = arr[i]
		print("ARRAY I "..arr[i])
		image3:addEventListener( "tap", handleFlagButton )
		flagGroup:insert(image3)
		flagGroup:insert(text3)
		i = i + 1	
	end
	sceneGroup:insert( flagGroup )
end

----------------------------
--Display Flags
--
function displayFlags()
local posiArray ={	display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100,
					display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100,
					display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100,
					display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100,
					display.contentCenterX - 100, display.contentCenterX , display.contentCenterX + 100} 	

CountryArray = makeArray(country)
displayArray = rawArray(country)
display.remove( flagGroup )
flagGroup = nil
flagGroup = display.newGroup()		
--Next lot of flags		
i = 1
--print("For loopStart",counter)
	for counter = counter, counter + 14 do
		if(counter > 114)then 				
			break
		end
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
			if(i > 12)then
			yaxis = 400
		end
		
		someString = "flags/"..CountryArray[counter]..".png" 
		image2 = display.newImageRect(flagGroup,someString, 50, 50)
		text2 = display.newEmbossedText(flagGroup,displayArray[counter],posiArray[i] +20,yaxis + 35,90,0,native.systemFont,13)
		image2.x = (posiArray[i])
		image2.y = yaxis
		--print(someString)
		image2.id = counter
		image2:addEventListener( "tap", handleFlagButton )
		flagGroup:insert(image2)
		flagGroup:insert(text2)
		i = i + 1		
	end
	counter = counter + (i-1)
	sceneGroup:insert( flagGroup )
end

------------------------------------
-- Function to handle button events 
-- Country Button Pressed!!!
-- 
function handleButtonEvent( event,self )
		Runtime:removeEventListener( "touch", touchListener )
		--clear DebugGroup Remove from Screen!
		display.remove( debugGroup )
		dubugGroup = nil
		debugGroup = display.newGroup()
		
    if ( event.phase == "ended" ) then
        -- Code executed when the touch lifts off the object
        --print( "touch ended on object " .. tostring(event.target.id) )
		tableView = widget.newTableView(
			{
			left = 0,
			top = 45,
			height = 500,        --Height and width of the actual Table View
			width = display.ContentWidthX ,
			onRowRender = onRowRender,
			onRowTouch = onRowTouch,
			listener = scrollListener,
			hideBackground = true
			}
		)
		for i = 1, 57 do          -- 57 the amount of lines in the flat file! TODO full proof this!
			response = getRow(i)
			local dummyArray = {}
			local titleArray = {}
			dummyArray = makeArray(response)
			CountryToDisplay[i] = dummyArray[event.target.id]
			titleArray[i] = dummyArray[1]
			--print(CountryToDisplay[i])
			
			--print(dummyArray[i])
			dummyArray = nil -- Kill It.
			
			local isCategory = false
			local rowHeight = 70 ----------------------------------------ROW HEIGHT get the majic right.
			local rowColor = { default={ 0, 0, 0}, over={ 0, 0, 0} }
			local lineColor = { 0, 0, 0 }
			--print( string.find( "Hello Corona user", "Corona" ) ) 
			
			local SectionString = titleArray[i]
			local DataString = CountryToDisplay[i]
			SectionString = SectionString:gsub("%a", string.upper,1) --Make First letter a capital
			DataString = DataString:gsub("%a", string.upper,1)
			local id = SectionString.." = "..DataString --Concat output to display
			
-- Insert a row into the tableView
			tableView:insertRow(
				{
					isCategory = isCategory,
					rowHeight = rowHeight,
					rowColor = rowColor,
					lineColor = lineColor,
					id = id,
				    --params = {}  -- Include custom data in the row               **TODO but not needed.
				}
			)		
		end
			FirstTimeFlag = 1 --Are there any tables being displayed? see function textListener.
    end 
		return true  -- Prevents tap/touch propagation to underlying objects
end
	
----------------------------------------------------------------Fuctions End--------------------------------------------	
------------------------------------------------------------------------------------------------------------------------


-- create()
function scene:create( event )
	
	sceneGroup = self.view
	local bg2X,bg2Y = display.contentCenterX, display.contentCenterY
	local bg2 = display.newRect( bg2X, bg2Y, display.contentWidth, display.contentHeight + 100 )
	bg2.fill = { type="image", filename="bg_blue.jpg" }
	sceneGroup:insert( bg2 )
	-- Vars             ---------------------------------------------Double check these Vars
	CountryArray = {}
	CountryToDisplay = {}
	displayArray = {}
	flag = 0
	FirstTimeFlag = 0
	counter = 2
	--Groups
	ButtonGroup = display.newGroup()
	debugGroup = display.newGroup()
	

flagGroup = display.newGroup()
backLayer = display.newGroup()

local background = display.newImage(backLayer, "bg_map_dotted.png", 30, 140)


--SearchTitle = display.newText(backLayer,"Search",display.contentCenterX,0, 0, 0, native.systemFont, 14)
--SearchTitle:setFillColor( 1, 1, 1 )					

-- Button widget for the Go Back button
backButton = widget.newButton(
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
backLayer:insert(backButton)

-- Open File
local path = system.pathForFile( "wjp.csv", system.ResourceDirectory )
local file = io.open(path, "r")
if file then
	print("File Found")
	country = file:read("*l")
	io.close (file)
	print("File Loaded Ok")
	else
		print("Not working") --No file/Error/file Open
end

-- Display Flags
displayFlags()
-- insert my display objects 
sceneGroup:insert( backLayer )
sceneGroup:insert( flagGroup )
Runtime:addEventListener("touch", touchListener)

end

 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
		defaultField = native.newTextField( 160, 15, 180, 30 )
		defaultField.placeholder = ( "Search" )
		defaultField:addEventListener( "userInput", textListener )
		backButton:addEventListener("tap", goBack) 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
				display.remove( debugGroup )
			dubugGroup = nil
		backButton:removeEventListener("tap", goBack)
	
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