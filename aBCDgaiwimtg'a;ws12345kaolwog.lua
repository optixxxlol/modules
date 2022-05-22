if esp then
    esp:unload();
end

local connections = {};
local players = game:GetService('Players');
local localPlayer = players.LocalPlayer;

local espTextScale;

local function newDrawing(class, props)
    local d = Drawing.new(class);
    for i,v in next, props or {} do
        d[i]=v;
    end
    return d;
end

local function newInst(class, props)
    local inst = Instance.new(class);
    for i,v in next, props or {} do
        inst[i]=v;
    end
    return inst;
end

local function rotateVector2(v2, r)
    local c = math.cos(r);
    local s = math.sin(r);
    return Vector2.new(c * v2.X - s*v2.Y, s*v2.X + c*v2.Y)
end

local function ConvertNumberRange(val,oldmin,oldmax,newmin,newmax)
    return (((val - oldmin) * (newmax - newmin)) / (oldmax - oldmin)) + newmin;
end

local esp = {
    drawings = {};
    textlayout = {
        ['name'] = {pos = 'top', enabled = false, color = Color3.new(1,1,1), transparency = 1};
        ['distance'] = {pos = 'bottom', enabled = false, suffix = 'm', color = Color3.new(1,1,1), transparency = 1};
        ['health'] = {pos = 'left', enabled = false, color = Color3.new(0,1,0), transparency = 1};
        ['tool'] = {pos = 'bottom', enabled = false, color = Color3.new(1,1,1), transparency = 1};
    };
    barlayout = {
        ['health'] = {pos = 'left', enabled = false, color1 = Color3.new(1,0,0), color2 = Color3.new(0,1,0), transparency = 1};
    };
    targets = {};
    enabled = false;
    teamcheck = false;
    limitdistance = true;
    displaynames = true;
    maxdistance = 2500;
    arrowradius = 300;
    textsize = 13;
    textfont = 2;
    targetcolor = Color3.new(1,.15,.15);
    chams = {false, Color3.new(1,1,1), Color3.new(0,0,0), 0.5, 0};
    box = {false, Color3.new(1,1,1)};
    boxfill = {false, Color3.new(1,1,1), .25};
    arrow = {false, Color3.new(1,1,1), 3};
    angle = {false, Color3.new(1,1,1)};
    tracer = {false, Color3.new(1,1,1)};
    outline = {true, Color3.new(0,0,0)};
};


espTextScale = newDrawing('Text', {Visible = false, Text = 'M'});

function esp:unload()
    for _,v in next, players:GetPlayers() do
        esp.remove(v);
    end
    for _,v in next, connections do
        v:Disconnect();
    end
    espTextScale:Remove();
    getgenv().esp = nil;
end

function esp:check(plr)
    if not esp.enabled then
        return false
    end

    local pass = true;

    local char = esp.GetPlayerCharacter(plr)
    if not (char and char:FindFirstChild('HumanoidRootPart') and char:FindFirstChild('Humanoid') and char.Humanoid.Health ~= 0) then
        pass = false;
    elseif esp.limitdistance and esp.maxdistance < (char.HumanoidRootPart.CFrame.p - workspace.CurrentCamera.CFrame.p).magnitude then
        pass = false;
    end

    if pass and not (esp.teamcheck and (esp.GetPlayerTeam(plr) ~= esp.GetPlayerTeam(localPlayer)) or true) then
        pass = false;
    end

    return pass
end

function esp.GetCharacterInfo(plr)
    local char = esp.GetPlayerCharacter(plr);
    return {
        character = char;
        maxhealth = char.Humanoid.MaxHealth;
        health = char.Humanoid.Health;
    }
end

