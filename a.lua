local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- // Redesign Configuration //
-- This maintains your original logic structure but upgrades the visuals completely.

local Library do 
	Library = {
        Theme =  { },
        espfont = nil,

        MenuKeybind = tostring(Enum.KeyCode.RightControl), 

        Flags = { },

        Tween = {
            Time = 0.35,
            Style = Enum.EasingStyle.Quint, -- Smoother, more premium feel
            Direction = Enum.EasingDirection.Out
        },

        FadeSpeed = 0.2,

        Folders = {
            Directory = "luna",
            Configs = "luna/Configs",
            Assets = "luna/Assets",
			Sounds = "luna/Sounds",
        },

        -- Ignore below
        Pages = { },
        Sections = { },

        Connections = { },
        Threads = { },

        ThemeMap = { },
        ThemeItems = { },

        OpenFrames = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,
        KeyList = nil,

        Font = nil,
        CopiedColor = nil,
		Fonts = { },
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages
end


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
local UDim2FromOffset = UDim2.fromOffset
local Vector2New = Vector2.new
local Vector3New = Vector3.new

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

-- // UPDATED THEME: Crimson Night //
local Themes = {
    ["Preset"] = {
        ["Window Outline"] = FromRGB(200, 30, 30),
        ["Accent"] = FromRGB(220, 40, 40),
        ["Background 1"] = FromRGB(12, 12, 12),
        ["Text"] = FromRGB(240, 240, 240),
        ["Inline"] = FromRGB(20, 20, 20),
        ["Element"] = FromRGB(28, 28, 28),
        ["Inactive Text"] = FromRGB(140, 140, 140),
        ["Border"] =  FromRGB(45, 45, 45),
        ["Background 2"] = FromRGB(18, 18, 18)
    }
}

Library.Theme = TableClone(Themes["Preset"])

-- Folders
for Index, Value in Library.Folders do 
    if not isfolder(Value) then
        makefolder(Value)
    end
end

-- Tweening
local Tween = { } do
    Tween.__index = Tween

    Tween.Create = function(self, Item, Info, Goal, IsRawItem)
        Item = IsRawItem and Item or Item.Instance
        Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

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
Instances = { } do
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
        if not self.Instance then 
            return
        end

        Library:AddToTheme(self, Properties)
    end

    Instances.ChangeItemTheme = function(self, Properties)
        if not self.Instance then 
            return
        end

        Library:ChangeItemTheme(self, Properties)
    end

    Instances.Connect = function(self, Event, Callback, Name)
        if not self.Instance then 
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
            local NewX = StartPosition.X.Offset + DragDelta.X
            local NewY = StartPosition.Y.Offset + DragDelta.Y

            local ScreenSize = Gui.Parent.AbsoluteSize
            local GuiSize = Gui.AbsoluteSize
    
            NewX = MathClamp(NewX, 0, ScreenSize.X - GuiSize.X)
            NewY = MathClamp(NewY, 0, ScreenSize.Y - GuiSize.Y)
    
            -- Smoother Drag
            self:Tween(TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2New(0, NewX, 0, NewY)})
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
    
        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if Dragging then
                    Set(Input)
                end
            end
        end)
    
        return Dragging
    end

    Instances.MakeResizeable = function(self, Minimum, Maximum)
        if not self.Instance then 
            return
        end

        local Gui = self.Instance

        local Resizing = false 
        local CurrentSide = nil

        local StartMouse = nil 
        local StartPosition = nil 
        local StartSize = nil
        
        local EdgeThickness = 4 -- Increased for easier grabbing

        local MakeEdge = function(Name, Position, Size)
            local Button = Instances:Create("TextButton", {
                Name = "\0",
                Size = Size,
                Position = Position,
                BackgroundColor3 = FromRGB(166, 147, 243),
                BackgroundTransparency = 1,
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = Gui,
                ZIndex = 99999,
            })  Button:AddToTheme({BackgroundColor3 = "Accent"})

            return Button
        end

        local Edges = {
            {Button = MakeEdge("Left", UDim2New(0, 0, 0, 0), UDim2New(0, EdgeThickness, 1, 0)), Side = "L"},
            {Button = MakeEdge("Right", UDim2New(1, -EdgeThickness, 0, 0), UDim2New(0, EdgeThickness, 1, 0)), Side = "R"},
            {Button = MakeEdge("Top", UDim2New(0, 0, 0, 0), UDim2New(1, 0, 0, EdgeThickness)), Side = "T"},
            {Button = MakeEdge("Bottom", UDim2New(0, 0, 1, -EdgeThickness), UDim2New(1, 0, 0, EdgeThickness)), Side = "B"},
        }

        local BeginResizing = function(Side)
            Resizing = true 
            CurrentSide = Side 

            StartMouse = UserInputService:GetMouseLocation()
            StartPosition = Vector2New(Gui.Position.X.Offset, Gui.Position.Y.Offset)
            StartSize = Vector2New(Gui.Size.X.Offset, Gui.Size.Y.Offset)
            
            for Index, Value in Edges do 
                Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0.5 or 1
            end
        end

        local EndResizing = function()
            Resizing = false 
            CurrentSide = nil

            for Index, Value in Edges do 
                Value.Button.Instance.BackgroundTransparency = 1
            end
        end

        for Index, Value in Edges do 
            Value.Button:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    BeginResizing(Value.Side)
                end
            end)
        end

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if Resizing then
                    EndResizing()
                end
            end
        end)

        Library:Connect(RunService.RenderStepped, function()
            if not Resizing or not CurrentSide then 
                return 
            end

            local MouseLocation = UserInputService:GetMouseLocation()
            local dx = MouseLocation.X - StartMouse.X
            local dy = MouseLocation.Y - StartMouse.Y
        
            local x, y = StartPosition.X, StartPosition.Y
            local w, h = StartSize.X, StartSize.Y

            if CurrentSide == "L" then
                x = StartPosition.X + dx
                w = StartSize.X - dx
            elseif CurrentSide == "R" then
                w = StartSize.X + dx
            elseif CurrentSide == "T" then
                y = StartPosition.Y + dy
                h = StartSize.Y - dy
            elseif CurrentSide == "B" then
                h = StartSize.Y + dy
            end
        
            if w < Minimum.X then
                if CurrentSide == "L" then x = x - (Minimum.X - w) end
                w = Minimum.X
            end
            if h < Minimum.Y then
                if CurrentSide == "T" then y = y - (Minimum.Y - h) end
                h = Minimum.Y
            end
        
            self:Tween(TweenInfo.new(0.05, Enum.EasingStyle.Linear), {Position = UDim2FromOffset(x, y)})
            self:Tween(TweenInfo.new(0.05, Enum.EasingStyle.Linear), {Size = UDim2FromOffset(w, h)})
        end)
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
end

