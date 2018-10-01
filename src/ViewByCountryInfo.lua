local composer = require( "composer" )
local scene = composer.newScene()local widget = require( "widget" )
local scene = composer.newScene()
 
 local prevScene = composer.getSceneName("previous")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------


local function goBack()

	-- Completely remove the scene, including its scene object
	
	
    composer.removeScene( "ViewByCountryInfo" )
	
	
	
	composer.gotoScene( prevScene, { time=800, effect="crossFade" } )
end

--Get Row Data (Country Data)
--From the flat file
--
function getRow(row)
	local path = system.pathForFile( "wjp.csv", system.ResourceDirectory )
	local file = io.open(path,"r")
	--local data = ""
	if file then
		--print("File Found")
		for i = 1, row do
			value = ""
			value = file:read("*l")
			if i == row then
				return value
			end
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
 -- Render Row
 -- Renders/draws scollable TableView of country data
 --
local function onRowRender( event )
	local temp = ""
	
    -- Get reference to the row group
    row = event.row
	
    -- TODO******** Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = 100
    --local rowWidth = 3000
	temp = row.id
    local rowTitle = display.newText(row,row.id, 0, 0,270,0,native.systemFont, 15 )
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

	
 
 
-- create()
function scene:create( event )
 
    dataGroup = self.view
	flagDataGroup = display.newGroup()
	
    -- Code here runs when the scene is first created but has not yet appeared on screen
	local bg2X,bg2Y = display.contentCenterX, display.contentCenterY
	local bg2 = display.newRect( bg2X, bg2Y, display.contentWidth, display.contentHeight + 100 )
	bg2.fill = { type="image", filename="bg_blue.jpg" }
	flagDataGroup:insert( bg2 )
	
	backButton2 = widget.newButton(
		{
			onRelease = goBack,
			x = 29,
			y = 500,
			width = 40,
			height = 40,
			defaultFile = "backButtonDefault.png",
			overFile = "backButtonPressed.png"
		}
	)
	flagDataGroup:insert(backButton2)
	
	local countryName = composer.getVariable( "countryString" )
	local DisplayName = composer.getVariable( "countryDisplayString" ) 
	cID = composer.getVariable( "countryID" )
	print(cID)
	
	local someString = "flags/"..countryName..".png"
	local flagImage = display.newImageRect(flagDataGroup,someString, 100, 100)
	flagDataGroup:insert( flagImage )
	flagImage.x = display.contentCenterX
	flagImage.y = display.contentCenterY - 238
	
	local text1 = display.newText(flagDataGroup,DisplayName,display.contentCenterX-100,display.contentCenterY - 245,110,0,native.systemFont,17)
	
	local path = system.pathForFile( "wjp.csv", system.ResourceDirectory )
	dataGroup:insert( flagDataGroup )
	
	--Open File.
	local file = io.open(path, "r")
	if file then
		print("File Found")
		country = file:read("*l")
		io.close (file)
	else
		print("Not working") --No file/Error
	end
	displayATable(cID)
	dataGroup:insert(tableView)	
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