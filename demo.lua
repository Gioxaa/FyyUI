-- FyyUI Demo
-- local FyyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/FyyWannaFly/FyyUI/main/fyyui.lua"))()
local FyyUI = require(script.fyyui)

-- Pake Logo (optional: kasih rbxassetid)
-- local menu = FyyUI.Menu({
--     Title = "FyyUI Hub",
--     Logo = "rbxassetid://123456789",
--     Size = UDim2.fromOffset(530, 300),
--     MinSize = Vector2.new(320, 300),
--     MaxSize = Vector2.new(850, 560),
--     Resizable = true,
--     HasOutline = true,
--     Topbar = { ButtonsType = "Mac", TitleAlignment = "Left" },
-- })

local menu = FyyUI.Menu({
	Title = "FyyUI Hub",
	Size = UDim2.fromOffset(420, 360),
	MinSize = Vector2.new(300, 250),
	MaxSize = Vector2.new(800, 560),
	Resizable = true,
	HasOutline = true,
})

menu:Toggle({
	Text = "Auto Farm",
	Description = "Automatically farms ores",
	Default = false,
	Callback = function(v) print("[Auto Farm]", v) end,
})

menu:Toggle({
	Text = "Auto Collect",
	Description = "Collects dropped items",
	Default = true,
	Callback = function(v) print("[Auto Collect]", v) end,
})

menu:Divider()

menu:Button({
	Text = "Toggle All",
	Description = "Enable or disable all features",
	Callback = function() print("Toggle All!") end,
})

menu:Button({
	Text = "Stop",
	Description = "Stops all automation",
	Color = Color3.fromRGB(255, 80, 80),
	Callback = function() print("Stopped!") end,
})

menu:Divider()

menu:Label({
	Text = "Status: Running",
	Description = "All systems operational",
})

menu:Label({
	Text = "Connected",
	Color = Color3.fromRGB(0, 200, 100),
})

game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		menu:ToggleVisibility()
	end
end)

print("FyyUI loaded!")
