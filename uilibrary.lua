-- ============================================================
-- NEONFLOW LIBRARY - HIGH-END MODULAR UI ENGINE
-- Inspired by glowing CSS cards & browser-style tabs
-- Standalone, high-end, Ambiguous-free library
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
    CardBG = Color3.fromRGB(20, 20, 20),
    ItemBG = Color3.fromRGB(30, 30, 30),
    TabActiveBG = Color3.fromRGB(81, 81, 81), -- Dark Gray Browser
    TabHeaderBG = Color3.fromRGB(53, 53, 53), -- Dark Gray Header
    Stroke = Color3.fromRGB(50, 50, 50),
    TextPrimary = Color3.fromRGB(240, 240, 240),
    TextMuted = Color3.fromRGB(160, 160, 160),
    AccentGlow = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 0)}, -- Red to Yellow Gradient
    AccentSingle = Color3.fromRGB(232, 28, 255) -- Magenta for highlighting
}

-- [ U T I L S ]
local function Create(cls, props) 
    local inst = Instance.new(cls)
    for k, v in pairs(props) do inst[k] = v end 
    return inst 
end

local function AnimateGlow(stroke, gradient)
    -- This simulates the rotating hover effect by rotating the gradient
    local rotationTween = TweenService:Create(gradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
    rotationTween:Play()
end

-- [ C O R E   E N G I N E ]
function NeonFlow:CreateWindow(options)
    local title = options.Title or "NeonFlow UI"
    local size = options.Size or UDim2.fromOffset(580, 460)

    local ScreenGui = Create("ScreenGui", { Name = "NeonFlow_Engine", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = gethui and gethui() or CoreGui

    -- [ THE MAIN G L O W I N G   C A R D ]
    -- This acts as the border container to simulate the CSS ::before glowing effect
    local MainGlowCard = Create("Frame", {
        Name = "MainGlowCard",
        Size = size + UDim2.fromOffset(6, 6), -- Slight offset for "before" look
        Position = UDim2.new(0.5, -size.X.Offset/2 - 3, 0.5, -size.Y.Offset/2 - 3),
        -- GANTI INI: MainGlowCard container background should be transparent to shine maximal
        -- BackgroundColor3 = Theme.MainBG, 
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        Parent = ScreenGui
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = MainGlowCard})
    
    -- Simulate CSS gradient border using UIStroke with Gradient
    local GlowStroke = Create("UIStroke", {Thickness = 3, Color = Color3.new(1,1,1), Parent = MainGlowCard}) -- Color overwritten by gradient
    local GlowGradient = Create("UIGradient", {Color = ColorSequence.new(Theme.AccentGlow), Rotation = -45, Parent = GlowStroke})
    AnimateGlow(GlowStroke, GlowGradient)

    -- [ MAIN W I N D O W   C O N T E N T ]
    local MainWindow = Create("Frame", {
        Name = "MainWindow",
        Size = size,
        Position = UDim2.fromOffset(3, 3), -- Center window content within GlowCard container
        BackgroundColor3 = Theme.MainBG,
        Parent = MainGlowCard
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = MainWindow})
    Create("UIStroke", {Color = Theme.Stroke, Thickness = 1.5, Parent = MainWindow}) -- Inner subtle border

    -- [ B R O W S E R - S T Y L E   T A B   H E A D E R ]
    local TabHeaderHead = Create("Frame", { Name = "TabsHead", Size = UDim2.new(1, 0, 0, 40), Position = UDim2.fromOffset(0, 0), BackgroundColor3 = Theme.TabHeaderBG, Parent = MainWindow })
    Create("UICorner", {CornerRadius = UDim.new(0, 7), Parent = TabHeaderHead})
    
    -- Bottom masks for TabHeader to connect flat to content area
    Create("Frame", {Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0,0,1,-10), BackgroundColor3 = Theme.TabHeaderBG, BorderSizePixel = 0, ZIndex = 0, Parent = TabHeaderHead})

    -- Draggable Logic Setup (FIXED: Moved here to header area)
    local dragToggle, dragStart, startPosGlow
    TabHeaderHead.InputBegan:Connect(function(input) 
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

    local TabTabBar = Create("Frame", { Name = "TabBarContainer", Size = UDim2.new(1, -90, 1, 0), Position = UDim2.fromOffset(20, 0), BackgroundTransparency = 1, Parent = TabHeaderHead })
    Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Left, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 0), Parent = TabTabBar})

    -- Window options styled like browser example
    local WindowOpts = Create("Frame", { Name = "WindowOpt", Size = UDim2.fromOffset(90, 1), Position = UDim2.new(1, -90, 0, 10), BackgroundTransparency = 1, Parent = TabHeaderHead })
    Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0,0), Parent = WindowOpts})

    local MinBtn = Create("TextButton", { Text = "-", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Theme.TextPrimary, Size = UDim2.fromOffset(30, 20), BackgroundTransparency = 1, Parent = WindowOpts })
    local CloseBtn = Create("TextButton", { Text = "X", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.TextPrimary, Size = UDim2.fromOffset(30, 20), BackgroundTransparency = 1, Parent = WindowOpts })
    
    CloseBtn.MouseButton1Click:Connect(function() MainGlowCard:Destroy() end)
    
    local minState = false
    MinBtn.MouseButton1Click:Connect(function()
        minState = not minState
        if minState then
            MainWindow.Size = UDim2.fromOffset(MainWindow.Size.X.Offset, 40)
            MainWindow.ClipsDescendants = true
        else
            MainWindow.Size = size
            MainWindow.ClipsDescendants = false
        end
    end)

    -- [ T A B   C O N T A I N E R ]
    -- This holds the scrolling frames of each tab content
    local TabContainer = Create("Frame", { Name = "TabContainer", Size = UDim2.new(1, 0, 1, -40), Position = UDim2.fromOffset(0, 40), BackgroundColor3 = Theme.MainBG, ClipsDescendants = true, Parent = MainWindow })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TabContainer})
    -- Mask top corners
    Create("Frame", {Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Theme.MainBG, BorderSizePixel = 0, ZIndex = 0, Parent = TabContainer})

    local WindowObj = { Tabs = {}, ActiveTab = nil, Container = TabContainer, GUI = ScreenGui }

    function WindowObj:AddTab(tabOptions)
        local tabName = tabOptions.Title or "Tab"
        local isDefault = #self.Tabs == 0

        -- Browser Style Tab Button
        local tabBtn = Create("Frame", { Name = "TabBtn_" .. tabName, Size = UDim2.fromOffset(110, 34), BackgroundColor3 = isDefault and Theme.TabActiveBG or Theme.TabHeaderBG, Parent = TabTabBar })
        Create("UICorner", {CornerRadius = UDim.new(0, 7), Parent = tabBtn})
        -- Mask bottom corners to connect flat to content area
        Create("Frame", {Size = UDim2.new(1, 0, 0, 5), Position = UDim2.new(0,0,1,-5), BackgroundColor3 = isDefault and Theme.TabActiveBG or Theme.TabHeaderBG, BorderSizePixel = 0, Parent = tabBtn})

        local tabTitle = Create("TextLabel", { Text = tabName, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.TextPrimary, Size = UDim2.new(1, -20, 1, -8), Position = UDim2.fromOffset(8, 4), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = tabBtn })
        
        -- Browser style close button on tab
        local closeTab = Create("TextLabel", { Text = "x", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Theme.TextMuted, Size = UDim2.fromOffset(12, 12), Position = UDim2.new(1, -18, 0, 6), BackgroundTransparency = 1, Parent = tabBtn })

        -- Tab Content Scrolling Frame
        local frame = Create("ScrollingFrame", { 
            Name = "TabFrame_" .. tabName,
            Size = UDim2.new(1, -20, 1, -20), 
            Position = UDim2.fromOffset(10, 10), 
            BackgroundTransparency = 1, 
            ScrollBarThickness = 3, 
            ScrollBarImageColor3 = Theme.Stroke, 
            AutomaticCanvasSize = Enum.AutomaticSize.Y, 
            Visible = isDefault, 
            Parent = TabContainer 
        })
        Create("UIListLayout", {Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame})

        local tabObj = { btn = tabBtn, title = tabTitle, frame = frame, idx = #self.Tabs }
        table.insert(self.Tabs, tabObj)

        local btnTrigger = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", Parent = tabBtn})
        btnTrigger.MouseButton1Click:Connect(function()
            for _, t in ipairs(self.Tabs) do 
                local isActive = (t == tabObj)
                t.frame.Visible = isActive
                t.btn.BackgroundColor3 = isActive and Theme.TabActiveBG or Theme.TabHeaderBG
                -- Update bottom masks too
                for _, mask in ipairs(t.btn:GetChildren()) do if mask.Name == "Frame" and mask.BorderSizePixel == 0 then mask.BackgroundColor3 = isActive and Theme.TabActiveBG or Theme.TabHeaderBG end end
            end
        end)

        -- [ E L E M E N T   B U I L D E R S ]
        -- These already styled modern elements are available within each tab object
        local Elements = {}
        
        -- Add pre-styled label
        function Elements:AddLabel(text, styledHeading)
            Create("TextLabel", { 
                Text = text, 
                Font = styledHeading and Enum.Font.GothamBold or Enum.Font.Gotham, 
                TextSize = styledHeading and 20 or 14, 
                TextColor3 = styledHeading and Theme.TextPrimary or Theme.TextMuted,
                Size = UDim2.new(1, 0, 0, styledHeading and 30 or 20),
                BackgroundTransparency = 1, 
                TextXAlignment = Enum.TextXAlignment.Left, 
                Parent = frame 
            })
        end

        function Elements:AddToggle(options)
            local title = options.Title or "Toggle"
            local default = options.Default or false
            local callback = options.Callback or function() end

            -- Modern Toggle Component styled sleek
            local row = Create("Frame", {Name = "Toggle_" .. title, Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = frame})
            
            local box = Create("Frame", {Size = UDim2.fromOffset(16, 16), Position = UDim2.new(0, 0, 0.5, -8), BackgroundColor3 = Theme.ItemBG, Parent = row})
            Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = box})
            Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Parent = box})
            
            local fill = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.AccentSingle, Transparency = default and 0 or 1, Parent = box})
            Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = fill})
            local check = Create("TextLabel", {Text = "✓", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Theme.White, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, TextTransparency = default and 0 or 1, Parent = fill})
            
            Create("TextLabel", {Text = title, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Theme.TextPrimary, Size = UDim2.new(1, -26, 1, 0), Position = UDim2.fromOffset(26, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = row})
            
            local btn = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", Parent = row})
            
            local state = default
            btn.MouseButton1Click:Connect(function() 
                state = not state
                TweenService:Create(fill, TweenInfo.new(0.2), {Transparency = state and 0 or 1}):Play()
                TweenService:Create(check, TweenInfo.new(0.2), {TextTransparency = state and 0 or 1}):Play()
                callback(state)
            end)
        end

        function Elements:AddButton(options)
            local text = options.Title or "Button"
            local callback = options.Callback or function() end

            local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Parent = frame})
            
            -- Main Button Background with custom hover glow (improvisation)
            local btn = Create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.CardBG, Text = text, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Theme.AccentSingle, Parent = row})
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn})
            
            -- Adding hover glow effect using UIStroke and Gradient
            local glowStroke = Create("UIStroke", {Thickness = 2, Color = Theme.Stroke, Transparency = 0.5, Parent = btn})
            local hoverGradient = Create("UIGradient", {Color = ColorSequence.new(Theme.AccentGlow), Visible = false, Parent = glowStroke})

            btn.MouseEnter:Connect(function() glowStroke.Color = Color3.new(1,1,1); hoverGradient.Visible = true; glowStroke.Thickness = 3; btn.TextColor3 = Theme.White end)
            btn.MouseLeave:Connect(function() glowStroke.Color = Theme.Stroke; hoverGradient.Visible = false; glowStroke.Thickness = 2; btn.TextColor3 = Theme.AccentSingle end)

            btn.MouseButton1Click:Connect(callback)
        end

        function Elements:AddDropdown(options)
            local title = options.Title or "Dropdown"
            local values = options.Values or {}
            local default = options.Default or 1
            local callback = options.Callback or function() end

            local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = frame})
            Create("TextLabel", {Text = title, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.TextMuted, Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = row})
            
            local btn = Create("TextButton", {Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, 16), BackgroundColor3 = Theme.ItemBG, Text = values[default] or "Select...", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left, Parent = row})
            Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = btn})
            Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Parent = btn})
            Create("TextLabel", {Text = "▼", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.TextMuted, Size = UDim2.fromOffset(20, 20), Position = UDim2.new(1, -20, 0.5, -10), BackgroundTransparency = 1, Parent = btn})

            -- Simplified stand-alone dropdown UI. Full modular logic needed for zindex handling in standalone file. Improvised.
            btn.MouseButton1Click:Connect(function() print("Dropdown functionality not fully implemented in standalone code snippet but UI is ready.") end)
        end

        return Elements
    end

    return WindowObj
end

return NeonFlow
