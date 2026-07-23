-- Roblox Studio / executor smoke harness.
--
-- Load the local fyyui.lua into FyyUI, then run:
--   require-or-load-this-file(FyyUI)
-- The function deliberately uses only the public API except for checking that
-- transient overlays were removed; those checks protect the lifecycle bug this
-- release fixes.
return function(FyyUI)
	local callbacks = { toggle = 0, checkbox = 0 }
	local menu = FyyUI.Menu({
		Title = "FyyUI hardening regression",
		Stats = false,
		Scale = 9, -- constructor must clamp to the supported range.
	})
	assert(menu:GetScale() == 1.35, "constructor scale must be clamped")

	local tab = menu:Tab({ Text = "Regression" })
	local toggle = tab:Toggle({ Flag = "toggle", Callback = function() callbacks.toggle += 1 end })
	local checkbox = tab:Checkbox({ Flag = "checkbox", Callback = function() callbacks.checkbox += 1 end })
	local multi = tab:Dropdown({
		Flag = "multi",
		Multi = true,
		Options = { "One", "Two" },
		Default = { "One", "Unknown" },
	})
	local single = tab:Dropdown({ Flag = "single", Options = { "One", "Two" }, Default = "One" })

	assert(#multi:GetValue() == 1 and multi:GetValue()[1] == "One", "multi default must exclude unknown options")
	local rejected, rejectionDetails = menu:ImportConfig({ Values = { single = "Unknown" } })
	assert(not rejected and #rejectionDetails.Failed == 1, "rejected setter values must fail config import")
	local ok = menu:ImportConfig({ Values = { toggle = true, checkbox = true } }, { NoCallbacks = true })
	assert(ok, "valid config import should succeed")
	task.wait()
	assert(callbacks.toggle == 0 and callbacks.checkbox == 0, "NoCallbacks must suppress toggle and checkbox callbacks")

	menu:OpenCommandPalette()
	menu:SetVisible(false)
	assert(not menu._paletteOpen and menu._paletteOverlay == nil, "hidden menu must close the command palette")

	toggle:Destroy()
	local changed, err = toggle:SetValue(false)
	assert(changed == false and err == "destroyed", "destroyed setters must be safe")
	assert(menu:ExportConfig().Values.toggle == nil, "destroyed flagged controller must not export")

	assert(not pcall(function() tab:Slider({ Min = 10, Max = 0 }) end), "invalid slider bounds must fail early")
	assert(not pcall(function() tab:Slider({ Step = 0 }) end), "zero slider step must fail early")

	menu:Destroy()
end
