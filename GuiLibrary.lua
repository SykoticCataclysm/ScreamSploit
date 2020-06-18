local Library = { Windows = 0 }

local Heartbeat = game:GetService("RunService").Heartbeat
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

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

Library.Gui = Create("ScreenGui", {
	Name = "ScreamSploit",
	Parent = game:GetService("CoreGui")
})

function Library:Window(name)
	local Window = { Number = Library.Windows, Open = true }
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
	
	Window.Frame = Create("ImageLabel", {
        BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
        Image = "rbxassetid://3570695787",
        ImageColor3 = Color3.new(0.137255, 0.137255, 0.137255),
		Name = name,
		Parent = Library.Gui,
        Position = UDim2.new(0, 20 + 180 * Window.Number, 0, 25),
        ScaleType = Enum.ScaleType.Slice,
        Size = UDim2.new(0, 170, 0, 0),
        SliceCenter = Rect.new(Vector2.new(100, 100), Vector2.new(100, 100)),
		SliceScale = 0.1,
		Create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Create("ImageLabel", {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            Image = "rbxassetid://5196024144",
            ImageColor3 = Color3.new(0.117647, 0.117647, 0.117647),
            Name = "Top",
            ScaleType = Enum.ScaleType.Slice,
            Size = UDim2.new(0, 170, 0, 30),
            SliceCenter = Rect.new(Vector2.new(100, 100), Vector2.new(100, 100)),
            SliceScale = 0.07,
            Create("TextLabel", {
                BackgroundColor3 = Color3.new(0.392157, 0.12549, 0.666667),
                BorderSizePixel = 0,
                Font = Enum.Font.SourceSans,
                Name = "Underline",
                Position = UDim2.new(0, 0, 1, -2),
                Size = UDim2.new(0, 170, 0, 2),
                Text = "",
                TextColor3 = Color3.new(0, 0, 0),
                TextSize = 14
            }),
            Create("TextLabel", {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Font = Enum.Font.Fantasy,
                Name = "Title",
                Size = UDim2.new(0, 160, 0, 30),
                Text = name,
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 18
            }),
            Create("TextButton", {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                Font = Enum.Font.SourceSans,
                Name = "Minimise",
                Position = UDim2.new(0, 140, 0, 0),
                Size = UDim2.new(0, 30, 0, 28),
                Text = "-",
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 30
            })
        })
	})
	
	Window.Minimise = Window.Frame.Top.Minimise
	Window.Minimise.MouseButton1Click:Connect(function()
		Window.Open = not Window.Open
		Window.Minimise.Text = Window.Open and "-" or "+"
		if Window.Open then
			Window:Resize(true)
		else
			Window.Frame:TweenSize(UDim2.new(0, 170, 0, 30), "InOut", "Sine", 0.4, true)
		end
    end)
    Dragger(Window.Frame, Window.Frame.Top)
	
	function Window:Section(text)
		local Section = {}
		Section.Frame = Create("Frame", {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
			Name = "SectionFrame",
			Parent = Window.Frame,
            Size = UDim2.new(0, 170, 0, 30),
            Create("TextLabel", {
                BackgroundColor3 = Color3.new(0.392157, 0.12549, 0.666667),
                BorderSizePixel = 0,
                Font = Enum.Font.Fantasy,
                Name = "Label",
                Position = UDim2.new(0, 0, 0, 5),
                Size = UDim2.new(0, 170, 0, 25),
                Text = text,
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 16
            })
		})

		Window:Resize()
	end
	
	function Window:Button(text, func)
		local Button = {}
		Button.Frame = Create("Frame", {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
			Name = "ButtonFrame",
			Parent = Window.Frame,
            Size = UDim2.new(0, 170, 0, 30),
            Create("TextButton", {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Font = Enum.Font.Fantasy,
                Name = "Button",
                Position = UDim2.new(0, 5, 0, 5),
                Size = UDim2.new(0, 160, 0, 25),
                Text = text,
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 16,
                ZIndex = 2,
                Create("ImageLabel", {
                    Active = true,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://3570695787",
                    ImageColor3 = Color3.new(0.392157, 0.12549, 0.666667),
                    Name = "Background",
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    ScaleType = Enum.ScaleType.Slice,
                    Selectable = true,
                    Size = UDim2.new(1, 0, 1, 0),
                    SliceCenter = Rect.new(Vector2.new(100, 100), Vector2.new(100, 100)),
                    SliceScale = 0.07
                })
            })
		})
		
		Button.Click = Button.Frame.Button
		Button.Click.MouseButton1Click:Connect(func)

		Window:Resize()
	end
	
	function Window:Toggle(name, func)
		local Toggle = { Enabled = false }
		Toggle.Frame = Create("Frame", {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
			Name = "ToggleFrame",
			Parent = Window.Frame,
            Size = UDim2.new(0, 170, 0, 30),
            Create("TextLabel", {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                Font = Enum.Font.Fantasy,
                Name = "Label",
                Position = UDim2.new(0, 5, 0, 5),
                Size = UDim2.new(0, 130, 0, 25),
                Text = name,
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            Create("ImageButton", {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Image = "rbxassetid://3570695787",
                ImageColor3 = Color3.new(0.196078, 0.196078, 0.196078),
                Name = "Button",
                Position = UDim2.new(0, 140, 0, 5),
                ScaleType = Enum.ScaleType.Slice,
                Size = UDim2.new(0, 25, 0, 25),
                SliceCenter = Rect.new(Vector2.new(100, 100), Vector2.new(100, 100)),
                SliceScale = 0.07
            })
		})
		
		Toggle.Click = Toggle.Frame.Button
		Toggle.Click.MouseButton1Click:Connect(function()
			Toggle.Enabled = not Toggle.Enabled
			Toggle.Click.ImageColor3 = Toggle.Enabled and Color3.new(0.392157, 0.12549, 0.666667) or Color3.new(0.196078, 0.196078, 0.196078)
			func(Toggle.Enabled)
		end)
		
		Window:Resize()
	end
	
	function Window:Box(name, func)
		local Box = {}
		Box.Frame = Create("Frame", {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
			Name = "BoxFrame",
			Parent = Window.Frame,
            Size = UDim2.new(0, 170, 0, 30),
            Create("ImageLabel", {
                Active = true,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                Image = "rbxassetid://3570695787",
                ImageColor3 = Color3.new(0.196078, 0.196078, 0.196078),
                Name = "Background",
                Position = UDim2.new(0, 5, 0, 5),
                ScaleType = Enum.ScaleType.Slice,
                Selectable = true,
                Size = UDim2.new(0, 160, 0, 25),
                SliceCenter = Rect.new(Vector2.new(100, 100), Vector2.new(100, 100)),
                SliceScale = 0.070000000298023
            }),
            Create("TextBox", {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                Font = Enum.Font.Fantasy,
				Name = "Box",
				PlaceholderText = name,
                Position = UDim2.new(0, 5, 0, 5),
                Size = UDim2.new(0, 160, 0, 25),
                Text = "",
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 16
            })
		})
		
		Box.Holder = Box.Frame.Box
		Box.Holder.FocusLost:Connect(function()
			if Box.Holder.Text ~= "" then
				func(Box.Holder.Text)
			end
		end)
		
		Window:Resize()
	end
	
	function Window:Slider(name, min, max, func)
		local Slider = { Value = min, Drag = nil }
		Slider.Frame = Create("Frame", {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
			Name = "SliderFrame",
			Parent = Window.Frame,
            Size = UDim2.new(0, 170, 0, 50),
            Create("TextLabel", {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                Font = Enum.Font.Fantasy,
                Name = "Label",
                Position = UDim2.new(0, 5, 0, 5),
                Size = UDim2.new(0, 160, 0, 25),
                Text = name,
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            Create("TextLabel", {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                Font = Enum.Font.Fantasy,
                Name = "Current",
                Position = UDim2.new(0, 5, 0, 5),
                Size = UDim2.new(0, 160, 0, 25),
                Text = min,
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Right
            }),
            Create("ImageLabel", {
                Active = true,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                Image = "rbxassetid://3570695787",
                ImageColor3 = Color3.new(0.196078, 0.196078, 0.196078),
                Name = "Background",
                Position = UDim2.new(0, 5, 0, 32),
                ScaleType = Enum.ScaleType.Slice,
                Selectable = true,
                Size = UDim2.new(0, 160, 0, 18),
                SliceCenter = Rect.new(Vector2.new(100, 100), Vector2.new(100, 100)),
                SliceScale = 0.07,
                Create("ImageLabel", {
                    Active = true,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://3570695787",
                    ImageColor3 = Color3.new(0.392157, 0.12549, 0.666667),
                    Name = "Fill",
                    ScaleType = Enum.ScaleType.Slice,
                    Selectable = true,
                    Size = UDim2.new(0, 0, 1, 0),
                    SliceCenter = Rect.new(Vector2.new(100, 100), Vector2.new(100, 100)),
                    SliceScale = 0.07
                })
            })
		})
		
		Slider.Current = Slider.Frame.Current
		Slider.Background = Slider.Frame.Background
		Slider.Fill = Slider.Background.Fill
		Slider.Background.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				if Slider.Drag then
					Slider.Drag:Disconnect()
				end
				Slider.Drag = Heartbeat:Connect(function()
					local Percent = math.clamp((Mouse.X - Slider.Background.AbsolutePosition.X) / Slider.Background.AbsoluteSize.X, 0, 1)
					Slider.Value = settings.min + ((settings.max - settings.min) * Percent)
					Slider.Current.Text = Slider.Value
					func(Slider.Value)
					Slider.Fill:TweenSize(UDim2.new(Percent, 0, 1, 0), "InOut", "Linear", 0.1, true)
				end)
			end
		end)
		Slider.Background.InputEnded:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and Slider.Drag then
				Slider.Drag:Disconnect()
			end
		end)
		
		Window:Resize()
	end
	
	Window:Resize()
	return Window
end

return Library