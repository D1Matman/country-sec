--
-- For more information on config.lua see the Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings
--

application =
{
	content =
	{
		width = 320,
		height = 480, 
		scale = "letterbox",
		fps = 60,
		
		--[[
		imageSuffix =
		{
			    ["@2x"] = 2,
			    ["@4x"] = 4,
		},
		--]]
	},
}

settings =
{
    window =
    {
		defaultViewWidth = 414,
		defaultViewHeight = 736,
		resizable = true,
		minViewWidth = 414,
		minViewHeight = 736,
		--enableMaximizeButton = true,
		titleText = {
            default = "Global Security & Laws Travel Companion"
        },
    },  
}