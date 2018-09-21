--Search test app
--Searches a CSV flat file for country names using a search term.
--Searches with complete words or imcomplete chars (from start of word ie Aus for Australia or A for all countries starting with A.
--Gets index of Column location  for the rest of the data in the flat file. ie to extract all the other needed data for that country 
--we need the index in the flat file.
--Ignors Upper case. 


display.setStatusBar( display.DarkStatusBar )
-- Vars
CountryArray = {}
CountryToDisplay = {}
flag = 0
FirstTimeFlag = 0
--Groups
ButtonGroup = display.newGroup()
debugGroup = display.newGroup()

local widget = require( "widget" )
local defaultField


--Search For complete string ie "Australia" case sensitive. NOT USED might use for system search.
function findit (array,search)
	daLength = #array
	for i = 1, daLength  do
	--print(coun[i].." "..i)
		if (array[i] == search) then
			--print("Found "..array[i].." at "..i) --Debug
			return i
		end
	end
	return 0
end

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

--Search partial string, not case sensitive. ie "A" or "Aust" etc
-- Display results as Buttons
--
function findChars(array,search) 
	local someString = ""
	local startpos = 200
	local counter = 0 --match counter
	local flag = 0
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
			
			counter = counter + 1 -- For button Spacing on Y axis.See var 'top' below
			print("Found "..array[i].. " at index position "..i) --Debug		
			flag = 1 -- Found search term Flag
			local Sstr = i
			local Sstr = widget.newButton -- Make Button
			{
				shape = "roundedRect",
				fontSize = 17,
				left = 35,
				top = (30 * counter) + 20,
				width = 250,
				height = 20,
				id = i,
				label = array[i],
				strokeWidth=12,
				labelColor = { default={ 0, 0.3, 1 }, over={ 1, 1, 1, 0.5 } },
				fillColor = { default={ .1, 0.2, 0.7, 0.5 },over={ 1, 0.2, 0.5, 1 }}, 
				emboss=false,
				cornerRadius=8,
				--onRelease = handleButtonEvent --Not needed have event listener below
			}
			-- Button event Handler for each button created. 
			Sstr:addEventListener( "touch", handleButtonEvent ) 
			ButtonGroup:insert(Sstr) --Make a group so we can remove them from the screen.
			
		end		
	end
	if(flag ~= 1) then --Search term Not Found.
		myText = display.newText(debugGroup,"Search Term Not Found!\n    Please Try Again",display.contentCenterX,startpos + (20*counter), 240, 300, native.systemFont, 22)
		myText:setFillColor( 0.8, 0, 0 )
		debugGroup:insert(myText)
		
	end
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
 
 -- Render Row
 -- Renders/draws scollable TableView of country data
 local function onRowRender( event )
	FirstTimeFlag = 1 --Are there any tables being displayed? see function textListener below
    -- Get reference to the row group
    row = event.row
	
    -- TODO******** Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = 100
    --local rowWidth = 3000
 
    local rowTitle = display.newText(row,row.id, 0, 0,270,0,native.systemFont, 14 )
    rowTitle:setFillColor( 0,0,8 )
 
    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 20      --Where inside the ROW
    rowTitle.y = 20
	rowHeight = rowHeight * 0.5
	isBounceEnabled = false

end

-- Function to handle button events 
-- Country Button Pressed!!!
-- 
function handleButtonEvent( event,self )

		--clear DebugGroup Remove from Screen!
		display.remove( debugGroup )
		dubugGroup = nil
		debugGroup = display.newGroup()

    if ( event.phase == "ended" ) then
        -- Code executed when the touch lifts off the object
        print( "touch ended on object " .. tostring(event.target.id) )
-- Create Table View
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
			print(CountryToDisplay[i])
			
			--print(dummyArray[i])
			dummyArray = nil -- Kill It.
			
			local isCategory = false
			local rowHeight = 70 ----------------------------------------ROW HEIGHT get the majic right.
			local rowColor = { default={ 0, 0, 0}, over={ 0, 0, 0} }
			local lineColor = { 0, 0, 0 }
			
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
			
    end 
return true  -- Prevents tap/touch propagation to underlying objects
end


--Get the text from the textbox ie the search term, TEXT TERM ENTERED
--Call findChars to get results 
-- Handels blank Chars
-- Should: Clear Buttons, Clear Rows, Clear Debug
-- ButtonGroup: Country Buttons

local function textListener( event )
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
				print("BLANK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
					myText = display.newText(debugGroup,"Please enter a search term!",display.contentCenterX,display.contentCenterY-180, native.systemFont, 22)
					myText:setFillColor( 0.8, 0, 0 )
					debugGroup:insert(myText)
			end	

		end
end

 ----------------------------------------------Begin-----------------------------------
 --------------------------------------------------------------------------------------
 
-- Variables
country = ""
--coun = {}
--code = {}
position = 0 

local composer = require( "composer" )
 
-- Create a background which should appear behind all scenes
local background = display.newImage( "world.png", 30, 140)

--Open the CSV file.
local path = system.pathForFile( "wjp.csv", system.ResourceDirectory )

local file = io.open(path, "r")
if file then
	--print("File Found")
	country = file:read("*l")
	--code = file:read("*l")
	--region = file:read("*l")
	io.close (file)

	else
		print("Not working") --No file/Error
end

CountryArray = makeArray(country)
print(country)
-- Create text field
defaultField = native.newTextField( 160, 25, 180, 30 )
defaultField:addEventListener( "userInput", textListener )
SearchTitle = display.newText("Search",display.contentCenterX,0, 0, 0, native.systemFont, 14)
SearchTitle:setFillColor( 0.1, 0.7, 0.3 )

-- XXXX logo
local image = display.newImageRect( "XXXXlogo.png", 90, 30 )
image.x = display.contentCenterX
image.y = 460

-- Show the objectimage (XXX) Logo
image.isVisible = true
 
 
 
 
 
 
-- Remove it
--image:removeSelf()
--image = nil
--Button NOT USED - text cleared in 'event'
--button1.x = display.contentCenterX
--button1.y = 400

--Debug
--position = findit(CountryArray,"Australia")
--print("Found target at position ", position)
--findChars(CountryArray,"St")
