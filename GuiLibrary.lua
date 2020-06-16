local Library = { WindowCount = 0, Toggled = true }

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Dragger = {}
function Dragger.New(frame, dragitem)
    frame.Active = true
    dragitem.Active = true
    dragitem.MouseEnter:connect(function()
        IsInFrame = true
    end)
    dragitem.MouseLeave:connect(function()
        IsInFrame = false
    end)
    local input = dragitem.InputBegan:connect(function(key)
        if key.UserInputType == Enum.UserInputType.MouseButton1 and IsInFrame then
            local objectPosition = Vector2.new(mouse.X - frame.AbsolutePosition.X, mouse.Y - frame.AbsolutePosition.Y)
            while RunService.Heartbeat:wait() and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                pcall(function()
                    frame:TweenPosition(UDim2.new(0, mouse.X - objectPosition.X + (frame.Size.X.Offset * frame.AnchorPoint.X), 0, mouse.Y - objectPosition.Y + (frame.Size.Y.Offset * frame.AnchorPoint.Y)), 'Out', 'Linear', 0.04, true)
                end)
            end
        end
    end)
end

function Library:Create(type, props)
    local Obj = Instance.new(type, props.Parent)
    for i, v in next, props do
        Obj[i] = v
    end
    return Obj
end

function Library:PlayTween(obj, props, speed, easing)
    easing = easing or {}
    local Tween = TweenService:Create(obj, TweenInfo.new(speed, unpack(easing)), props)
    Tween:Play()
    return Tween
end;

