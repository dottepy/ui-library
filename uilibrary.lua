-- ============================================================
-- NEONFLOW LIBRARY - ULTRA HIGH-END MODULAR ENGINE
-- Fixed: Perfect Alignment, Attached Glow, Glowing Bubble
-- ============================================================
local NeonFlow = {}
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = {
    MainBG = Color3.fromRGB(10, 10, 10), CardBG = Color3.fromRGB(18, 18, 18),
    ItemBG = Color3.fromRGB(25, 25, 25), TopBarBG = Color3.fromRGB(15, 15, 15),
    Stroke = Color3.fromRGB(45, 45, 45), TextPrimary = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(170, 100, 255), AccentSingle = Color3.fromRGB(180, 40, 255),
    GlowGradient = {ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 0, 180))}
}

local function Create(cls, props) local inst = Instance.new(cls) for k, v in pairs(props) do inst[k] = v end return inst end

function NeonFlow:CreateWindow(options)
    local title = options.Title or "NeonFlow UI"
    local size = options.Size or UDim2.fromOffset(580, 460)
    local ScreenGui = Create("ScreenGui", { Name = "NeonFlow_Engine", ResetOnSpawn = false })
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = gethui and gethui() or CoreGui

    -- [ FIXED: Glow nempel sempurna, Thickness 2, No Offset ]
    local MainWindow = Create("Frame", { Name = "MainWindow", Size = size, Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2), BackgroundColor3 = Theme.MainBG, Active = true, Parent = ScreenGui })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = MainWindow})
    local GlowStroke = Create("UIStroke", {Thickness = 2, Parent = MainWindow})
    local GlowGradient = Create("UIGradient", {Color = ColorSequence.new(Theme.GlowGradient), Rotation = 0, Parent = GlowStroke})
    TweenService:Create(GlowGradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360}):Play()

    -- [ FIXED: TopBar Alignment ]
    local TopBar = Create("Frame", { Name = "TopBar", Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Theme.TopBarBG, Parent = MainWindow })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TopBar})
    
    local Title = Create("TextLabel", { Text = title, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.TextPrimary, Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(15, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = TopBar })
    
    -- Controls (Sejajar dengan Title)
    local CloseBtn = Create("TextButton", { Text = "X", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.TextPrimary, Size = UDim2.fromOffset(25, 35), Position = UDim2.new(1, -30, 0, 0), BackgroundTransparency = 1, Parent = TopBar })
    local MinBtn = Create("TextButton", { Text = "—", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.TextPrimary, Size = UDim2.fromOffset(25, 35), Position = UDim2.new(1, -60, 0, 0), BackgroundTransparency = 1, Parent = TopBar })
    
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    -- [ FIXED: Floating Bubble Glow ]
    local MinimizeBubble = Create("TextButton", { Name = "MinimizeBubble", Size = UDim2.fromOffset(40, 40), Position = UDim2.new(0.9, 0, 0.5, 0), BackgroundColor3 = Theme.MainBG, Text = "⚔️", Font = Enum.Font.GothamBold, TextSize = 16, Visible = false, Parent = ScreenGui })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = MinimizeBubble})
    local BubbleStroke = Create("UIStroke", {Thickness = 2, Parent = MinimizeBubble})
    local BubbleGrad = Create("UIGradient", {Color = ColorSequence.new(Theme.GlowGradient), Parent = BubbleStroke})
    TweenService:Create(BubbleGrad, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360}):Play()

    MinBtn.MouseButton1Click:Connect(function() MainWindow.Visible = false; MinimizeBubble.Visible = true end)
    MinimizeBubble.MouseButton1Click:Connect(function() MinimizeBubble.Visible = false; MainWindow.Visible = true end)

    local TabBar = Create("Frame", { Name = "TabBar", Size = UDim2.new(1, -20, 0, 30), Position = UDim2.fromOffset(10, 40), BackgroundTransparency = 1, Parent = MainWindow })
    Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 8), Parent = TabBar})
    Create("Frame", { Name = "Sep", Size = UDim2.new(1, -20, 0, 1), Position = UDim2.fromOffset(10, 75), BackgroundColor3 = Theme.Stroke, Parent = MainWindow })

    local TabContainer = Create("Frame", { Name = "TabContainer", Size = UDim2.new(1, -20, 1, -85), Position = UDim2.fromOffset(10, 80), BackgroundTransparency = 1, ClipsDescendants = true, Parent = MainWindow })
    local WindowObj = { Tabs = {}, Container = TabContainer }

    function WindowObj:AddTab(tabOptions)
        local tabName = tabOptions.Title or "Tab"
        local isDefault = #self.Tabs == 0
        local btn = Create("TextButton", { Size = UDim2.fromOffset(0, 24), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = isDefault and Theme.AccentSingle or Theme.ItemBG, Text = "  "..tabName.."  ", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.TextPrimary, Parent = TabBar })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn})
        
        local frame = Create("ScrollingFrame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 0, AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = isDefault, Parent = TabContainer })
        Create("UIListLayout", {Padding = UDim.new(0, 10), Parent = frame})
        
        table.insert(self.Tabs, {btn = btn, frame = frame})
        btn.MouseButton1Click:Connect(function()
            for _, t in ipairs(self.Tabs) do
                local active = (t.btn == btn)
                t.frame.Visible = active
                t.btn.BackgroundColor3 = active and Theme.AccentSingle or Theme.ItemBG
            end
        end)
        
        local Elements = {}
        function Elements:AddToggle(opt) local row = Create("Frame", {Size = UDim2.new(1,0,0,24), BackgroundTransparency = 1, Parent = frame}); local fill = Create("Frame", {Size = UDim2.fromOffset(16,16), BackgroundColor3 = Theme.AccentSingle, Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0,4), Parent = fill}); Create("TextLabel", {Text = opt.Title, TextSize = 12, TextColor3 = Theme.TextPrimary, Position = UDim2.fromOffset(25, 0), Parent = row}) end
        function Elements:AddButton(opt) local btn = Create("TextButton", {Size = UDim2.new(1,0,0,30), BackgroundColor3 = Theme.CardBG, Text = opt.Title, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.TextPrimary, Parent = frame}); Create("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn}) end
        return Elements
    end
    return WindowObj
end
return NeonFlow