function esp.GetPlayerInfo(plr)
    local charInfo = esp.GetCharacterInfo(plr)
    return {
        character = charInfo,
        text = {
            ['name'] = {text = esp.displaynames and plr.DisplayName or plr.Name},
            ['distance'] = {text = (charInfo.character and charInfo.character:FindFirstChild('HumanoidRootPart')) and tostring(math.floor((charInfo.character.HumanoidRootPart.CFrame.p - workspace.CurrentCamera.CFrame.p).magnitude))},
            ['health'] = {text = math.floor(charInfo.health), color = esp.barlayout.health.color1:Lerp(esp.barlayout.health.color2, charInfo.health / charInfo.maxhealth)},
            ['tool'] = {text = plr.Character:FindFirstChildOfClass("Tool") and plr.Character:FindFirstChildOfClass("Tool").Name or "None"},
        },
        bar = {
            ['health'] = {value = charInfo.health, max = charInfo.maxhealth},
        },
    }
end

function esp.GetPlayerTeam(plr)
    return plr.Team
end

function esp.GetPlayerCharacter(plr)
    return plr.Character
end

function esp:init()

    function esp.new(plr)
        esp.drawings[plr] = {
            boxfill = newDrawing('Square', {Thickness = 1, Transparency = .5, Filled = true});
            boxoutline = newDrawing('Square', {Thickness = 3});
            box = newDrawing('Square', {Thickness = 1});
            chams = newInst('Highlight', {Parent = workspace, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop});
            text = {};
            bar = {};
        }
        for i,v in next, esp.textlayout do
            esp.drawings[plr].text[i] = {newDrawing('Text', {ZIndex = 1}), i};
        end
        for i in next, esp.barlayout do
            esp.drawings[plr].bar[i] = {newDrawing('Square', {Filled = true, ZIndex = 2}), newDrawing('Square', {Filled = true, ZIndex = 1})};
        end
    end

    function esp.remove(plr)
        local drawings = esp.drawings[plr]
        if drawings then
            for i,v in next, drawings do
                if i == 'text' or i == 'bar'then
                    for _,v2 in next, v do
                        if i == 'text' or i == 'bar' then
                            v2[1]:Remove();
                            if i == 'bar' then
                                v2[2]:Remove();
                            end
                        end
                    end
                elseif i ~= 'chams' then
                    v:Remove();
                else
                    v:Destroy();
                end
            end
            esp.drawings[plr] = nil;
        end
    end

    function esp.CFrameToViewport(cf)
        local cam = workspace.CurrentCamera;
        return cam:WorldToViewportPoint((cf * (cf - cf.p):ToObjectSpace(cam.CFrame - cam.CFrame.p)).p);
    end

    for _,v in next, players:GetPlayers() do
        if v ~= players.LocalPlayer then
            esp.new(v);
        end
    end

    table.insert(connections, players.PlayerAdded:Connect(esp.new));
    table.insert(connections, players.PlayerRemoving:Connect(esp.remove));
    table.insert(connections,
        game:GetService('RunService').RenderStepped:Connect(function()
            espTextScale.Size = esp.textsize;
            espTextScale.Font = esp.textfont;
            local textScaleBounds = espTextScale.TextBounds;
            for plr,data in next, esp.drawings do
                local s,e = pcall(function()
                    local pass = esp:check(plr);
                    local screenPos, onScreen, char, HRP;
                    local camera = workspace.CurrentCamera;
            
                    if pass then
                        char = esp.GetPlayerCharacter(plr);
                        HRP = char.PrimaryPart;
                        screenPos, onScreen = camera:WorldToViewportPoint((HRP.CFrame * (HRP.CFrame - char:GetBoundingBox().Position):ToObjectSpace(camera.CFrame - camera.CFrame.p)).p);
                    end
            
                    local function setPropAll(prop, value)
                        for i,v in next, data do
                            if i == 'text' or i == 'bar' then
                                for _,v2 in next, v do
                                    if i == 'text' or i == 'bar' then
                                        v2[1][prop] = value;
                                        if i == 'bar' then
                                            v2[2][prop] = value;
                                        end
                                    end
                                end
                            elseif i ~= 'chams' then
                                v[prop] = value;
                            end
                        end
                    end

                    setPropAll('Visible', pass and onScreen)
                    if pass then
                        setPropAll('Transparency', esp.limitdistance and 1 - math.clamp(ConvertNumberRange(math.floor((HRP.CFrame.p - camera.CFrame.p).magnitude), esp.maxdistance - 90, esp.maxdistance, 0, 1), 0, 1) or 1);
                    end

                    if esp.teamcheck and plr.Team == game.Players.LocalPlayer.Team then
                        data.chams.Enabled = false
                    else
                        data.chams.Enabled = esp.chams[1] and pass;
                    end
                    if data.chams.Adornee ~= (data.chams.Enabled and char or nil) then
                        data.chams.Adornee = data.chams.Enabled and char or nil;
                        data.chams.Parent = data.chams.Enabled and char or nil;
                    end
                    if data.chams.Enabled then
                        data.chams.FillColor = esp.chams[2];
                        data.chams.OutlineColor = esp.chams[3];
                        data.chams.FillTransparency = esp.chams[4];
                        data.chams.OutlineTransparency = esp.chams[5];
                    end

                    pass = pass and onScreen
            
                    if pass and onScreen then

                        local boundingCFrame, boundingSize = char:GetBoundingBox()
                        local size = math.clamp((camera:WorldToViewportPoint((boundingCFrame * CFrame.new(0, -(boundingSize.Y / 2), 0)).p).Y - camera:WorldToViewportPoint((boundingCFrame * CFrame.new(0, boundingSize.Y / 2, 0)).p).Y) / 2, 1, 300);
                        local size = Vector2.new(math.floor(size * 1.4), math.floor(size * 2.2));
                        local pos = Vector2.new(math.floor(HRP.Position.X - Size * 1.5 / 2), math.floor(HRP.Position.Y - Size * 1.8 / 2));
                        local bottom = Vector2.new(pos.X + size.X / 2, pos.Y + size.Y);
                        
                        local bottom = Vector2.new(pos.X+size.X/2, pos.Y+size.Y);
                        
                        local padding, barSize = 2, esp.outline[1] and 1 or 2;
                        local topPos, bottomPos, leftPos, rightPos = -padding, padding, -padding, padding
                        local leftTextPos, rightTextPos = 0, 0;
                        
                        local targetColor = esp.targets[plr] or false;

                        local playerInfo = esp.GetPlayerInfo(plr);
                        local textInfo = playerInfo.text;
                        local barInfo = playerInfo.bar;
                        
                        if esp.teamcheck and plr.Team == game.Players.LocalPlayer.Team then
                            data.box.Visible = false
                            data.boxoutline.Visible = false
                        else
                            data.box.Visible = esp.box[1];
                            data.boxoutline.Visible = esp.box[1] and esp.outline[1];
                        end
                        data.boxfill.Visible = esp.box[1] and esp.boxfill[1];
                        if esp.box[1] then
                            data.box.Size = size;
                            data.box.Position = pos;
                            data.box.Color = esp.box[2];
                            
                            if esp.outline[1] then
                                data.boxoutline.Position = pos;
                                data.boxoutline.Size = size;
                                data.boxoutline.Color = esp.outline[2];
                            end
            
                            if esp.boxfill[1] then
                                data.boxfill.Size = size;
                                data.boxfill.Position = pos;
                                data.boxfill.Color = esp.boxfill[2];
                                data.boxfill.Transparency = data.boxfill.Transparency > esp.boxfill[3] and esp.boxfill[3] or data.boxfill.Transparency;
                            end
                        end
                        for flag, barData in next, data.bar do
                            local espBarData = esp.barlayout[flag];
                            local barInfo = barInfo[flag];
                            local barPos = espBarData.pos;
                            local obj1, obj2 = barData[1], barData[2];

                            if esp.teamcheck and plr.Team == game.Players.LocalPlayer.Team then
                                obj1.Visible = false
                            else
                                obj1.Visible = espBarData.enabled and barInfo ~= nil
                            end
                            obj2.Visible = obj1.Visible and esp.outline[1];
                            if obj1.Visible then
                                local isVert = barPos == 'right' or barPos == 'left'
                                local new = barSize + padding
                                
                                obj2.Color = esp.outline[2];
                                obj2.Size = isVert and Vector2.new(barSize + 2, size.Y + 2) or Vector2.new(size.X + 2, barSize + 2);
                                obj2.Thickness = 3
                                obj2.Position = (
                                    barPos == 'top' and pos - Vector2.new(1, barSize + (esp.outline[1] and 3 or 0) - topPos) or
                                    barPos == 'bottom' and pos + Vector2.new(-1, size.Y - (esp.outline[1] and 0 or 2) + bottomPos) or
                                    barPos == 'right' and  pos + Vector2.new(size.X - (esp.outline[1] and 0 or 2) + rightPos, esp.outline[1] and -1 or 2) or
                                    barPos == 'left' and pos - Vector2.new(barSize  + (esp.outline[1] and 2 or 0) - leftPos, esp.outline[1] and 1 or 2)
                                )

                                local barsize = (isVert and obj2.Size.Y or obj2.Size.X) - ConvertNumberRange(barInfo.value, barInfo.min or 0, barInfo.max or 100, 0, isVert and obj2.Size.Y or obj2.Size.X);

                                obj1.Size = obj2.Size - Vector2.new(2,2) - Vector2.new(isVert and 0 or barsize, isVert and barsize or 0)
                                obj1.Position = obj2.Position + Vector2.new(1,1) + Vector2.new(isVert and 0 or (obj2.Size.X - (esp.outline[1] and 2 or 0)) - obj1.Size.X, isVert and (obj2.Size.Y - (esp.outline[1] and 2 or 0)) - obj1.Size.Y or 0)

                                obj1.Color = espBarData.color1:Lerp(espBarData.color2, ConvertNumberRange(barInfo.value, barInfo.min or 0, barInfo.max or 100, 0, 1))

                                if barPos == 'top' then topPos -= new
                                elseif barPos == 'bottom' then bottomPos += new
                                elseif barPos == 'left' then leftPos -= new
                                elseif barPos == 'right' then rightPos += new
                                end

                            end

                        end

                        for flag, textData in next, data.text do
                            local espTextData = esp.textlayout[flag];
                            local textPos = espTextData.pos;
                            local obj = textData[1];

                            if esp.teamcheck and plr.Team == game.Players.LocalPlayer.Team then
                                obj.Visible = false
                            else
                                obj.Visible = espTextData.enabled and textInfo[flag] ~= nil;
                            end
                            if obj.Visible then
                                obj.Text = (textInfo[flag].text or flag)..(espTextData.suffix or '');
                                obj.Size = esp.textsize;
                                obj.Font = esp.textfont;
                                obj.Color = textInfo[flag].color or espTextData.color;
                                obj.Outline = esp.outline[1];
                                obj.OutlineColor = esp.outline[2];
                                obj.Center = (textPos == 'top' or textPos == 'bottom') and true or false;

                                obj.Position = (
                                    textPos == 'top' and pos - Vector2.new(- size.X / 2, textScaleBounds.Y + (esp.outline[1] and 1 or 0) - topPos) or
                                    textPos == 'bottom' and pos + Vector2.new(size.X / 2, size.Y - (esp.outline[1] and 0 or 2) + bottomPos) or
                                    textPos == 'right' and pos + Vector2.new(size.X + (esp.outline[1] and 1 or -1) + rightPos, rightTextPos) or
                                    textPos == 'left' and pos - Vector2.new(obj.TextBounds.X + (esp.outline[1] and 1 or -1) - leftPos, -leftTextPos)
                                )

                                if textPos == 'top' then topPos -= obj.TextBounds.Y
                                elseif textPos == 'bottom' then bottomPos += obj.TextBounds.Y
                                elseif textPos == 'left' then leftTextPos += obj.TextBounds.Y
                                elseif textPos == 'right' then rightTextPos += obj.TextBounds.Y
                                end

                            end
                        end

                    end
                end)
            end
        end)
    )

end
getgenv().esp = esp;
return esp