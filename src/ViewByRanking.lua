-----------------------------------------------------------------------------------------
--
-- ViewByRanking.lua -- SCENE
--
-- This is the scene in which rankings for each country are shown for chosen category
-- that was selected on previous Category Menu screen
--
-- Once the user picks a country from the rankings list, they will be taken to 
-- the Country Info scene to view that country.

-----------------------------------------------------------------------------------------

local composer = require( "composer" )

local scene = composer.newScene()

CountryArray = {}
displayArray = {}
CountryToDisplay = {}
newArray = {}
-----------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------
function getRatingLine(line)

	local path = system.pathForFile( "wjp.csv", system.ResourceDirectory )
	local file = io.open(path, "r")
	local data
	if file then
	print("File Found")
	for i = 1, line + 1 do
		data = file:read("*l")
			
	end	
		io.close (file)
		print("File Loaded Ok")
		return(data)
		else
			print("Not working") --No file/Error/file Open
	end
end

function sortArray(arr,arr2,arr3)
	for i = 1, #arr do
		local k = 1
		for k = k + i, #arr do

			if(arr[i] < arr[k])then
				local temp1 = arr[i]
				local temp2 = arr2[i]
				local temp3 = arr3[i]
				arr[i] = arr[k]
				arr2[i] = arr2[k]
				arr3[i] = arr3[k]
				arr[k] = temp1	
				arr2[k] = temp2
				arr3[k] = temp3
	
		end
		end
				
	end
	--print(arr)
	return arr
end	

-- function for Go Back button
local function goBack()
	composer.gotoScene( "categoryMenuScene", { time=800, effect="crossFade" } )
	composer.removeScene("ViewByRanking")
end

local function gotoViewByCountryData()
 
	composer.gotoScene( "ViewByCountryInfo", { time=800, effect="crossFade" } )
end
-- ScrollView listener
local function scrollListener( event )
 
	local phase = event.phase
	if ( phase == "began" ) then --print( "Scroll view was touched" )
	elseif ( phase == "moved" ) then-- print( "Scroll view was moved" )
	elseif ( phase == "ended" ) then --print( "Scroll view was released" )
	end
 
	-- In the event a scroll limit is reached...
	if ( event.limitReached ) then
		if ( event.direction == "up" ) then --print( "Reached bottom limit" )
		elseif ( event.direction == "down" ) then --print( "Reached top limit" )
		elseif ( event.direction == "left" ) then --print( "Reached right limit" )
		elseif ( event.direction == "right" ) then --print( "Reached left limit" )
		end
	end
 
	return true
end

local function onRowRender( event )
	local temp = ""
	
    -- Get reference to the row group
    row = event.row
	
    -- TODO******** Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = 100
    --local rowWidth = 3000
	temp = row.id
    local rowTitle = display.newText(row.id, 0, 0,270,0,native.systemFont, 15 )
    --rowTitle:setFillColor( 0,0,8 )
	
	if (string.find(temp,"Factor")~=1)then
		rowTitle:setFillColor( 0,0,0 ) --Is not a FACTOR (flat file) heading text colour blue.
		else
		rowTitle:setFillColor( 0,8,0 )	--Is a heading Colour X (green) 
	end
 
    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 20      --Where inside the ROW
    rowTitle.y = 20
	rowHeight = rowHeight * 0.5
	isBounceEnabled = false

end

function displayATable(TheEvent) -- Create Table View

	tableView = widget.newTableView(
			{
			left = 0,
			top = 60,
			height = 410,        --Height and width of the actual Table View
			width = display.ContentWidthX ,
			onRowRender = onRowRender,
			onRowTouch = onRowTouch,
			listener = scrollListener,
			hideBackground = true
			}
		)
					
		for i = 1, 46 do          -- 57 the amount of lines in the flat file! TODO full proof this! ***Had to Change this FACTOR has been removed from CSV
			response = getRow(i)
			local dummyArray = {}
			local titleArray = {}
			dummyArray = makeArray(response)
			CountryToDisplay[i] = dummyArray[TheEvent]
			titleArray[i] = dummyArray[1]
			--print(CountryToDisplay[i])
			
			--print(dummyArray[i])
			dummyArray = nil -- Kill It.
			
			local isCategory = false
			local rowHeight = 60 ----------------------------------------ROW HEIGHT get the majic right.
			local rowColor = { default={ 0, 0, 0,0}, over={ 0, 0, 0,0} }
			local lineColor = { 0, 0, 0,0}
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
		

		

	dataGroup:insert(tableView)		
end

