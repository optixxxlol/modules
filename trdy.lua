-- // Library Init
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/portallol/scripts/main/scripts/hasad.lua"))()
-- // Main Shit
local replicated_storage = game:GetService("ReplicatedStorage")
local user_input_service = game:GetService("UserInputService")
local replicated_first = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local local_player = Players.LocalPlayer
local player_gui = local_player.PlayerGui
local Mouse = local_player:GetMouse()
local Camera = workspace.CurrentCamera
--
local TriggerbotDebounce = false
local TriggerbotLoop = RunService.RenderStepped:Connect(function()
    if not library.flags.tb then return end
    if TriggerbotDebounce then return end

    local SelfCharacter = game.Players.LocalPlayer.Character
    local SelfRootPart, SelfHumanoid = SelfCharacter and SelfCharacter:FindFirstChild("HumanoidRootPart"), SelfCharacter and SelfCharacter:FindFirstChildOfClass("Humanoid")
    if not SelfCharacter or not SelfRootPart or not SelfHumanoid then return end

    local Target = Mouse.Target
    local Player
    if Target and Target.Parent and Players:GetPlayerFromCharacter(Target.Parent) then 
        Player = Players:GetPlayerFromCharacter(Target.Parent)
    end
    if not Target or not Player then return end

    local Character = Player.Character
    local RootPart, Humanoid = Character and Character:FindFirstChild("HumanoidRootPart"), Character and Character:FindFirstChildOfClass("Humanoid")
    if not Character or not RootPart or not Humanoid then return end
    if not Character:FindFirstChild("Head") then return end
    TriggerbotDebounce = true
    task.spawn(function()
        if library.flags.tbdelay/1000 > 1/60 then
            wait(library.flags.tbdelay/1000)
        end
        mouse1press()
        repeat 
            RunService.RenderStepped:Wait()
        until not Mouse.Target or not Mouse.Target.Parent or Players:GetPlayerFromCharacter(Mouse.Target.Parent) ~= Player
        mouse1release()
        TriggerbotDebounce = false
    end)
end)
--
local replicated_storage = game:GetService("ReplicatedStorage")
local user_input_service = game:GetService("UserInputService")
local replicated_first = game:GetService("ReplicatedFirst")
local run_service = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
local local_player = players.LocalPlayer
local player_gui = local_player.PlayerGui
local mouse = local_player:GetMouse()
local camera = workspace.CurrentCamera
local SilentAim = {
    enabled = false,
    targetpart = "Head",
}
local function find_target()
    local target
    local closest = 9e9

    for _,player in pairs (players.GetPlayers(players)) do
        local character = player.Character
        local root_part, humanoid = character and character.FindFirstChild(character, "HumanoidRootPart"), character and character.FindFirstChildOfClass(character, "Humanoid")
        if (not character or not root_part or not humanoid) or (player == local_player) then continue end

        local screen_pos, on_screen = camera.WorldToViewportPoint(camera, root_part.Position)
        if (not on_screen) then continue end

        local distance_from_mouse = (Vector2.new(screen_pos.X, screen_pos.Y) - user_input_service.GetMouseLocation(user_input_service)).Magnitude
        if (distance_from_mouse > 200 or closest < distance_from_mouse) then continue end

        closest = distance_from_mouse
        target = character[SilentAim.targetpart]
    end

    return target
end

local __namecall; __namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if SilentAim.enabled then
        if (method == "Raycast") then
            local target = find_target()
            if (target) then
                args[2] = (target.Position - args[1]).unit * 500
            end
        end
    end

    return __namecall(self, unpack(args))
end)
-- // ESP
local rs = game:GetService("RunService")
local camera = workspace.CurrentCamera
local plr = game.Players.LocalPlayer
local MaximumDistance = 100
local ScrapShit = {
    Enabled = false,
    Bad = false,
    Good = false,
    Rare = false,
    Legendary = false,
    maxdistance = 2500
}
-- // Functions
local function Scrap(v)
    -- // Drawing
    local s = Drawing.new("Text")
    s.Transparency = 1
    s.Visible = false
    s.Color = Color3.new(1,1,1)
    s.Size = 13
    s.Center = true
    s.Outline = true
    s.Font = 2
    --
    local t = Drawing.new("Text")
    t.Transparency = 1
    t.Visible = false
    t.Color = Color3.new(1,1,1)
    t.Size = 13
    t.Center = true
    t.Outline = true
    t.Font = 2
    -- // RenderStepped
    rs.RenderStepped:Connect(function()
        if v.PrimaryPart ~= nil then
            VectorPoint = camera:WorldToViewportPoint(v.PrimaryPart.Position)
            Distance = (camera.CFrame.p - v.PrimaryPart.Position).Magnitude
                if (VectorPoint.Z > 0) then
                    if ScrapShit.maxdistance > (v.PrimaryPart.CFrame.p - workspace.CurrentCamera.CFrame.p).magnitude then
                        if ScrapShit.Enabled then
                            if tostring(v.MeshPart.Particle.Color) == "0 1 1 1 0 1 1 1 1 0 " then
                                if ScrapShit.Bad then
                                    s.Visible = true
                                    s.Position = Vector2.new(VectorPoint.X, VectorPoint.Y)
                                    s.Text = tostring('Scrap'.. " ["..math.ceil(Distance).. "m]")
                                    s.Color = Color3.fromRGB(255,255,255)
                                    --
                                    t.Visible = true
                                    t.Position = Vector2.new(VectorPoint.X, VectorPoint.Y + 13)
                                    t.Text = "Common"
                                    t.Color = Color3.fromRGB(255,255,255)
                                else
                                    t.Visible = false
                                    s.Visible = false
                                end
                            end
                            if tostring(v.MeshPart.Particle.Color) == "0 0.184314 1 0.4 0 1 0.184314 1 0.4 0 " then
                                if ScrapShit.Good then
                                    s.Visible = true
                                    s.Position = Vector2.new(VectorPoint.X, VectorPoint.Y)
                                    s.Text = tostring('Scrap'.. " ["..math.ceil(Distance).. "m]")
                                    s.Color = Color3.fromRGB(255,255,255)
                                    --
                                    t.Visible = true
                                    t.Position = Vector2.new(VectorPoint.X, VectorPoint.Y + 13)
                                    t.Text = "Good"
                                    t.Color = Color3.fromRGB(0,255,0)
                                else
                                    t.Visible = false
                                    s.Visible = false
                                end
                            end
                            if tostring(v.MeshPart.Particle.Color) == "0 1 0.184314 0.184314 0 1 1 0.184314 0.184314 0 " then
                                if ScrapShit.Rare then
                                    s.Visible = true
                                    s.Position = Vector2.new(VectorPoint.X, VectorPoint.Y)
                                    s.Text = tostring('Scrap'.. " ["..math.ceil(Distance).. "m]")
                                    s.Color = Color3.fromRGB(255,255,255)
                                    --
                                    t.Visible = true
                                    t.Position = Vector2.new(VectorPoint.X, VectorPoint.Y + 13)
                                    t.Text = "Rare"
                                    t.Color = Color3.fromRGB(255,0,0)
                                else
                                    t.Visible = false
                                    s.Visible = false
                                end
                            end
                            if tostring(v.MeshPart.Particle.Color) == "0 1 0.666667 0 0 1 1 0.666667 0 0 " then
                                if ScrapShit.Legendary then
                                    s.Visible = true
                                    s.Position = Vector2.new(VectorPoint.X, VectorPoint.Y)
                                    s.Text = tostring('Scrap'.. " ["..math.ceil(Distance).. "m]")
                                    s.Color = Color3.fromRGB(255,255,255)
                                    --
                                    t.Visible = true
                                    t.Position = Vector2.new(VectorPoint.X, VectorPoint.Y + 13)
                                    t.Text = "Legendary"
                                    t.Color = Color3.fromRGB(252, 211, 3)
                                else
                                    s.Visible = false
                                    t.Visible = false
                                end
                            end
                        else
                            s.Visible = false
                            t.Visible = false
                        end
                    else
                        t.Visible = false
                        s.Visible = false
                    end
                else
                    s.Visible = false
                    t.Visible = false
                end
        else
            s.Visible = false
            t.Visible = false
        end
    end)
