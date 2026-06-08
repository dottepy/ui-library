-- ============================================================
-- NEONFLOW LIBRARY - FINAL STABLE ENGINE
-- FIXED: SINGLE OBJECT UI (Anti-glitch), Draggable fixed, Glow Fixed
-- ============================================================
local NeonFlow = {}
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = {
    MainBG = Color3.fromRGB(10, 10, 10), ItemBG = Color3.fromRGB(20, 20, 20),
    Stroke = Color3.fromRGB(45, 45, 45), AccentSingle = Color3.fromRGB(180, 40, 255),
    GlowGradient = {ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 0, 180))}
}

local function Create(cls, props) local inst = Instance.new(cls) for k, v in pairs(props) do inst[k] = v end return inst end

function NeonFlow:CreateWindow(options)
    local size = options.Size or UDim2.fromOffset(580, 460)
    local ScreenGui = Create("ScreenGui", { Name = "NeonFlow_Engine", ResetOnSpawn = false })
    ScreenGui.Parent = gethui and gethui() or CoreGui

    -- [ THE ONE AND ONLY MAIN WINDOW ]
    -- Glow nempel di sini, Draggable di sini. Tidak ada tumpukan frame!
    local MainWindow = Create("Frame", { Name = "MainWindow", Size = size, Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2), BackgroundColor3 = Theme.MainBG, Parent = ScreenGui })
    Create("UICorner", {CornerRadius = UDim0.new(0, 8), Parent = MainWindow})
    local GlowStroke = Create("UIStroke", {Thickness = 3, Color = Color3.new(1,1,1), Parent = MainWindow})
    local Grad = Create("UIGradient", {Color = ColorSequence.new(Theme.GlowGradient), Rotation = 0, Parent = GlowStroke})
    TweenService:Create(Grad, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360}):Play()

    -- [ DRAGGING ]
    local dragToggle, dragStart, startPos
    MainWindow.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = true; dragStart = input.Position; startPos = MainWindow.Position end end)
    UserInputService.InputChanged:Connect(function(input) if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end end)

    -- [ TOP BAR ]
    local TopBar = Create("Frame", { Name = "TopBar", Size = UDim2.new(1, 0, 0, 35), BackgroundTransparency = 1, Parent = MainWindow })
    Create("TextLabel", { Text = options.Title, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Color3.new(1,1,1), Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(15, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = TopBar })
    
    local CloseBtn = Create("TextButton", { Text = "X", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.new(1,1,1), Size = UDim2.fromOffset(30, 35), Position = UDim2.new(1, -30, 0, 0), BackgroundTransparency = 1, Parent = TopBar })
    local MinBtn = Create("TextButton", { Text = "—", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.new(1,1,1), Size = UDim2.fromOffset(30, 35), Position = UDim2.new(1, -60, 0, 0), BackgroundTransparency = 1, Parent = TopBar })
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- [ FLOATING BUBBLE ]
    local Bubble = Create("TextButton", { Name = "Bubble", Size = UDim2.fromOffset(40, 40), Position = UDim2.new(0.9, 0, 0.5, 0), BackgroundColor3 = Theme.MainBG, Text = "⚔️", Font = Enum.Font.GothamBold, TextSize = 16, Visible = false, Parent = ScreenGui })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Bubble})
    local BStroke = Create("UIStroke", {Thickness = 2, Parent = Bubble})
    local BGrad = Create("UIGradient", {Color = ColorSequence.new(Theme.GlowGradient), Parent = BStroke})
    TweenService:Create(BGrad, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360}):Play()
    
    MinBtn.MouseButton1Click:Connect(function() MainWindow.Visible = false; Bubble.Visible = true end)
    Bubble.MouseButton1Click:Connect(function() if tick() - lastClick < 0.4 then Bubble.Visible = false; MainWindow.Visible = true end; lastClick = tick() end)

    -- [ TABS ]
    local TabBar = Create("Frame", { Name = "TabBar", Size = UDim2.new(1, -20, 0, 30), Position = UDim2.fromOffset(10, 40), BackgroundTransparency = 1, Parent = MainWindow })
    Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), Parent = TabBar})
    local TabContainer = Create("Frame", { Name = "TabContainer", Size = UDim2.new(1, -20, 1, -80), Position = UDim2.fromOffset(10, 80), BackgroundTransparency = 1, ClipsDescendants = true, Parent = MainWindow })

    local WindowObj = { Tabs = {}, Container = TabContainer }
    function WindowObj:AddTab(opt)
        local btn = Create("TextButton", { Size = UDim2.fromOffset(0, 24), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = (#self.Tabs == 0 and Theme.AccentSingle or Theme.ItemBG), Text = "  "..opt.Title.."  ", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.new(1,1,1), Parent = TabBar })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn})
        local frame = Create("ScrollingFrame", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, ScrollBarThickness = 0, AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = (#self.Tabs == 0), Parent = TabContainer })
        Create("UIListLayout", {Padding = UDim.new(0, 10), Parent = frame})
        table.insert(self.Tabs, {btn = btn, frame = frame})
        btn.MouseButton1Click:Connect(function() for _, t in ipairs(self.Tabs) do t.frame.Visible = (t.btn == btn); t.btn.BackgroundColor3 = (t.btn == btn and Theme.AccentSingle or Theme.ItemBG) end end)
        return { AddToggle = function(o) local r = Create("Frame", {Size = UDim2.new(1,0,0,24), BackgroundTransparency = 1, Parent = frame}); local f = Create("Frame", {Size = UDim2.fromOffset(16,16), BackgroundColor3 = Theme.AccentSingle, Parent = r}); Create("UICorner", {CornerRadius = UDim.new(0,4), Parent = f}); Create("TextLabel", {Text = o.Title, TextSize = 12, TextColor3 = Color3.new(1,1,1), Position = UDim2.fromOffset(25, 0), Parent = r}) end }
    end
    return WindowObj
end
return NeonFlow
