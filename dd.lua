--!nonstrict
--[[
    scoot ui library
    made by samet
    https://discord.gg/VhvTd5HV8d

    example/documentation is at the bottom
]]

--[[
    LPH OPTIMIZATION MACROS & DOCUMENTATION
    Source: https://docs.luarmor.net/insane-optimization-tricks-and-lph-macro-usage
    
    This library uses LPH_NO_VIRTUALIZE for performance-critical sections:
    - RenderStepped/Heartbeat connections
    - __index/__namecall hooks
    - Functions called 30+ times per second
    - While true loops with no delay
    - GC scan loops
    
    DO NOT wrap entire script in LPH_NO_VIRTUALIZE - only use on
    performance-critical code to avoid defeating obfuscation.
    
    Always initialize LPH macros at script start for compatibility.
]]

-- Safe unload check - only unload if Library is fully initialized
if getgenv().UnloadAlternate then
    pcall(getgenv().UnloadAlternate)
elseif getgenv().Library and getgenv().Library.Unload then
    pcall(getgenv().Library.Unload, getgenv().Library)
end

-- Declare globals for compiler
local env = getgenv()
local LPH_OBFUSCATED = env.LPH_OBFUSCATED or false
if not LPH_OBFUSCATED then
    env["LPH_NO_" .. "VIRTUALIZE"] = function(f) return f end
    env["LPH_J" .. "IT"] = function(f) return f end
    env["LPH_J" .. "IT_MAX"] = function(f) return f end
end

local LPH_NO_VIRTUALIZE = env.LPH_NO_VIRTUALIZE
local LPH_JIT = env.LPH_JIT
local LPH_JIT_MAX = env.LPH_JIT_MAX

local LoadTick = os.clock()