end
-- // Child Added / Workspace
for i,v in pairs(game.Workspace.Filter.SpawnedPiles:GetChildren()) do
    Scrap(v)
end

game.Workspace.Filter.SpawnedPiles.ChildAdded:Connect(function(v)
    Scrap(v)
end)
-- // Safe ESP
local SafeShit = {
    enabled = false,
    excludebroken = false,
    showsmall = false,
    showmedium = false,
    maxdistance = 2500
}
local function MatchBegin(inputString, matchString)
    return inputString:sub(1, #matchString) == matchString
end
-- // Functions
local function Safe(v)
    -- // Drawing
    local s = Drawing.new("Text")
    s.Transparency = 1
    s.Visible = false
    s.Color = Color3.new(1,1,1)
    s.Size = 13
    s.Center = true
    s.Outline = true
    s.Font = 2
    local r = Drawing.new("Text")
    r.Transparency = 1
    r.Visible = false
    r.Color = Color3.new(1,1,1)
    r.Size = 13
    r.Center = true
    r.Outline = true
    r.Font = 2
    -- // RenderStepped
    rs.RenderStepped:Connect(function()
        if v.PrimaryPart ~= nil then
            ScreenPoint = camera:WorldToViewportPoint(v.PrimaryPart.Position)
            Distance = (camera.CFrame.p - v.PrimaryPart.Position).Magnitude
            if (ScreenPoint.Z > 0) then
                if SafeShit.maxdistance > (v.PrimaryPart.CFrame.p - workspace.CurrentCamera.CFrame.p).magnitude then
                    if SafeShit.enabled then
                        s.Position = Vector2.new(ScreenPoint.X, ScreenPoint.Y)
                        s.Text = tostring('Safe'.. " ["..math.ceil(Distance).. "m]")
                        s.Color = Color3.fromRGB(255,255,255)
                        if SafeShit.showmedium and MatchBegin(v.Name, "MediumSafe") then
                            r.Visible = true
                            r.Position = Vector2.new(ScreenPoint.X, ScreenPoint.Y + 13)
                            s.Visible = true
                            r.Text = "Type [Large]"
                            r.Color = Color3.fromRGB(255,0,0)
                        elseif SafeShit.showsmall and MatchBegin(v.Name, "SmallSafe") then
                            r.Text = "Type [Small]"
                            r.Color = Color3.fromRGB(0,255,0)
                            r.Visible = true
                            r.Position = Vector2.new(ScreenPoint.X, ScreenPoint.Y + 13)
                            s.Visible = true
                        else
                            r.Visible = false
                            s.Visible = false
                        end
                        if v.Values.Broken.Value and SafeShit.excludebroken then
                            r.Visible = false
                            s.Visible = false
                        end
                    else
                        r.Visible = false
                        s.Visible = false
                    end
                else
                    s.Visible = false
                    r.Visible = false
                end
            else
                r.Visible = false
                s.Visible = false
            end
        else
            r.Visible = false
            s.Visible = false
        end
    end)
end
-- // Child Added / Workspace
for i,v in pairs(game.Workspace.Map.BredMakurz:GetChildren()) do
    if MatchBegin(v.Name, "MediumSafe") or MatchBegin(v.Name, "SmallSafe") then
        Safe(v)
    end
end

game.Workspace.Map.BredMakurz.ChildAdded:Connect(function(v)
    if MatchBegin(v.Name, "MediumSafe") or MatchBegin(v.Name, "SmallSafe") then
        Safe(v)
    end
end)
-- // Register ESP
local RegisterShit = {
    enabled = false,
    exclude = false,
    maxdistance = 2500
}
-- // Functions
local function Register(v)
    -- // Drawing
    local s = Drawing.new("Text")
    s.Transparency = 1
    s.Visible = false
    s.Color = Color3.new(1,1,1)
    s.Size = 13
    s.Center = true
    s.Outline = true
    s.Font = 2
    local r = Drawing.new("Text")
    r.Transparency = 1
    r.Visible = false
    r.Color = Color3.new(1,1,1)
    r.Size = 13
    r.Center = true
    r.Outline = true
    r.Font = 2
    -- // RenderStepped
    rs.RenderStepped:Connect(function()
        if v.PrimaryPart ~= nil then
            ScreenPoint = camera:WorldToViewportPoint(v.PrimaryPart.Position)
            Distance = (camera.CFrame.p - v.PrimaryPart.Position).Magnitude
            if (ScreenPoint.Z > 0) then
                if RegisterShit.maxdistance > (v.PrimaryPart.CFrame.p - workspace.CurrentCamera.CFrame.p).magnitude then
                    if RegisterShit.enabled then
                        s.Visible = true
                        s.Position = Vector2.new(ScreenPoint.X, ScreenPoint.Y)
                        s.Text = tostring('Register'.. " ["..math.ceil(Distance).. "m]")
                        s.Color = Color3.fromRGB(255,255,255)
                        if v.Values.Broken.Value then
                            r.Text = "Status [Broken]"
                            r.Color = Color3.fromRGB(255,0,0)
                            r.Visible = true
                            r.Position = Vector2.new(ScreenPoint.X, ScreenPoint.Y + 13)
                        else
                            r.Text = "Status [Good]"
                            r.Color = Color3.fromRGB(0,255,0)
                            r.Visible = true
                            r.Position = Vector2.new(ScreenPoint.X, ScreenPoint.Y + 13)
                        end
                        if v.Values.Broken.Value and RegisterShit.exclude then
                            r.Visible = false
                            s.Visible = false
                        end
                    else
                        r.Visible = false
                        s.Visible = false
                    end
                else
                    s.Visible = false
                    r.Visible = false
                end
            else
                r.Visible = false
                s.Visible = false
            end
        else
            r.Visible = false
            s.Visible = false
        end
    end)
end
-- // Child Added / Workspace
for i,v in pairs(game.Workspace.Map.BredMakurz:GetChildren()) do
    if MatchBegin(v.Name, "Register") then
        Register(v)
    end
end

game.Workspace.Map.BredMakurz.ChildAdded:Connect(function(v)
    if MatchBegin(v.Name, "Register") then
        Register(v)
    end
end)
-- // Player ESP
local TextLayout = {}
local ESP = {
    enabled = false,
    box = {
        enabled = false,
        color = Color3.fromRGB(255,255,255),
    },
    healthbar = {
        enabled = false,
        color = Color3.fromRGB(0,255,0),
    },
    viewangle = {
        enabled = false,
        color = Color3.fromRGB(0,255,0),
    },
    text = {
        name = false,
        distance = false,
        gun = false,
        health = false,
        color = Color3.fromRGB(255,255,255),
        size = 13,
        font = "Plex",
    },
    outlines = true,
    outlinecolor = Color3.fromRGB(0,0,0),
    maxdistance = 2500
}
--
local lplr = game.Players.LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local CurrentCamera = workspace.CurrentCamera
local worldToViewportPoint = CurrentCamera.worldToViewportPoint
local WorldToViewportPoint = camera.WorldToViewportPoint
local mouse = game.Players.LocalPlayer:GetMouse()
local UserInput = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
--
function esp(v)
    local BoxOutline = Drawing.new("Square")
    BoxOutline.Visible = false
    BoxOutline.Color = Color3.new(0,0,0)
    BoxOutline.Thickness = 3
    BoxOutline.Transparency = 1
    BoxOutline.Filled = false

    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.new(1,1,1)
    Box.Thickness = 1
    Box.Transparency = 1
    Box.Filled = false

    local HealthOutline = Drawing.new("Line")
    HealthOutline.Thickness = 3 
    HealthOutline.Color = Color3.new(0,0,0)
    HealthOutline.Visible = false

    local Health = Drawing.new("Line")
    Health.Thickness = 1
    Health.Visible = false
    
    local Name = Drawing.new("Text")
    Name.Transparency = 1
    Name.Visible = false
    Name.Color = Color3.new(1,1,1)
    Name.Size = 13
    Name.Center = true
    Name.Outline = true

    local Gun = Drawing.new("Text")
    Gun.Transparency = 1
    Gun.Visible = false
    Gun.Color = Color3.new(1,1,1)
    Gun.Size = 13
    Gun.Center = true
    Gun.Outline = true

    local Tool = Drawing.new("Text")
    Tool.Transparency = 1
    Tool.Visible = false
    Tool.Color = Color3.new(1,1,1)
    Tool.Size = 13
    Tool.Center = true
    Tool.Outline = true

	local HealthText = Drawing.new("Text")
    HealthText.Transparency = 1
    HealthText.Visible = false
    HealthText.Color = Color3.new(1,1,1)
    HealthText.Size = 13
    HealthText.Center = true
    HealthText.Outline = true
    --
    game:GetService("RunService").RenderStepped:Connect(function()
        if v.Character ~= nil and v ~= lplr and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and v.Character:FindFirstChildOfClass("Humanoid") and math.floor(v.Character:FindFirstChildOfClass("Humanoid").Health) > 0 then
            local Vector, onScreen = camera:worldToViewportPoint(v.Character.HumanoidRootPart.Position)
            local Distance = (CurrentCamera.CFrame.p - v.Character.HumanoidRootPart.Position).Magnitude
            local RootPart = v.Character.HumanoidRootPart
            local Head = v.Character.Head
            local RootPosition, RootVis = worldToViewportPoint(CurrentCamera, RootPart.Position)
            local HeadPosition = worldToViewportPoint(CurrentCamera, Head.Position + Vector3.new(0,0.5,0))
            local LegPosition = worldToViewportPoint(CurrentCamera, RootPart.Position - Vector3.new(0,3,0))
            local Pos = Camera:WorldToViewportPoint(RootPart.Position)
			local Size           = (Camera:WorldToViewportPoint(RootPart.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(RootPart.Position + Vector3.new(0, 2.6, 0)).Y) / 2
            local BoxSize        = Vector2.new(math.floor(Size * 1.5), math.floor(Size * 2))
            local BoxPos         = Vector2.new(math.floor(Pos.X - Size * 1.5 / 2), math.floor(Pos.Y - Size * 1.8 / 2))
            local BottomOffset = BoxSize.Y + BoxPos.Y + 1
            if onScreen then
                if ESP.maxdistance > (v.Character.HumanoidRootPart.CFrame.p - workspace.CurrentCamera.CFrame.p).magnitude then
                    if ESP.enabled then
                        if ESP.box.enabled then
                            BoxOutline.Size = BoxSize
                            BoxOutline.Position = BoxPos
                            BoxOutline.Visible = ESP.outlines
                            BoxOutline.Color = ESP.outlinecolor
            
                            Box.Size = BoxSize
                            Box.Position = BoxPos
                            Box.Visible = true
                            Box.Color = ESP.box.color
                        else
                            Box.Visible = false
                            BoxOutline.Visible = false
                        end
                        if ESP.healthbar.enabled then
                            Health.From = Vector2.new((BoxPos.X - 5), BoxPos.Y + BoxSize.Y)
                            Health.To = Vector2.new(Health.From.X, Health.From.Y - (v.Character.Humanoid.Health / v.Character.Humanoid.MaxHealth) * BoxSize.Y)
                            Health.Color = ESP.healthbar.color
                            Health.Visible = true
        
                            HealthOutline.From = Vector2.new(Health.From.X, BoxPos.Y + BoxSize.Y + 1)
                            HealthOutline.To = Vector2.new(Health.From.X, (Health.From.Y - 1 * BoxSize.Y) -1)
                            HealthOutline.Visible = ESP.outlines
                            HealthOutline.Color = ESP.outlinecolor
                        else
                            Health.Visible = false
                            HealthOutline.Visible = false
                        end
                        if ESP.text.name then
                            Name.Text = tostring(v.DisplayName)
                            Name.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X, BoxPos.Y - 15)
                            Name.Visible = true
                            Name.Size = ESP.text.size
                            Name.Color = ESP.text.color
                            Name.Outline = ESP.outlines
                            Name.OutlineColor = ESP.outlinecolor
                            if ESP.text.font == "UI" then
                                Name.Font = 0
                            elseif ESP.text.font == "System" then
                                Name.Font = 1
                            elseif ESP.text.font == "Plex" then
                                Name.Font = 2
                            elseif ESP.text.font == "Monospace" then
                                Name.Font = 3
                            end
                        else
                            Name.Visible = false
                        end
                        if ESP.text.distance then
                            Gun.Text = tostring(math.ceil(Distance)).." m"
                            Gun.Position = Vector2.new(BoxSize.X/2 + BoxPos.X, BottomOffset)
                            Gun.Visible = true
                            Gun.Size = ESP.text.size
                            Gun.Color = ESP.text.color
                            Gun.Outline = ESP.outlines
                            Gun.OutlineColor = ESP.outlinecolor
                            if ESP.text.font == "UI" then
                                Gun.Font = 0
                            elseif ESP.text.font == "System" then
                                Gun.Font = 1
                            elseif ESP.text.font == "Plex" then
                                Gun.Font = 2
                            elseif ESP.text.font == "Monospace" then
                                Gun.Font = 3
                            end
                        else
                            Gun.Visible = false
                        end
                        if ESP.text.gun then
                            local Equipped = v.Character:FindFirstChildOfClass("Tool") and v.Character:FindFirstChildOfClass("Tool").Name or "None"
                            Tool.Text = tostring(Equipped)
                            Tool.Position = Vector2.new(BoxSize.X/2 + BoxPos.X, BoxSize.Y + BoxPos.Y + 12)
                            Tool.Visible = true
                            Tool.Size = ESP.text.size
                            Tool.Color = ESP.text.color
                            Tool.Outline = ESP.outlines
                            Tool.OutlineColor = ESP.outlinecolor
                            if ESP.text.font == "UI" then
                                Tool.Font = 0
                            elseif ESP.text.font == "System" then
                                Tool.Font = 1
                            elseif ESP.text.font == "Plex" then
                                Tool.Font = 2
                            elseif ESP.text.font == "Monospace" then
                                Tool.Font = 3
                            end
        
                            if ESP.text.distance == false then
                                Gun.Position = Vector2.new(BoxSize.X/2 + BoxPos.X, BottomOffset)
                            elseif ESP.text.gun == true and ESP.text.distance == false then
                                Tool.Position = Vector2.new(BoxSize.X/2 + BoxPos.X, BottomOffset)
                            else
                                Tool.Position = Vector2.new(BoxSize.X/2 + BoxPos.X, BoxSize.Y + BoxPos.Y + 12)
                                Gun.Position = Vector2.new(BoxSize.X/2 + BoxPos.X, BottomOffset)
                            end
                        else
                            Tool.Visible = false  
                        end
                        if ESP.text.health then
                            HealthText.Text = tostring(math.floor(v.Character.Humanoid.Health))
                            HealthText.Position = Vector2.new(Health.To.X - 12, Health.To.Y - 2)
                            HealthText.Visible = true
                            HealthText.Size = ESP.text.size
                            HealthText.Color = ESP.text.color
                            HealthText.Outline = ESP.outlines
                            HealthText.OutlineColor = ESP.outlinecolor
                            if ESP.text.font == "UI" then
                                HealthText.Font = 0
                            elseif ESP.text.font == "System" then
                                HealthText.Font = 1
                            elseif ESP.text.font == "Plex" then
                                HealthText.Font = 2
                            elseif ESP.text.font == "Monospace" then
                                HealthText.Font = 3
                            end
        
                            if ESP.healthbar.enabled == false then
                                HealthText.Position = Vector2.new(BoxPos.X - 12, BoxPos.Y - 2)
                            else
                                HealthText.Position = Vector2.new(Health.To.X - 12, Health.To.Y - 2)
                            end
                        else
                            HealthText.Visible = false
                        end
                    else
                        Box.Visible = false
                        BoxOutline.Visible = false
                        Health.Visible = false
                        HealthOutline.Visible = false
                        Name.Visible = false
                        Gun.Visible = false
                        Tool.Visible = false
                        HealthText.Visible = false
                    end
                else
                    Box.Visible = false
                    BoxOutline.Visible = false
                    Health.Visible = false
                    HealthOutline.Visible = false
                    Name.Visible = false
                    Gun.Visible = false
                    Tool.Visible = false
                    HealthText.Visible = false
                end
            else
                Box.Visible = false
                BoxOutline.Visible = false
                Health.Visible = false
                HealthOutline.Visible = false
                Name.Visible = false
                Gun.Visible = false
                Tool.Visible = false
                HealthText.Visible = false
            end
        else
            Box.Visible = false
            BoxOutline.Visible = false
            Health.Visible = false
            HealthOutline.Visible = false
            Name.Visible = false
            Gun.Visible = false
            Tool.Visible = false
            HealthText.Visible = false
        end
    end)
end
--
for i,v in pairs(game.Players:GetChildren()) do
    esp(v)
end

game.Players.PlayerAdded:Connect(function(v)
    esp(v)
end)
-- // Chams
local ChamSettings = {
    enabled = false,
    color = Color3.fromRGB(255,255,255),
    outlinecolor = Color3.fromRGB(255,255,255),
    transpareny = 0,
    outlinetransparency = 0
}
--
local players = game:GetService('Players')
local runService = game:GetService('RunService')
local coreGui = game:GetService('CoreGui')

local client = players.LocalPlayer
local h_parent = coreGui

if type(gethui) == 'function' then h_parent = gethui() end
if type(get_hidden_gui) == 'function' then h_parent = get_hidden_gui() end

local function create(class, properties)
	local object = Instance.new(class)
	for k, v in next, properties do
		object[k] = v;
	end
	return object
end

local function cleaner()
	local tasks = {}
	local function give(task)
		table.insert(tasks, task)
	end
	local function clean()
		for i = #tasks, 1, -1 do
			local task = table.remove(tasks, i)

			if typeof(task) == 'Instance' then task:Destroy() end
			if typeof(task) == 'RBXScriptSignal' then task:Disconnect() end
			if typeof(task) == 'function' then task() end
		end
	end
	return give, clean
end

local chams = {}
local function onPlayerAdded(player)
	local p_give, p_clean = cleaner()
	local c_give, c_clean = cleaner()
	local function onCharacterAdded(character)
		c_clean()

		local highlight = create('Highlight', {
			Adornee = character,
			Parent = h_parent,
		})

		local storage = { player, highlight }

		c_give(highlight)
		c_give(function()
			local index = table.find(chams, storage)
			if index then
				table.remove(chams, index)
			end
		end)

		table.insert(chams, storage)
	end

	if player.Character then
		task.spawn(onCharacterAdded, player.Character)
	end

	p_give(player.CharacterAdded:Connect(onCharacterAdded))
	p_give(player:GetPropertyChangedSignal('Parent'):Connect(function()
		if player.Parent ~= players then
			p_clean()
			c_clean()
		end
	end))

end

for _, player in next, players:GetPlayers() do
	if player ~= client then
		task.spawn(onPlayerAdded, player)
	end
end

players.PlayerAdded:Connect(onPlayerAdded)

runService.Stepped:Connect(function()
	for i = 1, #chams do
		local store = chams[i]
		local plr, highlight = store[1], store[2]

		local doesShow = ChamSettings.enabled
        highlight.Enabled = ESP.enabled and doesShow
		
		highlight.FillColor = ChamSettings.color
		highlight.OutlineColor = ChamSettings.outlinecolor

		highlight.FillTransparency = ChamSettings.transparency
		highlight.OutlineTransparency = ChamSettings.outlinetransparency
	end
end)
--
local misctoggles = {
    ChatToggle = false,
    InfStamina = false,
    InstaPick = false,
    NoFall = false,
    walkspeed = false,
    walkspeedval = 16,
    jumppower = false,
    jumppowerval = 50,
    fov = false,
    fovval = 90
}
--
local oldStamina
oldStamina =
hookfunction(
getupvalue(getrenv()._G.S_Take, 2),
function(v1, ...)
    if (misctoggles.InfStamina) then
        v1 = 0
    end
    return oldStamina(v1, ...)
end
)
local oldNamecall
oldNamecall =
hookmetamethod(
game,
"__namecall",
newcclosure(
    function(...)
        if (not checkcaller() and getnamecallmethod() == "FireServer" and misctoggles.NoFall) then
            local tab = ...
            if (tostring(tab) == "__DFfDD") then
                return
            end
        end

        return oldNamecall(...)
    end
)
)
local fMain
local fMainDo
for i, v in next, getgc() do
    if (type(v) == "function" and getinfo(v).source:find(".PlayerScripts.")) then
        if (getinfo(v).name == "Main") then
            fMain = v
        elseif
            (getinfo(v).name == "MainDo" and
                ({
                    pcall(
                        function()
                            getproto(v, 3)
                        end
                    )
                })[1])
         then -- for extra certainty, there is nothing like this for the other function because i cba and i spent alot of time reversing this function
            fMainDo = v
        end
        if (fMain and fMainDo) then
            break
        end
    end
end

if (fMainDo and fMain) then
    local oldMainDo
    oldMainDo =
        hookfunction(
        fMainDo,
        function(InputObject, ...)
            if (misctoggles.InstaPick) then
                local InteractTable = getupvalue(fMain, 2) -- yes indeed, i couldve used the proto from MainDo but i forgor that you had to make the last arg true to get upvalues from it
                if (type(InteractTable) == "table" and type(InteractTable[InputObject.KeyCode]) == "table") then
                    InteractTable[InputObject.KeyCode][2] = 0
                end
            end
            return oldMainDo(InputObject, ...)
        end
    )
end
--
local OriginalWalkspeed = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").WalkSpeed or 16
local OriginalJumpPower = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").JumpPower or 50
local FOV = Camera.FieldOfView
RunService.RenderStepped:Connect(function()
    local SelfCharacter = game.Players.LocalPlayer.Character
    local SelfRootPart, SelfHumanoid = SelfCharacter and SelfCharacter:FindFirstChild("HumanoidRootPart"), SelfCharacter and SelfCharacter:FindFirstChildOfClass("Humanoid")
    if not SelfCharacter or not SelfRootPart or not SelfHumanoid then return end

    if misctoggles.walkspeed then
        SelfHumanoid.WalkSpeed = misctoggles.walkspeedval
    else
        SelfHumanoid.WalkSpeed = OriginalWalkspeed
    end
    if misctoggles.fov then
        Camera.FieldOfView = misctoggles.fovval
    else
        Camera.FieldOfView = FOV
    end
end)

local OldNewIndex; OldNewIndex = hookmetamethod(game, "__newindex", function(self, key, value)
    local SelfName = tostring(self)

    if not checkcaller() then
        if key == "FieldOfView" then
            if value == 40 then
                value = FOV
            end
            FOV = value

            if misctoggles.fov and misctoggles.fovval then
                value = misctoggles.fovval
            end

            return OldNewIndex(self, key, value)
        end
        if key == "WalkSpeed" then
            OriginalWalkspeed = value
            if misctoggles.walkspeed then
                value = misctoggles.walkspeedval
            end

            return OldNewIndex(self, key, value)
        end
        if key == "JumpPower" then
            OriginalJumpPower = value
            if misctoggles.jumppower then
                value = misctoggles.jumppowerval
            end

            return OldNewIndex(self, key, value)
        end
        if key == "Ambient" and library.flags.fb then
            value = Color3.fromRGB(255, 255, 255)

            return OldNewIndex(self, key, value)
        end
        if key == "ClockTime" and library.flags.timetoggle then
            value = library.flags.time

            return OldNewIndex(self, key, value)
        end

        return OldNewIndex(self, key, value)
    end

    return OldNewIndex(self, key, value)
end)
--
local _Humanoid do
    RunService.RenderStepped:Connect(function()
        _Humanoid = nil
        if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            _Humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
        end
    end)
end
local OldIndex; OldIndex = hookmetamethod(game, "__index", function(self, key)
    local SelfName = tostring(self)
    local caller = getcallingscript()

    if not checkcaller() then
        if _Humanoid and self == _Humanoid then
            if key == "WalkSpeed" then
                return OriginalWalkspeed
            end
        end
        if _Humanoid and self == _Humanoid then
            if key == "JumpPower" then
                return OriginalJumpPower
            end
        end
        if key == "FieldOfView" then
            if misctoggles.fov and misctoggles.fovval then
                --return menu.values[3].world.self["field of view"].Slider
            end
        end
    end
    return OldIndex(self, key)
end)
--
local NoclipLoop = rs.Stepped:Connect(function()
    if not plr.Character then return end
    if not library.flags.noclip then return end

    for _,part in pairs (plr.Character:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide == true then
            part.CanCollide = false
        end
    end
end)
--
loadstring(game:HttpGet("https://raw.githubusercontent.com/NougatBitz/BitzUtils/main/CriminalityFeatures.lua"))()
--
library:init()
local lib = library.NewWindow({title = 'ametrine | criminality'})
library:CreateSettingsTab(lib)
--
local main = lib:AddTab("Main", 1)
local vis = lib:AddTab("Visuals", 2)
local misc = lib:AddTab("Misc", 3)
--
local aim_tb = main:AddSection('Triggerbot', 1, 2)
--
local main_silent = main:AddSection("Silent Aim", 1, 1)
local main_mods = main:AddSection("Gun Mods", 2, 1)
local main_tele = main:AddSection("Teleport [Experimental]", 1, 3)
--
local vis_esp = vis:AddSection("ESP", 1, 1)
local vis_sky = vis:AddSection("Skybox", 2, 3)
local vis_other = vis:AddSection("Other", 2, 2)
local vis_settings = vis:AddSection("Settings", 2, 1)
local vis_world = vis:AddSection("Items", 1, 2)
--
local misc_game = misc:AddSection("Game", 1, 1)
local misc_play = misc:AddSection("Player", 1, 2)
--
aim_tb:AddToggle({text = "Enabled", flag = "tb"})
aim_tb:AddSlider({text = 'Delay', flag = "tbdelay", suffix = 'ms', value = 60, min = 0, max = 100});
--
main_silent:AddToggle({text = "Enabled", flag = 'silent', callback = function() SilentAim.enabled = library.flags.silent end})
main_silent:AddList({text = "Hitbox", flag = 'silentpart', values = {"Head", "Torso"}, callback = function() SilentAim.targetpart = library.flags.silentpart end})
--
main_mods:AddToggle({text = "No Recoil", flag = 'recoil', callback = function() ToggleBitzFeature("NoRecoil", library.flags.recoil) end})
main_mods:AddToggle({text = "No Spread", flag = 'spread', callback = function() ToggleBitzFeature("NoSpread", library.flags.spread) end})
main_mods:AddToggle({text = "Wallbang", flag = 'silentwall'})
--
local Positions = {
    ["Tower"] = Vector3.new(-4475, 105, -850),
    ["Vibe Check Inside"] = Vector3.new(-4776, -200, -968),
    ["Vibe Check Outside"] = Vector3.new(-4776, -34, -789),
    ["Subway"] = Vector3.new(-4721, -32, -699),
    ["Sewers"] = Vector3.new(-4131, -91, -704),
    ["Junkyard"] = Vector3.new(-3941, 5, -595),
    ["Gas station"] = Vector3.new(-4373, 7, 215),
    ["Motel"] = Vector3.new(-4638, 6, -983),
    ["Cafe"] = Vector3.new(-4612, 6, -278),
    ["Armory"] = Vector3.new(-4205, 5, -186),
    ["ATM"] = Vector3.new(-4156, 3, -206)
}

local LastTP = tick()
main_tele:AddList({text = "Locations", flag = 'tpplaces', values = {"Tower", "Vibe Check Inside", "Vibe Check Outside", "Subway", "Sewers", "Junkyard", "Gas station", "Motel", "Cafe", "ATM", "Armory"}})
main_tele:AddButton({text = "Teleport", risky = true, callback = function()
    local SelfCharacter = plr.Character
    local SelfRootPart, SelfHumanoid = SelfCharacter and SelfCharacter:FindFirstChild("HumanoidRootPart"), SelfCharacter and SelfCharacter:FindFirstChildOfClass("Humanoid")
    if not SelfCharacter or not SelfRootPart or not SelfHumanoid then return end

    local Time = tick() - LastTP
    if Time < 10 then
        local TimeLeft = math.floor(10 - Time)
        library:SendNotification('Please wait '.. TimeLeft .. ' seconds', 5, Color3.fromRGB(255,0,0))
        return
    end

    LastTP = tick()
    
    local Position

    if Positions[library.flags.tpplaces] ~= nil then
        Position = Positions[library.flags.tpplaces]
    else

    end

    if not Position then
        return
    end
    
    SelfRootPart.Position = Vector3.new(0, -1e9, 0)
    wait(1)
    SelfRootPart.Position = Position
end})
--
local esp = vis_esp:AddToggle({text = "Enabled", flag = 'esptoggle', callback = function() ESP.enabled = library.flags.esptoggle end})
local box = vis_esp:AddToggle({text = "Boxes", flag = 'espbox', callback = function() ESP.box.enabled = library.flags.espbox end}) box:AddColor({text = "Boxes Color", flag = 'boxcolor', color = Color3.fromRGB(255,255,255), callback = function() ESP.box.color = library.flags.boxcolor end})
local health = vis_esp:AddToggle({text = "Healthbar", flag = 'esphealth', callback = function() ESP.healthbar.enabled = library.flags.esphealth end}) health:AddColor({text = "Healthbar Color", flag = 'healthcolor', color = Color3.fromRGB(0,255,0), callback = function() ESP.healthbar.color = library.flags.healthcolor end})
local cham = vis_esp:AddToggle({text = "Chams", flag = 'espcham', tooltip = 'Must have highlights enabled.', callback = function() ChamSettings.enabled = library.flags.espcham end}) cham:AddColor({text = "Main Color", flag = 'chamcolor', color = Color3.fromRGB(255,255,255), callback = function() ChamSettings.color = library.flags.chamcolor end}) cham:AddColor({text = "Outline Color", flag = 'chamoutcolor', color = Color3.fromRGB(0,0,0), callback = function() ChamSettings.outlinecolor = library.flags.chamoutcolor end})
vis_esp:AddSeparator({text = "Text"})
vis_esp:AddToggle({text = "Name", flag = 'espname', callback = function() ESP.text.name = library.flags.espname end})
vis_esp:AddToggle({text = "Distance", flag = 'espdistance', callback = function() ESP.text.distance = library.flags.espdistance end})
vis_esp:AddToggle({text = "Weapon", flag = 'espweapon', callback = function() ESP.text.gun = library.flags.espweapon end})
vis_esp:AddToggle({text = "Health", flag = 'esphealthtext', callback = function() ESP.text.health = library.flags.esphealthtext end})
--
vis_world:AddSeparator({text = "Scrap"})
vis_world:AddToggle({text = "Enabled", flag = 'scraptoggle', callback = function() ScrapShit.Enabled = library.flags.scraptoggle end})
vis_world:AddToggle({text = "Common Only", flag = 'scrapbad', callback = function() ScrapShit.Bad = library.flags.scrapbad end})
vis_world:AddToggle({text = "Good Only", flag = 'scrapgood', callback = function() ScrapShit.Good = library.flags.scrapgood end})
vis_world:AddToggle({text = "Rare Only", flag = 'scraprare', callback = function() ScrapShit.Rare = library.flags.scraprare end})
vis_world:AddToggle({text = "Legendary Only", flag = 'scraplegend', callback = function() ScrapShit.Legendary = library.flags.scraplegend end})
vis_world:AddSeparator({text = "Safes"})
vis_world:AddToggle({text = "Enabled", flag = 'safetoggle', callback = function() SafeShit.enabled = library.flags.safetoggle end})
vis_world:AddToggle({text = "Small Only", flag = 'safesmall', callback = function() SafeShit.showsmall = library.flags.safesmall end})
vis_world:AddToggle({text = "Large Only", flag = 'safelarge', callback = function() SafeShit.showmedium = library.flags.safelarge end})
vis_world:AddToggle({text = "Exclude Broken", flag = 'safeexclude', callback = function() SafeShit.excludebroken = library.flags.safeexclude end})
vis_world:AddSeparator({text = "Registers"})
vis_world:AddToggle({text = "Enabled", flag = 'register', callback = function() RegisterShit.enabled = library.flags.register end})
vis_world:AddToggle({text = "Exclude Broken", flag = 'registerexclude', callback = function() RegisterShit.exclude = library.flags.registerexclude end})
--
local fov = vis_other:AddToggle({text = "Fov Changer", flag = 'fovtoggle', callback = function() misctoggles.fov = library.flags.fovtoggle end})
fov:AddSlider({min = 40, max = 120, value = 90, flag = 'fovval', callback = function() misctoggles.fovval = library.flags.fovval end})
vis_other:AddToggle({text = "Fullbright", flag = 'fb'})
local timetoggle = vis_other:AddToggle({text = "Time of Day", flag = 'timetoggle'})
timetoggle:AddSlider({min = 0, max = 24, value = 12, flag = 'time'})
--
local skybox = nil
local skyboxvals
local customskyval = nil
vis_sky:AddBox({text = "Custom Skybox", flag = 'customsky', callback = function(val) customskyval = val end})
vis_sky:AddButton({text = "Load Skybox", callback = function()
    if s then
		s:Destroy()
	end
	image = getsynasset(customskyval..".png")
	s = Instance.new("Sky")
    s.Name = "SKY"
    s.SkyboxBk = image
    s.SkyboxDn = image
    s.SkyboxFt = image
    s.SkyboxLf = image
    s.SkyboxRt = image
    s.SkyboxUp = image
end}):AddButton({text = "Remove Skybox", callback = function()
    s:Destroy()
end})
vis_sky:AddSeparator({text = "Pre-made Skyboxes"})
vis_sky:AddList({text = "Skyboxes", flag = 'skybox', values = {"Normal","Clouds","Twilight","Dababy","Amongus",'Purple Nebula','Night Sky','Pink Daylight','Morning Glow','Setting Sun','Fade Blue','Elegant Morning','Neptune','Redshift','Aesthetic Night',"Nebula","Vaporwave","MC","Chill"}, callback = function() skybox = library.flags.skybox end})
vis_sky:AddButton({text = "Load Skybox", callback = function()
    if s then
		s:Destroy()
	end
    --
    local s = Instance.new("Sky", game.Lighting)
    if skybox == "Normal" then
        s:Destroy()
    elseif skybox == "Clouds" then
        s.SkyboxLf = "rbxassetid://570557620"      
        s.SkyboxBk = "rbxassetid://570557514"      
        s.SkyboxDn = "rbxassetid://570557775"      
        s.SkyboxFt = "rbxassetid://570557559"      
        s.SkyboxRt = "rbxassetid://570557672"      
        s.SkyboxUp = "rbxassetid://570557727"    
    elseif skybox == "Twilight" then
        s.SkyboxLf = "rbxassetid://264909758"      
        s.SkyboxBk = "rbxassetid://264908339"      
        s.SkyboxDn = "rbxassetid://264907909"     
        s.SkyboxFt = "rbxassetid://264909420"     
        s.SkyboxRt = "rbxassetid://264908886"     
        s.SkyboxUp = "rbxassetid://264907379"
    elseif skybox == "Dababy" then
        s.SkyboxLf = "rbxassetid://7245418472"
        s.SkyboxBk = "rbxassetid://7245418472"
        s.SkyboxDn = "rbxassetid://7245418472"
        s.SkyboxFt = "rbxassetid://7245418472"
        s.SkyboxRt = "rbxassetid://7245418472"
        s.SkyboxUp = "rbxassetid://7245418472"
    elseif skybox == "Amongus" then
        s.SkyboxLf = "rbxassetid://5752463190"
        s.SkyboxBk = "rbxassetid://5752463190"
        s.SkyboxDn = "rbxassetid://5752463190"
        s.SkyboxFt = "rbxassetid://5752463190"
        s.SkyboxRt = "rbxassetid://5752463190"
        s.SkyboxUp = "rbxassetid://5752463190"
    elseif skybox == 'Purple Nebula' then
        s.SkyboxBk = 'rbxassetid://159454299'
        s.SkyboxDn = 'rbxassetid://159454296'
        s.SkyboxFt = 'rbxassetid://159454293'
        s.SkyboxLf = 'rbxassetid://159454286'
        s.SkyboxRt = 'rbxassetid://159454300'
        s.SkyboxUp = 'rbxassetid://159454288'
    elseif skybox == 'Night Sky' then
        s.SkyboxBk = 'rbxassetid://12064107'
        s.SkyboxDn = 'rbxassetid://12064152'
        s.SkyboxFt = 'rbxassetid://12064121'
        s.SkyboxLf = 'rbxassetid://12063984'
        s.SkyboxRt = 'rbxassetid://12064115'
        s.SkyboxUp = 'rbxassetid://12064131'
    elseif skybox == 'Pink Daylight' then
        s.SkyboxBk = 'rbxassetid://271042516'
        s.SkyboxDn = 'rbxassetid://271077243'
        s.SkyboxFt = 'rbxassetid://271042556'
        s.SkyboxLf = 'rbxassetid://271042310'
        s.SkyboxRt = 'rbxassetid://271042467'
        s.SkyboxUp = 'rbxassetid://271077958'
    elseif skybox == 'Morning Glow' then
        s.SkyboxBk = 'rbxassetid://1417494030'
        s.SkyboxDn = 'rbxassetid://1417494146'
        s.SkyboxFt = 'rbxassetid://1417494253'
        s.SkyboxLf = 'rbxassetid://1417494402'
        s.SkyboxRt = 'rbxassetid://1417494499'
        s.SkyboxUp = 'rbxassetid://1417494643'
    elseif skybox == 'Setting Sun' then
        s.SkyboxBk = 'rbxassetid://626460377'
        s.SkyboxDn = 'rbxassetid://626460216'
        s.SkyboxFt = 'rbxassetid://626460513'
        s.SkyboxLf = 'rbxassetid://626473032'
        s.SkyboxRt = 'rbxassetid://626458639'
        s.SkyboxUp = 'rbxassetid://626460625'
    elseif skybox == 'Fade Blue' then
        s.SkyboxBk = 'rbxassetid://153695414'
        s.SkyboxDn = 'rbxassetid://153695352'
        s.SkyboxFt = 'rbxassetid://153695452'
        s.SkyboxLf = 'rbxassetid://153695320'
        s.SkyboxRt = 'rbxassetid://153695383'
        s.SkyboxUp = 'rbxassetid://153695471'
    elseif skybox == 'Elegant Morning' then
        s.SkyboxBk = 'rbxassetid://153767241'
        s.SkyboxDn = 'rbxassetid://153767216'
        s.SkyboxFt = 'rbxassetid://153767266'
        s.SkyboxLf = 'rbxassetid://153767200'
        s.SkyboxRt = 'rbxassetid://153767231'
        s.SkyboxUp = 'rbxassetid://153767288'
    elseif skybox == 'Neptune' then
        s.SkyboxBk = 'rbxassetid://218955819'
        s.SkyboxDn = 'rbxassetid://218953419'
        s.SkyboxFt = 'rbxassetid://218954524'
        s.SkyboxLf = 'rbxassetid://218958493'
        s.SkyboxRt = 'rbxassetid://218957134'
        s.SkyboxUp = 'rbxassetid://218950090'
    elseif skybox == 'Redshift' then
        s.SkyboxBk = 'rbxassetid://401664839'
        s.SkyboxDn = 'rbxassetid://401664862'
        s.SkyboxFt = 'rbxassetid://401664960'
        s.SkyboxLf = 'rbxassetid://401664881'
        s.SkyboxRt = 'rbxassetid://401664901'
        s.SkyboxUp = 'rbxassetid://401664936'
    elseif skybox == 'Aesthetic Night' then
        s.SkyboxBk = 'rbxassetid://1045964490'
        s.SkyboxDn = 'rbxassetid://1045964368'
        s.SkyboxFt = 'rbxassetid://1045964655'
        s.SkyboxLf = 'rbxassetid://1045964655'
        s.SkyboxRt = 'rbxassetid://1045964655'
        s.SkyboxUp = 'rbxassetid://1045962969'
    elseif skybox == "Nebula" then
        s.SkyboxLf = "rbxassetid://159454286"     
        s.SkyboxBk = "rbxassetid://159454299"     
        s.SkyboxDn = "rbxassetid://159454296"    
        s.SkyboxFt = "rbxassetid://159454293"      
        s.SkyboxLf = "rbxassetid://159454286"      
        s.SkyboxRt = "rbxassetid://159454300"      
        s.SkyboxUp = "rbxassetid://159454288"
    elseif skybox == "Vaporwave" then
        s.SkyboxLf = "rbxassetid://1417494402"     
        s.SkyboxBk = "rbxassetid://1417494030"     
        s.SkyboxDn = "rbxassetid://1417494146"     
        s.SkyboxFt = "rbxassetid://1417494253"     
        s.SkyboxLf = "rbxassetid://1417494402"     
        s.SkyboxRt = "rbxassetid://1417494499"      
        s.SkyboxUp = "rbxassetid://1417494643"
    elseif skybox == "MC" then
        s.SkyboxLf = "rbxassetid://1876543392"
        s.SkyboxBk = "rbxassetid://1876545003"
        s.SkyboxDn = "rbxassetid://1876544331"
        s.SkyboxFt = "rbxassetid://1876542941"
        s.SkyboxLf = "rbxassetid://1876543392"
        s.SkyboxRt = "rbxassetid://1876543764"
        s.SkyboxUp = "rbxassetid://1876544642"
    elseif skybox == "Chill" then
        s.SkyboxLf = "rbxassetid://5103948542"
        s.SkyboxBk = "rbxassetid://5084575798"
        s.SkyboxDn = "rbxassetid://5084575916"
        s.SkyboxFt = "rbxassetid://5103949679"
        s.SkyboxLf = "rbxassetid://5103948542"
        s.SkyboxRt = "rbxassetid://5103948784"
        s.SkyboxUp = "rbxassetid://5084576400"
    end
end}):AddButton({text = "Remove Skybox", callback = function()
    s:Destroy()
end})
--
vis_settings:AddSlider({text = "Draw distance", flag = 'drawdist', min = 0, max = 10000, value = 2500, callback = function() 
    ESP.maxdistance = library.flags.drawdist
    ScrapShit.maxdistance = library.flags.drawdist
    SafeShit.maxdistance = library.flags.drawdist
    RegisterShit.maxdistance = library.flags.drawdist
    CashShit.maxdistance = library.flags.drawdist
end})
local outline = vis_settings:AddToggle({text = "Outlines", state = true, flag = 'espoutline', callback = function() ESP.outlines = library.flags.espoutline end}) outline:AddColor({text = "Outlines Color", flag = 'outlinecolor', callback = function() ESP.outlinecolor = library.flags.outlinecolor end})
vis_settings:AddSeparator({text = "Text Settings"})
vis_settings:AddList({text = "Text Font", flag = 'font', values = {'Plex', 'System', 'UI', 'Monospace'}, selected = 'Plex', callback = function() ESP.text.font = library.flags.font end})
vis_settings:AddSlider({text = "Text Size", value = 13, min = 10, max = 20, flag = 'fonts', callback = function() ESP.text.size = library.flags.fonts end})
vis_settings:AddColor({text = "Text Color", flag = 'textcolor', color = Color3.fromRGB(255,255,255), callback = function() ESP.text.color = library.flags.textcolor end})
vis_settings:AddSeparator({text = "Cham Settings"})
vis_settings:AddSlider({text = "Transparency", min = 0, max = 1, value = 0, increment = 0.01, flag = 'chamtran', callback = function() ChamSettings.transparency = library.flags.chamtran end})
vis_settings:AddSlider({text = "Outline Transparency", min = 0, max = 1, value = 0, increment = 0.01, flag = 'chamouttran', callback = function() ChamSettings.outlinetransparency = library.flags.chamouttran end})
--
misc_game:AddToggle({text = "Toggle Chat", flag = 'togglechat', callback = function()
    misctoggles.ChatToggle = library.flags.togglechat
    if misctoggles.ChatToggle == true then
        local Players = game:GetService("Players")
        local ChatFrame = Players.LocalPlayer.PlayerGui.Chat.Frame
        ChatFrame.ChatChannelParentFrame.Visible = true
        ChatFrame.ChatBarParentFrame.Position = UDim2.new(0, 0, 1, -42)
    elseif misctoggles.ChatToggle == false then
        local Players = game:GetService("Players")
        local ChatFrame = Players.LocalPlayer.PlayerGui.Chat.Frame
        ChatFrame.ChatChannelParentFrame.Visible = false
    end
end})
--
misc_play:AddToggle({text = "Infinite Stamina", flag = 'stam', callback = function() misctoggles.InfStamina = library.flags.stam end})
local w = misc_play:AddToggle({text = "Walkspeed", flag = 'wstoggle', callback = function() misctoggles.walkspeed = library.flags.wstoggle end})
w:AddSlider({min = 1, max = 40, value = 16, flag = 'wsval', callback = function() misctoggles.walkspeedval = library.flags.wsval end})
local j = misc_play:AddToggle({text = "JumpPower", flag = 'jptoggle', callback = function() misctoggles.jumppower = library.flags.jptoggle end})
j:AddSlider({min = 1, max = 100, value = 50, flag = 'jpval', callback = function() misctoggles.jumppowerval = library.flags.jpval end})
misc_play:AddToggle({text = "No-Clip", flag = 'noclip'})
misc_play:AddToggle({text = "No Fall Damage", flag = 'nofall', callback = function() misctoggles.NoFall = library.flags.nofall end})
misc_play:AddToggle({text = "Instant Pickup", flag = 'insta', callback = function() misctoggles.InstaPick = library.flags.insta end})
--
return library
