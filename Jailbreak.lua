-- Variables

local Settings = {
    WalkSpeed = 16,
    JumpPower = 50
}

local Services = {
    Players = game:GetService("Players")
}

Local = {
    Player = Services.Players.LocalPlayer
}

Meta = {
    Table = getrawmetatable(game),
    Index = Meta.Table.__index,
    NewIndex = Meta.Table.__newindex,
    Namecall = Meta.Table.__namecall
}

-- Setup

if Local.Player.Character then
    Local.Char = Local.Player.Character
    if Local.Char:FindFirstChild("Humanoid") then
        Local.Hum = Local.Char.Humanoid
        Local.Root = Local.Char.HumanoidRootPart
        Local.Hum.WalkSpeed = Settings.WalkSpeed
        Local.Hum.JumpPower = Settings.JumpPower
        Hum.Died:Connect(function()
            Local.Char = nil
            Local.Hum = nil
            Local.Root = nil
        end)
    end
end

Local.Player.PlayerAdded:Connect(function(Char)
    Local.Char = Char
    Local.Hum = Char:WaitForChild("Humanoid")
    Local.Root = Char:WaitForChild("HumanoidRootPart")
    Local.Hum.WalkSpeed = Settings.WalkSpeed
    Local.Hum.JumpPower = Settings.JumpPower
    Hum.Died:Connect(function()
        Local.Char = nil
        Local.Hum = nil
        Local.Root = nil
    end)
end)

setreadonly(Meta.Table, false)

Meta.Table.__index = newcclosure(function(t, k)
    if not checkcaller() then
        if k == "WalkSpeed" then
            return 16
        elseif k == "JumpPower" then
            return 50
        end
    end
    return Meta.Index(t, k)
end)

-- Gui

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SykoticCataclysm/ScreamSploit/master/GuiLibrary.lua", true))()

local PlayerTab = Library:CreateWindow("Player", 0)

PlayerTab:Slider("WalkSpeed", { min = 16, max = 125, default = Settings.WalkSpeed }, function(val)
    Settings.WalkSpeed = val
    if Local.Hum then
        Local.Hum.WalkSpeed = val
    end
end)

PlayerTab:Slider("JumpPower", { min = 50, max = 100, default = Settings.JumpPower }, function(val)
    Settings.JumpPower = val
    if Local.Hum then
        Local.Hum.JumpPower = val
    end
end)