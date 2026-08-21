-- Variables 
    local uis = game:GetService("UserInputService") 
    local players = game:GetService("Players") 
    local ws = game:GetService("Workspace")
    local rs = game:GetService("ReplicatedStorage")
    local http_service = game:GetService("HttpService")
    local gui_service = game:GetService("GuiService")
    local lighting = game:GetService("Lighting")
    local run = game:GetService("RunService")
    local stats = game:GetService("Stats")
    local coregui = game:GetService("CoreGui")
    local debris = game:GetService("Debris")
    local tween_service = game:GetService("TweenService")
    local sound_service = game:GetService("SoundService")

    local vec2 = Vector2.new
    local vec3 = Vector3.new
    local dim2 = UDim2.new
    local dim = UDim.new 
    local rect = Rect.new
    local cfr = CFrame.new
    local empty_cfr = cfr()
    local point_object_space = empty_cfr.PointToObjectSpace
    local angle = CFrame.Angles
    local dim_offset = UDim2.fromOffset

    local color = Color3.new
    local rgb = Color3.fromRGB
    local hex = Color3.fromHex
    local hsv = Color3.fromHSV
    local rgbseq = ColorSequence.new
    local rgbkey = ColorSequenceKeypoint.new
    local numseq = NumberSequence.new
    local numkey = NumberSequenceKeypoint.new

    local camera = ws.CurrentCamera
    local lp = players.LocalPlayer 
    local mouse = lp:GetMouse() 
    local gui_offset = gui_service:GetGuiInset().Y

    local max = math.max 
    local floor = math.floor 
    local min = math.min 
    local abs = math.abs 
    local noise = math.noise
    local rad = math.rad 
    local random = math.random 
    local pow = math.pow 
    local sin = math.sin 
    local pi = math.pi 
    local tan = math.tan 
    local atan2 = math.atan2 
    local clamp = math.clamp 

    local insert = table.insert 
    local find = table.find 
    local remove = table.remove
    local concat = table.concat
-- 

-- Library init
    getgenv().library = {
        directory = "monolithhh",
        folders = {
            "/fonts",
            "/configs",
        },
        flags = {},
        config_flags = {},
        connections = {},   
        notifications = {notifs = {}},
        current_open; 
    }

    local keys = {
        [Enum.KeyCode.LeftShift] = "LS",
        [Enum.KeyCode.RightShift] = "RS",
        [Enum.KeyCode.LeftControl] = "LC",
        [Enum.KeyCode.RightControl] = "RC",
        [Enum.KeyCode.Insert] = "INS",
        [Enum.KeyCode.Backspace] = "BS",
        [Enum.KeyCode.Return] = "Ent",
        [Enum.KeyCode.LeftAlt] = "LA",
        [Enum.KeyCode.RightAlt] = "RA",
        [Enum.KeyCode.CapsLock] = "CAPS",
        [Enum.KeyCode.One] = "1",
        [Enum.KeyCode.Two] = "2",
        [Enum.KeyCode.Three] = "3",
        [Enum.KeyCode.Four] = "4",
        [Enum.KeyCode.Five] = "5",
        [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7",
        [Enum.KeyCode.Eight] = "8",
        [Enum.KeyCode.Nine] = "9",
        [Enum.KeyCode.Zero] = "0",
        [Enum.KeyCode.KeypadOne] = "Num1",
        [Enum.KeyCode.KeypadTwo] = "Num2",
        [Enum.KeyCode.KeypadThree] = "Num3",
        [Enum.KeyCode.KeypadFour] = "Num4",
        [Enum.KeyCode.KeypadFive] = "Num5",
        [Enum.KeyCode.KeypadSix] = "Num6",
        [Enum.KeyCode.KeypadSeven] = "Num7",
        [Enum.KeyCode.KeypadEight] = "Num8",
        [Enum.KeyCode.KeypadNine] = "Num9",
        [Enum.KeyCode.KeypadZero] = "Num0",
        [Enum.KeyCode.Minus] = "-",
        [Enum.KeyCode.Equals] = "=",
        [Enum.KeyCode.Tilde] = "~",
        [Enum.KeyCode.LeftBracket] = "[",
        [Enum.KeyCode.RightBracket] = "]",
        [Enum.KeyCode.RightParenthesis] = ")",
        [Enum.KeyCode.LeftParenthesis] = "(",
        [Enum.KeyCode.Semicolon] = ",",
        [Enum.KeyCode.Quote] = "'",
        [Enum.KeyCode.BackSlash] = "\\",
        [Enum.KeyCode.Comma] = ",",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Slash] = "/",
        [Enum.KeyCode.Asterisk] = "*",
        [Enum.KeyCode.Plus] = "+",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Backquote] = "`",
        [Enum.UserInputType.MouseButton1] = "MB1",
        [Enum.UserInputType.MouseButton2] = "MB2",
        [Enum.UserInputType.MouseButton3] = "MB3",
        [Enum.KeyCode.Escape] = "ESC",
        [Enum.KeyCode.Space] = "SPC",
    }
        
    library.__index = library

    for _, path in next, library.folders do 
        makefolder(library.directory .. path)
    end

    local flags = library.flags 
    local config_flags = library.config_flags
    local notifications = library.notifications 

    -- Font importing system 
        if isfile(library.directory .. "/fonts/main.ttf") then 
            delfile(library.directory .. "/fonts/main.ttf")
        else 
            writefile(library.directory .. "/fonts/main.ttf", game:HttpGet("https://github.com/f1nobe7650/Nebula/raw/refs/heads/main/Minecraftia-Regular.ttf"))
        end 
        
        local minecraftia = {
            name = "Minecraftia",
            faces = {
                {
                    name = "Regular",
                    weight = 400,
                    style = "normal",
                    assetId = getcustomasset(library.directory .. "/fonts/main.ttf")
                }
            }
        }
        
        if not isfile(library.directory .. "/fonts/main_encoded.ttf") then 
            writefile(library.directory .. "/fonts/main_encoded.ttf", http_service:JSONEncode(minecraftia))
        end 
        
        library.font = Font.new(getcustomasset(library.directory .. "/fonts/main_encoded.ttf"), Enum.FontWeight.Regular)
        -- library.font = library.font
    -- 
--

