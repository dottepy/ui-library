-- ============================================================
-- NEONFLOW LIBRARY - ULTRA HIGH-END MODULAR ENGINE
-- Fixed: Consolidated Window (No Glow Gap), Clean Controls, Glowing Bubble
-- ambiguity-free, optimized, stand-alone library
-- ============================================================
local NeonFlow = {}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [ T H E M E   C O N F I G ]
-- All IDs here are in English
local Theme = {
    MainBG = Color3.fromRGB(10, 10, 10),
    CardBG = Color3.fromRGB(18, 18, 18),
    ItemBG = Color3.fromRGB(25, 25, 25),
    TopBarBG = Color3.fromRGB(15, 15, 15),
    TabBtnActive = Color3.fromRGB(35, 35, 35),
    Stroke = Color3.fromRGB(45, 45, 45),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(170, 100, 255),
    -- Neon Purple Glow Gradient
    GlowGradient = {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)), 
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 0, 180))
    },
    AccentSingle = Color3.fromRGB(180, 40, 255) -- Magenta for highlighting
}

-- [ U T I L S ]
local function Create(cls, props) 
    local inst = Instance.new(cls)
    for k, v in pairs(props) do inst[k] = v end 
    return inst 
end

local function AnimateGlow(stroke, gradient)
    -- This simulates the rotating hover effect by rotating the gradient
    local rotationTween = TweenService:Create(gradient, TweenInfo.new(3.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
    rotationTween:Play()
end

-- [ C O R E   E N G I N E ]
function NeonFlow:CreateWindow(options)
    local title = options.Title or "NeonFlow UI"
    local size = options.Size or UDim2.fromOffset(580, 460)

    local ScreenGui = Create("ScreenGui", { Name = "NeonFlow_Engine", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = gethui and gethui() or CoreGui

    -- [ M A I N   W I N D O W ]
    -- Sekarang cuma 1 Frame biar glow-nya 100% nempel sempurna di pinggir tanpa celah.
    local MainWindow = Create("Frame", {
        Name = "MainWindow",
        Size = size,
        Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2),
        BackgroundColor3 = Theme.MainBG,
        Active = true, -- PENTING untuk input
        Parent = ScreenGui
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = MainWindow})
    
    -- Glow nempel langsung di MainWindow menggunakan UIStroke
    local GlowStroke = Create("UIStroke", {Thickness = 3, Color = Color3.new(1,1,1), Parent = MainWindow}) -- Color overwritten by gradient
    local GlowGradient = Create("UIGradient", {Color = ColorSequence.new(Theme.GlowGradient), Rotation = 0, Parent = GlowStroke})
    AnimateGlow(GlowStroke, GlowGradient)

    -- [ T O P   B A R ] (Draggable Area only now)
    local TopBar = Create("Frame", { Name = "TopBar", Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Theme.TopBarBG, Parent = MainWindow })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TopBar})
    -- Mask bottom corners to connect flat to content area
    Create("Frame", {Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0,0,1,-10), BackgroundColor3 = Theme.TopBarBG, BorderSizePixel = 0, Parent = TopBar})
    -- Garis pemisah tipis
    Create("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0,0,1,0), BackgroundColor3 = Theme.Stroke, BorderSizePixel = 0, Parent = TopBar}) 

    -- [ D R A G G I N G   L O G I C ] (Now triggers on TopBar click and moves MainWindow)
    local dragToggle, dragStart, startPos
    TopBar.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            dragToggle = true; dragStart = input.Position; startPos = MainWindow.Position 
        end 
    end)
    UserInputService.InputChanged:Connect(function(input) 
        if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then 
            local delta = input.Position - dragStart
            MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
        end 
    end)
    UserInputService.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end 
    end)

    -- Title Section (FIXED: Cleaned up and moved explanation here as desc)
    local TitleContainer = Create("Frame", { Name = "TitleSection", Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.fromOffset(15, 0), BackgroundTransparency = 1, Parent = TopBar })
    Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6), Parent = TitleContainer})
    Create("TextLabel", { Text = title, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.TextPrimary, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Parent = TitleContainer })

    -- Controls Section (FIXED: SLEEK, PRECISE & ALIGNED)
    local WindowOpts = Create("Frame", { Name = "WindowOpt", Size = UDim2.fromOffset(80, 1), Position = UDim2.new(1, -80, 0, 0), BackgroundTransparency = 1, Parent = TopBar })
    Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 8), Parent = WindowOpts})
    Create("UIPadding", {PaddingRight = UDim.new(0, 15), Parent = WindowOpts}) -- right padding for neat distance

    -- Controls are now simple buttons with direct Text property and sizes for precise alignment. Removed nested labels.
    local MinBtn = Create("TextButton", { Text = "—", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.TextPrimary, Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, Parent = WindowOpts })
    local CloseBtn = Create("TextButton", { Text = "X", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.TextPrimary, Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, Parent = WindowOpts })
    
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    -- [ F L O A T I N G   B U B B L E   L O G I C ]
    -- The specialized minimize bubble. FIXED: Background and GLOW are now correct and attached.
    local MinimizeBubble = Create("TextButton", {
        Name = "MinimizeBubble",
        Size = UDim2.fromOffset(46, 46),
        Position = UDim2.new(1, -60, 0.5, -23),
        BackgroundColor3 = Theme.MainBG, -- solid background inside
        Text = "⚔️", Font = Enum.Font.GothamBold, TextSize = 20,
        Visible = false,
        Parent = ScreenGui
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = MinimizeBubble})
    
    -- Glow nempel langsung di MinimizeBubble menggunakan UIStroke
    local BubbleStroke = Create("UIStroke", {Thickness = 3, Color = Color3.new(1,1,1), Parent = MinimizeBubble}) -- Color overwritten by gradient
    local BubbleGradient = Create("UIGradient", {Color = ColorSequence.new(Theme.AccentGlow), Rotation = 0, Parent = BubbleStroke})
    AnimateGlow(BubbleStroke, BubbleGradient) -- Glow animation attached to bubble

    -- Bubble Dragging Setup
    local bDragToggle, bDragStart, bStartPos
    MinimizeBubble.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            bDragToggle = true; bDragStart = input.Position; bStartPos = MinimizeBubble.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if bDragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - bDragStart
            MinimizeBubble.Position = UDim2.new(bStartPos.X.Scale, bStartPos.X.Offset + delta.X, bStartPos.Y.Scale, bStartPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then bDragToggle = false end
    end)

    -- Double Click Restore logic
    local lastBubbleClick = 0
    MinimizeBubble.MouseButton1Click:Connect(function()
        local currentTick = tick()
        if currentTick - lastBubbleClick < 0.4 then -- Double click detected
            MinimizeBubble.Visible = false
            MainWindow.Visible = true
        end
        lastBubbleClick = currentTick
    end)

    MinBtn.MouseButton1Click:Connect(function()
        MainWindow.Visible = false
        MinimizeBubble.Visible = true
    end)

    -- [ T A B   B A R ]
    local TabBar = Create("Frame", { Name = "TabBar", Size = UDim2.new(1, -20, 0, 35), Position = UDim2.fromOffset(10, 40), BackgroundTransparency = 1, Parent = MainWindow })
    Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 8), Parent = TabBar})

    -- [ G A R I S   P E M I S A H ] Line separator after Tab Bar
    Create("Frame", { Name = "Separator", Size = UDim2.new(1, -20, 0, 1), Position = UDim2.new(0, 10, 0, 80), BackgroundColor3 = Theme.Stroke, BorderSizePixel = 0, Parent = MainWindow })

    -- [ T A B   C O N T A I N E R ]
    -- FIXED: ClipsDescendants = true so scrolling frames don't overflow the designated area
    local TabContainer = Create("Frame", { Name = "TabContainer", Size = UDim2.new(1, -20, 1, -115), Position = UDim2.fromOffset(10, 85), BackgroundTransparency = 1, ClipsDescendants = true, Parent = MainWindow })

    -- [ F O O T E R ] Permanently visible footer "created by tepy"
    local Footer = Create("TextLabel", { Text = "created by tepy", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Theme.TextMuted, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 1, -20), BackgroundTransparency = 1, TextTransparency = 0.5, Parent = MainWindow })

    local WindowObj = { Tabs = {}, ActiveTab = nil, Container = TabContainer, GUI = ScreenGui }

    -- [ N E W   N A V I G A T I O N   L O G I C ]
    function WindowObj:AddTab(tabOptions)
        local tabName = tabOptions.Title or "Tab"
        local isDefault = #self.Tabs == 0

        -- SLEEK NAVIGATION BUTTON (Centered Pill Style)
        local navBtn = Create("TextButton", { 
            Name = "NavBtn_" .. tabName, 
            Size = UDim2.fromOffset(0, 26), AutomaticSize = Enum.AutomaticSize.X, 
            BackgroundColor3 = isDefault and Theme.TabBtnActive or Theme.TabHeaderBG, 
            Text = "  " .. tabName .. "  ", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = isDefault and Theme.AccentSingle or Theme.TextMuted,
            Parent = TabBar 
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
            ClipsDescendants = false, -- individual tab scrolling within container
            Parent = TabContainer 
        })
        Create("UIListLayout", {Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame})

        local tabObj = { btn = navBtn, frame = frame, idx = #self.Tabs, stroke = btnStroke }
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
        function Elements:AddDropdown(options) local title = options.Title or "Dropdown"; local values = options.Values or {}; local default = options.Default or 1; local callback = options.Callback or function() end; local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = frame}); Create("TextLabel", {Text = title, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.TextMuted, Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = row}); local btn = Create("TextButton", {Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, 16), BackgroundColor3 = Theme.CardBG, Text = values[default] or "Select...", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left, Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = btn}); Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Parent = btn}); Create("TextLabel", {Text = "▼", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Theme.TextMuted, Size = UDim2.fromOffset(20, 20), Position = UDim2.new(1, -20, 0.5, -10), BackgroundTransparency = 1, Parent = btn}); btn.MouseButton1Click:Connect(function() print("Dropdown Standalone click handled.") end) end
        
        return Elements
    end

    -- [ A U T O   I N J E C T   'M I S C'   T A B ]
    task.spawn(function()
        local MiscTab = WindowObj:AddTab({Title = "Misc"})
        MiscTab:AddLabel("Utility & Settings", true)
        MiscTab:AddToggle({ Title = "Window Transparency", Default = false, Callback = function(state) TweenService:Create(MainWindow, TweenInfo.new(0.3), {BackgroundTransparency = state and 0.35 or 0}):Play() end })
        MiscTab:AddButton({ Title = "Join Discord", Callback = function() if setclipboard then setclipboard("https://discord.gg/yourlink"); print("Discord link copied to clipboard!") end end })
    end)

    return WindowObj
end

return NeonFlow
