-- NETRIX HUB UNIVERSAL v7 (painel simples)
local function note(t)
pcall(function()
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Netrix Hub", Text = t, Duration = 5})
end)
end
note("Carregando...")
local ok, err = pcall(function()
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local WS = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Cam = WS.CurrentCamera
local IMG = "rbxassetid://99262930883927"
local AC = Color3.fromRGB(150, 90, 255)
local BG = Color3.fromRGB(22, 22, 28)
local PANEL = Color3.fromRGB(32, 32, 42)
local OFF = Color3.fromRGB(62, 62, 78)
local SUB = Color3.fromRGB(165, 165, 190)
local W = Color3.new(1, 1, 1)
local FB, FM = Enum.Font.GothamBold, Enum.Font.GothamMedium -- fonte do painel
local mobile = UIS.TouchEnabled and not UIS.MouseEnabled
local draw = false
pcall(function() draw = Drawing ~= nil and Drawing.new ~= nil end)
local C = {Aim = false, Part = "Cabeca", TeamCheck = true, WallCheck = false, ShowFOV = true, FOV = 150,
AimSpeed = 10, Line = false, Skel = false, Box = false, Name = false, Health = false, Dist = false,
ECol = "Roxo", ESPTeam = false, Walk = false, WalkVal = 32, Jump = false, JumpVal = 100, InfJump = false,
Noclip = false, Fly = false, FlyVal = 60, Bright = false, CamOn = false, CamFOV = 70, AFK = true}
local CB = {}
local ord = 0
local function L() ord = ord + 1 return ord end
local function N(c, p, par)
local o = Instance.new(c)
for k, v in pairs(p) do o[k] = v end
if par then o.Parent = par end
return o
end
local function R(o, r) N("UICorner", {CornerRadius = UDim.new(0, r)}, o) return o end
local function T(par, txt, pos, size, font, ts, col, al)
return N("TextLabel", {BackgroundTransparency = 1, Position = pos, Size = size, Text = txt, Font = font,
TextSize = ts, TextColor3 = col, TextXAlignment = al or Enum.TextXAlignment.Left}, par)
end
local act
UIS.InputChanged:Connect(function(i)
if act and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
act.up(i.Position)
end
end)
UIS.InputEnded:Connect(function(i)
if act and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
local a = act
act = nil
if a.fin then a.fin() end
end
end)
local function drag(handle, target, click)
handle.InputBegan:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
local sp, su, moved = i.Position, target.Position, false
act = {
up = function(p)
local d = p - sp
if d.Magnitude > 6 then moved = true end
target.Position = UDim2.new(su.X.Scale, su.X.Offset + d.X, su.Y.Scale, su.Y.Offset + d.Y)
end,
fin = function() if click and not moved then click() end end,
}
end
end)
end
local Gui = N("ScreenGui", {Name = "NetrixHubUniversal", ResetOnSpawn = false, IgnoreGuiInset = true,
DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
local tg = {}
pcall(function() if gethui then tg[#tg + 1] = gethui() end end)
pcall(function() tg[#tg + 1] = game:GetService("CoreGui") end)
tg[#tg + 1] = LP:WaitForChild("PlayerGui")
for _, t in ipairs(tg) do
pcall(function()
local o = t:FindFirstChild("NetrixHubUniversal")
if o then o:Destroy() end
end)
end
for _, t in ipairs(tg) do
if pcall(function() Gui.Parent = t end) and Gui.Parent == t then break end
end
local Main = R(N("Frame", {Size = UDim2.new(0, 420, 0, 270), Position = UDim2.new(0.5, -210, 0.5, -135),
BackgroundColor3 = BG, BorderSizePixel = 0}, Gui), 8)
N("UIStroke", {Color = Color3.fromRGB(55, 55, 72), Thickness = 1}, Main)
local Bar = N("Frame", {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Active = true}, Main)
T(Bar, "Netrix Hub Universal", UDim2.new(0, 12, 0, 0), UDim2.new(1, -50, 1, 0), FB, 14, W)
local X = N("TextButton", {Text = "X", Font = FB, TextSize = 14, TextColor3 = Color3.fromRGB(255, 90, 100),
BackgroundTransparency = 1, Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(1, -32, 0, 0)}, Bar)
N("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 32),
BackgroundColor3 = Color3.fromRGB(50, 50, 66), BorderSizePixel = 0}, Main)
drag(Bar, Main)
local Side = R(N("Frame", {Size = UDim2.new(0, 96, 1, -42), Position = UDim2.new(0, 6, 0, 38),
BackgroundColor3 = PANEL, BorderSizePixel = 0}, Main), 6)
N("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, Side)
N("UIPadding", {PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}, Side)
local Body = N("Frame", {Size = UDim2.new(1, -114, 1, -42), Position = UDim2.new(0, 108, 0, 38),
BackgroundTransparency = 1, ClipsDescendants = true}, Main)
local pages, tabs = {}, {}
local function show(n)
for k, p in pairs(pages) do p.Visible = (k == n) end
for k, b in pairs(tabs) do
local on = (k == n)
b.BackgroundColor3 = on and AC or PANEL
b.TextColor3 = on and W or SUB
end
end
local function tab(name)
local b = R(N("TextButton", {Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = PANEL, Text = name, Font = FM,
TextSize = 12, TextColor3 = SUB, AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = L()}, Side), 6)
tabs[name] = b
local pg = N("ScrollingFrame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
ScrollBarThickness = 3, ScrollBarImageColor3 = AC, CanvasSize = UDim2.new(),
AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false}, Body)
N("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, pg)
N("UIPadding", {PaddingRight = UDim.new(0, 6)}, pg)
pages[name] = pg
b.MouseButton1Click:Connect(function() show(name) end)
return pg
end
local function row(pg, h, cls)
return R(N(cls or "Frame", {Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = PANEL, BorderSizePixel = 0,
LayoutOrder = L()}, pg), 6)
end
local function toggle(pg, txt, key)
local r = row(pg, 32, "TextButton")
r.Text = ""
r.AutoButtonColor = false
T(r, txt, UDim2.new(0, 10, 0, 0), UDim2.new(1, -60, 1, 0), FM, 12, W)
local t = R(N("Frame", {Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -44, 0.5, -9),
BorderSizePixel = 0}, r), 9)
local k = R(N("Frame", {Size = UDim2.new(0, 14, 0, 14), BackgroundColor3 = W, BorderSizePixel = 0}, t), 7)
local function paint()
t.BackgroundColor3 = C[key] and AC or OFF
k.Position = C[key] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
end
paint()
r.MouseButton1Click:Connect(function()
C[key] = not C[key]
paint()
if CB[key] then pcall(CB[key], C[key]) end
end)
end
local function slider(pg, txt, mn, mx, key)
local r = row(pg, 44)
T(r, txt, UDim2.new(0, 10, 0, 4), UDim2.new(1, -70, 0, 18), FM, 12, W)
local v = T(r, tostring(C[key]), UDim2.new(1, -60, 0, 4), UDim2.new(0, 50, 0, 18), FB, 12, AC,
Enum.TextXAlignment.Right)
local bar = R(N("Frame", {Size = UDim2.new(1, -28, 0, 6), Position = UDim2.new(0, 14, 0, 31),
BackgroundColor3 = OFF, BorderSizePixel = 0}, r), 3)
local p0 = (C[key] - mn) / (mx - mn)
local fill = R(N("Frame", {Size = UDim2.new(p0, 0, 1, 0), BackgroundColor3 = AC, BorderSizePixel = 0}, bar), 3)
local knob = R(N("Frame", {Size = UDim2.new(0, 16, 0, 16), AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.new(p0, 0, 0.5, 0), BackgroundColor3 = W, BorderSizePixel = 0}, bar), 8)
local hit = N("TextButton", {BackgroundTransparency = 1, Text = "", Position = UDim2.new(0, 6, 0, 20),
Size = UDim2.new(1, -12, 0, 24)}, r)
local function set(x)
local rel = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
local val = math.floor(mn + (mx - mn) * rel + 0.5)
local s = (val - mn) / (mx - mn)
C[key] = val
fill.Size = UDim2.new(s, 0, 1, 0)
knob.Position = UDim2.new(s, 0, 0.5, 0)
v.Text = tostring(val)
end
hit.InputBegan:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
pg.ScrollingEnabled = false
set(i.Position.X)
act = {up = function(p) set(p.X) end, fin = function() pg.ScrollingEnabled = true end}
end
end)
end
local function btn(pg, txt, label, color, cb)
local r = row(pg, 32)
T(r, txt, UDim2.new(0, 10, 0, 0), UDim2.new(1, -110, 1, 0), FM, 12, W)
local b = R(N("TextButton", {Size = UDim2.new(0, 84, 0, 22), Position = UDim2.new(1, -94, 0.5, -11),
BackgroundColor3 = color, Text = label, Font = FB, TextSize = 11, TextColor3 = W, BorderSizePixel = 0}, r), 5)
b.MouseButton1Click:Connect(function() cb(b) end)
end
local function pick(pg, txt, opts, key)
local i = table.find(opts, C[key]) or 1
btn(pg, txt, opts[i], AC, function(b)
i = i % #opts + 1
b.Text = opts[i]
C[key] = opts[i]
end)
end
local A, E, P, M = tab("Aim"), tab("ESP"), tab("Player"), tab("Misc")
toggle(A, "Ativar Aimbot", "Aim")
pick(A, "Mirar em", {"Cabeca", "Tronco"}, "Part")
toggle(A, "Team Check", "TeamCheck")
toggle(A, "Wall Check", "WallCheck")
toggle(A, "Mostrar circulo FOV", "ShowFOV")
slider(A, "Tamanho do FOV", 20, 500, "FOV")
slider(A, "Velocidade da mira", 1, 20, "AimSpeed")
toggle(E, "ESP Line", "Line")
toggle(E, "ESP Esqueleto", "Skel")
toggle(E, "ESP Caixa", "Box")
toggle(E, "ESP Name", "Name")
toggle(E, "ESP Vida", "Health")
toggle(E, "ESP Distancia", "Dist")
pick(E, "Cor do ESP", {"Roxo", "Vermelho", "Verde", "Azul", "Branco"}, "ECol")
toggle(E, "Ignorar meu time", "ESPTeam")
toggle(P, "Speed", "Walk")
slider(P, "Velocidade", 16, 150, "WalkVal")
toggle(P, "Pulo alto", "Jump")
slider(P, "Forca do pulo", 50, 300, "JumpVal")
toggle(P, "Pulo infinito", "InfJump")
toggle(P, "Noclip", "Noclip")
toggle(P, "Fly", "Fly")
slider(P, "Velocidade do Fly", 20, 200, "FlyVal")
toggle(M, "Fullbright", "Bright")
toggle(M, "Alterar FOV da camera", "CamOn")
slider(M, "FOV da camera", 30, 120, "CamFOV")
toggle(M, "Anti AFK", "AFK")
btn(M, "Fechar hub", "FECHAR", Color3.fromRGB(210, 60, 90), function() Gui:Destroy() end)
show("Aim")
local Fl = R(N("ImageButton", {Size = UDim2.new(0, 52, 0, 52), Position = UDim2.new(0, 16, 0.5, -26),
BackgroundTransparency = 1, BorderSizePixel = 0, Image = IMG, ScaleType = Enum.ScaleType.Crop,
AutoButtonColor = false, ZIndex = 50}, Gui), 14)
drag(Fl, Fl, function() Main.Visible = not Main.Visible end)
X.MouseButton1Click:Connect(function() Main.Visible = false end)
note("Painel carregado! Toque na imagem para abrir/fechar.")
local fov
if draw then
pcall(function()
fov = Drawing.new("Circle")
fov.Thickness = 1.5
fov.NumSides = 48
fov.Filled = false
fov.Color = AC
fov.Visible = false
end)
end
local function center()
if mobile then return Cam.ViewportSize / 2 end
return UIS:GetMouseLocation()
end
local rayP = RaycastParams.new()
rayP.FilterType = Enum.RaycastFilterType.Exclude
local function clear(part, ch)
local o = Cam.CFrame.Position
local list = {ch}
if LP.Character then list[2] = LP.Character end
rayP.FilterDescendantsInstances = list
return WS:Raycast(o, part.Position - o, rayP) == nil
end
local enemy, lastT = false, 0
local function target(c0)
local now = os.clock()
if now - lastT > 2 then
lastT = now
enemy = false
local my = LP.Team
if my then
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LP and p.Team and p.Team ~= my then enemy = true break end
end
end
end
local best, bd = nil, C.FOV
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LP and not (C.TeamCheck and enemy and p.Team == LP.Team) then
local ch = p.Character
local h = ch and ch:FindFirstChildOfClass("Humanoid")
if h and h.Health > 0 then
local part
if C.Part == "Cabeca" then
part = ch:FindFirstChild("Head")
else
part = ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso") or ch:FindFirstChild("HumanoidRootPart")
end
if part then
local pos, on = Cam:WorldToViewportPoint(part.Position)
if on then
local d = (Vector2.new(pos.X, pos.Y) - c0).Magnitude
if d < bd and (not C.WallCheck or clear(part, ch)) then best, bd = part, d end
end
end
end
end
end
return best
end
local function aim()
local t = target(center())
if t then
local goal = CFrame.new(Cam.CFrame.Position, t.Position)
Cam.CFrame = Cam.CFrame:Lerp(goal, math.clamp(C.AimSpeed / 20, 0.05, 1))
end
end
local function bones(s)
local t = {}
for a, b in s:gmatch("([%w ]+)-([%w ]+)") do t[#t + 1] = {a, b} end
return t
end
local R15 = bones("Head-UpperTorso,UpperTorso-LowerTorso,UpperTorso-LeftUpperArm,LeftUpperArm-LeftLowerArm,LeftLowerArm-LeftHand,UpperTorso-RightUpperArm,RightUpperArm-RightLowerArm,RightLowerArm-RightHand,LowerTorso-LeftUpperLeg,LeftUpperLeg-LeftLowerLeg,LeftLowerLeg-LeftFoot,LowerTorso-RightUpperLeg,RightUpperLeg-RightLowerLeg,RightLowerLeg-RightFoot")
local R6 = bones("Head-Torso,Torso-Left Arm,Torso-Right Arm,Torso-Left Leg,Torso-Right Leg")
local COLS = {Roxo = Color3.fromRGB(170, 110, 255), Vermelho = Color3.fromRGB(255, 70, 90),
Verde = Color3.fromRGB(70, 230, 130), Azul = Color3.fromRGB(80, 170, 255), Branco = W}
local curCol = COLS.Roxo
local ESP, shown = {}, false
local function line(th)
local l = Drawing.new("Line")
l.Thickness = th or 1.5
l.Color = curCol
l.Visible = false
return l
end
local function txt(sz, col)
local t = Drawing.new("Text")
t.Size = sz
t.Center = true
t.Outline = true
t.Color = col
t.Visible = false
return t
end
local function mk(p)
local good, o = pcall(function()
local bx = Drawing.new("Square")
bx.Thickness = 1.5
bx.Filled = false
bx.Color = curCol
bx.Visible = false
return {ln = line(), bx = bx, nm = txt(14, W), ds = txt(12, Color3.fromRGB(210, 210, 230)),
hp = line(3), bn = {}, pt = {}}
end)
if good then ESP[p] = o end
end
local function hide(o)
o.ln.Visible = false
o.bx.Visible = false
o.nm.Visible = false
o.ds.Visible = false
o.hp.Visible = false
for _, b in ipairs(o.bn) do b.Visible = false end
end
local function kill(o)
pcall(function()
o.ln:Remove()
o.bx:Remove()
o.nm:Remove()
o.ds:Remove()
o.hp:Remove()
for _, b in ipairs(o.bn) do b:Remove() end
end)
end
Players.PlayerRemoving:Connect(function(p)
local o = ESP[p]
if o then
kill(o)
ESP[p] = nil
end
end)
local function part(o, ch, n)
local p = o.pt[n]
if p and p.Parent then return p end
p = ch:FindFirstChild(n)
o.pt[n] = p
return p
end
local function esp()
if not (C.Line or C.Skel or C.Box or C.Name or C.Health or C.Dist) then
if shown then
for _, o in pairs(ESP) do hide(o) end
shown = false
end
return
end
shown = true
local col = COLS[C.ECol] or COLS.Roxo
if col ~= curCol then
curCol = col
for _, o in pairs(ESP) do
o.ln.Color = col
o.bx.Color = col
for _, b in ipairs(o.bn) do b.Color = col end
end
end
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LP and not ESP[p] then mk(p) end
end
local vp = Cam.ViewportSize
local mine = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
for p, o in pairs(ESP) do
local ch = p.Character
local h = ch and ch:FindFirstChildOfClass("Humanoid")
local rt = ch and part(o, ch, "HumanoidRootPart")
local hd = ch and part(o, ch, "Head")
if not (h and h.Health > 0 and rt and hd) or (C.ESPTeam and p.Team ~= nil and p.Team == LP.Team) then
hide(o)
else
local rp, on = Cam:WorldToViewportPoint(rt.Position)
if not on then
hide(o)
else
local top = Cam:WorldToViewportPoint(hd.Position + Vector3.new(0, 0.7, 0))
local bot = Cam:WorldToViewportPoint(rt.Position - Vector3.new(0, 3.2, 0))
local hh = math.abs(bot.Y - top.Y)
local ww = hh * 0.55
o.ln.Visible = C.Line
if C.Line then
o.ln.From = Vector2.new(vp.X / 2, vp.Y)
o.ln.To = Vector2.new(rp.X, bot.Y)
end
o.bx.Visible = C.Box
if C.Box then
o.bx.Size = Vector2.new(ww, hh)
o.bx.Position = Vector2.new(rp.X - ww / 2, top.Y)
end
o.nm.Visible = C.Name
if C.Name then
o.nm.Text = p.DisplayName
o.nm.Position = Vector2.new(rp.X, top.Y - 16)
end
o.hp.Visible = C.Health
if C.Health then
local f = math.clamp(h.Health / math.max(h.MaxHealth, 1), 0, 1)
local x = rp.X - ww / 2 - 5
o.hp.From = Vector2.new(x, top.Y + hh)
o.hp.To = Vector2.new(x, top.Y + hh * (1 - f))
o.hp.Color = Color3.new(1 - f, f, 0.25)
end
o.ds.Visible = C.Dist
if C.Dist and mine then
o.ds.Text = math.floor((rt.Position - mine.Position).Magnitude) .. "m"
o.ds.Position = Vector2.new(rp.X, top.Y + hh + 2)
end
local list = part(o, ch, "UpperTorso") and R15 or R6
for i = 1, #list do
local b = o.bn[i]
if not b then
b = line()
o.bn[i] = b
end
b.Visible = false
if C.Skel then
local a, c = part(o, ch, list[i][1]), part(o, ch, list[i][2])
if a and c then
local pa, va = Cam:WorldToViewportPoint(a.Position)
local pc, vc = Cam:WorldToViewportPoint(c.Position)
if va and vc then
b.From = Vector2.new(pa.X, pa.Y)
b.To = Vector2.new(pc.X, pc.Y)
b.Visible = true
end
end
end
end
for i = #list + 1, #o.bn do o.bn[i].Visible = false end
end
end
end
end
local function hum()
local c = LP.Character
return c and c:FindFirstChildOfClass("Humanoid")
end
local flyBV
local function stopFly()
if flyBV then
flyBV:Destroy()
flyBV = nil
end
end
local function fly(h)
local ch = LP.Character
local rt = ch and ch:FindFirstChild("HumanoidRootPart")
if not rt then return end
if not flyBV or flyBV.Parent ~= rt then
stopFly()
flyBV = Instance.new("BodyVelocity")
flyBV.MaxForce = Vector3.new(1e6, 1e6, 1e6)
flyBV.Velocity = Vector3.new(0, 0, 0)
flyBV.Parent = rt
end
local md = h.MoveDirection
if md.Magnitude > 0.05 then
local look = Cam.CFrame.LookVector
local flat = Vector3.new(look.X, 0, look.Z)
local sign = 1
if flat.Magnitude > 0.01 and md:Dot(flat.Unit) < 0 then sign = -1 end
flyBV.Velocity = Vector3.new(md.X * C.FlyVal, look.Y * sign * C.FlyVal, md.Z * C.FlyVal)
else
flyBV.Velocity = Vector3.new(0, 0, 0)
end
end
local lightOld
local function setBright(v)
if v then
if not lightOld then
lightOld = {Lighting.Brightness, Lighting.ClockTime, Lighting.FogEnd, Lighting.GlobalShadows,
Lighting.Ambient, Lighting.OutdoorAmbient}
end
Lighting.Brightness = 2
Lighting.ClockTime = 14
Lighting.FogEnd = 1e6
Lighting.GlobalShadows = false
Lighting.Ambient = Color3.fromRGB(190, 190, 190)
Lighting.OutdoorAmbient = Color3.fromRGB(190, 190, 190)
elseif lightOld then
Lighting.Brightness = lightOld[1]
Lighting.ClockTime = lightOld[2]
Lighting.FogEnd = lightOld[3]
Lighting.GlobalShadows = lightOld[4]
Lighting.Ambient = lightOld[5]
Lighting.OutdoorAmbient = lightOld[6]
lightOld = nil
end
end
CB.Walk = function(v)
local h = hum()
if h and not v then h.WalkSpeed = 16 end
end
CB.Jump = function(v)
local h = hum()
if h and not v then h.JumpPower = 50 end
end
CB.Fly = function(v) if not v then stopFly() end end
CB.Bright = setBright
local nc, ncT = {}, 0
local ncConn = RS.Stepped:Connect(function()
if not C.Noclip then return end
local ch = LP.Character
if not ch then return end
local now = os.clock()
if now - ncT > 1 then
ncT = now
nc = {}
for _, d in ipairs(ch:GetDescendants()) do
if d:IsA("BasePart") then nc[#nc + 1] = d end
end
end
for _, d in ipairs(nc) do d.CanCollide = false end
end)
local jConn = UIS.JumpRequest:Connect(function()
if C.InfJump then
local h = hum()
if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end
end)
local idleConn = LP.Idled:Connect(function()
if C.AFK then
pcall(function()
local vu = game:GetService("VirtualUser")
vu:CaptureController()
vu:ClickButton2(Vector2.new())
end)
end
end)
local origFOV
local function step()
Cam = WS.CurrentCamera
if fov then
local s = C.ShowFOV and C.Aim
fov.Visible = s
if s then
fov.Radius = C.FOV
fov.Position = center()
end
end
if C.Aim then pcall(aim) end
if draw then pcall(esp) end
local h = hum()
if h then
if C.Walk and h.WalkSpeed ~= C.WalkVal then h.WalkSpeed = C.WalkVal end
if C.Jump then
if not h.UseJumpPower then h.UseJumpPower = true end
if h.JumpPower ~= C.JumpVal then h.JumpPower = C.JumpVal end
end
if C.Fly then pcall(fly, h) end
end
if C.CamOn then
if not origFOV then origFOV = Cam.FieldOfView end
Cam.FieldOfView = C.CamFOV
elseif origFOV then
Cam.FieldOfView = origFOV
origFOV = nil
end
end
local bound = pcall(function()
RS:BindToRenderStep("NetrixHubLoop", Enum.RenderPriority.Camera.Value + 1, step)
end)
local conn
if not bound then conn = RS.RenderStepped:Connect(step) end
Gui.Destroying:Connect(function()
if bound then pcall(function() RS:UnbindFromRenderStep("NetrixHubLoop") end) end
if conn then conn:Disconnect() end
ncConn:Disconnect()
jConn:Disconnect()
idleConn:Disconnect()
stopFly()
setBright(false)
if origFOV then Cam.FieldOfView = origFOV end
local h = hum()
if h then
if C.Walk then h.WalkSpeed = 16 end
if C.Jump then h.JumpPower = 50 end
end
if fov then pcall(function() fov:Remove() end) end
for _, o in pairs(ESP) do kill(o) end
end)
if not draw then note("Seu executor nao tem Drawing: ESP e FOV desativados.") end
end)
if not ok then
warn("[Netrix Hub] erro: " .. tostring(err))
note("ERRO: " .. string.sub(tostring(err), 1, 150))
end