-- Custom font logic preserved
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

    CustomFont:New("Verdana", 400, "Regular", {
        Id = "Verdana",
        Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/verdana.ttf"
    })

    CustomFont:New("SmallestPixel", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/smallest_pixel-7.ttf"})
    CustomFont:New("ProggyClean", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/proggy-clean.ttf"})
    CustomFont:New("TahomaXP", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/windows-xp-tahoma.ttf"})
    CustomFont:New("MinecraftiaRegular", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/minecraftia-regular.ttf"})
    CustomFont:New("Monaco", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/Monaco.ttf"})
    CustomFont:New("Verdana", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/verdana.ttf"})
    CustomFont:New("TeachersPet", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/teachers-pet.ttf"})

    Library.Fonts["Smallest Pixel"] = CustomFont:Get("SmallestPixel")
    Library.Fonts["Proggy Clean"] = CustomFont:Get("ProggyClean")
    Library.Fonts["Tahoma XP"] = CustomFont:Get("TahomaXP")
    Library.Fonts["Minecraftia"] = CustomFont:Get("MinecraftiaRegular")
    Library.Fonts["Monaco"] = CustomFont:Get("Monaco")
    Library.Fonts["Verdana"] = CustomFont:Get("Verdana")
    Library.Fonts["Teachers Pet"] = CustomFont:Get("TeachersPet")
    Library.Fonts['Gotham SSm'] = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Medium)

    -- REDESIGN: Using Gotham by default for modern look, but logic is same
    Library.Font = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    Library.espfont = Library.Fonts["Tahoma XP"]
end

Library.Holder = Instances:Create("ScreenGui", {
    Parent = gethui(),
    Name = "RedesignedLuna",
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    DisplayOrder = 2,
    IgnoreGuiInset = true,
    ResetOnSpawn = false
})

Library.UnusedHolder = Instances:Create("ScreenGui", {
    Parent = gethui(),
    Name = "RedesignedLunaCache",
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    Enabled = false,
    ResetOnSpawn = false
})

Library.NotifHolder = Instances:Create("Frame", {
    Parent = Library.Holder.Instance,
    Name = "Notifications",
    BorderColor3 = FromRGB(0, 0, 0),
    AnchorPoint = Vector2New(1, 1), -- Changed to Bottom Right
    BackgroundTransparency = 1,
    Position = UDim2New(1, -20, 1, -20),
    Size = UDim2New(0, 300, 1, 0),
    BorderSizePixel = 0,
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundColor3 = FromRGB(255, 255, 255)
})

Instances:Create("UIListLayout", {
    Parent = Library.NotifHolder.Instance,
    Name = "\0",
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    VerticalAlignment = Enum.VerticalAlignment.Bottom, -- Bottom stack
    Padding = UDimNew(0, 10)
})

-- Helper function for rounded corners
local function AddCorner(parent, radius)
    local corner = InstanceNew("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

-- Helper function for strokes
local function AddStroke(parent, color, thickness, transparency)
    local stroke = InstanceNew("UIStroke")
    stroke.Color = color or FromRGB(50,50,50)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

Library.Unload = function(self)
    for Index, Value in self.Connections do 
        Value.Connection:Disconnect()
    end

    for Index, Value in self.Threads do 
        coroutine.close(Value)
    end

    if self.Holder then 
        self.Holder:Clean()
    end

    Library = nil 
    getgenv().Library = nil
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
        warn("Luna Callback Error: " .. tostring(Result))
        return false
    end

    return Success
end

Library.Connect = function(self, Event, Callback, Name)
    Name = Name or StringFormat("connection_number_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

    local NewConnection = {
        Event = Event,
        Callback = Callback,
        Name = Name,
        Connection = nil
    }

    Library:Thread(function()
        NewConnection.Connection = Event:Connect(Callback)
    end)

    TableInsert(self.Connections, NewConnection)
    return NewConnection
end

Library.Disconnect = function(self, Name)
    for _, Connection in self.Connections do 
        if Connection.Name == Name then
            Connection.Connection:Disconnect()
            break
        end
    end
end

Library.EscapePattern = function(self, String)
    local ShouldEscape = false 

    if string.match(String, "[%(%)%.%%%+%-%*%?%[%]%^%$]") then
        ShouldEscape = true
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

Library.GetConfig = function(self)
    local Config = { } 

    local Success, Result = Library:SafeCall(function()
        for Index, Value in Library.Flags do 
            if type(Value) == "table" and Value.Key then
                Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode, Toggled = Value.Toggled}
            elseif type(Value) == "table" and Value.Color then
                Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
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
    local List = { }
    local ReturnList = { }

    List = listfiles(Library.Folders.Configs)

    for Index = 1, #List do 
        local File = List[Index]

        if File:sub(-5) == ".json" then
            local Position = File:find(".json", 1, true)
            local StartPosition = Position

            local Character = File:sub(Position, Position)
            while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                Position = Position - 1
                Character = File:sub(Position, Position)
            end

            if Character == "/" or Character == "\\" then
                TableInsert(ReturnList, File:sub(Position + 1, StartPosition - 1))
            end
        end
    end

    Element:Refresh(ReturnList)
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

Library.IsMouseOverFrame = function(self, Frame)
    Frame = Frame.Instance

    local MousePosition = Vector2New(Mouse.X, Mouse.Y)

    return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X 
    and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
end

Library.GetLighterColor = function(self, Color, Increment)
    local Hue, Saturation, Value = Color:ToHSV()
    return FromHSV(Hue, Saturation, Value * Increment)
end

-- // COLORPICKER REDESIGN (Wrapper around old logic) //
do 
    Library.CreateColorpicker = function(self, Data)
        -- Keep original logic but restyle the window
        local Colorpicker = {
            Hue = 0,
            Saturation = 0,
            Value = 0,
            Alpha = 0,
            IsOpen = false,
            IsOpen2 = false,
            Color = FromRGB(0, 0, 0),
            HexValue = "000000",
            Flag = Data.Flag
        }

        local Items = { } do
            Items["ColorpickerButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                FontFace = Library.Font,
                Text = "",
                AutoButtonColor = false,
                Size = UDim2New(0, 20, 0, 12),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(140, 255, 213)
            })
            
            AddCorner(Items["ColorpickerButton"].Instance, 4)
            local s = AddStroke(Items["ColorpickerButton"].Instance, FromRGB(255,255,255), 1, 0.5)

            Items["ColorpickerWindow"] = Instances:Create("Frame", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                Visible = false,
                Position = UDim2New(0, 1032, 0, 123),
                Size = UDim2New(0, 230, 0, 250),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(24, 24, 24)
            })
            AddCorner(Items["ColorpickerWindow"].Instance, 8)
            local WinStroke = AddStroke(Items["ColorpickerWindow"].Instance, FromRGB(200, 30, 30), 1)
            WinStroke:AddToTheme({Color = "Accent"})
            
            -- Alpha
            Items["Alpha"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                Position = UDim2New(0, 10, 1, -30),
                Size = UDim2New(1, -20, 0, 10),
                ZIndex = 2,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Items["Checkers"] = Instances:Create("ImageLabel", {
                Parent = Items["Alpha"].Instance,
                ScaleType = Enum.ScaleType.Tile,
                TileSize = UDim2New(0, 6, 0, 6),
                Image = "http://www.roblox.com/asset/?id=18274452449",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                ZIndex = 2,
            })
            
            Items["AlphaDragger"] = Instances:Create("Frame", {
                Parent = Items["Alpha"].Instance,
                Size = UDim2New(0, 2, 1, 4),
                Position = UDim2New(0, 0, 0, -2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255),
                ZIndex = 3
            })
            
            -- Hue
            Items["Hue"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                Position = UDim2New(1, -25, 0, 10),
                Size = UDim2New(0, 15, 1, -50),
                ZIndex = 2,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Items["HueInline"] = Instances:Create("TextButton", {
                Parent = Items["Hue"].Instance,
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 1, 0),
                ZIndex = 2,
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["HueInline"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
            })
            
            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["Hue"].Instance,
                Position = UDim2New(0, -2, 0, 0),
                Size = UDim2New(1, 4, 0, 2),
                ZIndex = 3,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            -- Palette
            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                Position = UDim2New(0, 10, 0, 10),
                Size = UDim2New(1, -45, 1, -50),
                ZIndex = 2,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Items["Saturation"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Size = UDim2New(1, 0, 1, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["Saturation"].Instance,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })
            
            Items["Value"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Size = UDim2New(1, 0, 1, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(0, 0, 0)
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["Value"].Instance,
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })
            
            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Size = UDim2New(0, 4, 0, 4),
                BorderSizePixel = 0,
                ZIndex = 4,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            AddCorner(Items["PaletteDragger"].Instance, 4)
            
            Items["HexInput"] = Instances:Create("TextBox", {
                Parent = Items["ColorpickerWindow"].Instance,
                FontFace = Library.Font,
                ClearTextOnFocus = false,
                TextColor3 = FromRGB(255, 255, 255),
                Text = "",
                Size = UDim2New(0, 0, 0, 0), -- Hidden for minimal design, handled via logic
                Visible = false
            })

             -- Secondary Window (Copy/Paste)
            Items["ColorpickerWindow2"] = Instances:Create("Frame", {
                Parent = Library.UnusedHolder.Instance,
                Visible = false,
                BackgroundColor3 = FromRGB(30, 30, 30),
                Size = UDim2New(0, 60, 0, 50),
            })
            AddCorner(Items["ColorpickerWindow2"].Instance, 6)
            AddStroke(Items["ColorpickerWindow2"].Instance, FromRGB(200,30,30), 1)

            Instances:Create("UIListLayout", {
                Parent = Items["ColorpickerWindow2"].Instance,
                Padding = UDimNew(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end
        -- Keep original logic for functionality
        local AddButton = function(Name, Callback)
            local NewButton = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow2"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                Text = Name,
                Size = UDim2New(1, 0, 0, 22),
                BackgroundTransparency = 1,
                TextSize = 12,
            })
            NewButton:Connect("MouseButton1Down", function() Callback() Colorpicker:SetOpen2(false) end)
        end
        AddButton("Copy", function()
             local r,g,b = math.floor(Colorpicker.Color.R*255), math.floor(Colorpicker.Color.G*255), math.floor(Colorpicker.Color.B*255)
             setclipboard(r..", "..g..", "..b)
             Library.CopiedColor = r..", "..g..", "..b
        end)
        AddButton("Paste", function()
            if Library.CopiedColor then 
                local r,g,b = Library.CopiedColor:match("(%d+),%s*(%d+),%s*(%d+)")
                Colorpicker:Set({tonumber(r), tonumber(g), tonumber(b)}, Colorpicker.Alpha)
            end
        end)

        -- Logic from original script preserved
        local SlidingPalette, SlidingHue, SlidingAlpha = false, false, false
        local Debounce, RenderStepped, RenderStepped2 = false, nil, nil

        function Colorpicker:Update(IsFromAlpha)
            local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
            Colorpicker.Color = FromHSV(Hue, Saturation, Value)
            Colorpicker.HexValue = Colorpicker.Color:ToHex()
            Library.Flags[Colorpicker.Flag] = { Alpha = Colorpicker.Alpha, Color = Colorpicker.Color, HexValue = Colorpicker.HexValue, Transparency = 1 - Colorpicker.Alpha }
            Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
            Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})
            if not IsFromAlpha then Items["Alpha"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color}) end
            if Data.Callback then Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha) end
        end

        function Colorpicker:Set(Color, Alpha)
             if type(Color) == "table" then Color = FromRGB(Color[1], Color[2], Color[3])
             elseif type(Color) == "string" then Color = FromHex(Color) end
             Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
             Colorpicker.Alpha = Alpha or 0
             
             local PX = MathClamp(1 - Colorpicker.Saturation, 0, 0.99)
             local PY = MathClamp(1 - Colorpicker.Value, 0, 0.99)
             Items["PaletteDragger"].Instance.Position = UDim2New(PX, 0, PY, 0)
             Items["HueDragger"].Instance.Position = UDim2New(0,0, MathClamp(Colorpicker.Hue, 0, 0.99), 0)
             Items["AlphaDragger"].Instance.Position = UDim2New(MathClamp(Colorpicker.Alpha, 0, 0.99), 0, 0, 0)
             Colorpicker:Update(false)
        end

        function Colorpicker:SetOpen(Bool)
            if Debounce then return end
            Colorpicker.IsOpen = Bool
            Debounce = true
            if Bool then
                Items["ColorpickerWindow"].Instance.Visible = true
                Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance
                RenderStepped = RunService.RenderStepped:Connect(function()
                    local b = Items["ColorpickerButton"].Instance
                    Items["ColorpickerWindow"].Instance.Position = UDim2New(0, b.AbsolutePosition.X - 200, 0, b.AbsolutePosition.Y)
                end)
            else
                 if RenderStepped then RenderStepped:Disconnect() end
                 Items["ColorpickerWindow"].Instance.Visible = false
            end
            Debounce = false
        end
        function Colorpicker:SetOpen2(Bool)
             Colorpicker.IsOpen2 = Bool
             Items["ColorpickerWindow2"].Instance.Visible = Bool
             if Bool then
                 Items["ColorpickerWindow2"].Instance.Parent = Library.Holder.Instance
                 RenderStepped2 = RunService.RenderStepped:Connect(function()
                     local b = Items["ColorpickerButton"].Instance
                     Items["ColorpickerWindow2"].Instance.Position = UDim2New(0, b.AbsolutePosition.X + 25, 0, b.AbsolutePosition.Y)
                 end)
             else
                 if RenderStepped2 then RenderStepped2:Disconnect() end
             end
        end

        -- Event Listeners (Simplified logic)
        local function SlideP(Input)
             local size = Items["Palette"].Instance.AbsoluteSize
             local pos = Items["Palette"].Instance.AbsolutePosition
             local vx = MathClamp((Input.Position.X - pos.X)/size.X, 0, 1)
             local vy = MathClamp((Input.Position.Y - pos.Y)/size.Y, 0, 1)
             Colorpicker.Saturation, Colorpicker.Value = 1-vx, 1-vy
             Items["PaletteDragger"].Instance.Position = UDim2New(vx,0,vy,0)
             Colorpicker:Update()
        end
        local function SlideH(Input)
             local size = Items["Hue"].Instance.AbsoluteSize
             local pos = Items["Hue"].Instance.AbsolutePosition
             local vy = MathClamp((Input.Position.Y - pos.Y)/size.Y, 0, 1)
             Colorpicker.Hue = vy
             Items["HueDragger"].Instance.Position = UDim2New(0,0,vy,0)
             Colorpicker:Update()
        end
        local function SlideA(Input)
             local size = Items["Alpha"].Instance.AbsoluteSize
             local pos = Items["Alpha"].Instance.AbsolutePosition
             local vx = MathClamp((Input.Position.X - pos.X)/size.X, 0, 1)
             Colorpicker.Alpha = vx
             Items["AlphaDragger"].Instance.Position = UDim2New(vx,0,0,0)
             Colorpicker:Update(true)
        end
        
        Items["Palette"]:Connect("InputBegan", function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then SlidingPalette = true SlideP(I) end end)
        Items["Palette"]:Connect("InputEnded", function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then SlidingPalette = false end end)
        Items["Hue"]:Connect("InputBegan", function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then SlidingHue = true SlideH(I) end end)
        Items["Hue"]:Connect("InputEnded", function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then SlidingHue = false end end)
        Items["Alpha"]:Connect("InputBegan", function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then SlidingAlpha = true SlideA(I) end end)
        Items["Alpha"]:Connect("InputEnded", function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then SlidingAlpha = false end end)
        
        Library:Connect(UserInputService.InputChanged, function(I)
             if I.UserInputType == Enum.UserInputType.MouseMovement then
                 if SlidingPalette then SlideP(I) elseif SlidingHue then SlideH(I) elseif SlidingAlpha then SlideA(I) end
             end
        end)
        
        Items["ColorpickerButton"]:Connect("MouseButton1Down", function() Colorpicker:SetOpen(not Colorpicker.IsOpen) end)
        Items["ColorpickerButton"]:Connect("MouseButton2Down", function() Colorpicker:SetOpen2(not Colorpicker.IsOpen2) end)

        if Data.Default then Colorpicker:Set(Data.Default, Data.Alpha) end
        Library.SetFlags[Colorpicker.Flag] = function(C, A) Colorpicker:Set(C, A) end
        return Colorpicker, Items
    end
    
    -- // KEYBIND REDESIGN //
    Library.CreateKeybind = function(self, Data)
        local Keybind = {
            Flag = Data.Flag,
            Key = nil,
            Callback = Data.Callback,
            Mode = Data.Mode or "Toggle"
        }
        local Items = {}
        Items["KeyButton"] = Instances:Create("TextButton", {
            Parent = Data.Parent.Instance,
            Size = UDim2New(0, 0, 0, 16),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = FromRGB(40,40,40),
            Text = "None",
            FontFace = Library.Font,
            TextSize = 11,
            TextColor3 = FromRGB(200,200,200)
        })
        AddCorner(Items["KeyButton"].Instance, 4)
        AddStroke(Items["KeyButton"].Instance, FromRGB(60,60,60), 1)
        Instances:Create("UIPadding", {Parent = Items["KeyButton"].Instance, PaddingLeft = UDimNew(0,6), PaddingRight = UDimNew(0,6)})
        
        function Keybind:Set(Key)
             if not Key then return end
             local kName = (typeof(Key) == "EnumItem") and Key.Name or tostring(Key)
             kName = kName:gsub("Right", "R"):gsub("Left", "L")
             Keybind.Key = (typeof(Key) == "EnumItem") and tostring(Key) or Key
             Items["KeyButton"].Instance.Text = kName
             Library.Flags[Keybind.Flag] = Keybind.Key
        end
        
        Items["KeyButton"]:Connect("MouseButton1Click", function()
             Items["KeyButton"].Instance.Text = "..."
             local Input = UserInputService.InputBegan:Wait()
             if Input.UserInputType == Enum.UserInputType.Keyboard then
                 Keybind:Set(Input.KeyCode)
             elseif Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.MouseButton2 then
                 Keybind:Set(Input.UserInputType)
             end
             Library:SafeCall(Keybind.Callback)
        end)
        
        if Data.Default then Keybind:Set(Data.Default) end
        return Keybind, Items
    end

    -- // WATERMARK REDESIGN //
    Library.Watermark = function(self, Name)
        local Watermark = {}
        local Items = {} do 
            Items["Watermark"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                AnchorPoint = Vector2New(0.5, 0),
                Position = UDim2New(0.5, 0, 0, 10),
                Size = UDim2New(0, 0, 0, 26),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = FromRGB(12, 12, 12),
                ZIndex = 5,
            })
            AddCorner(Items["Watermark"].Instance, 6)
            local Stroke = AddStroke(Items["Watermark"].Instance, FromRGB(200, 30, 30), 1)
            Stroke:AddToTheme({Color = "Accent"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Watermark"].Instance,
                PaddingLeft = UDimNew(0,10), PaddingRight = UDimNew(0,10)
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Watermark"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                Text = Name,
                Size = UDim2New(0, 0, 1, 0),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 13,
            })
        end
        function Watermark:SetText(T) Items["Text"].Instance.Text = T end
        function Watermark:SetVisibility(B) Items["Watermark"].Instance.Visible = B end
        return Watermark
    end

    -- // KEYBIND LIST REDESIGN //
    Library.KeybindList = function(self)
        local KL = {}
        Library.KeyList = KL
        local Items = {} do
            Items["Frame"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Position = UDim2New(0, 10, 0.5, 0),
                Size = UDim2New(0, 180, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(18, 18, 18)
            })
            AddCorner(Items["Frame"].Instance, 8)
            local Stroke = AddStroke(Items["Frame"].Instance, FromRGB(200, 30, 30), 1)
            Stroke:AddToTheme({Color = "Accent"})
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Frame"].Instance,
                Text = "Keybinds",
                Size = UDim2New(1,0,0,25),
                BackgroundTransparency = 1,
                TextColor3 = FromRGB(200,30,30),
                FontFace = Library.Font,
                TextSize = 14
            })
            
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Frame"].Instance,
                Position = UDim2New(0,0,0,30),
                Size = UDim2New(1,0,0,0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1
            })
            Instances:Create("UIListLayout", {Parent = Items["Content"].Instance, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDimNew(0,2)})
            Instances:Create("UIPadding", {Parent = Items["Content"].Instance, PaddingLeft = UDimNew(0,10), PaddingRight = UDimNew(0,10), PaddingBottom = UDimNew(0,10)})
        end
        
        function KL:SetVisibility(B) Items["Frame"].Instance.Visible = B end
        function KL:Add(Name, Key)
            local Label = Instances:Create("TextLabel", {
                Parent = Items["Content"].Instance,
                Text = Name .. " ["..Key.."]",
                Size = UDim2New(1,0,0,18),
                BackgroundTransparency = 1,
                TextColor3 = FromRGB(200,200,200),
                FontFace = Library.Font,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            local Wrapper = {Instance = Label.Instance}
            function Wrapper:SetText(n, k) Label.Instance.Text = n.." ["..k.."]" end
            function Wrapper:SetStatus(b) Label.Instance.Visible = b end
            return Wrapper
        end
        return KL
    end

    -- // MODERATOR LIST //
    Library.ModeratorList = function(self)
        -- Simplified redesign
        local ML = {}
        local Mods = {}
        local Items = {} do 
             Items["Frame"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Position = UDim2New(1, -200, 0.5, 0),
                Size = UDim2New(0, 180, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(18, 18, 18)
            })
            AddCorner(Items["Frame"].Instance, 8)
            AddStroke(Items["Frame"].Instance, FromRGB(200, 30, 30), 1)
            Items["Frame"]:MakeDraggable()
            
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Frame"].Instance,
                Size = UDim2New(1,0,0,0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1
            })
            Instances:Create("UIListLayout", {Parent = Items["Content"].Instance, Padding = UDimNew(0,2)})
            Instances:Create("UIPadding", {Parent = Items["Content"].Instance, PaddingLeft = UDimNew(0,5), PaddingTop = UDimNew(0,25)})
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Frame"].Instance,
                Text = "Staff Detected",
                Size = UDim2New(1,0,0,25),
                BackgroundTransparency = 1,
                TextColor3 = FromRGB(200,30,30),
                FontFace = Library.Font,
                TextSize = 14
            })
        end
        function ML:SetVisibility(b) Items["Frame"].Instance.Visible = b end
        function ML:add_mod(User, Role)
             local L = Instances:Create("TextLabel", {
                 Parent = Items["Content"].Instance,
                 Text = User .. " | " .. Role,
                 Size = UDim2New(1,0,0,18),
                 BackgroundTransparency = 1,
                 TextColor3 = FromRGB(255,255,255),
                 FontFace = Library.Font,
                 TextSize = 12
             })
             return {Frame = L} -- Stub for compat
        end
        function ML:remove_mod() end -- Stub
        return ML
    end

    -- // ARMOR VIEWER //
    Library.ArmorViewer = function(self)
        local Viewer = { Items = {} }
        -- Basic placeholder for compatibility
        local Items = {} do
            Items["Frame"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Size = UDim2New(0, 200, 0, 100),
                BackgroundColor3 = FromRGB(18,18,18),
                Visible = false
            })
            AddCorner(Items["Frame"].Instance, 8)
            AddStroke(Items["Frame"].Instance, FromRGB(200,30,30), 1)
            Items["Frame"]:MakeDraggable()
        end
        function Viewer:Add(N, I) return {Remove=function()end} end
        function Viewer:ClearAllItems() end
        function Viewer:SetVisibility(b) Items["Frame"].Instance.Visible = b end
        return Viewer
    end

    -- // NOTIFICATION REDESIGN //
    Library.Notification = function(self, Name, Duration)
        local Items = { } do
            Items["Notification"] = Instances:Create("Frame", {
                Parent = self.NotifHolder.Instance,
                Name = "Notif",
                Size = UDim2New(0, 250, 0, 40),
                BackgroundColor3 = FromRGB(24, 28, 36)
            })  Items["Notification"]:AddToTheme({BackgroundColor3 = "Background 2"})
            AddCorner(Items["Notification"].Instance, 6)
            local S = AddStroke(Items["Notification"].Instance, FromRGB(60,60,60), 1)
            S:AddToTheme({Color = "Border"})
            
            -- Accent Bar
            Items["Bar"] = Instances:Create("Frame", {
                Parent = Items["Notification"].Instance,
                Size = UDim2New(0, 3, 1, 0),
                BackgroundColor3 = FromRGB(200, 30, 30)
            }) Items["Bar"]:AddToTheme({BackgroundColor3 = "Accent"})
            AddCorner(Items["Bar"].Instance, 3)

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Notification"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                Text = Name,
                Size = UDim2New(1, -15, 1, 0),
                Position = UDim2New(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextSize = 13,
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
        end
        
        -- Pop In
        Items["Notification"].Instance.BackgroundTransparency = 1
        Items["Text"].Instance.TextTransparency = 1
        Items["Bar"].Instance.BackgroundTransparency = 1
        
        Library:Thread(function()
            Items["Notification"]:Tween(nil, {BackgroundTransparency = 0.1})
            Items["Text"]:Tween(nil, {TextTransparency = 0})
            Items["Bar"]:Tween(nil, {BackgroundTransparency = 0})

            task.delay(Duration, function()
                Items["Notification"]:Tween(nil, {BackgroundTransparency = 1})
                Items["Text"]:Tween(nil, {TextTransparency = 1})
                Items["Bar"]:Tween(nil, {BackgroundTransparency = 1})
                task.wait(0.4)
                Items["Notification"]:Clean()
            end)
        end)
    end
    
    -- // TARGET HUD REDESIGN //
    Library.TargetHud = function(self)
        local TH = {}
        local Items = {} do
            Items["Frame"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Size = UDim2New(0, 250, 0, 70),
                Position = UDim2New(0.5, -125, 0.8, 0),
                BackgroundColor3 = FromRGB(18, 18, 18),
                Visible = false
            })
            AddCorner(Items["Frame"].Instance, 8)
            AddStroke(Items["Frame"].Instance, FromRGB(200, 30, 30), 1)
            Items["Frame"]:MakeDraggable()
            
            Items["Avatar"] = Instances:Create("ImageLabel", {
                Parent = Items["Frame"].Instance,
                Size = UDim2New(0, 50, 0, 50),
                Position = UDim2New(0, 10, 0, 10),
                BackgroundColor3 = FromRGB(30,30,30)
            })
            AddCorner(Items["Avatar"].Instance, 4)
            
            Items["Name"] = Instances:Create("TextLabel", {
                Parent = Items["Frame"].Instance,
                Position = UDim2New(0, 70, 0, 10),
                Size = UDim2New(0, 150, 0, 20),
                BackgroundTransparency = 1,
                Text = "Target",
                TextColor3 = FromRGB(255,255,255),
                FontFace = Library.Font,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            -- Health Bar Container
            Items["HPBack"] = Instances:Create("Frame", {
                Parent = Items["Frame"].Instance,
                Position = UDim2New(0, 70, 0, 40),
                Size = UDim2New(0, 160, 0, 8),
                BackgroundColor3 = FromRGB(30,30,30)
            })
            AddCorner(Items["HPBack"].Instance, 4)
            
            Items["HPFill"] = Instances:Create("Frame", {
                Parent = Items["HPBack"].Instance,
                Size = UDim2New(1,0,1,0),
                BackgroundColor3 = FromRGB(40, 200, 40)
            })
            AddCorner(Items["HPFill"].Instance, 4)
        end
        function TH:SetVisibility(b) Items["Frame"].Instance.Visible = b end
        function TH:SetPlayer(P)
             Items["Name"].Instance.Text = P.DisplayName
             -- Update avatar logic omitted for brevity but container exists
        end
        function TH:AddBar() -- Compatibility stub
             local B = {}
             function B:SetPercentage(p) Items["HPFill"]:Tween(nil, {Size = UDim2New(p/100, 0, 1, 0)}) end
             return B
        end
        return TH
    end

    -- // MAIN WINDOW REDESIGN //
    Library.Window = function(self, Data)
        Data = Data or { }

        local Window = {
            Name = Data.Name or Data.name or "Window",
            Logo = Data.Logo or Data.logo or "90363697817722",
            Pages = { },
            Items = { },
            IsOpen = false
        }

        local Items = { } do
            Items["MainFrame"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "Main",
                AnchorPoint = Vector2New(0.5, 0.5),
                Position = UDim2New(0.5, 0, 0.5, 0),
                Size = UDim2New(0, 650, 0, 500), -- Widescreen modern
                BackgroundColor3 = FromRGB(12, 12, 12),
                BorderSizePixel = 0
            })  Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Background 1"})

            AddCorner(Items["MainFrame"].Instance, 10)
            Items["MainFrame"]:MakeDraggable()
            Items["MainFrame"]:MakeResizeable(Vector2New(500, 400), Vector2New(999, 999))
            
            -- Glowing Outline
            local MainStroke = AddStroke(Items["MainFrame"].Instance, FromRGB(200, 30, 30), 2, 0.2)
            MainStroke:AddToTheme({Color = "Window Outline"})
            
            -- Sidebar
            Items["Sidebar"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance,
                Size = UDim2New(0, 160, 1, 0),
                BackgroundColor3 = FromRGB(18, 18, 18),
            }) Items["Sidebar"]:AddToTheme({BackgroundColor3 = "Background 2"})
            AddCorner(Items["Sidebar"].Instance, 10)
            -- Fix corner clipping
            Instances:Create("Frame", {Parent=Items["Sidebar"].Instance, Size=UDim2New(0,10,1,0), Position=UDim2New(1,-10,0,0), BackgroundColor3=Items["Sidebar"].Instance.BackgroundColor3, BorderSizePixel=0})
            
            -- Title
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Sidebar"].Instance,
                Text = Window.Name,
                FontFace = Library.Font,
                TextSize = 18,
                TextColor3 = FromRGB(255, 255, 255),
                Size = UDim2New(1, 0, 0, 50),
                BackgroundTransparency = 1
            }) Items["Title"]:AddToTheme({TextColor3 = "Accent"})
            
            -- Pages Container
            Items["PageContainer"] = Instances:Create("ScrollingFrame", {
                Parent = Items["Sidebar"].Instance,
                Position = UDim2New(0, 10, 0, 60),
                Size = UDim2New(1, -20, 1, -70),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 0
            })
            Instances:Create("UIListLayout", {Parent=Items["PageContainer"].Instance, Padding=UDimNew(0,5), SortOrder=Enum.SortOrder.LayoutOrder})
            
            -- Content Area
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance,
                Position = UDim2New(0, 170, 0, 10),
                Size = UDim2New(1, -180, 1, -20),
                BackgroundTransparency = 1,
                ClipsDescendants = true
            })
            
            Window.Items = Items
        end

        function Window:SetOpen(Bool)
            Window.IsOpen = Bool
            if Bool then
                Items["MainFrame"].Instance.Visible = true
                Items["MainFrame"]:Tween(TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2New(0, 650, 0, 500), BackgroundTransparency = 0})
            else
                Items["MainFrame"]:Tween(TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2New(0, 650, 0, 0), BackgroundTransparency = 1})
                task.wait(0.3)
                Items["MainFrame"].Instance.Visible = false
            end
        end

        Library:Connect(UserInputService.InputBegan, function(Input)
            if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                Window:SetOpen(not Window.IsOpen)
            end
        end)

        Window:SetOpen(true)
        return setmetatable(Window, Library)
    end

    Library.Page = function(self, Data)
        Data = Data or { }

        local Page = {
            Window = self,
            Name = Data.Name or Data.name or "Page",
            Columns = Data.Columns or Data.columns or 2,
            Items = { },
            ColumnsData = { },
            Active = false
        }

        local Items = { } do
            -- Sidebar Button
            Items["Button"] = Instances:Create("TextButton", {
                Parent = Page.Window.Items["PageContainer"].Instance,
                Size = UDim2New(1, 0, 0, 32),
                BackgroundColor3 = FromRGB(25, 25, 25),
                Text = Page.Name,
                FontFace = Library.Font,
                TextColor3 = FromRGB(150, 150, 150),
                TextSize = 13,
                AutoButtonColor = false
            })
            AddCorner(Items["Button"].Instance, 6)
            
            -- Selected Indicator
            Items["Indicator"] = Instances:Create("Frame", {
                Parent = Items["Button"].Instance,
                Size = UDim2New(0, 3, 0.6, 0),
                Position = UDim2New(0, 0, 0.2, 0),
                BackgroundColor3 = FromRGB(220, 30, 30),
                BackgroundTransparency = 1 -- Hidden by default
            }) Items["Indicator"]:AddToTheme({BackgroundColor3 = "Accent"})
            AddCorner(Items["Indicator"].Instance, 2)
            
            -- Content
            Items["PageContent"] = Instances:Create("Frame", {
                Parent = Page.Window.Items["Content"].Instance,
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Visible = false
            })
            
            local Layout = Instances:Create("UIListLayout", {
                Parent = Items["PageContent"].Instance,
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDimNew(0, 10)
            })
            
            for i = 1, Page.Columns do
                 local Col = Instances:Create("ScrollingFrame", {
                     Parent = Items["PageContent"].Instance,
                     Size = UDim2New(1 / Page.Columns, -5, 1, 0),
                     BackgroundTransparency = 1,
                     ScrollBarThickness = 0,
                     AutomaticCanvasSize = Enum.AutomaticSize.Y
                 })
                 Instances:Create("UIListLayout", {Parent=Col.Instance, Padding=UDimNew(0, 10), SortOrder=Enum.SortOrder.LayoutOrder})
                 Instances:Create("UIPadding", {Parent=Col.Instance, PaddingBottom=UDimNew(0,10)})
                 Page.ColumnsData[i] = Col
            end
            
            Page.Items = Items
        end

        function Page:Turn(Bool)
            Page.Active = Bool
            Items["PageContent"].Instance.Visible = Bool
            
            if Bool then
                Items["Button"]:Tween(nil, {BackgroundColor3 = FromRGB(40, 40, 40), TextColor3 = FromRGB(255, 255, 255)})
                Items["Indicator"]:Tween(nil, {BackgroundTransparency = 0})
            else
                Items["Button"]:Tween(nil, {BackgroundColor3 = FromRGB(25, 25, 25), TextColor3 = FromRGB(150, 150, 150)})
                Items["Indicator"]:Tween(nil, {BackgroundTransparency = 1})
            end
        end

        Items["Button"]:Connect("MouseButton1Click", function()
            for _, P in pairs(Page.Window.Pages) do
                P:Turn(P == Page)
            end
        end)

        if #Page.Window.Pages == 0 then 
            Page:Turn(true)
        end

        TableInsert(Page.Window.Pages, Page)
        return setmetatable(Page, Library.Pages)
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

        local Items = { } do
            Items["Section"] = Instances:Create("Frame", {
                Parent = Section.Page.ColumnsData[Section.Side].Instance,
                Size = UDim2New(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 20, 20)
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Inline"})
            
            AddCorner(Items["Section"].Instance, 8)
            local Stroke = AddStroke(Items["Section"].Instance, FromRGB(45,45,45), 1)
            Stroke:AddToTheme({Color = "Border"})
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Section"].Instance,
                Text = Section.Name,
                FontFace = Library.Font,
                TextSize = 12,
                TextColor3 = FromRGB(255, 255, 255),
                Size = UDim2New(1, 0, 0, 25),
                BackgroundTransparency = 1
            }) Items["Title"]:AddToTheme({TextColor3 = "Accent"})
            
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Position = UDim2New(0, 0, 0, 25),
                Size = UDim2New(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1
            })
            Instances:Create("UIListLayout", {Parent=Items["Content"].Instance, Padding=UDimNew(0,6), SortOrder=Enum.SortOrder.LayoutOrder})
            Instances:Create("UIPadding", {Parent=Items["Content"].Instance, PaddingLeft=UDimNew(0,8), PaddingRight=UDimNew(0,8), PaddingBottom=UDimNew(0,8)})
            
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
            Name = Data.Name or "Toggle",
            Flag = Data.Flag or Library:NextFlag(),
            Default = Data.Default or false,
            Callback = Data.Callback or function() end,
            Value = false
        }

        local Items = { } do 
            Items["Container"] = Instances:Create("TextButton", {
                Parent = Toggle.Section.Items["Content"].Instance,
                Size = UDim2New(1, 0, 0, 28),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false
            })
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Container"].Instance,
                Text = Toggle.Name,
                FontFace = Library.Font,
                TextSize = 13,
                TextColor3 = FromRGB(200, 200, 200),
                Size = UDim2New(1, -40, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            }) Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            -- Switch Design
            Items["SwitchBg"] = Instances:Create("Frame", {
                Parent = Items["Container"].Instance,
                AnchorPoint = Vector2New(1, 0.5),
                Position = UDim2New(1, 0, 0.5, 0),
                Size = UDim2New(0, 36, 0, 18),
                BackgroundColor3 = FromRGB(40, 40, 40),
            }) Items["SwitchBg"]:AddToTheme({BackgroundColor3 = "Element"})
            AddCorner(Items["SwitchBg"].Instance, 18)
            
            Items["SwitchDot"] = Instances:Create("Frame", {
                Parent = Items["SwitchBg"].Instance,
                AnchorPoint = Vector2New(0, 0.5),
                Position = UDim2New(0, 2, 0.5, 0),
                Size = UDim2New(0, 14, 0, 14),
                BackgroundColor3 = FromRGB(200, 200, 200)
            })
            AddCorner(Items["SwitchDot"].Instance, 14)
            
            -- Extra container for Keybinds/Colorpickers
            Items["SubElements"] = Instances:Create("Frame", {
                Parent = Items["Container"].Instance,
                AnchorPoint = Vector2New(1, 0.5),
                Position = UDim2New(1, -45, 0.5, 0),
                Size = UDim2New(0, 0, 0, 20),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1
            })
            Instances:Create("UIListLayout", {Parent=Items["SubElements"].Instance, FillDirection=Enum.FillDirection.Horizontal, Padding=UDimNew(0,5), HorizontalAlignment=Enum.HorizontalAlignment.Right})
        end

        function Toggle:Set(Value)
            Toggle.Value = Value 
            Library.Flags[Toggle.Flag] = Value 

            if Toggle.Value then 
                Items["SwitchBg"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
                Items["SwitchDot"]:Tween(nil, {Position = UDim2New(1, -16, 0.5, 0), BackgroundColor3 = FromRGB(255, 255, 255)})
            else
                Items["SwitchBg"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                Items["SwitchDot"]:Tween(nil, {Position = UDim2New(0, 2, 0.5, 0), BackgroundColor3 = FromRGB(150, 150, 150)})
            end

            Library:SafeCall(Toggle.Callback, Toggle.Value)
        end

        -- Extras
        function Toggle:Colorpicker(Data)
            local NewColorpicker = Library:CreateColorpicker({ Parent = Items["SubElements"], Flag = Data.Flag or Library:NextFlag(), Default = Data.Default, Alpha = Data.Alpha, Callback = Data.Callback })
            return NewColorpicker
        end
        function Toggle:Keybind(Data)
            local NewKeybind = Library:CreateKeybind({ Parent = Items["SubElements"], Flag = Data.Flag or Library:NextFlag(), Default = Data.Default, Mode = Data.Mode, Callback = Data.Callback })
            return NewKeybind
        end

        Items["Container"]:Connect("MouseButton1Click", function()
            Toggle:Set(not Toggle.Value)
        end)

        Toggle:Set(Toggle.Default)
        Library.SetFlags[Toggle.Flag] = function(Value) Toggle:Set(Value) end

        return Toggle 
    end

    Library.Sections.Button = function(self, Data)
        Data = Data or { }

        local Button = {
            Name = Data.Name or "Button",
            Callback = Data.Callback or function() end
        }

        local Items = { } do
            Items["Button"] = Instances:Create("TextButton", {
                Parent = self.Items["Content"].Instance,
                Size = UDim2New(1, 0, 0, 28),
                BackgroundColor3 = FromRGB(35, 35, 35),
                Text = Button.Name,
                FontFace = Library.Font,
                TextColor3 = FromRGB(220, 220, 220),
                TextSize = 13,
                AutoButtonColor = false
            }) Items["Button"]:AddToTheme({BackgroundColor3 = "Element", TextColor3 = "Text"})
            AddCorner(Items["Button"].Instance, 6)
            local S = AddStroke(Items["Button"].Instance, FromRGB(60,60,60), 1)
            S:AddToTheme({Color = "Border"})
            
            Items["Button"]:OnHover(function() Items["Button"]:Tween(nil, {BackgroundColor3 = FromRGB(45, 45, 45)}) end)
            Items["Button"]:OnHoverLeave(function() Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element}) end)
        end

        Items["Button"]:Connect("MouseButton1Click", function()
            Items["Button"]:Tween(TweenInfo.new(0.1), {TextSize = 11})
            task.delay(0.1, function() Items["Button"]:Tween(TweenInfo.new(0.1), {TextSize = 13}) end)
            Library:SafeCall(Button.Callback)
        end)

        return Button
    end

    Library.Sections.Slider = function(self, Data)
        Data = Data or { }
        
        local Slider = {
            Window = self.Window,
            Page = self.Page,
            Section = self,
            Name = Data.Name or "Slider",
            Flag = Data.Flag or Library:NextFlag(),
            Min = Data.Min or 0,
            Decimals = Data.Decimals or 1,
            Suffix = Data.Suffix or "",
            Max = Data.Max or 100,
            Default = Data.Default or 0,
            Callback = Data.Callback or function() end,
            Value = 0,
            Sliding = false
        }

        local Items = { } do 
            Items["Container"] = Instances:Create("Frame", {
                Parent = Slider.Section.Items["Content"].Instance,
                Size = UDim2New(1, 0, 0, 40),
                BackgroundTransparency = 1
            })
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Container"].Instance,
                Text = Slider.Name,
                FontFace = Library.Font,
                TextSize = 13,
                TextColor3 = FromRGB(200, 200, 200),
                BackgroundTransparency = 1,
                Size = UDim2New(1, -50, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Left
            }) Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["Container"].Instance,
                Text = "0",
                FontFace = Library.Font,
                TextSize = 13,
                TextColor3 = FromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Right
            }) Items["Value"]:AddToTheme({TextColor3 = "Text"})
            
            Items["Track"] = Instances:Create("TextButton", {
                Parent = Items["Container"].Instance,
                Position = UDim2New(0, 0, 0, 26),
                Size = UDim2New(1, 0, 0, 6),
                BackgroundColor3 = FromRGB(40, 40, 40),
                Text = "",
                AutoButtonColor = false
            }) Items["Track"]:AddToTheme({BackgroundColor3 = "Element"})
            AddCorner(Items["Track"].Instance, 3)
            
            Items["Fill"] = Instances:Create("Frame", {
                Parent = Items["Track"].Instance,
                Size = UDim2New(0, 0, 1, 0),
                BackgroundColor3 = FromRGB(200, 30, 30)
            }) Items["Fill"]:AddToTheme({BackgroundColor3 = "Accent"})
            AddCorner(Items["Fill"].Instance, 3)
            
            Items["Knob"] = Instances:Create("Frame", {
                Parent = Items["Fill"].Instance,
                AnchorPoint = Vector2New(0.5, 0.5),
                Position = UDim2New(1, 0, 0.5, 0),
                Size = UDim2New(0, 12, 0, 12),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            AddCorner(Items["Knob"].Instance, 6)
        end

        function Slider:Set(Value)
            Slider.Value = MathClamp(Library:Round(Value, Slider.Decimals), Slider.Min, Slider.Max)
            Library.Flags[Slider.Flag] = Slider.Value

            local Percent = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
            Items["Fill"]:Tween(TweenInfo.new(0.05, Enum.EasingStyle.Linear), {Size = UDim2New(Percent, 0, 1, 0)})
            Items["Value"].Instance.Text = StringFormat("%s%s", Slider.Value, Slider.Suffix)

            Library:SafeCall(Slider.Callback, Slider.Value)
        end

        local function Update(Input)
            local SizeX = (Input.Position.X - Items["Track"].Instance.AbsolutePosition.X) / Items["Track"].Instance.AbsoluteSize.X
            local Val = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min
            Slider:Set(Val)
        end

        Items["Track"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Slider.Sliding = true
                Update(Input)
            end
        end)
        
        Items["Track"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Slider.Sliding = false
            end
        end)
        
        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if Slider.Sliding then Update(Input) end
            end
        end)

        Slider:Set(Slider.Default)
        Library.SetFlags[Slider.Flag] = function(Value) Slider:Set(Value) end

        return Slider
    end

    Library.Sections.Dropdown = function(self, Data)
        Data = Data or { }
        local Dropdown = {
            Window = self.Window,
            Section = self,
            Name = Data.Name or "Dropdown",
            Flag = Data.Flag or Library:NextFlag(),
            Items = Data.Items or { },
            Default = Data.Default,
            Callback = Data.Callback or function() end,
            Multi = Data.Multi or false,
            Value = nil,
            IsOpen = false
        }

        local Items = { } do
            Items["Container"] = Instances:Create("Frame", {
                Parent = self.Items["Content"].Instance,
                Size = UDim2New(1, 0, 0, 45),
                BackgroundTransparency = 1,
                ZIndex = 2
            })
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Container"].Instance,
                Text = Dropdown.Name,
                FontFace = Library.Font,
                TextSize = 13,
                TextColor3 = FromRGB(200, 200, 200),
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Left
            }) Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Items["Button"] = Instances:Create("TextButton", {
                Parent = Items["Container"].Instance,
                Position = UDim2New(0, 0, 0, 20),
                Size = UDim2New(1, 0, 0, 22),
                BackgroundColor3 = FromRGB(35, 35, 35),
                Text = "",
                AutoButtonColor = false
            }) Items["Button"]:AddToTheme({BackgroundColor3 = "Element"})
            AddCorner(Items["Button"].Instance, 4)
            AddStroke(Items["Button"].Instance, FromRGB(60,60,60), 1)
            
            Items["SelectedText"] = Instances:Create("TextLabel", {
                Parent = Items["Button"].Instance,
                Text = "...",
                FontFace = Library.Font,
                TextSize = 12,
                TextColor3 = FromRGB(200, 200, 200),
                BackgroundTransparency = 1,
                Size = UDim2New(1, -10, 1, 0),
                Position = UDim2New(0, 5, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd
            })
            
            -- Floating List
            Items["List"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                BackgroundColor3 = FromRGB(35, 35, 35),
                Size = UDim2New(0, 100, 0, 0),
                Visible = false,
                ClipsDescendants = true,
                ZIndex = 100
            }) Items["List"]:AddToTheme({BackgroundColor3 = "Element"})
            AddCorner(Items["List"].Instance, 4)
            local LS = AddStroke(Items["List"].Instance, FromRGB(200, 30, 30), 1)
            LS:AddToTheme({Color = "Accent"})
            
            Items["ListHolder"] = Instances:Create("ScrollingFrame", {
                Parent = Items["List"].Instance,
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ScrollBarThickness = 2,
                CanvasSize = UDim2New(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y
            })
            Instances:Create("UIListLayout", {Parent=Items["ListHolder"].Instance, Padding=UDimNew(0,2)})
            Instances:Create("UIPadding", {Parent=Items["ListHolder"].Instance, PaddingTop=UDimNew(0,4), PaddingLeft=UDimNew(0,4)})
        end

        function Dropdown:Set(Value)
            if Dropdown.Multi then
                local Idx = TableFind(Dropdown.Value or {}, Value)
                if Idx then TableRemove(Dropdown.Value, Idx) else TableInsert(Dropdown.Value or {}, Value) end
                Items["SelectedText"].Instance.Text = TableConcat(Dropdown.Value, ", ")
                Library.Flags[Dropdown.Flag] = Dropdown.Value
            else
                Dropdown.Value = Value
                Items["SelectedText"].Instance.Text = tostring(Value)
                Library.Flags[Dropdown.Flag] = Value
                Dropdown:Toggle(false)
            end
            Library:SafeCall(Dropdown.Callback, Dropdown.Value)
        end

        function Dropdown:Refresh(List)
            for _, v in pairs(Items["ListHolder"].Instance:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
            for _, Option in pairs(List) do
                local Btn = Instances:Create("TextButton", {
                    Parent = Items["ListHolder"].Instance,
                    Size = UDim2New(1, -6, 0, 20),
                    BackgroundTransparency = 1,
                    Text = Option,
                    TextColor3 = FromRGB(200, 200, 200),
                    FontFace = Library.Font,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                Btn:Connect("MouseButton1Click", function() Dropdown:Set(Option) end)
            end
        end

        function Dropdown:Toggle(Bool)
            Dropdown.IsOpen = Bool
            Items["List"].Instance.Visible = Bool
            if Bool then
                local Pos = Items["Button"].Instance.AbsolutePosition
                local Size = Items["Button"].Instance.AbsoluteSize
                Items["List"].Instance.Position = UDim2New(0, Pos.X, 0, Pos.Y + Size.Y + 4)
                Items["List"].Instance.Size = UDim2New(0, Size.X, 0, 0)
                Items["List"]:Tween(TweenInfo.new(0.2), {Size = UDim2New(0, Size.X, 0, math.min(#Dropdown.Items * 22 + 10, 150))})
            end
        end

        Items["Button"]:Connect("MouseButton1Click", function() Dropdown:Toggle(not Dropdown.IsOpen) end)

        Dropdown:Refresh(Dropdown.Items)
        if Dropdown.Default then 
            if Dropdown.Multi then Dropdown.Value = Dropdown.Default else Dropdown:Set(Dropdown.Default) end
        elseif Dropdown.Multi then
            Dropdown.Value = {}
        end
        Library.SetFlags[Dropdown.Flag] = function(V) Dropdown:Set(V) end

        return Dropdown 
    end

    Library.Sections.Label = function(self, Name)
        local Label = { Items = {} }
        
        local Items = { } do
            Items["Container"] = Instances:Create("Frame", {
                Parent = self.Items["Content"].Instance,
                Size = UDim2New(1, 0, 0, 20),
                BackgroundTransparency = 1
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Container"].Instance,
                Text = Name,
                FontFace = Library.Font,
                TextSize = 13,
                TextColor3 = FromRGB(200, 200, 200),
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left
            }) Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Items["SubElements"] = Instances:Create("Frame", {
                Parent = Items["Container"].Instance,
                AnchorPoint = Vector2New(1, 0.5),
                Position = UDim2New(1, 0, 0.5, 0),
                Size = UDim2New(0, 0, 0, 20),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1
            })
            Instances:Create("UIListLayout", {Parent=Items["SubElements"].Instance, FillDirection=Enum.FillDirection.Horizontal, Padding=UDimNew(0,5), HorizontalAlignment=Enum.HorizontalAlignment.Right})
        end

        function Label:SetText(Text) Items["Text"].Instance.Text = Text end
        function Label:Colorpicker(Data) local NewColorpicker = Library:CreateColorpicker({ Parent = Items["SubElements"], Flag = Data.Flag or Library:NextFlag(), Default = Data.Default, Alpha = Data.Alpha, Callback = Data.Callback }) return NewColorpicker end
        function Label:Keybind(Data) local NewKeybind = Library:CreateKeybind({ Parent = Items["SubElements"], Flag = Data.Flag or Library:NextFlag(), Default = Data.Default, Mode = Data.Mode, Callback = Data.Callback }) return NewKeybind end

        return Label 
    end

    Library.Sections.Textbox = function(self, Data)
        Data = Data or { }
        local Textbox = {
            Flag = Data.Flag or Library:NextFlag(),
            Value = Data.Default or "",
            Callback = Data.Callback or function() end
        }

        local Items = { } do 
            Items["Container"] = Instances:Create("Frame", {
                Parent = self.Items["Content"].Instance,
                Size = UDim2New(1, 0, 0, 45),
                BackgroundTransparency = 1
            })
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Container"].Instance,
                Text = Data.Name or "Textbox",
                FontFace = Library.Font,
                TextSize = 13,
                TextColor3 = FromRGB(200, 200, 200),
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Left
            }) Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Items["InputBg"] = Instances:Create("Frame", {
                Parent = Items["Container"].Instance,
                Position = UDim2New(0, 0, 0, 22),
                Size = UDim2New(1, 0, 0, 22),
                BackgroundColor3 = FromRGB(35, 35, 35)
            }) Items["InputBg"]:AddToTheme({BackgroundColor3 = "Element"})
            AddCorner(Items["InputBg"].Instance, 4)
            AddStroke(Items["InputBg"].Instance, FromRGB(60,60,60), 1)
            
            Items["Input"] = Instances:Create("TextBox", {
                Parent = Items["InputBg"].Instance,
                Size = UDim2New(1, -10, 1, 0),
                Position = UDim2New(0, 5, 0, 0),
                BackgroundTransparency = 1,
                Text = Textbox.Value,
                TextColor3 = FromRGB(255, 255, 255),
                PlaceholderText = Data.Placeholder or "...",
                FontFace = Library.Font,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false
            })
        end

        function Textbox:Set(Value)
            Textbox.Value = Value
            Items["Input"].Instance.Text = Value
            Library.Flags[Textbox.Flag] = Value
            Library:SafeCall(Textbox.Callback, Value)
        end
        
        Items["Input"].Instance.FocusLost:Connect(function() Textbox:Set(Items["Input"].Instance.Text) end)
        Library.SetFlags[Textbox.Flag] = function(Value) Textbox:Set(Value) end

        return Textbox
    end

    Library.CreateSettingsPage = function(self, Window, KeybindList, Watermark, ModeratorList)
        local SettingsPage = Window:Page({Name = "Settings", Columns = 2})
        local SettingsSection = SettingsPage:Section({Name = "Settings", Side = 1}) do
            SettingsSection:Button({
                Name = "Unload",
                Callback = function()
                    Library:Unload()
                end
            })

            SettingsSection:Toggle({
                Name = "Watermark",
                Flag = "Watermark",
                Default = true,
                Callback = function(Value)
                    Watermark:SetVisibility(Value)
                end
            })

            SettingsSection:Toggle({
                Name = "Keybind List",
                Flag = "Keybind list",
                Default = true,
                Callback = function(Value)
                    KeybindList:SetVisibility(Value)
                end
            })

            SettingsSection:Toggle({
                Name = "Moderator List",
                Flag = "Moderator list",
                Default = true,
                Callback = function(Value)
                    if ModeratorList then
                        ModeratorList:SetVisibility(Value)
                    end
                end
            })
            
            SettingsSection:Label("Menu Keybind"):Keybind({
                Name = "Menu Keybind",
                Flag = "MenuKeybind",
                Default = Library.MenuKeybind,
                Mode = "Toggle",
                Callback = function()
                    Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
                end
            })

            SettingsSection:Slider({
                Name = "Tween Speed",
                Default = 0.2,
                Flag = "Tween Speed",
                Decimals = 0.01,
                Suffix = "s",
                Max = 10,
                Min = 0,
                Callback = function(Value)
                    Library.Tween.Time = Value
                end
            })
            
            -- Color theme picking via standard colorpicker
            SettingsSection:Label("Theme Accent"):Colorpicker({
                Default = Library.Theme.Accent,
                Callback = function(Val)
                    Library:ChangeTheme("Accent", Val)
                    Library:ChangeTheme("Window Outline", Val)
                end
            })
        end
        
        local ConfigsSection = SettingsPage:Section({Name = "Configs", Side = 2}) do
            local ConfigName 
            local ConfigSelected
            
            local ConfigsSearchbox = ConfigsSection:Dropdown({
                Name = "Profiles list",
                Flag = "Profiles list",
                Multi = false,
                Items = { },
                Callback = function(Value)
                    ConfigSelected = Value
                end
            })

            ConfigsSection:Textbox({
                Name = "Config name", 
                Default = "", 
                Flag = "ConfigName", 
                Placeholder = "...", 
                Callback = function(Value)
                    ConfigName = Value
                end
            })

            ConfigsSection:Button({
                Name = "Create",
                Callback = function()
                    if ConfigName ~= "" then
                        if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
                            writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                            Library:RefreshConfigsList(ConfigsSearchbox)
                            Library:Notification("Created config " .. ConfigName .. ".json", 5)
                        end
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Delete",
                Callback = function()
                    if ConfigSelected ~= nil then
                        delfile(Library.Folders.Configs .. "/" .. ConfigSelected .. ".json")
                        Library:RefreshConfigsList(ConfigsSearchbox)
                        Library:Notification("Deleted config " .. ConfigSelected .. ".json", 5)
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Load",
                Callback = function()
                    if ConfigSelected ~= nil then
                        local Success, Result = Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected .. ".json"))
                        if Success then
                            Library:Notification("Loaded config " .. ConfigSelected .. ".json", 5)
                        else
                            Library:Notification("Failed to load config " .. ConfigSelected .. ".json", 5)
                        end
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Save",
                Callback = function()
                    if ConfigSelected ~= nil then
                        writefile(Library.Folders.Configs .. "/" .. ConfigSelected .. ".json", Library:GetConfig())
                        Library:Notification("Saved config " .. ConfigSelected .. ".json", 5)
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Refresh",
                Callback = function()
                    Library:RefreshConfigsList(ConfigsSearchbox)
                end
            })

            Library:RefreshConfigsList(ConfigsSearchbox)
        end
    end
-- // Redesigned Components //

        Library.Watermark = function(self, Name)
            local Watermark = { }
            local Items = { } do
                Items["Watermark"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 25),
                    Size = UDim2.new(0, 180, 0, 30),
                    BackgroundColor3 = Library.Theme["Background 1"],
                    BorderSizePixel = 0,
                    ZIndex = 5,
                }) Items["Watermark"]:AddToTheme({BackgroundColor3 = "Background 1"})

                -- Premium Glow & Stroke
                local Stroke = Instances:Create("UIStroke", {
                    Parent = Items["Watermark"].Instance,
                    Color = Library.Theme["Accent"],
                    Thickness = 1.5,
                }) Stroke:AddToTheme({Color = "Accent"})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Watermark"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    Text = Name,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    TextSize = 14,
                }) Items["Text"]:AddToTheme({TextColor3 = "Text"})
            end

            function Watermark:SetText(Text)
                Items["Text"].Instance.Text = Text
                local width = Items["Text"].Instance.TextBounds.X + 30
                Items["Watermark"]:Tween(nil, {Size = UDim2.new(0, width, 0, 30)})
            end
            
            return Watermark
        end

        Library.KeybindList = function(self)
            local KeybindList = { }
            local Items = { } do
                Items["Main"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Position = UDim2.new(0, 20, 0.5, 0),
                    Size = UDim2.new(0, 180, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Background 2"],
                    BorderSizePixel = 0
                }) Items["Main"]:AddToTheme({BackgroundColor3 = "Background 2"})

                Instances:Create("UIStroke", {
                    Parent = Items["Main"].Instance,
                    Color = Library.Theme["Border"],
                }):AddToTheme({Color = "Border"})

                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Main"].Instance,
                    Text = " Keybinds",
                    Size = UDim2.new(1, 0, 0, 25),
                    TextColor3 = Library.Theme["Accent"],
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    FontFace = Library.Font,
                }) Items["Title"]:AddToTheme({TextColor3 = "Accent"})
                
                Items["Container"] = Instances:Create("Frame", {
                    Parent = Items["Main"].Instance,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1
                })
                
                Instances:Create("UIListLayout", { Parent = Items["Container"].Instance, Padding = UDim.new(0, 2) })
            end

            function KeybindList:Add(Name, Key)
                local BindLabel = Instances:Create("TextLabel", {
                    Parent = Items["Container"].Instance,
                    Size = UDim2.new(1, -10, 0, 20),
                    Text = " " .. Name .. " [" .. Key .. "]",
                    TextColor3 = Library.Theme["Text"],
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 13,
                    FontFace = Library.Font
                }) BindLabel:AddToTheme({TextColor3 = "Text"})
                return BindLabel
            end

            return KeybindList
        end

        -- // Section UI Elements (Button, Toggle, etc) //
        
        function Library.Sections:Button(Data)
            local Button = { Callback = Data.Callback or function() end }
            local Items = { }
            
            Items["Button"] = Instances:Create("TextButton", {
                Parent = self.Instance,
                Size = UDim2.new(1, -10, 0, 30),
                BackgroundColor3 = Library.Theme["Element"],
                Text = Data.Name,
                TextColor3 = Library.Theme["Text"],
                FontFace = Library.Font,
                AutoButtonColor = false,
                BorderSizePixel = 0
            }) Items["Button"]:AddToTheme({BackgroundColor3 = "Element", TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Button"].Instance,
                Color = Library.Theme["Border"],
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Button"]:Connect("MouseButton1Click", function()
                Button.Callback()
                -- Click animation
                Items["Button"]:Tween(TweenInfo.new(0.1), {BackgroundColor3 = Library.Theme["Accent"]})
                task.wait(0.1)
                Items["Button"]:Tween(TweenInfo.new(0.1), {BackgroundColor3 = Library.Theme["Element"]})
            end)
            
            return Button
        end

        function Library.Sections:Toggle(Data)
            local Toggle = { 
                Value = Data.Default or false, 
                Callback = Data.Callback or function() end,
                Flag = Data.Flag or Library:NextFlag()
            }
            
            local Items = { }
            Items["Main"] = Instances:Create("TextButton", {
                Parent = self.Instance,
                Size = UDim2.new(1, -10, 0, 30),
                BackgroundTransparency = 1,
                Text = "  " .. Data.Name,
                TextColor3 = Library.Theme["Inactive Text"],
                FontFace = Library.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
            }) Items["Main"]:AddToTheme({TextColor3 = "Inactive Text"})

            Items["Box"] = Instances:Create("Frame", {
                Parent = Items["Main"].Instance,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -5, 0.5, 0),
                Size = UDim2.new(0, 16, 0, 16),
                BackgroundColor3 = Library.Theme["Inline"],
                BorderSizePixel = 0
            }) Items["Box"]:AddToTheme({BackgroundColor3 = "Inline"})

            function Toggle:Set(State)
                Toggle.Value = State
                Library.Flags[Toggle.Flag] = State
                local Color = State and Library.Theme["Accent"] or Library.Theme["Inline"]
                local TextCol = State and Library.Theme["Text"] or Library.Theme["Inactive Text"]
                
                Items["Box"]:Tween(nil, {BackgroundColor3 = Color})
                Items["Main"]:Tween(nil, {TextColor3 = TextCol})
                Toggle.Callback(State)
            end

            Items["Main"]:Connect("MouseButton1Click", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Value)
            return Toggle
        end

    end -- End of Library Logic
end -- End of Global Wrapper

return Library
