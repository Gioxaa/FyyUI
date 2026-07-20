--[[
	FyyUI v0.1.0
	Roblox UI Library
	@github fyyhub/FyyUI
	
	local FyyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/fyyhub/FyyUI/main/fyyui.lua"))()
	local menu = FyyUI.Menu({ Title = "Hub" })
	menu:Toggle({ Text = "Auto Farm", Description = "Farms resources automatically", Callback = function(v) end })
]]

return (function()
	local Theme = {
		Dark = {
			Background = Color3.fromRGB(20, 20, 25),
			Topbar = Color3.fromRGB(28, 28, 34),
			TopbarBorder = Color3.fromRGB(40, 40, 48),
			Accent = Color3.fromRGB(0, 140, 255),
			AccentSecondary = Color3.fromRGB(100, 60, 255),
			TextPrimary = Color3.fromRGB(230, 230, 240),
			TextSecondary = Color3.fromRGB(150, 150, 165),
			TextMuted = Color3.fromRGB(100, 100, 115),
			Element = Color3.fromRGB(38, 38, 46),
			ElementHover = Color3.fromRGB(48, 48, 56),
			ElementBorder = Color3.fromRGB(50, 50, 60),
			ElementSelected = Color3.fromRGB(0, 120, 230),
			ToggleOn = Color3.fromRGB(0, 190, 90),
			ToggleOff = Color3.fromRGB(58, 58, 68),
			ToggleKnob = Color3.fromRGB(215, 215, 225),
			Border = Color3.fromRGB(45, 45, 55),
			ScrollBar = Color3.fromRGB(70, 70, 85),
			Font = Enum.Font.SourceSans,
			FontBold = Enum.Font.SourceSansBold,
			FontSize = 15,
			FontSizeTitle = 18,
			FontSizeSmall = 13,
			Padding = 10,
			CornerRadius = 8,
			TopbarHeight = 42,
			ElementHeight = 34,
			DescHeight = 50,
			Spacing = 4,
		},
		Light = {
			Background = Color3.fromRGB(245, 245, 250),
			Topbar = Color3.fromRGB(235, 235, 242),
			TopbarBorder = Color3.fromRGB(220, 220, 230),
			Accent = Color3.fromRGB(0, 120, 240),
			AccentSecondary = Color3.fromRGB(80, 50, 230),
			TextPrimary = Color3.fromRGB(30, 30, 40),
			TextSecondary = Color3.fromRGB(100, 100, 115),
			TextMuted = Color3.fromRGB(150, 150, 165),
			Element = Color3.fromRGB(225, 225, 234),
			ElementHover = Color3.fromRGB(215, 215, 226),
			ElementBorder = Color3.fromRGB(210, 210, 220),
			ElementSelected = Color3.fromRGB(0, 110, 225),
			ToggleOn = Color3.fromRGB(0, 175, 80),
			ToggleOff = Color3.fromRGB(180, 180, 192),
			ToggleKnob = Color3.fromRGB(245, 245, 250),
			Border = Color3.fromRGB(210, 210, 222),
			ScrollBar = Color3.fromRGB(180, 180, 195),
			Font = Enum.Font.SourceSans,
			FontBold = Enum.Font.SourceSansBold,
			FontSize = 15,
			FontSizeTitle = 18,
			FontSizeSmall = 13,
			Padding = 10,
			CornerRadius = 8,
			TopbarHeight = 42,
			ElementHeight = 34,
			DescHeight = 50,
			Spacing = 4,
		},
	}

	function Theme:Override(base, overrides)
		base = type(base) == "string" and self[base] or base
		if not base then base = self.Dark end
		local merged = {}
		for k, v in pairs(base) do merged[k] = v end
		for k, v in pairs(overrides or {}) do merged[k] = v end
		return merged
	end

	local U = {}

	function U.Create(className, properties, children)
		local inst = Instance.new(className)
		if properties then
			for k, v in pairs(properties) do
				inst[k] = v
			end
		end
		if children then
			for _, child in ipairs(children) do
				child.Parent = inst
			end
		end
		return inst
	end

	function U.Shadow(parent, transparency)
		return U.Create("ImageLabel", {
			Name = "Shadow",
			Size = UDim2.new(1, 8, 1, 8),
			Position = UDim2.fromOffset(-4, -4),
			BackgroundTransparency = 1,
			Image = "rbxassetid://6015897843",
			ImageTransparency = transparency or 0.55,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(10, 10, 118, 118),
			Parent = parent,
		})
	end

	local Toggle = {}
	Toggle.__index = Toggle

	function Toggle.new(parent, options, theme)
		local self = setmetatable({}, Toggle)
		self.Text = options.Text or "Toggle"
		self.Description = options.Description
		self.Value = options.Default or false
		self.Callback = options.Callback or function() end
		self.Enabled = true
		self.Theme = theme
		self.HasDesc = self.Description ~= nil and self.Description ~= ""
		local h = self.HasDesc and theme.DescHeight or theme.ElementHeight

		self.Container = U.Create("Frame", {
			Name = "Toggle",
			Size = UDim2.new(1, 0, 0, h),
			BackgroundTransparency = 1,
			Parent = parent,
		})

		self.Label = U.Create("TextLabel", {
			Name = "Label",
			Size = UDim2.new(1, -60, 0, 20),
			Position = UDim2.fromOffset(0, self.HasDesc and 2 or (h - 20) / 2),
			BackgroundTransparency = 1,
			Text = self.Text,
			Font = theme.Font,
			TextSize = theme.FontSize,
			TextColor3 = theme.TextPrimary,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			Parent = self.Container,
		})

		if self.HasDesc then
			self.DescLabel = U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, -60, 0, 16),
				Position = UDim2.fromOffset(0, 24),
				BackgroundTransparency = 1,
				Text = self.Description,
				Font = theme.Font,
				TextSize = theme.FontSizeSmall,
				TextColor3 = theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Parent = self.Container,
			})
		end

		self.Track = U.Create("ImageButton", {
			Name = "Track",
			Size = UDim2.fromOffset(46, 24),
			Position = UDim2.new(1, -54, 0.5, -12),
			BackgroundColor3 = self.Value and theme.ToggleOn or theme.ToggleOff,
			AutoButtonColor = false,
			Parent = self.Container,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self.Track })

		self.Knob = U.Create("Frame", {
			Name = "Knob",
			Size = UDim2.fromOffset(18, 18),
			Position = UDim2.fromOffset(self.Value and 26 or 2, 3),
			BackgroundColor3 = theme.ToggleKnob,
			Parent = self.Track,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self.Knob })

		self.Track.MouseButton1Click:Connect(function()
			if not self.Enabled then return end
			self:SetValue(not self.Value)
		end)

		return self
	end

	function Toggle:_animate(value)
		local ts = game:GetService("TweenService")
		local ti = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		ts:Create(self.Track, ti, { BackgroundColor3 = value and self.Theme.ToggleOn or self.Theme.ToggleOff }):Play()
		ts:Create(self.Knob, ti, { Position = UDim2.fromOffset(value and 26 or 2, 3) }):Play()
	end

	function Toggle:SetValue(value, instant)
		if self.Value == value then return end
		self.Value = value
		if instant then
			self.Track.BackgroundColor3 = value and self.Theme.ToggleOn or self.Theme.ToggleOff
			self.Knob.Position = UDim2.fromOffset(value and 26 or 2, 3)
		else
			self:_animate(value)
		end
		self.Callback(value)
	end

	function Toggle:GetValue() return self.Value end

	function Toggle:SetEnabled(enabled)
		self.Enabled = enabled
		self.Track.BackgroundTransparency = enabled and 0 or 0.5
		self.Knob.BackgroundTransparency = enabled and 0 or 0.5
	end

	function Toggle:SetText(text)
		self.Text = text
		self.Label.Text = text
	end

	function Toggle:SetDescription(desc)
		self.Description = desc
		if self.DescLabel then
			self.DescLabel.Text = desc or ""
		end
	end

	function Toggle:Destroy()
		if self.Container then self.Container:Destroy() end
	end

	local Menu = {}
	Menu.__index = Menu

	function Menu.new(options, theme)
		local self = setmetatable({}, Menu)
		self.Options = options
		self.Theme = theme
		self.Components = {}
		self.Visible = options.Visible ~= false

		local size = options.Size or Vector2.new(450, 550)
		local pos = options.Position or UDim2.new(0.5, -size.X / 2, 0.5, -size.Y / 2)

		self.Gui = U.Create("ScreenGui", {
			Name = options.Title or "FyyUI",
			DisplayOrder = 100,
			IgnoreGuiInset = true,
			Enabled = self.Visible,
		})
		U.Shadow(self.Gui, 0.55)

		self.Frame = U.Create("Frame", {
			Name = "Main",
			Size = UDim2.fromOffset(size.X, size.Y),
			Position = pos,
			BackgroundColor3 = theme.Background,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Parent = self.Gui,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, theme.CornerRadius), Parent = self.Frame })

		self.Topbar = U.Create("Frame", {
			Name = "Topbar",
			Size = UDim2.new(1, 0, 0, theme.TopbarHeight),
			BackgroundColor3 = theme.Topbar,
			BorderSizePixel = 0,
			Parent = self.Frame,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, theme.CornerRadius), Parent = self.Topbar })
		U.Create("Frame", {
			Name = "TopbarFill",
			Size = UDim2.new(1, 0, 0, theme.CornerRadius),
			Position = UDim2.new(0, 0, 1, -theme.CornerRadius),
			BackgroundColor3 = theme.Topbar,
			BorderSizePixel = 0,
			Parent = self.Topbar,
		})
		U.Create("Frame", {
			Name = "TopbarBorder",
			Size = UDim2.new(1, -16, 0, 1),
			Position = UDim2.new(0, 8, 1, 0),
			BackgroundColor3 = theme.TopbarBorder,
			BorderSizePixel = 0,
			Parent = self.Topbar,
		})

		self.Title = U.Create("TextLabel", {
			Name = "Title",
			Size = UDim2.new(1, -80, 1, 0),
			Position = UDim2.fromOffset(14, 0),
			BackgroundTransparency = 1,
			Text = options.Title or "FyyUI",
			Font = theme.FontBold,
			TextSize = theme.FontSizeTitle,
			TextColor3 = theme.TextPrimary,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = self.Topbar,
		})

		self.CloseBtn = U.Create("ImageButton", {
			Name = "Close",
			Size = UDim2.fromOffset(26, 26),
			Position = UDim2.new(1, -36, 0.5, -13),
			BackgroundColor3 = Color3.fromRGB(55, 55, 65),
			AutoButtonColor = false,
			Parent = self.Topbar,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self.CloseBtn })
		U.Create("TextLabel", {
			Name = "CloseIcon",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
			Text = "\215",
			Font = theme.FontBold,
			TextSize = 18,
			TextColor3 = Color3.fromRGB(180, 180, 190),
			Parent = self.CloseBtn,
		})

		self.Container = U.Create("ScrollingFrame", {
			Name = "Container",
			Size = UDim2.new(1, -theme.Padding * 2, 1, -(theme.TopbarHeight + theme.Padding + 4)),
			Position = UDim2.fromOffset(theme.Padding, theme.TopbarHeight + theme.Padding + 2),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = theme.ScrollBar,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Parent = self.Frame,
		})

		self:_dragging()
		self.CloseBtn.MouseButton1Click:Connect(function() self:SetVisible(false) end)

		local parentInst = options.Parent or game:GetService("CoreGui")
		self.Gui.Parent = parentInst

		return self
	end

	function Menu:_dragging()
		local topbar = self.Topbar
		local frame = self.Frame
		local dragging, dragStart, startPos = false

		topbar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = frame.Position
			end
		end)
		topbar.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
				local delta = input.Position - dragStart
				frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
		topbar.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end

	function Menu:Toggle(options)
		options = options or {}
		local toggle = Toggle.new(self.Container, options, self.Theme)
		table.insert(self.Components, toggle)
		return toggle
	end

	function Menu:Button(options)
		options = options or {}
		local theme = self.Theme
		local hasDesc = options.Description ~= nil and options.Description ~= ""
		local h = hasDesc and theme.DescHeight or theme.ElementHeight
		local btn = {}

		btn.Container = U.Create("Frame", {
			Name = "ButtonContainer",
			Size = UDim2.new(1, 0, 0, h + 4),
			BackgroundTransparency = 1,
			Parent = self.Container,
		})

		local padTop = hasDesc and 4 or (h - theme.ElementHeight) / 2 + 2

		btn.Button = U.Create("ImageButton", {
			Name = "Button",
			Size = UDim2.new(1, 0, 0, h),
			Position = UDim2.fromOffset(0, padTop),
			BackgroundColor3 = theme.Element,
			AutoButtonColor = false,
			Parent = btn.Container,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn.Button })

		if hasDesc then
			U.Create("TextLabel", {
				Name = "Text",
				Size = UDim2.new(1, -16, 0, 20),
				Position = UDim2.fromOffset(8, 4),
				BackgroundTransparency = 1,
				Text = options.Text or "Button",
				Font = theme.Font,
				TextSize = theme.FontSize,
				TextColor3 = options.Color or theme.TextPrimary,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = btn.Button,
			})
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, -16, 0, 16),
				Position = UDim2.fromOffset(8, 26),
				BackgroundTransparency = 1,
				Text = options.Description,
				Font = theme.Font,
				TextSize = theme.FontSizeSmall,
				TextColor3 = theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = btn.Button,
			})
		else
			U.Create("TextLabel", {
				Name = "Text",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				Text = options.Text or "Button",
				Font = theme.FontBold,
				TextSize = theme.FontSize,
				TextColor3 = options.Color or theme.TextPrimary,
				Parent = btn.Button,
			})
		end

		btn.Button.MouseEnter:Connect(function() btn.Button.BackgroundColor3 = theme.ElementHover end)
		btn.Button.MouseLeave:Connect(function() btn.Button.BackgroundColor3 = theme.Element end)
		btn.Button.MouseButton1Click:Connect(function()
			if options.Callback then options.Callback() end
		end)

		btn.SetText = function(text) btn.Button.TextLabel.Text = text end
		btn.SetCallback = function(cb) options.Callback = cb end
		btn.Destroy = function() if btn.Container then btn.Container:Destroy() end end

		table.insert(self.Components, btn)
		return btn
	end

	function Menu:Label(options)
		options = options or {}
		local hasDesc = options.Description ~= nil and options.Description ~= ""
		local h = hasDesc and self.Theme.DescHeight or self.Theme.ElementHeight
		local lbl = {}

		lbl.Container = U.Create("Frame", {
			Name = "Label",
			Size = UDim2.new(1, 0, 0, h),
			BackgroundTransparency = 1,
			Parent = self.Container,
		})

		lbl.TextLabel = U.Create("TextLabel", {
			Name = "Text",
			Size = UDim2.new(1, 0, 0, hasDesc and 20 or h),
			Position = UDim2.fromOffset(0, hasDesc and 2 or 0),
			BackgroundTransparency = 1,
			Text = options.Text or "",
			Font = self.Theme.Font,
			TextSize = options.TextSize or self.Theme.FontSize,
			TextColor3 = options.Color or self.Theme.TextSecondary,
			TextXAlignment = Enum.TextXAlignment.Left,
			RichText = true,
			Parent = lbl.Container,
		})

		if hasDesc then
			lbl.DescLabel = U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, 0, 0, 16),
				Position = UDim2.fromOffset(0, 24),
				BackgroundTransparency = 1,
				Text = options.Description,
				Font = self.Theme.Font,
				TextSize = self.Theme.FontSizeSmall,
				TextColor3 = self.Theme.TextMuted,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
				Parent = lbl.Container,
			})
		end

		lbl.SetText = function(text) lbl.TextLabel.Text = text end
		lbl.SetColor = function(color) lbl.TextLabel.TextColor3 = color end
		if lbl.DescLabel then
			lbl.SetDescription = function(desc) lbl.DescLabel.Text = desc end
		end
		lbl.Destroy = function() if lbl.Container then lbl.Container:Destroy() end end

		table.insert(self.Components, lbl)
		return lbl
	end

	function Menu:Divider()
		local div = {}
		div.Container = U.Create("Frame", {
			Name = "Divider",
			Size = UDim2.new(1, 0, 0, 12),
			BackgroundTransparency = 1,
			Parent = self.Container,
		})
		U.Create("Frame", {
			Name = "Line",
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0.5, 0),
			BackgroundColor3 = self.Theme.Border,
			BorderSizePixel = 0,
			Parent = div.Container,
		})
		div.Destroy = function() if div.Container then div.Container:Destroy() end end
		table.insert(self.Components, div)
		return div
	end

	function Menu:SetVisible(visible)
		self.Visible = visible
		if self.Gui then self.Gui.Enabled = visible end
	end

	function Menu:ToggleVisibility() self:SetVisible(not self.Visible) end
	function Menu:GetVisible() return self.Visible end
	function Menu:SetTitle(title) self.Title.Text = title end

	function Menu:Destroy()
		for _, comp in ipairs(self.Components) do
			if comp.Destroy then comp:Destroy() end
		end
		self.Components = {}
		if self.Gui then self.Gui:Destroy() end
	end

	local FyyUI = {
		Version = "0.1.0",
		Theme = Theme,
	}

	function FyyUI.Menu(options)
		options = options or {}
		local themeName = options.Theme or "Dark"
		local theme = type(themeName) == "string" and Theme[themeName] or themeName
		if not theme then theme = Theme.Dark end
		if options.ColorOverride then
			theme = Theme:Override(theme, options.ColorOverride)
		end
		return Menu.new(options, theme)
	end

	return FyyUI
end)()