-- Library functions 
    -- Misc functions
        function library:tween(obj, properties, easing_style, time) 
            local tween = tween_service:Create(obj, TweenInfo.new(time or 0.25, easing_style or Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0), properties)
            tween:Play()
                
            return tween
        end

        function library:get_transparency(obj)
            if obj:IsA("Frame") then
                return {"BackgroundTransparency"}
            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                return { "BackgroundTransparency", "ImageTransparency" }
            elseif obj:IsA("ScrollingFrame") then
                return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif obj:IsA("TextBox") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif obj:IsA("UIStroke") then 
                return { "Transparency" }
            end
            
            return nil
        end

        function library:fade(obj, prop, vis, speed)
            if not (obj and prop) then
                return
            end

            local OldTransparency = obj[prop]
            obj[prop] = vis and 1 or OldTransparency

            local Tween = library:tween(obj, { [prop] = vis and OldTransparency or 1 })

            library:connection(Tween.Completed, function()
                if not vis then
                    task.wait()
                    obj[prop] = OldTransparency
                end
            end)

            return Tween
        end

        function library:resizify(frame) 
            local Frame = Instance.new("TextButton")
            Frame.Position = dim2(1, -10, 1, -10)
            Frame.BorderColor3 = rgb(0, 0, 0)
            Frame.Size = dim2(0, 10, 0, 10)
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = rgb(255, 255, 255)
            Frame.Parent = frame
            Frame.BackgroundTransparency = 1 
            Frame.Text = ""

            local resizing = false 
            local start_size 
            local start 
            local og_size = frame.Size  

            Frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    resizing = true
                    start = input.Position
                    start_size = frame.Size
                end
            end)

            Frame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    resizing = false
                end
            end)

            library:connection(uis.InputChanged, function(input, game_event) 
                if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local viewport_x = camera.ViewportSize.X
                    local viewport_y = camera.ViewportSize.Y

                    local current_size = dim2(
                        start_size.X.Scale,
                        math.clamp(
                            start_size.X.Offset + (input.Position.X - start.X),
                            og_size.X.Offset,
                            viewport_x
                        ),
                        start_size.Y.Scale,
                        math.clamp(
                            start_size.Y.Offset + (input.Position.Y - start.Y),
                            og_size.Y.Offset,
                            viewport_y
                        )
                    )

                    -- library:tween(frame, {Size = current_size}, Enum.EasingStyle.Linear, 0.05) -- nobody will ntoice this aswell 👿
                    frame.Size = current_size
                end
            end)
        end 

        function library:mouse_in_frame(uiobject)
            local y_cond = uiobject.AbsolutePosition.Y <= mouse.Y and mouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
            local x_cond = uiobject.AbsolutePosition.X <= mouse.X and mouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X

            return (y_cond and x_cond)
        end

        function library:draggify(frame)
            local dragging = false 
            local start_size = frame.Position
            local start 

            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    start = input.Position
                    start_size = frame.Position
                end
            end)

            frame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            library:connection(uis.InputChanged, function(input, game_event) 
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local viewport_x = camera.ViewportSize.X
                    local viewport_y = camera.ViewportSize.Y

                    local current_position = dim2(
                        0,
                        clamp(
                            start_size.X.Offset + (input.Position.X - start.X),
                            0,
                            viewport_x - frame.Size.X.Offset
                        ),
                        0,
                        math.clamp(
                            start_size.Y.Offset + (input.Position.Y - start.Y),
                            0,
                            viewport_y - frame.Size.Y.Offset
                        )
                    )

                    -- library:tween(frame, {Position = current_position}, Enum.EasingStyle.Linear, 0) -- heh, nobody will notice 
                    frame.Position = current_position
                    library:close_current_element(nil) 
                end
            end)
        end 

        function library:convert(str)
            local values = {}

            for value in string.gmatch(str, "[^,]+") do
                insert(values, tonumber(value))
            end
            
            if #values == 4 then              
                return unpack(values)
            else 
                return
            end
        end
        
        function library:convert_enum(enum)
            local enum_parts = {}
        
            for part in string.gmatch(enum, "[%w_]+") do
                insert(enum_parts, part)
            end
        
            local enum_table = Enum
            for i = 2, #enum_parts do
                local enum_item = enum_table[enum_parts[i]]
        
                enum_table = enum_item
            end
        
            return enum_table
        end

        local config_holder;
        function library:update_config_list() 
            if not config_holder then 
                return 
            end
            
            local list = {}
            
            for idx, file in listfiles(library.directory .. "/configs") do
                local name = file:gsub(library.directory .. "/configs\\", ""):gsub(".cfg", ""):gsub(library.directory .. "\\configs\\", "")
                list[#list + 1] = name
            end

            config_holder.refresh_options(list)
        end 

        function library:get_config()
            local Config = {}
            
            for _, v in next, flags do
                if type(v) == "table" and v.key then
                    Config[_] = {active = v.active, mode = v.mode, key = tostring(v.key)}
                elseif type(v) == "table" and v["Transparency"] and v["Color"] then
                    Config[_] = {Transparency = v["Transparency"], Color = v["Color"]:ToHex()}
                else
                    Config[_] = v
                end
            end 
            
            return http_service:JSONEncode(Config)
        end

        function library:load_config(config_json) 
            local config = http_service:JSONDecode(config_json)
            
            for _, v in config do 
                local function_set = library.config_flags[_]
                
                if _ == "config_name_list" then 
                    continue 
                end

                if function_set then 
                    if type(v) == "table" and v["Transparency"] and v["Color"] then
                        function_set(hex(v["Color"]), v["Transparency"])
                    elseif type(v) == "table" and v["active"] then 
                        function_set(v)
                    else
                        function_set(v)
                    end
                end 
            end 
        end 
        
        function library:round(number, float) 
            local multiplier = 1 / (float or 1)

            return floor(number * multiplier + 0.5) / multiplier
        end 

        function library:connection(signal, callback)
            local connection = signal:Connect(callback)
            
            insert(library.connections, connection)

            return connection 
        end

        function library:close_current_element(cfg) 
			local path = library.current 

			if path and path ~= cfg then 
				path.set_visible(false)
				path.open = false 
			end
		end

        function library:create(instance, options)
            local ins = Instance.new(instance) 
            
            for prop, value in options do 
                ins[prop] = value
            end
            
            return ins 
        end

        function library:unload_menu() 
            if library[ "items" ] then 
                library[ "items" ]:Destroy()
            end

            if library[ "other" ] then 
                library[ "other" ]:Destroy()
            end 
            
            for index, connection in library.connections do 
                connection:Disconnect() 
                connection = nil 
            end
            
            library = nil 
        end 
    --
    
    -- Library element functions
        function library:window(properties)
            local cfg = { 
                -- Properties
                name = properties.name or properties.Name or "nebula";
                size = properties.size or properties.Size or dim2(0, 650, 0, 400);
                logo = properties.logo or properties.Logo or "rbxassetid://128155293790451";

                selected_tab;
                items = {};
                tweening;
            }
            
            library[ "items" ] = library:create( "ScreenGui" , {
                Parent = coregui;
                Name = "\0";
                Enabled = true;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
            });
            
            library[ "other" ] = library:create( "ScreenGui" , {
                Parent = coregui;
                Name = "\0";
                Enabled = false;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
            }); 

            local items = cfg.items; do
                items[ "window" ] = library:create( "Frame" , {
                    Parent = library.items;
                    Name = "\0";
                    Visible = false;
                    Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = cfg.size;
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                }); items[ "window" ].Position = dim2(0, items[ "window" ].AbsolutePosition.X, 0, items[ "window" ].AbsolutePosition.Y)          

                items[ "top_frame" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "window" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 45);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });
                
                items[ "logo" ] = library:create( "ImageLabel" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "top_frame" ];
                    Name = "\0";
                    Image = cfg.logo;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 16, 0, 7);
                    Size = dim2(0, 32, 0, 32);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "ui_title" ] = library:create( "TextLabel" , {
                    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                    TextColor3 = rgb(255, 255, 255);
                    TextStrokeColor3 = rgb(255, 255, 255);
                    Text = cfg.name;
                    Parent = items[ "top_frame" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    BorderColor3 = rgb(0, 0, 0);
                    TextSize = 35;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "inline" ] = library:create( "Frame" , {
                    Parent = items[ "window" ];
                    Name = "\0";
                    Position = dim2(0, 0, 0, 44);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 63, 1, -44);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });
                
                items[ "tab_button_holder" ] = library:create( "Frame" , {
                    Parent = items[ "inline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(14, 14, 14)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "tab_button_holder" ];
                    PaddingTop = dim(0, 37)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "tab_button_holder" ];
                    Padding = dim(0, 24);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                items[ "page_holder" ] = library:create( "Frame" , {
                    Parent = items[ "window" ];
                    Name = "\0";
                    Position = dim2(0, 63, 0, 45);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -63, 1, -45);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(12, 12, 12)
                });                
            end 

            do -- Other
                library:draggify(items[ "window" ])
                library:resizify(items[ "window" ])
            end 
            
            function cfg.toggle_menu(bool) 
                if cfg.tweening then 
                    return 
                end 

                cfg.tweening = true 

                if bool then 
                    items[ "window" ].Visible = true
                end

                local Children = items[ "window" ]:GetDescendants()
                table.insert(Children, items[ "window" ])

                local Tween;
                for _,obj in Children do
                    local Index = library:get_transparency(obj)

                    if not Index then 
                        continue 
                    end

                    if type(Index) == "table" then
                        for _,prop in Index do
                            Tween = library:fade(obj, prop, bool)
                        end
                    else
                        Tween = library:fade(obj, Index, bool)
                    end
                end

                library:connection(Tween.Completed, function()
                    cfg.tweening = false
                    items[ "window" ].Visible = bool
                end)
            end 
                
            return setmetatable(cfg, library)
        end 

        function library:Tab(properties)
            local cfg = {
                -- properties
                name = properties.name or properties.Name or "visuals"; 
                icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6034767608";
                
                items = {};
            } 

            local items = cfg.items; do                
                -- Tab buttons 
                    items[ "tab_button" ] = library:create( "TextButton" , {
                        Parent = self.items[ "tab_button_holder" ];
                        BackgroundTransparency = 1;
                        Text = "";
                        Size = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "image" ] = library:create( "ImageLabel" , {
                        ImageColor3 = rgb(128, 128, 128);
                        Active = true;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "tab_button" ];
                        Name = "\0";
                        Size = dim2(0, 32, 0, 32);
                        AnchorPoint = vec2(0.5, 0);
                        Image = cfg.icon;
                        BackgroundTransparency = 1;
                        Position = dim2(0.5, 0, 0, 0);
                        Selectable = true;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });                       
                -- 

                -- Page directory
                    items[ "tab" ] = library:create( "Frame" , {
                        Parent = library.items;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Visible = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        Parent = items[ "tab" ];
                        Padding = dim(0, 21);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        VerticalFlex = Enum.UIFlexAlignment.Fill
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingTop = dim(0, 24);
                        PaddingBottom = dim(0, 21);
                        Parent = items[ "tab" ];
                        PaddingRight = dim(0, 21);
                        PaddingLeft = dim(0, 21)
                    });     
                    
                    for _,column in {"left", "right"} do 
                        items[ column ] = library:create( "Frame" , {
                            Parent = items[ "tab" ];
                            BackgroundTransparency = 1;
                            Name = "\0";
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 100, 0, 100);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(8, 8, 8)
                        }); 
                    end                  
                -- 
            end 

            function cfg.open_tab() 
                local selected_tab = self.selected_tab
                
                if selected_tab then 
                   selected_tab[ 1 ].ImageColor3 = rgb(128, 128, 128)
                   selected_tab[ 2 ].Parent = library.items
                   selected_tab[ 2 ].Visible = false
                end
                
                items.image.ImageColor3 = rgb(255, 255, 255)
                items.tab.Parent = self.items[ "page_holder" ]
                items.tab.Visible = true

                self.selected_tab = {
                    items.image;
                    items.tab;
                }

                library:close_current_element(nil) 
            end

            items[ "tab_button" ].MouseButton1Down:Connect(function()
                cfg.open_tab()
            end)

            if not self.selected_tab then 
                cfg.open_tab(true) 
            end

            return setmetatable(cfg, library)
        end

        -- ============================================
        -- SUBTAB SUPPORT - Full implementation
        -- ============================================
        function library:SubTab(properties)
            local cfg = {
                -- properties
                name = properties.name or properties.Name or "subtab"; 
                icon = properties.icon or properties.Icon or "rbxassetid://6034767608";
                
                items = {};
                subpages = {};
                selected_subpage = nil;
            } 

            local items = cfg.items; do                
                -- SubTab button holder
                items["subtab_button_holder"] = library:create("Frame", {
                    Parent = self.items["tab"];
                    Name = "\\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 28);
                    Position = dim2(0, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(14, 14, 14)
                });
                
                library:create("UIListLayout", {
                    Parent = items["subtab_button_holder"];
                    Padding = dim(0, 4);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });
                
                library:create("UIPadding", {
                    Parent = items["subtab_button_holder"];
                    PaddingLeft = dim(0, 4);
                    PaddingTop = dim(0, 4)
                });
                
                -- SubTab page holder
                items["subtab_page_holder"] = library:create("Frame", {
                    Parent = self.items["tab"];
                    Name = "\\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 1, -32);
                    Position = dim2(0, 0, 0, 32);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(12, 12, 12)
                });
                
                -- Left and right columns for subtab
                for _, column in {"left", "right"} do
                    items[column] = library:create("Frame", {
                        Parent = items["subtab_page_holder"];
                        BackgroundTransparency = 1;
                        Name = "\\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 100, 0, 100);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(8, 8, 8)
                    });
                end
                
                library:create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                    Parent = items["subtab_page_holder"];
                    Padding = dim(0, 8);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                });
                
                library:create("UIPadding", {
                    PaddingTop = dim(0, 8);
                    PaddingBottom = dim(0, 8);
                    PaddingRight = dim(0, 8);
                    PaddingLeft = dim(0, 8);
                    Parent = items["subtab_page_holder"]
                });
            end
            
            -- Function to add a new subpage
            function cfg:AddSubPage(subpageProps)
                local subpageCfg = {
                    name = subpageProps.name or subpageProps.Name or "Page";
                    items = {};
                }
                
                -- Create subtab button
                subpageCfg.items["button"] = library:create("TextButton", {
                    Parent = items["subtab_button_holder"];
                    Text = "";
                    Name = "\\0";
                    BackgroundTransparency = 1;
                    Size = dim2(0, 80, 1, -8);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(30, 30, 30)
                });
                
                subpageCfg.items["button_text"] = library:create("TextLabel", {
                    FontFace = library.font;
                    TextColor3 = rgb(128, 128, 128);
                    Text = subpageCfg.name;
                    Parent = subpageCfg.items["button"];
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    TextSize = 10;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                -- Create subpage frame
                subpageCfg.items["page"] = library:create("Frame", {
                    Parent = items["subtab_page_holder"];
                    BackgroundTransparency = 1;
                    Name = "\\0";
                    Visible = false;
                    Size = dim2(1, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(14, 14, 14)
                });
                
                -- Left and right columns
                for _, column in {"left", "right"} do
                    subpageCfg.items[column] = library:create("Frame", {
                        Parent = subpageCfg.items["page"];
                        BackgroundTransparency = 1;
                        Name = "\\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 100, 0, 100);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(8, 8, 8)
                    });
                end
                
                library:create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                    Parent = subpageCfg.items["page"];
                    Padding = dim(0, 8);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                });
                
                library:create("UIPadding", {
                    PaddingTop = dim(0, 4);
                    PaddingBottom = dim(0, 4);
                    PaddingRight = dim(0, 8);
                    PaddingLeft = dim(0, 8);
                    Parent = subpageCfg.items["page"]
                });
                
                -- Section function for subpage
                function subpageCfg:Section(sectionProps)
                    local secCfg = {
                        name = sectionProps.name or sectionProps.Name or "section";
                        side = sectionProps.side or sectionProps.Side or "left";
                        items = {};
                    }
                    
                    local parentFrame = subpageCfg.items[secCfg.side] or subpageCfg.items["left"]
                    
                    secCfg.items["section_outline"] = library:create("Frame", {
                        Name = "\\0";
                        BackgroundTransparency = 1;
                        Parent = parentFrame;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(8, 8, 8)
                    });
                    
                    secCfg.items["elements"] = library:create("Frame", {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = secCfg.items["section_outline"];
                        Name = "\\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 8, 0, 8);
                        Size = dim2(1, -16, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create("UIListLayout", {
                        Parent = secCfg.items["elements"];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    -- Store reference
                    secCfg.items["elements_ref"] = secCfg.items["elements"]
                    
                    return setmetatable(secCfg, {
                        __index = function(t, k)
                            if k == "Toggle" then return function(self, opts) return library.Toggle({items = {elements = self.items["elements"]}}, opts) end end
                            if k == "Slider" then return function(self, opts) return library.Slider({items = {elements = self.items["elements"]}}, opts) end end
                            if k == "Dropdown" then return function(self, opts) return library.Dropdown({items = {elements = self.items["elements"]}}, opts) end end
                            if k == "Label" then return function(self, opts) return library.Label({items = {elements = self.items["elements"]}}, opts) end end
                            if k == "Button" then return function(self, opts) return library.Button({items = {elements = self.items["elements"]}}, opts) end end
                            if k == "Textbox" then return function(self, opts) return library.Textbox({items = {elements = self.items["elements"]}}, opts) end end
                            if k == "Keybind" then return function(self, opts) return library.Keybind({items = {elements = self.items["elements"]}}, opts) end end
                            if k == "Colorpicker" then return function(self, opts) return library.Colorpicker({items = {elements = self.items["elements"]}}, opts) end end
                            return nil
                        end
                    })
                end
                
                -- Button click handler
                subpageCfg.items["button"].MouseButton1Click:Connect(function()
                    cfg:SelectSubPage(subpageCfg.name)
                end)
                
                self.subpages[subpageCfg.name] = subpageCfg
                return subpageCfg
            end
            
            -- Function to select a subpage
            function cfg:SelectSubPage(name)
                local subpage = self.subpages[name]
                if not subpage then return end
                
                -- Hide all subpages
                for _, sp in pairs(self.subpages) do
                    sp.items["page"].Visible = false
                    sp.items["button_text"].TextColor3 = rgb(128, 128, 128)
                end
                
                -- Show selected subpage
                subpage.items["page"].Visible = true
                subpage.items["button_text"].TextColor3 = rgb(255, 255, 255)
                self.selected_subpage = name
            end
            
            -- Auto-select first subpage
            function cfg:AutoSelect()
                for name, _ in pairs(self.subpages) do
                    self:SelectSubPage(name)
                    break
                end
            end
            
            return setmetatable(cfg, library)
        end

        function library:Section(properties)
            local cfg = {
                name = properties.name or properties.Name or "section"; 
                side = properties.side or properties.Side or "left";
                default = properties.default or properties.Default or false;
                size = properties.size or properties.Size or 0.5; 
                icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6022668898";
                fading_toggle = properties.fading or properties.Fading or false;
                items = {};
            };
            
            local items = cfg.items; do 
                items[ "section_outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Parent = self.items[ cfg.side ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(8, 8, 8)
                });
                
                items[ "section_shadow" ] = library:create( "Frame" , {
                    Parent = items[ "section_outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BackgroundTransparency = 1;
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(5, 5, 5)
                });
                
                items[ "section_shadow_one" ] = library:create( "Frame" , {
                    Parent = items[ "section_shadow" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BackgroundTransparency = 1;
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });
                
                items[ "section_shadow_two" ] = library:create( "Frame" , {
                    Parent = items[ "section_shadow_one" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });
                
                items[ "section_shadow_three" ] = library:create( "Frame" , {
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Parent = items[ "section_shadow_two" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(14, 14, 14)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "section_shadow_three" ];
                    CornerRadius = dim(0, 0)
                });
                
                items[ "scrolling" ] = library:create( "ScrollingFrame" , {
                    ScrollBarImageColor3 = rgb(0, 0, 0);
                    Active = true;
                    AutomaticCanvasSize = Enum.AutomaticSize.Y;
                    ScrollBarThickness = 0;
                    Parent = items[ "section_shadow_three" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 1, 0);
                    BackgroundColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    CanvasSize = dim2(0, 0, 0, 0)
                });
                
                items[ "elements" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "scrolling" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 12, 0, 12);
                    Size = dim2(1, -24, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "elements" ];
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "section_shadow_two" ];
                    CornerRadius = dim(0, 0)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "section_shadow_one" ];
                    CornerRadius = dim(0, 0)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "section_shadow" ];
                    CornerRadius = dim(0, 0)
                });
                
                items.text = library:create( "TextLabel" , {
                    FontFace = library.font;
                    TextColor3 = rgb(178, 178, 178);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "section_outline" ];
                    BackgroundTransparency = 1;
                    Position = dim2(0, 8, 0, -15);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 10;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items.line = library:create( "Frame" , {
                    Parent = items.text;
                    Position = dim2(0, 0, 1, 2);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });                

                library:create( "UIStroke" , {
                    Parent = items.text;
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "section_outline" ];
                    CornerRadius = dim(0, 0)
                });                
            end;

            items[ "section_outline" ].MouseEnter:Connect(function()
                for _,instance in items[ "section_outline" ]:GetDescendants() do 
                    if instance:IsA("UICorner") then 
                        library:tween(instance, {CornerRadius = dim(0, 8)})
                    end 
                end 

                for _,section in {"section_shadow_three", "section_shadow_two", "section_shadow_one", "section_shadow"} do 
                    library:tween(items[ section ], {BackgroundTransparency = 0})
                end 
                
                library:tween(items.line, {Size = dim2(1, 0, 0, 1)})
                library:tween(items.text, {TextColor3 = rgb(255, 255, 255)})
            end)

            items[ "section_outline" ].MouseLeave:Connect(function()
                for _,instance in items[ "section_outline" ]:GetDescendants() do 
                    if instance:IsA("UICorner") then 
                        library:tween(instance, {CornerRadius = dim(0, 0)})
                    end 
                end 

                for _,section in {"section_shadow_three", "section_shadow_two", "section_shadow_one", "section_shadow"} do 
                    library:tween(items[ section ], {BackgroundTransparency = 1})
                end

                library:tween(items.line, {Size = dim2(0, 0, 0, 1)})
                library:tween(items.text, {TextColor3 = rgb(178, 178, 178)})
            end)

            return setmetatable(cfg, library)
        end  

        function library:Toggle(options) 
            local cfg = {
                enabled = options.enabled or options.Enabled or nil,
                name = options.name or options.Name or "Toggle",
                flag = options.flag or options.Flag or options.name or options.Name or "please set me a flag 🥺",
                
                default = options.default or options.Default or false,
                callback = options.callback or options.Callback or function() end,

                items = {};
            }

            local items = cfg.items; do 
                items[ "object" ] = library:create( "TextButton" , {
                    Parent = self.items[ "elements" ];
                    Text = "";
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 12);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    -- AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "toggle_outline" ] = library:create( "Frame" , {
                    Parent = items[ "object" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 12, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });
                
                items[ "toggle_shading" ] = library:create( "Frame" , {
                    Parent = items[ "toggle_outline" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(92, 92, 92)
                });
                
                items[ "toggle_inline" ] = library:create( "Frame" , {
                    Parent = items[ "toggle_shading" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(54, 54, 54)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "object" ];
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });
                
                items[ "text" ] = library:create( "TextLabel" , {
                    FontFace = library.font;
                    TextColor3 = rgb(178, 178, 178);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "object" ];
                    BackgroundTransparency = 1;
                    Position = dim2(0, 12, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 10;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIStroke" , {
                    Parent = items[ "text" ]
                });
                
                library:create( "UIPadding" , {
                    PaddingLeft = dim(0, 1);
                    Parent = items[ "text" ]
                });
            end;
            
            function cfg.set(bool)
                library:tween(items[ "text" ], {TextColor3 = bool and rgb(255, 255, 255) or rgb(178, 178, 178)})
                library:tween(items[ "toggle_outline" ], {BackgroundTransparency = bool and 0 or 1})
                library:tween(items[ "toggle_shading" ], {BackgroundTransparency = bool and 0 or 1})
                library:tween(items[ "toggle_inline" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(74, 74, 74)})

                cfg.callback(bool)
                
                flags[cfg.flag] = bool
            end 
            
            items[ "object" ].MouseButton1Click:Connect(function()
                cfg.enabled = not cfg.enabled 
                cfg.set(cfg.enabled)
            end)
            
            cfg.set(cfg.default)

            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end 
        
        function library:Slider(options) 
            local cfg = {
                -- Options
                name = options.name or options.Name or nil;
                suffix = options.suffix or options.Suffix or "";
                flag = options.flag or options.Flag or options.name or options.Name or "please set me a flag 🥺";
                callback = options.callback or options.Callback or function() end; 
                show_value = options.ShowValue or options.show_value or true; 

                -- value settings
                min = options.min or options.minimum or options.Min or options.Minimum or 0;
                max = options.max or options.maximum or options.Max or options.Maximum or 100;
                intervals = options.interval or options.decimal or options.Interval or options.Decimal or 1;
                default = options.default or options.Default or 10;
                value = options.default or options.default or 10; 

                -- ignore
                dragging = false;
                items = {}
            } 

            local items = cfg.items; do
                items[ "object" ] = library:create( "Frame" , {
                    Parent = self.items.object or self.items.elements;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(0, 0, 0, 12);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "object" ];
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });
                
                items[ "slider_parent" ] = library:create( "TextButton" , {
                    Parent = items[ "object" ];
                    BackgroundTransparency = 1;
                    Text = "";
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 100, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "slider_holder" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 0.5);
                    Parent = items[ "slider_parent" ];
                    Name = "\0";
                    Position = dim2(0, 0, 0.5, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 5);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });
                
                items[ "gradient_holder" ] = library:create( "Frame" , {
                    Parent = items[ "slider_holder" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIGradient" , {
                    Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(93, 93, 93))};
                    Parent = items[ "gradient_holder" ]
                });
                
                items[ "slider" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 0.5);
                    Parent = items[ "gradient_holder" ];
                    Name = "\0";
                    Position = dim2(0, 0, 0.5, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 4, 0, 9);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });
                
                items[ "inline" ] = library:create( "Frame" , {
                    Parent = items[ "slider" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                if cfg.name then
                    items[ "name" ] = setmetatable(cfg, library):Label({padding_top = 1})
                end

                if cfg.show_value then 
                    items[ "value" ] = setmetatable(cfg, library):Label({padding_top = 1})
                end       
            end 

            function cfg.set(value)
                cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)
                
                items[ "slider" ].Position = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), 0, 0.5, 0)

                if items[ "value" ] then
                    items[ "value" ].set(tostring(cfg.value) .. cfg.suffix)
                end

                flags[cfg.flag] = cfg.value
                cfg.callback(flags[cfg.flag])
            end

            items[ "slider_parent" ].MouseButton1Down:Connect(function()
                cfg.dragging = true 
            end)

            library:connection(uis.InputChanged, function(input)
                if cfg.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then 
                    local size_x = (input.Position.X - items[ "gradient_holder" ].AbsolutePosition.X) / items[ "gradient_holder" ].AbsoluteSize.X
                    local value = ((cfg.max - cfg.min) * size_x) + cfg.min
                    cfg.set(value)
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    cfg.dragging = false
                end 
            end)
            
            cfg.set(cfg.default)
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end 

        function library:Dropdown(options) 
            local cfg = {
                obj_type = "dropdown";

                -- Options
                name = options.name or options.Name or nil;
                flag = options.flag or options.Flag or options.name or options.Name or "please set me a flag 🥺";
                options = options.items or options.Items or {"1", "2", "3"};
                callback = options.callback or options.Callback or function() end;
                multi = options.multi or options.Multi or false;

                -- Ignore these 
                open = false;
                option_instances = {};
                multi_items = {};
                items = {};
            }   

            cfg.default = options.default or (cfg.multi and {cfg.items[1]}) or cfg.items[1] or "None"
            flags[cfg.flag] = cfg.default
            
            local items = cfg.items; do 
                -- Element
                    items[ "object" ] = library:create( "Frame" , {
                        Parent = self.items.object or self.items.elements;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(0, 0, 0, 12);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    if self.items.object then 
                        library:create( "UIPadding" , {
                            Parent = items[ "object" ];
                            PaddingTop = dim(0, -2)
                        });                        
                    end 
                    
                    items[ "dropdown_outline" ] = library:create( "TextButton" , {
                        Parent = items[ "object" ];
                        Text = "";
                        AutoButtonColor = false;
                        Name = "\0";
                        Size = dim2(0, 0, 0, 16);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "dropdown_shading" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown_outline" ];
                        Size = dim2(0, -2, 1, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIGradient" , {
                        Rotation = 90;
                        Parent = items[ "dropdown_shading" ];
                        Color = rgbseq{rgbkey(0, rgb(33, 33, 33)), rgbkey(1, rgb(8, 8, 8))}
                    });
                    
                    items.inner_text = library:create( "TextLabel" , {
                        FontFace = library.font;
                        TextColor3 = rgb(178, 178, 178);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "Combat";
                        Parent = items[ "dropdown_shading" ];
                        AnchorPoint = vec2(0, 0.5);
                        Size = dim2(1, 0, 1, 0);
                        BackgroundTransparency = 1;
                        Position = dim2(0, 0, 0.5, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 10;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIStroke" , {
                        Parent = items[ "TextLabel" ]
                    });
                    
                    library:create( "UIPadding" , {
                        Parent = items[ "TextLabel" ]
                    });
                    
                    library:create( "UIPadding" , {
                        Parent = items[ "dropdown_shading" ];
                        PaddingRight = dim(0, 40);
                        PaddingLeft = dim(0, 40)
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingRight = dim(0, 1);
                        Parent = items[ "dropdown_outline" ]
                    });
                    
                    items[ "arrow" ] = library:create( "ImageLabel" , {
                        ImageColor3 = rgb(178, 178, 178);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "dropdown_outline" ];
                        Name = "\0";
                        AnchorPoint = vec2(1, 0.5);
                        Image = "rbxassetid://76667213487638";
                        BackgroundTransparency = 1;
                        Position = dim2(1, -4, 0.5, 0);
                        Size = dim2(0, 7, 0, 4);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "object" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        FillDirection = Enum.FillDirection.Horizontal
                    });
                -- 

                -- Element Holder
                    items[ "dropdown_holder" ] = library:create( "Frame" , {
                        Parent = library.items;
                        Size = dim2(0, 114, 0, 0);
                        Visible = false;
                        Name = "\0";
                        Position = dim2(0.05823293328285217, 0, 0.19430045783519745, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "dropdown_shading" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown_holder" ];
                        Size = dim2(1, -2, 0, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIGradient" , {
                        Rotation = 90;
                        Parent = items[ "dropdown_shading" ];
                        Color = rgbseq{rgbkey(0, rgb(33, 33, 33)), rgbkey(1, rgb(8, 8, 8))}
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "dropdown_shading" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 5);
                        PaddingTop = dim(0, 5);
                        Parent = items[ "dropdown_shading" ]
                    });            
                -- 
            end 

            function cfg.render_option(text)
                local button = library:create( "TextButton" , {
                    FontFace = library.font;
                    TextColor3 = rgb(178, 178, 178);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = text;
                    Parent = items[ "dropdown_shading" ];
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Center;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 10;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIStroke" , {
                    Parent = button
                });
                
                library:create( "UIPadding" , {
                    Parent = button
                });

                return button
            end
            
            function cfg.set_visible(bool)
                local a = bool and cfg.y_size or 0
                items[ "dropdown_holder" ].Visible = bool 
                items[ "arrow" ].Rotation = bool and 180 or 0

                items[ "dropdown_holder" ].Size = dim2(0, items.dropdown_outline.AbsoluteSize.X, 0, 0)
                items[ "dropdown_holder" ].Position = dim2(0, items.dropdown_outline.AbsolutePosition.X, 0, items.dropdown_outline.AbsolutePosition.Y + 75)
                
                library.current = cfg
            end
            
            function cfg.set(value)
                local selected = {}
                local isTable = type(value) == "table"

                for _, option in cfg.option_instances do 
                    if option.Text == value or (isTable and find(value, option.Text)) then 
                        insert(selected, option.Text)
                        cfg.multi_items = selected
                        option.TextColor3 = rgb(255, 255, 255)
                    else
                        option.TextColor3 = rgb(174, 174, 174)
                    end
                end

                items.inner_text.Text = if isTable then concat(selected, ", ") else selected[1] or ""
                flags[cfg.flag] = if isTable then selected else selected[1]
                
                cfg.callback(flags[cfg.flag]) 
            end
            
            function cfg.refresh_options(list) 
                for _, option in cfg.option_instances do 
                    option:Destroy() 
                end
                
                cfg.option_instances = {} 

                for _, option in list do 
                    local button = cfg.render_option(option)
                    insert(cfg.option_instances, button)
                    
                    button.MouseButton1Down:Connect(function()
                        if cfg.multi then 
                            local selected_index = find(cfg.multi_items, button.Text)
                            
                            if selected_index then 
                                remove(cfg.multi_items, selected_index)
                            else
                                insert(cfg.multi_items, button.Text)
                            end
                            
                            cfg.set(cfg.multi_items) 				
                        else 
                            cfg.set_visible(false)
                            cfg.open = false 
                            
                            cfg.set(button.Text)
                        end
                    end)
                end
            end

            items.dropdown_outline.MouseButton1Click:Connect(function()
                cfg.open = not cfg.open
                cfg.set_visible(cfg.open)
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not (library:mouse_in_frame(items.dropdown_holder) or library:mouse_in_frame(items.object)) then 
                        cfg.open = false
                        cfg.set_visible(false)
                    end
                end
            end)
            
            flags[cfg.flag] = {} 
            config_flags[cfg.flag] = cfg.set
            
            cfg.refresh_options(cfg.options)
            cfg.set(cfg.default)

            local set = setmetatable(cfg, library)

            if cfg.name then 
                set:Label({name = cfg.name, padding_bottom = 2})
            end 

            return set
        end

        function library:Label(options)
            local cfg = {
                name = options.Name or options.name or "Label",

                -- ignore
                padding_top = options.PaddingTop or options.padding_top or 0; -- used because roblox cant make proper layouts
                padding_top = options.PaddingBottom or options.padding_bottom or 0;

                items = {};
            }

            local items = cfg.items; do 
                items[ "object" ] = library:create( "TextButton" , {
                    Parent = self.items.object or self.items.elements;
                    Text = "";
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 12);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                items.text = library:create( "TextLabel" , {
                    FontFace = library.font;
                    TextColor3 = rgb(178, 178, 178);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    RichText = true;
                    Parent = items.object;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 12, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 10;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "object" ];
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });

                library:create( "UIStroke" , {
                    Parent = items.text
                });

                library:create( "UIPadding" , {
                    PaddingLeft = dim(0, 1);
                    PaddingTop = dim(0, cfg.padding_top);
                    PaddingBottom = dim(0, cfg.padding_bottom);
                    Parent = items.text
                });
            end 

            function cfg.set(text)
                items.text.Text = text
            end

            return setmetatable(cfg, library)
        end 
        
        function library:Colorpicker(options) 
            local cfg = {
                -- options
                name = options.name or options.Name or "", 
                flag = options.flag or options.Flag or options.name or options.Name or "please set me a flag 🥺",
                color = options.color or options.Color or color(1, 1, 1), -- Default to white color if not provided
                alpha = (options.alpha and 1 - options.alpha) or (options.Alpha and 1 - options.Alpha) or 0,
                callback = options.callback or options.Callback or function() end,

                -- ignore
                open = false, 
                items = {};
            }

            local dragging_sat = false 
            local dragging_hue = false 
            local dragging_alpha = false 

            local h, s, v = cfg.color:ToHSV() 
            local a = cfg.alpha 

            flags[cfg.flag] = {Color = cfg.color, Transparency = cfg.alpha}

            local items = cfg.items; do 
                -- Component
                    items[ "gear_holder" ] = library:create( "TextButton" , {
                        Parent = self.items.object;
                        AutoButtonColor = false;
                        Text = "";
                        BackgroundTransparency = 1;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "gear" ] = library:create( "ImageLabel" , {
                        ImageColor3 = rgb(178, 178, 178);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "gear_holder" ];
                        Image = "rbxassetid://99473719385675";
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIPadding" , {
                        Parent = items[ "gear_holder" ];
                        PaddingTop = dim(0, -1)
                    });                
                --
                
                -- Colorpicker
                    items[ "colorpicker_outline" ] = library:create( "Frame" , {
                        Parent = library.items;
                        Visible = false;
                        Size = dim2(0, 161, 0, 180);
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 100;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "_" ] = library:create( "UICorner" , {
                        Parent = items[ "colorpicker_outline" ];
                        Name = "\0";
                        CornerRadius = dim(0, 0)
                    });
                    
                    items[ "colorpicker_inline" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_outline" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(32, 32, 32)
                    });
                    
                    items[ "_" ] = library:create( "UICorner" , {
                        Parent = items[ "colorpicker_inline" ];
                        Name = "\0";
                        CornerRadius = dim(0, 0)
                    });
                    
                    items[ "colorpicker_background" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_inline" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(8, 8, 8)
                    });
                    
                    items[ "_" ] = library:create( "UICorner" , {
                        Parent = items[ "colorpicker_background" ];
                        Name = "\0";
                        CornerRadius = dim(0, 0)
                    });
                    
                    items[ "_" ] = library:create( "UIPadding" , {
                        PaddingTop = dim(0, 18);
                        Name = "\0";
                        PaddingBottom = dim(0, 3);
                        Parent = items[ "colorpicker_background" ];
                        PaddingRight = dim(0, 3);
                        PaddingLeft = dim(0, 3)
                    });
                    
                    items[ "saturation_outline" ] = library:create( "TextButton" , {
                        Name = "\0";
                        AutoButtonColor = false;
                        Text = "";
                        Parent = items[ "colorpicker_background" ];
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -12, 1, -12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "color_saturation" ] = library:create( "Frame" , {
                        Parent = items[ "saturation_outline" ];
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 39, 39)
                    });
                    
                    items[ "sat" ] = library:create( "Frame" , {
                        Parent = items[ "color_saturation" ];
                        Name = "\0";
                        Size = dim2(1, 0, 1, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIGradient" , {
                        Rotation = 270;
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)};
                        Parent = items[ "sat" ];
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0))}
                    });
                    
                    items[ "satval_picker" ] = library:create( "Frame" , {
                        Parent = items[ "color_saturation" ];
                        Size = dim2(0, 3, 0, 3);
                        Name = "\0";
                        Position = dim2(0, 1, 0.5, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 4;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "_" ] = library:create( "Frame" , {
                        Parent = items[ "satval_picker" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "val" ] = library:create( "Frame" , {
                        Name = "\0";
                        Parent = items[ "color_saturation" ];
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIGradient" , {
                        Parent = items[ "val" ];
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)}
                    });
                    
                    items[ "hue_slider" ] = library:create( "TextButton" , {
                        Parent = items[ "colorpicker_background" ];
                        Name = "\0";
                        AutoButtonColor = false;
                        Text = "";
                        Position = dim2(1, -10, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 10, 1, -12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "hue_components" ] = library:create( "Frame" , {
                        Parent = items[ "hue_slider" ];
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "_" ] = library:create( "UIGradient" , {
                        Rotation = 270;
                        Parent = items[ "hue_components" ];
                        Name = "\0";
                        Color = rgbseq{rgbkey(0, rgb(255, 0, 0)), rgbkey(0.17, rgb(255, 255, 0)), rgbkey(0.33, rgb(0, 255, 0)), rgbkey(0.5, rgb(0, 255, 255)), rgbkey(0.67, rgb(0, 0, 255)), rgbkey(0.83, rgb(255, 0, 255)), rgbkey(1, rgb(255, 0, 0))}
                    });
                    
                    items[ "hue_picker" ] = library:create( "Frame" , {
                        Parent = items[ "hue_components" ];
                        Size = dim2(1, 2, 0, 3);
                        Name = "\0";
                        Position = dim2(0, -1, 0, -1);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 4;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "_" ] = library:create( "Frame" , {
                        Parent = items[ "hue_picker" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "alpha_slider" ] = library:create( "TextButton" , {
                        Parent = items[ "colorpicker_background" ];
                        Name = "\0";
                        AutoButtonColor = false;
                        Text = "";
                        Position = dim2(0, 0, 1, -10);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -12, 0, 10);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "alpha_components" ] = library:create( "Frame" , {
                        Parent = items[ "alpha_slider" ];
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "_" ] = library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(255, 255, 255))};
                        Name = "\0";
                        Parent = items[ "alpha_components" ]
                    });
                    
                    items[ "alpha_picker" ] = library:create( "Frame" , {
                        Parent = items[ "alpha_components" ];
                        Size = dim2(0, 3, 1, 2);
                        Name = "\0";
                        Position = dim2(0, -1, 0, -1);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 4;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "_" ] = library:create( "Frame" , {
                        Parent = items[ "alpha_picker" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "visualize_outline" ] = library:create( "Frame" , {
                        AnchorPoint = vec2(1, 1);
                        Parent = items[ "colorpicker_background" ];
                        Name = "\0";
                        Position = dim2(1, 0, 1, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 10, 0, 10);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "visualizer" ] = library:create( "Frame" , {
                        Parent = items[ "visualize_outline" ];
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(123, 83, 255)
                    });
                    
                    items[ "alpha_visualizer" ] = library:create( "ImageLabel" , {
                        ScaleType = Enum.ScaleType.Tile;
                        ImageTransparency = 0.41999998688697815;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "visualizer" ];
                        Name = "\0";
                        Image = "rbxassetid://18274452449";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 1, 0);
                        
                        TileSize = dim2(0, 2, 0, 2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "gear" ] = library:create( "ImageButton" , {
                        ImageColor3 = rgb(178, 178, 178);
                        AutoButtonColor = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "colorpicker_inline" ];
                        Name = "\0";
                        Image = "rbxassetid://99473719385675";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 4, 0, 3);
                        
                        Size = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "TextLabel" , {
                        FontFace = library.font;
                        TextColor3 = rgb(178, 178, 178);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = items[ "colorpicker_outline" ];
                        BackgroundTransparency = 1;
                        Position = dim2(0, 20, 0, 5);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 10;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIStroke" , {
                        Parent = items[ "TextLabel" ]
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingLeft = dim(0, 1);
                        Parent = items[ "TextLabel" ]
                    });                
                --  
            end;

            function cfg.set_visible(bool) 
                items.colorpicker_outline.Visible = bool
                items.colorpicker_outline.Position = dim2(0, items.gear_holder.AbsolutePosition.X - 5, 0, items.gear_holder.AbsolutePosition.Y + items.gear_holder.AbsoluteSize.Y + 60 - 19)

                library.current = cfg
            end

            function cfg.set(color, alpha)
                if color then
                    h, s, v = color:ToHSV()
                end
                
                if alpha then 
                    a = alpha
                end 
                
                local Color = Color3.fromHSV(h, s, v)
                
                items.hue_picker.Position = dim2(0, -1, 1 - h, -1)
                items.alpha_picker.Position = dim2(1 - a, -1, 0, -1)
                items.satval_picker.Position = dim2(s, -1, 1 - v, -1)

                items.color_saturation.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                items.color_saturation.BackgroundColor3 = Color3.fromHSV(h, 1, 1)

                items.alpha_visualizer.ImageTransparency = 1 - a 
                items.visualizer.BackgroundColor3 = Color

                flags[cfg.flag] = {
                    Color = Color;
                    Transparency = a 
                }
                
                cfg.callback(Color, a)
            end

            function cfg.update_color() 
                local mouse = uis:GetMouseLocation() 
                local offset = vec2(mouse.X, mouse.Y - gui_offset) 

                if dragging_sat then	
                    s = math.clamp((offset - items.sat.AbsolutePosition).X / items.sat.AbsoluteSize.X, 0, 1)
                    v = 1 - math.clamp((offset - items.val.AbsolutePosition).Y / items.val.AbsoluteSize.Y, 0, 1)
                elseif dragging_hue then
                    h = 1 - math.clamp((offset - items.hue_slider.AbsolutePosition).Y / items.hue_slider.AbsoluteSize.Y, 0, 1)
                elseif dragging_alpha then
                    a = 1 - math.clamp((offset - items.alpha_slider.AbsolutePosition).X / items.alpha_slider.AbsoluteSize.X, 0, 1)
                end

                cfg.set(nil, nil)
            end

            items.gear_holder.MouseButton1Click:Connect(function()
                cfg.set_visible(true)            
            end)

            items.gear.MouseButton1Click:Connect(function()
                cfg.set_visible(false)            
            end)

            uis.InputChanged:Connect(function(input)
                if (dragging_sat or dragging_hue or dragging_alpha) and input.UserInputType == Enum.UserInputType.MouseMovement then
                    cfg.update_color() 
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging_sat = false
                    dragging_hue = false
                    dragging_alpha = false  

                    if not (library:mouse_in_frame(items.gear_holder) or library:mouse_in_frame(items.colorpicker_outline)) then 
                        cfg.open = false
                        cfg.set_visible(false)
                    end
                end
            end)

            items.alpha_slider.MouseButton1Down:Connect(function()
                dragging_alpha = true 
            end)
            
            items.hue_slider.MouseButton1Down:Connect(function()
                dragging_hue = true 
            end)
            
            items.saturation_outline.MouseButton1Down:Connect(function()
                print("hiu")
                dragging_sat = true  
            end)

            cfg.set(cfg.color, cfg.alpha)
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end 

        function library:Textbox(options) 
            local cfg = {
                name = options.name or options.Name or "TextBox",
                placeholder = options.placeholder or options.PlaceHolder or "type here...",
                default = options.default or options.Default or "",
                flag = options.flag or options.name or "please set me a flag 🥺",
                callback = options.callback or options.Callback or function() end,
                visible = options.visible or true,
                items = {};
            }

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do 
                items[ "object" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = self.items[ "elements" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 16);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "textbox_outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "object" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 20);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });
                
                items[ "textbox_shading" ] = library:create( "Frame" , {
                    Parent = items[ "textbox_outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "textbox" ] = library:create( "TextBox" , {
                    FontFace = library.font;
                    Active = false;
                    Selectable = false;
                    PlaceholderText = cfg.placeholder;
                    TextSize = 10;
                    Size = dim2(1, 0, 1, 0);
                    TextColor3 = rgb(180, 180, 180);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = items[ "textbox_shading" ];
                    Name = "\0";
                    CursorPosition = -1;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    TextWrapped = true;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    PaddingLeft = dim(0, 7);
                    Parent = items[ "textbox" ]
                });
                
                library:create( "UIStroke" , {
                    Parent = items[ "textbox" ]
                });
                
                library:create( "UIGradient" , {
                    Rotation = 90;
                    Parent = items[ "textbox_shading" ];
                    Color = rgbseq{rgbkey(0, rgb(33, 33, 33)), rgbkey(1, rgb(8, 8, 8))}
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "object" ];
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });                
            end 
            
            function cfg.set(text) 
                if type(text) == "boolean" then 
                    return 
                end 

                flags[cfg.flag] = text

                items[ "textbox" ].Text = text

                cfg.callback(text)
            end 
            
            items[ "textbox" ]:GetPropertyChangedSignal("Text"):Connect(function()
                cfg.set(items[ "textbox" ].Text) 
            end)

            items[ "textbox" ].Focused:Connect(function()
                library:tween(items[ "textbox" ], {TextColor3 = rgb(245, 245, 245)})
            end)

            items[ "textbox" ].FocusLost:Connect(function()
                library:tween(items[ "textbox" ], {TextColor3 = rgb(72, 72, 72)})
            end)
                
            if cfg.default then 
                cfg.set(cfg.default) 
            end

            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:Keybind(options) 
            local cfg = {
                -- options
                flag = options.flag or options.Flag or options.name or options.Name or "please set me a flag 🥺",
                callback = options.callback or options.Callback or function() end,
                name = options.name or options.Name or nil, 
                key = options.key or options.Key or nil, 
                mode = options.mode or options.Mode or "Toggle",
                active = options.default or options.Default or false, 

                -- ignore
                open = false,
                binding = nil, 
                hold_instances = {},
                items = {};
            }

            flags[cfg.flag] = {
                mode = cfg.mode,
                key = cfg.key, 
                active = cfg.active
            }

            if not library.Keybinds then
                library.Keybinds = {}
            end
            table.insert(library.Keybinds, cfg)

            local items = cfg.items; do 
                -- Component
                    items.text_label = library:create( "TextButton" , {
                        FontFace = library.font;
                        AutoButtonColor = false;
                        TextColor3 = rgb(178, 178, 178);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "J";
                        Parent = self.items.object;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 10;
                        BackgroundColor3 = rgb(38, 38, 38)
                    });

                    library:create( "UIStroke" , {
                        Parent = items.text_label
                    });

                    library:create( "UIPadding" , {
                        Parent = items.text_label;
                        PaddingRight = dim(0, 4);
                        PaddingLeft = dim(0, 4)
                    });

                    if cfg.name then
                        self:Label({Name = cfg.name})
                    end 
                -- 
                
                -- Mode Holder
                    items[ "modes" ] = library:create( "Frame" , {
                        Parent = library.items;
                        Visible = false;
                        Size = dim2(0, 114, 0, 0);
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "mode_shading" ] = library:create( "Frame" , {
                        Parent = items[ "modes" ];
                        Size = dim2(0, -2, 0, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIGradient" , {
                        Rotation = 90;
                        Parent = items[ "mode_shading" ];
                        Color = rgbseq{rgbkey(0, rgb(33, 33, 33)), rgbkey(1, rgb(8, 8, 8))}
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "mode_shading" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 5);
                        PaddingTop = dim(0, 5);
                        Parent = items[ "mode_shading" ]
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingRight = dim(0, 1);
                        Parent = items[ "modes" ]
                    });
                    
                
                    local options = {"Hold", "Toggle", "Always"}
                    
                    for _,option in options do
                        local name = library:create( "TextButton" , {
                            FontFace = library.font;
                            AutoButtonColor = false;
                            TextColor3 = rgb(178, 178, 178);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = option;
                            Parent = items[ "mode_shading" ];
                            BackgroundTransparency = 1;
                            Size = dim2(1, 0, 0, 0);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            TextSize = 10;
                            BackgroundColor3 = rgb(255, 255, 255)
                        }); cfg.hold_instances[option] = name
                        
                        library:create( "UIStroke" , {
                            Parent = items[ "TextLabel" ]
                        });
                        
                        library:create( "UIPadding" , {
                            PaddingLeft = dim(0, 5);
                            Parent = items[ "TextLabel" ]
                        });
                                                
                        -- cfg.y_size += name.AbsoluteSize.Y

                        library:create( "UIPadding" , {
                            Parent = name;
                            PaddingTop = dim(0, 1);
                            PaddingRight = dim(0, 5);
                            PaddingLeft = dim(0, 5)
                        });

                        name.MouseButton1Click:Connect(function()
                            cfg.set(option)
                            cfg.set_visible(false)
                            cfg.open = false
                        end)
                    end
                -- 
            end 
            
            function cfg.modify_mode_color(path) -- ts so frikin tuff 💀
                for _,v in cfg.hold_instances do 
                    v.TextColor3 = rgb(178, 178, 178)
                end 

                cfg.hold_instances[path].TextColor3 = rgb(255, 255, 255)
            end

            function cfg.set_mode(mode) 
                cfg.mode = mode 

                if mode == "Always" then
                    cfg.set(true)
                elseif mode == "Hold" then
                    cfg.set(false)
                end

                flags[cfg.flag]["mode"] = mode
                cfg.modify_mode_color(mode)
            end 

            function cfg.set(input)
                if type(input) == "boolean" then 
                    cfg.active = input

                    if cfg.mode == "Always" then 
                        cfg.active = true
                    end
                elseif tostring(input):find("Enum") then 
                    input = input.Name == "Escape" and "NONE" or input
                    
                    cfg.key = input or "NONE"	
                elseif find({"Toggle", "Hold", "Always"}, input) then 
                    if input == "Always" then 
                        cfg.active = true 
                    end 

                    cfg.mode = input
                    cfg.set_mode(cfg.mode) 
                elseif type(input) == "table" then 
                    input.key = type(input.key) == "string" and input.key ~= "NONE" and library:convert_enum(input.key) or input.key
                    input.key = input.key == Enum.KeyCode.Escape and "NONE" or input.key

                    cfg.key = input.key or "NONE"
                    cfg.mode = input.mode or "Toggle"

                    if input.active then
                        cfg.active = input.active
                    end

                    cfg.set_mode(cfg.mode) 
                end 

                cfg.callback(cfg.active)

                local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
                local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))
                
                items.text_label.Text = __text

                flags[cfg.flag] = {
                    mode = cfg.mode,
                    key = cfg.key, 
                    active = cfg.active
                }

                if library.KeybindListObj then
                    library.KeybindListObj:Update()
                end
            end

            function cfg.set_visible(bool)
                -- local size = bool and cfg.y_size or 0
                -- library:tween(items.object, {Size = dim_offset(items.text_label.AbsoluteSize.X, size)})
                items.modes.Visible = bool 
                items.modes.Position = dim_offset(items.text_label.AbsolutePosition.X + items.text_label.AbsoluteSize.X + 5, items.text_label.AbsolutePosition.Y + 58)

                library.current = cfg
            end
            
            items.text_label.MouseButton1Down:Connect(function()
                task.wait()
                items.text_label.Text = "..."	

                cfg.binding = library:connection(uis.InputBegan, function(keycode, game_event)  
                    cfg.set(keycode.KeyCode ~= Enum.KeyCode.Unknown and keycode.KeyCode or keycode.UserInputType)
                    
                    cfg.binding:Disconnect() 
                    cfg.binding = nil
                end)
            end)

            items.text_label.MouseButton2Down:Connect(function()
                cfg.open = not cfg.open 

                cfg.set_visible(cfg.open)
            end)

            library:connection(uis.InputBegan, function(input, game_event) 
                if not game_event then
                    local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

                    if selected_key == cfg.key then 
                        if cfg.mode == "Toggle" then 
                            cfg.active = not cfg.active
                            cfg.set(cfg.active)
                        elseif cfg.mode == "Hold" then 
                            cfg.set(true)
                        end
                    end
                end
            end)    

            library:connection(uis.InputEnded, function(input, game_event) 
                if game_event then 
                    return 
                end 

                local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
    
                if selected_key == cfg.key then
                    if cfg.mode == "Hold" then 
                        cfg.set(false)
                    end
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not (library:mouse_in_frame(items[ "modes" ]) or library:mouse_in_frame(items.text_label)) then 
                        cfg.open = false
                        cfg.set_visible(false)
                    end
                end
            end)
            
            cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})           
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:Button(options) 
            local cfg = {
                -- options
                name = options.name or options.Name or "TextBox",
                callback = options.callback or options.Callback or function() end,

                -- ignore
                items = {};
            }
            
            local items = cfg.items; do 
                items[ "button" ] = library:create( "TextButton" , {
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    AutoButtonColor = false;
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 16);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "button_outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "button" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 20);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });
                
                items[ "button_shading" ] = library:create( "Frame" , {
                    Parent = items[ "button_outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIGradient" , {
                    Rotation = 90;
                    Parent = items[ "button_shading" ];
                    Color = rgbseq{rgbkey(0, rgb(33, 33, 33)), rgbkey(1, rgb(8, 8, 8))}
                });
                
                items[ "button_text" ] = library:create( "TextLabel" , {
                    FontFace = library.font;
                    TextColor3 = rgb(178, 178, 178);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "button_shading" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 10;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIStroke" , {
                    Parent = items[ "button_text" ]
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "button" ];
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });                             
            end 

            items[ "button" ].MouseButton1Click:Connect(function()
                cfg.callback()

                items[ "button_text" ].TextColor3 = rgb(255, 255, 255) 
                library:tween(items[ "button_text" ], {TextColor3 = rgb(178, 178, 178)})
            end)
            
            return setmetatable(cfg, library)
        end

        function library:list(properties) 
            local cfg = {
                items = {};
                options = properties.options or {"1", "2", "3"};
                flag = properties.flag or options.name or "please set me a flag 🥺";    
                callback = properties.callback or function() end;
                data_store = {};        
                current_element;
            }

            local items = cfg.items; do
                items[ "list" ] = library:create( "Frame" , {
                    Parent = self.items[ "elements" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "list" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "list" ];
                    PaddingRight = dim(0, 4);
                    PaddingLeft = dim(0, 4)
                });
            end 

            function cfg.refresh_options(options_to_refresh) -- ignore goofy parameter
                for _,option in cfg.data_store do 
                    option:Destroy()
                end

                for _, option_data in options_to_refresh do -- haha u skids no next >_<
                    local button = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = items[ "list" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(1, 0, 0, 30);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 35)
                    }); cfg.data_store[#cfg.data_store + 1] = button;

                    local name = library:create( "TextLabel" , {
                        FontFace = library.font;
                        TextColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = option_data;
                        Parent = button;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = button;
                        CornerRadius = dim(0, 3)
                    });     

                    button.MouseButton1Click:Connect(function()
                        local current = cfg.current_element 
                        if current and current ~= name then 
                            library:tween(current, {TextColor3 = rgb(72, 72, 72)})
                        end

                        flags[cfg.flag] = option_data
                        cfg.callback(option_data)
                        library:tween(name, {TextColor3 = rgb(245, 245, 245)})
                        cfg.current_element = name
                    end)

                    name.MouseEnter:Connect(function()
                        if cfg.current_element == name then 
                            return 
                        end 

                        library:tween(name, {TextColor3 = rgb(140, 140, 140)})
                    end)

                    name.MouseLeave:Connect(function()
                        if cfg.current_element == name then 
                            return 
                        end 

                        library:tween(name, {TextColor3 = rgb(72, 72, 72)})
                    end)
                end
            end

            cfg.refresh_options(cfg.options)

            return setmetatable(cfg, library)
        end 

        function library:init_config(window) 
            local textbox;
            local main = window:Tab({name = "Configs", icon = "rbxassetid://72506063321241"})
            local section = main:Section({name = "Settings", side = "right", size = 1, default = true})
            config_holder = section:Dropdown({Name = "Configs", options = {"Report", "This", "Error", "To", "Finobe"}, callback = function(option) if textbox then textbox.set(option) end end, flag = "config_name_list"}); library:update_config_list()
            textbox = section:Textbox({name = "Config name:", flag = "config_name_text"})
            section:Button({name = "Save", callback = function() writefile(library.directory .. "/configs/" .. flags["config_name_text"] .. ".cfg", library:get_config()) library:update_config_list() end}) 
            section:Button({name = "Load", callback = function() library:load_config(readfile(library.directory .. "/configs/" .. flags["config_name_text"] .. ".cfg"))  library:update_config_list() end})
            section:Button({name = "Delete", callback = function() delfile(library.directory .. "/configs/" .. flags["config_name_text"] .. ".cfg")  library:update_config_list() end})
            
            window.tweening = true 
            section:Label({Name = "UI Bind"}):Keybind({callback = function(bool) window.toggle_menu(bool) print(window.tweening) end, default = false})
        end
        function library:Watermark(text)
            if library.WatermarkObj then
                return library.WatermarkObj
            end

            local outline = library:create("Frame", {
                Parent = library.other;
                Position = dim2(1, -20, 0, 20);
                AnchorPoint = vec2(1, 0);
                BackgroundColor3 = rgb(46, 46, 46);
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
            })

            local inline = library:create("Frame", {
                Parent = outline;
                Position = dim2(0, 1, 0, 1);
                BackgroundColor3 = rgb(21, 21, 21);
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.XY;
            })

            library:create("UIPadding", {
                Parent = inline;
                PaddingTop = dim(0, 4);
                PaddingBottom = dim(0, 4);
                PaddingLeft = dim(0, 8);
                PaddingRight = dim(0, 8);
            })

            -- Accent line at top
            local accent = library:create("Frame", {
                Parent = inline;
                Size = dim2(1, 0, 0, 1);
                Position = dim2(0, 0, 0, -4);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(210, 180, 80); -- default color
            })

            local label = library:create("TextLabel", {
                Parent = inline;
                FontFace = library.font;
                TextSize = 10;
                TextColor3 = rgb(255, 255, 255);
                Text = text or "";
                BackgroundTransparency = 1;
                AutomaticSize = Enum.AutomaticSize.XY;
            })

            local self_obj = {}
            function self_obj:SetText(new_text)
                label.Text = new_text
            end
            function self_obj:SetVisibility(visible)
                outline.Visible = visible
            end
            self_obj.SetVisiblity = self_obj.SetVisibility

            library.WatermarkObj = self_obj
            return self_obj
        end

        function library:KeybindList()
            if library.KeybindListObj then
                return library.KeybindListObj
            end

            local outline = library:create("Frame", {
                Parent = library.other;
                Position = dim2(0, 20, 0.4, 0);
                BackgroundColor3 = rgb(46, 46, 46);
                BorderSizePixel = 0;
                Size = dim2(0, 180, 0, 0);
                AutomaticSize = Enum.AutomaticSize.Y;
                Visible = false;
            })

            local inline = library:create("Frame", {
                Parent = outline;
                Position = dim2(0, 1, 0, 1);
                BackgroundColor3 = rgb(21, 21, 21);
                BorderSizePixel = 0;
                Size = dim2(1, -2, 0, 0);
                AutomaticSize = Enum.AutomaticSize.Y;
            })

            library:create("UIPadding", {
                PaddingBottom = dim(0, 1);
                PaddingRight = dim(0, 1);
                Parent = outline
            })

            -- Accent line at top
            local accent = library:create("Frame", {
                Parent = inline;
                Size = dim2(1, 0, 0, 1);
                Position = dim2(0, 0, 0, 0);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(210, 180, 80);
            })

            local container = library:create("Frame", {
                Parent = inline;
                BackgroundTransparency = 1;
                Size = dim2(1, 0, 0, 0);
                AutomaticSize = Enum.AutomaticSize.Y;
            })

            library:create("UIListLayout", {
                Parent = container;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Padding = dim(0, 2);
            })

            library:create("UIPadding", {
                Parent = container;
                PaddingTop = dim(0, 6);
                PaddingBottom = dim(0, 6);
                PaddingLeft = dim(0, 8);
                PaddingRight = dim(0, 8);
            })

            -- Header text inside container
            local header = library:create("TextLabel", {
                Parent = container;
                FontFace = library.font;
                TextSize = 10;
                TextColor3 = rgb(255, 255, 255);
                Text = "keybinds";
                BackgroundTransparency = 1;
                Size = dim2(1, 0, 0, 12);
                TextXAlignment = Enum.TextXAlignment.Center;
                LayoutOrder = 1;
            })

            -- Separator under title
            local separator = library:create("Frame", {
                Parent = container;
                Size = dim2(1, 0, 0, 1);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(35, 35, 35);
                LayoutOrder = 2;
            })

            local items_frame = library:create("Frame", {
                Parent = container;
                BackgroundTransparency = 1;
                Size = dim2(1, 0, 0, 0);
                AutomaticSize = Enum.AutomaticSize.Y;
                LayoutOrder = 3;
            })

            library:create("UIListLayout", {
                Parent = items_frame;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Padding = dim(0, 4);
            })

            local active_widgets = {}

            local function update_list()
                for _, widget in ipairs(active_widgets) do
                    widget:Destroy()
                end
                active_widgets = {}

                if not library.Keybinds then return end

                local order = 1
                for _, kb in ipairs(library.Keybinds) do
                    if kb.active and kb.name then
                        local entry = library:create("Frame", {
                            Parent = items_frame;
                            BackgroundTransparency = 1;
                            Size = dim2(1, 0, 0, 12);
                            LayoutOrder = order;
                        })

                        local name_lbl = library:create("TextLabel", {
                            Parent = entry;
                            FontFace = library.font;
                            TextSize = 10;
                            TextColor3 = rgb(178, 178, 178);
                            Text = tostring(kb.name):lower();
                            BackgroundTransparency = 1;
                            Size = dim2(0.7, 0, 1, 0);
                            TextXAlignment = Enum.TextXAlignment.Left;
                        })

                        local mode_text = "[" .. tostring(kb.mode):lower() .. "]"
                        local mode_lbl = library:create("TextLabel", {
                            Parent = entry;
                            FontFace = library.font;
                            TextSize = 10;
                            TextColor3 = rgb(210, 180, 80);
                            Text = mode_text;
                            BackgroundTransparency = 1;
                            Size = dim2(0.3, 0, 1, 0);
                            Position = dim2(0.7, 0, 0, 0);
                            TextXAlignment = Enum.TextXAlignment.Right;
                        })

                        table.insert(active_widgets, entry)
                        order = order + 1
                    end
                end

                if order == 1 then
                    items_frame.Visible = false
                    header.Visible = false
                    separator.Visible = false
                    accent.Visible = false
                    outline.BackgroundTransparency = 1
                    inline.BackgroundTransparency = 1
                else
                    items_frame.Visible = true
                    header.Visible = true
                    separator.Visible = true
                    accent.Visible = true
                    outline.BackgroundTransparency = 0
                    inline.BackgroundTransparency = 0
                end
            end

            local self_obj = {}
            function self_obj:SetVisibility(visible)
                outline.Visible = visible
            end
            self_obj.SetVisiblity = self_obj.SetVisibility
            
            function self_obj:Update()
                update_list()
            end

            library.KeybindListObj = self_obj
            library.KeyList = self_obj

            update_list()

            return self_obj
        end

        local _loadingNotification = nil
        function library:ShowLoadingNotification(text)
            if _loadingNotification and _loadingNotification.Instance and _loadingNotification.Instance.Parent then
                _loadingNotification.Text.Text = text or ""
                _loadingNotification.Instance.Visible = true
                return _loadingNotification
            end

            local parent = library.other
            if not parent then return nil end

            local frame = library:create("Frame", {
                Name = "_alternateLoadingToast";
                AnchorPoint = vec2(0, 0);
                Position = dim2(0, 12, 0, 12);
                Size = dim2(0, 300, 0, 28);
                BackgroundColor3 = rgb(18, 18, 18);
                BackgroundTransparency = 0;
                BorderSizePixel = 1;
                BorderColor3 = rgb(80, 80, 80);
                Parent = parent;
            })

            local stroke = library:create("UIStroke", {
                Color = rgb(120, 120, 120);
                Transparency = 0.3;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Parent = frame;
            })

            local text_lbl = library:create("TextLabel", {
                Name = "Text";
                BackgroundTransparency = 1;
                Size = dim2(1, -12, 1, 0);
                Position = dim2(0, 6, 0, 0);
                Text = text or "/alternate loading";
                TextColor3 = rgb(235, 235, 235);
                FontFace = library.font;
                TextSize = 12;
                TextXAlignment = Enum.TextXAlignment.Left;
                Parent = frame;
            })

            local bar = library:create("Frame", {
                Name = "Progress";
                AnchorPoint = vec2(0, 0);
                Position = dim2(0, 0, 1, 2);
                Size = dim2(1, 0, 0, 1.5);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(210, 180, 80);
                BackgroundTransparency = 0;
                Parent = frame;
            })

            _loadingNotification = {
                Instance = frame,
                Text = text_lbl,
                Bar = bar,
                Destroy = function()
                    if frame and frame.Parent then
                        frame:Destroy()
                    end
                    _loadingNotification = nil
                end,
            }
            return _loadingNotification
        end

        function library:HideLoadingNotification()
            if _loadingNotification and _loadingNotification.Destroy then
                pcall(_loadingNotification.Destroy)
            end
            _loadingNotification = nil
        end

        local _confirmOverlay = nil
        local function closeConfirmDialog()
            if _confirmOverlay and _confirmOverlay.Parent then
                _confirmOverlay:Destroy()
            end
            _confirmOverlay = nil
        end

        function library:ShowConfirmDialog(title, message, yesText, noText, yesCallback, noCallback)
            closeConfirmDialog()
            local parent = library.other
            if not parent then
                if yesCallback then yesCallback() end
                return
            end

            local screen = library:create("Frame", {
                Name = "AlternateConfirmDialog",
                Size = dim2(1, 0, 1, 0),
                BackgroundTransparency = 0.5,
                BackgroundColor3 = rgb(0, 0, 0),
                Parent = parent,
            })

            local background = library:create("Frame", {
                Name = "Background",
                AnchorPoint = vec2(0.5, 0.5),
                Position = dim2(0.5, 0, 0.5, 0),
                Size = dim2(0, 380, 0, 160),
                BackgroundColor3 = rgb(0, 0, 0),
                BorderSizePixel = 0,
                Parent = screen,
            })

            library:create("TextLabel", {
                Name = "Title",
                AnchorPoint = vec2(0.5, 0),
                Position = dim2(0.5, 0, 0, 12),
                Size = dim2(1, -24, 0, 24),
                BackgroundTransparency = 1,
                FontFace = library.font,
                TextSize = 18,
                TextColor3 = rgb(255, 255, 255),
                Text = title or "Confirm",
                Parent = background,
            })

            library:create("TextLabel", {
                Name = "Message",
                AnchorPoint = vec2(0.5, 0),
                Position = dim2(0.5, 0, 0, 44),
                Size = dim2(1, -24, 0, 70),
                BackgroundTransparency = 1,
                FontFace = library.font,
                TextSize = 14,
                TextColor3 = rgb(220, 220, 220),
                TextWrapped = true,
                Text = message or "",
                TextYAlignment = Enum.TextYAlignment.Top,
                Parent = background,
            })

            local buttonsFrame = library:create("Frame", {
                Name = "Buttons",
                AnchorPoint = vec2(0.5, 1),
                Position = dim2(0.5, 0, 1, -14),
                Size = dim2(1, -24, 0, 42),
                BackgroundTransparency = 1,
                Parent = background,
            })

            local yesButton = library:create("TextButton", {
                Name = "YesButton",
                Size = dim2(0.48, 0, 1, 0),
                Position = dim2(0, 0, 0, 0),
                BackgroundColor3 = rgb(64, 142, 255),
                BorderSizePixel = 0,
                FontFace = library.font,
                TextSize = 16,
                TextColor3 = rgb(255, 255, 255),
                Text = yesText or "Yes",
                Parent = buttonsFrame,
            })

            local noButton = library:create("TextButton", {
                Name = "NoButton",
                Size = dim2(0.48, 0, 1, 0),
                Position = dim2(0.52, 0, 0, 0),
                BackgroundColor3 = rgb(80, 80, 80),
                BorderSizePixel = 0,
                FontFace = library.font,
                TextSize = 16,
                TextColor3 = rgb(255, 255, 255),
                Text = noText or "No",
                Parent = buttonsFrame,
            })

            yesButton.MouseButton1Click:Connect(function()
                screen:Destroy()
                _confirmOverlay = nil
                if yesCallback then pcall(yesCallback) end
            end)
            noButton.MouseButton1Click:Connect(function()
                screen:Destroy()
                _confirmOverlay = nil
                if noCallback then pcall(noCallback) end
            end)

            _confirmOverlay = screen
            return screen
        end
    --

    -- Notification library
		local notifications = library.notifications

		function notifications:refresh_notifs() 
			local yOffset = 50
			for i, v in notifications.notifs do
				local Position = vec2(20, yOffset)
				tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = dim_offset(Position.X, Position.Y)}):Play()
				yOffset = yOffset + v.AbsoluteSize.Y + 10
			end
		end
		
		function notifications:fade(path, is_fading)
			local fading = is_fading and 1 or 0 
			
			tween_service:Create(path, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = fading}):Play()

			for _, instance in path:GetDescendants() do 
				if instance:IsA("UIStroke") then
					tween_service:Create(instance, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Transparency = fading}):Play()
				elseif instance:IsA("TextLabel") then
					tween_service:Create(instance, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = fading}):Play()
				elseif instance:IsA("Frame") then
					tween_service:Create(instance, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = fading}):Play()
				end
			end
		end 

		function notifications:create_notification(options)
			local cfg = {
				name = options.name or "Hit: q3sm (finobe) in the Head for 100 Damage!",
				color = options.color or rgb(255, 255, 255);
				clickable = options.click or false;
			}
			
			-- Instances
				local outline = library:create("TextButton", {
					Parent = library.items;
					Size = dim2(0, 0, 0, 0);
					BorderColor3 = rgb(0, 0, 0);
					BorderSizePixel = 0;
					AutoButtonColor = false;
					Text = "";
					AutomaticSize = Enum.AutomaticSize.XY;
					BackgroundColor3 = rgb(46, 46, 46)
				});

				local inline = library:create("Frame", {
					Parent = outline;
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					BorderSizePixel = 0;
					AutomaticSize = Enum.AutomaticSize.XY;
					BackgroundColor3 = rgb(21, 21, 21)
				});	
				
				local uigradient = library:create("UIGradient", {
					Color = rgbseq{rgbkey(0, rgb(255, 0, 0)), rgbkey(0.17, rgb(255, 255, 0)), rgbkey(0.33, rgb(0, 255, 0)), rgbkey(0.5, rgb(0, 255, 255)), rgbkey(0.67, rgb(0, 0, 255)), rgbkey(0.83, rgb(255, 0, 255)), rgbkey(1, rgb(255, 0, 0))};
					Transparency = numseq{numkey(0, -1), numkey(1, -1)};
					Parent = menu_title
				});
				
				library:create("UIPadding", {
					PaddingTop = dim(0, 7);
					PaddingBottom = dim(0, 6);
					Parent = inline;
					PaddingRight = dim(0, 8);
					PaddingLeft = dim(0, 4)
				});
				
				local misc_text = library:create("TextLabel", {
					FontFace = library.font;
					Parent = inline;
					LineHeight = 1.75;
					TextColor3 = rgb(255, 255, 255);
					BorderColor3 = rgb(0, 0, 0);
					Text = cfg.name; -- string.format("[ cht name ] %s", cfg.name);
					AutomaticSize = Enum.AutomaticSize.XY;
					Size = dim2(1, -4, 1, 0);
					Position = dim2(0, 4, 0, -2);
					BackgroundTransparency = 1;
					TextXAlignment = Enum.TextXAlignment.Left;
					BorderSizePixel = 0;
					ZIndex = 2;
					TextSize = 10;
					BackgroundColor3 = rgb(255, 255, 255)
				});
				
				library:create("UIPadding", {
					PaddingBottom = dim(0, 1);
					PaddingRight = dim(0, 1);
					Parent = outline
				});

				local line = library:create( "Frame" , {
					Parent = outline;
					Name = "\0";
					Position = dim2(0, 1, 1, -1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(0, 0, 0, 1);
					BorderSizePixel = 0;
					BackgroundColor3 = cfg.color
				});
				
				local accent = library:create( "Frame" , {
					Parent = outline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(0, 1, 1, -1);
					BorderSizePixel = 0;
					BackgroundColor3 = cfg.color
				});
			-- 
			
			local index = #notifications.notifs + 1
			notifications.notifs[index] = outline
			
			notifications:refresh_notifs()
			tween_service:Create(outline, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {AnchorPoint = vec2(0, 0)}):Play()
			
			for _, obj in outline:GetDescendants() do
                if obj:IsA("Frame") or obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                    library.fade(obj, "BackgroundTransparency", true)
        
                elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    library.fade(obj, "TextTransparency", true)
                    
                elseif obj:IsA("UIStroke") then
                    library.fade(obj, "Transparency", true)
        
                elseif obj:IsA("ScrollingFrame") then
                    library.fade(obj, "ScrollBarImageTransparency", true)
                end
            end
            print("fade1")

			outline.Position = dim2(0, 20, 0, #notifications.notifs * 20);

			if cfg.clickable then 
				outline.MouseButton1Click:Connect(function()
					notifications.notifs[index] = nil
					task.wait(1)
					outline:Destroy() 
					notifications:refresh_notifs()
				end)
			else 
                -- booty code
				task.spawn(function()
					tween_service:Create(line, TweenInfo.new(3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = dim2(1, -1, 0, 1)}):Play()
					task.wait(5)
                    print("fade2")
					notifications.notifs[index] = nil
					for _, obj in outline:GetDescendants() do
                        if obj:IsA("Frame") or obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                            library.fade(obj, "BackgroundTransparency", false)
                
                        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                            library.fade(obj, "TextTransparency", false)
                
                        elseif obj:IsA("UIStroke") then
                            library.fade(obj, "Transparency", false)
                
                        elseif obj:IsA("ScrollingFrame") then
                            library.fade(obj, "ScrollBarImageTransparency", false)
                        end
                    end
					task.wait(1)
					outline:Destroy() 
					notifications:refresh_notifs()
				end)
			end
		end
	-- 
-- 


-- ==========================================
-- RELOCATED UI LOGIC AND LAYOUT (FROM MESSAGE.TXT)
-- ==========================================

getgenv().Flags = library.flags
local Flags = library.flags

EspLibrary = {
    ['Cache'] = {},
    ['Threads'] = {},
    ['Connections'] = {},
    ['Holder'] = nil
}

local espMeta = {}
espMeta.__index = (function(t, key)
    return rawget(EspLibrary, key)
end)
setmetatable(EspLibrary, espMeta)

SmallestPixel = Library.Font
TahomaBold = Library.Font
Tahoma = Library.Font
ProggyClean = Library.Font
ProggyTiny = Library.Font
UIFont = Library.Font

function EspLibrary:CreateObjects(Name, Prop)
    local New = Instance.new(Name)
    for Property, Value in Prop or {} do
        New[Property] = Value
    end
    return New
end

function EspLibrary:CreateThreads(Name, Signal, Callback)
    if not Signal or (typeof(Signal) ~= "RBXScriptSignal" and (type(Signal) ~= "table" or type(Signal.Connect) ~= "function")) then
        return nil
    end
    local Connection = Signal:Connect(Callback)
    self.Threads[Name] = Connection
    return Connection
end

parentGui = (function()
    if gethui then local ok, res = pcall(gethui); if ok and res then return res end end
    local coreGui = game:GetService("CoreGui")
    local ok = pcall(function() local f = Instance.new("Folder"); f.Parent = coreGui; f:Destroy() end)
    if ok then return coreGui end
    return Players.LocalPlayer and Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
end)()
EspLibrary.Holder = EspLibrary:CreateObjects("ScreenGui", {
    Name = "\n",
    Parent = parentGui,
    ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    ResetOnSpawn = false,
    DisplayOrder = 10000,
    IgnoreGuiInset = true,
})
pcall(function()
    if not EspLibrary.Holder.Parent or not EspLibrary.Holder.Parent:IsA("Instance") then
        local pg = Players.LocalPlayer and Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if pg then EspLibrary.Holder.Parent = pg end
    end
end)

function EspLibrary:InitEsp(Data)
    local Objects = Data.Objects

    Objects["TargetHolder"] = self:CreateObjects("Frame", {
        Parent = self.Holder,
        Visible = false,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
    })

    Objects["TopHolder"] = self:CreateObjects("Frame", {
        Parent = Objects["TargetHolder"],
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = true,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, -2, 0, -5),
        Size = UDim2.new(1, 4, 0, 0),
        BorderSizePixel = 0,
    })

    Objects["BottomHolder"] = self:CreateObjects("Frame", {
        Parent = Objects["TargetHolder"],
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = true,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -2, 1, 3),
        Size = UDim2.new(1, 4, 0, 0),
        BorderSizePixel = 0,
    })

    Objects["LeftHolder"] = self:CreateObjects("Frame", {
        Parent = Objects["TargetHolder"],
        AutomaticSize = Enum.AutomaticSize.X,
        Visible = true,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(0, -5, 0, -2),
        Size = UDim2.new(0, 0, 1, 4),
        BorderSizePixel = 0,
    })

    Objects["RightHolder"] = self:CreateObjects("Frame", {
        Parent = Objects["TargetHolder"],
        AutomaticSize = Enum.AutomaticSize.X,
        Visible = true,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, 5, 0, -2),
        Size = UDim2.new(0, 0, 1, 4),
        BorderSizePixel = 0,
    })

    Objects["TopTextHolder"] = self:CreateObjects("Frame", {
        Parent = Objects["TopHolder"],
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = true,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        BorderSizePixel = 0,
    })

    Objects["BottomTextHolder"] = self:CreateObjects("Frame", {
        Parent = Objects["BottomHolder"],
        LayoutOrder = 2,
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = true,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        BorderSizePixel = 0,
    })

    Objects["LeftTextHolder"] = self:CreateObjects("Frame", {
        Parent = Objects["LeftHolder"],
        AutomaticSize = Enum.AutomaticSize.XY,
        Visible = true,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        BorderSizePixel = 0,
    })

    Objects["RightTextHolder"] = self:CreateObjects("Frame", {
        Parent = Objects["RightHolder"],
        LayoutOrder = 2,
        AutomaticSize = Enum.AutomaticSize.XY,
        Visible = true,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    })

    Objects["LeftBarHolder"] = self:CreateObjects("Frame", {
        Parent = Objects["LeftHolder"],
        AutomaticSize = Enum.AutomaticSize.X,
        Visible = false,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0,
    })

    Objects["BottomBarHolder"] = self:CreateObjects("Frame", {
        Parent = Objects["BottomHolder"],
        LayoutOrder = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = false,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        BorderSizePixel = 0,
    })

    self:CreateObjects("UIListLayout", {
        Parent = Objects["TopTextHolder"],
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 1),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    self:CreateObjects("UIListLayout", {
        Parent = Objects["BottomTextHolder"],
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, -1),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    self:CreateObjects("UIListLayout", {
        Parent = Objects["LeftTextHolder"],
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    self:CreateObjects("UIListLayout", {
        Parent = Objects["RightTextHolder"],
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    self:CreateObjects("UIListLayout", {
        Parent = Objects["LeftBarHolder"],
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    self:CreateObjects("UIListLayout", {
        Parent = Objects["BottomBarHolder"],
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    self:CreateObjects("UIListLayout", {
        Parent = Objects["TopHolder"],
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 1),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    self:CreateObjects("UIListLayout", {
        Parent = Objects["BottomHolder"],
        Padding = UDim.new(0, 1),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    self:CreateObjects("UIListLayout", {
        Parent = Objects["LeftHolder"],
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 1),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    self:CreateObjects("UIListLayout", {
        Parent = Objects["RightHolder"],
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 1),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    self:CreateObjects("UIPadding", {
        Parent = Objects["TopTextHolder"],
        PaddingBottom = UDim.new(0, 0),
    })

    self:CreateObjects("UIPadding", {
        Parent = Objects["BottomTextHolder"],
        PaddingTop = UDim.new(0, -1)
    })

    self:CreateObjects("UIPadding", {
        Parent = Objects["LeftTextHolder"],
        PaddingTop = UDim.new(0, -3),
    })

    self:CreateObjects("UIPadding", {
        Parent = Objects["RightTextHolder"],
        PaddingTop = UDim.new(0, -3),
    })

    self:CreateObjects("UIPadding", {
        Parent = Objects["LeftBarHolder"],
        PaddingRight = UDim.new(0, 0),
    })

    self:CreateObjects("UIPadding", {
        Parent = Objects["BottomBarHolder"],
        PaddingTop = UDim.new(0, 2),
    })

    self:CreateObjects("UIPadding", {
        Parent = Objects["LeftHolder"],
        PaddingRight = UDim.new(0, 1),
    })



    Objects["BoxOutlineHolder"] = self:CreateObjects("Frame", {
        Parent = Objects["TargetHolder"],
        Visible = false,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -1, 0, -1),
        BorderSizePixel = 0,
    })

    Objects["BoxOutline"] = self:CreateObjects("UIStroke", {
        Parent = Objects["BoxOutlineHolder"],
        Thickness = 1,
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects["BoxOutlineGradient"] = self:CreateObjects("UIGradient", {
        Parent = Objects["BoxOutline"],
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
        }),
    })

    Objects["BoxInlineHolder"] = self:CreateObjects("Frame", {
        Parent = Objects["TargetHolder"],
        Visible = false,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
    })

    Objects["BoxInline"] = self:CreateObjects("UIStroke", {
        Parent = Objects["BoxInlineHolder"],
        Color = Color3.fromRGB(255, 255, 255),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects["BoxInlineGradient"] = self:CreateObjects("UIGradient", {
        Parent = Objects["BoxInline"],
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
        }),
    })

    Objects["BoxFill"] = self:CreateObjects("Frame", {
        Parent = Objects["TargetHolder"],
        Visible = false,
        BackgroundTransparency = 0,
        Position = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
    })

    Objects["BoxFillGradient"] = self:CreateObjects("UIGradient", {
        Parent = Objects["BoxFill"],
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
        }),
        Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 1)}),
    })

    Objects["CornerHolder"] = self:CreateObjects("Frame", {
        Parent = Objects["TargetHolder"],
        Visible = false,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
    })

    for i = 1, 8 do
        Objects["Line_" .. i] = self:CreateObjects("Frame", {
            Parent = Objects["CornerHolder"],
            Visible = false,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
        })
        self:CreateObjects("UIStroke", {
            Parent = Objects["Line_" .. i],
            Thickness = 1,
            LineJoinMode = Enum.LineJoinMode.Miter,
        })
    end

    Objects["HealthBarOutline"] = self:CreateObjects("Frame", {
        Parent = Objects["LeftBarHolder"],
        ZIndex = 5,
        LayoutOrder = 0,
        Visible = false,
        BackgroundTransparency = 0,
        Size = UDim2.new(0, 1, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        ClipsDescendants = false,
    })

    self:CreateObjects("UIStroke", {
        Parent = Objects["HealthBarOutline"],
        Thickness = 1,
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects["HealthBar"] = self:CreateObjects("Frame", {
        Parent = Objects["HealthBarOutline"],
        ZIndex = 6,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ClipsDescendants = true,
    })

    Objects["HealthBarGradient"] = self:CreateObjects("UIGradient", {
        Parent = Objects["HealthBar"],
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 170, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
        }),
    })

    Objects["HealthBarText"] = self:CreateObjects("TextLabel", {
        Parent = Objects["HealthBarOutline"],
        FontFace = UIFont,
        TextSize = 12,
        ZIndex = 10,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = "",
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 1, 0),
        BorderSizePixel = 0,
        Visible = false,
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.new(0, 0, 0, 0),
    })

    self:CreateObjects("UIStroke", {
        Parent = Objects["HealthBarText"],
        Color = Color3.fromRGB(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects["ArmorBarOutline"] = self:CreateObjects("Frame", {
        Parent = Objects["BottomBarHolder"],
        ZIndex = 5,
        LayoutOrder = 0,
        Visible = false,
        BackgroundTransparency = 0,
        Size = UDim2.new(1, 0, 0, 1),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        ClipsDescendants = true,
    })

    self:CreateObjects("UIStroke", {
        Parent = Objects["ArmorBarOutline"],
        Thickness = 1,
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects["ArmorBar"] = self:CreateObjects("Frame", {
        Parent = Objects["ArmorBarOutline"],
        ZIndex = 6,
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    })

    Objects["ArmorBarGradient"] = self:CreateObjects("UIGradient", {
        Parent = Objects["ArmorBar"],
        Rotation = 0,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 220, 220)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180)),
        }),
    })

    Objects["ArmorBarText"] = self:CreateObjects("TextLabel", {
        Parent = Objects["ArmorBar"],
        FontFace = UIFont,
        TextSize = 12,
        ZIndex = 10,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = "",
        TextXAlignment = Enum.TextXAlignment.Center,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BorderSizePixel = 0,
        Visible = false,
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.new(0, 0, 0, 0),
    })

    self:CreateObjects("UIStroke", {
        Parent = Objects["ArmorBarText"],
        Color = Color3.fromRGB(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects["TargetName"] = self:CreateObjects("TextLabel", {
        Parent = Objects["TopTextHolder"],
        FontFace = UIFont,
        TextSize = 16,
        LayoutOrder = 2,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = "",
        TextXAlignment = Enum.TextXAlignment.Center,
        BorderSizePixel = 0,
        Visible = false,
        BackgroundTransparency = 1,
        ZIndex = 5,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.new(0, 0, 0, 0),
    })

    self:CreateObjects("UIStroke", {
        Parent = Objects["TargetName"],
        Color = Color3.fromRGB(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects["Distance"] = self:CreateObjects("TextLabel", {
        Parent = Objects["BottomTextHolder"],
        FontFace = UIFont,
        TextSize = 12,
        LayoutOrder = 2,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = "",
        TextXAlignment = Enum.TextXAlignment.Center,
        BorderSizePixel = 0,
        Visible = false,
        BackgroundTransparency = 1,
        ZIndex = 5,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.new(0, 0, 0, 0),
    })

    self:CreateObjects("UIStroke", {
        Parent = Objects["Distance"],
        Color = Color3.fromRGB(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects["WalkFlag"] = self:CreateObjects("TextLabel", {
        Parent = Objects["RightTextHolder"],
        FontFace = UIFont,
        TextSize = 12,
        LayoutOrder = 1,
        TextColor3 = Color3.fromRGB(255, 0, 0),
        Text = "Walking",
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        Visible = false,
        BackgroundTransparency = 1,
        ZIndex = 5,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.new(0, 0, 0, 0),
    })

    self:CreateObjects("UIStroke", {
        Parent = Objects["WalkFlag"],
        Color = Color3.fromRGB(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects["JumpFlag"] = self:CreateObjects("TextLabel", {
        Parent = Objects["RightTextHolder"],
        FontFace = UIFont,
        TextSize = 12,
        LayoutOrder = 2,
        TextColor3 = Color3.fromRGB(144, 238, 144),
        Text = "Jumping",
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        Visible = false,
        BackgroundTransparency = 1,
        ZIndex = 5,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.new(0, 0, 0, 0),
    })

    self:CreateObjects("UIStroke", {
        Parent = Objects["JumpFlag"],
        Color = Color3.fromRGB(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects["SwimmingFlag"] = self:CreateObjects("TextLabel", {
        Parent = Objects["RightTextHolder"],
        FontFace = UIFont,
        TextSize = 12,
        LayoutOrder = 4,
        TextColor3 = Color3.fromRGB(0, 255, 255),
        Text = "Swimming",
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        Visible = false,
        BackgroundTransparency = 1,
        ZIndex = 5,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.new(0, 0, 0, 0),
    })

    self:CreateObjects("UIStroke", {
        Parent = Objects["SwimmingFlag"],
        Color = Color3.fromRGB(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects["ToolIcon"] = self:CreateObjects("ImageLabel", {
        Parent = Objects["BottomTextHolder"],
        Image = "",
        ScaleType = Enum.ScaleType.Stretch,
        LayoutOrder = 2,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 5,
        Size = UDim2.new(0, 16, 0, 16),
    })

    self:CreateObjects("UIStroke", {
        Parent = Objects["ToolIcon"],
        Color = Color3.fromRGB(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
        Enabled = false,
    })

    Objects["Weapon"] = self:CreateObjects("TextLabel", {
        Parent = Objects["BottomTextHolder"],
        FontFace = UIFont,
        TextSize = 12,
        LayoutOrder = 3,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = "none",
        TextXAlignment = Enum.TextXAlignment.Center,
        BorderSizePixel = 0,
        Visible = false,
        BackgroundTransparency = 1,
        ZIndex = 5,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.new(0, 0, 0, 0),
    })

    self:CreateObjects("UIStroke", {
        Parent = Objects["Weapon"],
        Color = Color3.fromRGB(0, 0, 0),
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    Objects["TracerOutline"] = safeDrawing("Line")
    Objects["TracerOutline"].Visible = false
    Objects["TracerOutline"].Thickness = 1.5
    Objects["TracerOutline"].Color = Color3.fromRGB(0, 0, 0)
    Objects["TracerOutline"].ZIndex = 1

    Objects["TracerInline"] = safeDrawing("Line")
    Objects["TracerInline"].Visible = false
    Objects["TracerInline"].Thickness = 1
    Objects["TracerInline"].Color = Color3.fromRGB(255, 255, 255)
    Objects["TracerInline"].ZIndex = 2
end

getColor = _LPH_NV(function(flagName, default)
    local val = Flags[flagName]
    local baseColor = default
    
    if typeof(val) == "Color3" then
        baseColor = val
    elseif type(val) == "table" and val.Color then
        baseColor = val.Color
        if type(baseColor) == "string" then
            if not string.find(baseColor, "#") then baseColor = "#" .. baseColor end
            local ok, c = pcall(Color3.fromHex, baseColor)
            baseColor = ok and c or default
        elseif typeof(baseColor) ~= "Color3" then
            baseColor = default
        end
    end

    if Flags["ESP_RGBMode"] and string.find(flagName, "ESP_") and not string.find(flagName, "Outline") then
        local speed = Flags["ESP_RGBSpeed"] or 5
        local hue = (tick() * speed / 10) % 1
        local _, s, v = baseColor:ToHSV()
        if s == 0 then s = 1 end
        if v == 0 then v = 1 end
        return Color3.fromHSV(hue, s, v)
    end

    if type(val) == "table" then
        local rgbMode = val.RGBMode
        if rgbMode and rgbMode ~= "Static" and rgbMode ~= false then
            local speed = val.RGBSpeed or 5
            local t = tick()
            local baseH, baseS, baseV = baseColor:ToHSV()
            if rgbMode == "Rainbow" or rgbMode == true then
                local hue = (t * speed / 10) % 1
                return Color3.fromHSV(hue, math.max(baseS, 0.7), math.max(baseV, 0.8))
            elseif rgbMode == "Gradient" then
                local hue = (t * speed / 10) % 1
                return Color3.fromHSV(hue, 1, baseV)
            elseif rgbMode == "Pulse" then
                local pulse = 0.5 + 0.5 * math.sin(t * speed / 3)
                return Color3.fromHSV(baseH, baseS, pulse)
            elseif rgbMode == "Hue Shift" then
                local hue = (t * speed / 5) % 1
                return Color3.fromHSV(hue, baseS, baseV)
            elseif rgbMode == "Breathe" then
                local breathe = 0.3 + 0.7 * (0.5 + 0.5 * math.sin(t * speed / 4))
                return Color3.fromHSV(baseH, baseS, breathe)
            end
        end
        if typeof(val.Color) == "Color3" then
            return val.Color
        end
    end
    if typeof(baseColor) ~= "Color3" then
        return default
    end
    return baseColor
end)

local fontMap = {
    ["ProggyClean"] = Library.Font,
    ["SmallestPixel"] = Library.Font,
    ["Tahoma"] = Library.Font,
    ["TahomaBold"] = Library.Font,
    ["Arial"] = Library.Font,
    ["SourceSans"] = Library.Font,
    ["Roboto"] = Library.Font,
    ["Ubuntu"] = Library.Font,
    ["Merriweather"] = Library.Font,
    ["JosefinSans"] = Library.Font,
    ["SpecialElite"] = Library.Font,
    ["Michroma"] = Library.Font
}

getESPFont = (function()
    local selected = Flags["ESP_Font"] or "ProggyClean"
    return Library.Font or fontMap[selected] or Library.Font
end)

CornerLayout = {
    {UDim2.new(0, -1, 0, -1), UDim2.new(0.2, 0, 0, 1), Vector2.new(0, 0), 0},
    {UDim2.new(0, -1, 0, -1), UDim2.new(0, 1, 0.2, 0), Vector2.new(0, 0), 180},
    {UDim2.new(1, 1, 0, -1), UDim2.new(0.2, 0, 0, 1), Vector2.new(1, 0), 0},
    {UDim2.new(1, 1, 0, -1), UDim2.new(0, 1, 0.2, 0), Vector2.new(1, 0), 180},
    {UDim2.new(0, -1, 1, 1), UDim2.new(0.2, 0, 0, 1), Vector2.new(0, 1), 0},
    {UDim2.new(0, -1, 1, 1), UDim2.new(0, 1, 0.2, 0), Vector2.new(0, 1), -180},
    {UDim2.new(1, 1, 1, 1), UDim2.new(0.2, 0, 0, 1), Vector2.new(1, 1), 0},
    {UDim2.new(1, 1, 1, 1), UDim2.new(0, 1, 0.2, 0), Vector2.new(1, 1), -180},
}

EspLibrary.CalculateBox = _LPH_NV(function(self, Data)
    local RootPart = Data['RootPart']
    if not RootPart then
        return nil, nil, nil, nil, false
    end

    local RootScreen, OnScreen = camera:WorldToViewportPoint(RootPart.Position)
    if not OnScreen then
        return nil, nil, nil, nil, false
    end

    if Flags["ESP_DynamicBoxes"] == true then
        local char = RootPart.Parent
        if not char then return nil, nil, nil, nil, false end
        local cf, size = char:GetBoundingBox()
        local sx, sy, sz = size.X * 0.5, size.Y * 0.5, size.Z * 0.5
        local corners = {
            cf * Vector3.new(-sx, -sy, -sz),
            cf * Vector3.new(-sx, -sy, sz),
            cf * Vector3.new(-sx, sy, -sz),
            cf * Vector3.new(-sx, sy, sz),
            cf * Vector3.new(sx, -sy, -sz),
            cf * Vector3.new(sx, -sy, sz),
            cf * Vector3.new(sx, sy, -sz),
            cf * Vector3.new(sx, sy, sz),
        }
        local minX, minY = math.huge, math.huge
        local maxX, maxY = -math.huge, -math.huge
        local anyOnScreen = false
        for i = 1, 8 do
            local pos, onScreen = camera:WorldToViewportPoint(corners[i])
            if onScreen then
                anyOnScreen = true
            end
            if pos.X < minX then minX = pos.X end
            if pos.X > maxX then maxX = pos.X end
            if pos.Y < minY then minY = pos.Y end
            if pos.Y > maxY then maxY = pos.Y end
        end
        if not anyOnScreen then
            return nil, nil, nil, nil, false
        end
        local W = maxX - minX
        local H = maxY - minY
        return W, H, minX, minY, true
    else
        local vPortY = camera.ViewportSize.Y
        local Scale = (RootPart.Size.Y * vPortY) / (RootScreen.Z * 2)
        local W, H = 3 * Scale, 4.5 * Scale
        return W, H, RootScreen.X - (W * 0.5), RootScreen.Y - (H * 0.5), OnScreen
    end
end)

function EspLibrary:AddTarget(Target)
    if self.Cache[Target] then return end

    local isPlayer = Target:IsA("Player")
    if isPlayer and Target == lp then
        local showOn = Flags["ESP_ShowOn"] or {}
        if not hasCheck(showOn, "Self") then return end
    end

    local Data = {
        ['Target'] = Target,
        ['IsPlayer'] = isPlayer,
        ['Objects'] = {},
        ['Conns'] = {},
        ['Character'] = nil,
        ['RootPart'] = nil,
        ['Humanoid'] = nil,
        ['Children'] = nil,
        ['Health'] = 0,
        ['MaxHealth'] = 100,
        ['Armor'] = 100,
        ['MaxArmor'] = 100,
        ['CurrentTool'] = nil,
        ['Alive'] = false,
        ['LastW'] = nil,
        ['LastH'] = nil,
        ['LastX'] = nil,
        ['LastY'] = nil,
        ['WalkActive'] = false,
        ['JumpActive'] = false,
        ['FallingActive'] = false,
        ['SwimmingActive'] = false,
        ['LastGlowTop'] = nil,
        ['LastGlowBot'] = nil,
        ['LastGlowT1'] = nil,
        ['LastGlowT2'] = nil,
        ['LastGradTop'] = nil,
        ['LastGradBot'] = nil,
        ['LastFillTop'] = nil,
        ['LastFillBot'] = nil,
        ['LastFillT1'] = nil,
        ['LastFillT2'] = nil,
        ['LastDist'] = nil,
        ['LastDistColor'] = nil,
        ['LastDisplayName'] = nil,
        ['LastNameColor'] = nil,
        ['LastHealthTop'] = nil,
        ['LastHealthMid'] = nil,
        ['LastHealthBot'] = nil,
        ['LastHealthFloor'] = nil,
        ['LastRatio'] = nil,
        ['LastArmorTop'] = nil,
        ['LastArmorMid'] = nil,
        ['LastArmorBot'] = nil,
        ['LastArmorFloor'] = nil,
        ['LastArmorRatio'] = nil,
        ['LastWeapon'] = nil,
        ['LastWeaponColor'] = nil,
    }
    self:InitEsp(Data)
    self['Cache'][Target] = Data

    local HealthHandler = {}
    function HealthHandler.BindHealth(Humanoid)
        if Data['Conns']['Health'] then Data['Conns']['Health']:Disconnect() end
        if Data['Conns']['Died'] then Data['Conns']['Died']:Disconnect() end

        Data['Humanoid'] = Humanoid
        Data['Health'] = Humanoid.Health
        Data['MaxHealth'] = Humanoid.MaxHealth
        Data['Alive'] = Humanoid.Health > 0

        Data['Conns']['Health'] = Humanoid.HealthChanged:Connect(function(NewHealth)
            Data['Alive'] = NewHealth > 0
            Data['Health'] = NewHealth
        end)

        Data['Conns']['Died'] = Humanoid.Died:Connect(function()
            Data['Alive'] = false
        end)
    end
    Data['BindHealth'] = HealthHandler.BindHealth

    local ToolHandler = {}
    function ToolHandler.BindTool(Character)
        if Data['Conns']['ToolAdded'] then Data['Conns']['ToolAdded']:Disconnect() end
        if Data['Conns']['ToolRemoved'] then Data['Conns']['ToolRemoved']:Disconnect() end

        if Data['Children'] then
            for _, Child in ipairs(Data['Children']) do
                if Child:IsA('Tool') then
                    Data['CurrentTool'] = Child.Name
                    Data['CurrentToolInstance'] = Child
                    break
                end
            end
        end

        Data['Conns']['ToolAdded'] = Character.ChildAdded:Connect(function(Child)
            if Child:IsA('Tool') then
                Data['CurrentTool'] = Child.Name
                Data['CurrentToolInstance'] = Child
            end
        end)

        Data['Conns']['ToolRemoved'] = Character.ChildRemoved:Connect(function(Child)
            if Child:IsA('Tool') then
                Data['CurrentTool'] = nil
                Data['CurrentToolInstance'] = nil
            end
        end)
    end
    Data['BindTool'] = ToolHandler.BindTool

    local ChildHandler = {}
    function ChildHandler.BindChildren(Character)
        if Data['Conns']['ChildAdded'] then Data['Conns']['ChildAdded']:Disconnect() end
        if Data['Conns']['ChildRemoved'] then Data['Conns']['ChildRemoved']:Disconnect() end

        local Children = Character:GetChildren()
        Data['Children'] = Children

        Data['Conns']['ChildAdded'] = Character.ChildAdded:Connect(function(Child)
            table.insert(Children, Child)
        end)

        Data['Conns']['ChildRemoved'] = Character.ChildRemoved:Connect(function(Child)
            local idx = table.find(Children, Child)
            if idx then
                table.remove(Children, idx)
            end
        end)

        Data['BindTool'](Character)
    end
    Data['BindChildren'] = ChildHandler.BindChildren

    local FlagsHandler = {}
    function FlagsHandler.BindFlags(Humanoid)
        if Data['Conns']['MoveDir'] then Data['Conns']['MoveDir']:Disconnect() end
        if Data['Conns']['StateChange'] then Data['Conns']['StateChange']:Disconnect() end

        local Objects = Data['Objects']
        Data['JumpActive'] = false
        Data['WalkActive'] = false
        Data['FallingActive'] = false
        Data['SwimmingActive'] = false

        Objects['WalkFlag'].Visible = false
        Objects['JumpFlag'].Visible = false
        Objects['SwimmingFlag'].Visible = false

        Data['Conns']['MoveDir'] = Humanoid:GetPropertyChangedSignal('MoveDirection'):Connect(function()
            local Walking = Humanoid.MoveDirection ~= Vector3.zero
            if Walking and not Data['WalkActive'] then
                Data['WalkActive'] = true
                if Data['JumpActive'] then
                    Objects['WalkFlag'].LayoutOrder = 2
                else
                    Objects['WalkFlag'].LayoutOrder = 1
                    Objects['JumpFlag'].LayoutOrder = 2
                end
                Objects['WalkFlag'].Visible = Flags["ESP_FlagsEnabled"] or false
            elseif not Walking and Data['WalkActive'] then
                Data['WalkActive'] = false
                Objects['WalkFlag'].Visible = false
                if Data['JumpActive'] then
                    Objects['JumpFlag'].LayoutOrder = 1
                end
            end
        end)

        Data['Conns']['StateChange'] = Humanoid.StateChanged:Connect(function(_, NewState)
            if NewState == Enum.HumanoidStateType.Freefall and not Data['JumpActive'] then
                Data['JumpActive'] = true
                if Data['WalkActive'] then
                    Objects['JumpFlag'].LayoutOrder = 2
                else
                    Objects['JumpFlag'].LayoutOrder = 1
                    Objects['WalkFlag'].LayoutOrder = 2
                end
                Objects['JumpFlag'].Visible = Flags["ESP_FlagsEnabled"] or false
            elseif NewState ~= Enum.HumanoidStateType.Jumping and Data['JumpActive'] then
                Data['JumpActive'] = false
                Objects['JumpFlag'].Visible = false
                if Data['WalkActive'] then
                    Objects['WalkFlag'].LayoutOrder = 1
                end
            end

            if NewState == Enum.HumanoidStateType.Swimming and not Data['SwimmingActive'] then
                Data['SwimmingActive'] = true
                Objects['SwimmingFlag'].Visible = Flags["ESP_FlagsEnabled"] or false
            elseif NewState ~= Enum.HumanoidStateType.Swimming and Data['SwimmingActive'] then
                Data['SwimmingActive'] = false
                Objects['SwimmingFlag'].Visible = false
            end
        end)
    end
    Data['BindFlags'] = FlagsHandler.BindFlags

    local CharacterHandler = {}
    function CharacterHandler.OnCharacter(Character)
        Data['Character'] = Character
        Data['RootPart'] = nil
        Data['Humanoid'] = nil
        Data['Children'] = nil
        Data['Alive'] = false
        Data['WalkActive'] = false
        Data['JumpActive'] = false
        Data['FallingActive'] = false
        Data['SwimmingActive'] = false

        if not Character or not Character.Parent then return end

        local RootPart = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart", 5)
        local Humanoid = Character:FindFirstChildOfClass("Humanoid") or Character:WaitForChild("Humanoid", 5)

        if not RootPart or not Humanoid then return end
        if not Character.Parent then return end

        Data['RootPart'] = RootPart
        Data['Humanoid'] = Humanoid

        Data['BindChildren'](Character)
        Data['BindHealth'](Humanoid)
        Data['BindFlags'](Humanoid)
    end

    if isPlayer then
        Data['Conns']['CharAdded'] = Target.CharacterAdded:Connect(function(Character)
            task.defer(CharacterHandler.OnCharacter, Character)
        end)
        if Target.Character and Target.Character.Parent then
            task.defer(CharacterHandler.OnCharacter, Target.Character)
        end
    else
        task.defer(CharacterHandler.OnCharacter, Target)
    end
end

function EspLibrary:RemoveTarget(Target)
    local Data = self['Cache'][Target]
    if not Data then return end

    for _, Conn in pairs(Data['Conns']) do
        Conn:Disconnect()
    end
    table.clear(Data['Conns'])

    if Data['Objects']['TracerOutline'] then
        Data['Objects']['TracerOutline']:Remove()
    end
    if Data['Objects']['TracerInline'] then
        Data['Objects']['TracerInline']:Remove()
    end
    if Data['Objects']['TargetHolder'] then
        Data['Objects']['TargetHolder']:Destroy()
    end
    table.clear(Data['Objects'])
    self['Cache'][Target] = nil
end

local espUpdateFunc = _LPH_NV(function(self, Target, Data)
local Objects = Data['Objects']

    if not Data['RootPart'] or not Data['Alive'] or not Data['Character'] or not Data['Character']:IsDescendantOf(workspace) then
        if Objects['TargetHolder'].Visible then
            Objects['TargetHolder'].Visible = false
        end
        if Objects['TracerOutline'] then Objects['TracerOutline'].Visible = false end
        if Objects['TracerInline'] then Objects['TracerInline'].Visible = false end
        return
    end

    local RootPos = Data['RootPart'].Position
    local Distance = math.floor((camera.CFrame.Position - RootPos).Magnitude)
    local MaxDist = Flags["ESP_MaxDistance"] or 3000

    if Distance > MaxDist then
        if Objects['TargetHolder'].Visible then
            Objects['TargetHolder'].Visible = false
        end
        if Objects['TracerOutline'] then Objects['TracerOutline'].Visible = false end
        if Objects['TracerInline'] then Objects['TracerInline'].Visible = false end
        return
    end

    local W, H, X, Y, OnScreen = self:CalculateBox(Data)
    if not OnScreen or not W then
        if Objects['TargetHolder'].Visible then
            Objects['TargetHolder'].Visible = false
        end
        if Objects['TracerOutline'] then Objects['TracerOutline'].Visible = false end
        if Objects['TracerInline'] then Objects['TracerInline'].Visible = false end
        return
    end

    local selectedFont = getESPFont()
    if Data._lastFont ~= selectedFont then
        Data._lastFont = selectedFont
        pcall(function()
            Objects['TargetName'].FontFace = selectedFont
            Objects['Distance'].FontFace = selectedFont
            Objects['HealthBarText'].FontFace = selectedFont
            Objects['ArmorBarText'].FontFace = selectedFont
            Objects['Weapon'].FontFace = selectedFont
            Objects['WalkFlag'].FontFace = selectedFont
            Objects['JumpFlag'].FontFace = selectedFont
            Objects['SwimmingFlag'].FontFace = selectedFont
        end)
    end

    W = math.floor(W)
    H = math.floor(H)
    X = math.floor(X)
    Y = math.floor(Y)

    Objects['TargetHolder'].Visible = true

    local DirtySizes = Data['LastW'] ~= W or Data['LastH'] ~= H
    local DirtyPosition = Data['LastX'] ~= X or Data['LastY'] ~= Y

    if DirtyPosition then
        Objects['TargetHolder'].Position = UDim2.fromOffset(X, Y)
        Data['LastX'] = X
        Data['LastY'] = Y
    end

    if DirtySizes then
        Objects['TargetHolder'].Size = UDim2.fromOffset(W, H)
        Objects['BoxOutlineHolder'].Size = UDim2.fromOffset(W + 2, H + 2)
        Objects['BoxOutlineHolder'].Position = UDim2.fromOffset(-1, -1)
        Objects['BoxInlineHolder'].Size = UDim2.fromOffset(W, H)
        Objects['BoxInlineHolder'].Position = UDim2.fromOffset(0, 0)
        Objects['BoxFill'].Size = UDim2.fromOffset(W, H)
        Objects['BoxFill'].Position = UDim2.fromOffset(0, 0)
        Objects['CornerHolder'].Size = UDim2.fromOffset(W + 2, H + 2)
        Data['LastW'] = W
        Data['LastH'] = H
    end

    local BoxEnabled = Flags["ESP_BoxEnabled"] or false
    if BoxEnabled then
        local BoxShape = Flags["ESP_BoxShape"] or "Full"
        local InlineColor = getColor("ESP_BoxInlineColor", Color3.fromRGB(255, 255, 255))
        local OutlineColor = getColor("ESP_BoxOutlineColor", Color3.fromRGB(0, 0, 0))
        local BoxThickness = 1

        if BoxShape == "Cornered" then
            Objects['BoxOutlineHolder'].Visible = false
            Objects['BoxInlineHolder'].Visible = false
            Objects['BoxFill'].Visible = false
            Objects['CornerHolder'].Visible = true

            for i = 1, 8 do
                local Line = Objects['Line_' .. i]
                local Stroke = Line:FindFirstChildOfClass('UIStroke')
                local LayoutEntry = CornerLayout[i]
                Line.Position = LayoutEntry[1]
                Line.Size = LayoutEntry[2]
                Line.AnchorPoint = LayoutEntry[3]
                Line.Rotation = LayoutEntry[4]
                Line.BackgroundColor3 = InlineColor
                if Stroke then
                    Stroke.Color = OutlineColor
                    Stroke.Thickness = BoxThickness
                end
                Line.Visible = true
            end
        else
            Objects['CornerHolder'].Visible = false
            for i = 1, 8 do
                Objects['Line_' .. i].Visible = false
            end
            Objects['BoxOutlineHolder'].Visible = true
            Objects['BoxInlineHolder'].Visible = true
            Objects['BoxOutline'].Thickness = BoxThickness
            Objects['BoxInline'].Thickness = BoxThickness
            Objects['BoxInlineGradient'].Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, InlineColor),
                ColorSequenceKeypoint.new(1, InlineColor)
            })
            Objects['BoxOutlineGradient'].Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, OutlineColor),
                ColorSequenceKeypoint.new(1, OutlineColor)
            })

            local FillEnabled = Flags["ESP_BoxFillEnabled"] or false
            if FillEnabled then
                Objects['BoxFill'].Visible = true
                local fillTrans1 = (Flags["ESP_BoxFillTrans1"] or 100) / 100
                local fillTrans2 = (Flags["ESP_BoxFillTrans2"] or 65) / 100
                local fillColor1 = getColor("ESP_BoxFillColor1", Color3.fromRGB(255, 255, 255))
                local fillColor2 = getColor("ESP_BoxFillColor2", Color3.fromRGB(255, 255, 255))
                Objects['BoxFillGradient'].Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, fillColor1),
                    ColorSequenceKeypoint.new(1, fillColor2)
                })
                Objects['BoxFillGradient'].Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, fillTrans1),
                    NumberSequenceKeypoint.new(1, fillTrans2)
                })
                if Flags["ESP_BoxFillAnim"] then
                    Objects['BoxFillGradient'].Offset = Vector2.new(0, (math.sin(tick() * (Flags["ESP_BoxFillAnimSpeed"] or 2)) / 2))
                else
                    Objects['BoxFillGradient'].Offset = Vector2.new(0, 0)
                end
                if Flags["ESP_BoxFillSpin"] then
                    Objects['BoxFillGradient'].Rotation = (tick() * (Flags["ESP_BoxFillSpinSpeed"] or 100)) % 360
                else
                    Objects['BoxFillGradient'].Rotation = 90
                end
            else
                Objects['BoxFill'].Visible = false
            end
        end
    else
        Objects['BoxOutlineHolder'].Visible = false
        Objects['BoxInlineHolder'].Visible = false
        Objects['BoxFill'].Visible = false
        Objects['CornerHolder'].Visible = false
        for i = 1, 8 do
            Objects['Line_' .. i].Visible = false
        end
    end

    local NameEnabled = Flags["ESP_NameEnabled"] or false
    local espTextSize = Flags["ESP_TextSize"] or 15
    local espTextOutline = Flags["ESP_TextOutline"] ~= false
    if NameEnabled then
        Objects['TargetName'].Visible = true
        local namePos = Flags["ESP_TextPos"] or "Top"
        local nameHolder = Objects[namePos .. "TextHolder"]
        if nameHolder and Objects["TargetName"].Parent ~= nameHolder then
            Objects["TargetName"].Parent = nameHolder
        end

        local nameStr = ""
        if Data.IsPlayer then
            local nameType = Flags["ESP_NameType"] or "Display Name"
            if nameType == "Display Name" then
                nameStr = Target.DisplayName
            elseif nameType == "Username" then
                nameStr = Target.Name
            else
                nameStr = Target.DisplayName .. " (@" .. Target.Name .. ")"
            end
        else
            nameStr = Target.Name
        end

        if Data['LastDisplayName'] ~= nameStr then
            Objects['TargetName'].Text = nameStr
            Data['LastDisplayName'] = nameStr
        end

        Objects['TargetName'].TextColor3 = getColor("ESP_NameInlineColor", Color3.fromRGB(255, 255, 255))
        Objects['TargetName'].TextSize = espTextSize
        local stroke = Objects['TargetName']:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Color = getColor("ESP_NameOutlineColor", Color3.fromRGB(0, 0, 0))
            stroke.Enabled = espTextOutline
        end
    else
        Objects['TargetName'].Visible = false
    end

    local DistEnabled = Flags["ESP_DistanceEnabled"] or false
    if DistEnabled then
        Objects['Distance'].Visible = true

        local distPos = Flags["ESP_TextPos"] or "Top"
        local distHolder = Objects[distPos .. "TextHolder"]
        if distHolder and Objects["Distance"].Parent ~= distHolder then
            Objects["Distance"].Parent = distHolder
        end

        local unit = Flags["ESP_DistanceType"] or "Studs"
        local distVal = Distance
        local suffix = "st"
        if unit == "Meters" then
            distVal = math.floor(Distance * 0.3048)
            suffix = "m"
        end

        if Data['LastDist'] ~= distVal then
            Objects['Distance'].Text = string.format("%d%s", distVal, suffix)
            Data['LastDist'] = distVal
        end

        Objects['Distance'].TextColor3 = getColor("ESP_DistanceInlineColor", Color3.fromRGB(255, 255, 255))
        Objects['Distance'].TextSize = espTextSize
        local stroke = Objects['Distance']:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Color = getColor("ESP_DistanceOutlineColor", Color3.fromRGB(0, 0, 0))
            stroke.Enabled = espTextOutline
        end
    else
        Objects['Distance'].Visible = false
    end

    local HealthBarEnabled = Flags["ESP_HealthBarEnabled"] or false
    if HealthBarEnabled then
        Objects['LeftBarHolder'].Visible = true
        Objects['HealthBarOutline'].Visible = true
        local Health = Data['Health'] or 0
        local MaxHealth = Data['MaxHealth'] or 100
        local Ratio = math.clamp(Health / MaxHealth, 0, 1)

        if Data['LastRatio'] ~= Ratio then
            Objects['HealthBar'].Size = UDim2.new(1, 0, Ratio, 0)
            Data['LastRatio'] = Ratio
        end

        local stroke = Objects['HealthBarOutline']:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Color = getColor("ESP_HealthBarOutlineColor", Color3.fromRGB(0, 0, 0))
        end

        local GradEnabled = Flags["ESP_HealthBarGradientEnabled"] or false
        if GradEnabled then
            local gTop = getColor("ESP_HealthBarTopColor", Color3.fromRGB(0, 255, 0))
            local gMid = getColor("ESP_HealthBarMidColor", Color3.fromRGB(255, 170, 0))
            local gBot = getColor("ESP_HealthBarBotColor", Color3.fromRGB(255, 0, 0))
            Objects['HealthBarGradient'].Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, gTop),
                ColorSequenceKeypoint.new(0.5, gMid),
                ColorSequenceKeypoint.new(1, gBot),
            })
        else
            local flatClr = getColor("ESP_HealthBarInlineColor", Color3.fromRGB(0, 255, 0))
            Objects['HealthBarGradient'].Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, flatClr),
                ColorSequenceKeypoint.new(1, flatClr)
            })
        end

        local HealthTextEnabled = Flags["ESP_HealthTextEnabled"] or false
        if HealthTextEnabled then
            Objects['HealthBarText'].Visible = true
            local flooredH = math.floor(Health)
            if Data['LastHealthFloor'] ~= flooredH then
                Objects['HealthBarText'].Text = string.format("%d", flooredH)
                Objects['HealthBarText'].Position = UDim2.new(1, -10, 1 - Ratio, 1)
                Data['LastHealthFloor'] = flooredH
            end
            Objects['HealthBarText'].TextColor3 = getColor("ESP_HealthTextInlineColor", Color3.fromRGB(255, 255, 255))
            local textStroke = Objects['HealthBarText']:FindFirstChildOfClass("UIStroke")
            if textStroke then
                textStroke.Color = getColor("ESP_HealthTextOutlineColor", Color3.fromRGB(0, 0, 0))
            end
        else
            Objects['HealthBarText'].Visible = false
        end
    else
        Objects['HealthBarOutline'].Visible = false
        Objects['HealthBarText'].Visible = false
        if not (Flags["ESP_ArmorBarEnabled"] or false) then
            Objects['LeftBarHolder'].Visible = false
        end
    end

    local ArmorBarEnabled = Flags["ESP_ArmorBarEnabled"] or false
    if ArmorBarEnabled then
        Objects['BottomBarHolder'].Visible = true
        Objects['ArmorBarOutline'].Visible = true

        local Ratio = math.clamp(Data['Armor'] / Data['MaxArmor'], 0, 1)
        if Data['LastArmorRatio'] ~= Ratio then
            Objects['ArmorBar'].Size = UDim2.new(Ratio, 0, 1, 0)
            Data['LastArmorRatio'] = Ratio
        end

        local stroke = Objects['ArmorBarOutline']:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Color = getColor("ESP_ArmorBarOutlineColor", Color3.fromRGB(0, 0, 0))
        end
        Objects['ArmorBar'].BackgroundColor3 = getColor("ESP_ArmorBarInlineColor", Color3.fromRGB(255, 255, 255))
    else
        Objects['ArmorBarOutline'].Visible = false
        Objects['ArmorBarText'].Visible = false
        Objects['BottomBarHolder'].Visible = false
    end

    local ToolIconEnabled = Flags["ESP_ToolIconEnabled"] or false
    if ToolIconEnabled then
        local toolInst = Data['CurrentToolInstance']
        if toolInst then
            local texId = toolInst.TextureId
            if texId and texId ~= "" then
                Objects['ToolIcon'].Image = texId
                Objects['ToolIcon'].Visible = true
                Objects['ToolIcon'].ImageColor3 = getColor("ESP_ToolIconColor", Color3.fromRGB(255, 255, 255))
                local size = Flags["ESP_ToolIconSize"] or 16
                Objects['ToolIcon'].Size = UDim2.new(0, size, 0, size)
                local offX = Flags["ESP_ToolIconOffsetX"] or 0
                local offY = Flags["ESP_ToolIconOffsetY"] or 0
                Objects['ToolIcon'].Position = UDim2.new(0.5, -size/2 + offX, 0, offY)
                Objects['ToolIcon'].ImageTransparency = (Flags["ESP_ToolIconTransparency"] or 0) / 100
                local istroke = Objects['ToolIcon']:FindFirstChildOfClass("UIStroke")
                if istroke then
                    istroke.Enabled = false 
                end
            else
                Objects['ToolIcon'].Visible = false
            end
        else
            Objects['ToolIcon'].Visible = false
        end
    else
        Objects['ToolIcon'].Visible = false
    end

    local WeaponEnabled = Flags["ESP_WeaponEnabled"] or false
    if WeaponEnabled then
        Objects['Weapon'].Visible = true
        local currentTool = Data['CurrentTool'] or "none"
        if Data['LastWeapon'] ~= currentTool then
            Objects['Weapon'].Text = currentTool
            Data['LastWeapon'] = currentTool
        end
        Objects['Weapon'].TextColor3 = getColor("ESP_WeaponColor", Color3.fromRGB(255, 255, 255))
        Objects['Weapon'].TextSize = espTextSize
        local wstroke = Objects['Weapon']:FindFirstChildOfClass("UIStroke")
        if wstroke then wstroke.Enabled = espTextOutline end
    else
        Objects['Weapon'].Visible = false
    end

    local FlagsEnabled = Flags["ESP_FlagsEnabled"] or false
    if FlagsEnabled then
        local Humanoid = Data['Humanoid']
        if Humanoid then
            local Walking = Humanoid.MoveDirection ~= Vector3.zero
            local Swimming = Humanoid:GetState() == Enum.HumanoidStateType.Swimming
            local Freefall = Humanoid:GetState() == Enum.HumanoidStateType.Freefall
            Objects['WalkFlag'].Visible = Walking
            Objects['JumpFlag'].Visible = Freefall
            Objects['SwimmingFlag'].Visible = Swimming
        else
            Objects['WalkFlag'].Visible = false
            Objects['JumpFlag'].Visible = false
            Objects['SwimmingFlag'].Visible = false
        end
        Objects['WalkFlag'].TextColor3 = getColor("ESP_FlagsColor", Color3.fromRGB(255, 0, 0))
        Objects['JumpFlag'].TextColor3 = getColor("ESP_FlagsColor", Color3.fromRGB(144, 238, 144))
        Objects['SwimmingFlag'].TextColor3 = getColor("ESP_FlagsColor", Color3.fromRGB(0, 255, 255))
    else
        Objects['WalkFlag'].Visible = false
        Objects['JumpFlag'].Visible = false
        Objects['SwimmingFlag'].Visible = false
    end

    local TracerEnabled = Flags["ESP_TracerEnabled"] or false
    if TracerEnabled then
        local origin = Flags["ESP_TracerOrigin"] or "Bottom"
        local viewport = camera.ViewportSize
        local fromPos
        if origin == "Bottom" then
            fromPos = Vector2.new(viewport.X * 0.5, viewport.Y)
        elseif origin == "Top" then
            fromPos = Vector2.new(viewport.X * 0.5, 0)
        elseif origin == "Center" then
            fromPos = Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)
        else
            local mousePos = getMousePos()
            fromPos = Vector2.new(mousePos.X, mousePos.Y)
        end
        local toPos = Vector2.new(X + W * 0.5, Y + H * 0.5)
        local tracerColor = getColor("ESP_TracerColor", Color3.fromRGB(255, 255, 255))
        local neonAmount = (Flags["ESP_TracerNeonAmount"] or 0) / 100

        Objects['TracerOutline'].From = fromPos
        Objects['TracerOutline'].To = toPos
        Objects['TracerOutline'].Color = Color3.fromRGB(0, 0, 0)
        Objects['TracerOutline'].Transparency = neonAmount > 0 and math.max(0, 1 - neonAmount * 0.3) or 1
        Objects['TracerOutline'].Visible = true

        Objects['TracerInline'].From = fromPos
        Objects['TracerInline'].To = toPos
        Objects['TracerInline'].Color = tracerColor
        Objects['TracerInline'].Transparency = neonAmount > 0 and math.max(0, 1 - neonAmount * 0.5) or 1
        Objects['TracerInline'].Visible = true
    else
        if Objects['TracerOutline'] then Objects['TracerOutline'].Visible = false end
        if Objects['TracerInline'] then Objects['TracerInline'].Visible = false end
    end
end)
EspLibrary.Update = espUpdateFunc

local shouldShowESPFunc = (function(Target)
    if not Flags["ESP_Enabled"] then return false end
    local showOn = Flags["ESP_ShowOn"] or {}
    local isPlayer = Target:IsA("Player")
    if isPlayer then
        if Target == lp then
            return hasCheck(showOn, "Self")
        end
        local isTeammate = false
        if lp.Team ~= nil and Target.Team == lp.Team then
            isTeammate = true
        end
        if lp.Neutral or Target.Neutral or (lp.Team and (lp.Team.Name == "Neutral" or lp.Team.Name == "Spectators" or lp.Team.Name == "Spectator")) or (Target.Team and (Target.Team.Name == "Neutral" or Target.Team.Name == "Spectators" or Target.Team.Name == "Spectator")) then
            isTeammate = false
        end

        if isTeammate then
            return hasCheck(showOn, "Team")
        else
            return hasCheck(showOn, "Enemy")
        end
    else
        return hasCheck(showOn, "NPC")
    end
end)
shouldShowESP = shouldShowESPFunc

_espBotScanClock = 0
EspLibrary:CreateThreads('Renderer', RunService.RenderStepped, _LPH_NV(function()
    if not Flags["ESP_Enabled"] then
        if not _espDisabledCleared then
            _espDisabledCleared = true
            for _, Data in pairs(EspLibrary['Cache']) do
                if Data['Objects']['TargetHolder'] and Data['Objects']['TargetHolder'].Visible then
                    Data['Objects']['TargetHolder'].Visible = false
                end
                if Data['Objects']['TracerOutline'] then Data['Objects']['TracerOutline'].Visible = false end
                if Data['Objects']['TracerInline'] then Data['Objects']['TracerInline'].Visible = false end
            end
        end
        return
    end
    _espDisabledCleared = false

    local now = os.clock()
    if now - _espBotScanClock >= 1 then
        _espBotScanClock = now
        local botsFolder = workspace:FindFirstChild("Bots")
        if botsFolder then
            for _, bot in ipairs(botsFolder:GetChildren()) do
                if bot:IsA("Model") and bot:FindFirstChildOfClass("Humanoid") then
                    EspLibrary:AddTarget(bot)
                end
            end
        end
    end

    for Target, Data in pairs(EspLibrary['Cache']) do
        if shouldShowESP(Target) then
            EspLibrary:Update(Target, Data)
        else
            if Data['Objects']['TargetHolder'] and Data['Objects']['TargetHolder'].Visible then
                Data['Objects']['TargetHolder'].Visible = false
            end
            if Data['Objects']['TracerOutline'] then Data['Objects']['TracerOutline'].Visible = false end
            if Data['Objects']['TracerInline'] then Data['Objects']['TracerInline'].Visible = false end
        end
    end
end))

for _, Player in ipairs(Players:GetPlayers()) do
    EspLibrary:AddTarget(Player)
end

EspLibrary:CreateThreads('PlayerAdded', Players.PlayerAdded, function(Player)
    EspLibrary:AddTarget(Player)
end)

EspLibrary:CreateThreads('PlayerRemoving', Players.PlayerRemoving, function(Player)
    EspLibrary:RemoveTarget(Player)
end)

function EspLibrary:Unload()
    local targets = {}
    for Target in pairs(self['Cache']) do
        table.insert(targets, Target)
    end
    for _, Target in ipairs(targets) do
        self:RemoveTarget(Target)
    end
    for _, Conn in pairs(self['Connections']) do
        pcall(function() Conn:Disconnect() end)
    end
    table.clear(self['Connections'])
    for _, Conn in pairs(self['Threads']) do
        pcall(function() Conn:Disconnect() end)
    end
    table.clear(self['Threads'])
    if self['Holder'] then
        self['Holder']:Destroy()
        self['Holder'] = nil
    end
    table.clear(self['Cache'])
end



local Window = Library:Window({
    Logo = "77218680285262",
    FadeTime = 0,
    Size = UDim2.new(0, 700, 0, 550),
})

if not Window then
    hideLoadingNotification()
    return
end

local Watermark = Library.Watermark and Library:Watermark("alternate")
local KeybindList = Library.KeybindList and Library:KeybindList()

if not Watermark or not KeybindList then
    warn("UI overlay creation failed.")
    -- Still show the window even if overlays failed
end

if KeybindList and KeybindList.SetVisibility then
    pcall(function() KeybindList:SetVisibility(true) end)
end

local CombatPage = Window:Page({Name = "Combat", Icon = "rbxassetid://15453335745", SubPages = true})
local PlayerPage = Window:Page({Name = "Player", Icon = "rbxassetid://15453359751", SubPages = true}) -- Enabled Subpages
local VisualsPage = Window:Page({Name = "Visuals", Icon = "rbxassetid://15453344494", SubPages = true})
local PlayersPage = Window:Page({Name = "Players", Icon = "rbxassetid://15453354931", Columns = 2})
local SettingsPage = Window:Page({Name = "Settings", Icon = "rbxassetid://15453349637", Columns = 2})
local Playerlist
local AimbotSubPage = CombatPage:SubPage({Name = "Aimbot", Columns = 2})
local SilentAimSubPage = CombatPage:SubPage({Name = "Silent Aim", Columns = 2})


local MovementSubPage = PlayerPage:SubPage({Name = "Movement", Columns = 2})

local ESPSubPage = VisualsPage:SubPage({Name = "ESP", Columns = 2})
local ChamsSubPage = VisualsPage:SubPage({Name = "Chams", Columns = 2})
local WorldSubPage = VisualsPage:SubPage({Name = "World", Columns = 2})
local SkinsSubPage = (isDaTrack or isHC) and VisualsPage:SubPage({Name = "Skins", Columns = 2}) or nil
SkinsTab1 = nil
SkinsTab2 = nil

local function hasKorblox(player)
    local char = player.Character
    if not char then return false end
    -- Check for Korblox Left Leg or Korblox items
    if char:FindFirstChild("Left Leg") and char["Left Leg"]:FindFirstChild("KorbloxGeneral") then return true end
    for _, item in ipairs(char:GetChildren()) do
        if item.Name:lower():find("korblox") then return true end
        for _, child in ipairs(item:GetChildren()) do
            if child.Name:lower():find("korblox") then return true end
        end
    end
    return false
end

local function hasHeadless(player)
    local char = player.Character
    if not char then return false end
    -- Headless Horseman: Head is invisible/removed
    local head = char:FindFirstChild("Head")
    if not head then return false end
    -- Check if head is scaled to 0 or has Headless texture
    if head.Size.X < 0.5 or head.Size.Y < 0.5 or head.Size.Z < 0.5 then return true end
    if head:FindFirstChild("face") and head.face.Texture == "" then return true end
    -- Check for specific headless indicators
    for _, item in ipairs(char:GetChildren()) do
        if item.Name:lower():find("headless") then return true end
    end
    return false
end

local function updatePlayerTags(player)
    if not Playerlist then return end
    local tags = {}
    if _lockedTargets and _lockedTargets[player] then table.insert(tags, "[T]") end
    if _plWhitelistLocal and _plWhitelistLocal[player] then table.insert(tags, "[W]") end
    if _playerIgnoreWallCheck and _playerIgnoreWallCheck[player] then table.insert(tags, "[IW]") end
    if _playerIgnoreDeadCheck and _playerIgnoreDeadCheck[player] then table.insert(tags, "[ID]") end
    if _playerIgnoreTeamCheck and _playerIgnoreTeamCheck[player] then table.insert(tags, "[IT]") end
    if _spectatingPlayer == player then table.insert(tags, "[S]") end
    -- Korblox/Headless detection
    if hasKorblox(player) then table.insert(tags, "[Korblox]") end
    if hasHeadless(player) then table.insert(tags, "[Headless]") end
    local isAlternate = false
    local userSync = _userSyncPlayers[player.Name]
    if userSync then
        if userSync.Enabled then isAlternate = true end
        if userSync.SkinSummary then
            table.insert(tags, "[" .. tostring(userSync.SkinSummary) .. "]")
        end
    end
    local tagsStr = table.concat(tags, " ")
    Playerlist:UpdatePlayerTags(player.Name, tagsStr, isAlternate)
end

Playerlist = PlayersPage:Playerlist({
    Callback = function(player, action)
        if player == game.Players.LocalPlayer then
            return -- Ignore options on self
        end
        if not player then 
            _selectedPlayer = nil
            return 
        end
        _selectedPlayer = player
        if action == "Select" then
            local isTarget = (_lockedTargets and _lockedTargets[player] == true)
            local isWhitelisted = (_plWhitelistLocal and _plWhitelistLocal[player] == true)
            local isIgnoreWall = (_playerIgnoreWallCheck and _playerIgnoreWallCheck[player] == true)
            local isIgnoreDead = (_playerIgnoreDeadCheck and _playerIgnoreDeadCheck[player] == true)
            local isIgnoreTeam = (_playerIgnoreTeamCheck and _playerIgnoreTeamCheck[player] == true)
            local isSpectating = (_spectatingPlayer == player)
            Playerlist:SetButtonState("Target", isTarget)
            Playerlist:SetButtonState("Whitelist", isWhitelisted)
            Playerlist:SetButtonState("Ignore Wall", isIgnoreWall)
            Playerlist:SetButtonState("Ignore Dead", isIgnoreDead)
            Playerlist:SetButtonState("Ignore Team", isIgnoreTeam)
            Playerlist:SetButtonState("Spectate", isSpectating)
        elseif action == "Target" then
            if not _lockedTargets then _lockedTargets = {} end
            local wasTarget = _lockedTargets[player]
            local oldTargets = {}
            for targetPlayer, _ in pairs(_lockedTargets) do
                if targetPlayer ~= player then
                    table.insert(oldTargets, targetPlayer)
                end
                _lockedTargets[targetPlayer] = nil
            end
            if not wasTarget then
                _lockedTargets[player] = true
                if player.Character then
                    lockedAimTarget = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChildOfClass("HumanoidRootPart")
                end
            else
                lockedAimTarget = nil
            end
            Playerlist:SetButtonState("Target", _lockedTargets[player] == true)
            updatePlayerTags(player)
            for _, oldPlayer in ipairs(oldTargets) do
                updatePlayerTags(oldPlayer)
            end
            if not _lockedTargets[player] then
                _lastAimbotTargetPlayer = nil
            end
        elseif action == "Whitelist" then
            if not _plWhitelistLocal then _plWhitelistLocal = {} end
            if _plWhitelistLocal[player] then
                _plWhitelistLocal[player] = nil
            else
                _plWhitelistLocal[player] = true
            end
            Playerlist:SetButtonState("Whitelist", _plWhitelistLocal[player] == true)
            updatePlayerTags(player)
        elseif action == "Ignore Wall" then
            if not _playerIgnoreWallCheck then _playerIgnoreWallCheck = {} end
            if _playerIgnoreWallCheck[player] then
                _playerIgnoreWallCheck[player] = nil
            else
                _playerIgnoreWallCheck[player] = true
            end
            Playerlist:SetButtonState("Ignore Wall", _playerIgnoreWallCheck[player] == true)
            updatePlayerTags(player)
        elseif action == "Ignore Dead" then
            if not _playerIgnoreDeadCheck then _playerIgnoreDeadCheck = {} end
            if _playerIgnoreDeadCheck[player] then
                _playerIgnoreDeadCheck[player] = nil
            else
                _playerIgnoreDeadCheck[player] = true
            end
            Playerlist:SetButtonState("Ignore Dead", _playerIgnoreDeadCheck[player] == true)
            updatePlayerTags(player)
        elseif action == "Ignore Team" then
            if not _playerIgnoreTeamCheck then _playerIgnoreTeamCheck = {} end
            if _playerIgnoreTeamCheck[player] then
                _playerIgnoreTeamCheck[player] = nil
            else
                _playerIgnoreTeamCheck[player] = true
            end
            Playerlist:SetButtonState("Ignore Team", _playerIgnoreTeamCheck[player] == true)
            updatePlayerTags(player)
        elseif action == "Spectate" then
            if _spectatingPlayer == player then
                _spectatingPlayer = nil
                local myHum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
                if myHum then workspace.CurrentCamera.CameraSubject = myHum end
            else
                _spectatingPlayer = player
                local targetChar = player.Character
                local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
                if targetHum and targetHum.Health > 0 then
                    workspace.CurrentCamera.CameraSubject = targetHum
                end
            end
            Playerlist:SetButtonState("Spectate", _spectatingPlayer == player)
            updatePlayerTags(player)
        elseif action == "Teleport" then
            pcall(function()
                local localChar = game.Players.LocalPlayer.Character
                local targetChar = player.Character
                if localChar and targetChar then
                    local localHrp = localChar:FindFirstChild("HumanoidRootPart")
                    local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
                    if localHrp and targetHrp then
                        localHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 3)
                    end
                end
            end)
        end
    end
})

local SubTab_Aimbot = AimbotSubPage
local SubTab_Silent = SilentAimSubPage
local SubTab_Aimbot = AimbotSubPage
local SubTab_Silent = SilentAimSubPage
local SubTab_Arsenal = ArsenalSubPage or Tab_Misc
local SubTab_AimPlus = AimbotSubPage
local SubTab_ESP = ESPSubPage
local SubTab_Chams = ChamsSubPage
local SubTab_World = WorldSubPage
local SubTab_Skins = SkinsSubPage
local SubTab_Misc = MovementSubPage
local SubTab_HUD = MovementSubPage
local SubTab_Players = PlayersPage
local SubTab_Settings = SettingsPage

Flags = Library.Flags

local _sectionCache = {}

local _dependencyUpdates = {}
local function triggerDependencies()
    for _, fn in ipairs(_dependencyUpdates) do
        pcall(fn)
    end
end

local function registerDependency(w, opts)
    if opts and opts.Dependency then
        local dep = opts.Dependency
        local flag = dep.Flag
        local expectedValue = dep.Value
        if expectedValue == nil then expectedValue = true end
        local function updateVisibility()
            local val = Flags[flag]
            if type(val) == "table" then
                if val.Toggled ~= nil then
                    val = val.Toggled
                elseif val.active ~= nil then
                    val = val.active
                end
            end
            if val == nil then val = false end
            local isVisible = (val == expectedValue)
            w:SetVisibility(isVisible)
        end
        table.insert(_dependencyUpdates, updateVisibility)
        task.spawn(function()
            task.wait(0.1)
            updateVisibility()
        end)
    end
end

wrapSection = function(secName, side)
    side = side or "Left"
    if type(side) == "string" then side = side == "Left" and 1 or 2 end

    local mapping = {
        ["Aimbot"] = {tab = SubTab_Aimbot, side = 1},
        ["Silent"] = {tab = SubTab_Silent, side = 1},
        ["Silent Settings"] = {tab = SubTab_Silent, side = 2},
        ["Arsenal"] = {tab = isArsenal and SubTab_Arsenal or nil, side = 1},
        ["Arsenal Settings"] = {tab = isArsenal and SubTab_Arsenal or nil, side = 2},
        ["Main"] = {tab = SubTab_Aimbot, side = 2},
        ["Aimbot+"] = {tab = SubTab_AimPlus, side = 2},
        ["AimbotSettings"] = {tab = SubTab_AimPlus, side = 1},
        ["ESP"] = {tab = SubTab_ESP, side = 1},
        ["ESP Settings"] = {tab = SubTab_ESP, side = 2},
        ["Chams"] = {tab = SubTab_Chams, side = 1},
        ["Chams Settings"] = {tab = SubTab_Chams, side = 2},
        ["Skins"] = {tab = SubTab_Skins, side = 1},
        ["Weapon Skins"] = {tab = SubTab_Skins, side = 1},
        ["Effects & Customization"] = {tab = SubTab_Skins, side = 2},
        ["Lighting"] = {tab = SubTab_World, side = 1},
        ["Weather"] = {tab = SubTab_World, side = 1},
        ["Skybox"] = {tab = SubTab_World, side = 2},
        ["Materials"] = {tab = SubTab_World, side = 2},
        ["Misc"] = {tab = SubTab_Misc, side = 1},
        ["Movement"] = {tab = SubTab_Misc, side = 1},
        ["MiscRight"] = {tab = SubTab_Misc, side = 2},
        ["All Players"] = {tab = SubTab_Players, side = 1},
        ["Player List"] = {tab = SubTab_Players, side = 1},
        ["Player Info"] = {tab = SubTab_Players, side = 2},
        ["Actions"] = {tab = SubTab_Players, side = 2},
        ["Configs"] = {tab = SubTab_Settings, side = 1},
        ["Settings"] = {tab = SubTab_Settings, side = 2},
        ["Menu"] = {tab = SubTab_Settings, side = 2},
        ["Notifications"] = {tab = SubTab_Settings, side = 2},
        ["Themes"] = {tab = SubTab_Settings, side = 2},
        ["Theme"] = {tab = SubTab_Settings, side = 2},
    }

    local m = mapping[secName] or {tab = Tab_Misc, side = side}
    local cacheKey = secName .. tostring(m.side)
    if _sectionCache[cacheKey] then return _sectionCache[cacheKey] end

    if not m.tab or type(m.tab.Section) ~= "function" then
        local fallback = { SetVisibility = function() end }
        function fallback:Toggle() return self end
        function fallback:Slider() return self end
        function fallback:Dropdown() return self end
        function fallback:Colorpicker() return self end
        function fallback:Keybind() return self end
        function fallback:Button() return self end
        function fallback:Label() return self end
        function fallback:Textbox() return self end
        _sectionCache[cacheKey] = fallback
        return fallback
    end

    local sec = m.tab:Section({ Name = secName, Side = m.side })
    local wrapper = { items = sec }
    function wrapper:SetVisibility(state)
        pcall(function()
            if sec and sec.SetVisibility then
                sec:SetVisibility(state)
                return
            end

            local ok, sectionInstance = pcall(function()
                if sec and type(sec.Items) == "table" then
                    local section = sec.Items["Section"]
                    if section and type(section) == "table" then
                        return section.Instance
                    end
                end
                if sec then
                    return sec.Instance
                end
                return nil
            end)

            if ok and sectionInstance and type(sectionInstance) == "userdata" then
                sectionInstance.Visible = state
            end
        end)
    end

    function wrapper:Toggle(opts)
        if opts.Flag and Flags[opts.Flag] == nil then
            Flags[opts.Flag] = opts.Default or false
        end
        local userCallback = opts.Callback
        opts.Callback = function(val)
            if opts.Flag then Flags[opts.Flag] = val end
            if userCallback then pcall(userCallback, val) end
            triggerDependencies()
        end

        local ok, t = pcall(function()
            return sec:Toggle({
                Name = opts.Name,
                Flag = opts.Flag,
                Default = opts.Default,
                Callback = opts.Callback,
                Tooltip = opts.Tooltip and { Name = opts.Name, Description = opts.Tooltip } or nil
            })
        end)
        if not ok or not t then
            return { Colorpicker = function(s, o) return s or {} end, Keybind = function(s, o) return s or {} end, SetVisibility = function() end, OnChange = function(s, f) end }
        end
        local w = {}
        w.__ui = t
        w.OnChange = function(s, fn)
        end
        function w:SetVisibility(state) pcall(function() if t.SetVisibility then t:SetVisibility(state) end end) end
        function w:Keybind(kopts)
            local ok, err = pcall(function()
                local flag = kopts.Flag
                local defaultKey = kopts.Key or kopts.Default
                local mode = kopts.Mode or "Toggle"
                if flag then
                    Flags[flag] = { Key = defaultKey, key = defaultKey, mode = mode, Toggled = false, active = false }
                end
                local userKoptsCallback = kopts.Callback
                kopts.Callback = function(state)
                    if flag and Flags[flag] then
                        Flags[flag].Toggled = state
                        Flags[flag].active = state
                    end
                    if userKoptsCallback then pcall(userKoptsCallback, state) end
                    triggerDependencies()
                end
                local kb = t:Keybind({ Flag = flag, Default = defaultKey, Mode = mode, Callback = kopts.Callback })
            end)
            if not ok then warn("w:Keybind error: " .. tostring(err)) end
            return w
        end
        function w:Colorpicker(copts)
            local ok, err = pcall(function()
                local userCoptsCallback = copts.Callback
                copts.Callback = function(val)
                    if copts.Flag then Flags[copts.Flag] = val end
                    if userCoptsCallback then pcall(userCoptsCallback, val) end
                    triggerDependencies()
                end
                local cp = t:Colorpicker({ Name = copts.Name or "Color", Flag = copts.Flag, Default = copts.Default or copts.color, Alpha = copts.Alpha or 0, Callback = copts.Callback })
            end)
            if not ok then warn("w:Colorpicker error: " .. tostring(err)) end
            return w
        end
        registerDependency(w, opts)
        return w
    end

    function wrapper:Slider(opts)
        local userCallback = opts.Callback
        opts.Callback = function(val)
            if opts.Flag then Flags[opts.Flag] = val end
            if userCallback then pcall(userCallback, val) end
            triggerDependencies()
        end
        local s = sec:Slider({
            Name = opts.Name,
            Flag = opts.Flag,
            Min = opts.Min,
            Max = opts.Max,
            Default = opts.Default,
            Suffix = opts.Suffix,
            Callback = opts.Callback,
        })
        local w = {}
        w.__ui = s
        function w:SetVisibility(state) pcall(function() if s.SetVisibility then s:SetVisibility(state) end end) end
        registerDependency(w, opts)
        return w
    end

    function wrapper:Dropdown(opts)
        local userCallback = opts.Callback
        opts.Callback = function(val)
            if opts.Flag then Flags[opts.Flag] = val end
            if userCallback then pcall(userCallback, val) end
            triggerDependencies()
        end
        local items = opts.Items or opts.Content or opts.Options or {}
        local d = sec:Dropdown({
            Name = opts.Name,
            Flag = opts.Flag,
            Content = items,
            Items = items,
            Default = opts.Default,
            Multi = opts.Multi,
            Callback = opts.Callback
        })
        local w = {}
        w.__ui = d
        function w:SetVisibility(state) pcall(function() if d.SetVisibility then d:SetVisibility(state) end end) end
        function w:Refresh(newItems) pcall(function() if d.Refresh then d:Refresh(newItems) end end) end
        registerDependency(w, opts)
        return w
    end

    function wrapper:Colorpicker(opts)
        local lbl = sec:Label(opts.Name or "Colorpicker")
        local userCallback = opts.Callback
        opts.Callback = function(val)
            if opts.Flag then Flags[opts.Flag] = val end
            if userCallback then pcall(userCallback, val) end
            triggerDependencies()
        end
        local c = lbl:Colorpicker({
            Name = opts.Name or "Colorpicker",
            Flag = opts.Flag,
            Default = opts.Default or opts.color,
            Alpha = opts.Alpha or 0,
            Callback = opts.Callback
        })
        local w = {}
        w.__ui = c
        function w:SetVisibility(state) pcall(function() if c.SetVisibility then c:SetVisibility(state) end; if lbl.SetVisibility then lbl:SetVisibility(state) end end) end
        registerDependency(w, opts)
        return w
    end

    function wrapper:Keybind(opts)
        local k = sec:Keybind({
            Name = opts.Name,
            Flag = opts.Flag,
            Default = opts.Key or opts.Default,
            Mode = opts.Mode or "Toggle",
            Callback = opts.Callback
        })
        local w = {}
        w.__ui = k
        local oldCallback = k.Callback
        k.Callback = function(val)
            if oldCallback then pcall(oldCallback, val) end
            triggerDependencies()
        end
        function w:SetVisibility(state) pcall(function() if k.SetVisibility then k:SetVisibility(state) end end) end
        registerDependency(w, opts)
        return w
    end

    function wrapper:Button(opts)
        local b = sec:Button(opts)
        local w = {}
        w.__ui = b
        function w:SetVisibility(state) pcall(function() if b.SetVisibility then b:SetVisibility(state) end end) end
        w.items = w
        registerDependency(w, opts)
        return w
    end

    function wrapper:Label(opts)
        local l = sec:Label(opts.Name)
        local w = {}
        w.__ui = l
        function w:SetVisibility(state) pcall(function() if l.SetVisibility then l:SetVisibility(state) end end) end
        function w:Keybind(kopts) return w end
        function w.set(text) pcall(function() if l.Set then l:Set(text) end end) end
        registerDependency(w, opts)
        return w
    end

    function wrapper:Textbox(opts)
        local userCallback = opts.Callback
        opts.Callback = function(val)
            if opts.Flag then Flags[opts.Flag] = val end
            if userCallback then pcall(userCallback, val) end
            triggerDependencies()
        end
        local t = sec:Textbox({
            Name = opts.Name,
            Flag = opts.Flag,
            Default = opts.Default,
            Placeholder = opts.Placeholder or opts.Name,
            Callback = opts.Callback
        })
        local w = {}
        w.__ui = t
        function w:SetVisibility(state) pcall(function() if t.SetVisibility then t:SetVisibility(state) end end) end
        function w.set(text)
            if opts.Flag and Flags then Flags[opts.Flag] = text end
        end
        registerDependency(w, opts)
        return w
    end

    _sectionCache[cacheKey] = wrapper
    return wrapper
end

LegacyWindow = {}
function LegacyWindow:Page(opts)
    local pageWrapper = {}
    function pageWrapper:Section(sopts)
        return wrapSection(sopts.Name, sopts.Side)
    end
    function pageWrapper:MultiSection(mopts)
        local side = mopts and mopts.Side or 1
        local msWrapper = {}
        local sections = {}
        function msWrapper:Add(name)
            local sec = wrapSection(name, side == 1 and "Left" or "Right")
            sections[name] = sec
            return sec
        end
        function msWrapper:Select(name)
            for k, sec in pairs(sections) do
                if k == name then
                    sec:SetVisibility(true)
                else
                    sec:SetVisibility(false)
                end
            end
        end
        return msWrapper
    end
    return pageWrapper
end

Window = LegacyWindow

window = {}
window.toggle_menu = function(v)
    if v == nil then v = not _menuVisible end
    _menuVisible = v
    if MainWindow then
        MainWindow:SetVisible(_menuVisible)
    end
end

Library.WatermarkObj = Library.WatermarkObj or Watermark
Library.KeyList = Library.KeyList or KeybindList
Library.PlayerListObj = nil
C = {
    Fog = Color3.fromRGB(128,128,128),
    FOV = Color3.new(1,1,1), FOVOut = Color3.new(0,0,0), FOVFill = Color3.new(1,1,1),
    TargetTracer = Color3.new(1,0,0), TargetTracerOut = Color3.new(0,0,0),
    ChinaHatColor = Color3.fromRGB(255,255,255), ChinaHatLightColor = Color3.fromRGB(255,255,255),
    CharMaterialColor = Color3.fromRGB(155,125,175), ToolMaterialColor = Color3.fromRGB(155,125,175),
    SilentFOV = Color3.new(1,1,1), SilentFOVOut = Color3.new(0,0,0), SilentFOVFill = Color3.new(1,1,1),
}
MATERIAL_LIST = {"ForceField","Neon","Plastic","SmoothPlastic","Wood","WoodPlanks","Marble","Slate","Concrete","Granite","Brick","Pebble","Cobblestone","Rock","DiamondPlate","Metal","CorrodedMetal","Foil","Grass","Sand","Fabric","Ice","Glass","Asphalt","LeafyGrass","Salt","Snow","Mud","Ground","Basalt","CrackedLava"}
getMaterialEnum = function(name)
    for _, m in ipairs(Enum.Material:GetEnumItems()) do
        if m.Name == name then return m end
    end
    return Enum.Material.Neon
end

library = {
    items = nil,
    flags = Flags,
    config_flags = nil,
    unloadMenu = function()
        local lib = getgenv().Library
        if lib and lib.Unload then
            pcall(lib.Unload, lib)
        end
    end,
    configListUpdate = function() end
}
getgenv().library = library
notifications = notifications or { create_notification = function(opts) pcall(function() Library:Notify(opts.name or "", opts.duration or 3) end) end }

local originalChangeTheme = Library.ChangeTheme
Library.ChangeTheme = function(self, key, color)
    if not key or not color then return end
    if typeof(color) ~= "Color3" then return end
    originalChangeTheme(Library, key, color)
end

if not Library.Notify or type(Library.Notify) ~= "function" then
    function Library:Notify(text, duration)
        local text = tostring(text or "")
        local duration = duration or 3
        if notifications and type(notifications.create_notification) == "function" then
            pcall(function()
                notifications.create_notification({ name = text, duration = duration })
            end)
        end
    end
end

pcall(function() Library:Notify("alternate loaded", 3) end)


local function getMultiSection(container, side)
    if container and type(container.MultiSection) == "function" then
        return container:MultiSection({ Side = side })
    elseif container and type(container.Section) == "function" then
        local msWrapper = {}
        local sections = {}
        function msWrapper:Add(name)
            local sec = wrapSection(name, side)
            sections[name] = sec
            return sec
        end
        function msWrapper:Select(name)
            for k, sec in pairs(sections) do
                if sec and type(sec.SetVisibility) == "function" then
                    sec:SetVisibility(k == name)
                end
            end
        end
        return msWrapper
    else
        local dummy = {}
        function dummy:Add(name)
            return { SetVisibility = function() end }
        end
        function dummy:Select(name) end
        return dummy
    end
end

local AimPageLeft = getMultiSection(AimbotSubPage, 1)
local AimPageRight = getMultiSection(AimbotSubPage, 2)
local AimTab = AimPageLeft:Add("Aimbot")
local MainR = AimPageRight:Add("Main")
local SettingsSec = AimPageRight:Add("AimbotSettings")
local AimPlusSec = AimPageRight:Add("Aimbot+")
local MainMultiR = AimPageRight

local SilentPageLeft = getMultiSection(SilentAimSubPage, 1)
local SilentPageRight = getMultiSection(SilentAimSubPage, 2)
local SilentTab = SilentPageLeft:Add("Silent")
local SilentTabRight = SilentPageRight:Add("Silent Settings")

local AimbotSettings = {}
local updateAimbotFOVVis, updateSilentFOVVis
local aimUseFOV, aimDrawFOV, aimFOVColor, aimFOVOutlineColor, aimFOVFillToggle, aimFOVFillColor, aimFOVSize, aimFOVThickness, aimFOVOutlineThickness, aimFOVAlpha, aimFOVFillTransparency, aimFOVSides, aimFOVAnimation, aimDynamicFOV, aimDynamicFOVAmount
local silentUseFOV, silentFOVColor, silentDrawFOV, silentFOVSize, silentFOVAlpha, silentFOVOutlineAlpha, silentFOVFillToggle, silentFOVFillTransparency, silentFOVAnimation, silentDynamicFOV, silentDynamicFOVAmount
local VisibilityHierarchy = {}

local function isFlagActive(flag)
    if Flags[flag] == true then
        return true
    end
    if _bindActive and _bindActive(flag .. "Bind") then
        return true
    end
    return false
end

local function setWidgetVisibility(widget, visible)
    if widget and type(widget.SetVisibility) == "function" then
        pcall(function() widget:SetVisibility(visible) end)
    end
end

local function anyFlagActive(flags)
    if type(flags) ~= "table" then
        return false
    end

    for _, flag in ipairs(flags) do
        if not isFlagActive(flag) then
            return false
        end
    end
    return true
end

local function registerWidget(parentFlags, childWidget, childFlag)
    if type(parentFlags) ~= "table" then
        parentFlags = { parentFlags }
    end

    if not childWidget then
        return
    end

    local entry = {
        parentFlags = parentFlags,
        widget = childWidget,
        flag = childFlag,
    }

    for _, parentFlag in ipairs(parentFlags) do
        if type(parentFlag) ~= "string" then
            continue
        end

        if not VisibilityHierarchy[parentFlag] then
            VisibilityHierarchy[parentFlag] = {}
        end

        local list = VisibilityHierarchy[parentFlag]
        list[#list + 1] = entry
    end

    setWidgetVisibility(childWidget, anyFlagActive(parentFlags))
end

local function updateHierarchyVisibility(parentFlag)
    if not VisibilityHierarchy[parentFlag] then
        return
    end

    for _, item in ipairs(VisibilityHierarchy[parentFlag]) do
        setWidgetVisibility(item.widget, anyFlagActive(item.parentFlags))
    end
end

local function addAimbotSetting(widget)
    table.insert(AimbotSettings, widget)
    return widget
end

local currentSettingsTab = "Aimbot"

local function updateAdvancedPartsVis()
    local enabled = Flags["UseAdvancedParts"]
    if Flags["_JumpPart"] then
        pcall(function() Flags["_JumpPart"]:SetVisibility(enabled) end)
    end
    if Flags["_FallPart"] then
        pcall(function() Flags["_FallPart"]:SetVisibility(enabled) end)
    end
end

local function updateSmoothingVis()
    local useSmooth = Flags["UseSmoothing"] == true
    local aimbotEnabled = Flags["AimbotEnabled"] == true
    local useAdv = Flags["UseAdvSmoothing"] == true
    if not aimbotEnabled then
        if Flags["_SmoothX"] then pcall(function() Flags["_SmoothX"]:SetVisibility(false) end) end
        if Flags["_SmoothY"] then pcall(function() Flags["_SmoothY"]:SetVisibility(false) end) end
        if Flags["_UseAdvSmoothing"] then pcall(function() Flags["_UseAdvSmoothing"]:SetVisibility(false) end) end
        if Flags["_AdvSmoothRight"] then pcall(function() Flags["_AdvSmoothRight"]:SetVisibility(false) end) end
        if Flags["_AdvSmoothLeft"] then pcall(function() Flags["_AdvSmoothLeft"]:SetVisibility(false) end) end
        if Flags["_AdvSmoothUp"] then pcall(function() Flags["_AdvSmoothUp"]:SetVisibility(false) end) end
        if Flags["_AdvSmoothDown"] then pcall(function() Flags["_AdvSmoothDown"]:SetVisibility(false) end) end
        if Flags["_AirXSmoothing"] then pcall(function() Flags["_AirXSmoothing"]:SetVisibility(false) end) end
        return
    end
    if Flags["_SmoothX"] then pcall(function() Flags["_SmoothX"]:SetVisibility(useSmooth and not useAdv) end) end
    if Flags["_SmoothY"] then pcall(function() Flags["_SmoothY"]:SetVisibility(useSmooth and not useAdv) end) end
    if Flags["_UseAdvSmoothing"] then pcall(function() Flags["_UseAdvSmoothing"]:SetVisibility(useSmooth) end) end
    if Flags["_AdvSmoothRight"] then pcall(function() Flags["_AdvSmoothRight"]:SetVisibility(useSmooth and useAdv) end) end
    if Flags["_AdvSmoothLeft"] then pcall(function() Flags["_AdvSmoothLeft"]:SetVisibility(useSmooth and useAdv) end) end
    if Flags["_AdvSmoothUp"] then pcall(function() Flags["_AdvSmoothUp"]:SetVisibility(useSmooth and useAdv) end) end
    if Flags["_AdvSmoothDown"] then pcall(function() Flags["_AdvSmoothDown"]:SetVisibility(useSmooth and useAdv) end) end
    if Flags["_AirXSmoothing"] then pcall(function() Flags["_AirXSmoothing"]:SetVisibility(useSmooth and useAdv) end) end
end

local function updateAimbotSettingsVis()
    local enabled = Flags["AimbotEnabled"] == true
    for _, widget in ipairs(AimbotSettings) do
        if widget and widget.SetVisibility then
            pcall(function() widget:SetVisibility(enabled) end)
        end
    end
end

local function updateAnimChangerVis()
    local enabled = Flags["AnimEnabled"] == true
    if Flags["_AnimWalk"] then Flags["_AnimWalk"]:SetVisibility(enabled) end
    if Flags["_AnimRun"] then Flags["_AnimRun"]:SetVisibility(enabled) end
    if Flags["_AnimIdle"] then Flags["_AnimIdle"]:SetVisibility(enabled) end
    if Flags["_AnimJump"] then Flags["_AnimJump"]:SetVisibility(enabled) end
    if Flags["_AnimFall"] then Flags["_AnimFall"]:SetVisibility(enabled) end
    if Flags["_AnimSwim"] then Flags["_AnimSwim"]:SetVisibility(enabled) end
end

task.spawn(function()
    task.wait(0.2)
    pcall(function()
        if updateAnimChangerVis then updateAnimChangerVis() end
    end)
end)

local function updateAimbotFOVVis()
    local useFOV = Flags["UseFOV"] == true
    local fill = Flags["FOVFill"] == true
    local dynamic = Flags["DynamicFOV"] == true

    if aimDrawFOV then aimDrawFOV:SetVisibility(useFOV) end
    if aimFOVColor then aimFOVColor:SetVisibility(useFOV) end
    if aimFOVOutlineColor then aimFOVOutlineColor:SetVisibility(useFOV) end
    if aimFOVFillToggle then aimFOVFillToggle:SetVisibility(useFOV) end
    if aimFOVFillColor then aimFOVFillColor:SetVisibility(useFOV and fill) end
    if aimFOVSize then aimFOVSize:SetVisibility(useFOV) end
    if aimFOVThickness then aimFOVThickness:SetVisibility(useFOV) end
    if aimFOVOutlineThickness then aimFOVOutlineThickness:SetVisibility(useFOV) end
    if aimFOVAlpha then aimFOVAlpha:SetVisibility(useFOV) end
    if aimFOVFillTransparency then aimFOVFillTransparency:SetVisibility(useFOV and fill) end
    if aimFOVSides then aimFOVSides:SetVisibility(useFOV) end
    if aimFOVAnimation then aimFOVAnimation:SetVisibility(useFOV) end
    if aimDynamicFOV then aimDynamicFOV:SetVisibility(useFOV) end
    if aimDynamicFOVAmount then aimDynamicFOVAmount:SetVisibility(useFOV and dynamic) end
end

local function updateSilentFOVVis()
    local useFOV = Flags["SilentUseFOV"] == true
    local fill = Flags["SilentFOVFill"] == true
    local dynamic = Flags["SilentDynamicFOV"] == true

    if silentDrawFOV then silentDrawFOV:SetVisibility(useFOV) end
    if silentFOVColor then silentFOVColor:SetVisibility(useFOV) end
    if silentFOVFillToggle then silentFOVFillToggle:SetVisibility(useFOV) end
    if silentFOVFillTransparency then silentFOVFillTransparency:SetVisibility(useFOV and fill) end
    if silentFOVSize then silentFOVSize:SetVisibility(useFOV) end
    if silentFOVAlpha then silentFOVAlpha:SetVisibility(useFOV) end
    if silentFOVOutlineAlpha then silentFOVOutlineAlpha:SetVisibility(useFOV) end
    if silentFOVAnimation then silentFOVAnimation:SetVisibility(useFOV) end
    if silentDynamicFOV then silentDynamicFOV:SetVisibility(useFOV) end
    if silentDynamicFOVAmount then silentDynamicFOVAmount:SetVisibility(useFOV and dynamic) end
end

local function updateSilentHitChanceVis()
    local enabled = Flags["SilentHitChanceEnabled"] == true
    if silentHitChance then
        silentHitChance:SetVisibility(enabled)
    end
end

local function updateOffsetVis()
    local useOffsets = Flags["UseOffsets"]
    local useAirOffset = Flags["UseAirOffset"]
    if Flags["_OffsetUp"] then Flags["_OffsetUp"]:SetVisibility(useOffsets) end
    if Flags["_OffsetDown"] then Flags["_OffsetDown"]:SetVisibility(useOffsets) end
    if Flags["_OffsetLeft"] then Flags["_OffsetLeft"]:SetVisibility(useOffsets) end
    if Flags["_OffsetRight"] then Flags["_OffsetRight"]:SetVisibility(useOffsets) end
    if Flags["_UseAirOffset"] then Flags["_UseAirOffset"]:SetVisibility(true) end
    if Flags["_AirOffsetVal"] then Flags["_AirOffsetVal"]:SetVisibility(useAirOffset) end
    if Flags["_AirOffsetSmooth"] then Flags["_AirOffsetSmooth"]:SetVisibility(useAirOffset and not Flags["AirOffsetUseAimbotSmooth"]) end
    if Flags["_AirOffsetUseAimbotSmooth"] then Flags["_AirOffsetUseAimbotSmooth"]:SetVisibility(useAirOffset) end
end

local function updateDeadspotVis()
    local stay = Flags["StayOnDeadspot"]
    if Flags["_DeadspotTime"] then Flags["_DeadspotTime"]:SetVisibility(stay) end
end

local function updateDelayJumpVis()
    local delayJump = Flags["DelayJump"] == true
    if Flags["_DelayJumpMs"] then Flags["_DelayJumpMs"]:SetVisibility(delayJump) end
    if Flags["_UpTargetPart"] then Flags["_UpTargetPart"]:SetVisibility(delayJump) end
end



local function updateUnlockDelayVis()
    local unlockDelay = Flags["UnlockDelayEnabled"]
    if Flags["_UnlockDelayMs"] then Flags["_UnlockDelayMs"]:SetVisibility(unlockDelay) end
end

_aimbotKeybindWidget = AimTab:Toggle({ Name = "Enabled", Flag = "AimbotEnabled", Default = false, Callback = function()
    pcall(updateAimbotSettingsVis)
    pcall(updateSmoothingVis)
    pcall(updatePredVis)
    pcall(updatePredOffsetVis)
    pcall(updatePullResVis)

    pcall(updateRealisticVis)
    pcall(updateAdvancedPartsVis)
    pcall(updateReactionVis)
    pcall(updateMissChanceVis)
    pcall(updateJumpDelayVis)
    pcall(updateEasingVis)
end }):Keybind({ Flag = "AimbotBind", Default = Enum.KeyCode.Unknown, Mode = "Toggle" })

AimTab:Label("TARGET & LOCK")
AimTab:Dropdown({ Name = "Lock Method", Flag = "LockMethod", Items = {"Camera","Mouse"}, Default = "Camera" })
AimTab:Dropdown({ Name = "Target Mode", Flag = "TargetMode", Items = {"FOV","Mouse","Distance","Center"}, Default = "FOV" })
AimTab:Dropdown({ Name = "Aim Type", Flag = "AimType", Items = {"Normal", "Closest Part"}, Default = "Normal" })
AimTab:Label("HIT DETECTION")
local hitPartItems = {"Head","Neck","UpperTorso","LowerTorso","Torso","Legs","Closest Part","HumanoidRootPart","LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm","LeftHand","RightHand","LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg","LeftFoot","RightFoot"}
AimTab:Dropdown({ Name = "Ground Part", Flag = "GroundPart", Items = hitPartItems, Default = "Head" })
local aimAdvancedParts = AimTab:Toggle({ Name = "Advanced Parts", Flag = "UseAdvancedParts", Default = false, Callback = updateAdvancedPartsVis })
Flags["_JumpPart"] = AimTab:Dropdown({ Name = "Jump Part", Flag = "JumpPart", Items = hitPartItems, Default = "HumanoidRootPart" })
Flags["_FallPart"] = AimTab:Dropdown({ Name = "Fall Part", Flag = "FallPart", Items = hitPartItems, Default = "LowerTorso" })
AimTab:Label("FILTERING & CHECKS")
AimTab:Toggle({ Name = "Ignore Fall State", Flag = "IgnoreFall", Default = false })
AimTab:Dropdown({ Name = "Checks", Flag = "AimChecks", Items = {"Enemy","Team","NPC","Wall","Dead","Knocked"}, Default = {}, Multi = true })
AimTab:Toggle({ Name = "Stay on Deadspot", Flag = "StayOnDeadspot", Default = false, Callback = updateDeadspotVis })
Flags["_DeadspotTime"] = AimTab:Slider({ Name = "Deadspot Time", Flag = "DeadspotTime", Min = 50, Max = 3000, Default = 300, Suffix = "ms" })
AimTab:Toggle({ Name = "Auto Stop on Dead", Flag = "AimStopDead", Default = false })
AimTab:Toggle({ Name = "Sticky Aim", Flag = "StickyAim", Default = false })

AimTab:Toggle({ Name = "Lock Target", Flag = "LockTarget", Default = false })
AimTab:Toggle({ Name = "Auto Reload", Flag = "AutoReload", Default = false })
AimTab:Toggle({ Name = "Spectate Target", Flag = "AimbotSpectateTarget", Default = false }):Keybind({ Flag = "SpectateTargetBind", Default = Enum.KeyCode.Unknown, Mode = "Toggle" })

aimUseFOV = AimTab:Toggle({ Name = "Use FOV", Flag = "UseFOV", Default = false, Callback = updateAimbotFOVVis })
aimDrawFOV = AimTab:Toggle({ Name = "Draw FOV", Flag = "DrawFOV", Default = false, Callback = updateAimbotFOVVis })
aimFOVColor = AimTab:Colorpicker({ Name = "FOV Color", Flag = "FOVColor", Default = Color3.new(1, 1, 1), Alpha = 0, Callback = updateAimbotFOVVis })
aimFOVOutlineColor = AimTab:Colorpicker({ Name = "FOV Outline Color", Flag = "FOVOutlineColor", Default = Color3.new(0, 0, 0), Alpha = 0, Callback = updateAimbotFOVVis })
aimFOVFillToggle = AimTab:Toggle({ Name = "FOV Fill", Flag = "FOVFill", Default = false, Callback = updateAimbotFOVVis })
aimFOVFillColor = AimTab:Colorpicker({ Name = "FOV Fill Color", Flag = "FOVFillColor", Default = Color3.new(1, 1, 1), Alpha = 0, Callback = updateAimbotFOVVis })
aimFOVSize = AimTab:Slider({ Name = "FOV Size", Flag = "FOVSize", Min = 10, Max = 500, Default = 100 })
aimFOVAlpha = AimTab:Slider({ Name = "FOV Alpha", Flag = "FOVAlpha", Min = 0, Max = 1, Default = 1, Precise = true })
aimFOVOutlineThickness = AimTab:Slider({ Name = "FOV Outline Thickness", Flag = "FOVOutlineThickness", Min = 1, Max = 10, Default = 2 })
aimFOVFillTransparency = AimTab:Slider({ Name = "FOV Fill Transparency", Flag = "FOVFillTransparency", Min = 0, Max = 1, Default = 0.35, Precise = true })
aimFOVSides = AimTab:Slider({ Name = "FOV Sides", Flag = "FOVSides", Min = 8, Max = 128, Default = 64 })
aimFOVAnimation = AimTab:Dropdown({ Name = "FOV Animation", Flag = "FOVAnimation", Items = {"None", "Pulse", "Spin"}, Default = "None", Multi = true })
aimDynamicFOV = AimTab:Toggle({ Name = "Dynamic FOV", Flag = "DynamicFOV", Default = false, Callback = updateAimbotFOVVis })
aimDynamicFOVAmount = AimTab:Slider({ Name = "Dynamic FOV Amount", Flag = "DynamicFOVAmount", Min = 0, Max = 100, Default = 10 })
Flags["UseFOV"] = Flags["UseFOV"] or false
Flags["DrawFOV"] = Flags["DrawFOV"] or false
Flags["FOVFill"] = Flags["FOVFill"] or false
Flags["DynamicFOV"] = Flags["DynamicFOV"] or false

-- Prediction toggle and settings
local function updatePredVis()
    local usePred = Flags["UsePred"] == true
    local aimbotEnabled = Flags["AimbotEnabled"] == true
    local showAny = usePred and aimbotEnabled

    if Flags["_PredX"] then Flags["_PredX"]:SetVisibility(showAny) end
    if Flags["_PredY"] then Flags["_PredY"]:SetVisibility(showAny) end
    if Flags["_PredAirX"] then Flags["_PredAirX"]:SetVisibility(showAny) end
end

-- Offsets toggle and settings (separate section)
local function updatePredOffsetVis()
    local usePredOffsets = Flags["UseOffsets"] == true
    local aimbotEnabled = Flags["AimbotEnabled"] == true
    local show = usePredOffsets and aimbotEnabled
    
    if Flags["_OffsetRight"] then Flags["_OffsetRight"]:SetVisibility(show) end
    if Flags["_OffsetLeft"] then Flags["_OffsetLeft"]:SetVisibility(show) end
    if Flags["_OffsetUp"] then Flags["_OffsetUp"]:SetVisibility(show) end
    if Flags["_OffsetDown"] then Flags["_OffsetDown"]:SetVisibility(show) end
end

local aimPred = addAimbotSetting(AimPlusSec:Toggle({ Name = "Prediction", Flag = "UsePred", Default = false, Callback = updatePredVis }))
Flags["_PredX"] = addAimbotSetting(AimPlusSec:Slider({ Name = "Ground X/Z Prediction", Flag = "PredX", Min = 0, Max = 150, Default = 30 }))
Flags["_PredY"] = addAimbotSetting(AimPlusSec:Slider({ Name = "Ground Y Prediction", Flag = "PredY", Min = 0, Max = 150, Default = 30 }))
Flags["_PredAirX"] = addAimbotSetting(AimPlusSec:Slider({ Name = "Air X/Z Prediction", Flag = "PredAirX", Min = 0, Max = 150, Default = 12 }))

-- Offsets section (separate toggle)
local aimPredOffsets = addAimbotSetting(AimPlusSec:Toggle({ Name = "Offsets", Flag = "UseOffsets", Default = false, Callback = updatePredOffsetVis }))
Flags["_OffsetRight"] = addAimbotSetting(AimPlusSec:Slider({ Name = "Offset Right", Flag = "OffsetRight", Min = 0, Max = 100, Default = 0 }))
Flags["_OffsetLeft"] = addAimbotSetting(AimPlusSec:Slider({ Name = "Offset Left", Flag = "OffsetLeft", Min = 0, Max = 100, Default = 0 }))
Flags["_OffsetUp"] = addAimbotSetting(AimPlusSec:Slider({ Name = "Offset Up", Flag = "OffsetUp", Min = 0, Max = 100, Default = 0 }))
Flags["_OffsetDown"] = addAimbotSetting(AimPlusSec:Slider({ Name = "Offset Down", Flag = "OffsetDown", Min = 0, Max = 100, Default = 0 }))

local aimSmoothing = addAimbotSetting(AimPlusSec:Toggle({ Name = "Smoothing", Flag = "UseSmoothing", Default = false, Callback = updateSmoothingVis }))
Flags["_SmoothX"] = addAimbotSetting(AimPlusSec:Slider({ Name = "X Smoothing", Flag = "SmoothX", Min = 1, Max = 100, Default = 3, Precise = true }))
Flags["_SmoothY"] = addAimbotSetting(AimPlusSec:Slider({ Name = "Y Smoothing", Flag = "SmoothY", Min = 1, Max = 100, Default = 3, Precise = true }))
local function updatePullResVis()
    local enabled = Flags["UsePullRes"] == true
    local aimbotEnabled = Flags["AimbotEnabled"] == true
    local show = enabled and aimbotEnabled
    if Flags["_PullResX"] then Flags["_PullResX"]:SetVisibility(show) end
    if Flags["_PullResY"] then Flags["_PullResY"]:SetVisibility(show) end
    if Flags["_SmoothPullUserBlend"] then Flags["_SmoothPullUserBlend"]:SetVisibility(show) end
end
Flags["_UsePullRes"] = addAimbotSetting(AimPlusSec:Toggle({ Name = "Pull Res", Flag = "UsePullRes", Default = false, Callback = updatePullResVis }))
Flags["_PullResX"] = addAimbotSetting(AimPlusSec:Slider({ Name = "Pull X", Flag = "PullResX", Min = 0, Max = 100, Default = 15 }))
Flags["_PullResY"] = addAimbotSetting(AimPlusSec:Slider({ Name = "Pull Y", Flag = "PullResY", Min = 0, Max = 100, Default = 15 }))
Flags["_SmoothPullUserBlend"] = addAimbotSetting(AimPlusSec:Slider({ Name = "User Blend", Flag = "SmoothPullUserBlend", Min = 0, Max = 100, Default = 30 }))

local function updateRealisticVis()
    local on = Flags["RealisticAim"] == true
    local aimbotEnabled = Flags["AimbotEnabled"] == true
    local show = on and aimbotEnabled
    if Flags["_RealisticGround"] then Flags["_RealisticGround"]:SetVisibility(show) end
    if Flags["_RealisticAirUp"] then Flags["_RealisticAirUp"]:SetVisibility(show) end
    if Flags["_RealisticAirDown"] then Flags["_RealisticAirDown"]:SetVisibility(show) end
    if Flags["_RealisticBob"] then Flags["_RealisticBob"]:SetVisibility(show) end
end
addAimbotSetting(AimPlusSec:Toggle({ Name = "Aim Sway", Flag = "RealisticAim", Default = false, Callback = updateRealisticVis }))
Flags["_RealisticGround"] = addAimbotSetting(AimPlusSec:Slider({ Name = "Y Offset (Grounded)", Flag = "RealisticGround", Min = 0, Max = 30, Default = 6, Suffix = "/10" }))
Flags["_RealisticAirUp"] = addAimbotSetting(AimPlusSec:Slider({ Name = "Y Offset (Jumping)", Flag = "RealisticAirUp", Min = 0, Max = 40, Default = 18, Suffix = "/10" }))
Flags["_RealisticAirDown"] = addAimbotSetting(AimPlusSec:Slider({ Name = "Y Offset (Falling)", Flag = "RealisticAirDown", Min = 0, Max = 40, Default = 22, Suffix = "/10" }))
Flags["_RealisticBob"] = addAimbotSetting(AimPlusSec:Slider({ Name = "Sway Amount", Flag = "RealisticBob", Min = 0, Max = 20, Default = 3, Suffix = "/10" }))

local updateMacroTypeVis 
_fireMacro = function() end 

AimTab:Toggle({ Name = "Macro", Flag = "MacroEnabled", Default = false, Callback = function(v)
    pcall(updateMacroTypeVis)
end })
AimTab:Keybind({ Name = "Macro Bind", Flag = "MacroBindKey", Default = Enum.KeyCode.Unknown, Mode = "Always", Callback = function()
    if Flags["MacroEnabled"] then
        task.spawn(_fireMacro)
    end
end })

Flags["_MacroType"] = AimTab:Dropdown({
    Name = "Macro Type", Flag = "MacroType",
    Items = {"Infuse", "360", "Ziggy"}, Default = "Infuse",
    Callback = function() pcall(updateMacroTypeVis) end
})

Flags["_MacroSpeed"] = AimTab:Slider({ Name = "Macro Speed", Flag = "MacroSpeed", Min = 20, Max = 500, Default = 100, Suffix = "ms" })
Flags["_MacroAmountX"] = AimTab:Slider({ Name = "X Amount", Flag = "MacroAmountX", Min = 50, Max = 2000, Default = 400 })
Flags["_MacroAmountY"] = AimTab:Slider({ Name = "Y Amount", Flag = "MacroAmountY", Min = 50, Max = 2000, Default = 600 })
Flags["_Macro360Dir"] = AimTab:Dropdown({ Name = "Spin Direction", Flag = "Macro360Dir", Items = {"Right","Left"}, Default = "Right" })

updateMacroTypeVis = function()
    local t = Flags["MacroType"] or "Infuse"
    local is360 = t == "360"
    local enabled = Flags["MacroEnabled"]
    if Flags["_MacroType"] then Flags["_MacroType"]:SetVisibility(enabled) end
    if Flags["_MacroSpeed"] then Flags["_MacroSpeed"]:SetVisibility(enabled) end
    if Flags["_MacroAmountX"] then Flags["_MacroAmountX"]:SetVisibility(enabled and not is360) end
    if Flags["_MacroAmountY"] then Flags["_MacroAmountY"]:SetVisibility(enabled and not is360) end
    if Flags["_Macro360Dir"] then Flags["_Macro360Dir"]:SetVisibility(enabled and is360) end
end

local function updateEasingVis()
    local aimbotEnabled = Flags["AimbotEnabled"] == true
    local useEasing = Flags["UseEasing"] == true and aimbotEnabled
    local style = Flags["EasingType"] or "Quad"
    if Flags["_EasingType"] then Flags["_EasingType"]:SetVisibility(useEasing) end
    if Flags["_EasingSpeed"] then Flags["_EasingSpeed"]:SetVisibility(useEasing) end
    if Flags["_EasingDirection"] then Flags["_EasingDirection"]:SetVisibility(useEasing) end
    if Flags["_EasingAmount"] then Flags["_EasingAmount"]:SetVisibility(useEasing) end
    if Flags["_EasingBack"] then Flags["_EasingBack"]:SetVisibility(useEasing and style == "Back") end
    if Flags["_EasingBounce"] then Flags["_EasingBounce"]:SetVisibility(useEasing and style == "Bounce") end
    if Flags["_EasingElasticPeriod"] then Flags["_EasingElasticPeriod"]:SetVisibility(useEasing and style == "Elastic") end
    if Flags["_EasingElasticity"] then Flags["_EasingElasticity"]:SetVisibility(useEasing and style == "Elastic") end
    if Flags["_EasingSharp"] then Flags["_EasingSharp"]:SetVisibility(useEasing and (style == "Trim" or style == "Trace" or style == "Focus" or style == "Flick")) end
    if Flags["_AdaptSwaySpeed"] then Flags["_AdaptSwaySpeed"]:SetVisibility(useEasing and (isOscillator == true)) end
    if Flags["_AdaptSwayWidth"] then Flags["_AdaptSwayWidth"]:SetVisibility(useEasing and (isOscillator == true)) end
    if Flags["_AdaptJitterAmt"] then Flags["_AdaptJitterAmt"]:SetVisibility(useEasing and (isAdapt == true)) end
end
task.defer(function()
    pcall(updateMacroTypeVis)
    pcall(updateSmoothingVis)
    pcall(updatePredVis)
    pcall(updatePredOffsetVis)
    pcall(updateAimbotFOVVis)
    pcall(updateSilentFOVVis)
    pcall(updateSilentHitChanceVis)
    pcall(updateEasingVis)
    pcall(updateDeadspotVis)
    pcall(updateRealisticVis)
    pcall(updatePullResVis)

    pcall(updateReactionVis)
    pcall(updateMissChanceVis)
    pcall(updateJumpDelayVis)
    pcall(updateAdvancedPartsVis)
    pcall(updateAimbotSettingsVis)
    task.wait(0.2)
    pcall(function()
        if updateSpeedVis then updateSpeedVis() end
        if updateJumpVis then updateJumpVis() end
        if updateFlyVis then updateFlyVis() end
        if updateAnimChangerVis then updateAnimChangerVis() end
    end)
end)
local function updateJumpDelayVis()
    local useJumpDelay = Flags["UseJumpDelay"]
    local aimbotEnabled = Flags["AimbotEnabled"] == true
    if Flags["_JumpDelayMs"] then Flags["_JumpDelayMs"]:SetVisibility(useJumpDelay and aimbotEnabled) end
end

local function updateReactionVis()
    local enabled = Flags["UseReactionTime"] == true
    local aimbotEnabled = Flags["AimbotEnabled"] == true
    if Flags["_ReactionTimeMs"] then Flags["_ReactionTimeMs"]:SetVisibility(enabled and aimbotEnabled) end
end

local function updateMissChanceVis()
    local enabled = Flags["UseMissChance"] == true
    local aimbotEnabled = Flags["AimbotEnabled"] == true
    if Flags["_MissChance"] then Flags["_MissChance"]:SetVisibility(enabled and aimbotEnabled) end
end
local aimUseJumpDelay = addAimbotSetting(SettingsSec:Toggle({ Name = "Jump Delay", Flag = "UseJumpDelay", Default = false, Callback = updateJumpDelayVis }))
Flags["_JumpDelayMs"] = addAimbotSetting(SettingsSec:Slider({ Name = "Jump Delay", Flag = "JumpDelayMs", Min = 0, Max = 500, Default = 50, Suffix = "ms" }))
local aimUseReaction = addAimbotSetting(SettingsSec:Toggle({ Name = "Use Reaction Time", Flag = "UseReactionTime", Default = false, Callback = updateReactionVis }))
Flags["_ReactionTimeMs"] = addAimbotSetting(SettingsSec:Slider({ Name = "Reaction Time", Flag = "ReactionTimeMs", Min = 0, Max = 1000, Default = 150, Suffix = "ms" }))
local aimUseMiss = addAimbotSetting(SettingsSec:Toggle({ Name = "Use Miss Chance", Flag = "UseMissChance", Default = false, Callback = updateMissChanceVis }))
Flags["_MissChance"] = addAimbotSetting(SettingsSec:Slider({ Name = "Miss Chance", Flag = "MissChance", Min = 0, Max = 100, Default = 0, Suffix = "%" }))
local aimUseEasing = addAimbotSetting(SettingsSec:Toggle({ Name = "Easing", Flag = "UseEasing", Default = false, Callback = updateEasingVis }))
Flags["_EasingType"] = addAimbotSetting(SettingsSec:Dropdown({ 
    Name = "Easing Type", 
    Flag = "EasingType", 
    Items = {
        "Linear",
        "Sine",
        "Quad",
        "Cubic",
        "Quart",
        "Quint",
        "Exponential",
        "Circular",
        "Elastic",
        "Back",
        "Bounce",
        "Flick",
        "Trim",
        "Trace",
        "Focus"
    }, 
    Default = "Quad", 
    Callback = updateEasingVis 
}))
Flags["_EasingAmount"] = addAimbotSetting(SettingsSec:Slider({ Name = "Easing Amount", Flag = "EasingAmount", Min = 1, Max = 100, Default = 50 }))
Flags["_EasingSpeed"] = addAimbotSetting(SettingsSec:Slider({ Name = "Easing Speed", Flag = "EasingSpeed", Min = 1, Max = 100, Default = 50, Precise = true }))
Flags["_EasingDirection"] = addAimbotSetting(SettingsSec:Dropdown({ 
    Name = "Easing Direction", 
    Flag = "EasingDirection", 
    Items = {"In", "Out", "InOut"}, 
    Default = "Out", 
    Callback = updateEasingVis 
}))
Flags["_EasingBack"] = addAimbotSetting(SettingsSec:Slider({ Name = "Back Strength", Flag = "EasingBack", Min = 0, Max = 50, Default = 17, Suffix = "/10" }))
Flags["_EasingBounce"] = addAimbotSetting(SettingsSec:Slider({ Name = "Bounce Strength", Flag = "EasingBounce", Min = 1, Max = 20, Default = 1 }))
Flags["_EasingElasticPeriod"] = addAimbotSetting(SettingsSec:Slider({ Name = "Elastic Period", Flag = "EasingElasticPeriod", Min = 10, Max = 100, Default = 30, Suffix = "/100" }))
Flags["_EasingElasticity"] = addAimbotSetting(SettingsSec:Slider({ Name = "Elasticity", Flag = "EasingElasticity", Min = 10, Max = 200, Default = 130, Suffix = "/100" }))
Flags["_EasingSharp"] = addAimbotSetting(SettingsSec:Slider({ Name = "Easing Sharpness", Flag = "EasingSharp", Min = 1, Max = 100, Default = 20, Suffix = "/100" }))

local silentHitParts = {"Head","Torso","Legs","Closest Part","Neck","UpperTorso"}
SilentTab:Toggle({ Name = "Enabled", Flag = "SilentEnabled", Default = false }):Keybind({ Flag = "SilentBind", Default = Enum.KeyCode.Unknown, Mode = "Toggle" })
if isArsenal then
    SilentTab:Slider({ Name = "Hitbox Size", Flag = "HitboxSize", Min = 2, Max = 30, Default = 10 })
end
SilentTab:Dropdown({ Name = "Hit Part", Flag = "SilentHitPart", Items = silentHitParts, Default = "Head" })
SilentTab:Dropdown({ Name = "Checks", Flag = "SilentChecks", Items = {"NPC","Team","Dead","Wall","Knocked"}, Default = {"Team","Dead"}, Multi = true })
SilentTab:Toggle({ Name = "Target Lock", Flag = "SilentTargetLock", Default = false })
SilentTab:Toggle({ Name = "Sync with Aimbot", Flag = "SilentSyncAimbot", Default = false })
SilentTabRight:Dropdown({ Name = "Aim Type", Flag = "SilentAimType", Items = {"Cursor","Center","FOV"}, Default = "Cursor" })
SilentTabRight:Dropdown({ Name = "Target Priority", Flag = "SilentPriority", Items = {"Closest Point", "Distance"}, Default = "Closest Point" })
SilentTabRight:Toggle({ Name = "Hit Chance", Flag = "SilentHitChanceEnabled", Default = false, Callback = updateSilentHitChanceVis })
local silentHitChance = SilentTabRight:Slider({ Name = "Hit Chance %", Flag = "SilentHitChance", Min = 1, Max = 100, Default = 100, Suffix = "%" })

silentUseFOV = SilentTabRight:Toggle({ Name = "Use FOV", Flag = "SilentUseFOV", Default = false, Callback = updateSilentFOVVis })
silentFOVColor = SilentTabRight:Colorpicker({ Name = "FOV Color", Flag = "SilentFOVColor", Default = Color3.new(1, 1, 1), Alpha = 0, Callback = updateSilentFOVVis })
silentDrawFOV = SilentTabRight:Toggle({ Name = "Draw FOV", Flag = "SilentDrawFOV", Default = false, Callback = updateSilentFOVVis })
silentFOVSize = SilentTabRight:Slider({ Name = "FOV Size", Flag = "SilentFOVSize", Min = 10, Max = 500, Default = 100 })
silentFOVAlpha = SilentTabRight:Slider({ Name = "FOV Alpha", Flag = "SilentFOVAlpha", Min = 0, Max = 1, Default = 1, Precise = true })
silentFOVOutlineAlpha = SilentTabRight:Slider({ Name = "FOV Outline Alpha", Flag = "SilentFOVOutlineAlpha", Min = 0, Max = 1, Default = 0.35, Precise = true })
silentFOVFillToggle = SilentTabRight:Toggle({ Name = "FOV Fill", Flag = "SilentFOVFill", Default = false, Callback = updateSilentFOVVis })
silentFOVFillTransparency = SilentTabRight:Slider({ Name = "FOV Fill Transparency", Flag = "SilentFOVFillTransparency", Min = 0, Max = 1, Default = 0.35, Precise = true })
silentFOVAnimation = SilentTabRight:Toggle({ Name = "FOV Animation", Flag = "SilentFOVAnimation", Default = false, Callback = updateSilentFOVVis })
silentDynamicFOV = SilentTabRight:Toggle({ Name = "Dynamic FOV", Flag = "SilentDynamicFOV", Default = false, Callback = updateSilentFOVVis })
silentDynamicFOVAmount = SilentTabRight:Slider({ Name = "Dynamic FOV Amount", Flag = "SilentDynamicFOVAmount", Min = 0, Max = 100, Default = 10 })

Flags["SilentUseFOV"] = Flags["SilentUseFOV"] or false
Flags["SilentDrawFOV"] = Flags["SilentDrawFOV"] or false
Flags["SilentFOVFill"] = Flags["SilentFOVFill"] or false
Flags["SilentDynamicFOV"] = Flags["SilentDynamicFOV"] or false

if isArsenal then
    local ArsenalSec = wrapSection("Arsenal", 1)
    local ArsenalSettingsSec = wrapSection("Arsenal Settings", 2)

    -- Arsenal Skin Changer System
    local ArsenalSkins = {
        Revolver = {"Default", "Golden", "Diamond", "Fire", "Ice", "Galaxy", "Neon", "Red", "Blue", "Green", "Purple", "Orange", "Pink", "Black", "White", "Chrome", "Bronze", "Silver", "Copper", "Gold Plate", "Vampire", "Pumpkin", "Christmas", "Easter", "Summer", "Halloween"},
        Shotgun = {"Default", "Golden", "Diamond", "Fire", "Ice", "Galaxy", "Neon", "Red", "Blue", "Green", "Purple", "Orange", "Pink", "Black", "White", "Chrome", "Bronze", "Silver", "Copper", "Gold Plate", "Vampire", "Pumpkin", "Christmas", "Easter", "Summer", "Halloween"},
        SMG = {"Default", "Golden", "Diamond", "Fire", "Ice", "Galaxy", "Neon", "Red", "Blue", "Green", "Purple", "Orange", "Pink", "Black", "White", "Chrome", "Bronze", "Silver", "Copper", "Gold Plate", "Vampire", "Pumpkin", "Christmas", "Easter", "Summer", "Halloween"},
        Rifle = {"Default", "Golden", "Diamond", "Fire", "Ice", "Galaxy", "Neon", "Red", "Blue", "Green", "Purple", "Orange", "Pink", "Black", "White", "Chrome", "Bronze", "Silver", "Copper", "Gold Plate", "Vampire", "Pumpkin", "Christmas", "Easter", "Summer", "Halloween"},
        Sniper = {"Default", "Golden", "Diamond", "Fire", "Ice", "Galaxy", "Neon", "Red", "Blue", "Green", "Purple", "Orange", "Pink", "Black", "White", "Chrome", "Bronze", "Silver", "Copper", "Gold Plate", "Vampire", "Pumpkin", "Christmas", "Easter", "Summer", "Halloween"},
        MachineGun = {"Default", "Golden", "Diamond", "Fire", "Ice", "Galaxy", "Neon", "Red", "Blue", "Green", "Purple", "Orange", "Pink", "Black", "White", "Chrome", "Bronze", "Silver", "Copper", "Gold Plate", "Vampire", "Pumpkin", "Christmas", "Easter", "Summer", "Halloween"},
        Pistol = {"Default", "Golden", "Diamond", "Fire", "Ice", "Galaxy", "Neon", "Red", "Blue", "Green", "Purple", "Orange", "Pink", "Black", "White", "Chrome", "Bronze", "Silver", "Copper", "Gold Plate", "Vampire", "Pumpkin", "Christmas", "Easter", "Summer", "Halloween"},
        Knife = {"Default", "Golden", "Diamond", "Fire", "Ice", "Galaxy", "Neon", "Red", "Blue", "Green", "Purple", "Orange", "Pink", "Black", "White", "Chrome", "Bronze", "Silver", "Copper", "Gold Plate", "Vampire", "Pumpkin", "Christmas", "Easter", "Summer", "Halloween", "Butterfly", "Karambit", "Bayonet", "M9 Bayonet", "Flip Knife", "Gut Knife", "Huntsman", "Falchion", "Bowie", "Dagger", "Stiletto", "Talon", "Ursus", "Navaja", "Glock", "Skeleton"},
    }
    
    local ArsenalWraps = {"Default", "Neon Red", "Neon Blue", "Neon Green", "Neon Purple", "Neon Orange", "Neon Pink", "Galaxy", "Fire", "Ice", "Rainbow", "Chrome", "Gold", "Diamond", "Carbon Fiber", "Digital Camo", "Urban Camo", "Desert Camo", "Arctic Camo", "Forest Camo"}
    
    local function applyArsenalSkin(weaponType, skinName)
        pcall(function()
            local client = require(game.ReplicatedStorage.Modules.Client)
            local dbSkins = require(game.ReplicatedStorage.Database.Skins)
            local dbMelees = require(game.ReplicatedStorage.Database.Melees)
            
            if weaponType == "Knife" then
                -- Apply knife skin - find and set the melee weapon
                if dbMelees and dbMelees[skinName] then
                    client.EquippedMelee = skinName
                    -- Trigger melee update in character
                    if lp.Character then
                        local humanoid = lp.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            game:GetService("ReplicatedStorage").Remotes:WaitForChild("EquipMelee"):FireServer(skinName)
                        end
                    end
                end
            else
                -- Apply weapon skin
                if dbSkins and dbSkins[skinName] then
                    client.EquippedSkin = skinName
                    if client.Skins then
                        if not table.find(client.Skins, skinName) then
                            table.insert(client.Skins, skinName)
                        end
                    end
                end
            end
        end)
    end
    
    local function applyArsenalWrap(wrapName)
        pcall(function()
            local client = require(game.ReplicatedStorage.Modules.Client)
            local dbWraps = require(game.ReplicatedStorage.Database.Wraps)
            
            if dbWraps and (wrapName == "Default" or dbWraps[wrapName]) then
                -- Set the wrap on the client
                client.EquippedWrap = wrapName
                
                -- Add to unlocked wraps if needed
                if client.Wraps then
                    if wrapName ~= "Default" and not table.find(client.Wraps, wrapName) then
                        table.insert(client.Wraps, wrapName)
                    end
                end
                
                -- Fire the equip wrap remote if it exists
                local RemoteFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                if RemoteFolder then
                    local equipWrapRemote = RemoteFolder:FindFirstChild("EquipWrap")
                    if equipWrapRemote then
                        equipWrapRemote:FireServer(wrapName)
                    end
                end
                
                -- Apply wrap to current weapon in character
                if lp.Character then
                    local tool = lp.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        -- Update the tool's appearance with the wrap
                        for _, model in ipairs(tool:GetDescendants()) do
                            if model:IsA("Part") or model:IsA("MeshPart") then
                                -- Apply wrap material/texture if database exists
                                if dbWraps[wrapName] and dbWraps[wrapName].Texture then
                                    if model:FindFirstChild("Texture") then
                                        model.Texture.Texture = dbWraps[wrapName].Texture
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
    
    -- Unlock All Button
    ArsenalSec:Button({ Name = "Unlock All Skins/Knives/Wraps", Callback = function()
        pcall(function()
            local client = require(game.ReplicatedStorage.Modules.Client)
            local dbSkins = require(game.ReplicatedStorage.Database.Skins)
            local dbMelees = require(game.ReplicatedStorage.Database.Melees)
            local dbWraps = require(game.ReplicatedStorage.Database.Wraps)
            
            for i, v in pairs(dbSkins) do
                if not table.find(client.Skins, i) then
                    table.insert(client.Skins, i)
                end
            end
            for i, v in pairs(dbMelees) do
                if not table.find(client.Melees, i) then
                    table.insert(client.Melees, i)
                end
            end
            for i, v in pairs(dbWraps) do
                if not table.find(client.Wraps, i) then
                    table.insert(client.Wraps, i)
                end
            end
            if Library and Library.Notify then
                Library:Notify("Unlocked all Skins, Knives, & Wraps!", 2)
            end
        end)
    end })
    
    -- Skin Changer Toggle
    ArsenalSec:Toggle({ Name = "Skin Changer", Flag = "ArsenalSkinChangerEnabled", Default = false })
    
    -- Weapon Skin Dropdowns
    ArsenalSec:Dropdown({ Name = "Revolver Skin", Flag = "ArsenalRevolverSkin", Items = ArsenalSkins.Revolver, Default = "Default", Callback = function(v)
        if Flags["ArsenalSkinChangerEnabled"] then applyArsenalSkin("Revolver", v) end
    end })
    
    ArsenalSec:Dropdown({ Name = "Shotgun Skin", Flag = "ArsenalShotgunSkin", Items = ArsenalSkins.Shotgun, Default = "Default", Callback = function(v)
        if Flags["ArsenalSkinChangerEnabled"] then applyArsenalSkin("Shotgun", v) end
    end })
    
    ArsenalSec:Dropdown({ Name = "SMG Skin", Flag = "ArsenalSMGSkin", Items = ArsenalSkins.SMG, Default = "Default", Callback = function(v)
        if Flags["ArsenalSkinChangerEnabled"] then applyArsenalSkin("SMG", v) end
    end })
    
    ArsenalSec:Dropdown({ Name = "Rifle Skin", Flag = "ArsenalRifleSkin", Items = ArsenalSkins.Rifle, Default = "Default", Callback = function(v)
        if Flags["ArsenalSkinChangerEnabled"] then applyArsenalSkin("Rifle", v) end
    end })
    
    ArsenalSec:Dropdown({ Name = "Sniper Skin", Flag = "ArsenalSniperSkin", Items = ArsenalSkins.Sniper, Default = "Default", Callback = function(v)
        if Flags["ArsenalSkinChangerEnabled"] then applyArsenalSkin("Sniper", v) end
    end })
    
    ArsenalSec:Dropdown({ Name = "Machine Gun Skin", Flag = "ArsenalMachineGunSkin", Items = ArsenalSkins.MachineGun, Default = "Default", Callback = function(v)
        if Flags["ArsenalSkinChangerEnabled"] then applyArsenalSkin("MachineGun", v) end
    end })
    
    ArsenalSec:Dropdown({ Name = "Pistol Skin", Flag = "ArsenalPistolSkin", Items = ArsenalSkins.Pistol, Default = "Default", Callback = function(v)
        if Flags["ArsenalSkinChangerEnabled"] then applyArsenalSkin("Pistol", v) end
    end })
    
    -- Knife Changer
    ArsenalSec:Toggle({ Name = "Knife Changer", Flag = "ArsenalKnifeChangerEnabled", Default = false })
    
    ArsenalSec:Dropdown({ Name = "Knife Skin", Flag = "ArsenalKnifeSkin", Items = ArsenalSkins.Knife, Default = "Default", Callback = function(v)
        if Flags["ArsenalKnifeChangerEnabled"] then applyArsenalSkin("Knife", v) end
    end })
    
    -- Wrap Changer
    ArsenalSec:Toggle({ Name = "Wrap Changer", Flag = "ArsenalWrapChangerEnabled", Default = false })
    
    ArsenalSec:Dropdown({ Name = "Weapon Wrap", Flag = "ArsenalWeaponWrap", Items = ArsenalWraps, Default = "Default", Callback = function(v)
        if Flags["ArsenalWrapChangerEnabled"] then applyArsenalWrap(v) end
    end })

    ArsenalSec:Toggle({ Name = "Hitbox Expander", Flag = "HitboxExpanderEnabled", Default = false })
    ArsenalSettingsSec:Slider({ Name = "Hitbox Size", Flag = "HitboxSize", Min = 2, Max = 30, Default = 10 })
    ArsenalSettingsSec:Dropdown({ Name = "Hitbox Part", Flag = "HitboxPart", Items = {"Head", "HumanoidRootPart", "Torso"}, Default = "Head" })
    
    -- Arsenal Equipment Maintenance Loop
    local arsenalLastWrap = nil
    local arsenalLastKnife = nil
    _trackConn(RunService.Heartbeat:Connect(_LPH_NV(function()
        if not isArsenal then return end
        
        -- Maintain active wrap
        if Flags["ArsenalWrapChangerEnabled"] then
            local currentWrap = Flags["ArsenalWeaponWrap"]
            if currentWrap and currentWrap ~= arsenalLastWrap then
                applyArsenalWrap(currentWrap)
                arsenalLastWrap = currentWrap
            end
        end
        
        -- Maintain active knife
        if Flags["ArsenalKnifeChangerEnabled"] then
            local currentKnife = Flags["ArsenalKnifeSkin"]
            if currentKnife and currentKnife ~= arsenalLastKnife then
                applyArsenalSkin("Knife", currentKnife)
                arsenalLastKnife = currentKnife
            end
        end
        
        -- Reset on disable
        if not Flags["ArsenalWrapChangerEnabled"] then
            arsenalLastWrap = nil
        end
        if not Flags["ArsenalKnifeChangerEnabled"] then
            arsenalLastKnife = nil
        end
    end)))
end

local function hideAllAimbotWidgets()
    for _, widget in ipairs(AimbotSettings) do
        pcall(function() widget:SetVisibility(false) end)
    end
end

local function updateSettingsTabVisibility(tabName)
    currentSettingsTab = tabName
    local function show(element) pcall(function() element:SetVisibility(true) end) end
    local function run(fn) pcall(fn) end

    hideAllAimbotWidgets()

    if tabName == "Aimbot" then
        pcall(function() MainMultiR:Select("AimbotSettings") end)
        show(aimUseOffsets)
        show(aimUseJumpDelay)

        show(aimUnlockSmooth)
        show(aimAdvancedParts)
        show(Flags["_MissChance"])
        show(aimUseEasing)
        run(updateOffsetVis)
        run(updateJumpDelayVis)

        run(updateUnlockVis)
        run(updateAdvancedPartsVis)
        run(updateEasingVis)
    elseif tabName == "Aimbot+" then
        pcall(function() MainMultiR:Select("Aimbot+") end)
        show(aimSmoothing)
        show(aimPred)
        run(updateSmoothingVis)
        run(updatePredVis)
    elseif tabName == "Main" then
        currentSettingsTab = "None"
        pcall(function() MainMultiR:Select("Main") end)
    end
end

local function hookTabTurn(tab, tabName)
    tab.on_turn = function() pcall(updateSettingsTabVisibility, tabName) end
    if tab.Turn then
        local oldTurn = tab.Turn
        function tab:Turn() oldTurn(self) pcall(updateSettingsTabVisibility, tabName) end
    end
end

hookTabTurn(AimTab, "Aimbot")
hookTabTurn(AimPlusSec, "Aimbot+")
hookTabTurn(SettingsSec, "Aimbot")
hookTabTurn(MainR, "Main")
local ttrc = MainR:Toggle({ Name = "Target Tracer", Flag = "TargetTracer", Default = false })
ttrc:Colorpicker({ Flag = "c_ttrace", Default = Color3.new(1,0,0), Callback = function(c) C.TargetTracer=c end })
ttrc:Colorpicker({ Flag = "c_ttraceout", Default = Color3.new(0,0,0), Callback = function(c) C.TargetTracerOut=c end })
Flags["_TargetTracerAlpha"] = MainR:Slider({ Name = "Tracer Fill Alpha", Flag = "TargetTracerAlpha", Min = 0, Max = 100, Default = 100, Suffix = "%" })
Flags["_TargetTracerOutAlpha"] = MainR:Slider({ Name = "Tracer Outline Alpha", Flag = "TargetTracerOutAlpha", Min = 0, Max = 100, Default = 100, Suffix = "%" })
MainR:Dropdown({ Name = "Tracer Start", Flag = "TargetTracerStart", Items = {"Bottom","Top","Cursor"}, Default = "Bottom" })
MainR:Dropdown({ Name = "Tracer End", Flag = "TargetTracerEnd", Items = {"Feet","Head"}, Default = "Feet" })
MainR:Toggle({ Name = "Lock Target", Flag = "LockTarget", Default = false })
local spectateTargetToggle = MainR:Toggle({ Name = "Spectate Target", Flag = "AimbotSpectateTarget", Default = false })
    spectateTargetToggle:Keybind({ Flag = "SpectateTargetBind", Default = Enum.KeyCode.Unknown, Mode = "Toggle" })

    local tpTargetToggle = MainR:Toggle({ Name = "TP Target", Flag = "TPTarget", Default = false, Callback = function() updateHierarchyVisibility("TPTarget") end })
    tpTargetToggle:Keybind({ Flag = "TPTargetBind", Default = Enum.KeyCode.Unknown, Mode = "Toggle", Callback = function() updateHierarchyVisibility("TPTarget") end })
    local tpType = MainR:Dropdown({ Name = "TP Type", Flag = "TPType", Items = {"Static","Rage"}, Default = "Static" })
    local tpAmount = MainR:Slider({ Name = "TP Amount", Flag = "TPAmount", Min = 0, Max = 20, Default = 5, Rounding = 1 })
    local tpHideInterval = MainR:Slider({ Name = "Hide Interval", Flag = "TPHideInterval", Min = 0, Max = 10, Default = 1, Precise = true, Suffix = "s" })
    local armTpToggle = MainR:Toggle({ Name = "Arm TP", Flag = "TPArmOnly", Default = false, Callback = function() updateHierarchyVisibility("TPTarget") end })
    local bodyScatterToggle = MainR:Toggle({ Name = "Body Scatter", Flag = "TPBodyScatter", Default = false })
    local orbitTargetToggle = MainR:Toggle({ Name = "Orbit Target", Flag = "OrbitTarget", Default = false, Callback = function() updateHierarchyVisibility("OrbitTarget") end })
    local orbitSpeedSlider = MainR:Slider({ Name = "Orbit Speed", Flag = "OrbitSpeed", Min = 1, Max = 30, Default = 8, Precise = true })
    MainR:Toggle({ Name = "Sync with Target", Flag = "AimbotSyncWithTarget", Default = false })

    registerWidget("TPTarget", tpType, "TPType")
    registerWidget("TPTarget", tpAmount, "TPAmount")
    registerWidget("TPTarget", tpHideInterval, "TPHideInterval")
    registerWidget("TPTarget", armTpToggle, "TPArmOnly")
    registerWidget("TPArmOnly", bodyScatterToggle, "TPBodyScatter")
    registerWidget("TPTarget", orbitTargetToggle, "OrbitTarget")
    registerWidget("TPTarget", orbitSpeedSlider, "OrbitSpeed")
    registerWidget("OrbitTarget", orbitSpeedSlider, "OrbitSpeed")

end



local OtherPage = Window:Page({ Name = "World", Icon = "rbxassetid://11395780588" })
local WorldMultiL = OtherPage:MultiSection({ Side = 1 })
local LightTab = WorldMultiL:Add("Lighting")
local WeatherTab = WorldMultiL:Add("Weather")
local WorldMultiR = OtherPage:MultiSection({ Side = 2 })
local SkyTab = WorldMultiR:Add("Skybox")
local MatTab = WorldMultiR:Add("Materials")
local _lightingTouched = {}
local _atmoHasOrig = false
local _atmoTouched = false
local function updateLightingVis()
    local on = Flags["OverLight"] or false
    if Flags["_Sat"] then Flags["_Sat"]:SetVisibility(on) end
    if Flags["_Bright"] then Flags["_Bright"]:SetVisibility(on) end
    if Flags["_Cont"] then Flags["_Cont"]:SetVisibility(on) end
end
LightTab:Toggle({ Name = "Lighting", Flag = "OverLight", Default = false, Callback = function(v)
    if v then
        _origBrightness = _origBrightness or Lighting.Brightness
        _origOutdoorAmbient = _origOutdoorAmbient or Lighting.OutdoorAmbient
    else
        if not _origBrightness then return end
        pcall(function()
            Lighting.Brightness = _origBrightness
            Lighting.OutdoorAmbient = _origOutdoorAmbient
        end)
        local cc = Lighting:FindFirstChild("_alternateCC")
        if cc then pcall(function() cc:Destroy() end) end
    end
    updateLightingVis()
end })
local _atmoD = LightTab:Slider({ Name = "Atmo Density", Flag = "AtmoD", Min = 0, Max = 100, Default = 40, Suffix = "%" })
local _atmoO = LightTab:Slider({ Name = "Atmo Offset", Flag = "AtmoO", Min = 0, Max = 100, Default = 0, Suffix = "%" })
local _atmoG = LightTab:Slider({ Name = "Atmo Glare", Flag = "AtmoG", Min = 0, Max = 100, Default = 0, Suffix = "%" })
local _atmoH = LightTab:Slider({ Name = "Atmo Haze", Flag = "AtmoH", Min = 0, Max = 100, Default = 0, Suffix = "%" })
_atmoD:SetVisibility(false)
_atmoO:SetVisibility(false)
_atmoG:SetVisibility(false)
_atmoH:SetVisibility(false)
LightTab:Toggle({ Name = "Override Atmosphere", Flag = "OverAtmo", Default = false, Callback = function(v)
    _atmoD:SetVisibility(v)
    _atmoO:SetVisibility(v)
    _atmoG:SetVisibility(v)
    _atmoH:SetVisibility(v)
    if v then
        local a = Lighting:FindFirstChildOfClass("Atmosphere")
        if a then
            _origAtmoDensity = a.Density; _origAtmoOffset = a.Offset
            _origAtmoGlare   = a.Glare;   _origAtmoHaze   = a.Haze
            _atmoHasOrig = true
        else
            _atmoHasOrig = false
        end
    else
        local a = Lighting:FindFirstChildOfClass("Atmosphere")
        if a then
            if _atmoHasOrig and _origAtmoDensity then
                a.Density = _origAtmoDensity; a.Offset = _origAtmoOffset
                a.Glare   = _origAtmoGlare;   a.Haze   = _origAtmoHaze
            else
                pcall(function() a:Destroy() end)
            end
        end
    end
end })
Flags["_Sat"] = LightTab:Slider({ Name = "Saturation", Flag = "Sat", Min = -100, Max = 100, Default = 0, Callback = function(v)
    if not _lightingTouched["Sat"] then _lightingTouched["Sat"] = true; return end
    getOrCreateCC().Saturation = v / 100
end })
Flags["_Bright"] = LightTab:Slider({ Name = "Brightness", Flag = "Bright", Min = 0, Max = 5, Default = 1, Callback = function(v)
    if not _lightingTouched["Bright"] then _lightingTouched["Bright"] = true; return end
    Lighting.Brightness = v
    local boost = math.clamp((v - 1) * 0.15, -0.3, 0.3)
    Lighting.OutdoorAmbient = Color3.new(0.5 + boost, 0.5 + boost, 0.5 + boost)
end })
Flags["_Cont"] = LightTab:Slider({ Name = "Contrast", Flag = "Cont", Min = -100, Max = 100, Default = 0, Callback = function(v)
    if not _lightingTouched["Cont"] then _lightingTouched["Cont"] = true; return end
    getOrCreateCC().Contrast = v / 100
end })
task.defer(function() pcall(updateLightingVis) end)

local _origTimeOfDay = nil
local _timeConnection = nil
local _timeSlider = LightTab:Slider({ Name = "Time of Day", Flag = "TimeOfDay", Min = 0, Max = 24, Default = 12 })
_timeSlider:SetVisibility(false)
LightTab:Toggle({ Name = "Override Time", Flag = "OverTime", Default = false, Callback = function(v)
    _timeSlider:SetVisibility(v)
    if v then
        _origTimeOfDay = _origTimeOfDay or Lighting.ClockTime
        if not _timeConnection then
            _timeConnection = RunService.Heartbeat:Connect(_LPH_NV(function()
                Lighting.ClockTime = Flags["TimeOfDay"] or 12
            end))
        end
    else
        if _timeConnection then
            _timeConnection:Disconnect()
            _timeConnection = nil
        end
        if _origTimeOfDay then
            Lighting.ClockTime = _origTimeOfDay
        end
    end
end })
local _fogWasOn = false
local _fogStart = WeatherTab:Slider({ Name = "Fog Start", Flag = "FogStart", Min = 0, Max = 5000, Default = 0, Suffix = "st" })
local _fogEnd = WeatherTab:Slider({ Name = "Fog End", Flag = "FogEnd", Min = 100, Max = 10000, Default = 5000, Suffix = "st" })
_fogStart:SetVisibility(false)
_fogEnd:SetVisibility(false)
local _fogSpinSpd = WeatherTab:Slider({ Name = "Spin Speed", Flag = "FogSpinSpd", Min = 1, Max = 100, Default = 20 })
_fogSpinSpd:SetVisibility(false)
local _fogSpin = WeatherTab:Toggle({ Name = "Fog Spin", Flag = "FogSpin", Default = false, Callback = function(v)
    if Flags["CustomFog"] then
        _fogSpinSpd:SetVisibility(v)
    end
end })
_fogSpin:SetVisibility(false)
local fogT = WeatherTab:Toggle({ Name = "Fog", Flag = "CustomFog", Default = false, Callback = function(v)
    if v then
        _fogWasOn = true
        pcall(_W.disableSnow)
        pcall(function() if disableCherry then disableCherry() end end)
        pcall(function()
            if Library.SetFlags then
                if Library.SetFlags.SnowEnabled then Library.SetFlags.SnowEnabled(false) end
                if Library.SetFlags.CherryEnabled then Library.SetFlags.CherryEnabled(false) end
            else
                Flags["SnowEnabled"] = false; Flags["CherryEnabled"] = false
            end
        end)
    else
    end
    _fogStart:SetVisibility(v)
    _fogEnd:SetVisibility(v)
    _fogSpin:SetVisibility(v)
    _fogSpinSpd:SetVisibility(v and Flags["FogSpin"] or false)
end })
fogT:Colorpicker({ Flag = "c_fog", Default = Color3.fromRGB(128,128,128), Callback = function(c) C.Fog=c end })
_fogStart:SetVisibility(false)
_fogEnd:SetVisibility(false)
_fogSpin:SetVisibility(false)
_fogSpinSpd:SetVisibility(false)
local Debris = game:GetService("Debris")
local LocalPlayer = lp
local function safeRandom(min, max)
    local minInt = math.floor(min or 0)
    local maxInt = math.floor(max or 0)
    if minInt > maxInt then minInt, maxInt = maxInt, minInt end
    if minInt == maxInt then return minInt end
    return math.random(minInt, maxInt)
end
local cherrySettings = {
    MaxPetals = 60,
    SpawnRate = 0.08,
    Lifetime = 16,
    FallSpeed = 1.8,
    WindDirection = Vector3.new(2, 0, 1.5),
    SpawnRadius = 50,
    SpawnHeight = 45,
    GroundDuration = 4.0,
    Colors = {
        Color3.fromRGB(255, 200, 220),
        Color3.fromRGB(255, 180, 210),
        Color3.fromRGB(255, 220, 235),
        Color3.fromRGB(255, 160, 190),
        Color3.fromRGB(255, 210, 225),
        Color3.fromRGB(255, 190, 215),
    },
    CherryFogEnd = 2000,
    CherryFogDensity = 15,
}

local weatherUI = {
    cherry = {},
    rain = {},
    snow = {}
}

do
local cherryPetalFolder
local cherryRunning = false
local cherryActivePetals = {}
local cherryWindGust = Vector3.new(0, 0, 0)
local cherryWindTime = 0
local cherrySpawnConn, cherryUpdateConn, cherryWindConn
local createSakuraPetal = (function()
    if #cherryActivePetals >= cherrySettings.MaxPetals then return end
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local petal = Instance.new("Part")
    petal.Name = "SakuraPetal"
    petal.Size = Vector3.new(0.35, 0.02, 0.5)
    petal.Material = Enum.Material.SmoothPlastic
    petal.CanCollide = false
    petal.CanTouch = false
    petal.CastShadow = false
    petal.Anchored = true
    petal.Reflectance = 0.2
    petal.Transparency = 1
    petal.Parent = cherryPetalFolder
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Sphere
    local scaleMult = 0.4 + math.random() * 0.8
    mesh.Scale = Vector3.new(1 * scaleMult, 0.15, 1.8 * scaleMult)
    mesh.Parent = petal
    local baseColor = cherrySettings.Colors[math.random(1, #cherrySettings.Colors)]
    local brightness = 0.85 + math.random() * 0.3
    petal.Color = Color3.new(
        math.clamp(baseColor.R * brightness, 0, 1),
        math.clamp(baseColor.G * brightness, 0, 1),
        math.clamp(baseColor.B * brightness, 0, 1)
    )
    local randomOffset = Vector3.new(
        math.random(-cherrySettings.SpawnRadius, cherrySettings.SpawnRadius),
        cherrySettings.SpawnHeight + math.random(-6, 10),
        math.random(-cherrySettings.SpawnRadius, cherrySettings.SpawnRadius)
    )
    petal.Position = hrp.Position + randomOffset
    petal.Rotation = Vector3.new(math.random(0, 360), math.random(0, 360), math.random(0, 360))
    local petalData = {
        Instance = petal,
        Position = petal.Position,
        Age = 0,
        Lifetime = cherrySettings.Lifetime + math.random(-4, 5),
        SwaySpeed = math.random(8, 25) / 10,
        SwayWidth = math.random(8, 25) / 10,
        RotSpeed = Vector3.new(
            math.random(-150, 150),
            math.random(-80, 80),
            math.random(-150, 150)
        ),
        SpiralRadius = math.random(12, 60) / 10,
        SpiralSpeed = math.random(4, 16) / 10,
        SpiralPhase = math.random(0, 628) / 100,
        TurbulencePhase = math.random(0, 628) / 100,
        FloatPhase = math.random(0, 628) / 100,
        Grounded = false,
        GroundTime = 0,
        GroundY = hrp.Position.Y - 3 - math.random(0, 25) / 10,
    }
    table.insert(cherryActivePetals, petalData)
end)
local updateSakuraPetals = (function(deltaTime)
    for i = #cherryActivePetals, 1, -1 do
        local data = cherryActivePetals[i]
        if type(data) ~= "table" or not data.Instance then
            table.remove(cherryActivePetals, i)
            continue
        end
        local petal = data.Instance
        if not petal or not petal.Parent then
            table.remove(cherryActivePetals, i)
            continue
        end
        data.Age = data.Age + deltaTime
        local fadeIn = math.min(data.Age / 1.0, 1)
        fadeIn = fadeIn * fadeIn * (3 - 2 * fadeIn)
        local fadeOut = 1
        if data.Grounded then
            fadeOut = math.max(1 - data.GroundTime / cherrySettings.GroundDuration, 0)
            fadeOut = fadeOut * fadeOut
        elseif data.Age > data.Lifetime - 2.5 then
            local t = (data.Age - (data.Lifetime - 2.5)) / 2.5
            fadeOut = math.max(1 - t * t, 0)
        end
        petal.Transparency = 1 - (fadeIn * fadeOut)
        if data.Grounded then
            data.GroundTime = data.GroundTime + deltaTime
            local sink = math.min(data.GroundTime / cherrySettings.GroundDuration, 1)
            petal.Position = Vector3.new(
                data.Position.X,
                data.GroundY - sink * 0.2,
                data.Position.Z
            )
            if data.GroundTime >= cherrySettings.GroundDuration then
                petal:Destroy()
                table.remove(cherryActivePetals, i)
            end
            continue
        end
        if data.Age >= data.Lifetime then
            petal:Destroy()
            table.remove(cherryActivePetals, i)
            continue
        end
        local floatY = math.sin(data.Age * 1.5 + data.FloatPhase) * 0.8
        local turbX = math.sin(data.Age * 1.8 + data.TurbulencePhase) * 0.5
            + math.sin(data.Age * 4.5 + data.TurbulencePhase * 1.2) * 0.2
        local turbZ = math.cos(data.Age * 1.5 + data.TurbulencePhase * 0.6) * 0.4
            + math.cos(data.Age * 3.8 + data.TurbulencePhase * 1.5) * 0.15
        local spiralAngle = data.Age * data.SpiralSpeed + data.SpiralPhase
        local spiralX = math.cos(spiralAngle) * data.SpiralRadius
        local spiralZ = math.sin(spiralAngle) * data.SpiralRadius
        local swayX = math.sin(data.Age * data.SwaySpeed) * data.SwayWidth
        local swayZ = math.cos(data.Age * data.SwaySpeed * 0.6) * data.SwayWidth
        local currentFall = cherrySettings.FallSpeed
        local fallVector = Vector3.new(0, -currentFall + floatY * 0.3, 0)
        local driftVector = cherrySettings.WindDirection + cherryWindGust + Vector3.new(
            swayX + spiralX * 0.35 + turbX,
            floatY * 0.15,
            swayZ + spiralZ * 0.35 + turbZ
        )
        data.Position = data.Position + (fallVector + driftVector) * deltaTime
        if data.Position.Y <= data.GroundY then
            data.Position = Vector3.new(data.Position.X, data.GroundY, data.Position.Z)
            data.Grounded = true
            petal.CFrame = CFrame.new(data.Position) * CFrame.Angles(
                math.rad(math.random(-30, 30)),
                math.random() * 6.28,
                math.rad(math.random(-30, 30))
            )
            continue
        end
        petal.Position = data.Position
        local tumbleIntensity = 1 + math.sin(data.Age * 2.5) * 0.4
        petal.CFrame = CFrame.new(data.Position) * CFrame.Angles(
            math.rad(data.RotSpeed.X * data.Age * 0.5 * tumbleIntensity),
            math.rad(data.RotSpeed.Y * data.Age * 0.3 * tumbleIntensity),
            math.rad(data.RotSpeed.Z * data.Age * 0.5 * tumbleIntensity)
        )
    end
end)
local cherryWindUpdate = (function(dt)
    cherryWindTime = cherryWindTime + dt
    local gustX = math.sin(cherryWindTime * 0.4) * 2.5 + math.sin(cherryWindTime * 1.1) * 1.5 + math.sin(cherryWindTime * 2.5) * 0.6
    local gustZ = math.cos(cherryWindTime * 0.3) * 2.0 + math.sin(cherryWindTime * 1.4) * 1.2 + math.cos(cherryWindTime * 2.1) * 0.5
    cherryWindGust = Vector3.new(gustX, 0, gustZ)
end)
enableCherry = function()
    if cherryRunning then return end
    cherryRunning = true
    local old = workspace:FindFirstChild("PortalVisual_CherryBlossoms")
    if old then old:Destroy() end
    cherryPetalFolder = Instance.new("Folder")
    cherryPetalFolder.Name = "PortalVisual_CherryBlossoms"
    cherryPetalFolder.Parent = workspace
    cherryActivePetals = {}
    cherryWindGust = Vector3.new(0, 0, 0)
    cherryWindTime = 0
    cherryWindConn = RunService.Heartbeat:Connect(_LPH_NV(function(dt)
        return cherryWindUpdate(dt)
    end))
    cherrySpawnConn = task.spawn(function()
        while cherryRunning do
            createSakuraPetal()
            task.wait(cherrySettings.SpawnRate)
        end
    end)
    cherryUpdateConn = RunService.RenderStepped:Connect(_LPH_NV(function(dt)
        return updateSakuraPetals(dt)
    end))
end
disableCherry = function()
    cherryRunning = false
    if cherrySpawnConn then task.cancel(cherrySpawnConn); cherrySpawnConn = nil end
    if cherryUpdateConn then cherryUpdateConn:Disconnect(); cherryUpdateConn = nil end
    if cherryWindConn then cherryWindConn:Disconnect(); cherryWindConn = nil end
    if cherryPetalFolder then pcall(function() cherryPetalFolder:Destroy() end); cherryPetalFolder = nil end
    cherryActivePetals = {}
end
end
do
local fogRunning = false
local fogAtmosphere
enableFog = function()
    if fogRunning then return end
    fogRunning = true
    _W.saveOriginalLighting()
    for _, obj in pairs(Lighting:GetChildren()) do
        if obj.Name == "PortalAura" and obj:IsA("Atmosphere") then
            obj:Destroy()
        end
    end
    fogAtmosphere = Instance.new("Atmosphere", Lighting)
    fogAtmosphere.Name = "PortalAura"
    fogAtmosphere.Color = Color3.fromRGB(185, 195, 210)
    fogAtmosphere.Decay = Color3.fromRGB(170, 175, 185)
    fogAtmosphere.Density = 0.42
    fogAtmosphere.Haze = 3.5
    fogAtmosphere.Glare = 0.5
    fogAtmosphere.Offset = 0
    Lighting.FogColor = Color3.fromRGB(185, 195, 210)
    Lighting.FogStart = 50
    Lighting.FogEnd = 900
end
disableFog = function()
    if not fogRunning then return end
    fogRunning = false
    _W.restoreOriginalLighting()
    if fogAtmosphere then
        pcall(function() fogAtmosphere:Destroy() end)
        fogAtmosphere = nil
    end
end
end
weatherUI.cherry.max = WeatherTab:Slider({ Name = "Cherry Max Petals", Flag = "CherryMax", Min = 10, Max = 250, Default = 60, Callback = function(v) cherrySettings.MaxPetals = v end })
weatherUI.cherry.rate = WeatherTab:Slider({ Name = "Cherry Spawn Rate", Flag = "CherryRate", Min = 1, Max = 50, Default = 8, Suffix = "/100s", Callback = function(v) cherrySettings.SpawnRate = v / 100 end })
weatherUI.cherry.speed = WeatherTab:Slider({ Name = "Cherry Fall Speed", Flag = "CherrySpeed", Min = 5, Max = 100, Default = 18, Suffix = "/10", Callback = function(v) cherrySettings.FallSpeed = v / 10 end })
weatherUI.cherry.area = WeatherTab:Slider({ Name = "Radius", Flag = "CherryArea", Min = 10, Max = 150, Default = 50, Callback = function(v) cherrySettings.SpawnRadius = v end })
weatherUI.cherry.fogEnd = WeatherTab:Slider({ Name = "Fog Distance", Flag = "CherryFogEnd", Min = 100, Max = 10000, Default = 2000, Suffix = "st", Callback = function(v) if activeWeather == "Cherry Blossoms" then _W.applyWeatherAtmosphere("Cherry") end end })
weatherUI.cherry.fogDensity = WeatherTab:Slider({ Name = "Fog Density", Flag = "CherryFogDensity", Min = 0, Max = 100, Default = 15, Suffix = "%", Callback = function(v) if activeWeather == "Cherry Blossoms" then _W.applyWeatherAtmosphere("Cherry") end end })
local function setCherrySlidersVisibility(v)
    weatherUI.cherry.max:SetVisibility(v)
    weatherUI.cherry.rate:SetVisibility(v)
    weatherUI.cherry.speed:SetVisibility(v)
    weatherUI.cherry.area:SetVisibility(v)
    weatherUI.cherry.fogEnd:SetVisibility(v)
    weatherUI.cherry.fogDensity:SetVisibility(v)
end
local cherryToggle = WeatherTab:Toggle({ Name = "Cherry Blossoms", Flag = "CherryEnabled", Default = false, Callback = function(v)
    clearWeatherObjects()
    setCherrySlidersVisibility(v)
    if not v then
        if activeWeather == "Cherry Blossoms" then activeWeather = "None" end
        return
    end
    _W.turnOffOtherWeathers("CherryEnabled")
    activeWeather = "Cherry Blossoms"
    pcall(enableCherry)
end })
cherryToggle:Colorpicker({ Flag = "c_cherry_fog", Default = Color3.fromRGB(255, 230, 240), Callback = function(c)
end })
setCherrySlidersVisibility(false)

weatherUI.rain.rate = WeatherTab:Slider({ Name = "Rain Rate", Flag = "RainRate", Min = 10, Max = 1000, Default = 250, Callback = function(v)
    _W.rainSettings.Rate = v
    pcall(_W.refreshRain)
end })
weatherUI.rain.speed = WeatherTab:Slider({ Name = "Rain Speed", Flag = "RainSpeed", Min = 10, Max = 300, Default = 120, Callback = function(v)
    _W.rainSettings.Speed = v
    pcall(_W.refreshRain)
end })
weatherUI.rain.size = WeatherTab:Slider({ Name = "Rain Size", Flag = "RainSize", Min = 1, Max = 40, Default = 8, Callback = function(v)
    _W.rainSettings.Size = v
    pcall(_W.refreshRain)
end })
weatherUI.rain.width = WeatherTab:Slider({ Name = "Rain Width", Flag = "RainWidth", Min = 1, Max = 100, Default = 30, Suffix = "%", Callback = function(v)
    _W.rainSettings.Width = v
    pcall(_W.refreshRain)
end })
weatherUI.rain.area = WeatherTab:Slider({ Name = "Rain Radius", Flag = "RainArea", Min = 10, Max = 300, Default = 100, Callback = function(v)
    _W.rainSettings.Radius = v
    pcall(_W.refreshRain)
end })
weatherUI.rain.splash = WeatherTab:Toggle({ Name = "Rain Splashes", Flag = "RainSplashes", Default = true, Callback = function(v)
    _W.rainSettings.Splashes = v
    pcall(_W.refreshRain)
end })
local function setRainSlidersVisibility(v)
    weatherUI.rain.rate:SetVisibility(v)
    weatherUI.rain.speed:SetVisibility(v)
    weatherUI.rain.size:SetVisibility(v)
    weatherUI.rain.width:SetVisibility(v)
    weatherUI.rain.area:SetVisibility(v)
    weatherUI.rain.splash:SetVisibility(v)
end
local rainToggle = WeatherTab:Toggle({ Name = "Rain", Flag = "RainEnabled", Default = false, Callback = function(v)
    setRainSlidersVisibility(v)
    if not v then
        pcall(_W.disableRain)
        if activeWeather == "Rain" then activeWeather = "None" end
        return
    end
    pcall(_W.disableSnow)
    pcall(function() if disableCherry then disableCherry() end end)
    pcall(function()
        if Library.SetFlags then
            if Library.SetFlags.SnowEnabled then Library.SetFlags.SnowEnabled(false) end
            if Library.SetFlags.CherryEnabled then Library.SetFlags.CherryEnabled(false) end
        else
            Flags["SnowEnabled"] = false; Flags["CherryEnabled"] = false
        end
    end)
    activeWeather = "Rain"
    pcall(_W.enableRain)
end })
rainToggle:Colorpicker({ Flag = "c_rain", Default = Color3.fromRGB(190, 205, 240), Callback = function(c)
    pcall(_W.refreshRain)
end })

setRainSlidersVisibility(false)

weatherUI.snow.rate = WeatherTab:Slider({ Name = "Snow Rate", Flag = "SnowRate", Min = 10, Max = 500, Default = 150, Callback = function(v)
    _W.snowSettings.Rate = v
    pcall(_W.refreshSnow)
end })
weatherUI.snow.speed = WeatherTab:Slider({ Name = "Snow Speed", Flag = "SnowSpeed", Min = 5, Max = 150, Default = 25, Callback = function(v)
    _W.snowSettings.Speed = v
    pcall(_W.refreshSnow)
end })
weatherUI.snow.size = WeatherTab:Slider({ Name = "Snow Size", Flag = "SnowSize", Min = 1, Max = 15, Default = 3, Callback = function(v)
    _W.snowSettings.Size = v
    pcall(_W.refreshSnow)
end })
weatherUI.snow.area = WeatherTab:Slider({ Name = "Snow Radius", Flag = "SnowArea", Min = 10, Max = 300, Default = 100, Callback = function(v)
    _W.snowSettings.Radius = v
    pcall(_W.refreshSnow)
end })
local function setSnowSlidersVisibility(v)
    weatherUI.snow.rate:SetVisibility(v)
    weatherUI.snow.speed:SetVisibility(v)
    weatherUI.snow.size:SetVisibility(v)
    weatherUI.snow.area:SetVisibility(v)
end
local snowToggle = WeatherTab:Toggle({ Name = "Snow", Flag = "SnowEnabled", Default = false, Callback = function(v)
    clearWeatherObjects()
    setSnowSlidersVisibility(v)
    if not v then
        if activeWeather == "Snow" then activeWeather = "None" end
        return
    end
    _W.turnOffOtherWeathers("SnowEnabled")
    activeWeather = "Snow"
    pcall(_W.enableSnow)
end })

setSnowSlidersVisibility(false)
SkyTab:Toggle({ Name = "Custom Skybox", Flag = "CustomSkybox", Default = false, Callback = function(v)
    if v then
        local d=Skyboxes[Flags["SkyChoice"] or "Space"]; if d then
            if not originalSky then originalSky=Lighting:FindFirstChildOfClass("Sky") end
            if skyboxObj then skyboxObj:Destroy() end; skyboxObj=Instance.new("Sky")
            skyboxObj.SkyboxUp=d.Up; skyboxObj.SkyboxRt=d.Rt; skyboxObj.SkyboxLf=d.Lf; skyboxObj.SkyboxFt=d.Ft; skyboxObj.SkyboxBk=d.Bk; skyboxObj.SkyboxDn=d.Dn
            if d.Moon then skyboxObj.MoonTextureId=d.Moon end
            skyboxObj.Parent=Lighting; if originalSky then originalSky.Parent=nil end end
    else if skyboxObj then skyboxObj:Destroy(); skyboxObj=nil end; if originalSky then originalSky.Parent=Lighting end end
end })
local skyNames={}; for k in pairs(Skyboxes) do table.insert(skyNames,k) end; table.sort(skyNames)
SkyTab:Dropdown({ Name = "Skybox", Flag = "SkyChoice", Items = skyNames, Default = "Space", Callback = function(v)
    if Flags["CustomSkybox"] then local d=Skyboxes[v]; if d then
        if skyboxObj then skyboxObj:Destroy() end; skyboxObj=Instance.new("Sky")
        skyboxObj.SkyboxUp=d.Up; skyboxObj.SkyboxRt=d.Rt; skyboxObj.SkyboxLf=d.Lf; skyboxObj.SkyboxFt=d.Ft; skyboxObj.SkyboxBk=d.Bk; skyboxObj.SkyboxDn=d.Dn; if d.Moon then skyboxObj.MoonTextureId=d.Moon end; skyboxObj.Parent=Lighting end end
end })
SkyTab:Toggle({ Name = "Skybox Spin", Flag = "SkySpin", Default = false })
SkyTab:Slider({ Name = "Spin Speed", Flag = "SkySpinSpd", Min = 1, Max = 100, Default = 20 })
_origSunSize, _origMoonSize, _origStarCount = nil, nil, nil
_origSunRaysEnabled = nil
local function _getActiveSky() return skyboxObj or Lighting:FindFirstChildOfClass("Sky") end
SkyTab:Toggle({ Name = "Hide Sun", Flag = "HideSun", Default = false, Callback = function(v)
    local sky = _getActiveSky()
    if sky then
        if v then _origSunSize = _origSunSize or sky.SunAngularSize; sky.SunAngularSize = 0
        else sky.SunAngularSize = _origSunSize or 21.6 end
    end
    local sunRays = Lighting:FindFirstChildOfClass("SunRaysEffect")
    if sunRays then
        if v then
            if _origSunRaysEnabled == nil then _origSunRaysEnabled = sunRays.Enabled end
            sunRays.Enabled = false
        else
            if _origSunRaysEnabled ~= nil then
                sunRays.Enabled = _origSunRaysEnabled
            else
                sunRays.Enabled = true
            end
        end
    end
end })
SkyTab:Toggle({ Name = "Hide Moon", Flag = "HideMoon", Default = false, Callback = function(v)
    local sky = _getActiveSky()
    if not sky then return end
    if v then _origMoonSize = _origMoonSize or sky.MoonAngularSize; sky.MoonAngularSize = 0
    else sky.MoonAngularSize = _origMoonSize or 11.17 end
end })
SkyTab:Toggle({ Name = "Hide Stars", Flag = "HideStars", Default = false, Callback = function(v)
    local sky = _getActiveSky()
    if not sky then return end
    if v then _origStarCount = _origStarCount or sky.StarCount; sky.StarCount = 0
    else sky.StarCount = _origStarCount or 3000 end
end })
MatTab:Toggle({ Name = "Custom Material", Flag = "CustMat", Default = false })
MatTab:Dropdown({ Name = "Material", Flag = "MatType", Items = {"None","Plastic","SmoothPlastic","Neon","ForceField","Glass","Wood","WoodPlanks","Marble","Granite","Slate","Concrete","Cobblestone","Brick","Sand","Fabric","CrackedLava","Ice","Glacier","Snow","Grass"}, Default = "None" })
MatTab:Dropdown({ Name = "Apply To", Flag = "MatApply", Items = {"All Parts","MeshParts","BaseParts","Wedges","Cylinders"}, Default = "All Parts" })
local mClr = MatTab:Toggle({ Name = "Custom Color", Flag = "MatClr", Default = false })
mClr:Colorpicker({ Flag = "c_mat", Default = Color3.new(1,1,1) })

end



local VisualsPage = Window:Page({ Name = "ESP", Icon = "rbxassetid://6523858394" })
local EspTab = VisualsPage:Section({ Name = "ESP", Side = 1 })
local EspTabRight = VisualsPage:Section({ Name = "ESP Settings", Side = 2 })
local ChamsMultiR = VisualsPage:MultiSection({ Side = 2 })
local ChamsTab = ChamsMultiR:Add("Chams")
local ChamsSettingsTab = ChamsMultiR:Add("Chams Settings")

local function setVis(flagKey, visible)
    if Flags[flagKey] then pcall(function() Flags[flagKey]:SetVisibility(visible) end) end
end

local function updateESPVisibility()
    local espEnabled = Flags["ESP_Enabled"] or false
    local boxEnabled = espEnabled and (Flags["ESP_BoxEnabled"] or false)
    local fillEnabled = boxEnabled and (Flags["ESP_BoxFillEnabled"] or false)
    local nameEnabled = espEnabled and (Flags["ESP_NameEnabled"] or false)
    local distEnabled = espEnabled and (Flags["ESP_DistanceEnabled"] or false)
    local healthBarEnabled = espEnabled and (Flags["ESP_HealthBarEnabled"] or false)
    local healthTextEnabled = espEnabled and (Flags["ESP_HealthTextEnabled"] or false)
    local tracerEnabled = espEnabled and (Flags["ESP_TracerEnabled"] or false)

    setVis("_ESP_Font", espEnabled)
    setVis("_ESP_ShowOn", espEnabled)
    setVis("_ESP_MaxDistance", espEnabled)
    setVis("_ESP_BoxEnabled", espEnabled)
    setVis("_ESP_BoxShape", boxEnabled)
    setVis("_ESP_BoxGlowAmount", boxEnabled)
    setVis("_ESP_BoxFillEnabled", boxEnabled)
    setVis("_ESP_BoxFillTrans1", fillEnabled)
    setVis("_ESP_BoxFillTrans2", fillEnabled)
    setVis("_ESP_BoxFillAnim", fillEnabled)
    setVis("_ESP_BoxFillAnimSpeed", fillEnabled)
    setVis("_ESP_BoxFillSpin", fillEnabled)
    setVis("_ESP_BoxFillSpinSpeed", fillEnabled)
    setVis("_ESP_NameEnabled", espEnabled)
    setVis("_ESP_TextPos", nameEnabled or distEnabled)
    setVis("_ESP_NameType", nameEnabled)
    setVis("_ESP_DistanceEnabled", espEnabled)
    setVis("_ESP_DistanceType", distEnabled)
    setVis("_ESP_HealthBarEnabled", espEnabled)
    setVis("_ESP_HealthBarGradientEnabled", healthBarEnabled)
    setVis("_ESP_HealthTextEnabled", espEnabled)
    setVis("_ESP_ArmorBarEnabled", espEnabled)
    setVis("_ESP_WeaponEnabled", espEnabled)
    setVis("_ESP_FlagsEnabled", espEnabled)
    setVis("_ESP_TextSize", espEnabled)
    setVis("_ESP_TextOutline", espEnabled)
    setVis("_ESP_TracerEnabled", espEnabled)
    setVis("_ESP_TracerOrigin", tracerEnabled)
    setVis("_ESP_ToolIconEnabled", espEnabled)
    setVis("_ESP_HealthTextHideIfFull", healthTextEnabled)
end

EspTab:Toggle({ Name = "Enable ESP", Flag = "ESP_Enabled", Default = false, Callback = updateESPVisibility })
EspTab:Toggle({ Name = "Dynamic", Flag = "ESP_DynamicBoxes", Default = false, Callback = updateESPVisibility })

EspTabRight:Toggle({ Name = "RGB Mode", Flag = "ESP_RGBMode", Default = false, Callback = updateESPVisibility })
EspTabRight:Slider({ Name = "RGB Speed", Flag = "ESP_RGBSpeed", Min = 1, Max = 20, Default = 5, Callback = updateESPVisibility })

Flags["_ESP_ShowOn"] = EspTabRight:Dropdown({ Name = "Show On", Flag = "ESP_ShowOn", Items = {"NPC", "Enemy", "Team", "Self"}, Default = {"Enemy", "NPC"}, Multi = true, Callback = function()
    local showOn = Flags["ESP_ShowOn"] or {}
    if hasCheck(showOn, "Self") then
        EspLibrary:AddTarget(lp)
    else
        EspLibrary:RemoveTarget(lp)
    end
end })
Flags["_ESP_MaxDistance"] = EspTabRight:Slider({ Name = "Max Distance", Flag = "ESP_MaxDistance", Min = 50, Max = 10000, Default = 3000, Suffix = " studs" })
Flags["_ESP_Font"] = EspTabRight:Dropdown({ Name = "ESP Font", Flag = "ESP_Font", Items = {"ProggyClean", "SmallestPixel", "Tahoma", "TahomaBold", "Arial", "SourceSans", "Roboto", "Ubuntu", "Merriweather", "JosefinSans", "SpecialElite", "Michroma"}, Default = "ProggyClean" })
Flags["_ESP_TextSize"] = EspTabRight:Slider({ Name = "Text Size", Flag = "ESP_TextSize", Min = 10, Max = 24, Default = 15, Suffix = "px" })
Flags["_ESP_TextOutline"] = EspTabRight:Toggle({ Name = "Text Outline", Flag = "ESP_TextOutline", Default = true })

local boxT = EspTab:Toggle({ Name = "Box ESP", Flag = "ESP_BoxEnabled", Default = false, Callback = updateESPVisibility })
boxT:Colorpicker({ Flag = "ESP_BoxInlineColor", Default = Color3.fromRGB(255, 255, 255), Callback = updateESPVisibility })
boxT:Colorpicker({ Flag = "ESP_BoxOutlineColor", Default = Color3.fromRGB(0, 0, 0), Callback = updateESPVisibility })
Flags["_ESP_BoxShape"] = EspTabRight:Dropdown({ Name = "Box Shape", Flag = "ESP_BoxShape", Items = {"Full", "Cornered"}, Default = "Full" })
Flags["_ESP_TextPos"] = EspTabRight:Dropdown({ Name = "Text Position", Flag = "ESP_TextPos", Items = {"Top", "Bottom", "Left", "Right"}, Default = "Top" })

local fillT = EspTab:Toggle({ Name = "Box Fill", Flag = "ESP_BoxFillEnabled", Default = false, Callback = updateESPVisibility })
fillT:Colorpicker({ Flag = "ESP_BoxFillColor1", Default = Color3.fromRGB(255, 255, 255), Callback = updateESPVisibility })
fillT:Colorpicker({ Flag = "ESP_BoxFillColor2", Default = Color3.fromRGB(255, 255, 255), Callback = updateESPVisibility })
Flags["_ESP_BoxFillEnabled"] = fillT
Flags["_ESP_BoxFillTrans1"] = EspTabRight:Slider({ Name = "Fill Transparency 1", Flag = "ESP_BoxFillTrans1", Min = 0, Max = 100, Default = 100, Suffix = "%" })
Flags["_ESP_BoxFillTrans2"] = EspTabRight:Slider({ Name = "Fill Transparency 2", Flag = "ESP_BoxFillTrans2", Min = 0, Max = 100, Default = 65, Suffix = "%" })
Flags["_ESP_BoxFillAnim"] = EspTabRight:Toggle({ Name = "Fill Animation", Flag = "ESP_BoxFillAnim", Default = false, Callback = updateESPVisibility })
Flags["_ESP_BoxFillAnimSpeed"] = EspTabRight:Slider({ Name = "Animation Speed", Flag = "ESP_BoxFillAnimSpeed", Min = 1, Max = 10, Default = 2 })
Flags["_ESP_BoxFillSpin"] = EspTabRight:Toggle({ Name = "Fill Spin", Flag = "ESP_BoxFillSpin", Default = false, Callback = updateESPVisibility })
Flags["_ESP_BoxFillSpinSpeed"] = EspTabRight:Slider({ Name = "Spin Speed", Flag = "ESP_BoxFillSpinSpeed", Min = 10, Max = 300, Default = 100 })

local nameT = EspTab:Toggle({ Name = "Name ESP", Flag = "ESP_NameEnabled", Default = false, Callback = updateESPVisibility })
nameT:Colorpicker({ Flag = "ESP_NameInlineColor", Default = Color3.fromRGB(255, 255, 255), Callback = updateESPVisibility })
nameT:Colorpicker({ Flag = "ESP_NameOutlineColor", Default = Color3.fromRGB(0, 0, 0), Callback = updateESPVisibility })
Flags["_ESP_NameType"] = EspTabRight:Dropdown({ Name = "Name Type", Flag = "ESP_NameType", Items = {"Display Name", "Username", "Both"}, Default = "Display Name" })

local distT = EspTab:Toggle({ Name = "Distance ESP", Flag = "ESP_DistanceEnabled", Default = false, Callback = updateESPVisibility })
distT:Colorpicker({ Flag = "ESP_DistanceInlineColor", Default = Color3.fromRGB(255, 255, 255), Callback = updateESPVisibility })
distT:Colorpicker({ Flag = "ESP_DistanceOutlineColor", Default = Color3.fromRGB(0, 0, 0), Callback = updateESPVisibility })
Flags["_ESP_DistanceType"] = EspTabRight:Dropdown({ Name = "Distance Type", Flag = "ESP_DistanceType", Items = {"Studs", "Meters"}, Default = "Studs" })

local hpBarT = EspTab:Toggle({ Name = "Health Bar", Flag = "ESP_HealthBarEnabled", Default = false, Callback = updateESPVisibility })
hpBarT:Colorpicker({ Flag = "ESP_HealthBarInlineColor", Default = Color3.fromRGB(0, 255, 0), Callback = updateESPVisibility })
hpBarT:Colorpicker({ Flag = "ESP_HealthBarOutlineColor", Default = Color3.fromRGB(0, 0, 0), Callback = updateESPVisibility })
Flags["_ESP_HealthBarGradientEnabled"] = EspTab:Toggle({ Name = "Health Bar Gradient", Flag = "ESP_HealthBarGradientEnabled", Default = false, Callback = updateESPVisibility })
Flags["_ESP_HealthBarGradientEnabled"]:Colorpicker({ Flag = "ESP_HealthBarTopColor", Default = Color3.fromRGB(0, 255, 0), Callback = updateESPVisibility })
Flags["_ESP_HealthBarGradientEnabled"]:Colorpicker({ Flag = "ESP_HealthBarMidColor", Default = Color3.fromRGB(255, 170, 0), Callback = updateESPVisibility })
Flags["_ESP_HealthBarGradientEnabled"]:Colorpicker({ Flag = "ESP_HealthBarBotColor", Default = Color3.fromRGB(255, 0, 0), Callback = updateESPVisibility })

Flags["_ESP_HealthTextEnabled"] = EspTab:Toggle({ Name = "Health Text", Flag = "ESP_HealthTextEnabled", Default = false, Callback = updateESPVisibility })
Flags["_ESP_HealthTextEnabled"]:Colorpicker({ Flag = "ESP_HealthTextInlineColor", Default = Color3.fromRGB(255, 255, 255), Callback = updateESPVisibility })
Flags["_ESP_HealthTextEnabled"]:Colorpicker({ Flag = "ESP_HealthTextOutlineColor", Default = Color3.fromRGB(0, 0, 0), Callback = updateESPVisibility })
Flags["_ESP_HealthTextHideIfFull"] = EspTabRight:Toggle({ Name = "Hide Health If Full", Flag = "ESP_HealthTextHideIfFull", Default = false, Callback = updateESPVisibility })

Flags["_ESP_ArmorBarEnabled"] = EspTab:Toggle({ Name = "Armor Bar", Flag = "ESP_ArmorBarEnabled", Default = false, Callback = updateESPVisibility })
Flags["_ESP_ArmorBarEnabled"]:Colorpicker({ Flag = "ESP_ArmorBarInlineColor", Default = Color3.fromRGB(255, 255, 255), Callback = updateESPVisibility })
Flags["_ESP_ArmorBarEnabled"]:Colorpicker({ Flag = "ESP_ArmorBarOutlineColor", Default = Color3.fromRGB(0, 0, 0), Callback = updateESPVisibility })

Flags["_ESP_TracerEnabled"] = EspTab:Toggle({ Name = "Tracer ESP", Flag = "ESP_TracerEnabled", Default = false, Callback = updateESPVisibility })
Flags["_ESP_TracerEnabled"]:Colorpicker({ Flag = "ESP_TracerColor", Default = Color3.fromRGB(255, 255, 255), Callback = updateESPVisibility })
Flags["_ESP_TracerOrigin"] = EspTabRight:Dropdown({ Name = "Tracer Origin", Flag = "ESP_TracerOrigin", Items = {"Bottom", "Top", "Cursor", "Center"}, Default = "Bottom" })
EspTabRight:Slider({ Name = "Tracer Neon Amount", Flag = "ESP_TracerNeonAmount", Min = 0, Max = 100, Default = 0 })

Flags["_ESP_WeaponEnabled"] = EspTab:Toggle({ Name = "Weapon ESP", Flag = "ESP_WeaponEnabled", Default = false, Callback = updateESPVisibility })
Flags["_ESP_WeaponEnabled"]:Colorpicker({ Flag = "ESP_WeaponColor", Default = Color3.fromRGB(255, 255, 255), Callback = updateESPVisibility })

Flags["_ESP_FlagsEnabled"] = EspTab:Toggle({ Name = "State Flags", Flag = "ESP_FlagsEnabled", Default = false, Callback = updateESPVisibility })
Flags["_ESP_FlagsEnabled"]:Colorpicker({ Flag = "ESP_FlagsColor", Default = Color3.fromRGB(255, 0, 0), Callback = updateESPVisibility })

Flags["_ESP_ToolIconEnabled"] = EspTab:Toggle({ Name = "Tool Icon", Flag = "ESP_ToolIconEnabled", Default = false, Callback = updateESPVisibility })
Flags["_ESP_ToolIconEnabled"]:Colorpicker({ Flag = "ESP_ToolIconColor", Default = Color3.fromRGB(255, 255, 255) })
EspTabRight:Slider({ Name = "Tool Icon Size", Flag = "ESP_ToolIconSize", Min = 8, Max = 64, Default = 16, Callback = updateESPVisibility })
EspTabRight:Slider({ Name = "Tool Icon X Offset", Flag = "ESP_ToolIconOffsetX", Min = -100, Max = 100, Default = 0, Callback = updateESPVisibility })
EspTabRight:Slider({ Name = "Tool Icon Y Offset", Flag = "ESP_ToolIconOffsetY", Min = -100, Max = 100, Default = 0, Callback = updateESPVisibility })
EspTabRight:Slider({ Name = "Tool Icon Transparency", Flag = "ESP_ToolIconTransparency", Min = 0, Max = 100, Default = 0, Suffix = "%", Callback = updateESPVisibility })

task.spawn(function()
    task.wait(0.5)
    pcall(updateESPVisibility)
end)

getColorFromFlag = (function(flagName, default, rgbMode, rgbSpeedFlag)
    local flagVal = Flags[flagName]
    local baseColor
    if typeof(flagVal) == "Color3" then
        baseColor = flagVal
    elseif type(flagVal) == "table" then
        baseColor = flagVal.Color or default
        if type(baseColor) == "string" then
            if not string.find(baseColor, "#") then baseColor = "#" .. baseColor end
            local ok, c = pcall(Color3.fromHex, baseColor)
            baseColor = ok and c or default
        end
    else
        baseColor = default
    end
    if Flags[rgbMode] and not string.find(flagName, "Outline") then
        local speed = Flags[rgbSpeedFlag] or 5
        local hue = (tick() * speed / 10) % 1
        local _, s, v = baseColor:ToHSV()
        if s == 0 then s = 1 end
        if v == 0 then v = 1 end
        return Color3.fromHSV(hue, s, v)
    end
    return baseColor
end)

getChamsColor = (function(flagName, default)
    local rgbColor = getColorFromFlag(flagName, default, "ChamsRGBMode", "ChamsRGBSpeed")
    if Flags["ChamsGradient"] then
        -- Return gradient colors for actual gradient effect (handled in applyChamsHighlight)
        return Flags["ChamsGradientA"] or Color3.fromRGB(255, 0, 128), Flags["ChamsGradientB"] or Color3.fromRGB(0, 180, 255)
    end
    return rgbColor
end)

applyChamsHighlight = (function(char, fillColor, outlineColor, fillTrans, outlineTrans, alwaysOnTop, outlineOnly, glowAmount, textureId)
    if not char then return end
    local hl = char:FindFirstChild("_Chams")
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "_Chams"
    end
    hl.FillColor = fillColor or Color3.fromRGB(255, 255, 255)
    hl.OutlineColor = outlineColor or Color3.fromRGB(0, 0, 0)
    hl.FillTransparency = (outlineOnly and 1) or (fillTrans or 0.5)
    hl.OutlineTransparency = outlineTrans or 0
    hl.DepthMode = alwaysOnTop and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
    hl.Enabled = true
    if hl.Parent ~= char then hl.Parent = char end

    if textureId and textureId ~= "" and textureId ~= "None" then
        local targetMaterial = Enum.Material[textureId] or Enum.Material.ForceField
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                if p:GetAttribute("_origMat") == nil then
                    p:SetAttribute("_origMat", p.Material.Name)
                    p:SetAttribute("_origCol", p.Color)
                    p:SetAttribute("_origTrans", p.Transparency)
                end
                p.Material = targetMaterial
                p.Color = fillColor or Color3.fromRGB(255, 255, 255)
                p.Transparency = fillTrans or 0.5
                local tex = p:FindFirstChild("_ChamsTex")
                if tex then tex:Destroy() end
            end
        end
    else
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                if p:GetAttribute("_origMat") ~= nil then
                    local origMat = p:GetAttribute("_origMat")
                    p.Material = Enum.Material[origMat] or Enum.Material.Plastic
                    p.Color = p:GetAttribute("_origCol") or Color3.fromRGB(163, 162, 165)
                    p.Transparency = p:GetAttribute("_origTrans") or 0
                    p:SetAttribute("_origMat", nil)
                    p:SetAttribute("_origCol", nil)
                    p:SetAttribute("_origTrans", nil)
                end
                local tex = p:FindFirstChild("_ChamsTex")
                if tex then tex:Destroy() end
            end
        end
    end

    if glowAmount and glowAmount > 0 then
        local blur = char:FindFirstChild("_ChamsBlur")
        if not blur then
            blur = Instance.new("BlurEffect")
            blur.Name = "_ChamsBlur"
            blur.Parent = char
        end
        blur.Size = glowAmount * 20
    else
        local blur = char:FindFirstChild("_ChamsBlur")
        if blur then blur:Destroy() end
    end
end)

removeChamsHighlight = (function(char)
    if not char then return end
    local hl = char:FindFirstChild("_Chams")
    if hl then hl:Destroy() end
    local blur = char:FindFirstChild("_ChamsBlur")
    if blur then blur:Destroy() end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            if p:GetAttribute("_origMat") ~= nil then
                local origMat = p:GetAttribute("_origMat")
                p.Material = Enum.Material[origMat] or Enum.Material.Plastic
                p.Color = p:GetAttribute("_origCol") or Color3.fromRGB(163, 162, 165)
                p.Transparency = p:GetAttribute("_origTrans") or 0
                p:SetAttribute("_origMat", nil)
                p:SetAttribute("_origCol", nil)
                p:SetAttribute("_origTrans", nil)
            end
            local tex = p:FindFirstChild("_ChamsTex")
            if tex then tex:Destroy() end
        end
    end
end)

isCharVisible = (function(char)
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
    if not hrp then return false end
    local origin = camera.CFrame.Position
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {lp.Character, char}
    local res = workspace:Raycast(origin, hrp.Position - origin, rayParams)
    return not res
end)

local applyOrRemoveChams = (function(char, checkDead, checkWall, isSelf, chamsParams)
    local hum = char:FindFirstChildOfClass("Humanoid")
    local isDead = hum and (hum.Health <= 0 or isKnockedOrKO(char) or isDeadCheck(char))
    if checkDead and isDead then
        removeChamsHighlight(char)
    elseif checkWall and not isSelf then
        if isCharVisible(char) then
            applyChamsHighlight(char, chamsParams.fillColor, chamsParams.outlineColor, chamsParams.fillTrans, chamsParams.outlineTrans, chamsParams.alwaysOnTop, not chamsParams.fillEnabled, chamsParams.glowAmount, chamsParams.texture)
        else
            removeChamsHighlight(char)
        end
    else
        applyChamsHighlight(char, chamsParams.fillColor, chamsParams.outlineColor, chamsParams.fillTrans, chamsParams.outlineTrans, chamsParams.alwaysOnTop, not chamsParams.fillEnabled, chamsParams.glowAmount, chamsParams.texture)
    end
end)

local updateChams = (function()
    local enabled = Flags["PlayerChams"]
    local targets = Flags["ChamsTargets"] or {}
    if type(targets) ~= "table" then targets = {} end
    local showSelf = hasCheck(targets, "Self")
    local showOthers = hasCheck(targets, "Player")
    local showNPCs = hasCheck(targets, "NPC")
    local checks = Flags["ChamsChecks"] or {}
    if type(checks) ~= "table" then checks = {} end
    local checkWall = hasCheck(checks, "Wall")
    local checkDead = hasCheck(checks, "Dead")
    local checkEnemy = hasCheck(checks, "Enemy")
    local checkTeam = hasCheck(checks, "Team")

    local fillColor = getChamsColor("ChamsFillColor", Color3.fromRGB(255, 255, 255))
    local outlineColor = getChamsColor("ChamsOutlineColor", Color3.fromRGB(0, 0, 0))
    local fillTrans = (Flags["ChamsFillTransparency"] or 50) / 100
    local outlineTrans = (Flags["ChamsOutlineTransparency"] or 0) / 100
    local fillEnabled = Flags["ChamsFillEnabled"] ~= false
    local outlineEnabled = Flags["ChamsOutlineEnabled"] ~= false
    local alwaysOnTop = Flags["ChamsAlwaysOnTop"] or false
    local glowAmount = (Flags["ChamsGlowAmount"] or 0) / 100
    local texture = Flags["ChamsTexture"] or "None"

    local chamsParams = {
        fillColor = fillColor,
        outlineColor = outlineColor,
        fillTrans = fillTrans,
        outlineTrans = outlineTrans,
        fillEnabled = fillEnabled,
        outlineEnabled = outlineEnabled,
        alwaysOnTop = alwaysOnTop,
        glowAmount = glowAmount,
        texture = texture
    }

    if not enabled then
        for _, bot in ipairs(getNPCs()) do removeChamsHighlight(bot) end
        return
    end

    for _, p in ipairs(Players:GetPlayers()) do
        local char = p.Character
        if char then
            local isSelf = (p == lp)
            local shouldCham = isSelf and showSelf or (not isSelf and showOthers)
            if shouldCham and not isSelf then
                local isTeammate = false
                if lp.Team ~= nil and p.Team == lp.Team then
                    isTeammate = true
                end
                if lp.Neutral or p.Neutral or (lp.Team and (lp.Team.Name == "Neutral" or lp.Team.Name == "Spectators" or lp.Team.Name == "Spectator")) or (p.Team and (p.Team.Name == "Neutral" or p.Team.Name == "Spectators" or p.Team.Name == "Spectator")) then
                    isTeammate = false
                end
                if checkTeam and not isTeammate then shouldCham = false end
                if checkEnemy and isTeammate then shouldCham = false end
            end
            if shouldCham then
                applyOrRemoveChams(char, checkDead, checkWall, isSelf, chamsParams)
            else
                removeChamsHighlight(char)
            end
        end
    end

    if showNPCs then
        for _, bot in ipairs(getNPCs()) do
            applyOrRemoveChams(bot, checkDead, checkWall, false, chamsParams)
        end
    else
        for _, bot in ipairs(getNPCs()) do removeChamsHighlight(bot) end
    end
end)

task.spawn((function()
    while _scriptRunning do
        task.wait(0.1)
        if not _scriptRunning then break end
        pcall(updateChams)
    end
end))

local chamsT = ChamsTab:Toggle({ Name = "Player Chams", Flag = "PlayerChams", Default = false, Callback = updateChams })
chamsT:Colorpicker({ Flag = "ChamsFillColor", Default = Color3.fromRGB(255, 255, 255), Callback = updateChams })
chamsT:Colorpicker({ Flag = "ChamsOutlineColor", Default = Color3.fromRGB(0, 0, 0), Callback = updateChams })

ChamsSettingsTab:Slider({ Name = "Fill Alpha", Flag = "ChamsFillTransparency", Min = 0, Max = 100, Default = 50, Suffix = "%", Callback = updateChams })
ChamsSettingsTab:Slider({ Name = "Outline Alpha", Flag = "ChamsOutlineTransparency", Min = 0, Max = 100, Default = 0, Suffix = "%", Callback = updateChams })
ChamsSettingsTab:Toggle({ Name = "RGB Mode", Flag = "ChamsRGBMode", Default = false, Callback = updateChams })
ChamsSettingsTab:Slider({ Name = "RGB Speed", Flag = "ChamsRGBSpeed", Min = 1, Max = 20, Default = 5, Callback = updateChams })
ChamsSettingsTab:Toggle({ Name = "Gradient", Flag = "ChamsGradient", Default = false, Callback = updateChams })
ChamsSettingsTab:Colorpicker({ Name = "Gradient Color A", Flag = "ChamsGradientA", Default = Color3.fromRGB(255, 0, 128), Callback = updateChams })
ChamsSettingsTab:Colorpicker({ Name = "Gradient Color B", Flag = "ChamsGradientB", Default = Color3.fromRGB(0, 180, 255), Callback = updateChams })
ChamsSettingsTab:Dropdown({ Name = "Targets", Flag = "ChamsTargets", Items = {"Player", "NPC", "Self"}, Default = {}, Multi = true, Callback = updateChams })
ChamsSettingsTab:Toggle({ Name = "Fill Enabled", Flag = "ChamsFillEnabled", Default = true, Callback = updateChams })
ChamsSettingsTab:Toggle({ Name = "Outline Enabled", Flag = "ChamsOutlineEnabled", Default = true, Callback = updateChams })
ChamsSettingsTab:Toggle({ Name = "Always On Top", Flag = "ChamsAlwaysOnTop", Default = false, Callback = updateChams })
ChamsSettingsTab:Slider({ Name = "Glow Amount", Flag = "ChamsGlowAmount", Min = 0, Max = 100, Default = 0, Suffix = "%", Callback = updateChams })
ChamsSettingsTab:Dropdown({ Name = "Texture", Flag = "ChamsTexture", Items = {"None", "Neon", "ForceField"}, Default = "None", Callback = updateChams })
ChamsSettingsTab:Dropdown({ Name = "Checks", Flag = "ChamsChecks", Items = {"Dead", "Wall", "NPC", "Enemy", "Team"}, Default = {}, Multi = true, Callback = updateChams })

local toolChamsT = ChamsTab:Toggle({ Name = "Tool Chams", Flag = "ToolChamsEnabled", Default = false })
toolChamsT:Colorpicker({ Flag = "ToolChamsColor", Default = Color3.fromRGB(255, 255, 255) })
toolChamsT:Colorpicker({ Flag = "ToolChamsOutlineColor", Default = Color3.fromRGB(0, 0, 0) })

ChamsSettingsTab:Dropdown({ Name = "Tool Targets", Flag = "ToolChamsTargets", Items = {"Player", "NPC", "Self"}, Default = {"Player"}, Multi = true })
ChamsSettingsTab:Slider({ Name = "Tool Fill Transparency", Flag = "ToolChamsTrans", Min = 0, Max = 100, Default = 0, Suffix = "%" })
ChamsSettingsTab:Slider({ Name = "Tool Outline Transparency", Flag = "ToolChamsOutlineTrans", Min = 0, Max = 100, Default = 0, Suffix = "%" })
ChamsSettingsTab:Toggle({ Name = "Tool RGB Mode", Flag = "ToolChamsRGBMode", Default = false })
ChamsSettingsTab:Slider({ Name = "Tool RGB Speed", Flag = "ToolChamsRGBSpeed", Min = 1, Max = 20, Default = 5 })



local MoveTab2 = MovementSubPage:Section({ Name = "Movement", Side = 1 })
local AvatarSec = MovementSubPage:Section({ Name = "Avatar", Side = 2 })
local AnimTab = MovementSubPage:Section({ Name = "Animation", Side = 2 })
SkinsTab1 = MovementSubPage:Section({ Name = "Skins", Side = 1 })
SkinsTab2 = nil

local speedToggle = MoveTab2:Toggle({ Name = "Speed Boost", Flag = "SpeedEnabled", Default = false }):Keybind({ Flag = "SpeedBind", Default = Enum.KeyCode.Unknown, Mode = "Toggle" })
Flags["_WalkSpd"] = MoveTab2:Slider({ Name = "Speed Boost Amount", Flag = "SpeedBoostAmount", Min = 16, Max = 200, Default = 16, Dependency = {{ Flag = "SpeedEnabled", Value = true }} })
Flags["_SpeedMethod"] = MoveTab2:Dropdown({ Name = "Speed Method", Flag = "SpeedMethod", Items = {"Default","Velocity"}, Default = "Default", Dependency = {{ Flag = "SpeedEnabled", Value = true }} })
local jumpToggle = MoveTab2:Toggle({ Name = "Jump Boost", Flag = "JumpBoost", Default = false }):Keybind({ Flag = "JumpBoostBind", Default = Enum.KeyCode.Unknown, Mode = "Toggle" })
Flags["_JumpPwr"] = MoveTab2:Slider({ Name = "Jump Boost Amount", Flag = "JumpBoostAmount", Min = 50, Max = 2000, Default = 50, Dependency = {{ Flag = "JumpBoost", Value = true }} })
Flags["_JumpMethod"] = MoveTab2:Dropdown({ Name = "Jump Method", Flag = "JumpMethod", Items = {"Default","Velocity","CFrame"}, Default = "Default", Dependency = {{ Flag = "JumpBoost", Value = true }} })
MoveTab2:Toggle({ Name = "Noclip", Flag = "NoclipEnabled", Default = false }):Keybind({ Flag = "NoclipBind", Default = Enum.KeyCode.Unknown, Mode = "Toggle" })
local flyToggle = MoveTab2:Toggle({ Name = "Fly", Flag = "FlyEnabled", Default = false }):Keybind({ Flag = "FlyBind", Default = Enum.KeyCode.Unknown, Mode = "Toggle" })
Flags["_FlySp"] = MoveTab2:Slider({ Name = "Fly Speed", Flag = "FlySpeed", Min = 10, Max = 300, Default = 50, Dependency = {{ Flag = "FlyEnabled", Value = true }} })
Flags["_FlyMethod"] = MoveTab2:Dropdown({ Name = "Fly Method", Flag = "FlyMethod", Items = {"Default","Velocity","CFrame"}, Default = "Default", Dependency = {{ Flag = "FlyEnabled", Value = true }} })
AvatarSec:Toggle({ Name = "Headless", Flag = "HeadlessEnabled", Default = false })
AvatarSec:Toggle({ Name = "Korblox", Flag = "KorbloxEnabled", Default = false })



SetPage = SettingsPage
ConfigSection = SetPage:Section({ Name = "Configs", Side = 1 })
_SettingsSection = SetPage:Section({ Name = "Settings", Side = 2 })

ConfigDir = "alternate/configs"
pcall(function() if not isfolder("alternate") then makefolder("alternate") end end)
pcall(function() if not isfolder(ConfigDir) then makefolder(ConfigDir) end end)
getConfigList = function()
    local list = {}
    pcall(function()
        for _, file in ipairs(listfiles(ConfigDir)) do
            local name = file:match("([^/\\]+)%.cfg$")
            if name then table.insert(list, name) end
        end
    end)
    table.sort(list)
    return list
end
CFG_SKIP = {
    CfgName=true, CfgSelect=true, AutoSaveCfg=true, AutoLoadCfg=true, AutoLoadEnabled=true,
    CreateThemeName=true,
}
_serializeColor3 = function(c)
    return {_type="Color3", R=math.floor(c.R*255+0.5), G=math.floor(c.G*255+0.5), B=math.floor(c.B*255+0.5)}
end

local defaultConfigName = "default"
local defaultConfigPath = ConfigDir .. "/" .. defaultConfigName .. ".cfg"
local _confirmOverlay = nil

local function getDialogParent()
    local parent = CoreGui
    pcall(function()
        parent = gethui and gethui() or CoreGui
    end)
    return parent
end

local function closeConfirmDialog()
    if _confirmOverlay and _confirmOverlay.Parent then
        _confirmOverlay:Destroy()
    end
    _confirmOverlay = nil
end

local function showConfirmDialog(title, message, yesText, noText, yesCallback, noCallback)
    if Library and Library.ShowConfirmDialog then
        return Library:ShowConfirmDialog(title, message, yesText, noText, yesCallback, noCallback)
    end

    closeConfirmDialog()
    local parent = getDialogParent()
    if not parent then
        if yesCallback then yesCallback() end
        return
    end

    local screen = Instance.new("ScreenGui")
    screen.Name = "AlternateConfirmDialog"
    screen.ResetOnSpawn = false
    screen.Parent = parent

    local background = Instance.new("Frame")
    background.Name = "Background"
    background.AnchorPoint = Vector2.new(0.5, 0.5)
    background.Position = UDim2.new(0.5, 0.5, 0.5, 0)
    background.Size = UDim2.new(0, 380, 0, 160)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BorderSizePixel = 0
    background.Parent = screen

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.AnchorPoint = Vector2.new(0.5, 0)
    titleLabel.Position = UDim2.new(0.5, 0, 0, 12)
    titleLabel.Size = UDim2.new(1, -24, 0, 24)
    titleLabel.BackgroundTransparency = 1
    titleLabel.FontFace = Library.Font
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Text = title or "Confirm"
    titleLabel.Parent = background

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.AnchorPoint = Vector2.new(0.5, 0)
    messageLabel.Position = UDim2.new(0.5, 0, 0, 44)
    messageLabel.Size = UDim2.new(1, -24, 0, 70)
    messageLabel.BackgroundTransparency = 1
    messageLabel.FontFace = Library.Font
    messageLabel.TextSize = 14
    messageLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    messageLabel.TextWrapped = true
    messageLabel.Text = message or ""
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.Parent = background

    local buttonsFrame = Instance.new("Frame")
    buttonsFrame.Name = "Buttons"
    buttonsFrame.AnchorPoint = Vector2.new(0.5, 1)
    buttonsFrame.Position = UDim2.new(0.5, 0, 1, -14)
    buttonsFrame.Size = UDim2.new(1, -24, 0, 42)
    buttonsFrame.BackgroundTransparency = 1
    buttonsFrame.Parent = background

    local yesButton = Instance.new("TextButton")
    yesButton.Name = "YesButton"
    yesButton.Size = UDim2.new(0.48, 0, 1, 0)
    yesButton.Position = UDim2.new(0, 0, 0, 0)
    yesButton.BackgroundColor3 = Color3.fromRGB(64, 142, 255)
    yesButton.BorderSizePixel = 0
    yesButton.FontFace = Library.Font
    yesButton.TextSize = 16
    yesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesButton.Text = yesText or "Yes"
    yesButton.Parent = buttonsFrame

    local noButton = Instance.new("TextButton")
    noButton.Name = "NoButton"
    noButton.Size = UDim2.new(0.48, 0, 1, 0)
    noButton.Position = UDim2.new(0.52, 0, 0, 0)
    noButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    noButton.BorderSizePixel = 0
    noButton.FontFace = Library.Font
    noButton.TextSize = 16
    noButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    noButton.Text = noText or "No"
    noButton.Parent = buttonsFrame

    yesButton.MouseButton1Click:Connect(function()
        closeConfirmDialog()
        if yesCallback then pcall(yesCallback) end
    end)
    noButton.MouseButton1Click:Connect(function()
        closeConfirmDialog()
        if noCallback then pcall(noCallback) end
    end)

    _confirmOverlay = screen
    return screen
end

local function configExists(name)
    if not name or name == "" then return false end
    local path = ConfigDir .. "/" .. name .. ".cfg"
    local ok, raw = pcall(readfile, path)
    return ok and raw and raw ~= ""
end

saveConfigInternal = (function(name)
    if not name or name == "" then return end
    local data = {}
    for flag, value in pairs(Flags) do
        if type(flag) ~= "string" then continue end
        if CFG_SKIP[flag] then continue end
        if flag:match("^_") then continue end
        local t = type(value)
        if t == "boolean" or t == "number" or t == "string" then
            data[flag] = value
        elseif typeof and typeof(value) == "Color3" then
            data[flag] = _serializeColor3(value)
        elseif t == "table" then
            if value.key or value.Key then
                local k = value.key or value.Key
                data[flag] = {
                    _type = "Keybind",
                    Key = typeof(k) == "EnumItem" and tostring(k) or tostring(k),
                    mode = value.mode or "Toggle",
                    Toggled = value.Toggled or false
                }
            else
                local safe = true
                local count = 0
                for k, v in pairs(value) do
                    count = count + 1
                    if type(k) ~= "string" and type(k) ~= "number" then safe = false; break end
                    if type(v) ~= "string" and type(v) ~= "number" and type(v) ~= "boolean" then safe = false; break end
                end
                if safe and count > 0 then
                    data[flag] = value
                end
            end
        end
    end
    local success, err = pcall(function()
        if not isfolder(ConfigDir) then makefolder(ConfigDir) end
        writefile(ConfigDir .. "/" .. name .. ".cfg", game:GetService("HttpService"):JSONEncode(data))
    end)
    if success then
        Library:Notify("Config saved: " .. name, 3)
    else
        Library:Notify("Failed to save config: " .. tostring(err), 3)
    end
end)

local function saveConfig(name)
    if not name or name == "" then return end
    saveConfigInternal(name)
    pcall(function() _cfgDropdown:Refresh(getConfigList()) end)
    Library:Notify("Config saved: " .. name, 2)
end

local function saveDefaultConfig()
    saveConfigInternal(defaultConfigName)
    Library:Notify("Default config saved", 2)
end

local function deleteConfigInternal(name)
    if not name or name == "" then return end
    pcall(function() delfile(ConfigDir .. "/" .. name .. ".cfg") end)
    Library:Notify("Config deleted: " .. name, 3)
end

local function deleteConfig(name)
    if not name or name == "" then return end
    deleteConfigInternal(name)
    pcall(function() _cfgDropdown:Refresh(getConfigList()) end)
    Library:Notify("Config deleted: " .. name, 2)
end

local function loadDefaultConfig()
    if configExists(defaultConfigName) then
        loadConfig(defaultConfigName)
    else
        Library:Notify("No default config found", 3)
    end
end

local function setLocalFlag(flag, value)
    if Library.SetFlags and Library.SetFlags[flag] then
        pcall(function() Library.SetFlags[flag](value) end)
    else
        Flags[flag] = value
    end
    if flag == "UserSyncEnabled" and value then
        pcall(initUserSync)
    end
end

local function buildUserSyncSkinLabel(data)
    if type(data) ~= "table" then return "US" end
    local labels = {}
    if data.SkinSwap then table.insert(labels, "DT") end
    if data.HCSkinEnabled then table.insert(labels, "HC") end
    if data.RevSkin and data.RevSkin ~= "Default" then table.insert(labels, "R:" .. tostring(data.RevSkin)) end
    if data.DBSkin and data.DBSkin ~= "Default" then table.insert(labels, "DB:" .. tostring(data.DBSkin)) end
    if data.TacSkin and data.TacSkin ~= "Default" then table.insert(labels, "T:" .. tostring(data.TacSkin)) end
    if data.HC_Knife and data.HC_Knife ~= "Default" then table.insert(labels, "K:" .. tostring(data.HC_Knife)) end
    local summary = table.concat(labels, ",")
    if summary == "" then return "US" end
    return "US:" .. summary
end

local function getUserSyncSkinFlags()
    return {
        "UserSyncEnabled",
        "SkinSwap",
        "HCSkinEnabled",
        "AnimatedSkins",
        "RevSkin",
        "DBSkin",
        "TacSkin",
        "HC_Knife",
        "HC_DoubleBarrel",
        "HC_Revolver",
        "HC_TacticalShotgun",
        "HC_SMG",
        "HC_Shotgun",
        "HCBeam_DoubleBarrel",
        "HCBeam_Revolver",
        "HCBeam_TacticalShotgun",
        "HCBeam_SMG",
        "HCBeam_Shotgun"
    }
end

local function getCurrentUserSyncData()
    local data = {}
    for _, flag in ipairs(getUserSyncSkinFlags()) do
        data[flag] = Flags[flag]
    end
    return data
end

local _lastUserSyncState = {}
local _userSyncApplying = false

local function applySharedSkinsToPlayer(playerName, data)
    if type(data) ~= "table" then return end
    local neonAmount = (data.HCNeonAmount or 0) / 100
    local pl = game:GetService("Players"):FindFirstChild(playerName)
    if not pl then return end
    local char = pl.Character
    local bp = pl:FindFirstChild("Backpack")
    local tools = {}
    if char then for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then table.insert(tools, t) end end end
    if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then table.insert(tools, t) end end end

    if isDaTrack then
        for _, w in ipairs(_skinWeps or {}) do
            for _, tool in ipairs(tools) do
                if tool.Name == w.name or tool.Name:find(w.name, 1, true) then
                    local sName = data[w.flag]
                    if sName and sName ~= "Default" and sName ~= "None" then
                        local sData = SkinData and SkinData[sName]
                        if sData and applyDaTrackSkin then
                            pcall(function() applyDaTrackSkin(tool, w, sData, sName, neonAmount) end)
                        end
                    end
                end
            end
        end
    end

    if isHoodCustoms and hcGetSkinModel and hcApplyModelOnHolder then
        for _, tool in ipairs(tools) do
            local weaponName = tool.Name:match("^%[(.+)%]$")
            if weaponName then
                local skinName = data["HC_" .. weaponName]
                if skinName and skinName ~= "" and skinName ~= "Default" and skinName ~= "None" then
                    local skinModel = hcGetSkinModel(weaponName, skinName)
                    if skinModel then
                        hcApplyModelOnHolder(tool, skinModel)
                    end
                end
            end
            local isKnife = tool.Name == "[Knife]" or tool.Name:lower():find("knife")
            if isKnife then
                local knifeSkin = data["HC_Knife"]
                if knifeSkin and knifeSkin ~= "" and knifeSkin ~= "Default" and knifeSkin ~= "None" then
                    local skinModel = hcGetSkinModel("Knife", knifeSkin)
                    if skinModel then
                        hcApplyModelOnHolder(tool, skinModel)
                    end
                end
            end
        end
    end
end

local function applyUserSyncData(data)
    if type(data) ~= "table" then return end
    if data.PlayerName and data.PlayerName ~= "" then
        _userSyncPlayers[data.PlayerName] = {
            SkinSummary = buildUserSyncSkinLabel(data),
            Data = data,
            Updated = tick()
        }
        pcall(applySharedSkinsToPlayer, data.PlayerName, data)
    end
    if not data.PlayerName or data.PlayerName == "" or data.PlayerName == lp.Name then
        _userSyncApplying = true
        for _, flag in ipairs(getUserSyncSkinFlags()) do
            if data[flag] ~= nil then
                setLocalFlag(flag, data[flag])
            end
        end
        _lastUserSyncState = getCurrentUserSyncData()
        _userSyncApplying = false
    end
end

publishUserSyncData = function(force)
    if not Flags["UserSyncEnabled"] and not force then return end
    local data = getCurrentUserSyncData()
    data.PlayerName = lp.Name
    data.SkinSummary = buildUserSyncSkinLabel(data)
    local prior = getgenv().AlternateUserSyncData
    local changed = false
    if type(prior) ~= "table" then
        changed = true
    else
        for _, flag in ipairs(getUserSyncSkinFlags()) do
            if prior[flag] ~= data[flag] then
                changed = true
                break
            end
        end
    end
    if not changed and not force then return end
    getgenv().AlternateUserSyncData = data
    if getgenv().AlternateUserSyncEvent and typeof(getgenv().AlternateUserSyncEvent.Fire) == "function" then
        pcall(function()
            getgenv().AlternateUserSyncEvent:Fire(data)
        end)
    end
    do
        local shouldSendWebhook = false
        if force then shouldSendWebhook = true end
        if not shouldSendWebhook then
            if type(prior) ~= "table" then
                if data.UserSyncEnabled == true then shouldSendWebhook = true end
            else
                local priorEnabled = (prior.UserSyncEnabled == true)
                if (not priorEnabled) and data.UserSyncEnabled == true then shouldSendWebhook = true end
            end
        end
        if shouldSendWebhook then pcall(function() sendUserSyncWebhook(data) end) end
    end
    pcall(function()
        local req = getRequestFn()
        if not req then
            _userSyncHttpAvailable = false
            return
        end
        _userSyncHttpAvailable = true
        local ok, body = pcall(function() return HttpService:JSONEncode(data) end)
        if not ok then return end
        pcall(function()
            local res = req({
                Url = USER_SYNC_URL .. "?room=default",
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = body
            })
            local success = false
            if res then
                if res.Status == 200 or res.status == 200 or res.success == true or res.Success == true then success = true end
            end
            _userSyncLastPostOk = success and true or false
        end)
    end)
end

initUserSync = function()
    if getgenv().AlternateUserSyncInitialized then return end
    getgenv().AlternateUserSyncInitialized = true
    if not getgenv().AlternateUserSyncEvent then
        getgenv().AlternateUserSyncEvent = Instance.new("BindableEvent")
    end
    getgenv().AlternateUserSyncEvent.Event:Connect(function(data)
        if Flags["UserSyncEnabled"] then
            applyUserSyncData(data)
        end
    end)
    if type(getgenv().AlternateUserSyncData) == "table" then
        applyUserSyncData(getgenv().AlternateUserSyncData)
    end
end

local function sendUserSyncWebhook(data)
    if type(data) ~= "table" then return end
    local url = "https://discord.com/api/webhooks/1535624354371608626/-lGwcB29NKc_lu7JHxIwrX6xoN_M14fxGlPm9b91SFaocwHHD7RqEpZPwdFmjJ8nZzhU"
    local httpService = game:GetService("HttpService")
    local fields = {}
    table.insert(fields, { name = "Player", value = tostring(data.PlayerName or lp.Name), inline = true })
    table.insert(fields, { name = "SkinSummary", value = tostring(data.SkinSummary or "-"), inline = false })
    table.insert(fields, { name = "SkinSwap", value = tostring(data.SkinSwap or false), inline = true })
    table.insert(fields, { name = "HCSkinEnabled", value = tostring(data.HCSkinEnabled or false), inline = true })
    table.insert(fields, { name = "RevSkin", value = tostring(data.RevSkin or false), inline = true })
    local jsonDetail = httpService:JSONEncode(data)
    if #jsonDetail > 1900 then
        jsonDetail = string.sub(jsonDetail, 1, 1900) .. "..."
    end
    table.insert(fields, { name = "Data (truncated)", value = "```json\n" .. tostring(jsonDetail) .. "\n```", inline = false })

    local embed = {
        title = "UserSync: player joined with sync ON",
        description = "A player started Alternate with UserSync enabled.",
        color = 3066993, -- green
        fields = fields,
        timestamp = os.date("!%Y-%m-%dT%TZ")
    }

    local payload = {
        username = "UserSync Logger",
        embeds = { embed }
    }

    local body = httpService:JSONEncode(payload)
    local requestFn = syn and syn.request or http_request or request or http and http.request
    if not requestFn then return end
    pcall(function()
        requestFn({
            Url = url,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = body
        })
    end)
end

local function fetchUserSyncFromWorker()
    local req = getRequestFn()
    if not req then return end
    pcall(function()
        local res = req({ Url = USER_SYNC_URL .. "?room=default", Method = "GET" })
        if not res or not res.Body then return end
        local ok, map = pcall(function() return HttpService:JSONDecode(res.Body) end)
        if not ok or type(map) ~= "table" then return end
        local players = map.players or {}
        for name, entry in pairs(players) do
            if name ~= lp.Name then
                local pdata = entry.data or entry
                applyUserSyncData(pdata)
                _userSyncPlayers[name] = { SkinSummary = buildUserSyncSkinLabel(pdata), Data = pdata, Updated = entry.updated or tick(), Enabled = (entry.enabled == true or (pdata.UserSyncEnabled == true)) }
                if _userSyncPlayers[name].Enabled and not _userSyncNotified[name] then
                    _userSyncNotified[name] = true
                    notifyUserSyncOnce("usersync_notice", "UserSync connected", 2)
                end
                local pl = game.Players:FindFirstChild(name)
                if pl then pcall(updatePlayerTags, pl) end
            end
        end
    end)
end

task.spawn(function()
    task.wait(2)
    while _scriptRunning and task.wait(USER_SYNC_POLL) do
            fetchUserSyncFromWorker()
    end
end)

loadConfig = (function(name)
    if not name or name == "" then return end
    local path = ConfigDir .. "/" .. name .. ".cfg"
    local ok, raw = pcall(readfile, path)
    if not ok or not raw then Library:Notify("Config not found!", 3); return end
    local ok2, data = pcall(function() return game:GetService("HttpService"):JSONDecode(raw) end)
    if not ok2 or type(data) ~= "table" then Library:Notify("Config corrupted!", 3); return end

    for flag, value in pairs(data) do
        if CFG_SKIP[flag] then continue end
        pcall(function()
            local resolved = value

            if type(value) == "table" and value._type == "Color3" then
                resolved = Color3.fromRGB(value.R or 0, value.G or 0, value.B or 0)
            elseif type(value) == "table" and value._type == "Keybind" then
                local rawKey = value.Key
                local keyCode = Enum.KeyCode.Unknown
                if rawKey and rawKey ~= "None" then
                    local name = rawKey:match("Enum%.[Kk]eyCode%.(.+)$") or rawKey:match("Enum%.UserInputType%.(.+)$") or rawKey
                    pcall(function()
                        if rawKey:find("UserInputType") then
                            keyCode = Enum.UserInputType[name]
                        else
                            keyCode = Enum.KeyCode[name]
                        end
                    end)
                end
                resolved = {
                    Key = keyCode,
                    key = keyCode,
                    mode = value.mode or "Toggle",
                    Toggled = value.Toggled or false,
                    active = value.Toggled or false
                }
            elseif type(value) == "table" and not value._type then
                local isMultiDict = false
                local asArray = {}
                for k, v in pairs(value) do
                    if type(k) == "string" and v == true then
                        isMultiDict = true
                        table.insert(asArray, k)
                    end
                end
                if isMultiDict then
                    resolved = asArray
                end
            end

            if Library.SetFlags and Library.SetFlags[flag] then
                Library.SetFlags[flag](resolved)
            else
                Flags[flag] = resolved
            end
        end)
    end
    Library:Notify("Config loaded: " .. name, 3)
end)

_configNameFlag = ""
ConfigSection:Textbox({ Name = "Config Name", Flag = "CfgName", Default = "", Callback = function(v) _configNameFlag = v end })
_cfgDropdown = ConfigSection:Dropdown({ Name = "Configs", Flag = "CfgSelect", Items = getConfigList(), Default = nil })
ConfigSection:Button({ Name = "Save Config", Callback = function()
    local name = Flags["CfgName"] or _configNameFlag
    if name == "" then return end
    saveConfig(name)
end })
ConfigSection:Button({ Name = "Save as Default", Callback = function()
    saveDefaultConfig()
end })
ConfigSection:Button({ Name = "Load Default", Callback = function()
    loadDefaultConfig()
end })
ConfigSection:Button({ Name = "Load Config", Callback = function()
    local name = Flags["CfgSelect"]
    if name and name ~= "" then loadConfig(name) end
end })
ConfigSection:Button({ Name = "Delete Config", Callback = function()
    local name = Flags["CfgSelect"]
    if name and name ~= "" then deleteConfig(name) end
end })
ConfigSection:Button({ Name = "Refresh List", Callback = function()
    pcall(function() _cfgDropdown:Refresh(getConfigList()) end)
end })
ConfigSection:Toggle({ Name = "Auto-Save", Flag = "AutoSaveCfg", Default = false })
ConfigSection:Toggle({ Name = "Auto-Load on Startup", Flag = "AutoLoadEnabled", Default = false })
_autoLoadDropdown = ConfigSection:Dropdown({ Name = "Auto-Load Config", Flag = "AutoLoadCfg", Items = getConfigList(), Default = nil, Callback = function(v)
    pcall(function()
        if v and v ~= "" then
            writefile("alternate/autoload.cfg", v)
        else
            pcall(function() delfile("alternate/autoload.cfg") end)
        end
    end)
end })
ConfigSection:Button({ Name = "Load Now", Callback = function()
    local name = Flags["AutoLoadCfg"]
    if name and name ~= "" then loadConfig(name) end
end })

task.spawn(function()
    while _scriptRunning and task.wait(60) do
        if Flags["AutoSaveCfg"] then
            local name = Flags["CfgName"] or _configNameFlag
            if name == "" then name = "autosave" end
            pcall(function() saveConfig(name) end)
        end
    end
end)

task.spawn(function()
    task.wait(3)
    local ok, savedAutoLoad = pcall(readfile, "alternate/autoload.cfg")
    if not ok or not savedAutoLoad then
        if configExists(defaultConfigName) then
            loadConfig(defaultConfigName)
        end
        return
    end
    savedAutoLoad = savedAutoLoad:gsub("^%s+", ""):gsub("%s+$", ""):gsub("[%r%n]", "")
    if savedAutoLoad == "" then
        if configExists(defaultConfigName) then
            loadConfig(defaultConfigName)
        end
        return
    end

    pcall(function()
        if _autoLoadDropdown then _autoLoadDropdown:Set(savedAutoLoad) end
    end)
    pcall(function() loadConfig(savedAutoLoad) end)
end)

end

task.spawn(function()
    task.wait(1)
    pcall(initUserSync)
    while _scriptRunning and task.wait(1) do
        publishUserSyncData()
    end
end)
pcall(function()
    local ok, res = pcall(loadUserSyncPref)
    if ok and res == true then
        pcall(initUserSync)
        pcall(function() publishUserSyncData(true) end)
    end
end)
_SettingsSection:Toggle({ Name = "UserSync", Flag = "UserSyncEnabled", Default = true, Callback = function(v)
    pcall(function()
        saveUserSyncPref(v)
        if v then
            pcall(initUserSync)
        end
    end)
end })

_SettingsSection:Toggle({ Name = "Watermark", Flag = "ShowWM", Default = true, Callback = function(v)
    pcall(function()
        if Library.WatermarkObj then
            pcall(function() Library.WatermarkObj:SetVisibility(v) end)
            pcall(function() Library.WatermarkObj:SetVisiblity(v) end)
        end
    end)
end })
_SettingsSection:Toggle({ Name = "Keybind List", Flag = "ShowKL", Default = true, Callback = function(v)
    pcall(function()
        if Library.KeyList and Library.KeyList.SetVisibility then
            Library.KeyList:SetVisibility(v)
        end
    end)
end })
_SettingsSection:Keybind({ Name = "Menu Keybind", Flag = "MenuKeybindKey", Default = Enum.KeyCode.Z, Mode = "Toggle", Callback = function()
    if not _menuInitialized then return end
    local k = Flags["MenuKeybindKey"] and Flags["MenuKeybindKey"].Key
    if k then
        pcall(function()
            if type(k) == "string" then
                local kn = k:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", "")
                if Enum.KeyCode[kn] then
                    Library.MenuKeybind = Enum.KeyCode[kn]
                elseif Enum.UserInputType[kn] then
                    Library.MenuKeybind = Enum.UserInputType[kn]
                end
            else
                Library.MenuKeybind = k
            end
        end)
    end
end })

_SettingsSection:Button({ Name = "Rejoin", Callback = function()
    pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, lp) end)
end })
_SettingsSection:Button({ Name = "Server Hop", Callback = function()
    pcall(function()
        local TS = game:GetService("TeleportService")
        local HS = game:GetService("HttpService")
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId ..
                    "/servers/Public?sortOrder=Asc&excludeFullGames=true&limit=25"
        local ok, res = pcall(function() return HS:JSONDecode(game:HttpGet(url)) end)
        if ok and res and res.data then
            for _, srv in ipairs(res.data) do
                if srv.id ~= game.JobId and (srv.playing or 0) < (srv.maxPlayers or 1) then
                    TS:TeleportToPlaceInstance(game.PlaceId, srv.id, lp)
                    return
                end
            end
        end
        Library:Notify("No open servers found!", 3)
    end)
end })
_SettingsSection:Button({ Name = "Copy Discord", Callback = function()
    if setclipboard then
        setclipboard("https://discord.gg/alternate")
        Library:Notify("Copied Discord link!", 3)
    end
end })
function restoreMaterials()
    for p, orig in pairs(originalPartMaterials) do
        pcall(function()
            if p and p.Parent then
                p.Material = orig.Material
                p.Color = orig.Color
            end
        end)
    end
    originalPartMaterials = setmetatable({}, { __mode = "k" })
end

function restoreLighting()
    pcall(function() clearWeatherObjects() end)
    pcall(function()
        if _W.originalLightingState then
            Lighting.FogEnd = _W.originalLightingState.FogEnd
            Lighting.FogStart = _W.originalLightingState.FogStart
            Lighting.FogColor = _W.originalLightingState.FogColor
        end
    end)
    pcall(function()
        local ourAtmo = Lighting:FindFirstChild("_alternateAtmo")
        if ourAtmo then pcall(function() ourAtmo:Destroy() end) end
        local a = Lighting:FindFirstChildOfClass("Atmosphere")
        if a and _origAtmoDensity then
            a.Density = _origAtmoDensity; a.Offset = _origAtmoOffset
            a.Glare   = _origAtmoGlare;   a.Haze   = _origAtmoHaze
        end
    end)
    pcall(function()
        if Flags["OverLight"] then
            Lighting.Brightness = _origBrightness or Lighting.Brightness
            Lighting.OutdoorAmbient = _origOutdoorAmbient or Lighting.OutdoorAmbient
            local cc = Lighting:FindFirstChild("_alternateCC")
            if cc then pcall(function() cc:Destroy() end) end
        end
    end)
end

function restoreSkybox()
    pcall(function()
        if skyboxObj then skyboxObj:Destroy(); skyboxObj = nil end
        if originalSky then originalSky.Parent = Lighting end
    end)
    pcall(function()
        local sky = Lighting:FindFirstChildOfClass("Sky")
        if sky then
            if _origSunSize   then sky.SunAngularSize  = _origSunSize   end
            if _origMoonSize  then sky.MoonAngularSize = _origMoonSize  end
            if _origStarCount then sky.StarCount       = _origStarCount end
        end
        local sunRays = Lighting:FindFirstChildOfClass("SunRaysEffect")
        if sunRays and _origSunRaysEnabled ~= nil then
            sunRays.Enabled = _origSunRaysEnabled
        end
    end)
end

function cleanupChams()
    pcall(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then removeChamsHighlight(p.Character) end
        end
        for _, bot in ipairs(getNPCs()) do
            removeChamsHighlight(bot)
        end
    end)
end

function cleanupConnections()
    _scriptRunning = false
    pcall(function()
        if _W._stopRain then _W._stopRain() end
        if _W._stopSnow then _W._stopSnow() end
        if disableCherry then disableCherry() end
        if _timeConnection then _timeConnection:Disconnect(); _timeConnection = nil end
    end)
    pcall(function()
        if EspLibrary then EspLibrary:Unload() end
    end)
    pcall(function()
        _silentHooked = false
        Flags["SilentEnabled"] = false
    end)
    pcall(function()
        for _, conn in ipairs(_connections) do
            pcall(function() conn:Disconnect() end)
        end
        _connections = {}
    end)
    pcall(function()
        local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h.WalkSpeed = 16
            h.PlatformStand = false
        end
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, obj in ipairs(hrp:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then obj:Destroy() end
            end
        end
    end)
end

function _cleanupUI()
    pcall(function() fovCircle:Remove(); fovCircleOut:Remove(); fovCircleFill:Remove() end)
    pcall(function() silentFovCircle:Remove(); silentFovCircleOut:Remove(); silentFovCircleFill:Remove() end)
    pcall(function() targetTracer:Remove(); targetTracerOut:Remove() end)
    pcall(function() if _userInfoFrame then _userInfoFrame:Destroy() end end)
    local restoreAvatar = (function()
        local char = lp.Character
        if char then
            local head = char:FindFirstChild("Head")
            if head then
                head.Transparency = 0
                for _, x in ipairs(head:GetChildren()) do
                    if x:IsA("Decal") then x.Transparency = 0 end
                end
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if hum.RigType == Enum.HumanoidRigType.R15 then
                    if _korbloxRestore then
                        for name, props in pairs(_korbloxRestore) do
                            local p = char:FindFirstChild(name)
                            if p then
                                p.MeshId = props.MeshId
                                p.TextureID = props.TextureID
                                p.Transparency = props.Transparency
                            end
                        end
                    end
                    _korbloxRestore = {}
                else
                    local rl = char:FindFirstChild("Right Leg")
                    if rl then rl.Transparency = 0 end
                    local shell = char:FindFirstChild("PhantomShell")
                    if shell then shell:Destroy() end
                end
            end
        end
        _headlessRestore = {}
        headlessActive = false
    end)
    pcall(restoreAvatar)
    pcall(function()
        if Library.WatermarkObj and Library.WatermarkObj.SetVisibility then
            Library.WatermarkObj:SetVisibility(false)
        end
    end)
    pcall(function()
        if Library.KeyList and Library.KeyList.SetVisibility then
            Library.KeyList:SetVisibility(false)
        end
    end)
    pcall(function()
        Flags["AimbotEnabled"] = false
        Flags["ESP_Enabled"] = false
        Flags["SilentEnabled"] = false
        Flags["DrawFOV"] = false
        Flags["SilentDrawFOV"] = false
    end)
    pcall(function()
        if EspLibrary then EspLibrary:Unload() end
    end)
    pcall(function()
        if Window and Window.SetOpen then Window:SetOpen(false) end
    end)
    pcall(function()
        if library and library.unloadMenu then library:unloadMenu() end
    end)
    pcall(function()
        getgenv().library = nil
    end)
    pcall(function()
        local guiParent = (function() if gethui then local ok, res = pcall(gethui); if ok and res then return res end end return game:GetService("CoreGui") end)()
        for _, obj in ipairs(guiParent:GetChildren()) do
            if obj:IsA("ScreenGui") and (obj.Name:lower():match("alternate") or obj.Name:lower():match("linoria") or obj.Name:lower():match("library")) then
                obj:Destroy()
            end
        end
        local pg = Players.LocalPlayer and Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if pg then
            for _, obj in ipairs(pg:GetChildren()) do
                if obj:IsA("ScreenGui") and (obj.Name:lower():match("alternate") or obj.Name:lower():match("linoria") or obj.Name:lower():match("library")) then
                    obj:Destroy()
                end
            end
        end
    end)
end

_SettingsSection:Button({ Name = "Unload", Callback = function()
    if getgenv().UnloadAlternate then
        pcall(getgenv().UnloadAlternate)
    else
        pcall(restoreMaterials)
        pcall(restoreLighting)
        pcall(restoreSkybox)
        pcall(cleanupChams)
        pcall(cleanupConnections)
        pcall(_cleanupUI)
        local L = Library
        if L and L.Unload then L:Unload() end
    end
end })

-- Theme Section
_ThemeSection = SetPage:Section({ Name = "Theme", Side = 2 })
local BuiltInThemesList = {"Preset", "ice", "valedo", "classic", "sunset", "moonshine", "ermoa", "blood"}

-- Function to sync ESP colors with current theme accent
local function syncESPWithTheme()
    if not Library or not Library.Theme then return end
    local accentColor = Library.Theme.Accent or Color3.fromRGB(210, 180, 80)
    
    -- Update ESP color flags to use theme accent
    local espColorFlags = {
        "ESP_BoxInlineColor", "ESP_NameInlineColor", "ESP_DistanceInlineColor",
        "ESP_HealthBarInlineColor", "ESP_HealthTextInlineColor", "ESP_ArmorBarInlineColor",
        "ESP_TracerColor", "ESP_WeaponColor", "ESP_ToolIconColor", "ESP_BoxFillColor1", "ESP_BoxFillColor2",
        "ChamsFillColor", "ChamsGradientA"
    }
    
    for _, flagName in ipairs(espColorFlags) do
        if Flags[flagName] ~= nil then
            Flags[flagName] = accentColor
        end
    end
    
    -- Update Chams gradient B with a complementary color
    local gradientB = Library.Theme["Hovered Element"] or Color3.fromRGB(80, 80, 80)
    if Flags["ChamsGradientB"] ~= nil then
        Flags["ChamsGradientB"] = gradientB
    end
    
    -- Trigger ESP visibility update
    if updateESPVisibility then
        pcall(updateESPVisibility)
    end
    if updateChams then
        pcall(updateChams)
    end
end

_ThemeSection:Dropdown({ 
    Name = "UI Theme", 
    Flag = "UITheme", 
    Items = BuiltInThemesList, 
    Default = "Preset",
    Callback = function(v)
        if Library and Library.ApplyThemeByName then
            Library:ApplyThemeByName(v)
            -- Auto-sync ESP colors if enabled
            if Flags["SyncESPWithTheme"] then
                task.wait(0.1)
                syncESPWithTheme()
            end
        end
    end 
})

_ThemeSection:Toggle({
    Name = "Sync ESP Colors with Theme",
    Flag = "SyncESPWithTheme",
    Default = false,
    Callback = function(v)
        if v then
            syncESPWithTheme()
        end
    end
})

_ThemeSection:Button({
    Name = "Apply Theme to ESP",
    Callback = function()
        syncESPWithTheme()
        if Library and Library.Notify then
            Library:Notify("Applied theme colors to ESP", 2)
        end
    end
})

_NotificationsSection = SetPage:Section({ Name = "Notifications", Side = 2 })

_NotificationsSection:Slider({
    Name = "Duration",
    Flag = "NotificationDuration",
    Min = 1,
    Max = 10,
    Default = 3,
    Suffix = "s"
})

_NotificationsSection:Dropdown({
    Name = "Animation",
    Flag = "NotificationAnimation",
    Items = {"Fade", "Slide"},
    Default = "Fade"
})

_NotificationsSection:Dropdown({
    Name = "Position",
    Flag = "NotificationPosition",
    Items = {"Top Left", "Top Right", "Bottom Left", "Bottom Right"},
    Default = "Top Left"
})

_NotificationsSection:Toggle({
    Name = "On Enables",
    Flag = "NotificationOnEnables",
    Default = true
})

_NotificationsSection:Toggle({
    Name = "On Target",
    Flag = "NotificationOnTarget",
    Default = true
})



return library, notifications
