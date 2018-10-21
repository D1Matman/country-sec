local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local scene = composer.newScene()
 
local prevScene = composer.getSceneName("previous") -- Get the last scene
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
--Function to launch webpage in system default browser
--passing in the country's name to insert into the URL (note: but corona button functions dont play nice with argument params for some reason!)
-----------------------------------------------------------------------------------
local function gotoWebNews()
	system.vibrate()
	audio.play( soundTable["soundSelect"] )
	-- create variable for countryname & init variable for URL string
	local name = countryName
	local newsUrl
	
	-- modify country name to replace any inner spaces in string with "+" signs to be used in URL string for web search
	-- ref: https://stackoverflow.com/questions/10460126/how-to-remove-spaces-from-a-string-in-lua
	name = name:gsub("%s+", "+")	
	
	-- url string for webpage, inserting country name
	-- example -- https://www.google.com/search?q=south+africa+visitor+security+risk+safety+travel+caution+concern	
	newsUrl = "https://www.google.com/search?q="..name.."+visitor+security+risk+safety+travel+caution+concern"
	
	-- open the web page
	system.openURL( newsUrl )
end

-----------------------------------------------------------------------------------
--Go back to previous screen
--
-----------------------------------------------------------------------------------
local function goBack()
	system.vibrate()
	audio.play( soundTable["soundBack"] )
	-- Completely remove the scene, including its scene object
    composer.removeScene( "ViewByCountryInfo" )
	composer.gotoScene( prevScene, { time=800, effect="crossFade" } )
end

-----------------------------------------------------------------------------------
--Get Row Data (Country Data)
--From the flat file
-----------------------------------------------------------------------------------
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

-----------------------------------------------------------------------------------
--Make a Country Array
--Ignors commas, "
--Convers Case to lower
-----------------------------------------------------------------------------------
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

-----------------------------------------------------------------------------------
 -- Render Row
 -- Renders/draws scollable TableView of country data
 --
 ----------------------------------------------------------------------------------
local function onRowRender( event )
	local temp = ""
	
    -- Get reference to the row group
    row = event.row
	
    -- TODO******** Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = 100
    --local rowWidth = 3000
	temp = row.id
    local rowTitle

	-- Set different fill colours to differentiate important category / headers
	if (string.find(temp,"OVERALL") == 1)then
		rowTitle = display.newEmbossedText(row,row.id, 0, 0,270,0,native.systemFontBold, 15 )
		rowTitle:setFillColor( 0.95, 0.95, 0 ) -- major category
	elseif (string.find(temp,"Government accou") == 1) then
		rowTitle = display.newEmbossedText(row,row.id, 0, 0,270,0,native.systemFontBold, 15 )
		rowTitle:setFillColor( 1, 0.8, 0 )	-- major category / header
	elseif (string.find(temp,"Absence") == 1) then
		rowTitle = display.newEmbossedText(row,row.id, 0, 0,270,0,native.systemFontBold, 15 )
		rowTitle:setFillColor( 1, 0.8, 0 )	-- major category / header
	elseif (string.find(temp,"Fundamental rights") == 1) then
		rowTitle = display.newEmbossedText(row,row.id, 0, 0,270,0,native.systemFontBold, 15 )
		rowTitle:setFillColor( 1, 0.8, 0 )	-- major category / header
	elseif (string.find(temp,"Public order") == 1) then
		rowTitle = display.newEmbossedText(row,row.id, 0, 0,270,0,native.systemFontBold, 15 )
		rowTitle:setFillColor( 1, 0.8, 0 )	-- major category / header
	elseif (string.find(temp,"Civil &") == 1) then
		rowTitle = display.newEmbossedText(row,row.id, 0, 0,270,0,native.systemFontBold, 15 )
		rowTitle:setFillColor( 1, 0.8, 0 )	-- major category / header		
	else
		rowTitle = display.newEmbossedText(row,row.id, 0, 0,270,0,native.systemFont, 15 )
		rowTitle:setFillColor( 1,1,1 )	-- minor rating category only
	end

    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 20      --Where inside the ROW
    rowTitle.y = 30
	rowHeight = rowHeight * 0.5
	isBounceEnabled = false
	
end

