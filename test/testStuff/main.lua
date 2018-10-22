-----------------------------------------------------------------------------------------
--
-- main.lua
-- Country Law App Test Suite.
-----------------------------------------------------------------------------------------


luaunit = require('luaunit')

function add(v1,v2)
    -- add positive numbers
    -- return 0 if any of the numbers are 0
    -- error if any of the two numbers are negative
    if v1 < 0 or v2 < 0 then
        error('Can only add positive or null numbers, received '..v1..' and '..v2)
    end
    if v1 == 0 or v2 == 0 then
        return 0
    end
    return v1+v2
end

-------------------------------------
--Make an Array - contains capitals
--Ignors commas, "
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

function findChars(array,search) 

	local someString = ""
	local startpos = 200
	Poscounter = 0 
	local flag = 0
	local foundArray= {}
	k = 1
	--Runtime:removeEventListener( "touch", touchListener )
	--Comapare each charater in the string, count the matches
	for i = 1, #array  do --Start at index 2 to disclude the headers ie Country, Country Code etc.**WALK AROUND!!
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
			--Poscounter = Poscounter + 1 -- For button Spacing on Y axis.See var 'top' below
			--print("Found "..array[i].. " at index position "..i) --Debug	
			foundArray[k] = i
			k = k +1
			flag = 1 -- Found search term Flag	
			
		else
			--flag = 0
		end		
	end
	return flag

end

-----------------------------------------------------------------------------------
--Get Row Data (Country Data)
--From the flat file
-----------------------------------------------------------------------------------
function getRow(row)
	local path = system.pathForFile( "wjp.csv", system.ResourceDirectory )
	local file = io.open(path,"r")
	--local data = ""
	local flag = 0
	local counter = 0
	if file then
		--print("File Found")
		for i = 1, row do
			value = ""
			value = file:read("*l")
			if value then
			counter = counter + 1
			end
		end
	
		if counter == row then
			flag = 1
		else
			flag = 0
		end
		
	end
	return flag
end

----------------------------------------------------------------------------------
-- Sort an Array; Highest to lowest. - Alpha Ass
----------------------------------------------------------------------------------
function sortArray(arr,arr2,arr3,arr4)
	for i = 1, #arr do
		local k = 1
		for k = k + i, #arr do

			if(arr[i] < arr[k])then
				local temp1 = arr[i]
				local temp2 = arr2[i]
				local temp3 = arr3[i]
				local temp4 = arr4[i]
				arr[i] = arr[k]
				arr2[i] = arr2[k]
				arr3[i] = arr3[k]
				arr4[i] = arr4[k]
				arr[k] = temp1	
				arr2[k] = temp2
				arr3[k] = temp3
				arr4[k] = temp4
			end
		end
				
	end
	return arr4
end	
-----------------------------------------
-- Test Functions
--


function testAddPositive()
    luaunit.assertEquals(add(1,1),2)
end

function testAddZero()
    luaunit.assertEquals(add(1,0),0)
    luaunit.assertEquals(add(0,5),0)
    luaunit.assertEquals(add(0,0),0)
end


---------------------------
-- TestArray Functions
--
function testRawArrayRetArr()
	a = "the,do\g,was,M\AD,so,we,shot,him,.,:)"
	luaunit.assertIsTable(rawArray(a))
end

function testRawArray() 
	a = "the,do\g,was,M\AD,so,we,shot,him,.,:)"
	b = {"the","dog","was","MAD","so","we","shot","him",".",":)"}
	c = {"pear","carrot","berry","tomato","pear","apple"}
	
	luaunit.assertEquals(rawArray("1,2,3,4,5,6,7,8,9,0"),{"1","2","3","4","5","6","7","8","9","0"})
	luaunit.assertEquals(rawArray(a),b)
end
	
function testMakeArrayIsArr()
	a = "the,do\g,was,M\AD,so,we,shot,him,.,:)"
	luaunit.assertIsTable(rawArray(a))
end

function testMakeArray()
	
	a = "TH\E,DOG,WAS,MAD,SO,WE,SHOT,HIM"
	b = {"the","dog","was","mad","so","we","shot","him"}
	
	luaunit.assertEquals(rawArray("1,2,3,4,5,6,7,8,9,0"),{"1","2","3","4","5","6","7","8","9","0"})
	luaunit.assertEquals(makeArray(a),b)
end

function testFindChars()

	a = {"the","dog","was","mad","so","we","shot","him"}
	b = "dog"
	c = {"pear","carrot","berry","tomato","pear","apple"}
	d = "apple"
	
	luaunit.assertEquals(findChars(a,b), 1)
	luaunit.assertEquals(findChars(c,d), 1)
	luaunit.assertEquals(findChars(c,b), 0) --Should Fail so return 0 pass
	
end

function testFileOpen()

	luaunit.assertEquals(getRow(1),1)
	luaunit.assertEquals(getRow(20),1)
	luaunit.assertEquals(getRow(130),0) --Will Fail so '0'
	
end

function testArraySort()
	a = {"pear","carrot","berry","tomato","apple"}
	b = {"pear","carrot","berry","tomato","apple"}
	c = {"pear","carrot","berry","tomato","apple"}
	d = {"pear","carrot","berry","tomato","apple"}
	f = {"tomato","pear","carrot","berry","apple"}
	
	
	luaunit.assertEquals(sortArray(a,b,c,d),f)
end

--os.exit( luaunit.LuaUnit.run() )

luaunit.LuaUnit.run()