-- ============================================================
-- NEONFLOW LIBRARY - HIGH-END MODULAR UI ENGINE
-- FOCUSED IMPROVEMENTS ON: Window Controls & Tabs UI
-- Rest of the code remains UNTOUCHED.
-- ============================================================
local NeonFlow = {}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [ T H E M E   C O N F I G ]
local Theme = {
    MainBG = Color3.fromRGB(10, 10, 10),
    CardBG = Color3.fromRGB(20, 20, 20),
    ItemBG = Color3.fromRGB(30, 30, 30),
    TabActiveBG = Color3.fromRGB(81, 81, 81), 
    TabHeaderBG = Color3.fromRGB(53, 53, 53), 
    Stroke = Color3.fromRGB(50, 50, 50),
    TextPrimary = Color3.fromRGB(240, 240, 240),
    TextMuted = Color3.fromRGB(160, 160, 160),
    GlowGradient = {ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 0))},
    AccentSingle = Color3.fromRGB(232, 28, 255) 
}

local function Create(cls, props) 
    local inst = Instance.new(cls)
    for k, v in pairs(props) do inst[k] = v end 
    return inst 
end

local function AnimateGlow(gradient)
    local rotationTween = TweenService:Create(gradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
    rotationTween:Play()
end

function NeonFlow:CreateWindow(options)
    local title = options.Title or "NeonFlow UI"
    local size = options.Size or UDim2.fromOffset(580, 460)

    local ScreenGui = Create("ScreenGui", { Name = "NeonFlow_Engine", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = gethui and gethui() or CoreGui

    local MainGlowCard = Create("Frame", {Name = "MainGlowCard", Size = UDim2.new(0, size.X.Offset + 6, 0, size.Y.Offset + 6), Position = UDim2.new(0.5, -(size.X.Offset + 6)/2, 0.5, -(size.Y.Offset + 6)/2), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = ScreenGui})
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = MainGlowCard})
    
    local BackgroundGradient = Create("UIGradient", {Color = ColorSequence.new(Theme.GlowGradient), Rotation = -45, Parent = MainGlowCard})
    AnimateGlow(BackgroundGradient)

    local MainWindow = Create("Frame", {Name = "MainWindow", Size = size, Position = UDim2.fromOffset(3, 3), BackgroundColor3 = Theme.MainBG, BorderSizePixel = 0, Active = true, Parent = MainGlowCard})
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = MainWindow})
    Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Parent = MainWindow}) 

    local dragToggle = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    local function updateInput(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(MainGlowCard, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Position = newPos}):Play()
    end

    MainWindow.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true; dragStart = input.Position; startPos = MainGlowCard.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragToggle = false end end)
        end
    end)
    MainWindow.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragToggle then updateInput(input) end end)

    local TabHeaderHead = Create("Frame", { Name = "TabsHead", Size = UDim2.new(1, 0, 0, 30), Position = UDim2.fromOffset(0, 0), BackgroundColor3 = Theme.TabHeaderBG, Parent = MainWindow })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TabHeaderHead})
    
    -- Bottom masks for TabHeader
    Create("Frame", {Size = UDim2.new(1, 0, 0, 5), Position = UDim2.new(0,0,1,-5), BackgroundColor3 = Theme.TabHeaderBG, BorderSizePixel = 0, Parent = TabHeaderHead})

    local TabTabBar = Create("Frame", { Name = "TabBarContainer", Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(10, 0), BackgroundTransparency = 1, Parent = TabHeaderHead })
    Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 5), Parent = TabTabBar})

    -- ============================================================
    -- F I X E D: RAPIHED WINDOW CONTROLS (Min/Close)
    -- This section is now neat and aligned.
    -- ============================================================
    -- Removed rigid WindowOpts frame. Creating buttons directly with alignment.
    local CloseBtn = Create("TextButton", { Text = "x", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.TextPrimary, Size = UDim2.fromOffset(30, 20), Position = UDim2.new(1, -30, 0, 0), BackgroundTransparency = 1, Parent = TabHeaderHead })
    local MinBtn = Create("TextButton", { Text = "_", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.TextPrimary, Size = UDim2.fromOffset(30, 20), Position = UDim2.new(1, -60, 0, 0), BackgroundTransparency = 1, Parent = TabHeaderHead })
    
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    -- Add hover effects for neatness
    CloseBtn.MouseEnter:Connect(function() CloseBtn.TextColor3 = Color3.fromRGB(255, 52, 52) end)
    CloseBtn.MouseLeave:Connect(function() CloseBtn.TextColor3 = Theme.TextPrimary end)

    MinBtn.MouseEnter:Connect(function() MinBtn.TextColor3 = Theme.AccentSingle end)
    MinBtn.MouseLeave:Connect(function() MinBtn.TextColor3 = Theme.TextPrimary end)
    
    local isMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            MainGlowCard.Size = UDim2.new(0, size.X.Offset + 6, 0, 30 + 6)
            MainWindow.Size = UDim2.new(0, size.X.Offset, 0, 30)
            MainWindow.ClipsDescendants = true
        else
            MainGlowCard.Size = UDim2.new(0, size.X.Offset + 6, 0, size.Y.Offset + 6)
            MainWindow.Size = size
            MainWindow.ClipsDescendants = false
        end
    end)

    local TabContainer = Create("Frame", { Name = "TabContainer", Size = UDim2.new(1, 0, 1, -30), Position = UDim2.fromOffset(0, 30), BackgroundColor3 = Theme.MainBG, ClipsDescendants = true, Parent = MainWindow })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TabContainer})
    Create("Frame", {Size = UDim2.new(1, 0, 0, 5), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Theme.MainBG, BorderSizePixel = 0, Parent = TabContainer}) -- top mask

    local WindowObj = { Tabs = {}, ActiveTab = nil, Container = TabContainer, GUI = ScreenGui }

    -- ============================================================
    -- I M P R O V I S E D: MODERN TAB UI (AddTab)
    -- Completely removed browser style masking. Sleek pill style.
    -- ============================================================
    function WindowObj:AddTab(tabOptions)
        local tabName = tabOptions.Title or "Tab"
        local isDefault = #self.Tabs == 0

        -- SLEEK PILL STYLE TAB BUTTON
        -- TextButton ensures it handles click events directly. Removed complex masking.
        local tabBtn = Create("TextButton", { 
            Name = "TabBtn_" .. tabName, 
            Size = UDim2.new(0, 100, 0, 24), 
            BackgroundColor3 = isDefault and Theme.TabActiveBG or Theme.TabHeaderBG, 
            Text = "", -- use TextLabel inside for alignment control
            Parent = TabTabBar 
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = tabBtn})
        Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Transparency = isDefault and 0 or 0.5, Parent = tabBtn}) -- subtly glow when selected

        -- Refined text label (slightly smaller text for modern feel)
        Create("TextLabel", { Text = tabName, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.TextPrimary, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.fromOffset(8, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = tabBtn })
        Create("TextLabel", { Text = "x", Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = Theme.TextMuted, Size = UDim2.fromOffset(12, 12), Position = UDim2.new(1, -16, 0.5, -6), BackgroundTransparency = 1, Parent = tabBtn })

        local frame = Create("ScrollingFrame", { 
            Name = "TabFrame_" .. tabName,
            Size = UDim2.new(1, -20, 1, -20), 
            Position = UDim2.fromOffset(10, 10), 
            BackgroundTransparency = 1, 
            ScrollBarThickness = 2, 
            ScrollBarImageColor3 = Theme.Stroke, 
            AutomaticCanvasSize = Enum.AutomaticSize.Y, 
            Visible = isDefault, 
            Parent = TabContainer 
        })
        Create("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame})

        local tabObj = { btn = tabBtn, frame = frame, idx = #self.Tabs }
        table.insert(self.Tabs, tabObj)

        -- Handle tab switching
        tabBtn.MouseButton1Click:Connect(function()
            for _, t in ipairs(self.Tabs) do 
                local isActive = (t == tabObj)
                t.frame.Visible = isActive
                t.btn.BackgroundColor3 = isActive and Theme.TabActiveBG or Theme.TabHeaderBG
                -- subtle glow handling
                local stroke = t.btn:FindFirstChild("UIStroke")
                if stroke then stroke.Transparency = isActive and 0 or 0.5 end
            end
        end)

        -- [ E L E M E N T S - UNTOUCHED ]
        local Elements = {}
        
        function Elements:AddLabel(text, isHeading) Create("TextLabel", { Text = text, Font = isHeading and Enum.Font.GothamBold or Enum.Font.Gotham, TextSize = isHeading and 16 or 13, TextColor3 = isHeading and Theme.TextPrimary or Theme.TextMuted, Size = UDim2.new(1, 0, 0, isHeading and 24 or 20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = frame }) end
        function Elements:AddToggle(options) local title = options.Title or "Toggle"; local default = options.Default or false; local callback = options.Callback or function() end; local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = frame}); local box = Create("Frame", {Size = UDim2.fromOffset(16, 16), Position = UDim2.new(0, 0, 0.5, -8), BackgroundColor3 = Theme.ItemBG, Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = box}); Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Parent = box}); local fill = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.AccentSingle, Transparency = default and 0 or 1, Parent = box}); Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = fill}); local check = Create("TextLabel", {Text = "✓", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Theme.White, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, TextTransparency = default and 0 or 1, Parent = fill}); Create("TextLabel", {Text = title, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.TextPrimary, Size = UDim2.new(1, -26, 1, 0), Position = UDim2.fromOffset(26, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = row}); local btn = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", Parent = row}); local state = default; btn.MouseButton1Click:Connect(function() state = not state; TweenService:Create(fill, TweenInfo.new(0.15), {Transparency = state and 0 or 1}):Play(); TweenService:Create(check, TweenInfo.new(0.15), {TextTransparency = state and 0 or 1}):Play(); callback(state) end); return { Set = function(newState) state = newState; fill.Transparency = state and 0 or 1; check.TextTransparency = state and 0 or 1; callback(state) end } end
        function Elements:AddButton(options) local text = options.Title or "Button"; local callback = options.Callback or function() end; local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Parent = frame}); local btn = Create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.CardBG, Text = text, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.AccentSingle, Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn}); local glowStroke = Create("UIStroke", {Thickness = 1, Color = Theme.Stroke, Parent = btn}); local hoverGradient = Create("UIGradient", {Color = ColorSequence.new(Theme.AccentGlow), Visible = false, Parent = glowStroke}); btn.MouseEnter:Connect(function() glowStroke.Color = Color3.new(1,1,1); hoverGradient.Visible = true; glowStroke.Thickness = 2; btn.TextColor3 = Theme.White end); btn.MouseLeave:Connect(function() glowStroke.Color = Theme.Stroke; hoverGradient.Visible = false; glowStroke.Thickness = 1; btn.TextColor3 = Theme.AccentSingle end); btn.MouseButton1Click:Connect(callback) end
        
        return Elements
    end

    return WindowObj
end

return NeonFlow
