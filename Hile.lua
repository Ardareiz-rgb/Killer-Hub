-- Killer Hub UI Library
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.__index = Library

-- Drag fonksiyonu (PC + Mobile uyumlu)
local function MakeDraggable(frame, dragHandle)
    local dragging, dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end
    end)
end

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Name = "KillerHub"
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 500, 0, 300)
    Main.Position = UDim2.new(0.5, -250, 0.5, -150)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    local UICorner = Instance.new("UICorner", Main)
    UICorner.CornerRadius = UDim.new(0, 12)

    -- Başlık
    local TitleBar = Instance.new("Frame", Main)
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

    local Title = Instance.new("TextLabel", TitleBar)
    Title.Text = title or "Killer Hub"
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Aç/Kapa butonu (mobil için sağ üst köşe)
    local CloseBtn = Instance.new("TextButton", TitleBar)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
    CloseBtn.Text = "X"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    local corner = Instance.new("UICorner", CloseBtn)
    corner.CornerRadius = UDim.new(0, 6)

    CloseBtn.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)

    -- PC'de aç/kapa tuşu (RightShift)
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.RightShift then
            Main.Visible = not Main.Visible
        end
    end)

    -- Sekme alanı
    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.new(0, 120, 1, -40)
    Tabs.Position = UDim2.new(0, 0, 0, 40)
    Tabs.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

    local TabList = Instance.new("UIListLayout", Tabs)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)

    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -120, 1, -40)
    Container.Position = UDim2.new(0, 120, 0, 40)
    Container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local UIPageLayout = Instance.new("UIPageLayout", Container)
    UIPageLayout.FillDirection = Enum.FillDirection.Horizontal
    UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIPageLayout.TweenTime = 0.3
    UIPageLayout.EasingStyle = Enum.EasingStyle.Quad

    -- Drag aktif et
    MakeDraggable(Main, TitleBar)

    local Window = {}
    Window.Pages = {}

    function Window:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Text = name
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 14
        TabBtn.Parent = Tabs

        local Page = Instance.new("Frame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.LayoutOrder = #Window.Pages + 1
        Page.Parent = Container

        local UIList = Instance.new("UIListLayout", Page)
        UIList.Padding = UDim.new(0, 5)
        UIList.SortOrder = Enum.SortOrder.LayoutOrder

        Window.Pages[name] = Page

        TabBtn.MouseButton1Click:Connect(function()
            UIPageLayout:JumpTo(Page)
        end)

        local TabFunctions = {}

        function TabFunctions:Button(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0, 200, 0, 35)
            Btn.Text = text
            Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.Parent = Page

            local Corner = Instance.new("UICorner", Btn)
            Corner.CornerRadius = UDim.new(0, 8)

            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
                task.wait(0.15)
                TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                if callback then callback() end
            end)
        end

        return TabFunctions
    end

    return Window
end

return Library
