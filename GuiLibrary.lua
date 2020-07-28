local Library = { Windows = 0, Binding = false, Keybinds = {} }

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Heartbeat = game:GetService("RunService").Heartbeat
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local BannedKeys = {
	Unknown = true,
	Escape = true
}

local AllowedInputTypes = {
	MouseButton1 = true,
	MouseButton2 = true
}

local function Create(obj, props)
	local Obj = Instance.new(obj)
	for i, v in pairs(props) do
		if i ~= "Parent" then
			if typeof(v) == "Instance" then
				v.Parent = Obj
			else
				Obj[i] = v
			end
		end			
	end
	Obj.Parent = props.Parent
	return Obj
end

local function Dragger(obj, drag)
    local Connection
    drag.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            if Connection then
                Connection:Disconnect()
            end
            local Start = Vector2.new(Mouse.X - obj.AbsolutePosition.X, Mouse.Y - obj.AbsolutePosition.Y)
            Connection = Heartbeat:Connect(function()
                obj:TweenPosition(UDim2.new(0, Mouse.X - Start.X, 0, Mouse.Y - Start.Y), "InOut", "Linear", 0.1, true)
            end)
        end
    end)
    drag.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 and Connection then
            Connection:Disconnect()
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, isrobloxprocess)
	if not Library.Binding and not isrobloxprocess then
		for i, v in next, Library.Keybinds do
			if v.Key == input.UserInputType.Name or v.Key == input.KeyCode.Name then
				v.Callback(v.Key)
			end
		end
	end
end)

Library.Gui = Create("ScreenGui", {
	Name = "Hub",
	Parent = game:GetService("CoreGui")
})

