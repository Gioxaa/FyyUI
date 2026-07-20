--[[
	FyyUI v0.1.0
	Roblox UI Library
	@github FyyWannaFly/FyyUI
	
	local FyyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/FyyWannaFly/FyyUI/main/fyyui.lua"))()
	local menu = FyyUI.Menu({ Title = "Hub" })
	menu:Toggle({ Text = "Auto Farm", Callback = function(v) end })
]]

return (function()
	local Theme = {
		Dark = {
			Background = Color3.fromRGB(18, 18, 22),
			Topbar = Color3.fromRGB(24, 24, 30),
			TopbarBorder = Color3.fromRGB(38, 38, 46),
			Accent = Color3.fromRGB(0, 130, 250),
			AccentLine = Color3.fromRGB(0, 150, 255),
			TextPrimary = Color3.fromRGB(225, 225, 235),
			TextSecondary = Color3.fromRGB(145, 145, 160),
			TextMuted = Color3.fromRGB(95, 95, 110),
			Element = Color3.fromRGB(35, 35, 42),
			ElementHover = Color3.fromRGB(45, 45, 54),
			ElementBorder = Color3.fromRGB(48, 48, 56),
			ToggleOn = Color3.fromRGB(0, 180, 80),
			ToggleOff = Color3.fromRGB(55, 55, 65),
			ToggleKnob = Color3.fromRGB(210, 210, 220),
			Border = Color3.fromRGB(40, 40, 48),
			ScrollBar = Color3.fromRGB(65, 65, 78),
			Font = Enum.Font.SourceSans,
			FontBold = Enum.Font.SourceSansBold,
			FontSize = 15,
			FontSizeTitle = 18,
			FontSizeSmall = 13,
			Padding = 10,
			CornerRadius = 8,
			TopbarHeight = 44,
			ElementHeight = 34,
			DescHeight = 52,
			Spacing = 6,
		},
		Light = {
			Background = Color3.fromRGB(242, 242, 247),
			Topbar = Color3.fromRGB(232, 232, 240),
			TopbarBorder = Color3.fromRGB(218, 218, 228),
			Accent = Color3.fromRGB(0, 115, 235),
			AccentLine = Color3.fromRGB(0, 130, 245),
			TextPrimary = Color3.fromRGB(28, 28, 36),
			TextSecondary = Color3.fromRGB(98, 98, 112),
			TextMuted = Color3.fromRGB(148, 148, 162),
			Element = Color3.fromRGB(222, 222, 232),
			ElementHover = Color3.fromRGB(212, 212, 224),
			ElementBorder = Color3.fromRGB(208, 208, 218),
			ToggleOn = Color3.fromRGB(0, 165, 75),
			ToggleOff = Color3.fromRGB(178, 178, 190),
			ToggleKnob = Color3.fromRGB(242, 242, 248),
			Border = Color3.fromRGB(208, 208, 220),
			ScrollBar = Color3.fromRGB(178, 178, 192),
			Font = Enum.Font.SourceSans,
			FontBold = Enum.Font.SourceSansBold,
			FontSize = 15,
			FontSizeTitle = 18,
			FontSizeSmall = 13,
			Padding = 10,
			CornerRadius = 8,
			TopbarHeight = 44,
			ElementHeight = 34,
			DescHeight = 52,
			Spacing = 6,
		},
	}

	function Theme:Override(base, overrides)
		base = type(base) == "string" and self[base] or base
		if not base then base = self.Dark end
		local m = {}
		for k, v in pairs(base) do m[k] = v end
		for k, v in pairs(overrides or {}) do m[k] = v end
		return m
	end

	local U = {}

	function U.Create(c, props, children)
		local inst = Instance.new(c)
		if props then for k, v in pairs(props) do inst[k] = v end end
		if children then for _, ch in ipairs(children) do ch.Parent = inst end end
		return inst
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
			Size = UDim2.new(1, -58, 0, 20),
			Position = UDim2.fromOffset(0, self.HasDesc and 2 or (h - 20) / 2 + 1),
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
			U.Create("TextLabel", {
				Name = "Description",
				Size = UDim2.new(1, -58, 0, 16),
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
			Position = UDim2.new(1, -52, 0.5, -12),
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
		spawn(function() self.Callback(value) end)
	end

	function Toggle:GetValue() return self.Value end

	function Toggle:SetEnabled(enabled)
		self.Enabled = enabled
		local t = enabled and 0 or 0.5
		self.Track.BackgroundTransparency = t
		self.Knob.BackgroundTransparency = t
	end

	function Toggle:SetText(text)
		self.Text = text
		self.Label.Text = text
	end

	function Toggle:SetDescription(desc)
		self.Description = desc
		if self.Container:FindFirstChild("Description") then
			self.Container.Description.Text = desc or ""
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

		self.Frame = U.Create("Frame", {
			Name = "Main",
			Size = UDim2.fromOffset(size.X, size.Y),
			Position = pos,
			BackgroundColor3 = theme.Background,
			BorderSizePixel = 0,
			Parent = self.Gui,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, theme.CornerRadius), Parent = self.Frame })

		local shadow = U.Create("ImageLabel", {
			Name = "Shadow",
			Size = UDim2.fromOffset(size.X + 12, size.Y + 12),
			Position = UDim2.fromOffset(-6, -6),
			BackgroundTransparency = 1,
			Image = "rbxassetid://6015897843",
			ImageTransparency = 0.6,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(10, 10, 118, 118),
			ZIndex = -1,
		})
		spawn(function()
			task.wait()
			shadow.Parent = self.Gui
		end)

		self.Topbar = U.Create("Frame", {
			Name = "Topbar",
			Size = UDim2.new(1, 0, 0, theme.TopbarHeight),
			BackgroundColor3 = theme.Topbar,
			BorderSizePixel = 0,
			Parent = self.Frame,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, theme.CornerRadius), Parent = self.Topbar })

		U.Create("Frame", {
			Name = "Fill",
			Size = UDim2.new(1, 0, 0, theme.CornerRadius),
			Position = UDim2.new(0, 0, 1, -theme.CornerRadius),
			BackgroundColor3 = theme.Topbar,
			BorderSizePixel = 0,
			Parent = self.Topbar,
		})
		U.Create("Frame", {
			Name = "AccentLine",
			Size = UDim2.new(1, -20, 0, 2),
			Position = UDim2.new(0, 10, 1, 0),
			BackgroundColor3 = theme.AccentLine,
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
			BackgroundColor3 = Color3.fromRGB(50, 50, 60),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Parent = self.Topbar,
		})
		self.CloseBtn.MouseEnter:Connect(function() self.CloseBtn.BackgroundTransparency = 0 end)
		self.CloseBtn.MouseLeave:Connect(function() self.CloseBtn.BackgroundTransparency = 1 end)
		U.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self.CloseBtn })
		U.Create("TextLabel", {
			Name = "Icon",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
			Text = "\215",
			Font = theme.FontBold,
			TextSize = 18,
			TextColor3 = Color3.fromRGB(170, 170, 185),
			Parent = self.CloseBtn,
		})

		self.Container = U.Create("ScrollingFrame", {
			Name = "Container",
			Size = UDim2.new(1, -theme.Padding * 2, 1, -(theme.TopbarHeight + theme.Padding + 4)),
			Position = UDim2.fromOffset(theme.Padding, theme.TopbarHeight + theme.Padding + 4),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = theme.ScrollBar,
			ScrollBarImageTransparency = 0.4,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Parent = self.Frame,
		})

		U.Create("UIListLayout", {
			Padding = UDim.new(0, theme.Spacing),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = self.Container,
		})

		self:_dragging()
		self.CloseBtn.MouseButton1Click:Connect(function() self:SetVisible(false) end)

		self.Gui.Parent = options.Parent or game:GetService("CoreGui")
		return self
	end

	function Menu:_dragging()
		local topbar = self.Topbar
		local frame = self.Frame
		local dragging, dragStart, startPos

		topbar.InputBegan:Connect(function(input)
			local t = input.UserInputType
			if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = frame.Position
			end
		end)
		topbar.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
				local delta = input.Position - dragStart
				frame.Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y
				)
				if shadow then
					shadow.Position = UDim2.new(
						startPos.X.Scale, startPos.X.Offset + delta.X - 6,
						startPos.Y.Scale, startPos.Y.Offset + delta.Y - 6
					)
				end
			end
		end)
		topbar.InputEnded:Connect(function(input)
			local t = input.UserInputType
			if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
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
			Size = UDim2.new(1, 0, 0, h + 2),
			BackgroundTransparency = 1,
			Parent = self.Container,
		})

		btn.Button = U.Create("ImageButton", {
			Name = "Button",
			Size = UDim2.new(1, 0, 0, h),
			BackgroundColor3 = theme.Element,
			AutoButtonColor = false,
			Parent = btn.Container,
		})
		U.Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn.Button })

		if hasDesc then
			U.Create("TextLabel", {
				Name = "Text",
				Size = UDim2.new(1, -16, 0, 20),
				Position = UDim2.fromOffset(10, 5),
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
				Position = UDim2.fromOffset(10, 27),
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

		btn.Button.MouseEnter:Connect(function()
			btn.Button.BackgroundColor3 = theme.ElementHover
		end)
		btn.Button.MouseLeave:Connect(function()
			btn.Button.BackgroundColor3 = theme.Element
		end)
		btn.Button.MouseButton1Click:Connect(function()
			if options.Callback then options.Callback() end
		end)

		btn.SetText = function(text)
			local t = btn.Button:FindFirstChild("Text")
			if t then t.Text = text end
		end
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
			Position = UDim2.fromOffset(0, hasDesc and 2 or (h - 20) / 2 + 1),
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
			U.Create("TextLabel", {
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
		lbl.SetColor = function(c) lbl.TextLabel.TextColor3 = c end
		lbl.Destroy = function() if lbl.Container then lbl.Container:Destroy() end end

		table.insert(self.Components, lbl)
		return lbl
	end

	function Menu:Divider()
		local div = {}
		div.Container = U.Create("Frame", {
			Name = "Divider",
			Size = UDim2.new(1, 0, 0, 14),
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

	function Menu:SetVisible(v)
		self.Visible = v
		if self.Gui then self.Gui.Enabled = v end
	end

	function Menu:ToggleVisibility() self:SetVisible(not self.Visible) end
	function Menu:GetVisible() return self.Visible end
	function Menu:SetTitle(t) self.Title.Text = t end

	function Menu:Destroy()
		for _, c in ipairs(self.Components) do
			if c.Destroy then c:Destroy() end
		end
		self.Components = {}
		if self.Gui then self.Gui:Destroy() end
	end

	local FyyUI = { Version = "0.1.0", Theme = Theme }

	function FyyUI.Menu(options)
		options = options or {}
		local name = options.Theme or "Dark"
		local theme = type(name) == "string" and Theme[name] or name
		if not theme then theme = Theme.Dark end
		if options.ColorOverride then theme = Theme:Override(theme, options.ColorOverride) end
		return Menu.new(options, theme)
	end

	return FyyUI
end)()