function handleRowButton (event,self)
	print("Row Button: "..event.target.id)
	composer.setVariable( "countryID", event.target.id )
	composer.setVariable( "countryString", CountryArray[event.target.id] )
	composer.setVariable( "countryDisplayString", displayArray[event.target.id] )
	gotoViewByCountryData()	
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



-------------------------------------------------------------------------------------
-- READ DATABASE
-------------------------------------------------------------------------------------

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



--------------------------------------------------------------------------------------
-- user interface stuff
--------------------------------------------------------------------------------------

local widget = require( "widget" )

local bg2
local backButton
--local defaultField
local searchTitle

local scrollView

local uiGroup
local backLayer


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    
	-- Code here runs when the scene is first created but has not yet appeared on screen

	-- Set up display groups
	uiGroup = display.newGroup()    -- Display group for UI objects
	backLayer = display.newGroup()
	scrollView = display.newGroup()
	
	-- Display blue background image
	bg2X,bg2Y = display.contentCenterX, display.contentCenterY
	bg2 = display.newRect( uiGroup, bg2X, bg2Y, display.contentWidth, display.contentHeight + 100 )
	bg2.fill = { type="image", filename="bg_blue.jpg" }

	------------------------------------------------------
	-- PLACEHOLDER TEXTFIELD STUFF --
	-- Display textfield
	--defaultField = native.newTextField( 160, 25, 180, 30 )
	--defaultField:addEventListener( "userInput", textListener )
	searchTitle = display.newText( "Search",display.contentCenterX,0, 0, 0, native.systemFont, 14)
	searchTitle:setFillColor( 1, 1, 1 )		
	---------------------------------------------------------------------------
	

	-- Create the widget for ScrollView
	scrollView = widget.newScrollView(
		{
			top = 75,
			left = 12,
			width = 296,
			height = 380,
			--scrollWidth = 0,
			scrollHeight = 380,
			listener = scrollListener,
			horizontalScrollDisabled = true,
			isBounceEnabled = false,
			--hideBackground = true
			backgroundColor = { 0.047, 0.227, 0.53 }
		}
	)

	------------------------------------------------------------------------------
	-- Create the content to populate the ScrollView

	-- starting co-ordinates for displaying stuff in scroll area
	rankX = -145
	flagX = -110
	nameX = -30
	y = -210

	-- create country list arrays, based on data read from db
	CountryArray = makeArray(country)
	displayArray = rawArray(country)
	newString = getRatingLine(composer.getVariable("LineNumber") - 1) --********************************************************************************
	print(newString)
	nextArray = makeArray(newString)
	for i = 2, #nextArray do
		print(nextArray[i])
	end
	print("*************************************"..composer.getVariable("LineNumber") - 1)
	someArray = sortArray(nextArray,CountryArray,displayArray)
		for i = 2, #nextArray do
		print(nextArray[i])
		print(CountryArray[i])
		
	end
	
	

	for i = 2, 114 do	-- we have 113 countries to populate in ranking chart everytime

		-- Create text and image content for a row in the scroll area
	
		local rankstring = "rank"
		rankstring = rankstring..i
		_G['rank'..i] = display.newText( i - 1, 0, 0, native.systemFont, 15 )
		_G['rank'..i]:setFillColor( 1, 0.8, 0 )
		_G['rank'..i].x = display.contentCenterX + rankX
		_G['rank'..i].y = display.contentCenterY + y
	
		local rankstring = "flag"
		rankstring = rankstring..i
		_G['flag'..i] = display.newImageRect( ("flags/"..CountryArray[i]..".png"), 50, 50)
		--print("flags/"..CountryArray[i]..".png")
		_G['flag'..i].x = display.contentCenterX + flagX
		_G['flag'..i].y = display.contentCenterY + y		
		_G['flag'..i].id = i
		_G['flag'..i]:addEventListener("touch",handleRowButton)
		
		
		
		_G['name'..i] = display.newText( displayArray[i], 0, 0, native.systemFont, 15 )
		_G['name'..i]:setFillColor( 1, 1, 1 )
		_G['name'..i].x = display.contentCenterX + nameX
		_G['name'..i].y = display.contentCenterY + y	

		-- increment the row height
		y = y + 50	
		
		-- add to the scrollView display group
		scrollView:insert ( _G['rank'..i] )
		scrollView:insert ( _G['flag'..i] )
		scrollView:insert ( _G['name'..i] )

	end
	
	
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
	uiGroup:insert ( searchTitle )
	uiGroup:insert ( backButton )
	--uiGroup:insert ( defaultField )

	
	-- insert my display objects (grouped as "uiGroup") into the "sceneGroup"
	sceneGroup:insert( uiGroup )
	
	sceneGroup:insert( scrollView )
	
	
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