-----------------------------------------------------------------------------------
-- Display a table of country data
--
-----------------------------------------------------------------------------------
 function displayATable(TheEvent) -- Create Table View

	tableView = widget.newTableView(
			{
			top = 60,
			left = 0,
			height = 396,        --Height and width of the actual Table View
			width = 310,
			onRowRender = onRowRender,
			onRowTouch = onRowTouch,
			listener = scrollListener,
			hideBackground = true
			}
		)
					
		for i = 2, 46 do          -- 46 the amount of lines in the flat file! TODO full proof this! ***Had to Change this FACTOR has been removed from CSV
			response = getRow(i)
			local dummyArray = {}
			local titleArray = {}
			dummyArray = makeArray(response)
			CountryToDisplay[i] = dummyArray[TheEvent]
			titleArray[i] = dummyArray[1]
			dummyArray = nil -- Kill It.
			
			local isCategory = false
			local rowHeight = 61 ----------------------------------------ROW HEIGHT get the magic right.
			local rowColor = { default={ 0, 0, 0,0}, over={ 0, 0, 0,0} }
			local lineColor = { 1, 1, 1, 0.5}
			
			local SectionString = titleArray[i]
			local DataString = CountryToDisplay[i]
			
			-- capitalisation of rating strings
			if (string.find(SectionString,"overall") == 1) then
				SectionString = SectionString:gsub("%a", string.upper) --Make overall score ALL CAPS, since its most important.
			else
				SectionString = SectionString:gsub("%a", string.upper,1) --Make First letter a capital only, for the rest.
			end
			
			DataString = DataString:gsub("%a", string.upper,1)
			local id = SectionString.."    "..(DataString * 100).." / 100" --Concat output to display
			
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

-----------------------------------------------------------------------------------
-- create()
-----------------------------------------------------------------------------------

function scene:create( event )
 
    dataGroup = self.view
	flagDataGroup = display.newGroup()
	
    -- Code here runs when the scene is first created but has not yet appeared on screen
	local bg2X,bg2Y = display.contentCenterX, display.contentCenterY
	local bg2 = display.newRect( bg2X, bg2Y, display.contentWidth, display.contentHeight + 100 )
	bg2.fill = { type="image", filename="bg_blue.jpg" }
	flagDataGroup:insert( bg2 )

	-- thin blue border lines at top and bottom of scroll view window
	borderTop = display.newLine( display.contentCenterX - 200, display.contentCenterY - 181, display.contentCenterX + 200, display.contentCenterY - 181 )
	borderTop:setStrokeColor( 0.05, 0.23, 0.53 )
	borderTop.strokeWidth = 1

	borderBottom = display.newLine( display.contentCenterX - 200, display.contentCenterY + 217, display.contentCenterX + 200, display.contentCenterY + 217 )
	borderBottom:setStrokeColor( 0.05, 0.23, 0.53 )
	borderBottom.strokeWidth = 1	
	
	-- Add scroll border lines to display group
	flagDataGroup:insert(borderTop)
	flagDataGroup:insert(borderBottom)
	
	
	countryName = composer.getVariable( "countryString" )
	local DisplayName = composer.getVariable( "countryDisplayString" ) 
	cID = composer.getVariable( "countryID" )
	
	print(cID) -- Print Country ID DEBUG
	
	local someString = "flags/"..countryName..".png"
	local flagImage = display.newImageRect(flagDataGroup,someString, 50, 50)
	flagDataGroup:insert( flagImage )
	flagImage.x = display.contentCenterX - 118
	flagImage.y = display.contentCenterY - 224
	
	local text1 = display.newEmbossedText(flagDataGroup,DisplayName,display.contentCenterX + 42,display.contentCenterY - 224, 250, 0, native.systemFontBold, 20)
	
	-- create the Go Back button
	backButton2 = widget.newButton(
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
	flagDataGroup:insert(backButton2)
	
	-- create the News button
	newsButton = widget.newButton(
		{
			label = "View Latest News",
			labelColor = { default= {1, 1, 1, 1}, over={1, 1, 1, 0.5} },
			fontSize = 20,
			font = "Arial",
			onRelease = gotoWebNews,
			emboss = true,
			shape = "roundedRect",
			x = display.contentCenterX + 24,
			y = 494,
			width = 250,
			height = 44,
			cornerRadius = 6,
			fillColor = { default= {0.11, 0.43, 0.95, 1}, over={0.11, 0.43, 0.95, 0.5} },
			strokeColor = { default={0.05, 0.23, 0.53, 1}, over={0.05, 0.23, 0.53, 0.5} },
			strokeWidth = 5
		}
	)
	flagDataGroup:insert(newsButton)
	
	dataGroup:insert( flagDataGroup )
	
	local path = system.pathForFile( "wjp.csv", system.ResourceDirectory )	
	
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

		-- Here we will default scroll user to row of ranking category they were just looking at
		-- BUT only if previous scene was the Rankings screen 
		if ( prevScene == "ViewByRanking" ) then
		
			local catRow = composer.getVariable("LineNumber")
			print("Auto scroll down to relevant y height for rank category on database line #"..(composer.getVariable("LineNumber")))
			
			local catY
			
			if (catrow ~= 2) then
				if (catRow == 3) then
					catY = -50
				elseif (catRow == 14) then
					catY = -720	
				elseif (catRow == 19) then
					catY = -1033
				elseif (catRow == 28) then
					catY = -1580
				elseif (catRow == 32) then
					catY = -1826
				end

				tableView:scrollToY( 
					{
						y = catY,
						time = 0
					} 
				)
			end
		end
		
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
		backButton2:addEventListener("tap", goBack)
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