Library.Gui = Library:Create("ScreenGui", {
    Name = "ScreamSploit",
    Parent = game:GetService("CoreGui"),
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

UserInputService.InputBegan:Connect(function(input, isgameprocessed)
    if not isgameprocessed and input.KeyCode == Enum.KeyCode.RightShift then
        Library.Toggled = not Library.Toggled
        Library.Gui.Enabled = Library.Toggled
    end
end)

function Library:CreateWindow(name)
    local Main = Library:Create("ImageLabel", {
        Name = "Main",
        Parent = Library.Gui,
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 30 + (190 * Library.WindowCount), 0, 50),
        Size = UDim2.new(0, 180, 0, 333),
        Image = "rbxassetid://4550094458",
        ImageColor3 = Color3.new(0.137255, 0.137255, 0.137255),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(4, 4, 296, 296)
    })
    local Bar = Library:Create("ImageLabel", {
        Name = "Bar",
        Parent = Main,
        BackgroundColor3 = Color3.new(1, 0.27451, 0.286275),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, -2),
        Size = UDim2.new(0, 180,0, 32),
        Image = "rbxassetid://4550094255",
        ImageColor3 = Color3.new(1, 0.27451, 0.286275),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(4, 4, 296, 296)
    })
    local Title = Library:Create("TextLabel", {
        Name = "Title",
        Parent = Bar,
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.GothamSemibold,
        Text = name,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 16
    })
    local UIListLayout = Library:Create("UIListLayout", {
        Parent = Main,
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = "Center",
        Padding = UDim.new(0, 5)
    })
    Dragger.New(Main, Bar)

    local Window = {}
    Window.Count = Library.WindowCount
    Window.Container = Main
    Library.WindowCount = Library.WindowCount + 1

    function Window:Resize()
        local Count = 0 
		for i, v in pairs(Main:GetChildren()) do
			if not v:IsA('UIListLayout') then
				Count = Count + 1
			end
		end
		Main.Size = UDim2.new(0, 180, 0, (count * 45) - 10)
    end

    function Window:Section(text)
        local Section = {}
        Section.Container = Library:Create("ImageLabel", {
            Name = "Section",
            Parent = Main,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, -85, 0, 98),
            Size = UDim2.new(0, 170,0, 35),
            Image = "rbxassetid://4550094458",
            ImageColor3 = Color3.fromRGB(40, 40, 40),
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(4, 4, 296, 296)
        })
        Section.Text = Library:Create("TextLabel", {
            Name = "Text",
            Parent = Section.Container,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.Gotham,
            Text = text,
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 14
        })
        Window:Resize()
    end

    function Window:Button(name, callback)
        local Button = {}
        Button.Func = callback or function() end
        Button.Container = Library:Create("ImageLabel", {
            Name = "Buttonsection",
            Parent = Main,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, -85, 0, 98),
            Size = UDim2.new(0, 170,0, 35),
            Image = "rbxassetid://4550094458",
            ImageColor3 = Color3.fromRGB(40, 40, 40),
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(4, 4, 296, 296)
        })
        Button.Buttonback = Library:Create("ImageLabel", {
            Name = "Buttonback",
            Parent = Button.Container,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, -78, 0.5, -12),
            Size = UDim2.new(0.917647064, 0, 0.685714304, 0),
            Image = "rbxassetid://4641155515",
            ImageColor3 = Color3.new(1, 0.27451, 0.286275),
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(4, 4, 296, 296)
        })
        Button.Button = Library:Create("TextButton", {
            Name = "Button",
            Parent = Button.Buttonback,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.Gotham,
            TextColor3 = Color3.new(1, 1, 1),
            ClipsDescendants = true,
            TextSize = 12,
            Text = name
        })
        Button.Button.MouseButton1Click:Connect(Button.Func)
        Window:Resize()
    end

    function Window:Toggle(name, callback)
        local Toggle = { Enabled = false }
        Toggle.Func = callback or function() end
        Toggle.Boxsection = Library:Create("ImageLabel", {
            Name = "Boxsection",
            Parent = Main,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, -85, 0, 98),
            Size = UDim2.new(0, 170,0, 35),
            Image = "rbxassetid://4550094458",
            ImageColor3 = Color3.fromRGB(40, 40, 40),
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(4, 4, 296, 296)
        })
        Toggle.Boxtitle = Library:Create("TextLabel", {
            Name = "Boxtitle",
            Parent = Toggle.Boxsection,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.0576470755, 0, 0, 0),
            Size = UDim2.new(0.470588237, 0, 1, 0),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        Toggle.Box = Library:Create("ImageButton", {
            Name = "Box",
            Parent = Toggle.Boxsection,
            BackgroundColor3 = Color3.new(1, 0.27451, 0.286275),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.800000012, 0, 0.5, -12),
            Size = UDim2.new(0.141176477, 0, 0.685714304, 0),
            AutoButtonColor = false,
            Image = "rbxassetid://4552505888",
            ImageColor3 = Color3.new(1, 0.27451, 0.286275)
        })
        Toggle.Fill = Library:Create("ImageLabel", {
            Name = "Fill",
            Parent = Toggle.Box,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Image = "rbxassetid://4555402813",
            ImageColor3 = Color3.new(1, 0.27451, 0.286275),
            ImageTransparency = 1
        })
        Toggle.Check = Library:Create("ImageLabel", {
            Name = "Check",
            Parent = Toggle.Fill,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, -9, 0.5, -9),
            Size = UDim2.new(0.75, 0, 0.75, 0),
            Image = "rbxassetid://4555411759",
            ImageTransparency = 1
        })
        Toggle.Box.MouseButton1Click:Connect(function()
            Toggle.Enabled = not Toggle.Enabled
            Library:PlayTween(fill, {ImageTransparency = Toggle.Enabled and 0 or 1}, 0.1, {"Linear", "In"})
            Library:PlayTween(check, {ImageTransparency = Toggle.Enabled and 0 or 1}, 0.1, {"Linear", "In"})
            Toggle.Func(Toggle.Enabled)
        end)
        Window:Resize()
    end

    function Window:TextBox(name, default, callback)
        local TextBox = {}
        TextBox.Func = callback or function() end
        TextBox.Container = Library:Create("ImageLabel", {
            Name = "Textboxsection",
            Parent = Main,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, -85, 0, 98),
            Size = UDim2.new(0, 170,0, 35),
            Image = "rbxassetid://4550094458",
            ImageColor3 = Color3.fromRGB(40, 40, 40),
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(4, 4, 296, 296)
        })
        TextBox.Label = Library:Create("TextLabel", {
            Name = "Label",
            Parent = TextBox.Container,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.0576470755, 0, 0, 0),
            Size = UDim2.new(0.470588237, 0, 1, 0),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        TextBox.Holder = Library:Create("ImageLabel", {
            Name = "Holder",
            Parent = TextBox.Container,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.529411793, 0, 0.5, -12),
            Size = UDim2.new(0.441176474, 0, 0.685714304, 0),
            Image = "rbxassetid://4550094458",
            ImageColor3 = Color3.new(0.137255, 0.137255, 0.137255),
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(4, 4, 296, 296)
        })
        TextBox.Box = Library:Create("TextBox", {
            Name = "Box",
            Parent = TextBox.Holder,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.Gotham,
            PlaceholderText = "Text",
            Text = default,
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 10
        })
        TextBox.Box.FocusLost:Connect(function()
            TextBox.Func(TextBox.Box.Text)
        end)
        Window:Resize()
    end

    function Window:Slider(name, settings, callback)
        assert(settings.min and settings.max and settings.default, "min, max, and default value required")
        local Slider = { Value = settings.default }
        Slider.Func = callback or function() end
        Slider.Container = Library:Create("ImageLabel", {
            Name = "Slidersection",
            Parent = Main,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, -85, 0, 98),
            Size = UDim2.new(0, 170,0, 35),
            Image = "rbxassetid://4550094458",
            ImageColor3 = Color3.fromRGB(40, 40, 40),
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(4, 4, 296, 296)
        })
        Slider.Name = Library:Create("TextLabel", {
            Name = "Name",
            Parent = Slider.Container,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.311764717, -43, 0, 0),
            Size = UDim2.new(0.470588237, 0, 0.646666706, 0),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        Slider.Back = Library:Create("TextButton", {
            Name = "Back",
            Parent = Slider.Container,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.SourceSans,
            Text = "",
            TextColor3 = Color3.new(0, 0, 0),
            TextSize = 14
        })
        Slider.Line = Library:Create("ImageLabel", {
            Name = "Line",
            Parent = Slider.Back,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, -75, 0.680000007, -2),
            Size = UDim2.new(0.882352948, 0, 0.0500000007, 0),
            Image = "rbxassetid://4550094458",
            ImageTransparency = 0.5,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(4, 4, 296, 296)
        })
        Slider.Fill = Library:Create("ImageLabel", {
            Name = "Fill",
            Parent = Slider.Line,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 1, 0),
            Image = "rbxassetid://4550094458",
            ImageColor3 = Color3.new(1, 0.27451, 0.286275),
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(4, 4, 296, 296)
        })
        Slider.Frame = Library:Create("ImageLabel", {
            Name = "Frame",
            Parent = Slider.Line,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.5, -7),
            Size = UDim2.new(0.0199999996, 0, 4.66666651, 0),
            Image = "rbxassetid://4550094458",
            ImageColor3 = Color3.new(1, 0.27451, 0.286275),
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(4, 4, 296, 296)
        })
        Slider.Label = Library:Create("TextLabel", {
            Name = "Label",
            Parent = Slider.Container,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(1.02941179, -43, 0, 0),
            Size = UDim2.new(0.223529384, 0, 0.646666706, 0),
            Font = Enum.Font.Gotham,
            Text = tostring(settings.default),
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 14,
            TextTransparency = 0.5
        })
        local Held, Step, Percentage = false, 1, 0
        Slider.Back.MouseButton1Down:Connect(function()
            Held = true
        end)
        UserInputService.InputEnded:Connect(function(input, isgameprocessed)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Held = false
            end
        end)
        RunService.RenderStepped:Connect(function()
            if Held then
                local X = UserInputService:GetMouseLocation().X
                local Pos = Slider.Frame.Position
                Percentage = math.clamp((X  - Slider.Back.AbsoluteSize.X) / Slider.Back.AbsolutePosition.X, 0, 1)
                Slider.Fill.Size = UDim2.new(Percentage, 0, 0, 3)
                local Amount = math.floor(settings.min + ((settings.max - settings.min) * Percentage))
                Slider.Label.Text = tostring(Amount)
                Slider.Func(Amount)
            end
        end)
        Window:Resize()
	end
	
	return Window
end

return Library