-- ============================================================
-- NEONFLOW LIBRARY - ULTRA HIGH-END MODULAR ENGINE
-- Style: Neon Purple & Black | Integrated High-End Top Bar
-- ambiguity-free, optimized, stand-alone library
-- ============================================================
local NeonFlow = {}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [ T H E M E   C O N F I G ]
-- CHANGE: Whole color palette to Black, Purple, and White
local Theme = {
    MainBG = Color3.fromRGB(5, 5, 5), -- Deep Black
    CardBG = Color3.fromRGB(15, 15, 15), -- Section/Card BG
    ItemBG = Color3.fromRGB(20, 20, 20), -- Interactable BG
    TabHeaderBG = Color3.fromRGB(10, 10, 10), -- Sleek Top Bar
    TabBtnActive = Color3.fromRGB(30, 30, 30), -- Active Tab BG
    Stroke = Color3.fromRGB(40, 40, 40), -- Subtle border
    TextPrimary = Color3.fromRGB(255, 255, 255), -- White
    TextMuted = Color3.fromRGB(180, 100, 255), -- Muted Purple
    -- Neon Purple Glow Gradient
    GlowGradient = {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 0, 255)), -- Deep Purple
        ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 0, 130))  -- Dark Purple
    },
    AccentSingle = Color3.fromRGB(160, 32, 255) -- Bright Neon Purple
}

-- [ U T I L S ]
local function Create(cls, props) 
    local inst = Instance.new(cls)
    for k, v in pairs(props) do inst[k] = v end 
    return inst 
end

