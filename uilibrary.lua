-- ============================================================
-- NEONFLOW LIBRARY - ULTRA HIGH-END MODULAR ENGINE
-- Added: Side-by-Side Components & Exposed Container
-- ============================================================
local NeonFlow = {}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = {
    MainBG = Color3.fromRGB(10, 10, 10), CardBG = Color3.fromRGB(18, 18, 18),
    ItemBG = Color3.fromRGB(25, 25, 25), TopBarBG = Color3.fromRGB(15, 15, 15),
    Stroke = Color3.fromRGB(45, 45, 45), TextPrimary = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(170, 100, 255), AccentSingle = Color3.fromRGB(150, 20, 220),
    GlowGradient = {ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 0, 180))}
}

local function Create(cls, props) local inst = Instance.new(cls); for k, v in pairs(props) do inst[k] = v end return inst end
local function AnimateGlow(gradient) TweenService:Create(gradient, TweenInfo.new(3.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360}):Play() end

function NeonFlow:CreateWindow(options)
    local title = options.Title or "NeonFlow UI"
    local size = options.Size or UDim2.fromOffset(580, 460)

    local ScreenGui = Create("ScreenGui", { Name = "NeonFlow_Engine", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = gethui and gethui() or CoreGui

    local MainWindow = Create("Frame", {Name = "MainWindow", Size = size, Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2), BackgroundColor3 = Theme.MainBG, Active = true, Parent = ScreenGui}); Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = MainWindow})
    local GlowStroke = Create("UIStroke", {Color = Color3.new(1,1,1), Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = MainWindow })
    local GlowGradient = Create("UIGradient", {Color = ColorSequence.new(Theme.GlowGradient), Rotation = 0, Parent = GlowStroke}); AnimateGlow(GlowGradient)

    local TopBar = Create("Frame", { Name = "TopBar", Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Theme.TopBarBG, Parent = MainWindow }); Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TopBar})
    Create("Frame", {Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0,0,1,-10), BackgroundColor3 = Theme.TopBarBG, BorderSizePixel = 0, Parent = TopBar}); Create("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0,0,1,0), BackgroundColor3 = Theme.Stroke, BorderSizePixel = 0, Parent = TopBar}) 

    local dragToggle, dragStart, startPos
    MainWindow.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = true; dragStart = input.Position; startPos = MainWindow.Position end end)
    UserInputService.InputChanged:Connect(function(input) if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end end)

    local TitleContainer = Create("Frame", { Name = "TitleSection", Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.fromOffset(15, 0), BackgroundTransparency = 1, Parent = TopBar }); Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6), Parent = TitleContainer})
    Create("TextLabel", { Text = title, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.TextPrimary, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Parent = TitleContainer })

    local WindowOpts = Create("Frame", { Name = "WindowOpt", Size = UDim2.fromOffset(60, 30), Position = UDim2.new(1, -65, 0.5, -15), BackgroundTransparency = 1, Parent = TopBar }); Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 10), Parent = WindowOpts}); Create("UIPadding", {PaddingRight = UDim.new(0, 12), Parent = WindowOpts})
    local MinBtn = Create("TextButton", { Text = "—", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.TextPrimary, Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, Parent = WindowOpts })
    local CloseBtn = Create("TextButton", { Text = "X", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.TextPrimary, Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, Parent = WindowOpts })
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    local MinimizeBubble = Create("TextButton", { Name = "MinimizeBubble", Size = UDim2.fromOffset(46, 46), Position = UDim2.new(1, -60, 0.5, -23), BackgroundColor3 = Theme.MainBG, Text = "KNTL", Font = Enum.Font.GothamBold, TextSize = 20, Visible = false, Parent = ScreenGui })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = MinimizeBubble}); local BubbleStroke = Create("UIStroke", {Color = Color3.new(1,1,1), Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = MinimizeBubble}); local BubbleGrad = Create("UIGradient", {Color = ColorSequence.new(Theme.GlowGradient), Rotation = 0, Parent = BubbleStroke}); AnimateGlow(BubbleGrad)

    local bDragToggle, bDragStart, bStartPos
    MinimizeBubble.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then bDragToggle = true; bDragStart = input.Position; bStartPos = MinimizeBubble.Position end end)
    UserInputService.InputChanged:Connect(function(input) if bDragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - bDragStart; MinimizeBubble.Position = UDim2.new(bStartPos.X.Scale, bStartPos.X.Offset + delta.X, bStartPos.Y.Scale, bStartPos.Y.Offset + delta.Y) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then bDragToggle = false end end)

    local lastClick = 0
    MinimizeBubble.MouseButton1Click:Connect(function() local currentTick = tick(); if currentTick - lastClick < 0.4 then MinimizeBubble.Visible = false; MainWindow.Visible = true end; lastClick = currentTick end)
    MinBtn.MouseButton1Click:Connect(function() MainWindow.Visible = false; MinimizeBubble.Visible = true end)

    local TabBar = Create("Frame", { Name = "TabBar", Size = UDim2.new(1, -20, 0, 35), Position = UDim2.fromOffset(10, 40), BackgroundTransparency = 1, Parent = MainWindow }); Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 8), Parent = TabBar})
    Create("Frame", { Name = "Separator", Size = UDim2.new(1, -20, 0, 1), Position = UDim2.new(0, 10, 0, 80), BackgroundColor3 = Theme.Stroke, BorderSizePixel = 0, Parent = MainWindow })
    local TabContainer = Create("Frame", { Name = "TabContainer", Size = UDim2.new(1, -20, 1, -125), Position = UDim2.fromOffset(10, 95), BackgroundTransparency = 1, ClipsDescendants = true, Parent = MainWindow })

    local WindowObj = { Tabs = {}, ActiveTab = nil, Container = TabContainer, GUI = ScreenGui }

    function WindowObj:AddTab(tabOptions)
        local tabName = tabOptions.Title or "Tab"
        local isDefault = #self.Tabs == 0

        local navBtn = Create("TextButton", { Name = "NavBtn_" .. tabName, Size = UDim2.fromOffset(0, 26), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = isDefault and Theme.AccentSingle or Theme.ItemBG, Text = "   " .. tabName .. "   ", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Theme.TextPrimary, Parent = TabBar })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = navBtn}); local btnStroke = Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Transparency = isDefault and 1 or 0, Parent = navBtn})
        local frame = Create("ScrollingFrame", { Name = "TabFrame_" .. tabName, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 0, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = isDefault, ClipsDescendants = false, Parent = TabContainer })
        Create("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame}); Create("UIPadding", {PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 10), Parent = frame})

        local tabObj = { btn = navBtn, frame = frame, idx = #self.Tabs, stroke = btnStroke }
        table.insert(self.Tabs, tabObj)

        navBtn.MouseButton1Click:Connect(function()
            for _, t in ipairs(self.Tabs) do 
                local isActive = (t == tabObj); t.frame.Visible = isActive; t.btn.BackgroundColor3 = isActive and Theme.AccentSingle or Theme.ItemBG; t.stroke.Transparency = isActive and 1 or 0
            end
        end)

        local Elements = {}
        Elements.Container = frame -- BUKA AKSES FRAME BUAT CUSTOM INJECT
        
        function Elements:AddLabel(text, styledHeading) Create("TextLabel", { Text = text, Font = styledHeading and Enum.Font.GothamBold or Enum.Font.Gotham, TextSize = styledHeading and 15 or 12, TextColor3 = styledHeading and Theme.TextPrimary or Theme.TextMuted, Size = UDim2.new(1, 0, 0, styledHeading and 22 or 18), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = frame }) end
        function Elements:AddToggle(options) local title = options.Title or "Toggle"; local default = options.Default or false; local callback = options.Callback or function() end; local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = frame}); local box = Create("Frame", {Size = UDim2.fromOffset(16, 16), Position = UDim2.new(0, 0, 0.5, -8), BackgroundColor3 = Theme.CardBG, Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = box}); Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = box}); local fill = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.AccentSingle, Transparency = default and 0 or 1, Parent = box}); Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = fill}); local check = Create("TextLabel", {Text = "✓", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Theme.White, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, TextTransparency = default and 0 or 1, Parent = fill}); Create("TextLabel", {Text = title, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.TextPrimary, Size = UDim2.new(1, -26, 1, 0), Position = UDim2.fromOffset(26, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = row}); local btn = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", Parent = row}); local state = default; btn.MouseButton1Click:Connect(function() state = not state; TweenService:Create(fill, TweenInfo.new(0.15), {Transparency = state and 0 or 1}):Play(); TweenService:Create(check, TweenInfo.new(0.15), {TextTransparency = state and 0 or 1}):Play(); callback(state) end); return { Set = function(newState) state = newState; fill.Transparency = state and 0 or 1; check.TextTransparency = state and 0 or 1; callback(state) end } end
        function Elements:AddButton(options) local text = options.Title or "Button"; local callback = options.Callback or function() end; local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Parent = frame}); local btn = Create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.CardBG, Text = text, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.AccentSingle, Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn}); local glowStroke = Create("UIStroke", {Thickness = 1, Color = Theme.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = btn}); local hoverGradient = Create("UIGradient", {Color = ColorSequence.new(Theme.GlowGradient), Visible = false, Parent = glowStroke}); btn.MouseEnter:Connect(function() glowStroke.Color = Color3.new(1,1,1); hoverGradient.Visible = true; glowStroke.Thickness = 2; btn.TextColor3 = Theme.White end); btn.MouseLeave:Connect(function() glowStroke.Color = Theme.Stroke; hoverGradient.Visible = false; glowStroke.Thickness = 1; btn.TextColor3 = Theme.AccentSingle end); btn.MouseButton1Click:Connect(callback) end
        
        function Elements:AddNumberCounter(options)
            local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Parent = frame})
            Create("TextLabel", {Text = options.Title, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.TextPrimary, Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = row})
            local minBtn = Create("TextButton", {Text = "−", Font = Enum.Font.GothamBold, TextSize = 14, BackgroundColor3 = Theme.CardBG, TextColor3 = Theme.TextPrimary, Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, -80, 0.5, -13), Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = minBtn}); Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = minBtn})
            local valLbl = Create("TextLabel", {Text = tostring(options.Default), Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.AccentSingle, Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, -50, 0.5, -13), BackgroundTransparency = 1, Parent = row})
            local addBtn = Create("TextButton", {Text = "+", Font = Enum.Font.GothamBold, TextSize = 14, BackgroundColor3 = Theme.CardBG, TextColor3 = Theme.TextPrimary, Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, -20, 0.5, -13), Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = addBtn}); Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = addBtn})
            local state = options.Default
            minBtn.MouseButton1Click:Connect(function() if state > options.Min then state -= 1; valLbl.Text = tostring(state); options.Callback(state) end end)
            addBtn.MouseButton1Click:Connect(function() if state < options.Max then state += 1; valLbl.Text = tostring(state); options.Callback(state) end end)
            return { UpdateVisibility = function(vis) row.Visible = vis end }
        end

        function Elements:AddDropdown(options)
            local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = frame})
            Create("TextLabel", {Text = options.Title, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.TextMuted, Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = row})
            local btn = Create("TextButton", {Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, 16), BackgroundColor3 = Theme.CardBG, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left, Padding = UDim.new(0, 8), Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = btn}); Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = btn})
            Create("TextLabel", {Text = "▼", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Theme.TextMuted, Size = UDim2.fromOffset(20, 20), Position = UDim2.new(1, -20, 0.5, -10), BackgroundTransparency = 1, Parent = btn})
            local dropHeight = math.min(#options.Values * 24, 150)
            local dropFrame = Create("ScrollingFrame", { Size = UDim2.fromOffset(0, dropHeight), CanvasSize = UDim2.new(0, 0, 0, #options.Values * 24), BackgroundColor3 = Theme.ItemBG, ScrollBarThickness = 2, ZIndex = 100, Visible = false, Parent = MainWindow }); Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = dropFrame}); Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = dropFrame}); Create("UIListLayout", {Padding = UDim.new(0, 0), Parent = dropFrame})
            
            local function UpdateVis(idx) local opt = options.Values[idx]; btn.Text = opt and (type(opt) == "table" and opt.name or opt) or "Select..." end
            UpdateVis(options.Default or 1)

            for i, opt in ipairs(options.Values) do
                local optBtn = Create("TextButton", {Text = "  " .. (type(opt) == "table" and opt.name or opt), Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, ZIndex = 101, Parent = dropFrame})
                optBtn.MouseButton1Click:Connect(function() UpdateVis(i); dropFrame.Visible = false; options.Callback(type(opt) == "table" and opt.id or opt) end)
            end
            btn.MouseButton1Click:Connect(function() if dropFrame.Visible then dropFrame.Visible = false return end; dropFrame.Size = UDim2.fromOffset(btn.AbsoluteSize.X, dropHeight); dropFrame.Position = UDim2.fromOffset(btn.AbsolutePosition.X - MainWindow.AbsolutePosition.X, (btn.AbsolutePosition.Y - MainWindow.AbsolutePosition.Y) + btn.AbsoluteSize.Y + 2); dropFrame.Visible = true end)
        end

        function Elements:AddSegmentedControl(options)
            local opt1, opt2 = options.Option1, options.Option2
            local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Parent = frame})
            local cont = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.CardBG, Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = cont}); Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = cont})
            local btn1 = Create("TextButton", {Text = opt1, Font = Enum.Font.GothamBold, TextSize = 12, Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1, ZIndex=2, Parent = cont})
            local btn2 = Create("TextButton", {Text = opt2, Font = Enum.Font.GothamBold, TextSize = 12, Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), BackgroundTransparency = 1, ZIndex=2, Parent = cont})
            local fill = Create("Frame", {Size = UDim2.new(0.5, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Theme.AccentSingle, ZIndex = 1, Parent = cont}); Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = fill})
            local function updateVis(val) local isOpt1 = (val == opt1); btn1.TextColor3 = isOpt1 and Theme.White or Theme.TextMuted; btn2.TextColor3 = not isOpt1 and Theme.White or Theme.TextMuted; TweenService:Create(fill, TweenInfo.new(0.2), {Position = isOpt1 and UDim2.new(0, 2, 0, 2) or UDim2.new(0.5, 2, 0, 2)}):Play() end
            updateVis(options.Default or opt1)
            btn1.MouseButton1Click:Connect(function() options.Callback(opt1); updateVis(opt1) end)
            btn2.MouseButton1Click:Connect(function() options.Callback(opt2); updateVis(opt2) end)
        end

        function Elements:AddDualToggle(options)
            local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = frame})
            local function createHalf(opt, xPos)
                local half = Create("Frame", {Size = UDim2.new(0.5, 0, 1, 0), Position = xPos, BackgroundTransparency = 1, Parent = row})
                local box = Create("Frame", {Size = UDim2.fromOffset(16, 16), Position = UDim2.new(0, 0, 0.5, -8), BackgroundColor3 = Theme.CardBG, Parent = half}); Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = box}); Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Parent = box})
                local fill = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.AccentSingle, Transparency = opt.Default and 0 or 1, Parent = box}); Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = fill})
                local check = Create("TextLabel", {Text = "✓", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Theme.White, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, TextTransparency = opt.Default and 0 or 1, Parent = fill})
                Create("TextLabel", {Text = opt.Title, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.TextPrimary, Size = UDim2.new(1, -26, 1, 0), Position = UDim2.fromOffset(26, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = half})
                local btn = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", Parent = half})
                local state = opt.Default
                btn.MouseButton1Click:Connect(function() state = not state; TweenService:Create(fill, TweenInfo.new(0.15), {Transparency = state and 0 or 1}):Play(); TweenService:Create(check, TweenInfo.new(0.15), {TextTransparency = state and 0 or 1}):Play(); opt.Callback(state) end)
            end
            createHalf(options.Toggle1, UDim2.new(0, 0, 0, 0)); createHalf(options.Toggle2, UDim2.new(0.5, 0, 0, 0))
        end

        function Elements:AddDualButton(options)
            local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Parent = frame})
            local btn1 = Create("TextButton", {Size = UDim2.new(0.48, 0, 1, 0), BackgroundColor3 = options.Button1.Color, Text = options.Button1.Title, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.White, Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn1}); Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = btn1}); btn1.MouseButton1Click:Connect(options.Button1.Callback)
            local btn2 = Create("TextButton", {Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0.52, 0, 0, 0), BackgroundColor3 = options.Button2.Color, Text = options.Button2.Title, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.White, Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn2}); Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = btn2}); btn2.MouseButton1Click:Connect(options.Button2.Callback)
        end

        function Elements:AddSearchRow(options)
            local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Parent = frame})
            local box = Create("TextBox", {Size = UDim2.new(0.55, -4, 1, 0), BackgroundColor3 = Theme.CardBG, Text = "", PlaceholderText = " Search ore...", Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left, Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = box}); Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = box})
            local selBtn = Create("TextButton", {Text = "Sel All", Font = Enum.Font.GothamBold, TextSize = 10, Size = UDim2.new(0.2, 0, 1, 0), Position = UDim2.new(0.55, 4, 0, 0), BackgroundColor3 = Theme.CardBG, TextColor3 = Theme.White, Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = selBtn}); Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = selBtn})
            local deselBtn = Create("TextButton", {Text = "Desel", Font = Enum.Font.GothamBold, TextSize = 10, Size = UDim2.new(0.2, 0, 1, 0), Position = UDim2.new(0.75, 8, 0, 0), BackgroundColor3 = Theme.CardBG, TextColor3 = Theme.White, Parent = row}); Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = deselBtn}); Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = deselBtn})
            box:GetPropertyChangedSignal("Text"):Connect(function() options.OnSearch(box.Text) end)
            selBtn.MouseButton1Click:Connect(options.OnSelectAll); deselBtn.MouseButton1Click:Connect(options.OnDeselectAll)
        end
        
        return Elements
    end

    return WindowObj
end

return NeonFlow
