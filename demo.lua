-- FyyUI Demo
-- Load dari GitHub (ganti kalo fork)
local FyyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/FyyWannaFly/FyyUI/main/fyyui.lua"))()

-- Kalo lokal: local FyyUI = require(script.fyyui)

local menu = FyyUI.Menu({
	Title = "FyyUI Hub",
	Size = Vector2.new(460, 580),
	Theme = "Dark",
})

menu:Toggle({
	Text = "Auto Farm",
	Description = "Automatically farms ores in the mine",
	Default = false,
	Callback = function(state)
		print("[Auto Farm]", state)
	end,
})

menu:Toggle({
	Text = "Auto Collect",
	Description = "Collects dropped items automatically",
	Default = true,
	Callback = function(state)
		print("[Auto Collect]", state)
	end,
})

menu:Divider()

menu:Button({
	Text = "Toggle All",
	Description = "Enable or disable all features at once",
	Callback = function()
		print("Toggle All pressed!")
	end,
})

menu:Button({
	Text = "Stop",
	Description = "Stops all running automation",
	Color = Color3.fromRGB(255, 80, 80),
	Callback = function()
		print("Stopped!")
	end,
})

menu:Divider()

menu:Label({
	Text = "Status: Running",
	Description = "All systems operational",
})

local statusLabel = menu:Label({
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