local function AnimateGlow(stroke, gradient)
    -- This simulates the rotating hover effect by rotating the gradient
    local rotationTween = TweenService:Create(gradient, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
    rotationTween:Play()
end

-- [ C O R E   E N G I N E ]
function NeonFlow:CreateWindow(options)
    local title = options.Title or "NeonFlow UI"
    local subtitle = options.SubTitle or "by user"
    local size = options.Size or UDim2.fromOffset(580, 460)

    local ScreenGui = Create("ScreenGui", { Name = "NeonFlow_Engine", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = gethui and gethui() or CoreGui

    -- [ THE MAIN G L O W I N G   C A R D ]
    -- Transparent container for the rotating neon border effect
    local MainGlowCard = Create("Frame", {
        Name = "MainGlowCard",
        Size = size + UDim2.fromOffset(8, 8), -- Margin for glow
        Position = UDim2.new(0.5, -size.X.Offset/2 - 4, 0.5, -size.Y.Offset/2 - 4),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        Parent = ScreenGui
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = MainGlowCard})
    
    -- UIStroke with UIGradient for the rotating neon border
    local GlowStroke = Create("UIStroke", {Thickness = 4, Color = Color3.new(1,1,1), Parent = MainGlowCard}) -- Color overwritten by gradient
    local GlowGradient = Create("UIGradient", {Color = ColorSequence.new(Theme.GlowGradient), Rotation = -45, Parent = GlowStroke})
    AnimateGlow(GlowStroke, GlowGradient)

    -- [ MAIN W I N D O W   C O N T E N T ]
    local MainWindow = Create("Frame", {
        Name = "MainWindow",
        Size = size,
        Position = UDim2.fromOffset(4, 4), -- Offset to show glow
        BackgroundColor3 = Theme.MainBG,
        Parent = MainGlowCard
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = MainWindow})
    Create("UIStroke", {Color = Theme.Stroke, Thickness = 1.5, Parent = MainWindow}) -- Inner subtle border

    -- [ H I G H - E N D   T O P   B A R ]
    -- This area contains Title, Navigation, and Controls, integrated seamlessly.
    local TopBarArea = Create("Frame", { Name = "TopBar", Size = UDim2.new(1, 0, 0, 35), Position = UDim2.fromOffset(0, 0), BackgroundColor3 = Theme.TabHeaderBG, Parent = MainWindow })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = TopBarArea})
    -- Mask bottom corners to keep top integrated
    Create("Frame", {Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0,0,1,-10), BackgroundColor3 = Theme.TabHeaderBG, BorderSizePixel = 0, Parent = TopBarArea})
    
    -- Draggable Logic Setup (FIXED: Full top bar draggable)
    local dragToggle, dragStart, startPosGlow
    TopBarArea.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            dragToggle = true; dragStart = input.Position; startPosGlow = MainGlowCard.Position 
        end 
    end)
    UserInputService.InputChanged:Connect(function(input) 
        if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then 
            local delta = input.Position - dragStart
            MainGlowCard.Position = UDim2.new(startPosGlow.X.Scale, startPosGlow.X.Offset + delta.X, startPosGlow.Y.Scale, startPosGlow.Y.Offset + delta.Y) 
        end 
    end)
    UserInputService.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end 
    end)

    -- Title Section (Left)
    local TitleContainer = Create("Frame", { Name = "TitleSection", Size = UDim2.new(0.3, 0, 1, 0), Position = UDim2.fromOffset(15, 0), BackgroundTransparency = 1, Parent = TopBarArea })
    Create("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, -2), Parent = TitleContainer})
    Create("TextLabel", { Text = title, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.TextPrimary, Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = TitleContainer })
    Create("TextLabel", { Text = subtitle, Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.TextMuted, Size = UDim2.new(1, 0, 0, 12), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = TitleContainer })

    -- Navigation Section (Center)
    -- This replaces the old tab system with sleek, centered navigation buttons.
    local NavBarContainer = Create("Frame", { Name = "NavBar", Size = UDim2.new(0.4, 0, 1, 0), Position = UDim2.new(0.3, 15, 0, 0), BackgroundTransparency = 1, Parent = TopBarArea })
    Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 8), Parent = NavBarContainer})

    -- Window Controls Section (Right)
    local WindowOpts = Create("Frame", { Name = "WindowOpt", Size = UDim2.fromOffset(70, 1), Position = UDim2.new(1, -75, 0, 0), BackgroundTransparency = 1, Parent = TopBarArea })
    Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 5), Parent = WindowOpts})
    Create("UIPadding", {PaddingRight = UDim.new(0, 10), Parent = WindowOpts}) -- right margin

    local MinBtn = Create("TextButton", { Text = "_", Font = Enum.Font.Gotham, TextSize = 16, TextColor3 = Theme.TextPrimary, Size = UDim2.fromOffset(25, 20), BackgroundTransparency = 1, Parent = WindowOpts })
    local CloseBtn = Create("TextButton", { Text = "x", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Theme.TextPrimary, Size = UDim2.fromOffset(25, 20), BackgroundTransparency = 1, Parent = WindowOpts })
    
    CloseBtn.MouseButton1Click:Connect(function() MainGlowCard:Destroy() end)
    
    -- Smooth Minimize
    local isMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetSize = isMinimized and UDim2.fromOffset(MainWindow.Size.X.Offset, 35) or size
        local targetGlowSize = isMinimized and UDim2.fromOffset(size.X.Offset + 8, 35 + 8) or (size + UDim2.fromOffset(8, 8))
        
        TweenService:Create(MainWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
        TweenService:Create(MainGlowCard, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetGlowSize}):Play()
        MainWindow.ClipsDescendants = isMinimized
    end)

    -- [ T A B   C O N T A I N E R ]
    -- This holds the content frames, positioned below the top bar.
    local TabContainer = Create("Frame", { Name = "TabContainer", Size = UDim2.new(1, -20, 1, -55), Position = UDim2.fromOffset(10, 45), BackgroundColor3 = Theme.MainBG, ClipsDescendants = true, Parent = MainWindow })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TabContainer})

    local WindowObj = { Tabs = {}, ActiveTab = nil, Container = TabContainer, GUI = ScreenGui }

    -- [ N E W   H I G H - E N D   N A V I G A T I ON   L O G I C ]
    function WindowObj:AddTab(tabOptions)
        local tabName = tabOptions.Title or "Tab"
        local isDefault = #self.Tabs == 0

        -- SLEEK NAVIGATION BUTTON (Centered Pill Style)
        local navBtn = Create("TextButton", { 
            Name = "NavBtn_" .. tabName, 
            Size = UDim2.fromOffset(90, 24), 
            BackgroundColor3 = isDefault and Theme.TabBtnActive or Theme.TabHeaderBG, 
            Text = tabName, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = isDefault and Theme.AccentSingle or Theme.TextMuted,
            Parent = NavBarContainer 
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = navBtn})
        local btnStroke = Create("UIStroke", {Color = isDefault and Theme.AccentSingle or Theme.Stroke, Thickness = 1, Transparency = isDefault and 0 or 0.8, Parent = navBtn})

        -- Content Frame
        local frame = Create("ScrollingFrame", { 
            Name = "TabFrame_" .. tabName,
            Size = UDim2.new(1, -10, 1, -10), 
            Position = UDim2.fromOffset(5, 5), 
            BackgroundTransparency = 1, 
            ScrollBarThickness = 2, 
            ScrollBarImageColor3 = Theme.Stroke, 
            AutomaticCanvasSize = Enum.AutomaticSize.Y, 
            Visible = isDefault, 
            ClipsDescendants = false,
            Parent = TabContainer 
        })
        Create("UIListLayout", {Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame})

        local tabObj = { btn = navBtn, titleLabel = nil, frame = frame, idx = #self.Tabs, stroke = btnStroke }
        table.insert(self.Tabs, tabObj)

        -- Handle navigation switching
        navBtn.MouseButton1Click:Connect(function()
            for _, t in ipairs(self.Tabs) do 
                local isActive = (t == tabObj)
                t.frame.Visible = isActive
                t.btn.BackgroundColor3 = isActive and Theme.TabBtnActive or Theme.TabHeaderBG
                t.btn.TextColor3 = isActive and Theme.AccentSingle or Theme.TextMuted
                t.stroke.Color = isActive and Theme.AccentSingle or Theme.Stroke
                t.stroke.Transparency = isActive and 0 or 0.8
            end
        end)

        -- [ E L E M E N T   B U I L D E R S ]
        local Elements = {}
        
        function Elements:AddLabel(text, styledHeading) Create("TextLabel", { Text = text, Font = styledHeading and Enum.Font.GothamBold or Enum.Font.Gotham, TextSize = styledHeading and 16 or 13, TextColor3 = styledHeading and Theme.TextPrimary or Theme.TextMuted, Size = UDim2.new(1, 0, 0, styledHeading and 24 or 20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = frame }) end
        function Elements:AddToggle(options) local title = options.Title or "Toggle"; local default = options.Default or false; local callback = options.Callback or function() end; local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = frame}); local box = Create("Frame", {Size = UDim2.fromOffset(16, 16), Position = UDim2.new(0, 0, 0.5, -8), BackgroundColor3 = Theme.ItemBG, Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = box}); Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Parent = box}); local fill = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.AccentSingle, Transparency = default and 0 or 1, Parent = box}); Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = fill}); local check = Create("TextLabel", {Text = "✓", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Theme.White, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, TextTransparency = default and 0 or 1, Parent = fill}); Create("TextLabel", {Text = title, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.TextPrimary, Size = UDim2.new(1, -26, 1, 0), Position = UDim2.fromOffset(26, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = row}); local btn = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", Parent = row}); local state = default; btn.MouseButton1Click:Connect(function() state = not state; TweenService:Create(fill, TweenInfo.new(0.15), {Transparency = state and 0 or 1}):Play(); TweenService:Create(check, TweenInfo.new(0.15), {TextTransparency = state and 0 or 1}):Play(); callback(state) end); return { Set = function(newState) state = newState; fill.Transparency = state and 0 or 1; check.TextTransparency = state and 0 or 1; callback(state) end } end
        function Elements:AddButton(options) local text = options.Title or "Button"; local callback = options.Callback or function() end; local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 35), BackgroundTransparency = 1, Parent = frame}); local btn = Create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.CardBG, Text = text, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Theme.AccentSingle, Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = btn}); local glowStroke = Create("UIStroke", {Thickness = 1.5, Color = Theme.Stroke, Parent = btn}); local hoverGradient = Create("UIGradient", {Color = ColorSequence.new(Theme.AccentGlow), Visible = false, Parent = glowStroke}); btn.MouseEnter:Connect(function() glowStroke.Color = Color3.new(1,1,1); hoverGradient.Visible = true; glowStroke.Thickness = 2.5; btn.TextColor3 = Theme.White end); btn.MouseLeave:Connect(function() glowStroke.Color = Theme.Stroke; hoverGradient.Visible = false; glowStroke.Thickness = 1.5; btn.TextColor3 = Theme.AccentSingle end); btn.MouseButton1Click:Connect(callback) end
        
        return Elements
    end

    return WindowObj
end

return NeonFlow