function Library:Window(name)
	local Window = { Number = Library.Windows, Open = true, CanMinimise = true }
	Library.Windows = Library.Windows + 1
	
	function Window:Resize(tween)
		local Size = 0
		for i, v in next, Window.Frame:GetChildren() do
			if not v:IsA("UIListLayout") then
				Size = Size + v.AbsoluteSize.Y
			end
		end
		if tween then
			Window.Frame:TweenSize(UDim2.new(0, 170, 0, Size + 5), "InOut", "Sine", 0.4)
		else
			Window.Frame.Size = UDim2.new(0, 170, 0, Size + 5)
		end
	end
	
	Window.Frame = Create('Frame', {
        BackgroundColor3 = Color3.new(0.137255, 0.137255, 0.137255),
		BorderColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314),
		ClipsDescendants = true,
		Name = 'Frame',
		Parent = Library.Gui,
        Position = UDim2.new(0, 20 + (185 * Window.Number), 0, 20),
        Size = UDim2.new(0, 175, 0, 30),
        Create('UIListLayout', {
            SortOrder = Enum.SortOrder.LayoutOrder
        }),
        Create('Frame', {
            BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392),
            BorderSizePixel = 0,
            Name = 'Top',
            Size = UDim2.new(1, 0, 0, 30),
            Create('TextLabel', {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                Font = Enum.Font.SourceSansSemibold,
                Name = 'Title',
                Position = UDim2.new(0, 5, 0, 0),
                Size = UDim2.new(1, -5, 1, 0),
                Text = name,
                TextColor3 = Color3.new(0.862745, 0.862745, 0.862745),
                TextSize = 20,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            Create('TextButton', {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                Font = Enum.Font.SourceSansSemibold,
                Name = 'Minimise',
                Position = UDim2.new(1, -30, 0, 0),
                Rotation = 45,
                Size = UDim2.new(0, 30, 0, 30),
                Text = '+',
                TextColor3 = Color3.new(0.862745, 0.862745, 0.862745),
                TextSize = 30
            })
		})
	})
	
	Dragger(Window.Frame, Window.Frame.Top)
	
	Window.Minimise = Window.Frame.Top.Minimise
	Window.Minimise.MouseButton1Click:Connect(function()
		if Window.CanMinimise then
			Window.Open = not Window.Open
			Window.CanMinimise = false
			local Tween = TweenService:Create(Window.Minimise, TweenInfo.new(0.4), {Rotation = Window.Minimise.Rotation + 45})
			Tween.Completed:Connect(function()
				Window.CanMinimise = true
			end)
			Tween:Play()
			if Window.Open then
				Window:Resize(true)
			else
				Window.Frame:TweenSize(UDim2.new(0, 170, 0, 30), "InOut", "Sine", 0.4, true)
			end
		end
	end)
	
	function Window:Button(text, func)
		local Button = { Callback = func or function() 
			print(text .. " - Function Not Assigned") 
		end }
		Button.Frame = Create('Frame', {
            BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647),
            BackgroundTransparency = 1,
			Name = 'Button',
			Parent = Window.Frame,
            Size = UDim2.new(1, 0, 0, 33),
            Create('TextButton', {
                BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392),
                BorderSizePixel = 0,
                Font = Enum.Font.SourceSansSemibold,
                Name = 'Button',
                Position = UDim2.new(0, 3, 0, 5),
				Size = UDim2.new(1, -6, 0, 28),
				Text = text,
                TextColor3 = Color3.new(0.862745, 0.862745, 0.862745),
                TextSize = 18
            })
		})
		
		Button.Click = Button.Frame.Button
		Button.Click.MouseButton1Click:Connect(Button.Callback)
		Window:Resize(false)
		return Button
	end
	
	function Window:Toggle(text, default, func)
		assert(typeof(default) == "boolean", text .. " - Default Is Not A Boolean")
		local Toggle = { Enabled = false, Callback = func or function() 
			print(text .. " - Function Not Assigned") 
		end }
		Toggle.Frame = Create('Frame', {
            BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647),
            BackgroundTransparency = 1,
			Name = 'Toggle',
			Parent = Window.Frame,
            Size = UDim2.new(1, 0, 0, 31),
            Create('TextButton', {
                BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392),
                BorderSizePixel = 0,
                Font = Enum.Font.SourceSansSemibold,
                Name = 'Button',
                Position = UDim2.new(1, -28, 0, 6),
                Size = UDim2.new(0, 24, 0, 24),
                Text = '',
                TextColor3 = Color3.new(0.862745, 0.862745, 0.862745),
                TextSize = 20
            }),
            Create('TextLabel', {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                Font = Enum.Font.SourceSansSemibold,
                Name = 'Label',
                Position = UDim2.new(0, 5, 0, 0),
                Size = UDim2.new(1, -5, 1, 0),
                Text = text,
                TextColor3 = Color3.new(0.862745, 0.862745, 0.862745),
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Left
            })
		})
		
		function Toggle:Switch()
			Toggle.Enabled = not Toggle.Enabled
			Toggle.Click.BackgroundColor3 = Toggle.Enabled and Color3.new(0.392157, 0.12549, 0.666667) or Color3.fromRGB(25, 25, 25)
			Toggle.Callback(Toggle.Enabled)	
		end
		
		Toggle.Click = Toggle.Frame.Button
		Toggle.Click.MouseButton1Click:Connect(Toggle.Switch)
		if default then
			Toggle:Switch()
		end
		Window:Resize(false)
		return Toggle
	end
	
	function Window:Box(text, default, contenttype, func)
		assert(typeof(contenttype) == "string", text .. " - ContentType Is Not A String")
		assert(contenttype == "player" or contenttype == "number" or contenttype == "any", text .. " - Incorrect Content Type")
		local Box = { Content = default, Callback = func or function() 
			print(text .. " - Function Not Assigned") 
		end }
		Box.Frame = Create('Frame', {
            BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647),
            BackgroundTransparency = 1,
			Name = 'Box',
			Parent = Window.Frame,
            Size = UDim2.new(1, 0, 0, 33),
            Create('TextBox', {
                BackgroundColor3 = Color3.new(0.137255, 0.137255, 0.137255),
                BorderColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392),
				BorderMode = Enum.BorderMode.Inset,                
				Font = Enum.Font.SourceSansSemibold,
                Name = 'Box',
				PlaceholderText = text,                
				Position = UDim2.new(0, 3, 0, 5),
                Size = UDim2.new(1, -6, 0, 28),
                Text = default,
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 18
            })
		})
		
		local function CheckType(val)
			assert(typeof(val) == "string", text .. " - CheckType Input Is Not A String")
			if contenttype == "player" then
				for i, v in next, Players:GetPlayers() do
					if v.Name:lower():find(val:lower()) then
						Box.Holder.Text = v.Name
						return v.Name
					end
				end
			elseif contenttype == "number" and tonumber(val) then
				return true
			elseif contenttype == "any" then
				return true
			end
			return false
		end
		
		function Box:Set(val, call)
			local res = CheckType(val)
			if typeof(res) == "string" or res == true then
				val = typeof(res) == "string" and res or val
				Box.Content = val
				Box.Holder.Text = val
				if call then
					Box.Callback(val)
				end
			else
				Box.Holder.Text = Box.Content
			end
		end
		
		Box.Holder = Box.Frame.Box
		Box.Holder.FocusLost:Connect(function()
			Box:Set(Box.Holder.Text, true)
		end)
		if default ~= "" then
			Box:Set(default, true)
		end
		Window:Resize(false)
		return Box
	end
	
	function Window:Keybind(text, default, func)
		assert(typeof(default) == "string", text .. " - Default Is Not A String")
		local Keybind = { Key = default, Callback = func or function()
			print(text .. " - Function Not Assigned")	
		end }
		Keybind.Frame = Create('Frame', {
            BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647),
            BackgroundTransparency = 1,
			Name = 'Keybind',
			Parent = Window.Frame,
            Size = UDim2.new(1, 0, 0, 33),
            Create('TextLabel', {
                BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
                Font = Enum.Font.SourceSansSemibold,
                Name = 'Label',
                Position = UDim2.new(0, 5, 0, 0),
                Size = UDim2.new(1, -5, 1, 0),
                Text = text,
                TextColor3 = Color3.new(0.862745, 0.862745, 0.862745),
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            Create('TextButton', {
                BackgroundColor3 = Color3.new(0.137255, 0.137255, 0.137255),
                BorderColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392),
				BorderMode = Enum.BorderMode.Inset,                
				Font = Enum.Font.SourceSansSemibold,
                Name = 'Box',
                Position = UDim2.new(1, -63, 0, 5),
                Size = UDim2.new(0, 60, 0, 28),
                Text = default,
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 18
            })
		})
		
		Keybind.Holder = Keybind.Frame.Box
		Keybind.Holder.MouseButton1Click:Connect(function()
			if not Library.Binding then
				Library.Binding = true
				Keybind.Holder.Text = "..."
				local Key = UserInputService.InputBegan:Wait()
				if AllowedInputTypes[Key.UserInputType.Name] then
					Keybind.Key = Key.UserInputType.Name
				elseif Key.UserInputType == Enum.UserInputType.Keyboard and not BannedKeys[Key.KeyCode.Name] then
					Keybind.Key = Key.KeyCode.Name
				end
				Keybind.Holder.Text = Keybind.Key
				wait(0.1)
				Library.Binding = false
			end
		end)
		
		Library.Keybinds[#Library.Keybinds + 1] = Keybind
		 
		Window:Resize(false)
		return Keybind
	end
	
	function Window:Slider(text, min, max, default, func)
		assert(typeof(min) == "number", text .. " - Min Is Not A Number")
		assert(typeof(max) == "number", text .. " - Max Is Not A Number")
		assert(typeof(default) == "number", text .. " - Default Is Not A Number")
		assert(default >= min and default <= max, text .. " - Default Is Not Within Min And Max")
		local Slider = { Value = default, DragLoop = nil, Callback = func or function()
			print(text .. " - Function Not Assigned")	
		end }
		Slider.Frame = Create('Frame', {
            BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647),
            BackgroundTransparency = 1,
			Name = 'Slider',
			Parent = Window.Frame,
            Size = UDim2.new(1, 0, 0, 43),
            Create('TextLabel', {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                Font = Enum.Font.SourceSansSemibold,
                Name = 'Label',
                Position = UDim2.new(0, 5, 0, 5),
                Size = UDim2.new(1, -5, 1, -3),
                Text = text .. " [ " .. default .. " ]",
                TextColor3 = Color3.new(0.862745, 0.862745, 0.862745),
                TextSize = 18,
                TextYAlignment = Enum.TextYAlignment.Top
            }),
            Create('ImageLabel', {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                Image = 'rbxassetid://3570695787',
                ImageColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392),
                Name = 'Bar',
                Position = UDim2.new(0, 10, 0, 35),
                ScaleType = Enum.ScaleType.Slice,
                Size = UDim2.new(1, -20, 0, 4),
                SliceCenter = Rect.new(Vector2.new(100, 100), Vector2.new(100, 100)),
                SliceScale = 0.12,
                Create('ImageLabel', {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    Image = 'rbxassetid://3570695787',
                    Name = 'Drag',
                    Position = UDim2.new(0, 0, 0.5, 0),
                    ScaleType = Enum.ScaleType.Slice,
                    Size = UDim2.new(0, 14, 0, 14),
                    SliceCenter = Rect.new(Vector2.new(100, 100), Vector2.new(100, 100)),
                    SliceScale = 0.12
                })
            })
		})
		
		Slider.Label = Slider.Frame.Label
		Slider.Bar = Slider.Frame.Bar
		Slider.Drag = Slider.Bar.Drag
		
		function Slider:Set(val)
			Slider.Value = val
			Slider.Label.Text = text .. " [ " .. val .. " ]"
			local Percent = (val - min) / (max - min)
			Slider.Drag.Position = UDim2.new(Percent, 0, 0.5, 0)
			Slider.Callback(val)
		end
		
		Slider.Drag.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if Slider.DragLoop then
					Slider.DragLoop:Disconnect()
				end
				Slider.DragLoop = Heartbeat:Connect(function()
					local Percent = math.clamp((Mouse.X - Slider.Bar.AbsolutePosition.X) / Slider.Bar.AbsoluteSize.X, 0, 1)
					Slider:Set(math.floor((min + ((max - min) * Percent)) * 10) / 10)
				end)
			end
		end)
		
		Slider.Drag.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 and Slider.DragLoop then
				Slider.DragLoop:Disconnect()
			end
		end)
		
		if default ~= min then
			Slider:Set(math.floor(default * 10) / 10)
		end
		
		Window:Resize(false)
		return Slider
	end
	
	function Window:ColourSlider(text, default, func)
		assert(typeof(default) == "number", text .. " - Default Is Not A Number")
		assert(default >= 0 and default <= 1, text .. " - Default Is Not Within 0 and 359")
		local ColourSlider = { DragLoop = nil, Callback = func or function()
			print(text .. " - Function Not Assigned")	
		end }
		ColourSlider.Frame = Create('Frame', {
            BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647),
            BackgroundTransparency = 1,
            Name = 'Colour',
			Parent = Window.Frame,            
			Size = UDim2.new(1, 0, 0, 43),
            Create('TextLabel', {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                Font = Enum.Font.SourceSansSemibold,
                Name = 'Label',
                Position = UDim2.new(0, 5, 0, 5),
                Size = UDim2.new(1, -5, 1, -3),
                Text = text,
                TextColor3 = Color3.new(0.862745, 0.862745, 0.862745),
                TextSize = 18,
                TextYAlignment = Enum.TextYAlignment.Top
            }),
            Create('ImageLabel', {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                Image = 'rbxassetid://3570695787',
                Name = 'HueBar',
                Position = UDim2.new(0, 10, 0, 35),
                ScaleType = Enum.ScaleType.Slice,
                Size = UDim2.new(1, -20, 0, 4),
                SliceCenter = Rect.new(Vector2.new(100, 100), Vector2.new(100, 100)),
                SliceScale = 0.12,
                Create('ImageLabel', {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    Image = 'rbxassetid://3570695787',
                    Name = 'Drag',
                    Position = UDim2.new(0, 0, 0.5, 0),
                    ScaleType = Enum.ScaleType.Slice,
                    Size = UDim2.new(0, 14, 0, 14),
                    SliceCenter = Rect.new(Vector2.new(100, 100), Vector2.new(100, 100)),
                    SliceScale = 0.12
                }),
                Create('UIGradient', {
                    Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)), ColorSequenceKeypoint.new(0.143, Color3.new(1, 0.333333, 0)), ColorSequenceKeypoint.new(0.286, Color3.new(1, 1, 0)), ColorSequenceKeypoint.new(0.429, Color3.new(0, 1, 0)), ColorSequenceKeypoint.new(0.571, Color3.new(0, 1, 1)), ColorSequenceKeypoint.new(0.714, Color3.new(0, 0, 1)), ColorSequenceKeypoint.new(0.857, Color3.new(1, 0, 1)), ColorSequenceKeypoint.new(1, Color3.new(0.666667, 0, 0)) })
                })
            })
		})
		
		ColourSlider.Bar = ColourSlider.Frame.HueBar
		ColourSlider.Drag = ColourSlider.Bar.Drag
		
		function ColourSlider:Set(percent)
			ColourSlider.Drag.Position = UDim2.new(percent, 0, 0.5, 0)
			local Colour = Color3.fromHSV(percent, 1, 1)
			ColourSlider.Callback(percent)
		end
		
		ColourSlider.Drag.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if ColourSlider.DragLoop then
					ColourSlider.DragLoop:Disconnect()
				end
				ColourSlider.DragLoop = Heartbeat:Connect(function()
					local Percent = math.clamp((Mouse.X - ColourSlider.Bar.AbsolutePosition.X) / ColourSlider.Bar.AbsoluteSize.X, 0, 1)
					ColourSlider:Set(Percent)
				end)
			end
		end)
		
		ColourSlider.Drag.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 and ColourSlider.DragLoop then
				ColourSlider.DragLoop:Disconnect()
			end
		end)
		
		ColourSlider:Set(default)
		Window:Resize(false)
		return ColourSlider
	end
	
	return Window
end

return Library