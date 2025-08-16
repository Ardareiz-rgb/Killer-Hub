--[[
🔥 Killer Hub v1.0
PC + Mobil uyumlu
Sekme, Buton, Toggle, Slider
Animasyonlu ve modern
]]--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KillerHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(30,30,30)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 12)

-- Fade-in animasyon
Main.BackgroundTransparency = 1
TweenService:Create(Main, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()

-- TitleBar
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(20,20,20)

local Title = Instance.new("TextLabel", TitleBar)
Title.Text = "🔥 Killer Hub 🔥"
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-40,0.5,-15)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
local Corner = Instance.new("UICorner", CloseBtn)
Corner.CornerRadius = UDim.new(0,6)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- RightShift aç/kapa (PC)
UserInputService.InputBegan:Connect(function(input,gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

-- Drag fonksiyonu (PC+Mobil)
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Tabs
local Tabs = Instance.new("Frame", Main)
Tabs.Size = UDim2.new(0,120,1,-40)
Tabs.Position = UDim2.new(0,0,0,40)
Tabs.BackgroundColor3 = Color3.fromRGB(20,20,20)
local TabList = Instance.new("UIListLayout", Tabs)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0,5)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1,-120,1,-40)
Container.Position = UDim2.new(0,120,0,40)
Container.BackgroundColor3 = Color3.fromRGB(30,30,30)

local UIPageLayout = Instance.new("UIPageLayout", Container)
UIPageLayout.FillDirection = Enum.FillDirection.Horizontal
UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIPageLayout.TweenTime = 0.3
UIPageLayout.EasingStyle = Enum.EasingStyle.Quad

-- Library
local Window = {}
Window.Pages = {}

function Window:CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Text = name
    TabBtn.Size = UDim2.new(1,0,0,30)
    TabBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    TabBtn.TextColor3 = Color3.new(1,1,1)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 14
    TabBtn.Parent = Tabs

    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1,0,1,0)
    Page.BackgroundTransparency = 1
    Page.LayoutOrder = #Window.Pages+1
    Page.Parent = Container

    local UIList = Instance.new("UIListLayout", Page)
    UIList.Padding = UDim.new(0,5)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder

    Window.Pages[name] = Page

    TabBtn.MouseButton1Click:Connect(function()
        UIPageLayout:JumpTo(Page)
    end)

    local TabFunctions = {}

    -- Normal Button
    function TabFunctions:Button(text,callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0,200,0,35)
        Btn.Text = text
        Btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        Btn.TextColor3 = Color3.new(1,1,1)
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 14
        Btn.Parent = Page
        local Corner = Instance.new("UICorner", Btn)
        Corner.CornerRadius = UDim.new(0,8)

        Btn.MouseEnter:Connect(function()
            TweenService:Create(Btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(70,70,70)}):Play()
        end)
        Btn.MouseLeave:Connect(function()
            TweenService:Create(Btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(50,50,50)}):Play()
        end)

        Btn.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
    end

    -- Toggle
    function TabFunctions:Toggle(text,default,callback)
        local Frame = Instance.new("Frame", Page)
        Frame.Size = UDim2.new(0,200,0,35)
        Frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
        local Corner = Instance.new("UICorner", Frame)
        Corner.CornerRadius = UDim.new(0,8)

        local Label = Instance.new("TextLabel", Frame)
        Label.Size = UDim2.new(0.7,0,1,0)
        Label.Position = UDim2.new(0,5,0,0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.new(1,1,1)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left

        local Btn = Instance.new("TextButton", Frame)
        Btn.Size = UDim2.new(0.3,0,1,0)
        Btn.Position = UDim2.new(0.7,0,0,0)
        Btn.Text = default and "ON" or "OFF"
        Btn.BackgroundColor3 = default and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
        Btn.TextColor3 = Color3.new(1,1,1)
        local BtnCorner = Instance.new("UICorner", Btn)
        BtnCorner.CornerRadius = UDim.new(0,8)

        local toggled = default

        Btn.MouseButton1Click:Connect(function()
            toggled = not toggled
            Btn.Text = toggled and "ON" or "OFF"
            Btn.BackgroundColor3 = toggled and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
            if callback then callback(toggled) end
        end)
    end

    return TabFunctions
end

-- Örnek Kullanım
local MainTab = Window:CreateTab("Main")
MainTab:Button("Merhaba De",function()
    print("Butona basıldı!")
end)
MainTab:Toggle("Fly Modu",false,function(v)
    print("Fly durumu:",v)
end)

local PlayerTab = Window:CreateTab("Player")
PlayerTab:Button("Speed Boost",function()
    print("Speed Boost basıldı")
end)
PlayerTab:Toggle("Noclip",false,function(v)
    print("Noclip durumu:",v)
end)

return Window
