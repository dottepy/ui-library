-- ============================================================
-- NEONFLOW LIBRARY - ULTRA HIGH-END MODULAR ENGINE
-- Fixed: Attached Glow, Floating Bubble, Hidden Scrollbar, Clean TopBar
-- ============================================================
local NeonFlow = {}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [ T H E M E   C O N F I G ]
local Theme = {
    MainBG = Color3.fromRGB(10, 10, 10),
    CardBG = Color3.fromRGB(18, 18, 18),
    ItemBG = Color3.fromRGB(25, 25, 25),
    TopBarBG = Color3.fromRGB(15, 15, 15),
    Stroke = Color3.fromRGB(45, 45, 45),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(170, 100, 255),
    GlowGradient = {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)), 
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 0, 180))
    },
    AccentSingle = Color3.fromRGB(150, 20, 220)
}

local function Create(cls, props) 
    local inst = Instance.new(cls)
    for k, v in pairs(props) do inst[k] = v end 
    return inst 
end

local function AnimateGlow(gradient)
    local rotationTween = TweenService:Create(gradient, TweenInfo.new(3.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
    rotationTween:Play()
end

function NeonFlow:CreateWindow(options)
    local title = options.Title or "NeonFlow UI"
    local size = options.Size or UDim2.fromOffset(580, 460)

    local ScreenGui = Create("ScreenGui", { Name = "NeonFlow_Engine", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = gethui and gethui() or CoreGui

    -- [ G L O W   C O N T A I N E R ]
    local MainGlowCard = Create("Frame", {
        Name = "MainGlowCard",
        Size = size + UDim2.fromOffset(6, 6),
        Position = UDim2.new(0.5, -size.X.Offset/2 - 3, 0.5, -size.Y.Offset/2 - 3),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        Parent = ScreenGui
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = MainGlowCard})
    
    local GlowStroke = Create("UIStroke", {Color = Color3.new(1,1,1), Thickness = 2, Parent = MainGlowCard})
    local GlowGradient = Create("UIGradient", {Color = ColorSequence.new(Theme.GlowGradient), Rotation = 0, Parent = GlowStroke})
    AnimateGlow(GlowGradient)

    -- [ M A I N   W I N D O W ]
    local MainWindow = Create("Frame", {
        Name = "MainWindow",
        Size = size,
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = Theme.MainBG,
        Active = true,
        Parent = MainGlowCard
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = MainWindow})

    -- [ T O P   B A R ]
    local TopBar = Create("Frame", { Name = "TopBar", Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Theme.TopBarBG, Parent = MainWindow })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TopBar})
    Create("Frame", {Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0,0,1,-10), BackgroundColor3 = Theme.TopBarBG, BorderSizePixel = 0, Parent = TopBar})
    Create("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0,0,1,0), BackgroundColor3 = Theme.Stroke, BorderSizePixel = 0, Parent = TopBar}) 

    -- [ D R A G G I N G   L O G I C ] (Fixed: Assigned to TopBar & moves MainGlowCard)
    local dragToggle, dragStart, startPos
    TopBar.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            dragToggle = true; dragStart = input.Position; startPos = MainGlowCard.Position 
        end 
    end)
    UserInputService.InputChanged:Connect(function(input) 
        if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then 
            local delta = input.Position - dragStart
            MainGlowCard.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
        end 
    end)
    UserInputService.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end 
    end)

    -- Title Section
    local TitleContainer = Create("Frame", { Name = "TitleSection", Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.fromOffset(15, 0), BackgroundTransparency = 1, Parent = TopBar })
    Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6), Parent = TitleContainer})
    Create("TextLabel", { Text = title, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.TextPrimary, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Parent = TitleContainer })

    -- Controls Section (Sleek & Neat)
    local WindowOpts = Create("Frame", { Name = "WindowOpt", Size = UDim2.fromOffset(80, 1), Position = UDim2.new(1, -80, -5, 1), BackgroundTransparency = 1, Parent = TopBar })
    Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 8), Parent = WindowOpts})
    Create("UIPadding", {PaddingRight = UDim.new(0, 15), Parent = WindowOpts})

    local MinBtn = Create("TextButton", { Text = "—", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.TextPrimary, Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, Parent = WindowOpts })
    local CloseBtn = Create("TextButton", { Text = "X", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.TextPrimary, Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, Parent = WindowOpts })
    
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    -- [ F L O A T I N G   B U B B L E   L O G I C ]
    local MinimizeBubble = Create("TextButton", {
        Name = "MinimizeBubble",
        Size = UDim2.fromOffset(46, 46),
        Position = UDim2.new(1, -60, 0.5, -23),
        BackgroundColor3 = Theme.MainBG,
        Text = "⚔️", -- Iconnya
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        Visible = false,
        Parent = ScreenGui
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = MinimizeBubble})
    local BubbleStroke = Create("UIStroke", {Color = Color3.new(1,1,1), Thickness = 2, Parent = MinimizeBubble})
    local BubbleGrad = Create("UIGradient", {Color = ColorSequence.new(Theme.GlowGradient), Rotation = 0, Parent = BubbleStroke})
    AnimateGlow(BubbleGrad)

    -- Bubble Dragging Logic
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

    -- Double Click Logic
    local lastClick = 0
    MinimizeBubble.MouseButton1Click:Connect(function()
        local currentTick = tick()
        if currentTick - lastClick < 0.4 then -- Deteksi double click
            MinimizeBubble.Visible = false
            MainGlowCard.Visible = true
        end
        lastClick = currentTick
    end)

    -- Handle Minimize Button Click
    MinBtn.MouseButton1Click:Connect(function()
        MainGlowCard.Visible = false
        MinimizeBubble.Visible = true
    end)

    -- [ T A B   B A R ]
    local TabBar = Create("Frame", { Name = "TabBar", Size = UDim2.new(1, -20, 0, 35), Position = UDim2.fromOffset(10, 40), BackgroundTransparency = 1, Parent = MainWindow })
    Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 8), Parent = TabBar})

    -- [ G A R I S   P E M I S A H ]
    Create("Frame", { Name = "Separator", Size = UDim2.new(1, -20, 0, 1), Position = UDim2.new(0, 10, 0, 80), BackgroundColor3 = Theme.Stroke, BorderSizePixel = 0, Parent = MainWindow })

    -- [ T A B   C O N T A I N E R ]
    local TabContainer = Create("Frame", { Name = "TabContainer", Size = UDim2.new(1, -20, 1, -115), Position = UDim2.fromOffset(10, 85), BackgroundTransparency = 1, ClipsDescendants = true, Parent = MainWindow })

    -- [ F O O T E R ]
    local Footer = Create("TextLabel", { Text = "created by tepy", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Theme.TextMuted, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 1, -20), BackgroundTransparency = 1, TextTransparency = 0.5, Parent = MainWindow })

    local WindowObj = { Tabs = {}, ActiveTab = nil, Container = TabContainer, GUI = ScreenGui }

    function WindowObj:AddTab(tabOptions)
        local tabName = tabOptions.Title or "Tab"
        local isDefault = #self.Tabs == 0

        local navBtn = Create("TextButton", { 
            Name = "NavBtn_" .. tabName, 
            Size = UDim2.fromOffset(0, 26), 
            AutomaticSize = Enum.AutomaticSize.X, 
            BackgroundColor3 = isDefault and Theme.AccentSingle or Theme.ItemBG, 
            Text = "  " .. tabName .. "  ", 
            Font = Enum.Font.GothamBold, 
            TextSize = 12, 
            TextColor3 = Theme.TextPrimary, 
            Parent = TabBar 
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = navBtn})
        local btnStroke = Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Transparency = isDefault and 1 or 0, Parent = navBtn})

        -- FIXED: ScrollBarThickness 0 = hidden, CanvasSize 0,0,0,0 fixes infinite scroll bug
        local frame = Create("ScrollingFrame", { 
            Name = "TabFrame_" .. tabName, 
            Size = UDim2.new(1, 0, 1, 0), 
            BackgroundTransparency = 1, 
            ScrollBarThickness = 0, 
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y, 
            Visible = isDefault, 
            ClipsDescendants = false, 
            Parent = TabContainer 
        })
        Create("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame})

        local tabObj = { btn = navBtn, frame = frame, idx = #self.Tabs, stroke = btnStroke }
        table.insert(self.Tabs, tabObj)

        navBtn.MouseButton1Click:Connect(function()
            for _, t in ipairs(self.Tabs) do 
                local isActive = (t == tabObj)
                t.frame.Visible = isActive
                t.btn.BackgroundColor3 = isActive and Theme.AccentSingle or Theme.ItemBG
                t.stroke.Transparency = isActive and 1 or 0
            end
        end)

        -- [ E L E M E N T S ]
        local Elements = {}
        
        function Elements:AddLabel(text, styledHeading) Create("TextLabel", { Text = text, Font = styledHeading and Enum.Font.GothamBold or Enum.Font.Gotham, TextSize = styledHeading and 15 or 12, TextColor3 = styledHeading and Theme.TextPrimary or Theme.TextMuted, Size = UDim2.new(1, 0, 0, styledHeading and 22 or 18), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = frame }) end
        
        function Elements:AddToggle(options) local title = options.Title or "Toggle"; local default = options.Default or false; local callback = options.Callback or function() end; local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = frame}); local box = Create("Frame", {Size = UDim2.fromOffset(16, 16), Position = UDim2.new(0, 0, 0.5, -8), BackgroundColor3 = Theme.CardBG, Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = box}); Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Parent = box}); local fill = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.AccentSingle, Transparency = default and 0 or 1, Parent = box}); Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = fill}); local check = Create("TextLabel", {Text = "✓", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Theme.White, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, TextTransparency = default and 0 or 1, Parent = fill}); Create("TextLabel", {Text = title, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.TextPrimary, Size = UDim2.new(1, -26, 1, 0), Position = UDim2.fromOffset(26, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = row}); local btn = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", Parent = row}); local state = default; btn.MouseButton1Click:Connect(function() state = not state; TweenService:Create(fill, TweenInfo.new(0.15), {Transparency = state and 0 or 1}):Play(); TweenService:Create(check, TweenInfo.new(0.15), {TextTransparency = state and 0 or 1}):Play(); callback(state) end); return { Set = function(newState) state = newState; fill.Transparency = state and 0 or 1; check.TextTransparency = state and 0 or 1; callback(state) end } end
        
        function Elements:AddButton(options) local text = options.Title or "Button"; local callback = options.Callback or function() end; local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Parent = frame}); local btn = Create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.CardBG, Text = text, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.AccentSingle, Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn}); local glowStroke = Create("UIStroke", {Thickness = 1, Color = Theme.Stroke, Parent = btn}); local hoverGradient = Create("UIGradient", {Color = ColorSequence.new(Theme.GlowGradient), Visible = false, Parent = glowStroke}); btn.MouseEnter:Connect(function() glowStroke.Color = Color3.new(1,1,1); hoverGradient.Visible = true; glowStroke.Thickness = 2; btn.TextColor3 = Theme.White end); btn.MouseLeave:Connect(function() glowStroke.Color = Theme.Stroke; hoverGradient.Visible = false; glowStroke.Thickness = 1; btn.TextColor3 = Theme.AccentSingle end); btn.MouseButton1Click:Connect(callback) end
        
        function Elements:AddDropdown(options) local title = options.Title or "Dropdown"; local values = options.Values or {}; local default = options.Default or 1; local callback = options.Callback or function() end; local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = frame}); Create("TextLabel", {Text = title, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.TextMuted, Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = row}); local btn = Create("TextButton", {Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, 16), BackgroundColor3 = Theme.CardBG, Text = values[default] or "Select...", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left, Padding = UDim.new(0, 8), Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = btn}); Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Parent = btn}); Create("TextLabel", {Text = "▼", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Theme.TextMuted, Size = UDim2.fromOffset(20, 20), Position = UDim2.new(1, -20, 0.5, -10), BackgroundTransparency = 1, Parent = btn}); btn.MouseButton1Click:Connect(function() print("Dropdown clicked") end) end
        
        return Elements
    end

    -- [ A U T O   I N J E C T   'M I S C'   T A B ]
    task.spawn(function()
        local MiscTab = WindowObj:AddTab({Title = "Misc"})
        MiscTab:AddLabel("Utility & Settings", true)
        MiscTab:AddToggle({
            Title = "Window Transparency",
            Default = false,
            Callback = function(state)
                TweenService:Create(MainWindow, TweenInfo.new(0.3), {BackgroundTransparency = state and 0.35 or 0}):Play()
            end
        })
        MiscTab:AddButton({
            Title = "Join Discord",
            Callback = function()
                if setclipboard then
                    setclipboard("https://discord.gg/yourlink")
                    print("Discord link copied to clipboard!")
                end
            end
        })
    end)

    return WindowObj
end

return NeonFlow