local Library do
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new
    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local Vector2New = Vector2.new

    local MathClamp = math.clamp
    local MathFloor = math.floor
    local MathAbs = math.abs
    local MathSin = math.sin

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower
    local StringLen = string.len

    local InstanceNew = Instance.new

    local RectNew = Rect.new

    Library = {
        Theme =  { },

        MenuKeybind = tostring(Enum.KeyCode.RightControl), 
        Flags = { },

        Tween = {
            Time = 0.3,
            Style = Enum.EasingStyle.Exponential,
            Direction = Enum.EasingDirection.Out
        },

        FadeSpeed = 0.2,

        Folders = {
            Directory = "alternate",
            Configs = "alternate/Configs",
            Assets = "alternate/Assets",
            Themes = "alternate/Themes",
        },

        Images = {
            ["Saturation"] = {"Saturation.png", "https://github.com/sametexe001/images/blob/main/saturation.png?raw=true" },
            ["Value"] = { "Value.png", "https://github.com/sametexe001/images/blob/main/value.png?raw=true" },
            ["Hue"] = { "Hue.png", "https://github.com/sametexe001/images/blob/main/horizontalhue.png?raw=true" },
            ["Checkers"] = { "Checkers.png", "https://github.com/sametexe001/images/blob/main/checkers.png?raw=true" },
        },

        -- Ignore below
        Pages = { },
        Sections = { },

        Connections = { },
        Threads = { },

        ThemeMap = { },
        ThemeItems = { },

        CopiedColor = nil,

        OpenFrames = { },

        CurrentPage = nil,

        SearchItems = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,
        Font = nil,
        KeyList = nil,

        Colorpickers = { },
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    local SpecialCharacters = {
        "[",
        "]",
        "(",
        ")",
        "{",
        "}",
        "!",
        "@",
        "#",
        "$",
        "%",
        "^",
        "&",
        "*",
        "+",
        "="
    }

    local Themes = {
        ["Preset"] = {
            ["Background"] = FromRGB(18, 18, 18),
            ["Border"] = FromRGB(30, 30, 30),
            ["Inline"] = FromRGB(22, 22, 22),
            ["Hovered Element"] = FromRGB(28, 28, 28),
            ["Page Background"] = FromRGB(16, 16, 16),
            ["Outline"] = FromRGB(40, 40, 40),
            ["Element"] = FromRGB(24, 24, 24),
            ["Gradient"] = FromRGB(255, 255, 255),
            ["Text"] = FromRGB(240, 240, 240),
            ["Text Stroke"] = FromRGB(0, 0, 0),
            ["Placeholder Text"] = FromRGB(150, 150, 150),
            ["Accent"] = FromRGB(210, 180, 80)
        }
    }

    Library.Theme = TableClone(Themes["Preset"])

    -- Folders
    for Index, Value in Library.Folders do 
        if not isfolder(Value) then
            makefolder(Value)
        end
    end

    -- Images
    for Index, Value in Library.Images do 
        local ImageData = Value

        local ImageName = ImageData[1]
        local ImageLink = ImageData[2]
        
        if not isfile(Library.Folders.Assets .. "/" .. ImageName) then
            writefile(Library.Folders.Assets .. "/" .. ImageName, game:HttpGet(ImageLink))
        end
    end

    -- Tweening
    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            local tweenTime = (Library and Library.Tween and Library.Tween.Time) or 0.2
            local tweenStyle = (Library and Library.Tween and Library.Tween.Style) or Enum.EasingStyle.Quad
            local tweenDirection = (Library and Library.Tween and Library.Tween.Direction) or Enum.EasingDirection.Out
            Info = Info or TweenInfo.new(tweenTime, tweenStyle, tweenDirection)

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()

            setmetatable(NewTween, Tween)

            return NewTween
        end

        Tween.GetProperty = function(self, Item)
            Item = Item or self.Item 

            if Item:IsA("Frame") then
                return { "BackgroundTransparency" }
            elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
                return { "BackgroundTransparency", "ImageTransparency" }
            elseif Item:IsA("ScrollingFrame") then
                return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif Item:IsA("TextBox") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("UIStroke") then 
                return { "Transparency" }
            end
        end

        Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
            local Item = Item or self.Item 

            local OldTransparency = Item[Property]
            Item[Property] = Visibility and 1 or OldTransparency

            local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
                [Property] = Visibility and OldTransparency or 1
            }, true)

            Library:Connect(NewTween.Tween.Completed, function()
                if not Visibility then 
                    task.wait()
                    Item[Property] = OldTransparency
                end
            end)

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then 
                return
            end

            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then 
                return
            end

            Tween:Pause()
            self = nil
        end
    end

    -- Instances
    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end

            return NewItem
        end

        Instances.FadeItem = function(self, Visibility, Speed)
            local Item = self.Instance

            if Visibility == true then 
                Item.Visible = true
            end

            local Descendants = Item:GetDescendants()
            TableInsert(Descendants, Item)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then 
                    continue
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, not Visibility, Speed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, not Visibility, Speed)
                end
            end
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance or not Library then 
                return
            end

            Library:AddToTheme(self, Properties)
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance or not Library then 
                return
            end

            Library:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance or not Library then 
                return
            end

            if not self.Instance[Event] then 
                return
            end

            return Library:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then 
                return
            end

            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then 
                return
            end

            return Library:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then 
                return
            end

            self.Instance:Destroy()
            self = nil
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Dragging = false 
            local DragStart
            local StartPosition 

            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                self:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)})
            end

            local InputChanged

            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true

                    DragStart = Input.Position
                    StartPosition = Gui.Position

                    if InputChanged then 
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Dragging = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, LPH_NO_VIRTUALIZE(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        Set(Input)
                    end
                end
            end))

            return Dragging
        end

        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Resizing = false 
            local Start = UDim2New()
            local Delta = UDim2New()
            local ResizeMax = Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

            local ResizeButton = Instances:Create("ImageButton", {
				Parent = Gui,
                Image = "rbxassetid://",
				AnchorPoint = Vector2New(1, 1),
				BorderColor3 = FromRGB(0, 0, 0),
				Size = UDim2New(0, 6, 0, 6),
				Position = UDim2New(1, -4, 1, -4),
                Name = "\0",
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
                ZIndex = 5,
				AutoButtonColor = false,
                Visible = true,
			})  ResizeButton:AddToTheme({ImageColor3 = "Accent"})

            local InputChanged

            ResizeButton:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then

                    Resizing = true

                    Start = Gui.Size - UDim2New(0, Input.Position.X, 0, Input.Position.Y)

                    if InputChanged then 
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Resizing = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, LPH_NO_VIRTUALIZE(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Resizing then
                        ResizeMax = Maximum or Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

                        Delta = Start + UDim2New(0, Input.Position.X, 0, Input.Position.Y)
                        Delta = UDim2New(0, math.clamp(Delta.X.Offset, Minimum.X, ResizeMax.X), 0, math.clamp(Delta.Y.Offset, Minimum.Y, ResizeMax.Y))

                        Tween:Create(Gui, TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = Delta}, true)
                    end
                end
            end))

            return Resizing
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseLeave, Function)
        end

        Instances.Border = function(self, Type)
            if not self.Instance then 
                return
            end

            local Color = Type == "Border" and Library.Theme.Border or Type == "Outline" and Library.Theme.Outline
        
            local UIStroke = Instances:Create("UIStroke", {
                Parent = self.Instance,
                Color = Color,
                Thickness = 1,
                LineJoinMode = Enum.LineJoinMode.Miter
            })  UIStroke:AddToTheme({Color = Type})

            return UIStroke
        end

        Instances.TextBorder = function(self)
            if not self.Instance then 
                return
            end

            local UIStroke = Instances:Create("UIStroke", {
                Parent = self.Instance,
                Color = Library.Theme["Text Stroke"],
                Thickness = 1,
                Transparency = 0.6,
                LineJoinMode = Enum.LineJoinMode.Miter
            })  UIStroke:AddToTheme({Color = "Text Stroke"})

            return UIStroke
        end

        Instances.Tooltip = function(self, Data)
            if not self.Instance then 
                return
            end

            if Data.Text == nil then 
                return
            end

            if type(Data.Text) ~= "string" then 
                return
            end

            local Gui = self.Instance

            local MouseLocation = UserInputService:GetMouseLocation()
            local RenderStepped

            local Items = { } do
                Items["Tooltip"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    Size = UDim2New(0, 0, 0, 25),
                    Position = UDim2New(0, Gui.AbsolutePosition.X, 0, Gui.AbsolutePosition.Y),
                    BorderColor3 = FromRGB(12, 12, 12),
                    BorderSizePixel = 2,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundTransparency = 1,
                    BackgroundColor3 = FromRGB(14, 17, 15)
                })  Items["Tooltip"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

                Items["UIStroke"] = Instances:Create("UIStroke", {
                    Parent = Items["Tooltip"].Instance,
                    Color = FromRGB(0, 0, 0),
                    Thickness = 1,
                    Transparency = 1,
                    LineJoinMode = Enum.LineJoinMode.Miter
                })  Items["UIStroke"]:AddToTheme({Color = "Outline"})

                Instances:Create("UIPadding", {
                    Parent = Items["Tooltip"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 5),
                    PaddingBottom = UDimNew(0, 6),
                    PaddingRight = UDimNew(0, 5),
                    PaddingLeft = UDimNew(0, 5)
                })

                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Tooltip"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(202, 243, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Text,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Title"]:AddToTheme({TextColor3 = "Accent"})

                Items["UIStroke2"] = Items["Title"]:TextBorder()
                Items["UIStroke2"].Instance.Transparency = 1

                Items["Description"] = Instances:Create("TextLabel", {
                    Parent = Items["Tooltip"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Description,
                    Position = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    TextTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Description"]:AddToTheme({TextColor3 = "Text"})

                Items["UIStroke3"] = Items["Description"]:TextBorder()
                Items["UIStroke3"].Instance.Transparency = 1
            end

            Library:Connect(Gui.MouseEnter, function()
                Items["Tooltip"].Instance.Position = UDim2New(0, MouseLocation.X + 8, 0, MouseLocation.Y - 32)
                Items["Tooltip"]:Tween(nil, {BackgroundTransparency = 0})
                Items["Title"]:Tween(nil, {TextTransparency = 0})
                Items["Description"]:Tween(nil, {TextTransparency = 0})
                Items["UIStroke"]:Tween(nil, {Transparency = 0})
                Items["UIStroke2"]:Tween(nil, {Transparency = 0})
                Items["UIStroke3"]:Tween(nil, {Transparency = 0})

                RenderStepped = Library:Connect(RunService.RenderStepped, LPH_NO_VIRTUALIZE(function()
                    MouseLocation = UserInputService:GetMouseLocation()
                    Items["Tooltip"].Instance.Position = UDim2New(0, MouseLocation.X + 8, 0, MouseLocation.Y - 35)
                end))
            end)

            Library:Connect(Gui.MouseLeave, function()
                Items["Tooltip"]:Tween(nil, {BackgroundTransparency = 1})
                Items["Title"]:Tween(nil, {TextTransparency = 1})
                Items["Description"]:Tween(nil, {TextTransparency = 1})
                Items["UIStroke"]:Tween(nil, {Transparency = 1})
                Items["UIStroke2"]:Tween(nil, {Transparency = 1})
                Items["UIStroke3"]:Tween(nil, {Transparency = 1})

                if RenderStepped then 
                    Library:Disconnect(RenderStepped.Name)
                    RenderStepped = nil
                end
            end)
        end
    end

    -- Custom font
    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end

            if not isfile(Library.Folders.Assets .. "/" .. Name .. ".ttf") then 
                writefile(Library.Folders.Assets .. "/" .. Name .. ".ttf", game:HttpGet(Data.Url))
            end

            local FontData = {
                name = Name,
                faces = { {
                    name = "Regular",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".ttf")
                } }
            }

            writefile(Library.Folders.Assets .. "/" .. Name .. ".json", HttpService:JSONEncode(FontData))
            return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
        end

        function CustomFont:Get(Name)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end
        end

        CustomFont:New("Monaco", 400, "Regular", {
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Monaco.ttf"
        })

        Library.Font = CustomFont:Get("Monaco")
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 2,
        ResetOnSpawn = false
    })

    Library.UnusedHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Enabled = false,
        ResetOnSpawn = false
    })

    Library.NotifHolder = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        AnchorPoint = Vector2New(0, 0),
        Position = UDim2New(0, 12, 0, 12),
        BackgroundTransparency = 1,
        Size = UDim2New(0, 0, 0, 0),
        BorderColor3 = FromRGB(0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })

    Instances:Create("UIListLayout", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDimNew(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    Instances:Create("UIPadding", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        PaddingTop = UDimNew(0, 4),
        PaddingBottom = UDimNew(0, 4),
        PaddingRight = UDimNew(0, 4),
        PaddingLeft = UDimNew(0, 4)
    })

    Library.Unload = function(self)
        if not self then return end

        if getgenv()._AlternateCleanup then
            pcall(getgenv()._AlternateCleanup)
            getgenv()._AlternateCleanup = nil
        end

        -- Close all open dropdown frames first
        if self.OpenFrames then
            for Frame, Value in pairs(self.OpenFrames) do
                if Value and Value.SetOpen then
                    pcall(function() Value:SetOpen(false) end)
                end
            end
            self.OpenFrames = {}
        end

        -- Disconnect all connections (support both ipairs and pairs)
        if self.Connections then
            for _, Value in pairs(self.Connections) do
                if Value and Value.Connection and typeof(Value.Connection.Disconnect) == "function" then
                    pcall(function() Value.Connection:Disconnect() end)
                end
            end
            self.Connections = {}
        end

        -- Close all active threads
        if self.Threads then
            for _, Value in pairs(self.Threads) do
                if Value and Value ~= coroutine.running() and coroutine.status(Value) ~= "dead" then
                    pcall(function() coroutine.close(Value) end)
                end
            end
            self.Threads = {}
        end

        -- Destroy UI holders
        if self.Holder and self.Holder.Instance then
            pcall(function()
                if self.Holder.Instance:IsA("ScreenGui") then
                    self.Holder.Instance.Enabled = false
                else
                    self.Holder.Instance.Visible = false
                end
                task.wait(0.1)
                self.Holder.Instance:Destroy()
            end)
        end
        if self.UnusedHolder and self.UnusedHolder.Instance then
            pcall(function()
                self.UnusedHolder.Instance.Enabled = false
                task.wait(0.1)
                self.UnusedHolder.Instance:Destroy()
            end)
        end
        if self.NotifHolder and self.NotifHolder.Instance then
            pcall(function() self.NotifHolder.Instance:Destroy() end)
        end

        -- Clear all references
        self.Holder = nil
        self.UnusedHolder = nil
        self.NotifHolder = nil
        self.KeyList = nil
        self.WatermarkObj = nil
        self.Pages = {}
        self.Sections = {}
        self.Colorpickers = {}
        self.Flags = {}
        self.ThemeItems = {}
        self.ThemeMap = {}
        self.SearchItems = {}
        self.SetFlags = {}
        self.CurrentPage = nil

        -- Clear global reference
        getgenv().Library = nil

        -- Restore mouse icon
        pcall(function() UserInputService.MouseIconEnabled = true end)
    end

    Library.GetImage = function(self, Image)
        local ImageData = self.Images[Image]

        if not ImageData then 
            return
        end

        return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
    end

    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        TableInsert(self.Threads, NewThread)
        return NewThread
    end
    
    Library.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        self.UnnamedConnections = (self.UnnamedConnections or 0) + 1
        Name = Name or StringFormat("Connection%s%s", self.UnnamedConnections, HttpService:GenerateGUID(false))

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = Event:Connect(Callback)
        }

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.Disconnect = function(self, Name)
        for Index = #self.Connections, 1, -1 do
            local Connection = self.Connections[Index]
            if Connection.Name == Name then
                if Connection.Connection and typeof(Connection.Connection.Disconnect) == "function" then
                    Connection.Connection:Disconnect()
                end
                table.remove(self.Connections, Index)
                break
            end
        end
    end

    Library.EscapePattern = function(self, String)
        local ShouldEscape = false 

        for Index, Value in SpecialCharacters do 
            if StringFind(String, Value) then 
                ShouldEscape = true
                break
            end
        end

        if ShouldEscape then
            return StringGSub(String, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
        end

        return String
    end

    Library.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("flag_number_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Library.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item 

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                Item[Property] = self.Theme[Value]
            else
                Item[Property] = Value()
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

	Library.ToRich = function(self, Text, Color)
		return `<font color="rgb({MathFloor(Color.R * 255)}, {MathFloor(Color.G * 255)}, {MathFloor(Color.B * 255)})">{Text}</font>`
	end

    Library.GetConfig = function(self)
        local Config = { } 

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.Color, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        return Success, Result
    end

    Library.DeleteConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config) then 
            delfile(Library.Folders.Configs .. "/" .. Config)
        end
    end

    Library.RefreshConfigsList = function(self, Element)
        local CurrentList = { }
        local List = { }

        local ConfigFolderName = StringGSub(Library.Folders.Configs, Library.Folders.Directory .. "/", "")

        for Index, Value in listfiles(Library.Folders.Configs) do
            local FileName = StringGSub(Value, Library.Folders.Directory .. "\\" .. ConfigFolderName .. "\\", "")
            List[Index] = FileName
        end

        local IsNew = #List ~= CurrentList

        if not IsNew then
            for Index = 1, #List do
                if List[Index] ~= CurrentList[Index] then
                    IsNew = true
                    break
                end
            end
        else
            CurrentList = List
            Element:Refresh(CurrentList)
        end
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.GetThemeFiles = function(self)
        if not isfolder(self.Folders.Themes) then
            makefolder(self.Folders.Themes)
        end

        local Files = { }
        for _, Path in ipairs(listfiles(self.Folders.Themes)) do
            local Name = tostring(Path):match("([^\\/]+)$") or tostring(Path)
            if Name and (Name:match("%.json$") or Name:match("%.txt$")) then
                local CleanName = Name:gsub("%.json$", ""):gsub("%.txt$", "")
                if CleanName ~= "" then
                    table.insert(Files, CleanName)
                end
            end
        end

        table.sort(Files)
        if #Files == 0 then
            self:SaveTheme("Preset")
            return { "Preset" }
        end

        return Files
    end

    Library.ThemeToHex = function(self, ColorValue)
        if typeof(ColorValue) ~= "Color3" then
            return "#FFFFFF"
        end

        return string.format("#%02X%02X%02X",
            math.floor((ColorValue.R * 255) + 0.5),
            math.floor((ColorValue.G * 255) + 0.5),
            math.floor((ColorValue.B * 255) + 0.5)
        )
    end

    Library.HexToColor = function(self, HexValue)
        local Hex = tostring(HexValue or "#FFFFFF"):gsub("#", "")
        if string.len(Hex) ~= 6 then
            return FromRGB(255, 255, 255)
        end

        local R = tonumber(Hex:sub(1, 2), 16) or 255
        local G = tonumber(Hex:sub(3, 4), 16) or 255
        local B = tonumber(Hex:sub(5, 6), 16) or 255
        return FromRGB(R, G, B)
    end

    Library.GetThemeTableForSave = function(self)
        local SaveTable = { }
        for Name, Value in pairs(self.Theme) do
            if typeof(Value) == "Color3" then
                SaveTable[Name] = self:ThemeToHex(Value)
            else
                SaveTable[Name] = tostring(Value)
            end
        end
        return SaveTable
    end

    Library.SaveTheme = function(self, Name)
        if not Name or tostring(Name):len() < 1 then
            Name = "CustomTheme"
        end

        local ThemeName = tostring(Name):gsub("%s+", "_")
        ThemeName = ThemeName:gsub("[^%w%-%_%.]", "_")
        if ThemeName == "" then
            ThemeName = "CustomTheme"
        end

        if not isfolder(self.Folders.Themes) then
            makefolder(self.Folders.Themes)
        end

        local Path = self.Folders.Themes .. "/" .. ThemeName .. ".json"
        writefile(Path, HttpService:JSONEncode(self:GetThemeTableForSave()))
        return ThemeName
    end

    Library.ExportTheme = function(self, Name)
        local ThemeName = self:SaveTheme(Name)
        local Payload = HttpService:JSONEncode(self:GetThemeTableForSave())
        if setclipboard then
            setclipboard(Payload)
        end
        return ThemeName, Payload
    end

    Library.ImportTheme = function(self, Name)
        local ThemeName = tostring(Name or "")
        if ThemeName == "" then
            return false
        end

        if not isfolder(self.Folders.Themes) then
            makefolder(self.Folders.Themes)
        end

        local Path = self.Folders.Themes .. "/" .. ThemeName .. ".json"
        local Exists = isfile(Path)
        if not Exists then
            local SearchPath = self.Folders.Themes .. "/" .. ThemeName
            if isfile(SearchPath .. ".json") then
                Path = SearchPath .. ".json"
                Exists = true
            elseif isfile(SearchPath .. ".txt") then
                Path = SearchPath .. ".txt"
                Exists = true
            end
        end

        if not Exists then
            return false
        end

        local ok, Raw = pcall(readfile, Path)
        if not ok or not Raw then
            return false
        end

        local Data = HttpService:JSONDecode(Raw)
        if type(Data) ~= "table" then
            return false
        end

        for Key, Value in pairs(Data) do
            if type(Value) == "string" and Value ~= "" then
                if Key == "Background" or Key == "Border" or Key == "Inline" or Key == "Hovered Element" or Key == "Page Background" or Key == "Outline" or Key == "Element" or Key == "Gradient" or Key == "Text" or Key == "Text Stroke" or Key == "Placeholder Text" or Key == "Accent" then
                    local Parsed = self:HexToColor(Value)
                    if typeof(Parsed) == "Color3" then
                        self:ChangeTheme(Key, Parsed)
                    end
                end
            end
        end

        return true
    end

    Library.IsMouseOverFrame = function(self, Frame, XOffset, YOffset)
        Frame = Frame.Instance
        XOffset = XOffset or 0 
        YOffset = YOffset or 0

        local MousePosition = Vector2New(Mouse.X + XOffset, Mouse.Y + YOffset)

        return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X 
        and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end

    Library.Lerp = function(self, Start, Finish, Time)
        return Start + (Finish - Start) * Time
    end

    -- Change the menu toggle keybind at runtime.
    -- Pass an Enum.KeyCode or Enum.UserInputType value.
    -- e.g. Library:SetMenuKeybind(Enum.KeyCode.RightAlt)
    Library.SetMenuKeybind = function(self, Key)
        Library.MenuKeybind = tostring(Key)
    end

    -- Components
    local Components = { } do
        Components.Window = function(self, Data)
            local Items = { } do
                Items["Window"] = Instances:Create("Frame", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    AnchorPoint = Data.AnchorPoint,
                    Position = Data.Position,
                    BorderColor3 = FromRGB(12, 12, 12),
                    Size = Data.Size,
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(14, 17, 15)
                })  Items["Window"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

                if Data.Draggable then 
                    Items["Window"]:MakeDraggable()
                end

                if Data.Resizeable then 
                    Items["Window"]:MakeResizeable(Vector2New(Data.Size.X.Offset, Data.Size.Y.Offset), Vector2New(9999, 9999))
                end

                Items["UIStroke"] = Items["Window"]:Border("Outline")
            end

            return Items
        end

        Components.AutosizingLabel = function(self, Data)
            local Label = { } 

            local Items = { } do
                Items["Label"] = Instances:Create("TextLabel", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Text,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Label"]:AddToTheme({TextColor3 = "Text"})

                Items["UIStroke"] = Items["Label"]:TextBorder()
            end

            function Label:SetProperty(Property, Value)
                Items["Label"].Instance[Property] = Value
            end

            return Label, Items
        end

        Components.WindowPage = function(self, Data)
            local Page = {
                Active = false,
                SubPages = { },
                Items = { },
                Window = Data.Window,
                ColumnsData = { }
            }

            local Items = { } do
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 46, 0, 46),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(14, 14, 14),
                    AutomaticSize = Enum.AutomaticSize.None,
                    ZIndex = 2
                })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Background"})

                Items["Liner"] = Instances:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(0, 0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})

                Items["Glow"] = Instances:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2New(0, 0),
                    Position = UDim2New(0, 0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    ZIndex = 0
                })  Items["Glow"]:AddToTheme({BackgroundColor3 = "Accent"})

                Items["GlowGradient"] = Instances:Create("UIGradient", {
                    Parent = Items["Glow"].Instance,
                    Name = "\0",
                    Rotation = 0,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(210, 180, 80)), RGBSequenceKeypoint(1, FromRGB(255, 225, 140))}
                })

                if Data.Icon then
                    Items["Icon"] = Instances:Create("ImageLabel", {
                        Parent = Items["Inactive"].Instance,
                        Name = "\0",
                        Image = Data.Icon,
                        ImageColor3 = FromRGB(128, 128, 128),
                        BackgroundTransparency = 1,
                        Position = UDim2New(0.5, 0, 0.5, 0),
                        AnchorPoint = Vector2New(0.5, 0.5),
                        Size = UDim2New(0, 85, 0, 85),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255),
                        ScaleType = Enum.ScaleType.Fit,
                        ZIndex = 1
                    })  Items["Icon"]:AddToTheme({ImageColor3 = "Accent"})

                    Items["IconGlow"] = Instances:Create("Frame", {
                        Parent = Items["Inactive"].Instance,
                        Name = "\0",
                        AnchorPoint = Vector2New(0.5, 0.5),
                        Position = UDim2New(0.5, 0, 0.5, 0),
                        Size = UDim2New(0, 0, 0, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(210, 180, 80),
                        BackgroundTransparency = 1,
                        ZIndex = 0
                    })  Items["IconGlow"]:AddToTheme({BackgroundColor3 = "Accent"})

                    Instances:Create("UIGradient", {
                        Parent = Items["IconGlow"].Instance,
                        Name = "\0",
                        Rotation = 0,
                        Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 225, 140)), RGBSequenceKeypoint(1, FromRGB(210, 180, 80))}
                    })
                else
                    Items["Text"] = Instances:Create("TextLabel", {
                        Parent = Items["Inactive"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(160, 160, 160),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = Data.Name,
                        AnchorPoint = Vector2New(0.5, 0.5),
                        Size = UDim2New(1, 0, 0, 14),
                        BackgroundTransparency = 1,
                        Position = UDim2New(0.5, 0, 0.85, 0),
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.None,
                        TextSize = 13,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
                    Items["TextStroke"] = Items["Text"]:TextBorder()
                end

                Items["Page"] = Instances:Create("Frame", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    Visible = false,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                if Data.SubPages then
                    Items["SubPages"] = Instances:Create("Frame", {
                        Parent = Items["Page"].Instance,
                        Name = "\0",
                        Size = UDim2New(1, 0, 0, 22),
                        BorderColor3 = FromRGB(42, 49, 45),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(20, 24, 21)
                    })  Items["SubPages"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Outline"})

                    Items["SubPages"]:Border("Border")

                    Instances:Create("UIPadding", {
                        Parent = Items["SubPages"].Instance,
                        Name = "\0",
                        PaddingRight = UDimNew(0, 4),
                        PaddingLeft = UDimNew(0, 4)
                    })

                    Instances:Create("UIListLayout", {
                        Parent = Items["SubPages"].Instance,
                        Name = "\0",
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Padding = UDimNew(0, 6),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    Items["Columns"] = Instances:Create("Frame", {
                        Parent = Items["Page"].Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 0, 0, 22),
                        BorderColor3 = FromRGB(42, 49, 45),
                        Size = UDim2New(1, 0, 1, -22),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                else
                    Instances:Create("UIListLayout", {
                        Parent = Items["Page"].Instance,
                        Name = "\0",
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Padding = UDimNew(0, 14),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    for Index = 1, Data.Columns do 
                        local NewColumn = Instances:Create("ScrollingFrame", {
                            Parent = Items["Page"].Instance,
                            Name = "\0",
                            ScrollBarImageColor3 = FromRGB(0, 0, 0),
                            Active = true,
                            AutomaticCanvasSize = Enum.AutomaticSize.Y,
                            ScrollBarThickness = 3,
                            BackgroundTransparency = 1,
                            Size = UDim2New(1, 0, 1, 0),
                            BackgroundColor3 = FromRGB(255, 255, 255),
                            BorderColor3 = FromRGB(0, 0, 0),
                            BorderSizePixel = 0,
                            CanvasSize = UDim2New(0, 0, 0, 0)
                        })

                        Instances:Create("UIPadding", {
                            Parent = NewColumn.Instance,
                            Name = "\0",
                            PaddingTop = UDimNew(0, 2),
                            PaddingBottom = UDimNew(0, 2),
                            PaddingRight = UDimNew(0, 2),
                            PaddingLeft = UDimNew(0, 2)
                        })

                        Instances:Create("UIListLayout", {
                            Parent = NewColumn.Instance,
                            Name = "\0",
                            Padding = UDimNew(0, 14),
                            SortOrder = Enum.SortOrder.LayoutOrder
                        })

                        Page.ColumnsData[Index] = NewColumn
                    end
                end

                Page.Items = Items
            end

            local Debounce = false

            function Page:Turn(Bool)
                if Debounce then 
                    return 
                end

                Page.Active = Bool 
                
                Debounce = true
                Items["Page"].Instance.Visible = Bool 
                Items["Page"].Instance.Parent = Bool and Data.ContentHolder.Instance or Library.UnusedHolder.Instance

                if Page.Active then
                    if Items["Inactive"] then
                        Items["Inactive"]:ChangeItemTheme({BackgroundColor3 = "Background"})
                        Items["Inactive"]:Tween(nil, {BackgroundTransparency = 1})
                    end
                    if Items["IconGlow"] then
                        Items["IconGlow"]:Tween(nil, {Size = UDim2New(0, 100, 0, 100), BackgroundTransparency = 0.65})
                    end
                    if Items["Icon"] then
                        Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
                        Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Accent, Size = UDim2New(0, 85, 0, 85)})
                    end
                    if Items["Text"] then
                        Items["Text"]:Tween(nil, {TextColor3 = FromRGB(240, 240, 240), Position = UDim2New(0, 8, 0.5, 0)})
                    end

                    Library.CurrentPage = Page
                else
                    if Items["Inactive"] then
                        Items["Inactive"]:ChangeItemTheme({BackgroundColor3 = "Background"})
                        Items["Inactive"]:Tween(nil, {BackgroundColor3 = Library.Theme.Background, BackgroundTransparency = 1})
                    end
                    if Items["IconGlow"] then
                        Items["IconGlow"]:Tween(nil, {Size = UDim2New(0, 0, 0, 0), BackgroundTransparency = 1})
                    end
                    if Items["Icon"] then
                        Items["Icon"]:ChangeItemTheme({ImageColor3 = "Text"})
                        Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Text, Size = UDim2New(0, 85, 0, 85)})
                    end
                    if Items["Text"] then
                        Items["Text"]:Tween(nil, {TextColor3 = FromRGB(140, 140, 140), Position = UDim2New(0, 8, 0.5, 0)})
                    end
                end

                local AllInstances = Items["Page"].Instance:GetDescendants()
                TableInsert(AllInstances, Items["Page"].Instance)
                
                local NewTween 
                local fadeTime = Data.Window.FadeTime or 0

                if fadeTime <= 0 then
                    -- Instant visibility optimization: skip loop entirely to prevent FPS lag and preserve theme transparencies
                    Debounce = false
                else
                    for Index, Value in AllInstances do 
                        local TransparencyProperty = Tween:GetProperty(Value)

                        if not TransparencyProperty then 
                            continue
                        end

                        if type(TransparencyProperty) == "table" then 
                            for _, Property in TransparencyProperty do 
                                NewTween = Tween:FadeItem(Value, Property, Bool, fadeTime)
                            end
                        else
                            NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, fadeTime)
                        end
                    end

                    if NewTween then
                        Library:Connect(NewTween.Tween.Completed, function()
                            Debounce = false
                        end)
                    else
                        Debounce = false
                    end
                end
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Data.Window.Pages do 
                    if Value == Page and Page.Active then
                        return
                    end

                    Value:Turn(Value == Page)
                end
            end)

            Items["Inactive"]:OnHover(function()
                if not Page.Active and Items["Inactive"] then
                    if Items["Text"] then
                        Items["Text"]:Tween(nil, {TextColor3 = FromRGB(220, 220, 220)})
                    end
                    if Items["Icon"] then
                        Items["Icon"]:Tween(nil, {ImageColor3 = FromRGB(220, 220, 220)})
                    end
                end
            end)

            Items["Inactive"]:OnHoverLeave(function()
                if not Page.Active and Items["Inactive"] then
                    if Items["Text"] then
                        Items["Text"]:Tween(nil, {TextColor3 = FromRGB(140, 140, 140)})
                    end
                    if Items["Icon"] then
                        Items["Icon"]:Tween(nil, {ImageColor3 = FromRGB(128, 128, 128)})
                    end
                end
            end)

            if #Data.Window.Pages == 0 then 
                Page:Turn(true)
            end

            TableInsert(Data.Window.Pages, Page)
            return Page, Items 
        end

        Components.WindowSubPage = function(self, Data)
            local SubPage = {
                Active = false,
                ColumnsData = { }
            }

            local Items = { } do
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Data.Page.Items["SubPages"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(12, 12, 12),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextSize = 15,
                    BackgroundColor3 = FromRGB(25, 30, 26)
                })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})

                Items["ButtonBorder"] = Instances:Create("UIStroke", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    Color = FromRGB(61, 60, 65),
                    Transparency = 1,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })  Items["ButtonBorder"]:AddToTheme({Color = "Outline"})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Name,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Size = UDim2New(0, 0, 0, 16),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 15,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Items["TextStroke"] = Items["Text"]:TextBorder()

                Instances:Create("UIPadding", {
                    Parent = Items["Text"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 10),
                    PaddingLeft = UDimNew(0, 10)
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 2),
                    PaddingLeft = UDimNew(0, 18),
                    PaddingRight = UDimNew(0, 12)
                })

                Items["Glow"] = Instances:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(210, 180, 80),
                    ZIndex = 0
                })  Items["Glow"]:AddToTheme({BackgroundColor3 = "Accent"})

                Instances:Create("UIGradient", {
                    Parent = Items["Glow"].Instance,
                    Name = "\0",
                    Rotation = 0,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(210, 180, 80)), RGBSequenceKeypoint(1, FromRGB(255, 225, 140))}
                })

                Items["Page"] = Instances:Create("Frame", {
                    Parent = Data.Page.Items["Columns"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = Data.FullHeight and UDim2New(0, 0, 0, 0) or UDim2New(0, -2, 0, -2),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = Data.FullHeight and UDim2New(1, 0, 1, 0) or UDim2New(1, 2, 1, 0),
                    BorderSizePixel = 0,
                    Visible = false,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 14),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                for Index = 1, Data.Columns do 
                    local NewColumn = Instances:Create("ScrollingFrame", {
                        Parent = Items["Page"].Instance,
                        Name = "\0",
                        ScrollBarImageColor3 = FromRGB(0, 0, 0),
                        Active = true,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        ScrollBarThickness = 3,
                        BackgroundTransparency = 1,
                        Size = UDim2New(1, 0, 1, 0),
                        BackgroundColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        CanvasSize = UDim2New(0, 0, 0, 0)
                    })

                    Instances:Create("UIPadding", {
                        Parent = NewColumn.Instance,
                        Name = "\0",
                        PaddingTop = UDimNew(0, 2),
                        PaddingBottom = UDimNew(0, 2),
                        PaddingRight = UDimNew(0, 2),
                        PaddingLeft = UDimNew(0, 2)
                    })

                    Instances:Create("UIListLayout", {
                        Parent = NewColumn.Instance,
                        Name = "\0",
                        Padding = UDimNew(0, 14),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    SubPage.ColumnsData[Index] = NewColumn
                end
            end

            local Debounce = false

            Library.SearchItems[SubPage] = { }

            function SubPage:Turn(Bool)
                if Debounce then 
                    return 
                end

                SubPage.Active = Bool 
                Debounce = true
                Items["Page"].Instance.Visible = Bool 
                Items["Page"].Instance.Parent = Bool and Data.Page.Items["Columns"].Instance or Library.UnusedHolder.Instance

                if SubPage.Active then
                        Items["Inactive"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element"})
                        Items["Inactive"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"], BackgroundTransparency = 0})
                        if Items["Liner"] then
                            Items["Liner"]:Tween(nil, {BackgroundTransparency = 1})
                        end
                        Items["Glow"]:Tween(nil, {BackgroundTransparency = 0.75})
                        if Items["GlowGradient"] then
                            Items["GlowGradient"]:Tween(nil, {Rotation = 180})
                        end
                        Items["Text"]:Tween(nil, {Position = UDim2New(0.5, 0, 0.5, 0)})

                        Library.CurrentPage = SubPage
                    else
                        Items["Inactive"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                        Items["Inactive"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element, BackgroundTransparency = 0})
                        if Items["Liner"] then
                            Items["Liner"]:Tween(nil, {BackgroundTransparency = 1})
                        end
                        Items["Glow"]:Tween(nil, {BackgroundTransparency = 1})
                        if Items["GlowGradient"] then
                            Items["GlowGradient"]:Tween(nil, {Rotation = 0})
                        end
                end

                local AllInstances = Items["Page"].Instance:GetDescendants()
                TableInsert(AllInstances, Items["Page"].Instance)

                local NewTween 
                local fadeTime = Data.Window.FadeTime or 0

                if fadeTime <= 0 then
                    -- Instant visibility optimization: skip loop entirely to prevent FPS lag and preserve theme transparencies
                    Debounce = false
                else
                    for Index, Value in AllInstances do 
                        local TransparencyProperty = Tween:GetProperty(Value)

                        if not TransparencyProperty then 
                            continue
                        end

                        if type(TransparencyProperty) == "table" then 
                            for _, Property in TransparencyProperty do 
                                NewTween = Tween:FadeItem(Value, Property, Bool, fadeTime)
                            end
                        else
                            NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, fadeTime)
                        end
                    end

                    if NewTween then
                        Library:Connect(NewTween.Tween.Completed, function()
                            Debounce = false
                        end)
                    else
                        Debounce = false
                    end
                end
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Data.Page.SubPages do 
                    if Value == SubPage and SubPage.Active then
                        return
                    end

                    Value:Turn(Value == SubPage)
                end
            end)

            Items["Inactive"]:OnHover(function()
                if SubPage.Active then 
                    return 
                end
                Items["Inactive"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})
            end)

            Items["Inactive"]:OnHoverLeave(function()
                if SubPage.Active then 
                    return 
                end
                Items["Inactive"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
            end)

            if #Data.Page.SubPages == 0 then 
                SubPage:Turn(true)
            end

            SubPage.Items = Items
            function SubPage:SetVisibility(Bool)
                Items["Inactive"].Instance.Visible = Bool
                if not Bool and SubPage.Active then
                    for _, val in ipairs(Data.Page.SubPages) do
                        if val ~= SubPage and val.Items and val.Items["Inactive"] and val.Items["Inactive"].Instance.Visible then
                            val:Turn(true)
                            break
                        end
                    end
                end
            end

            TableInsert(Data.Page.SubPages, SubPage)
            return SubPage
        end

        Components.Toggle = function(self, Data)
            local Toggle = {
                Value = false,
                Flag = Data.Flag
            }
            
            local Items = { } do
                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 18),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Indicator"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 2, 0.5, 0),
                    BorderColor3 = FromRGB(12, 12, 12),
                    Size = UDim2New(0, 10, 0, 10),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(30, 36, 31)
                })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

                Instances:Create("UIStroke", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Instances:Create("UIGradient", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Rotation = -165,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(208, 208, 208))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme.Gradient)}
                end})

                Items["Check"] = Instances:Create("ImageLabel", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(0, 0, 0),
                    ScaleType = Enum.ScaleType.Fit,
                    ImageTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "rbxassetid://108016671469439",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(1, 2, 1, 2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Name,
                    Size = UDim2New(0, 0, 0, 14),
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 22, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Items["Text"]:TextBorder()

                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, -6, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                if Data.Tooltip then
                    Items["TooltipThing"] = Instances:Create("TextLabel", {
                        Parent = Items["SubElements"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(235, 235, 235),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "(?)",
                        Size = UDim2New(0, 0, 0, 15),
                        AnchorPoint = Vector2New(0, 0.5),
                        Position = UDim2New(0, 22, 0.5, 0),
                        BackgroundTransparency = 1,
                        TextTransparency = 0.4,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.X,
                        TextSize = 13,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  Items["TooltipThing"]:AddToTheme({TextColor3 = "Text"})

                    Items["TooltipThing"]:TextBorder()

                    Items["TooltipThing"]:Tooltip({
                        Text = Data.Tooltip.Name,
                        Description = Data.Tooltip.Description
                    })
                end
            end
            
            function Toggle:Get()
                return Toggle.Value 
            end

            function Toggle:SetText(Text)
                Text = tostring(Text)
                Items["Text"].Instance.Text = Text
            end

            function Toggle:Set(Value)
                Toggle.Value = Value 
                Library.Flags[Toggle.Flag] = Value 

                if Toggle.Value then
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent", BorderColor3 = "Border"})
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
                    task.wait(0.05)
                    Items["Check"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {ImageTransparency = 0, Size = UDim2New(1, 2, 1, 2)})
                else
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                    task.wait(0.05)
                    Items["Check"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {ImageTransparency = 1, Size = UDim2New(0, 0, 0, 0)})
                end

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Toggle.Value)
                end
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool 
            end

            local PageSearchData = Library.SearchItems[Data.Page]

            if PageSearchData then
                local SearchData = {
                    Element = Items["Toggle"],
                    Name = Data.Name,
                }

                TableInsert(PageSearchData, SearchData)
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Items["Toggle"]:OnHover(function()
                if Toggle.Value then 
                    return 
                end

                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
            end)

            Items["Toggle"]:OnHoverLeave(function()
                if Toggle.Value then 
                    return 
                end

                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
            end)

            Toggle:Set(Data.Default)

            Library.SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return Toggle, Items
        end

        Components.Button = function(self, Data)
            local Button = { }

            local Items = { } do
                Items["Button"] = Instances:Create("Frame", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function Button:Add(Name, Callback)
                local NewButton = { }

                local SubItems = { } do
                    SubItems["NewButton"] = Instances:Create("TextButton", {
                        Parent = Items["Button"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(0, 0, 0),
                        BorderColor3 = FromRGB(12, 12, 12),
                        Text = "",
                        AutoButtonColor = false,
                        Size = UDim2New(1, 0, 0, 20),
                        BorderSizePixel = 2,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(30, 36, 31)
                    })  SubItems["NewButton"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

                    Instances:Create("UIGradient", {
                        Parent = SubItems["NewButton"].Instance,
                        Name = "\0",
                        Rotation = -165,
                        Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(208, 208, 208))}
                    }):AddToTheme({Color = function()
                        return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme.Gradient)}
                    end})

                    Instances:Create("UIStroke", {
                        Parent = SubItems["NewButton"].Instance,
                        Name = "\0",
                        Color = FromRGB(42, 49, 45),
                        LineJoinMode = Enum.LineJoinMode.Miter,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }):AddToTheme({Color = "Outline"})

                    SubItems["Text"] = Instances:Create("TextLabel", {
                        Parent = SubItems["NewButton"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(235, 235, 235),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = Name,
                        BackgroundTransparency = 1,
                        Size = UDim2New(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        TextYAlignment = Enum.TextYAlignment.Center,
                        TextSize = 13,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  SubItems["Text"]:AddToTheme({TextColor3 = "Text"})

                    SubItems["Text"]:TextBorder()
                end

                function NewButton:Press()
                    SubItems["NewButton"]:ChangeItemTheme({BackgroundColor3 = "Accent", BorderColor3 = "Border"})
                    SubItems["NewButton"]:Tween(nil, {BackgroundColor3 = (Library and Library.Theme and Library.Theme.Accent) or FromRGB(255,255,255)})

                    Library:SafeCall(Callback)
                    task.wait(0.1)

                    SubItems["NewButton"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
                    SubItems["NewButton"]:Tween(nil, {BackgroundColor3 = (Library and Library.Theme and Library.Theme.Element) or FromRGB(22,22,22)})
                end

                function NewButton:SetVisibility(Bool)
                    SubItems["NewButton"].Instance.Visible = Bool
                end

                local PageSearchData = Library.SearchItems[Data.Page]

                if PageSearchData then
                    local SearchData = {
                        Element = SubItems["NewButton"],
                        Name = Name,
                    }

                    TableInsert(PageSearchData, SearchData)
                end

                SubItems["NewButton"]:OnHover(function()
                    SubItems["NewButton"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
                    SubItems["NewButton"]:Tween(nil, {BackgroundColor3 = (Library and Library.Theme and Library.Theme["Hovered Element"]) or FromRGB(40,40,40)})
                end)

                SubItems["NewButton"]:OnHoverLeave(function()
                    SubItems["NewButton"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
                    SubItems["NewButton"]:Tween(nil, {BackgroundColor3 = (Library and Library.Theme and Library.Theme.Element) or FromRGB(22,22,22)})
                end)

                SubItems["NewButton"]:Connect("MouseButton1Down", function()
                    NewButton:Press()
                end)

                return NewButton 
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            return Button, Items
        end

        Components.Slider = function(self, Data)
            local Slider = {
                Value = 0,
                Flag = Data.Flag,
                Sliding = false
            }

            local Items = { } do
                Items["Slider"] = Instances:Create("Frame", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 22),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    Visible = Data.Visible ~= false
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Items["Text"]:TextBorder()

                Items["RealSlider"] = Instances:Create("TextButton", {
                    Parent = Items["Slider"].Instance,
                    AutoButtonColor = false,
                    Text = "",
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(12, 12, 12),
                    Size = UDim2New(1, 0, 0, 8),
                    BorderSizePixel = 1,
                    BackgroundColor3 = FromRGB(30, 36, 31)
                })  Items["RealSlider"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

                Instances:Create("UIGradient", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    Rotation = -90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(40, 40, 40)), RGBSequenceKeypoint(1, FromRGB(24, 24, 24))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(40, 40, 40)), RGBSequenceKeypoint(1, Library.Theme.Gradient)}
                end})

                Instances:Create("UIStroke", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0.5, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(19, 128, 225)
                })  Items["Accent"]:AddToTheme({BackgroundColor3 = "Accent"})

                Instances:Create("UIGradient", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    Rotation = -90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 210, 120)), RGBSequenceKeypoint(1, FromRGB(210, 180, 80))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 210, 120)), RGBSequenceKeypoint(1, Library.Theme.Accent)}
                end})

                Items["Dragger"] = Instances:Create("Frame", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, 0, 0.5, 0),
                    BorderColor3 = FromRGB(42, 49, 45),
                    Size = UDim2New(0, 3, 1, 2),
                    BorderSizePixel = 1,
                    BackgroundColor3 = FromRGB(14, 17, 15)
                })  Items["Dragger"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = Items["Dragger"].Instance,
                    Name = "\0",
                    Color = FromRGB(12, 12, 12),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "50%",
                    AnchorPoint = Vector2New(1, 0),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Value"]:AddToTheme({TextColor3 = "Text"})

                Items["Value"]:TextBorder()
            end

            function Slider:Get()
                return Slider.Value
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool == true
            end

            function Slider:Set(Value)
                Slider.Value = Library:Round(MathClamp(Value, Data.Min, Data.Max), Data.Decimals)

                Library.Flags[Slider.Flag] = Slider.Value

                Items["Accent"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New((Slider.Value - Data.Min) / (Data.Max - Data.Min), 0, 1, 0)})
                Items["Value"].Instance.Text = StringFormat("%s%s", tostring(Slider.Value), Data.Suffix)

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Slider.Value)
                end
            end

            --[[
            local PageSearchData = Library.SearchItems[Data.Page]

            if PageSearchData then
                local SearchData = {
                    Element = Items["Slider"],
                    Name = Data.Name,
                }

                TableInsert(PageSearchData, SearchData)
            end
            --]]

            local InputChanged

            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true 

                    local SizeX = (Mouse.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                    local Value = ((Data.Max - Data.Min) * SizeX) + Data.Min

                    Slider:Set(Value)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false
                            
                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, LPH_NO_VIRTUALIZE(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local SizeX = (Mouse.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                        local Value = ((Data.Max - Data.Min) * SizeX) + Data.Min

                        Slider:Set(Value)
                    end
                end
            end))

            Items["Slider"]:OnHover(function()
                Items["RealSlider"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
                Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
            end)

            Items["Slider"]:OnHoverLeave(function()
                Items["RealSlider"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
                Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
            end)

            if Data.Default then 
                Slider:Set(Data.Default)
            end

            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return Slider, Items
        end

        Components.Label = function(self, Data)
            local Label = { }

            local Items = { } do
                Items["Label"] = Instances:Create("Frame", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Items["Text"]:TextBorder()

                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, Items["Text"].Instance.TextBounds.X + 8, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function Label:SetText(Text)
                Text = tostring(Text)

                Items["Text"].Instance.Text = Text
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool
            end

            return Label, Items 
        end

        Components.Dropdown = function(self, Data)
            local Dropdown = {
                Flag = Data.Flag, 
                Value = { },
                Options = { },
                IsOpen = false
            }

            local Items = { } do
                Items["Dropdown"] = Instances:Create("Frame", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 40),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Items["Text"]:TextBorder()

                Items["RealDropdown"] = Instances:Create("TextButton", {
                    Parent = Items["Dropdown"].Instance,
                    AutoButtonColor = false,
                    Text = "",
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(12, 12, 12),
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(30, 36, 31)
                })  Items["RealDropdown"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

                Instances:Create("UIGradient", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    Rotation = -165,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(208, 208, 208))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme.Gradient)}
                end})

                Instances:Create("UIStroke", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "--",
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(1, -10, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2New(0, 8, 0.5, 0),
                    BorderSizePixel = 0,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Value"]:AddToTheme({TextColor3 = "Text"})

                Items["Value"]:TextBorder()

                Items["OptionHolder"] = Instances:Create("ScrollingFrame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    BorderColor3 = FromRGB(12, 12, 12),
                    BorderSizePixel = 2,
                    Position = UDim2New(0, 0, 1, 8),
                    Size = UDim2New(1, 0, 0, 25),
                    ZIndex = 5,
                    BackgroundColor3 = FromRGB(20, 24, 21),
                    ScrollBarThickness = 3,
                    ScrollBarImageColor3 = FromRGB(0, 0, 0),
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ClipsDescendants = true
                })  Items["OptionHolder"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Border"})

                Instances:Create("UIStroke", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Instances:Create("UIPadding", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 5),
                    PaddingBottom = UDimNew(0, 5),
                    PaddingRight = UDimNew(0, 5),
                    PaddingLeft = UDimNew(0, 8)
                })

                Items["OptionLayout"] = Instances:Create("UIListLayout", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 3),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                if Data.ShowFavorites then
                    Items["ViewMenu"] = Instances:Create("Frame", {
                        Parent = Items["OptionHolder"].Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(1, 0, 0, 22),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    Items["ViewMenuLayout"] = Instances:Create("UIListLayout", {
                        Parent = Items["ViewMenu"].Instance,
                        Name = "\0",
                        FillDirection = Enum.FillDirection.Horizontal,
                        Padding = UDimNew(0, 4),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        HorizontalAlignment = Enum.HorizontalAlignment.Left,
                        VerticalAlignment = Enum.VerticalAlignment.Center
                    })

                    Items["NormalViewButton"] = Instances:Create("TextButton", {
                        Parent = Items["ViewMenu"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "Normal",
                        AutoButtonColor = false,
                        BorderSizePixel = 0,
                        BackgroundTransparency = 0,
                        Size = UDim2New(0, 62, 1, 0),
                        TextSize = 13,
                        BackgroundColor3 = FromRGB(32, 38, 35)
                    })  Items["NormalViewButton"]:AddToTheme({BackgroundColor3 = "Inline", TextColor3 = "Text"})

                    Items["FavoritesViewButton"] = Instances:Create("TextButton", {
                        Parent = Items["ViewMenu"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "Favorites",
                        AutoButtonColor = false,
                        BorderSizePixel = 0,
                        BackgroundTransparency = 0,
                        Size = UDim2New(0, 70, 1, 0),
                        TextSize = 13,
                        BackgroundColor3 = FromRGB(32, 38, 35)
                    })  Items["FavoritesViewButton"]:AddToTheme({BackgroundColor3 = "Inline", TextColor3 = "Text"})

                    Items["NormalViewButton"]:Connect("MouseButton1Down", function()
                        Dropdown:SetView("Normal")
                    end)

                    Items["FavoritesViewButton"]:Connect("MouseButton1Down", function()
                        Dropdown:SetView("Favorites")
                    end)
                end

            end

            function Dropdown:Get()
                return Dropdown.Value
            end

            function Dropdown:GetFavorites()
                local List = { }

                for Index, Value in pairs(Dropdown.Options) do
                    if Value.Favorited then
                        TableInsert(List, Value.Name)
                    end
                end

                return List
            end

            function Dropdown:SetView(View)
                Dropdown.View = View == "Favorites" and "Favorites" or "Normal"

                if Data.ShowFavorites and Items["NormalViewButton"] and Items["FavoritesViewButton"] then
                    local ActiveColor = Library.Theme and Library.Theme.Accent or FromRGB(92, 128, 255)
                    local InactiveColor = Library.Theme and Library.Theme.Inline or FromRGB(32, 38, 35)

                    Items["NormalViewButton"].Instance.BackgroundColor3 = Dropdown.View == "Normal" and ActiveColor or InactiveColor
                    Items["FavoritesViewButton"].Instance.BackgroundColor3 = Dropdown.View == "Favorites" and ActiveColor or InactiveColor
                end

                for Index, Value in pairs(Dropdown.Options) do
                    if not Value.Row then
                        continue
                    end

                    local IsVisible = Dropdown.View == "Normal" or Value.Favorited
                    Value.Row.Visible = IsVisible
                end
            end

            local Debounce = false
            local RenderStepped


            function Dropdown:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Dropdown.IsOpen = Bool

                Debounce = true 

                if Dropdown.IsOpen then 
                    -- Calculate how many items to show (max 5)
                    local itemCount = 0
                    for _, Value in pairs(Dropdown.Options) do
                        if Dropdown.View == "Favorites" then
                            if Value.Favorited then
                                itemCount = itemCount + 1
                            end
                        else
                            itemCount = itemCount + 1
                        end
                    end
                    local maxItemsToShow = math.min(itemCount, 8)
                    local itemHeight = 18 + 3 -- item height + padding
                    local paddingTotal = 14 -- top + bottom padding
                    local menuOffset = Data.ShowFavorites and 26 + 5 or 0
                    local calculatedHeight = (maxItemsToShow * itemHeight) + paddingTotal + menuOffset
                    
                    Items["OptionHolder"].Instance.Visible = true
                    Items["OptionHolder"].Instance.Parent = Library.Holder.Instance
                    
                    RenderStepped = Library:Connect(RunService.RenderStepped, LPH_NO_VIRTUALIZE(function()
                        Items["OptionHolder"].Instance.Position = UDim2New(0, Items["RealDropdown"].Instance.AbsolutePosition.X, 0, Items["RealDropdown"].Instance.AbsolutePosition.Y + Items["RealDropdown"].Instance.AbsoluteSize.Y + 5)
                        Items["OptionHolder"].Instance.Size = UDim2New(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, calculatedHeight)
                    end))

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= Dropdown then 
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown 
                else
                    if Library.OpenFrames[Dropdown] then 
                        Library.OpenFrames[Dropdown] = nil
                    end

                    if RenderStepped then 
                        Library:Disconnect(RenderStepped.Name)
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["OptionHolder"].Instance:GetDescendants()
                TableInsert(Descendants, Items["OptionHolder"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                local function onCompleted()
                    Debounce = false 
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                    task.wait(0.2)
                    Items["OptionHolder"].Instance.Parent = not Dropdown.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end
                if NewTween then
                    NewTween.Tween.Completed:Connect(onCompleted)
                else
                    onCompleted()
                end
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end

            function Dropdown:Set(Option)
                if Data.Multi then 
                    if type(Option) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Option do
                        local OptionData = Dropdown.Options[Value]
                        
                        if not OptionData then
                            continue
                        end

                        OptionData.Selected = true 
                        OptionData:Toggle("Active")
                    end

                    Items["Value"].Instance.Text = TableConcat(Option, ", ")
                else
                    if not Dropdown.Options[Option] then
                        return
                    end

                    local OptionData = Dropdown.Options[Option]

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.Selected = false 
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true 
                            Value:Toggle("Active")
                        end
                    end

                    Items["Value"].Instance.Text = Option
                end

                if Data.Callback then   
                    Library:SafeCall(Data.Callback, Dropdown.Value)
                end
            end

            function Dropdown:Add(Option)
                local OptionName = tostring(Option)

                if type(Option) == "table" then
                    if Option.Name ~= nil then
                        OptionName = tostring(Option.Name)
                    elseif Option.Value ~= nil then
                        OptionName = tostring(Option.Value)
                    elseif Option[1] ~= nil then
                        OptionName = tostring(Option[1])
                    end
                end

                local OptionRow = Instances:Create("Frame", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 18),
                    ZIndex = 5,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                local OptionButton = Instances:Create("TextButton", {
                    Parent = OptionRow.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = OptionName,
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2New(0, 8, 0, 0),
                    Size = UDim2New(1, -26, 1, 0),
                    ZIndex = 6,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  OptionButton:AddToTheme({TextColor3 = "Text"})

                local OptionData = {
                    Row = OptionRow,
                    Button = OptionButton,
                    Name = OptionName,
                    Selected = false,
                    Favorited = false
                }

                if Data.ShowFavorites then
                    OptionData.StarButton = Instances:Create("TextButton", {
                        Parent = OptionRow.Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(200, 200, 200),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "☆",
                        AutoButtonColor = false,
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        Position = UDim2New(1, -18, 0.5, 0),
                        Size = UDim2New(0, 14, 0, 14),
                        TextSize = 15,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    OptionData.StarButton:Connect("MouseButton1Down", function()
                        OptionData:SetFavorite(not OptionData.Favorited)
                    end)
                end

                function OptionData:SetFavorite(Bool)
                    OptionData.Favorited = Bool

                    if OptionData.StarButton then
                        OptionData.StarButton.Text = Bool and "★" or "☆"
                        OptionData.StarButton.TextColor3 = Bool and FromRGB(255, 205, 90) or FromRGB(200, 200, 200)
                    end

                    if Data.ShowFavorites then
                        Dropdown:SetView(Dropdown.View)
                        if Dropdown.FavoriteFlag then
                            Library.Flags[Dropdown.FavoriteFlag] = Dropdown:GetFavorites()
                        end
                    end
                end

                function OptionData:Toggle(Status)
                    if Status == "Active" then 
                        OptionData.Button:ChangeItemTheme({TextColor3 = "Accent"})
                        OptionData.Button:Tween(nil, {TextColor3 = Library.Theme.Accent})
                    else
                        OptionData.Button:ChangeItemTheme({TextColor3 = "Text"}) 
                        OptionData.Button:Tween(nil, {TextColor3 = Library.Theme.Text})
                    end
                end

                function OptionData:Set()
                    OptionData.Selected = not OptionData.Selected

                    if Data.Multi then 
                        local Index = TableFind(Dropdown.Value, OptionData.Name)

                        if Index then 
                            TableRemove(Dropdown.Value, Index)
                        else
                            TableInsert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:Toggle(Index and "Inactive" or "Active")

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "--"
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.Selected then 
                            Dropdown.Value = OptionData.Name
                            Library.Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.Selected = true
                            OptionData:Toggle("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.Selected = false 
                                    Value:Toggle("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Library.Flags[Dropdown.Flag] = nil

                            OptionData.Selected = false
                            OptionData:Toggle("Inactive")

                            Items["Value"].Instance.Text = "--"
                        end
                    end

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Dropdown.Value)
                    end
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                OptionData.Row.Visible = true
                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if not Dropdown.Options[Option] then
                    return
                end

                Dropdown.Options[Option].Button:Clean()
                Dropdown.Options[Option] = nil
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do 
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do 
                    Dropdown:Add(Value)
                end
            end

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            Items["Dropdown"]:OnHover(function()
                Items["RealDropdown"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
            end)

            Items["Dropdown"]:OnHoverLeave(function()
                Items["RealDropdown"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Dropdown.IsOpen then
                        return 
                    end

                    if Library:IsMouseOverFrame(Items["OptionHolder"]) then 
                        return
                    end

                    Dropdown:SetOpen(false)
                end
            end)

            for Index, Value in Data.Items do 
                Dropdown:Add(Value)
            end

            if Data.ShowFavorites and Dropdown.FavoriteFlag and type(Library.Flags[Dropdown.FavoriteFlag]) == "table" then
                for _, Favorite in ipairs(Library.Flags[Dropdown.FavoriteFlag]) do
                    if Dropdown.Options[Favorite] then
                        Dropdown.Options[Favorite]:SetFavorite(true)
                    end
                end
            end

            if Data.Default then 
                Dropdown:Set(Data.Default)
            end

            if Data.ShowFavorites then
                Dropdown:SetView(Dropdown.View)
            end

            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            if Data.ShowFavorites and Dropdown.FavoriteFlag then
                Library.SetFlags[Dropdown.FavoriteFlag] = function(Value)
                    if type(Value) ~= "table" then
                        return
                    end

                    for Name, Option in pairs(Dropdown.Options) do
                        Option:SetFavorite(TableFind(Value, Name) ~= nil)
                    end
                end
            end

            return Dropdown, Items 
        end

        Components.ColorpickerTab = function(self, Data)
            if not Data.Pages then 
                return
            end
            if not Data.ContentHolder or not Data.ContentHolder.Instance then
                return
            end
            if not Data.PageHolder or not Data.PageHolder.Instance then
                return
            end

            local NewTab = { 
                Name = Data.Name,
                Active = false
            }

            local Items = { } do
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Data.PageHolder.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = NewTab.Name,
                    AutoButtonColor = false,
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(20, 24, 21)
                })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Inline"})

                Items["Inactive"]:TextBorder()

                Items["PageContent"] = Instances:Create("Frame", {
                    Parent = Data.ContentHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
            end

            function NewTab:Turn(Bool)
                NewTab.Active = Bool 

                if NewTab.Active then
                    Items["PageContent"].Instance.Visible = true 
                    Items["PageContent"].Instance.Parent = Data.ContentHolder.Instance 

                    Items["Inactive"]:ChangeItemTheme({BackgroundColor3 = "Background"})
                    Items["Inactive"]:Tween(nil, {BackgroundColor3 = Library.Theme.Background})
                else
                    Items["PageContent"].Instance.Visible = false
                    Items["PageContent"].Instance.Parent = Library.UnusedHolder.Instance 

                    Items["Inactive"]:ChangeItemTheme({BackgroundColor3 = "Inline"})
                    Items["Inactive"]:Tween(nil, {BackgroundColor3 = Library.Theme.Inline})
                end
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Data.Stack do 
                    Value:Turn(Value == NewTab)
                end
            end)

            if #Data.Stack == 0 then 
                NewTab:Turn(true)
            end

            TableInsert(Data.Stack, NewTab)
            return NewTab, Items 
        end

        Components.CreateSubPaletteItems = function(self, Items)
            Items["ColorpickerWindow"].Instance.Size = UDim2New(0, 171, 0, 168)

            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(42, 49, 45),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 8, 0, 8),
                Size = UDim2New(1, -41, 1, -41),
                BorderSizePixel = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(157, 175, 255)
            })  Items["Palette"]:AddToTheme({BorderColor3 = "Outline"})

            Instances:Create("UIStroke", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Color = FromRGB(12, 12, 12),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Saturation"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Saturation"),
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["Value"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 2, 1, 0),
                Image = Library:GetImage("Value"),
                BackgroundTransparency = 1,
                Position = UDim2New(0, -1, 0, 0),
                ZIndex = 3,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Position = UDim2New(0, 8, 0, 8),
                ZIndex = 5,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 2, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIStroke", {
                Parent = Items["PaletteDragger"].Instance,
                Name = "\0",
                Color = FromRGB(12, 12, 12),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Hue"] = Instances:Create("Frame", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                Active = true,
                BorderColor3 = FromRGB(42, 49, 45),
                AnchorPoint = Vector2New(1, 0),
                Position = UDim2New(1, -8, 0, 8),
                Size = UDim2New(0, 15, 1, -16),
                Selectable = true,
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Hue"]:AddToTheme({BorderColor3 = "Outline"})

            Instances:Create("UIStroke", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                Color = FromRGB(12, 12, 12),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["HueInline"] = Instances:Create("TextButton", {
                Parent = Items["Hue"].Instance,
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIGradient", {
                Parent = Items["HueInline"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
            })

            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIStroke", {
                Parent = Items["HueDragger"].Instance,
                Name = "\0",
                Color = FromRGB(12, 12, 12),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Alpha"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(42, 49, 45),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 8, 1, -8),
                Size = UDim2New(1, -41, 0, 15),
                BorderSizePixel = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(157, 175, 255)
            })  Items["Alpha"]:AddToTheme({BorderColor3 = "Outline"})

            Instances:Create("UIStroke", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                Color = FromRGB(12, 12, 12),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Checkers"] = Instances:Create("ImageLabel", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                ScaleType = Enum.ScaleType.Tile,
                BorderColor3 = FromRGB(0, 0, 0),
                TileSize = UDim2New(0, 6, 0, 6),
                Image = Library:GetImage("Checkers"),
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  

            Instances:Create("UIGradient", {
                Parent = Items["Checkers"].Instance,
                Name = "\0",
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(0.37, 0.5), NumSequenceKeypoint(1, 0)}
            })

            Items["AlphaDragger"] = Instances:Create("Frame", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                ZIndex = 5,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 1, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIStroke", {
                Parent = Items["AlphaDragger"].Instance,
                Name = "\0",
                Color = FromRGB(12, 12, 12),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
        end

        Components.Colorpicker = function(self, Data) -- poetry warning (╯°□°)╯
            local Colorpicker = {
                IsOpen = false,

                Hue = 0,
                Saturation = 0,
                Value = 0,
                Alpha = 0,

                Color = FromRGB(255, 255, 255),
                HexValue = "#ffffff",

                Pages = { },
                Flag = Data.Flag,
            }

            local UpdateSync

            local Items = { } do
                Items["ColorpickerButton"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(12, 12, 12),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2New(0, -123, 0, 0),
                    Size = UDim2New(0, 15, 0, 15),
                    BorderSizePixel = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(157, 175, 255)
                })  Items["ColorpickerButton"]:AddToTheme({BorderColor3 = "Border"})

                Instances:Create("UIStroke", {
                    Parent = Items["ColorpickerButton"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Items["ColorpickerButtonInline"] = Instances:Create("Frame", {
                    Parent = Items["ColorpickerButton"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(157, 175, 255)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["ColorpickerButtonInline"].Instance,
                    Name = "\0",
                    Rotation = -90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(160, 160, 160))}
                })

                Items["ColorpickerWindow"] = Instances:Create("TextButton", {
                    Parent = Library.UnusedHolder.Instance,
                    Text = "",
                    AutoButtonColor = false,
                    Name = "\0",
                    Position = UDim2New(0, 12, 0, 12),
                    BorderColor3 = FromRGB(12, 12, 12),
                    Size = UDim2New(0, 266, 0, 282),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(14, 17, 15)
                })  Items["ColorpickerWindow"]:AddToTheme({BorderColor3 = "Border", BackgroundColor3 = "Background"})

                Instances:Create("UIStroke", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                if Data.Pages then 
                    Items["Pages"] = Instances:Create("Frame", {
                        Parent = Items["ColorpickerWindow"].Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(1, 0, 0, 24),
                        Position = UDim2New(0, 0, 0, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    Instances:Create("UIListLayout", {
                        Parent = Items["Pages"].Instance,
                        Name = "\0",
                        FillDirection = Enum.FillDirection.Horizontal,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Padding = UDimNew(0, 4),
                        VerticalAlignment = Enum.VerticalAlignment.Center
                    })

                    Items["Content"] = Instances:Create("Frame", {
                        Parent = Items["ColorpickerWindow"].Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 0, 0, 24),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(1, 0, 1, -24),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                else
                    Components:CreateSubPaletteItems(Items)
                end
            end

            local ColorTab, ColorTabItems = Components:ColorpickerTab({
                ContentHolder = Items["Content"],
                Pages = Colorpicker.Pages,
                PageHolder = Items["Pages"],
                Stack = Colorpicker.Pages,
                Name = "Color"
            })

            local AnimationsTab, AnimationsTabItems = Components:ColorpickerTab({
                ContentHolder = Items["Content"],
                Pages = Colorpicker.Pages,
                PageHolder = Items["Pages"],
                Stack = Colorpicker.Pages,
                Name = "Animations"
            })

            local OtherTab, OtherTabItems = Components:ColorpickerTab({
                ContentHolder = Items["Content"],
                Pages = Colorpicker.Pages,
                PageHolder = Items["Pages"],
                Stack = Colorpicker.Pages,
                Name = "Other"
            })

            local OldColor = Colorpicker.Color
            local OldAlpha = Colorpicker.Alpha
            local CurrentAnimation

            local AnimationsDropdown, AnimationsDropdownItems
            local KeyframeOneLabel, KeyframeOneLabelItems
            local KeyframeTwoLabel, KeyframeTwoLabelItems

            local KeyframeOneColorpicker, KeyframeOneColorpickerItems
            local KeyframeTwoColorpicker, KeyframeTwoColorpickerItems

            local AnimationSpeedSlider, AnimationSpeedSliderItems

            if ColorTab then
                Items["Palette"] = Instances:Create("TextButton", {
                    Parent = ColorTabItems["PageContent"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(42, 49, 45),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2New(0, 8, 0, 8),
                    Size = UDim2New(1, -46, 1, -46),
                    BorderSizePixel = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(157, 175, 255)
                })  Items["Palette"]:AddToTheme({BorderColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    Color = FromRGB(12, 12, 12),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["Saturation"] = Instances:Create("ImageLabel", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Image = Library:GetImage("Saturation"),
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Value"] = Instances:Create("ImageLabel", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 2, 1, 0),
                    Image = Library:GetImage("Value"),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, -1, 0, 0),
                    ZIndex = 3,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["PaletteDragger"] = Instances:Create("Frame", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 8, 0, 8),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 2, 0, 2),
                    BorderSizePixel = 0,
                    ZIndex = 5,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["PaletteDragger"].Instance,
                    Name = "\0",
                    Color = FromRGB(12, 12, 12),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["Hue"] = Instances:Create("Frame", {
                    Parent = ColorTabItems["PageContent"].Instance,
                    Name = "\0",
                    Active = true,
                    BorderColor3 = FromRGB(42, 49, 45),
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, -8, 0, 8),
                    Size = UDim2New(0, 20, 1, -16),
                    Selectable = true,
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Hue"]:AddToTheme({BorderColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    Color = FromRGB(12, 12, 12),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["HueInline"] = Instances:Create("TextButton", {
                    Parent = Items["Hue"].Instance,
                    AutoButtonColor = false,
                    Text = "",
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["HueInline"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
                })

                Items["HueDragger"] = Instances:Create("Frame", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["HueDragger"].Instance,
                    Name = "\0",
                    Color = FromRGB(12, 12, 12),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["Alpha"] = Instances:Create("TextButton", {
                    Parent = ColorTabItems["PageContent"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(42, 49, 45),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 8, 1, -8),
                    Size = UDim2New(1, -46, 0, 20),
                    BorderSizePixel = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(157, 175, 255)
                })  Items["Alpha"]:AddToTheme({BorderColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = Items["Alpha"].Instance,   
                    Name = "\0",
                    Color = FromRGB(12, 12, 12),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["Checkers"] = Instances:Create("ImageLabel", {
                    Parent = Items["Alpha"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Tile,
                    BorderColor3 = FromRGB(0, 0, 0),
                    TileSize = UDim2New(0, 6, 0, 6),
                    Image = Library:GetImage("Checkers"),
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  

                Instances:Create("UIGradient", {
                    Parent = Items["Checkers"].Instance,
                    Name = "\0",
                    Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(0.37, 0.5), NumSequenceKeypoint(1, 0)}
                })

                Items["AlphaDragger"] = Instances:Create("Frame", {
                    Parent = Items["Alpha"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 1, 1, 0),
                    ZIndex = 5,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["AlphaDragger"].Instance,
                    Name = "\0",
                    Color = FromRGB(12, 12, 12),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
            end

            if AnimationsTab then
                AnimationsDropdown, AnimationsDropdownItems = Components:Dropdown({
                    Parent = AnimationsTabItems["PageContent"],
                    Name = "Animations",
                    Items = {"Rainbow", "Fade", "Fade alpha", "Linear"},
                    Default = nil,
                    Flag = Colorpicker.Flag.."Animation",
                    Multi = false,
                    Debounce = Colorpicker,
                    Callback = function(Value)
                        CurrentAnimation = Value
                        if Value == "Rainbow" then 
                            if KeyframeOneLabel and KeyframeTwoLabel and AnimationSpeedSlider then
                                KeyframeOneLabel:SetVisibility(false)
                                KeyframeTwoLabel:SetVisibility(false)

                                AnimationSpeedSliderItems["Slider"].Instance.Position = UDim2New(0, 8, 0, 45)
                            end

                            OldColor = Colorpicker.Color

                            Library:Thread(function()
                                while task.wait() do 
                                    local RainbowHue = MathAbs(MathSin(tick() * (AnimationSpeedSlider.Value / 25)))
                                    local Color = FromHSV(RainbowHue, 1, 1)

                                    Colorpicker:Set(Color, Colorpicker.Alpha)
                                    UpdateSync(true)

                                    if CurrentAnimation ~= "Rainbow" then
                                        Colorpicker:Set(OldColor, Colorpicker.Alpha)
                                        break
                                    end
                                end
                            end)
                        elseif Value == "Fade" then 
                            if KeyframeOneLabel and KeyframeTwoLabel and AnimationSpeedSlider then
                                KeyframeOneLabel:SetVisibility(true)
                                KeyframeTwoLabel:SetVisibility(false)

                                AnimationSpeedSliderItems["Slider"].Instance.Position = UDim2New(0, 8, 0, 65)

                                OldColor = Colorpicker.Color
                                
                                Library:Thread(function()
                                    while task.wait() do 
                                        local Speed = MathAbs(MathSin(tick() * (AnimationSpeedSlider.Value / 25)))
                                        Colorpicker:Set(KeyframeOneColorpicker.Color:Lerp(FromRGB(0, 0, 0), Speed), Colorpicker.Alpha)
                                        UpdateSync(true)

                                        if CurrentAnimation ~= "Fade" then
                                            Colorpicker:Set(OldColor, Colorpicker.Alpha)
                                            break
                                        end
                                    end
                                end)
                            end
                        elseif Value == "Fade alpha" then
                            if KeyframeOneLabel and KeyframeTwoLabel then
                                KeyframeOneLabel:SetVisibility(false)
                                KeyframeTwoLabel:SetVisibility(false)

                                AnimationSpeedSliderItems["Slider"].Instance.Position = UDim2New(0, 8, 0, 45)

                                OldColor = Colorpicker.Alpha
                                
                                Library:Thread(function()
                                    while task.wait() do 
                                        local AlphaValue = MathAbs(MathSin(tick() * (AnimationSpeedSlider.Value / 25)))
                                        Colorpicker:Set(Colorpicker.Color, AlphaValue)
                                        UpdateSync(true)

                                        if CurrentAnimation ~= "Fade alpha" then
                                            Colorpicker:Set(Colorpicker.Color, OldAlpha)
                                            break
                                        end
                                    end
                                end)
                            end
                        elseif Value == "Linear" then
                            if KeyframeOneLabel and KeyframeTwoLabel then
                                KeyframeOneLabel:SetVisibility(true)
                                KeyframeTwoLabel:SetVisibility(true)

                                AnimationSpeedSliderItems["Slider"].Instance.Position = UDim2New(0, 8, 0, 85)

                                OldColor = Colorpicker.Color
                                
                                Library:Thread(function()
                                    while task.wait() do 
                                        local Speed = MathAbs(MathSin(tick() * (AnimationSpeedSlider.Value / 25)))
                                        Colorpicker:Set(KeyframeOneColorpicker.Color:Lerp(KeyframeTwoColorpicker.Color, Speed), Colorpicker.Alpha)
                                        UpdateSync(true)

                                        if CurrentAnimation ~= "Linear" then
                                            Colorpicker:Set(OldColor, Colorpicker.Alpha)
                                            break
                                        end
                                    end
                                end)
                            end
                        end
                    end
                })

                AnimationsDropdownItems["Dropdown"].Instance.Position = UDim2New(0, 8, 0, 0)
                AnimationsDropdownItems["Dropdown"].Instance.Size = UDim2New(1, -16, 0, 40)

                KeyframeOneLabel, KeyframeOneLabelItems = Components:Label({
                    Parent = AnimationsTabItems["PageContent"],
                    Name = "Keyframe 1",
                })

                KeyframeOneLabelItems["Label"].Instance.Position = UDim2New(0, 8, 0, 45)
                KeyframeOneLabelItems["Label"].Instance.Size = UDim2New(1, -16, 0, 20)

                KeyframeTwoLabel, KeyframeTwoLabelItems = Components:Label({
                    Parent = AnimationsTabItems["PageContent"],
                    Name = "Keyframe 2",
                })

                KeyframeTwoLabelItems["Label"].Instance.Position = UDim2New(0, 8, 0, 65)
                KeyframeTwoLabelItems["Label"].Instance.Size = UDim2New(1, -16, 0, 20)

                KeyframeOneColorpicker, KeyframeOneColorpickerItems = Components:Colorpicker({
                    Parent = KeyframeOneLabelItems["SubElements"],
                    Alpha = 0,
                    Pages = false,
                    Default = Color3.fromRGB(255, 255, 255),
                    Flag = Colorpicker.Flag.."Animation".."Keyframe1",
                    Debounce = Colorpicker,
                })

                KeyframeTwoColorpicker, KeyframeTwoColorpickerItems = Components:Colorpicker({
                    Parent = KeyframeTwoLabelItems["SubElements"],
                    Alpha = 0,
                    Pages = false,
                    Default = Color3.fromRGB(0, 0, 0),
                    Debounce = Colorpicker,
                    Flag = Colorpicker.Flag.."Animation".."Keyframe2",
                })

                AnimationSpeedSlider, AnimationSpeedSliderItems = Components:Slider({
                    Parent = AnimationsTabItems["PageContent"],
                    Name = "Speed",
                    Flag = Colorpicker.Flag .. "AnimationSpeed",
                    Min = 0,
                    Max = 100,
                    Decimals = 0.1,
                    Default = 20,
                    Suffix = "%",
                })

                AnimationSpeedSliderItems["Slider"].Instance.Position = UDim2New(0, 8, 0, 85)
                AnimationSpeedSliderItems["Slider"].Instance.Size = UDim2New(1, -16, 0, 28)
            end

            local IsSyncToggled

            if OtherTab then
                Items["CurrentColor"] = Instances:Create("Frame", {
                    Parent = OtherTabItems["PageContent"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 8, 0, 8),
                    BorderColor3 = FromRGB(42, 49, 45),
                    Size = UDim2New(1, -16, 0, 50),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(157, 175, 255)
                })  Items["CurrentColor"]:AddToTheme({BorderColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = Items["CurrentColor"].Instance,
                    Name = "\0",
                    Color = FromRGB(12, 12, 12),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Instances:Create("UIGradient", {
                    Parent = Items["CurrentColor"].Instance,
                    Name = "\0",
                    Rotation = 82,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(154, 154, 154))}
                })

                Items["RGBColor"] = Instances:Create("TextLabel", {
                    Parent = OtherTabItems["PageContent"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "RGB:",
                    Size = UDim2New(1, -16, 0, 15),
                    Position = UDim2New(0, 8, 0, 65),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    RichText = true,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["HEXColor"] = Instances:Create("TextLabel", {
                    Parent = OtherTabItems["PageContent"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "HEX:",
                    Size = UDim2New(1, -16, 0, 15),
                    Position = UDim2New(0, 8, 0, 85),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    RichText = true,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["HSVColor"] = Instances:Create("TextLabel", {
                    Parent = OtherTabItems["PageContent"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "HSV:",
                    Size = UDim2New(1, -16, 0, 15),
                    Position = UDim2New(0, 8, 0, 105),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    RichText = true,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                local CopyNPasteButton, CopyNPasteButtonItems = Components:Button({
                    Parent = OtherTabItems["PageContent"],
                })

                CopyNPasteButtonItems["Button"].Instance.Position = UDim2New(0, 8, 0, 145)
                CopyNPasteButtonItems["Button"].Instance.Size = UDim2New(1, -16, 0, 20)

                CopyNPasteButton:Add("Copy", function()
                    Library.CopiedColor = Colorpicker.Color
                end)

                CopyNPasteButton:Add("Paste", function()
                    if Library.CopiedColor then
                        Colorpicker:Set(Library.CopiedColor)
                    end
                end)

                local Stash = { }

                IsSyncToggled = false

                local SyncColorpickersToggle, SyncColorpickerToggleItems = Components:Toggle({
                    Parent = OtherTabItems["PageContent"],
                    Flag = "SyncColorpickers"..Colorpicker.Flag,
                    Name = "Sync colorpickers",
                    Default = false,
                    Callback = function(Value)
                        IsSyncToggled = Value
                        if Value then 
                            for Index, Value in Library.Colorpickers do 
                                Stash[Value] = Value.Color
                                Value:Set(Colorpicker.Color)
                            end
                        else
                            for Index, Value in Library.Colorpickers do 
                                if Stash[Value] then
                                    Value:Set(Stash[Value])
                                end
                            end
                        end
                    end
                })

                SyncColorpickerToggleItems["Toggle"].Instance.Position = UDim2New(0, 8, 0, 125)
                SyncColorpickerToggleItems["Toggle"].Instance.Size = UDim2New(1, -16, 0, 12)
            end

            local Debounce = false
            local RenderStepped  

            function Colorpicker:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Colorpicker.IsOpen = Bool

                Debounce = true 

                if Colorpicker.IsOpen then 
                    Items["ColorpickerWindow"].Instance.Visible = true
                    Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance
                    
                    RenderStepped = Library:Connect(RunService.RenderStepped, LPH_NO_VIRTUALIZE(function()
                        Items["ColorpickerWindow"].Instance.Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 5)
                    end))

                    if not Data.Debounce then
                        for Index, Value in Library.OpenFrames do 
                            if Value ~= Colorpicker and Value ~= AnimationsDropdownItems then 
                                Value:SetOpen(false)
                            end
                        end

                        Library.OpenFrames[Colorpicker] = Colorpicker 
                    end
                else
                    if not Data.Debounce then 
                        if Library.OpenFrames[Colorpicker] then 
                            Library.OpenFrames[Colorpicker] = nil
                        end
                    end

                    if RenderStepped then 
                        Library:Disconnect(RenderStepped.Name)
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
                TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                local function onCompleted()
                    Debounce = false 
                    Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
                    task.wait(0.2)
                    Items["ColorpickerWindow"].Instance.Parent = not Colorpicker.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end
                if NewTween then
                    NewTween.Tween.Completed:Connect(onCompleted)
                else
                    onCompleted()
                end
            end

            UpdateSync = function(Bool)
                if IsSyncToggled and Bool then 
                    for Index, Value in Library.Colorpickers do 
                        if Value ~= Colorpicker and not StringFind(Value.Flag, "Theme") then
                            Value:Set(Colorpicker.Color)
                        end
                    end
                end
            end

            function Colorpicker:Update(IsFromAlpha, UpdateSyncc)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = FromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()

                Library.Flags[Colorpicker.Flag] = {
                    Alpha = Colorpicker.Alpha,
                    Color = "#" .. Colorpicker.HexValue
                }

                Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
                Items["ColorpickerButtonInline"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})

                UpdateSync(UpdateSyncc)

                if OtherTab then
                    Items["CurrentColor"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})

                    local Red = MathFloor(Colorpicker.Color.R * 255)
                    local Green = MathFloor(Colorpicker.Color.G * 255)
                    local Blue = MathFloor(Colorpicker.Color.B * 255)
                    local RedGreenBlue = tostring(Red) .. ", " .. tostring(Green) .. ", " .. tostring(Blue)

                    local FloorHue, FloorSat, FloorVal = Library:Round(Hue, 0.01), Library:Round(Saturation, 0.01), Library:Round(Value, 0.01)

                    Items["RGBColor"].Instance.Text = "RGB: " .. Library:ToRich(RedGreenBlue, Colorpicker.Color)
                    Items["HSVColor"].Instance.Text = `HSV: %{Library:ToRich(FloorHue, Colorpicker.Color)}, %{Library:ToRich(FloorSat, Colorpicker.Color)}, %{Library:ToRich(FloorVal, Colorpicker.Color)}`
                    Items["HEXColor"].Instance.Text = "HEX: " .. "#" .. Library:ToRich(Colorpicker.HexValue, Colorpicker.Color)
                end

                Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})

                if not IsFromAlpha then 
                    Items["Alpha"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
                end

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            function Colorpicker:Set(Color, Alpha)
                if type(Color) == "table" then
                    Color = FromRGB(Color[1], Color[2], Color[3])
                    Alpha = Color[4]
                elseif type(Color) == "string" then
                    Color = FromHex(Color)
                end 

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0  

                local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.99)
                local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.99)

                local AlphaPositionX = MathClamp(Colorpicker.Alpha, 0, 0.995)
                    
                local HuePositionY = MathClamp(Colorpicker.Hue, 0, 0.995)

                Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)})
                Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, HuePositionY, 0)})
                Items["AlphaDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(AlphaPositionX, 0, 0, 0)})
                Colorpicker:Update(true, true)
            end

            Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)

            local SlidingPalette = false
            local PaletteChanged
            
            Colorpicker.SlidePalette = LPH_NO_VIRTUALIZE(function(self, Input)
                if not Input or not SlidingPalette then
                    return
                end

                local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY

                local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.99)
                local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.99)

                Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
                Colorpicker:Update(false, true)
            end)
            
            local SlidingHue = false
            local HueChanged

            Colorpicker.SlideHue = LPH_NO_VIRTUALIZE(function(self, Input)
                if not Input or not SlidingHue then
                    return
                end
                
                local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

                Colorpicker.Hue = ValueY

                local SlideY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.995)

                Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, SlideY, 0)})
                Colorpicker:Update(false, true)
            end)

            local SlidingAlpha = false 
            local AlphaChanged

            Colorpicker.SlideAlpha = LPH_NO_VIRTUALIZE(function(self, Input)
                if not Input or not SlidingAlpha then
                    return
                end

                local ValueX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)

                Colorpicker.Alpha = ValueX

                local SlideX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.995)

                Items["AlphaDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, 0, 0)})
                Colorpicker:Update(true, true)
            end)

            Items["Palette"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingPalette = true 

                    Colorpicker:SlidePalette(Input)

                    if PaletteChanged then
                        return
                    end

                    PaletteChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingPalette = false

                            PaletteChanged:Disconnect()
                            PaletteChanged = nil
                        end
                    end)
                end
            end)

            Items["HueInline"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingHue = true 

                    Colorpicker:SlideHue(Input)

                    if HueChanged then
                        return
                    end

                    HueChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingHue = false

                            HueChanged:Disconnect()
                            HueChanged = nil
                        end
                    end)
                end
            end)

            Items["Alpha"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingAlpha = true 

                    Colorpicker:SlideAlpha(Input)

                    if AlphaChanged then
                        return
                    end

                    AlphaChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingAlpha = false

                            AlphaChanged:Disconnect()
                            AlphaChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, LPH_NO_VIRTUALIZE(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement then
                    if SlidingPalette then 
                        Colorpicker:SlidePalette(Input)
                    end

                    if SlidingHue then
                        Colorpicker:SlideHue(Input)
                    end

                    if SlidingAlpha then
                        Colorpicker:SlideAlpha(Input)
                    end
                end
            end))

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Colorpicker.IsOpen then
                        return
                    end

                    if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
                        return
                    end

                    if KeyframeOneLabel and KeyframeTwoLabel then
                        if Library:IsMouseOverFrame(KeyframeOneColorpickerItems["ColorpickerWindow"]) then
                            return
                        end

                        if Library:IsMouseOverFrame(KeyframeTwoColorpickerItems["ColorpickerWindow"]) then
                            return
                        end
                    end

                    Colorpicker:SetOpen(false)
                end
            end)

            if Data.Default then
                Colorpicker:Set(Data.Default, Data.Alpha)
                OldColor = Colorpicker.Color
            end

            Library.Colorpickers[Colorpicker] = Colorpicker

            Library.SetFlags[Colorpicker.Flag] = function(Value, Alpha)
                Colorpicker:Set(Value, Alpha)
            end

            return Colorpicker, Items
        end

        Components.Keybind = function(self, Data)
            local Keybind = { 
                IsOpen = false,

                Key = "",
                Value = "",

                Flag = Data.Flag,

                Mode = "",

                Toggled = false,

                Picking = false
            }

            local KeylistItem

            if Library.KeyList then
                KeylistItem = Library.KeyList:Add("", "", "")
            end

            local Items = { } do
                Items["KeyButton"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    TextTransparency = 0.4000000059604645,
                    Text = "MB2",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 0, 1, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["KeyButton"]:AddToTheme({TextColor3 = "Text"})
                
                Items["KeyButton"]:TextBorder()
                
                Items["KeybindWindow"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Position = UDim2New(0.007692307699471712, 0, 0.35323384404182434, 0),
                    BorderColor3 = FromRGB(12, 12, 12),
                    Size = UDim2New(0, 70, 0, 90),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(14, 17, 15)
                })  Items["KeybindWindow"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Toggle",
                    AutoButtonColor = false,
                    Position = UDim2New(0, 8, 0, 8),
                    Size = UDim2New(1, -16, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(202, 243, 255)
                })  Items["Toggle"]:AddToTheme({BackgroundColor3 = "Accent", TextColor3 = "Text"})

                Items["Toggle"]:TextBorder()

                Instances:Create("UIStroke", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Items["Hold"] = Instances:Create("TextButton", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Hold",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0, 38),
                    Size = UDim2New(1, -16, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(202, 243, 255)
                })  Items["Hold"]:AddToTheme({BackgroundColor3 = "Accent", TextColor3 = "Text"})

                Items["Hold"]:TextBorder()

                Items["Always"] = Instances:Create("TextButton", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Always",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0, 68),
                    Size = UDim2New(1, -16, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(202, 243, 255)
                })  Items["Always"]:AddToTheme({BackgroundColor3 = "Accent", TextColor3 = "Text"})  

                Items["Always"]:TextBorder()
            end

            local Modes = {
                ["Toggle"] = Items["Toggle"],
                ["Hold"] = Items["Hold"],
                ["Always"] = Items["Always"]
            }

            local Update = function()
                if KeylistItem then
                    KeylistItem:SetText(Keybind.Value, Data.Name, Keybind.Mode)
                    KeylistItem:SetStatus(Keybind.Toggled)
                end
            end

            function Keybind:Get()
                return Keybind.Key, Keybind.Mode, Keybind.Toggled
            end

            function Keybind:Set(Key)
                if StringFind(tostring(Key), "Enum") then 
                    Keybind.Key = tostring(Key)

                    Key = Key.Name == "Backspace" and "None" or Key.Name

                    local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                    local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay

                    -- If this keybind is marked as the menu key, keep Library.MenuKeybind in sync
                    if Data.IsMenuKey then
                        Library.MenuKeybind = Keybind.Key
                    end

                    Library.Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif type(Key) == "table" then
                    local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                    Keybind.Key = tostring(Key.Key)

                    if Key.Mode then
                        Keybind.Mode = Key.Mode
                        Keybind:SetMode(Key.Mode)
                    else
                        Keybind.Mode = "Toggle"
                        Keybind:SetMode("Toggle")
                    end

                    local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                    local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                    TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay

                    -- Sync menu keybind if flagged
                    if Data.IsMenuKey then
                        Library.MenuKeybind = Keybind.Key
                    end

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif TableFind({"Toggle", "Hold", "Always"}, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode(Keybind.Mode)

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                end

                Keybind.Picking = false
            end

            local Debounce = false
            local RenderSteppedConnection  

            function Keybind:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Keybind.IsOpen = Bool

                Debounce = true 

                if Keybind.IsOpen then 
                    Items["KeybindWindow"].Instance.Visible = true
                    Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance
                    
                    RenderSteppedConnection = Library:Connect(RunService.RenderStepped, LPH_NO_VIRTUALIZE(function()
                        Items["KeybindWindow"].Instance.Position = UDim2New(0, Items["KeyButton"].Instance.AbsolutePosition.X, 0, Items["KeyButton"].Instance.AbsolutePosition.Y + Items["KeyButton"].Instance.AbsoluteSize.Y + 5)
                    end))

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= Keybind then 
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Keybind] = Keybind 
                else
                    if Library.OpenFrames[Keybind] then 
                        Library.OpenFrames[Keybind] = nil
                    end

                    if RenderSteppedConnection then 
                        Library:Disconnect(RenderSteppedConnection.Name)
                        RenderSteppedConnection = nil
                    end
                end

                local Descendants = Items["KeybindWindow"].Instance:GetDescendants()
                TableInsert(Descendants, Items["KeybindWindow"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                local function onCompleted()
                    Debounce = false 
                    Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
                    task.wait(0.2)
                    Items["KeybindWindow"].Instance.Parent = not Keybind.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end
                if NewTween then
                    NewTween.Tween.Completed:Connect(onCompleted)
                else
                    onCompleted()
                end
            end

            function Keybind:SetMode(Mode)
                for Index, Value in Modes do 
                    if Index == Mode then
                        Value:Tween(nil, {BackgroundTransparency = 0})
                    else
                        Value:Tween(nil, {BackgroundTransparency = 1})
                    end
                end

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end

            function Keybind:Press(Bool)
                if Keybind.Mode == "Toggle" then 
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "Hold" then 
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "Always" then 
                    Keybind.Toggled = true
                end

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end

            Items["KeyButton"]:Connect("MouseButton1Click", function()
                Keybind.Picking = true 

                Items["KeyButton"].Instance.Text = "."
                Library:Thread(function()
                    local Count = 1

                    while true do 
                        if not Keybind.Picking then 
                            break
                        end

                        if Count == 4 then
                            Count = 1
                        end

                        Items["KeyButton"].Instance.Text = Count == 1 and "." or Count == 2 and ".." or Count == 3 and "..."
                        Count += 1
                        task.wait(0.5)
                    end
                end)

                local InputBegan
                InputBegan = UserInputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.Keyboard then 
                        Keybind:Set(Input.KeyCode)
                    else
                        Keybind:Set(Input.UserInputType)
                    end

                    InputBegan:Disconnect()
                    InputBegan = nil
                end)
            end)

            Items["KeyButton"]:Connect("MouseButton2Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Keybind.Value == "None" then
                    return
                end

                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Toggle" then 
                        Keybind:Press()
                    elseif Keybind.Mode == "Hold" then 
                        Keybind:Press(true)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Toggle" then 
                        Keybind:Press()
                    elseif Keybind.Mode == "Hold" then 
                        Keybind:Press(true)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Keybind.IsOpen then
                        return
                    end

                    if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
                        return
                    end

                    Keybind:SetOpen(false)
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Keybind.Value == "None" then
                    return
                end

                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                end
            end)

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Toggle"
                Keybind:SetMode("Toggle")
            end)

            Items["Hold"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Hold"
                Keybind:SetMode("Hold")
            end)

            Items["Always"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Always"
                Keybind:SetMode("Always")
            end)

            if Data.Default then
                Keybind:Set({Key = Data.Default, Mode = Data.Mode or "Toggle"})
            end

            Library.SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items 
        end

        Components.Textbox = function(self, Data)
            local Textbox = {
                Flag = Data.Flag,
                Value = ""
            }

            local Items = { } do
                Items["Textbox"] = Instances:Create("Frame", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 40),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Items["Text"]:TextBorder()

                Items["Background"] = Instances:Create("Frame", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(12, 12, 12),
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(30, 36, 31)
                })  Items["Background"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

                Instances:Create("UIGradient", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    Rotation = -165,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(208, 208, 208))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme.Gradient)}
                end})

                Instances:Create("UIStroke", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    PlaceholderColor3 = FromRGB(185, 185, 185),
                    PlaceholderText = Data.Placeholder,
                    TextSize = 13,
                    Size = UDim2New(1, 0, 1, 0),
                    ClipsDescendants = true,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    TextColor3 = FromRGB(235, 235, 235),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2New(0, 0, 0, 0),
                    ClearTextOnFocus = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Input"]:AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Placeholder Text"})

                Items["Input"]:TextBorder()

                Instances:Create("UIPadding", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    PaddingLeft = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8)
                })
            end

            function Textbox:Get()
                return Textbox.Value
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:Set(Value)
                if Data.Numeric then
                    if (not tonumber(Value)) and StringLen(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Library.Flags[Textbox.Flag] = Value

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Value)
                end
            end
            
            if Data.Finished then 
                Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            else
                Items["Input"].Instance:GetPropertyChangedSignal("Text"):Connect(function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            if Data.Default then
                Textbox:Set(Data.Default)
            end

            Library.SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return Textbox, Items
        end

        Components.Searchbox = function(self, Data) -- just pasted the entire dropdown fucntion with different instances, i cant be asked to make a whole new functionality
            local Dropdown = {
                Flag = Data.Flag, 
                Value = { },
                Options = { },
                IsOpen = false
            }

            local Items = { } do
                Items["Listbox"] = Instances:Create("Frame", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 185),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Search"] = Instances:Create("Frame", {
                    Parent = Items["Listbox"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 0.4000000059604645,
                    Size = UDim2New(0, 0, 0, 20),
                    BorderColor3 = FromRGB(12, 12, 12),
                    BorderSizePixel = 2,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(14, 17, 15)
                })  Items["Search"]:AddToTheme({BorderColor3 = "Border", BackgroundColor3 = "Background"})

                Instances:Create("UIStroke", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Transparency = 0.4000000059604645,
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter
                }):AddToTheme({Color = "Outline"})

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = "rbxassetid://71197946135150",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    Size = UDim2New(0, 50, 0, 50),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Icon"]:AddToTheme({ImageColor3 = "Text"})

                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    Size = UDim2New(0, 0, 1, 0),
                    Position = UDim2New(0, 22, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    PlaceholderColor3 = FromRGB(185, 185, 185),
                    AutomaticSize = Enum.AutomaticSize.X,
                    PlaceholderText = "search..",
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Input"]:AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Placeholder Text"})

                Items["Input"]:TextBorder()

                Instances:Create("UIPadding", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 5),
                    PaddingLeft = UDimNew(0, 3)
                })

                Items["RealListbox"] = Instances:Create("Frame", {
                    Parent = Items["Listbox"].Instance,
                    Name = "\0",
                    ClipsDescendants = true,
                    BorderColor3 = FromRGB(12, 12, 12),
                    Size = UDim2New(1, 0, 1, -28),
                    SelectionGroup = true,
                    Position = UDim2New(0, 0, 0, 28),
                    Selectable = true,
                    Active = true,
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(30, 36, 31)
                })  Items["RealListbox"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

                Instances:Create("UIStroke", {
                    Parent = Items["RealListbox"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Instances:Create("UIGradient", {
                    Parent = Items["RealListbox"].Instance,
                    Name = "\0",
                    Rotation = -165,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(208, 208, 208))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme.Gradient)}
                end})

                Items["List"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["RealListbox"].Instance,
                    Name = "\0",
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    ScrollBarImageColor3 = FromRGB(202, 243, 255),
                    MidImage = "rbxassetid://136419474381965",
                    BorderColor3 = FromRGB(0, 0, 0),
                    ScrollBarThickness = 2,
                    Size = UDim2New(1, -12, 1, -10),
                    Position = UDim2New(0, 3, 0, 5),
                    TopImage = "rbxassetid://136419474381965",
                    CanvasPosition = Vector2New(0, 0),
                    BottomImage = "rbxassetid://136419474381965",
                    BackgroundTransparency = 1,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["List"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

                Instances:Create("UIListLayout", {
                    Parent = Items["List"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["List"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 5),
                })
            end

            function Dropdown:Get()
                return Dropdown.Value
            end

            function Dropdown:SetVisibility(Bool)
                Items["Listbox"].Instance.Visible = Bool
            end

            function Dropdown:Set(Option)
                if Data.Multi then 
                    if type(Option) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Option do
                        local OptionData = Dropdown.Options[Value]
                        
                        if not OptionData then
                            continue
                        end

                        OptionData.Selected = true 
                        OptionData:Toggle("Active")
                    end
                else
                    if not Dropdown.Options[Option] then
                        return
                    end

                    local OptionData = Dropdown.Options[Option]

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.Selected = false 
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true 
                            Value:Toggle("Active")
                        end
                    end
                end

                if Data.Callback then   
                    Library:SafeCall(Data.Callback, Dropdown.Value)
                end
            end

            function Dropdown:Add(Option)
                local OptionButton = Instances:Create("TextButton", {
                    Parent = Items["List"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Option,
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2New(1, 0, 0, 20),
                    ZIndex = 1,
                    TextSize = 13,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  OptionButton:AddToTheme({TextColor3 = "Text"})

                OptionButton:TextBorder()

                local OptionData = {
                    Button = OptionButton,
                    Name = Option,
                    Selected = false
                }

                function OptionData:Toggle(Status)
                    if Status == "Active" then 
                        OptionData.Button:ChangeItemTheme({TextColor3 = "Accent"})
                        OptionData.Button:Tween(nil, {TextColor3 = Library.Theme.Accent})
                    else
                        OptionData.Button:ChangeItemTheme({TextColor3 = "Text"}) 
                        OptionData.Button:Tween(nil, {TextColor3 = Library.Theme.Text})
                    end
                end

                function OptionData:Set()
                    OptionData.Selected = not OptionData.Selected

                    if Data.Multi then 
                        local Index = TableFind(Dropdown.Value, OptionData.Name)

                        if Index then 
                            TableRemove(Dropdown.Value, Index)
                        else
                            TableInsert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:Toggle(Index and "Inactive" or "Active")

                        Library.Flags[Dropdown.Flag] = Dropdown.Value
                    else
                        if OptionData.Selected then 
                            Dropdown.Value = OptionData.Name
                            Library.Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.Selected = true
                            OptionData:Toggle("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.Selected = false 
                                    Value:Toggle("Inactive")
                                end
                            end
                        else
                            Dropdown.Value = nil
                            Library.Flags[Dropdown.Flag] = nil

                            OptionData.Selected = false
                            OptionData:Toggle("Inactive")
                        end
                    end

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Dropdown.Value)
                    end
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if not Dropdown.Options[Option] then
                    return
                end

                Dropdown.Options[Option].Button:Clean()
                Dropdown.Options[Option] = nil
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do 
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do 
                    Dropdown:Add(Value)
                end
            end

            Items["Listbox"]:OnHover(function()
                Items["Listbox"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
                Items["Listbox"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
            end)

            Items["Listbox"]:OnHoverLeave(function()
                Items["Listbox"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
                Items["Listbox"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
            end)

            local SearchStepped

            Items["Input"]:Connect("Focused", function()
                SearchStepped = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
                    for Index, Value in Dropdown.Options do
                        if Items["Input"].Instance.Text ~= "" then
                            if StringFind(StringLower(Value.Name), StringLower(Items["Input"].Instance.Text)) then
                                Value.Button.Instance.Visible = true
                            else
                                Value.Button.Instance.Visible = false
                            end
                        else
                            Value.Button.Instance.Visible = true
                        end
                    end
                end))
            end)

            Items["Input"]:Connect("FocusLost", function()
                if SearchStepped then
                    Library:Disconnect(SearchStepped.Name)
                end
            end)

            for Index, Value in Data.Items do 
                Dropdown:Add(Value)
            end

            if Data.Default then 
                Dropdown:Set(Data.Default)
            end

            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return Dropdown, Items 
        end
    end

    -- Library components
    Library.Watermark = function(self, Name)
        local Watermark = { }

        local Items = { } do 
            Items["Watermark"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0.5, 1),
                Position = UDim2New(0.5, 0, 1, -16),
                BorderColor3 = FromRGB(28, 34, 41),
                BorderSizePixel = 1,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(20, 24, 29)
            })  Items["Watermark"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Outline"})

            Items["Watermark"]:MakeDraggable()

            Instances:Create("UIStroke", {
                Parent = Items["Watermark"].Instance,
                Name = "\0",
                Color = FromRGB(42, 49, 45),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"})

            Instances:Create("UIPadding", {
                Parent = Items["Watermark"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 4),
                PaddingBottom = UDimNew(0, 4),
                PaddingRight = UDimNew(0, 6),
                PaddingLeft = UDimNew(0, 6)
            })

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Watermark"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Name,
                Position = UDim2New(0, 0, 0, 4),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 8,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Items["Liner"] = Instances:Create("Frame", {
                Parent = Items["Watermark"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 0),
                Position = UDim2New(0, 0, 1, 2),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 0, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(190, 120, 225),
                BackgroundTransparency = 1
            })
        end

        function Watermark:SetVisibility(Bool)
            Items["Watermark"].Instance.Visible = Bool
        end

        function Watermark:SetText(Text)
            Items["Text"].Instance.Text = Text
            local bounds = Items["Text"].Instance.TextBounds
            Items["Liner"].Instance.Size = UDim2New(0, math.max(bounds.X + 10, 8), 0, 1.5)
            Items["Liner"].Instance.Position = UDim2New(0, 0, 1, 1)
        end

        return Watermark
    end

    Library.KeybindList = function(self)
        local KeybindList = { }

        local Items = { } do
            Items["KeybindList"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 0.5),
                Position = UDim2New(0, 12, 0.5, 55),
                BorderColor3 = FromRGB(12, 12, 12),
                Size = UDim2New(0, 0, 0, 0),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = FromRGB(14, 17, 15)
            })  Items["KeybindList"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["KeybindList"]:MakeDraggable()

            Instances:Create("UIStroke", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                Color = FromRGB(42, 49, 45),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"})

            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Keybinds",
                Size = UDim2New(0, 0, 0, 20),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 9,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

            Items["Title"]:TextBorder()

            Instances:Create("UIPadding", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 8),
                PaddingBottom = UDimNew(0, 8),
                PaddingRight = UDimNew(0, 8),
                PaddingLeft = UDimNew(0, 8)
            })

            Items["Liner"] = Instances:Create("Frame", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 20),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 0, 0, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(202, 243, 255),
                BackgroundTransparency = 1
            })

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 24),
                Size = UDim2New(0, 0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end

        local showKeybindList = true

        local function updateSize()
            local activeCount = 0
            for _, child in ipairs(Items["Content"].Instance:GetChildren()) do
                if child:IsA("TextLabel") and child.Visible then
                    activeCount = activeCount + 1
                end
            end
            if activeCount == 0 or not showKeybindList then
                Items["KeybindList"].Instance.Visible = false
            else
                Items["KeybindList"].Instance.Visible = true
                -- Only set height; X is driven by AutomaticSize so the frame
                -- expands to fit whichever keybind label is widest.
                        local height = 32 + (activeCount * 15) + ((activeCount - 1) * 2)
                Items["KeybindList"].Instance.Size = UDim2New(0, 0, 0, height)
            end
        end

        function KeybindList:AddKeybind(NewKey)
            NewKey.Instance.Parent = Items["Content"].Instance
            updateSize()
        end

        function KeybindList:Add(Key, Name, Mode)
            local NewKey = self:CreateKeybind()
            NewKey:SetText(Key, Name, Mode)
            NewKey:SetStatus(true)
            return NewKey
        end

        function KeybindList:CreateKeybind()
            local NewKey = Instances:Create("TextLabel", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 9,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  NewKey:AddToTheme({TextColor3 = "Text"})

            NewKey:TextBorder()

            function NewKey:SetText(Key, Name, Mode)
                NewKey.Instance.Text = "" .. Key .. " - " .. Name .. " (" .. Mode .. ")"
            end

            function NewKey:SetStatus(Bool)
                if Bool then
                    NewKey.Instance.Visible = true
                    NewKey:Tween(nil, {TextTransparency = 0})
                    updateSize()
                else
                    NewKey:Tween(nil, {TextTransparency = 1}).Tween.Completed:Connect(function()
                        NewKey.Instance.Visible = false
                        updateSize()
                    end)
                end
            end

            return NewKey
        end

        function KeybindList:SetVisibility(Bool)
            showKeybindList = Bool
            if not Bool then
                Items["KeybindList"].Instance.Visible = false
            else
                updateSize()
            end
        end

        Library.KeyList = KeybindList
        return KeybindList
    end

    Library.Notification = function(self, Title, Description, Duration, Icon)
        return self:Notify(Title, Duration, Description, Icon)
    end

    Library.Window = function(self, Data)
        Data = Data or { }

        local Window = { 
            Name = Data.Name or Data.name or "alternate",
            Logo = Data.Logo or Data.logo or "",
            FadeTime = Data.FadeTime or Data.fadetime or 0.25,
            Size = Data.Size or Data.size or UDim2New(0, 500, 0, 480),

            Pages = { },
            Items = { },

            IsOpen = false,
        }

        local Items = Components:Window({
            Parent = Library.Holder,
            Draggable = true,
            Resizeable = true,
            AnchorPoint = Vector2New(0.5, 0.5),
            Position = UDim2New(0.5, 0, 0.5, 0),
            Size = Window.Size
        }) do
            Items["MainFrame"] = Items["Window"]
            Items["MainFrame"]:MakeDraggable()
            Items["MainFrame"]:MakeResizeable(Vector2New(Window.Size.X.Offset, Window.Size.Y.Offset), Vector2New(9999, 9999))

            Items["AccentBorder"] = Instances:Create("UIStroke", {
                Parent = Items["MainFrame"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(210, 180, 80)
            })  Items["AccentBorder"]:AddToTheme({Color = "Accent"})
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["MainFrame"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(240, 240, 240),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Window.Name,
                Name = "\0",
                Size = UDim2New(1, -14, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Center,
                Position = UDim2New(0, 7, 0, 1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Stroke"})
            
            Items["Inline"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance,
                Name = "\0",
                Position = UDim2New(0, 7, 0, 20),
                BorderColor3 = FromRGB(27, 27, 32),
                Size = UDim2New(1, -14, 1, -27),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["Inline"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Inline"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Library.Theme.Border,
                Name = "\0"
            }):AddToTheme({Color = "Border"})

            Items["Window"].Instance.Visible = false

            Items["Pages"] = Instances:Create("ScrollingFrame", {
                Parent = Items["Inline"].Instance,
                Name = "\0",
                Active = true,
                BackgroundTransparency = 1,
                ScrollingEnabled = false,
                ScrollBarThickness = 0,
                ScrollBarImageColor3 = FromRGB(210, 180, 80),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                Position = UDim2New(0, 7, 0, 7),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 108, 1, -14),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(14, 14, 14)
            })
            
            Instances:Create("UIPadding", {
                Parent = Items["Pages"].Instance,
                PaddingTop = UDimNew(0, 10),
                PaddingBottom = UDimNew(0, 9),
                PaddingLeft = UDimNew(0, 5),
                PaddingRight = UDimNew(0, 5)
            })

            Instances:Create("UIListLayout", {
                Parent = Items["Pages"].Instance,
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly
            })
            
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Inline"].Instance,
                Name = "\0",
                Position = UDim2New(0, 115, 0, 7),
                BorderColor3 = FromRGB(15, 15, 15),
                Size = UDim2New(1, -125, 1, -14),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(12, 12, 12)
            })  Items["Content"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
        
            Instances:Create("UIStroke", {
                Parent = Items["Content"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Library.Theme.Outline,
                Name = "\0"
            }):AddToTheme({Color = "Outline"})



            Window.Items = Items
        end

        local Debounce = false





        local OldSizes = { }

        function Window:AddToOldSizes(Item, Size)
            if not OldSizes[Item] then
                OldSizes[Item] = Size
            end
        end

        function Window:GetOldSize(Item)
            if OldSizes[Item] then
                return OldSizes[Item]
            end
        end

        function Window:SetOpen(Bool)
            if not Items or not Items["Window"] or not Items["Window"].Instance then
                return
            end

            if Bool == nil then
                Bool = not Window.IsOpen
            end

            Window.IsOpen = Bool
            -- Only toggle the top-level window frame. Children that live in
            -- UnusedHolder (inactive pages/subpages) must NOT be touched here;
            -- the recursive SetGuiVisibility was making those orphaned frames
            -- visible and causing section bleed across tabs/subtabs after hide.
            Items["Window"].Instance.Visible = Bool

            if Items["MouseBackground"] and Items["MouseBackground"].Instance then
                pcall(function()
                    Items["MouseBackground"].Instance.Visible = Bool
                end)
            end

            if Library.KeyList and Library.KeyList.SetVisibility then
                if Bool then
                    local flags = Library.Flags or {}
                    local showKeylist = true
                    if flags["ShowKL"] ~= nil then
                        showKeylist = flags["ShowKL"] ~= false
                    end
                    Library.KeyList:SetVisibility(showKeylist)
                else
                    Library.KeyList:SetVisibility(false)
                end
            end

            UserInputService.MouseIconEnabled = true
        end

        function Window:Hide()
            self:SetOpen(false)
        end

        function Window:Show()
            self:SetOpen(true)
        end

        function Window:CreateTab(Data)
            return self:Page(Data)
        end

        Library:Connect(UserInputService.InputBegan, function(Input)
            local menuKey = tostring(Library.MenuKeybind)
            if tostring(Input.KeyCode) == menuKey or tostring(Input.UserInputType) == menuKey then
                Window:SetOpen(not Window.IsOpen)
            end
        end)



        Window:SetOpen(true)
        return setmetatable(Window, self)
    end

    Library.Page = function(self, Data)
        Data = Data or { }

        local Page = {
            Window = self,

            Name = Data.Name or Data.name or "",
            Icon = Data.Icon or Data.icon,
            Columns = Data.Columns or Data.columns or 2,
            SubPages = Data.SubPages or Data.subpages or false,
        }

        Library.SearchItems[Page] = { }

        local NewPage, Items = Components:WindowPage({
            Name = Page.Name,
            Icon = Data.Icon or Data.icon,
            ContentHolder = Page.Window.Items["Content"],
            Stack = Page.Window.Pages,
            Parent = Page.Window.Items["Pages"],
            Columns = Page.Columns,
            SubPages = Page.SubPages,
            FadeTime = Page.Window.FadeTime,
            Window = Page.Window,
            FullHeight = true
        })

        return setmetatable(NewPage, Library.Pages)
    end

    Library.Pages.SubPage = function(self, Data)
        Data = Data or { }

        local SubPage = {
            Window = self.Window,
            Page = self,

            Name = Data.Name or Data.name or "SubPage",
            Icon = Data.Icon or Data.icon,
            Columns = Data.Columns or Data.columns or 2,
        }

        Library.SearchItems[SubPage] = { }

        local NewSubPage, Items = Components:WindowSubPage({
            Page = SubPage.Page,
            Name = SubPage.Name,
            Icon = Data.Icon or Data.icon,
            Columns = SubPage.Columns,
            Window = SubPage.Page.Window,
            FullHeight = true
        })

        return setmetatable(NewSubPage, Library.Pages)
    end
    
    Library.Pages.Playerlist = function(self, Data)
        local Playerlist = {
            Window = self.Window,
            Page = self,

            CurrentPlayer = nil,

            Players = { }
        }

        local Items = { } do 
            Playerlist.Page.Items.Page.Instance:FindFirstChildOfClass("UIListLayout"):Destroy()

            Items["Playerlist"] = Instances:Create("Frame", {
                Parent = Playerlist.Page.Items["Page"].Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 1),
                BorderColor3 = FromRGB(42, 49, 45),
                Size = UDim2New(1, 0, 1, -8),
                BorderSizePixel = 1,
                BackgroundColor3 = FromRGB(20, 24, 21),
                ClipsDescendants = true
            })  Items["Playerlist"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Outline"})

            Instances:Create("UIStroke",{
                Parent = Items["Playerlist"].Instance,
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Color = FromRGB(202, 243, 255),
                Thickness = 1
            }):AddToTheme({Color = "Border"})

            Items["RealPlayerlist"] = Instances:Create("Frame", {
                Parent = Items["Playerlist"].Instance,
                Name = "\0",
                Position = UDim2New(0, 8, 0, 8),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -16, 1, -105),
                BorderSizePixel = 1,
                BackgroundColor3 = FromRGB(14, 17, 15),
                ClipsDescendants = true
            })  Items["RealPlayerlist"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Instances:Create("UIStroke",{
                Parent = Items["RealPlayerlist"].Instance,
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Color = FromRGB(202, 243, 255),
                Thickness = 1
            }):AddToTheme({Color = "Outline"})

            Items["PlayerHolder"] = Instances:Create("ScrollingFrame", {
                Parent = Items["RealPlayerlist"].Instance,
                Name = "\0",
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BorderSizePixel = 0,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarImageColor3 = FromRGB(255, 255, 255),
                MidImage = "rbxassetid://86918736894927",
                BorderColor3 = FromRGB(0, 0, 0),
                ScrollBarThickness = 2,
                Size = UDim2New(1, -16, 1, -8),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 8, 0, 4),
                BottomImage = "rbxassetid://86918736894927",
                TopImage = "rbxassetid://86918736894927",
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["PlayerHolder"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

            Instances:Create("UIListLayout", {
                Parent = Items["PlayerHolder"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Instances:Create("UIPadding", {
                Parent = Items["PlayerHolder"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 2),
                PaddingBottom = UDimNew(0, 2),
                PaddingRight = UDimNew(0, 12),
                PaddingLeft = UDimNew(0, 2)
            })

            Items["PlayerAvatar"] = Instances:Create("ImageLabel", {
                Parent = Items["Playerlist"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                Image = "rbxassetid://98200387761744",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 8, 1, -10),
                Size = UDim2New(0, 65, 0, 65),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["PlayerUserID"] = Instances:Create("TextLabel", {
                Parent = Items["Playerlist"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "???",
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 80, 1, -60),
                BorderSizePixel = 0,
                ZIndex = 2,
                TextSize = 9,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["PlayerUserID"]:AddToTheme({TextColor3 = "Text"})

            Items["PlayerUserID"]:TextBorder()

            Items["PlayerAccountAge"] = Instances:Create("TextLabel", {
                Parent = Items["Playerlist"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "???",
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 80, 1, -40),
                BorderSizePixel = 0,
                ZIndex = 2,
                TextSize = 9,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["PlayerAccountAge"]:AddToTheme({TextColor3 = "Text"})

            Items["PlayerAccountAge"]:TextBorder()

            Items["PlayerUsername"] = Instances:Create("TextLabel", {
                Parent = Items["Playerlist"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "???",
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 80, 1, -78),
                BorderSizePixel = 0,
                ZIndex = 2,
                TextSize = 9,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["PlayerUsername"]:AddToTheme({TextColor3 = "Text"})

            Items["PlayerUsername"]:TextBorder()
        end

        Playerlist.Buttons = {}
        
        local ActionsFrame = Instances:Create("Frame", {
            Parent = Items["Playerlist"].Instance,
            Name = "ActionsFrame",
            AnchorPoint = Vector2New(1, 1),
            Position = UDim2New(1, -8, 1, -8),
            Size = UDim2New(0, 252, 0, 48),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        })
        
        local Grid = Instances:Create("UIGridLayout", {
            Parent = ActionsFrame.Instance,
            CellSize = UDim2New(0, 59, 0, 20),
            CellPadding = UDim2New(0, 4, 0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        local actionNames = {"Target", "Whitelist", "Spectate", "Teleport", "Ignore Wall", "Ignore Dead", "Ignore Team"}
        for i, name in ipairs(actionNames) do
            local btn = Instances:Create("TextButton", {
                Parent = ActionsFrame.Instance,
                Name = name,
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text,
                Text = name,
                AutoButtonColor = false,
                Size = UDim2New(0, 59, 0, 20),
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Element,
                TextSize = 8,
            })
            btn:AddToTheme({BackgroundColor3 = "Element", TextColor3 = "Text"})
            btn:TextBorder()
            
            Playerlist.Buttons[name] = btn
            
            btn.Instance.MouseButton1Down:Connect(function()
                if Playerlist.Player then
                    if Playerlist.Player == game.Players.LocalPlayer then
                        return -- Do not work on self
                    end
                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Playerlist.Player, name)
                    end
                end
            end)
        end

        function Playerlist:Add(Player)
            local PlayerItems = { }

            PlayerItems["NewPlayer"] = Instances:Create("TextButton", {
                Parent = Items["PlayerHolder"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 20),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            PlayerItems["Name"] = Instances:Create("TextLabel", {
                Parent = PlayerItems["NewPlayer"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Player.Name,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(0.33, 0, 0, 15),
                BorderSizePixel = 0,
                TextSize = 9,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  PlayerItems["Name"]:AddToTheme({TextColor3 = "Text"})

            local Team = Player.Team ~= nil and Player.Team.Name or "None"
            local TeamColor = Player.TeamColor ~= nil and BrickColor.new(tostring(Player.TeamColor)).Color or Color3.new(1, 1, 1)

            PlayerItems["Team"] = Instances:Create("TextLabel", {
                Parent = PlayerItems["NewPlayer"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = TeamColor,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Team,
                AnchorPoint = Vector2New(0.5, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0, 0),
                Size = UDim2New(0.34, 0, 0, 15),
                BorderSizePixel = 0,
                TextSize = 9,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            PlayerItems["Status"] = Instances:Create("TextLabel", {
                Parent = PlayerItems["NewPlayer"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Neutral",
                Size = UDim2New(0.33, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                Position = UDim2New(0.67, 0, 0, 0),
                BorderSizePixel = 0,
                TextSize = 9,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            PlayerItems["Liner"] = Instances:Create("Frame", {
                Parent = PlayerItems["NewPlayer"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, -1),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(42, 49, 45)
            })  PlayerItems["Liner"]:AddToTheme({BackgroundColor3 = "Outline"})

            if Player == LocalPlayer then
                PlayerItems["Status"].Instance.TextColor3 = Color3.fromRGB(255, 100, 100)
                PlayerItems["Status"].Instance.Text = "SELF"
                PlayerItems["Name"].Instance.TextColor3 = Color3.fromRGB(255, 100, 100)
            end

            local PlayerData = {
                Name = Player.Name,
                Selected = false,
                PlayerButton = PlayerItems["NewPlayer"],
                PlayerName = PlayerItems["Name"],
                PlayerTeam = PlayerItems["Team"],
                PlayerStatus = PlayerItems["Status"],
                Player = Player
            }

            function PlayerData:Toggle(Status)
                if Status == "Active" then
                    PlayerItems["Name"]:ChangeItemTheme({TextColor3 = "Accent"})
                    PlayerItems["Name"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
                else
                    PlayerItems["Name"]:ChangeItemTheme({TextColor3 = "Text"})
                    PlayerItems["Name"]:Tween(nil, {TextColor3 = Library.Theme.Text})
                end
            end

            function PlayerData:Set()
                PlayerData.Selected = not PlayerData.Selected

                if PlayerData.Selected then
                    Playerlist.Player = PlayerData.Player

                    for Index, Value in Playerlist.Players do 
                        Value.Selected = false
                        Value:Toggle("Inactive")
                    end

                    PlayerData:Toggle("Active")

                    local PlayerAvatar = Players:GetUserThumbnailAsync(Playerlist.Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                    Items["PlayerAvatar"].Instance.Image = PlayerAvatar
                    Items["PlayerUsername"].Instance.Text = Playerlist.Player.DisplayName .. " (@" .. Playerlist.Player.Name .. ")"
                    Items["PlayerUserID"].Instance.Text = tostring(Playerlist.Player.UserId)
                    Items["PlayerAccountAge"].Instance.Text = tostring(Playerlist.Player.AccountAge) .. " days old"
                    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Playerlist.Player, "Select")
                    end
                else
                    Playerlist.Player = nil
                    PlayerData:Toggle("Inactive")
                    Items["PlayerAvatar"].Instance.Image = "rbxassetid://98200387761744"
                    Items["PlayerUsername"].Instance.Text = "None"
                    Items["PlayerUserID"].Instance.Text = "None"
                    Items["PlayerAccountAge"].Instance.Text = "None"
                    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, nil, "Deselect")
                    end
                end
            end

            PlayerItems["NewPlayer"]:Connect("MouseButton1Down", function()
                PlayerData:Set()
            end)

            Playerlist.Players[Player.Name] = PlayerData
            return PlayerData
        end

        function Playerlist:Remove(Name)
            if Playerlist.Players[Name] then
                Playerlist.Players[Name].PlayerButton:Clean()
            end
                
            Playerlist.Players[Name] = nil
        end

        for Index, Value in Players:GetPlayers() do 
            Playerlist:Add(Value)
        end

        Library:Connect(Players.PlayerRemoving, function(Player)
            if Playerlist.Players[Player.Name] then 
                Playerlist:Remove(Player.Name)
            end
        end)

        Library:Connect(Players.PlayerAdded, function(Player)
            Playerlist:Add(Player)
        end)

        function Playerlist:SetButtonState(actionName, state)
            local btn = self.Buttons[actionName]
            if btn then
                if state then
                    btn.Instance.BackgroundColor3 = Library.Theme.Accent
                    btn.Instance.TextColor3 = Library.Theme.Background
                else
                    btn.Instance.BackgroundColor3 = Library.Theme.Element
                    btn.Instance.TextColor3 = Library.Theme.Text
                end
            end
        end
        
        function Playerlist:UpdatePlayerTags(PlayerName, tagsString, isAlternate)
            local pData = self.Players[PlayerName]
            if pData then
                pData.PlayerName.Instance.Text = pData.Player.Name .. (tagsString ~= "" and (" " .. tagsString) or "")
                if isAlternate ~= nil then
                    if isAlternate then
                        pData.PlayerStatus.Instance.Text = "Alternate"
                        pData.PlayerStatus.Instance.TextColor3 = Color3.fromRGB(80, 255, 80)
                    elseif pData.Player ~= LocalPlayer then
                        pData.PlayerStatus.Instance.Text = "Neutral"
                        pData.PlayerStatus.Instance.TextColor3 = Color3.fromRGB(235, 235, 235)
                    end
                end
            end
        end

        return Playerlist
    end

    Library.Pages.Section = function(self, Data)
        Data = Data or { }

        local Section = {
            Window = self.Window,
            Page = self,

            Name = Data.Name or Data.name or "Section",
            Side = Data.Side or Data.side or 1,

            Items = { }
        }

        if type(Section.Side) == "string" then
            Section.Side = Section.Side == "Left" and 1 or 2
        end

        local Items = { } do
            local sectionParent
            if Section.Page.ColumnsData and Section.Page.ColumnsData[Section.Side] and Section.Page.ColumnsData[Section.Side].Instance then
                sectionParent = Section.Page.ColumnsData[Section.Side].Instance
            elseif Section.Page.Items and Section.Page.Items["Columns"] and Section.Page.Items["Columns"].Instance then
                sectionParent = Section.Page.Items["Columns"].Instance
            elseif Section.Page.Items and Section.Page.Items["Page"] and Section.Page.Items["Page"].Instance then
                sectionParent = Section.Page.Items["Page"].Instance
            elseif Library.Holder and Library.Holder.Instance then
                sectionParent = Library.Holder.Instance
            end

            Items["Section"] = Instances:Create("Frame", {
                Parent = sectionParent,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 28),
                BorderColor3 = FromRGB(42, 49, 45),
                BorderSizePixel = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(18, 18, 18)
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Outline"})

            Items["Section"]:Border("Border")

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Section.Name,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 6, 0, 5),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 9,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Items["Text"]:TextBorder()

            Instances:Create("UIPadding", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                PaddingBottom = UDimNew(0, 8)
            })

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 10, 0, 26),
                Size = UDim2New(1, -20, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                ClipsDescendants = true,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Section.Items = Items
        end

        return setmetatable(Section, Library.Sections)
    end
    
    Library.Sections.Toggle = function(self, Data)
        Data = Data or { }

        local Toggle = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Toggle",
            Tooltip = Data.ToolTip or Data.tooltip or nil,
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or false,
            Callback = Data.Callback or Data.callback or function() end
        }

        local NewToggle, ToggleItems = Components:Toggle({
            Name = Toggle.Name,
            Parent = Toggle.Section.Items["Content"],
            Tooltip = Toggle.Tooltip,
            Flag = Toggle.Flag,
            Default = Toggle.Default,
            Page = Toggle.Page,
            Callback = Toggle.Callback
        })

        function NewToggle:Colorpicker(Data)
            local Colorpicker = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                Callback = Data.Callback or Data.callback or function() end,
                Alpha = Data.Alpha or Data.alpha or 0,
            }

            local NewColorpicker, ColorpickerItems = Components:Colorpicker({
                Name = Colorpicker.Name,
                Parent = ToggleItems["SubElements"],
                Pages = true,
                Page = Colorpicker.Page,
                Flag = Colorpicker.Flag,
                Default = Colorpicker.Default,
                Alpha = Colorpicker.Alpha,
                Callback = Colorpicker.Callback,
            })

            return NewColorpicker
        end

        function NewToggle:Keybind(Data)
            Data = Data or { }

            local Keybind = {
                Window = self.Window,
                Page = self.Page,
                Section = self.Section,

                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Enum.KeyCode.RightShift,
                Callback = Data.Callback or Data.callback or function() end,
                Mode = Data.Mode or Data.mode or "Toggle",
            }

            local NewKeybind, KeybindItems = Components:Keybind({
                Name = Toggle.Name,
                Parent = ToggleItems["SubElements"],
                Page = Keybind.Page,
                Flag = Keybind.Flag,
                Default = Keybind.Default,
                Mode = Keybind.Mode,
                Callback = Keybind.Callback
            })

            return NewKeybind
        end

        return NewToggle
    end

    Library.Sections.Keybind = function(self, Data)
        Data = Data or { }
        local Name = Data.Name or Data.name or "Keybind"
        
        local NewLabel, LabelItems = Components:Label({
            Name = Name,
            Parent = self.Items["Content"],
            Page = self.Page,
        })
        
        local Keybind = {
            Window = self.Window,
            Page = self.Page,
            Section = self,
            
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or Enum.KeyCode.RightShift,
            Callback = Data.Callback or Data.callback or function() end,
            Mode = Data.Mode or Data.mode or "Toggle",
        }
        
        local NewKeybind, KeybindItems = Components:Keybind({
            Name = Name,
            Parent = LabelItems["SubElements"],
            Page = Keybind.Page,
            Flag = Keybind.Flag,
            Default = Keybind.Default,
            Mode = Keybind.Mode,
            Callback = Keybind.Callback
        })
        
        return NewKeybind
    end

    Library.Sections.Button = function(self, Name, Callback)
        local Button = {
            Window = self.Window,
            Page = self.Page,
            Section = self
        }

        local NewButton, ButtonItems = Components:Button({
            Parent = Button.Section.Items["Content"],
            Page = Button.Page
        })
        
        -- If Name and Callback are provided, add the button directly
        if Name and Callback then
            NewButton:Add(Name, Callback)
        end

        return NewButton
    end

    Library.Sections.Colorpicker = function(self, Data)
        Data = Data or { }

        local label = self:Label(Data.Name or Data.name or "Colorpicker")
        return label:Colorpicker({
            Name = Data.Name or Data.name,
            Flag = Data.Flag or Data.flag,
            Default = Data.Default or Data.default,
            Alpha = Data.Alpha or Data.alpha,
            Callback = Data.Callback or Data.callback,
        })
    end

    Library.Sections.Slider = function(self, Data)
        Data = Data or { }
        
        local Slider = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Slider",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Min = Data.Min or Data.min or 0,
            Decimals = Data.Decimals or Data.decimals or 1,
            Suffix = Data.Suffix or Data.suffix or "",
            ToolTip = Data.ToolTip or Data.tooltip or nil,
            Max = Data.Max or Data.max or 100,
            Default = Data.Default or Data.Default or 0,
            Callback = Data.Callback or Data.callback or function() end,
        }

        local NewSlider, SliderItems = Components:Slider({
            Name = Slider.Name,
            Parent = Slider.Section.Items["Content"],
            Flag = Slider.Flag,
            Min = Slider.Min,
            Page = Slider.Page,
            Decimals = Slider.Decimals,
            Suffix = Slider.Suffix,
            Max = Slider.Max,
            Default = Slider.Default,
            Callback = Slider.Callback,
        })

        if Slider.ToolTip then
            SliderItems["Slider"]:Tooltip({
                Text = Slider.ToolTip.Name,
                Description = Slider.ToolTip.Description,
            })
        end

        local PageSearchData = Library.SearchItems[Slider.Page]

        if PageSearchData then
            local SearchData = {
                Element = SliderItems["Slider"],
                Name = Slider.Name,
            }

            TableInsert(PageSearchData, SearchData)
        end

        return NewSlider 
    end

    Library.Sections.Dropdown = function(self, Data)
        Data = Data or { }

        local Dropdown = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Dropdown",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Items = Data.Items or Data.items or { },
            Default = Data.Default or Data.default or nil,
            ToolTip = Data.ToolTip or Data.tooltip or nil,
            Multi = Data.Multi or Data.multi or false,
            Callback = Data.Callback or Data.callback or function() end            
        }

        local NewDropdown, DropdownItems = Components:Dropdown({
            Name = Dropdown.Name,
            Parent = Dropdown.Section.Items["Content"],
            Flag = Dropdown.Flag,
            Items = Dropdown.Items,
            Page = Dropdown.Page,
            Default = Dropdown.Default,
            Multi = Dropdown.Multi,
            Callback = Dropdown.Callback,
        })

        if Dropdown.ToolTip then
            DropdownItems["Dropdown"]:Tooltip({
                Text = Dropdown.ToolTip.Name,
                Description = Dropdown.ToolTip.Description,
            })
        end

        local PageSearchData = Library.SearchItems[Dropdown.Page]

        if PageSearchData then
            local SearchData = {
                Element = DropdownItems["Dropdown"],
                Name = Dropdown.Name,
            }

            TableInsert(PageSearchData, SearchData)
        end

        return NewDropdown 
    end

    Library.Sections.Label = function(self, Name, Tooltip)
        local Label = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Name or "Label"
        }

        local NewLabel, LabelItems = Components:Label({
            Name = Label.Name,
            Parent = Label.Section.Items["Content"],
            Page = Label.Page,
        })

        if Tooltip then
            LabelItems["Label"]:Tooltip({
                Text = Tooltip.Name,
                Description = Tooltip.Description,
            })
        end

        function NewLabel:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = self.Window,
                Page = self.Page,
                Section = self.Section,

                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                Callback = Data.Callback or Data.callback or function() end,
                Alpha = Data.Alpha or Data.alpha or 0,
            }

            local NewColorpicker, ColorpickerItems = Components:Colorpicker({
                Name = Colorpicker.Name,
                Parent = LabelItems["SubElements"],
                Pages = true,
                Page = Colorpicker.Page,
                Flag = Colorpicker.Flag,
                Default = Colorpicker.Default,
                Alpha = Colorpicker.Alpha,
                Callback = Colorpicker.Callback,
            })

            return NewColorpicker
        end

        function NewLabel:Keybind(Data)
            Data = Data or { }

            local Keybind = {
                Window = self.Window,
                Page = self.Page,
                Section = self.Section,

                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Enum.KeyCode.RightShift,
                Callback = Data.Callback or Data.callback or function() end,
                Mode = Data.Mode or Data.mode or "Toggle",
            }

            local NewKeybind, KeybindItems = Components:Keybind({
                Name = Label.Name,
                Parent = LabelItems["SubElements"],
                Page = Keybind.Page,
                Flag = Keybind.Flag,
                Default = Keybind.Default,
                Mode = Keybind.Mode,
                Callback = Keybind.Callback
            })

            return NewKeybind
        end

        local PageSearchData = Library.SearchItems[Label.Page]

        if PageSearchData then
            local SearchData = {
                Element = LabelItems["Label"],
                Name = Label.Name,
            }

            TableInsert(PageSearchData, SearchData)
        end

        return NewLabel
    end

    Library.Sections.Textbox = function(self, Data)
        Data = Data or { }

        local Textbox = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Textbox",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or "",
            Numeric = Data.Numeric or Data.numeric or false,
            Finished = Data.Finished or Data.finished or false,
            Placeholder = Data.Placeholder or Data.placeholder or "...",
            ToolTip = Data.ToolTip or Data.tooltip or nil,
            Callback = Data.Callback or Data.callback or function() end,
        }

        local NewTextbox, TextboxItems = Components:Textbox({
            Name = Textbox.Name,
            Placeholder = Textbox.Placeholder,
            Parent = Textbox.Section.Items["Content"],
            Flag = Textbox.Flag,
            Page = Textbox.Page,
            Default = Textbox.Default,
            Numeric = Textbox.Numeric,
            Finished = Textbox.Finished,
            Callback = Textbox.Callback,
        })

        if Textbox.ToolTip then
            TextboxItems["Textbox"]:Tooltip({
                Text = Textbox.ToolTip.Name,
                Description = Textbox.ToolTip.Description
            })
        end

        local PageSearchData = Library.SearchItems[Textbox.Page]

        if PageSearchData then
            local SearchData = {
                Element = TextboxItems["Textbox"],
                Name = Textbox.Name,
            }

            TableInsert(PageSearchData, SearchData)
        end

        return NewTextbox
    end

    Library.Sections.Searchbox = function(self, Data)
        Data = Data or { }

        local Searchbox = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Searchbox",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Items = Data.Items or Data.items or { },
            Default = Data.Default or Data.default or nil,
            Multi = Data.Multi or Data.multi or false,
            Callback = Data.Callback or Data.callback or function() end            
        }

        local NewSearchbox, SearchboxItems = Components:Searchbox({
            Parent = Searchbox.Section.Items["Content"],
            Flag = Searchbox.Flag,
            Items = Searchbox.Items,
            Page = Searchbox.Page,
            Default = Searchbox.Default,
            Multi = Searchbox.Multi,
            Callback = Searchbox.Callback,
        })

        local PageSearchData = Library.SearchItems[Searchbox.Page]

        if PageSearchData then
            local SearchData = {
                Element = SearchboxItems["Listbox"],
                Name = Searchbox.Name,
            }

            TableInsert(PageSearchData, SearchData)
        end

        return NewSearchbox 
    end

    Library.BlankElement = function(self, Data)
        local BlankElement = {
            Name = Data.Name or Data.name or "Blank",
            Size = Data.Size or Data.size or 18
        }

        local Items = { } do
            Items["BlankElement"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, BlankElement.Size),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["BlankElement"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = BlankElement.Name,
                Size = UDim2New(0, 0, 0, 15),
                AnchorPoint = Vector2New(0, 0.5),
                Position = UDim2New(0, 0, 0.5, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 9,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Items["Text"]:TextBorder()
        end

        return BlankElement, Items
    end

    Library.Notify = LPH_NO_VIRTUALIZE(function(self, Text, Duration, Description, Icon)
        if (Library.Flags and Library.Flags["NotificationsEnabled"] == false) then
            return
        end

        if type(Text) ~= "string" then
            Text = tostring(Text or "Notification")
        end
        if type(Duration) == "string" and not Description then
            Description = Duration
            Duration = nil
        end
        if type(Description) == "number" and not Duration then
            Duration = Description
            Description = nil
        end
        Duration = tonumber(Duration) or (Library.Flags and tonumber(Library.Flags["NotificationDuration"])) or 3

        -- Position from Library.Flags["NotificationPosition"]
        local posSetting = (Library.Flags and Library.Flags["NotificationPosition"]) or "Top Left"
        if Library.NotifHolder and Library.NotifHolder.Instance then
            local holder = Library.NotifHolder.Instance
            local layout = holder:FindFirstChildOfClass("UIListLayout")
            if posSetting == "Top Right" then
                holder.AnchorPoint = Vector2New(1, 0)
                holder.Position = UDim2New(1, -12, 0, 12)
                if layout then
                    layout.VerticalAlignment = Enum.VerticalAlignment.Top
                    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                end
            elseif posSetting == "Bottom Left" then
                holder.AnchorPoint = Vector2New(0, 1)
                holder.Position = UDim2New(0, 12, 1, -12)
                if layout then
                    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
                    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
                end
            elseif posSetting == "Bottom Right" then
                holder.AnchorPoint = Vector2New(1, 1)
                holder.Position = UDim2New(1, -12, 1, -12)
                if layout then
                    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
                    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                end
            else
                holder.AnchorPoint = Vector2New(0, 0)
                holder.Position = UDim2New(0, 12, 0, 12)
                if layout then
                    layout.VerticalAlignment = Enum.VerticalAlignment.Top
                    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
                end
            end
        end

        local Items = {}

        -- Main Notification Frame
        Items["Notification"] = Instances:Create("Frame", {
            Parent = Library.NotifHolder.Instance,
            Name = "\0",
            BorderColor3 = Library.Theme.Border or FromRGB(12, 12, 12),
            BorderSizePixel = 2,
            AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundColor3 = Library.Theme.Background or FromRGB(14, 17, 15),
            BackgroundTransparency = 1,
            ClipsDescendants = false
        })
        Items["Notification"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

        Items["Stroke"] = Instances:Create("UIStroke", {
            Parent = Items["Notification"].Instance,
            Name = "\0",
            Color = Library.Theme.Outline or FromRGB(42, 49, 45),
            Thickness = 1,
            Transparency = 1,
            LineJoinMode = Enum.LineJoinMode.Miter,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })
        Items["Stroke"]:AddToTheme({Color = "Outline"})

        Instances:Create("UIPadding", {
            Parent = Items["Notification"].Instance,
            Name = "\0",
            PaddingTop = UDimNew(0, 6),
            PaddingBottom = UDimNew(0, 8),
            PaddingLeft = UDimNew(0, 8),
            PaddingRight = UDimNew(0, 10)
        })

        -- Content Frame (Horizontal layout for Icon + Text)
        Items["ContentFrame"] = Instances:Create("Frame", {
            Parent = Items["Notification"].Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY
        })

        Instances:Create("UIListLayout", {
            Parent = Items["ContentFrame"].Instance,
            Name = "\0",
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDimNew(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        -- Optional icon, enlarged 6.5x from the old 12px size
        if Icon and type(Icon) == "string" and Icon ~= "" then
            Items["Icon"] = Instances:Create("ImageLabel", {
                Parent = Items["ContentFrame"].Instance,
                Name = "\0",
                Image = Icon,
                ImageColor3 = Library.Theme.Accent or FromRGB(210, 180, 80),
                ImageTransparency = 1,
                BackgroundTransparency = 1,
                Size = UDim2New(0, 78, 0, 78),
                BorderSizePixel = 0,
                ScaleType = Enum.ScaleType.Fit
            })
            Items["Icon"]:AddToTheme({ImageColor3 = "Accent"})
        end

        -- Text Container
        Items["TextContainer"] = Instances:Create("Frame", {
            Parent = Items["ContentFrame"].Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY
        })

        if Description and type(Description) == "string" and Description ~= "" then
            Instances:Create("UIListLayout", {
                Parent = Items["TextContainer"].Instance,
                Name = "\0",
                FillDirection = Enum.FillDirection.Vertical,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDimNew(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["TextContainer"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Accent or FromRGB(210, 180, 80),
                TextTransparency = 1,
                Text = Text,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 9,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            Items["Title"]:AddToTheme({TextColor3 = "Accent"})
            Items["TitleStroke"] = Items["Title"]:TextBorder()
            Items["TitleStroke"].Instance.Transparency = 1

            Items["Description"] = Instances:Create("TextLabel", {
                Parent = Items["TextContainer"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text or FromRGB(235, 235, 235),
                TextTransparency = 1,
                Text = Description,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 9,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            Items["Description"]:AddToTheme({TextColor3 = "Text"})
            Items["DescStroke"] = Items["Description"]:TextBorder()
            Items["DescStroke"].Instance.Transparency = 1
        else
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["TextContainer"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text or FromRGB(235, 235, 235),
                TextTransparency = 1,
                Text = Text,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 9,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            Items["Title"]:AddToTheme({TextColor3 = "Text"})
            Items["TitleStroke"] = Items["Title"]:TextBorder()
            Items["TitleStroke"].Instance.Transparency = 1
        end

        -- Progress Timer Line
        Items["Liner"] = Instances:Create("Frame", {
            Parent = Items["Notification"].Instance,
            Name = "\0",
            AnchorPoint = Vector2New(0, 0),
            Position = UDim2New(0, 0, 1, 2),
            Size = UDim2New(1, 0, 0, 1.5),
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.Accent or FromRGB(210, 180, 80),
            BackgroundTransparency = 1
        })

        -- Fade In / Timer / Fade Out
        Library:Thread(function()
            Items["Notification"].Instance.BackgroundTransparency = 0
            Items["Stroke"].Instance.Transparency = 0
            Items["Liner"].Instance.BackgroundTransparency = 0

            if Items["Icon"] then
                Items["Icon"].Instance.ImageTransparency = 0
            end
            if Items["Title"] then
                Items["Title"].Instance.TextTransparency = 0
                if Items["TitleStroke"] then Items["TitleStroke"].Instance.Transparency = 0.6 end
            end
            if Items["Description"] then
                Items["Description"].Instance.TextTransparency = 0.3
                if Items["DescStroke"] then Items["DescStroke"].Instance.Transparency = 0.6 end
            end

            TweenService:Create(Items["Liner"].Instance, TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                Size = UDim2New(1, 0, 0, 2)
            }):Play()

            task.wait(Duration)

            local fadeInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(Items["Notification"].Instance, fadeInfo, { BackgroundTransparency = 1 }):Play()
            TweenService:Create(Items["Stroke"].Instance, fadeInfo, { Transparency = 1 }):Play()
            TweenService:Create(Items["Liner"].Instance, fadeInfo, { BackgroundTransparency = 1 }):Play()

            if Items["Icon"] then
                TweenService:Create(Items["Icon"].Instance, fadeInfo, { ImageTransparency = 1 }):Play()
            end
            if Items["Title"] then
                TweenService:Create(Items["Title"].Instance, fadeInfo, { TextTransparency = 1 }):Play()
                if Items["TitleStroke"] then TweenService:Create(Items["TitleStroke"].Instance, fadeInfo, { Transparency = 1 }):Play() end
            end
            if Items["Description"] then
                TweenService:Create(Items["Description"].Instance, fadeInfo, { TextTransparency = 1 }):Play()
                if Items["DescStroke"] then TweenService:Create(Items["DescStroke"].Instance, fadeInfo, { Transparency = 1 }):Play() end
            end

            task.wait(0.3)
            pcall(function() Items["Notification"]:Clean() end)
        end)
    end)

    Library.CreateSettingsPage = function(self, Window, Watermark, KeybindList)
        local SettingsPage = Window:Page({Name = "UI Settings", Columns = 2}) do
            local SettingsSection = SettingsPage:Section({Name = "Settings", Side = 2}) do
                SettingsSection:Toggle({
                    Name = "Notifications",
                    Flag = "NotificationsEnabled",
                    Default = true,
                    Callback = function(Value)
                        Library.Flags["NotificationsEnabled"] = Value == true
                    end
                })

                SettingsSection:Slider({
                    Name = "Fade time",
                    Flag = "FadeTime",
                    Default = Library.FadeSpeed,
                    Min = 0,
                    Max = 1,
                    Decimals = 0.01,
                    Callback = function(Value)
                        Library.FadeSpeed = Value
                    end
                })

                SettingsSection:Slider({
                    Name = "Tween time",
                    Flag = "TweenTime",
                    Default = Library.Tween.Time,
                    Min = 0,
                    Max = 1,
                    Decimals = 0.01,
                    Callback = function(Value)
                        Library.Tween.Time = Value
                    end
                })

                SettingsSection:Dropdown({
                    Name = "Tween style",
                    Flag = "Tween style",
                    Items = { "Linear", "Quad", "Quart", "Back", "Bounce", "Circular", "Cubic", "Elastic", "Exponential", "Sine", "Quint" },
                    Default = "Cubic",
                    Callback = function(Value)
                        Library.Tween.Style = Enum.EasingStyle[Value]
                    end
                })

                SettingsSection:Dropdown({
                    Name = "Tween direction",
                    Flag = "Tween direction",
                    Items = { "In", "Out", "InOut" },
                    Default = "Out",
                    Callback = function(Value)
                        Library.Tween.Direction = Enum.EasingDirection[Value]
                    end
                })
            end

            local ThemeSection = SettingsPage:Section({Name = "Theme", Side = 1}) do
                local ThemeNameValue = "CustomTheme"
                local SavedThemes = Library:GetThemeFiles()
                local ThemeDropdown = ThemeSection:Dropdown({
                    Name = "Themes",
                    Flag = "ThemePreset",
                    Items = SavedThemes,
                    Default = "Preset",
                    Callback = function(Value)
                        if Value and Value ~= "" and Value ~= "Preset" then
                            Library:ImportTheme(Value)
                        elseif Value == "Preset" then
                            Library:ImportTheme("Preset")
                        end
                    end
                })

                ThemeSection:Textbox({
                    Name = "Theme name",
                    Flag = "ThemeName",
                    Default = ThemeNameValue,
                    Placeholder = "CustomTheme",
                    Callback = function(Value)
                        ThemeNameValue = tostring(Value or "CustomTheme")
                    end
                })

                local ThemeButtons = ThemeSection:Button()
                ThemeButtons:Add("Save", function()
                    local Name = Library.Flags["ThemeName"] or ThemeNameValue
                    local SavedName = Library:SaveTheme(Name)
                    ThemeDropdown:Refresh(Library:GetThemeFiles())
                    ThemeDropdown:Set(SavedName)
                    Library:Notify("Theme saved", 1.5)
                end)

                ThemeButtons:Add("Export", function()
                    local Name = Library.Flags["ThemeName"] or ThemeNameValue
                    local SavedName, Payload = Library:ExportTheme(Name)
                    ThemeDropdown:Refresh(Library:GetThemeFiles())
                    ThemeDropdown:Set(SavedName)
                    if setclipboard then
                        setclipboard(Payload)
                    end
                    Library:Notify("Theme exported", 1.5)
                end)

                ThemeButtons:Add("Import", function()
                    local Name = Library.Flags["ThemePreset"] or Library.Flags["ThemeName"] or ThemeNameValue
                    if Name and Name ~= "" then
                        local imported = Library:ImportTheme(Name)
                        if imported then
                            Library:Notify("Theme imported", 1.5)
                        else
                            Library:Notify("Theme not found", 1.5)
                        end
                    end
                end)

                ThemeButtons:Add("Delete", function()
                    local Name = Library.Flags["ThemePreset"] or Library.Flags["ThemeName"] or ThemeNameValue
                    local Target = tostring(Name or "")
                    if Target == "" then
                        Library:Notify("No theme selected", 1.5)
                        return
                    end

                    local Deleted = false
                    local Candidates = {
                        Target .. ".json",
                        Target .. ".txt",
                        Target
                    }

                    for _, Candidate in ipairs(Candidates) do
                        local Path = Library.Folders.Themes .. "/" .. Candidate
                        if isfile(Path) then
                            delfile(Path)
                            Deleted = true
                        end
                    end

                    if Deleted then
                        local Files = Library:GetThemeFiles()
                        ThemeDropdown:Refresh(Files)
                        local NewValue = Files[1] or "Preset"
                        ThemeDropdown:Set(NewValue)
                        Library:Notify("Theme deleted", 1.5)
                    else
                        Library:Notify("Theme not found", 1.5)
                    end
                end)

                local ThemeKeys = {
                    "Background",
                    "Border",
                    "Inline",
                    "Hovered Element",
                    "Page Background",
                    "Outline",
                    "Element",
                    "Gradient",
                    "Text",
                    "Text Stroke",
                    "Placeholder Text",
                    "Accent"
                }

                for _, ThemeKey in ipairs(ThemeKeys) do
                    local ThemeLabel = ThemeSection:Label(ThemeKey)
                    ThemeLabel:Colorpicker({
                        Name = ThemeKey,
                        Flag = "ThemeColor_" .. ThemeKey,
                        Default = Library.Theme[ThemeKey] or FromRGB(255, 255, 255),
                        Callback = function(ColorValue)
                            if ColorValue then
                                Library:ChangeTheme(ThemeKey, ColorValue)
                            end
                        end
                    })
                end
            end
        end

        return SettingsPage
    end
end

getgenv().Library = Library
getgenv().UnloadAlternate = function()
    if getgenv().Library and getgenv().Library.Unload then
        pcall(getgenv().Library.Unload, getgenv().Library)
    end
end
return Library
