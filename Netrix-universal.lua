-- NETRIX HUB UNIVERSAL v8
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
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Cam = WS.CurrentCamera
local IMG = "rbxassetid://99262930883927"

-- cores e fontes do painel
local AC = Color3.fromRGB(150, 90, 255)
local AC2 = Color3.fromRGB(205, 130, 255)
local BG = Color3.fromRGB(15, 14, 22)
local PANEL = Color3.fromRGB(27, 26, 38)
local PANEL2 = Color3.fromRGB(38, 36, 54)
local LINE = Color3.fromRGB(46, 44, 64)
local OFF = Color3.fromRGB(58, 56, 76)
local SUB = Color3.fromRGB(150, 148, 178)
local W = Color3.new(1, 1, 1)
local FB, FM = Enum.Font.GothamBold, Enum.Font.GothamMedium

local mobile = UIS.TouchEnabled and not UIS.MouseEnabled
local draw = false
pcall(function() draw = Drawing ~= nil and Drawing.new ~= nil end)

local C = {Aim = false, AimHold = false, Part = "Cabeca", TeamCheck = false, WallCheck = false, ShowFOV = false,
	FOV = 150, AimSpeed = 10, Line = false, Skel = false, Box = false, Name = false, Health = false,
	Dist = false, ECol = "Roxo", ESPTeam = false, ESPY = 0, Walk = false, WalkVal = 32, Jump = false,
	JumpVal = 100, InfJump = false, Noclip = false, Fly = false, FlyVal = 60, Bright = false,
	CamOn = false, CamFOV = 70, AFK = false}
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
local function tw(o, t, p, style)
	TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p):Play()
end
local function stroke(o, col, th, tr)
	return N("UIStroke", {Color = col, Thickness = th or 1, Transparency = tr or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, o)
end

-- arrastar / segurar (mouse e toque)
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

-- ScreenGui
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

-- ==========================================
-- PAINEL PRINCIPAL
-- ==========================================
local vp0 = Cam.ViewportSize
local MW, MH = math.min(490, vp0.X - 24), math.min(330, vp0.Y - 40)

local Main = R(N("Frame", {Size = UDim2.new(0, MW, 0, MH), Position = UDim2.new(0.5, -MW / 2, 0.5, -MH / 2),
	BackgroundColor3 = W, BorderSizePixel = 0}, Gui), 16)
N("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(26, 20, 42), Color3.fromRGB(12, 12, 18)), Rotation = 135}, Main)
stroke(Main, AC, 1.2, 0.5)
local Scale = N("UIScale", {Scale = 1}, Main)

-- cabecalho
local Bar = N("Frame", {Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, Active = true}, Main)
local Logo = R(N("ImageLabel", {Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(0, 12, 0, 8),
	BackgroundColor3 = PANEL, BorderSizePixel = 0, Image = IMG, ScaleType = Enum.ScaleType.Crop}, Bar), 10)
T(Bar, "NETRIX HUB", UDim2.new(0, 52, 0, 7), UDim2.new(1, -110, 0, 18), FB, 15, W)
T(Bar, "Universal v8  •  YouTube: @Netrix ofc", UDim2.new(0, 52, 0, 25), UDim2.new(1, -110, 0, 14), FM, 10, SUB)
local X = R(N("TextButton", {Text = "—", Font = FB, TextSize = 14, TextColor3 = W, BackgroundColor3 = PANEL2,
	AutoButtonColor = false, BorderSizePixel = 0, Size = UDim2.new(0, 28, 0, 28),
	Position = UDim2.new(1, -40, 0, 10)}, Bar), 9)
X.MouseEnter:Connect(function() tw(X, 0.12, {BackgroundColor3 = Color3.fromRGB(210, 60, 90)}) end)
X.MouseLeave:Connect(function() tw(X, 0.12, {BackgroundColor3 = PANEL2}) end)
N("Frame", {Size = UDim2.new(1, -24, 0, 1), Position = UDim2.new(0, 12, 0, 48), BackgroundColor3 = LINE,
	BorderSizePixel = 0}, Main)
drag(Bar, Main)

-- menu lateral
local Side = R(N("Frame", {Size = UDim2.new(0, 108, 1, -64), Position = UDim2.new(0, 10, 0, 54),
	BackgroundColor3 = PANEL, BorderSizePixel = 0}, Main), 12)
N("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, Side)
N("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}, Side)

local Body = N("Frame", {Size = UDim2.new(1, -134, 1, -64), Position = UDim2.new(0, 126, 0, 54),
	BackgroundTransparency = 1, ClipsDescendants = true}, Main)

local pages, tabs = {}, {}
local function show(n)
	for k, p in pairs(pages) do p.Visible = (k == n) end
	for k, b in pairs(tabs) do
		local on = (k == n)
		tw(b, 0.15, {BackgroundTransparency = on and 0 or 1, TextColor3 = on and W or SUB})
	end
end
local function tab(name, label)
	local b = R(N("TextButton", {Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = AC, BackgroundTransparency = 1,
		Text = label, Font = FM, TextSize = 12, TextColor3 = SUB, AutoButtonColor = false, BorderSizePixel = 0,
		LayoutOrder = L()}, Side), 9)
	tabs[name] = b
	local pg = N("ScrollingFrame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 3, ScrollBarImageColor3 = AC, CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false}, Body)
	N("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, pg)
	N("UIPadding", {PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6)}, pg)
	pages[name] = pg
	b.MouseButton1Click:Connect(function() show(name) end)
	b.MouseEnter:Connect(function()
		if pages[name] and not pages[name].Visible then tw(b, 0.12, {BackgroundTransparency = 0.85}) end
	end)
	b.MouseLeave:Connect(function()
		if pages[name] and not pages[name].Visible then tw(b, 0.12, {BackgroundTransparency = 1}) end
	end)
	return pg
end

local function sec(pg, txt)
	local l = T(pg, string.upper(txt), UDim2.new(), UDim2.new(1, 0, 0, 16), FB, 10, SUB)
	l.LayoutOrder = L()
	N("UIPadding", {PaddingLeft = UDim.new(0, 4)}, l)
	return l
end
local function row(pg, h, cls)
	local r = R(N(cls or "Frame", {Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = PANEL, BorderSizePixel = 0,
		LayoutOrder = L()}, pg), 10)
	stroke(r, LINE, 1, 0.3)
	return r
end
local function hover(r)
	r.MouseEnter:Connect(function() tw(r, 0.12, {BackgroundColor3 = PANEL2}) end)
	r.MouseLeave:Connect(function() tw(r, 0.12, {BackgroundColor3 = PANEL}) end)
end

local function toggle(pg, txt, key)
	local r = row(pg, 36, "TextButton")
	r.Text = ""
	r.AutoButtonColor = false
	hover(r)
	T(r, txt, UDim2.new(0, 12, 0, 0), UDim2.new(1, -70, 1, 0), FM, 12, W)
	local t = R(N("Frame", {Size = UDim2.new(0, 38, 0, 20), Position = UDim2.new(1, -50, 0.5, -10),
		BorderSizePixel = 0}, r), 10)
	local k = R(N("Frame", {Size = UDim2.new(0, 16, 0, 16), BackgroundColor3 = W, BorderSizePixel = 0}, t), 8)
	local function paint(anim)
		local on = C[key]
		local tc = on and AC or OFF
		local kp = on and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
		if anim then
			tw(t, 0.15, {BackgroundColor3 = tc})
			tw(k, 0.15, {Position = kp})
		else
			t.BackgroundColor3 = tc
			k.Position = kp
		end
	end
	paint(false)
	r.MouseButton1Click:Connect(function()
		C[key] = not C[key]
		paint(true)
		if CB[key] then pcall(CB[key], C[key]) end
	end)
end

local function slider(pg, txt, mn, mx, key)
	local r = row(pg, 50)
	T(r, txt, UDim2.new(0, 12, 0, 5), UDim2.new(1, -80, 0, 18), FM, 12, W)
	local v = T(r, tostring(C[key]), UDim2.new(1, -66, 0, 5), UDim2.new(0, 54, 0, 18), FB, 12, AC2,
		Enum.TextXAlignment.Right)
	local bar = R(N("Frame", {Size = UDim2.new(1, -30, 0, 6), Position = UDim2.new(0, 15, 0, 34),
		BackgroundColor3 = OFF, BorderSizePixel = 0}, r), 3)
	local p0 = (C[key] - mn) / (mx - mn)
	local fill = R(N("Frame", {Size = UDim2.new(p0, 0, 1, 0), BackgroundColor3 = W, BorderSizePixel = 0}, bar), 3)
	N("UIGradient", {Color = ColorSequence.new(AC, AC2)}, fill)
	local knob = R(N("Frame", {Size = UDim2.new(0, 16, 0, 16), AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(p0, 0, 0.5, 0), BackgroundColor3 = W, BorderSizePixel = 0}, bar), 8)
	local hit = N("TextButton", {BackgroundTransparency = 1, Text = "", Position = UDim2.new(0, 6, 0, 22),
		Size = UDim2.new(1, -12, 0, 26)}, r)
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
	local r = row(pg, 36)
	T(r, txt, UDim2.new(0, 12, 0, 0), UDim2.new(1, -120, 1, 0), FM, 12, W)
	local b = R(N("TextButton", {Size = UDim2.new(0, 90, 0, 24), Position = UDim2.new(1, -100, 0.5, -12),
		BackgroundColor3 = color, Text = label, Font = FB, TextSize = 11, TextColor3 = W, AutoButtonColor = false,
		BorderSizePixel = 0}, r), 8)
	b.MouseEnter:Connect(function() tw(b, 0.12, {BackgroundColor3 = color:Lerp(W, 0.18)}) end)
	b.MouseLeave:Connect(function() tw(b, 0.12, {BackgroundColor3 = color}) end)
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

local A = tab("Aim", "🎯  Aim")
local E = tab("ESP", "👁  ESP")
local P = tab("Player", "🏃  Player")
local M = tab("Misc", "⚙  Misc")
local D = tab("Discord", "💬  Discord")

sec(A, "Mira")
toggle(A, "Ativar Aimbot", "Aim")
toggle(A, "Mirar so segurando botao direito (PC)", "AimHold")
pick(A, "Mirar em", {"Cabeca", "Tronco"}, "Part")
slider(A, "Velocidade da mira", 1, 20, "AimSpeed")
sec(A, "Filtros")
toggle(A, "Team Check", "TeamCheck")
toggle(A, "Wall Check", "WallCheck")
sec(A, "Circulo FOV")
toggle(A, "Mostrar circulo FOV", "ShowFOV")
slider(A, "Tamanho do FOV", 20, 500, "FOV")

sec(E, "Desenhos")
toggle(E, "ESP Line (vem de cima)", "Line")
toggle(E, "ESP Esqueleto", "Skel")
toggle(E, "ESP Caixa", "Box")
sec(E, "Informacoes")
toggle(E, "ESP Name", "Name")
toggle(E, "ESP Vida", "Health")
toggle(E, "ESP Distancia", "Dist")
sec(E, "Ajustes")
pick(E, "Cor do ESP", {"Roxo", "Vermelho", "Verde", "Azul", "Branco"}, "ECol")
toggle(E, "Ignorar meu time", "ESPTeam")
slider(E, "Ajuste vertical do ESP", -60, 60, "ESPY")

sec(P, "Movimento")
toggle(P, "Speed", "Walk")
slider(P, "Velocidade", 16, 150, "WalkVal")
toggle(P, "Pulo alto", "Jump")
slider(P, "Forca do pulo", 50, 300, "JumpVal")
toggle(P, "Pulo infinito", "InfJump")
toggle(P, "Noclip", "Noclip")
sec(P, "Voo")
toggle(P, "Fly", "Fly")
slider(P, "Velocidade do Fly", 20, 200, "FlyVal")

sec(M, "Visual")
toggle(M, "Fullbright", "Bright")
toggle(M, "Alterar FOV da camera", "CamOn")
slider(M, "FOV da camera", 30, 120, "CamFOV")
sec(M, "Outros")
toggle(M, "Anti AFK", "AFK")
btn(M, "Fechar hub", "FECHAR", Color3.fromRGB(210, 60, 90), function() Gui:Destroy() end)
local DISCORD = "https://discord.gg/yQyvXYM2CK"
sec(D, "Comunidade")
local card = row(D, 74)
T(card, "Entre no nosso Discord!", UDim2.new(0, 12, 0, 8), UDim2.new(1, -24, 0, 18), FB, 13, W)
T(card, DISCORD, UDim2.new(0, 12, 0, 28), UDim2.new(1, -24, 0, 16), FM, 11, AC2)
T(card, "Novidades, suporte e atualizacoes do Netrix Hub.", UDim2.new(0, 12, 0, 48), UDim2.new(1, -24, 0, 16), FM, 10, SUB)
btn(D, "Link do Discord", "COPIAR", AC, function(b)
	local okc = pcall(function() setclipboard(DISCORD) end)
	note(okc and "Link do Discord copiado!" or ("Seu executor nao copia. Link: " .. DISCORD))
end)

show("Aim")

-- abrir / fechar com animacao
local open = true
local function setOpen(v)
	open = v
	if v then
		Main.Visible = true
		Scale.Scale = 0.88
		tw(Scale, 0.22, {Scale = 1}, Enum.EasingStyle.Back)
	else
		tw(Scale, 0.14, {Scale = 0.88})
		task.delay(0.14, function() if not open then Main.Visible = false end end)
	end
end
X.MouseButton1Click:Connect(function() setOpen(false) end)

-- botao flutuante (quadrado arredondado, sem borda)
local Fl = R(N("ImageButton", {Size = UDim2.new(0, 58, 0, 58), Position = UDim2.new(0, 16, 0.5, -29),
	BackgroundTransparency = 1, BorderSizePixel = 0, Image = IMG, ScaleType = Enum.ScaleType.Crop,
	AutoButtonColor = false, ZIndex = 50}, Gui), 16)
local FlScale = N("UIScale", {Scale = 1}, Fl)
Fl.MouseEnter:Connect(function() tw(FlScale, 0.15, {Scale = 1.1}) end)
Fl.MouseLeave:Connect(function() tw(FlScale, 0.15, {Scale = 1}) end)
Fl.MouseButton1Down:Connect(function() tw(FlScale, 0.1, {Scale = 0.92}) end)
Fl.MouseButton1Up:Connect(function() tw(FlScale, 0.1, {Scale = 1}) end)
drag(Fl, Fl, function() setOpen(not open) end)
setOpen(true)
note("Painel carregado! Toque na imagem para abrir/fechar.")

-- ==========================================
-- AIMBOT
-- ==========================================
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
local function updateEnemy()
	local now = os.clock()
	if now - lastT < 2 then return end
	lastT = now
	enemy = false
	local my = LP.Team
	if my then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LP and p.Team and p.Team ~= my then enemy = true break end
		end
	end
end

local function aimPart(ch)
	if C.Part == "Cabeca" then return ch:FindFirstChild("Head") end
	return ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso") or ch:FindFirstChild("HumanoidRootPart")
end

-- devolve a parte e a distancia ate o centro da tela (ou nil se nao serve)
local function candidate(p, c0, limit)
	if p == LP then return nil end
	if C.TeamCheck and enemy and p.Team == LP.Team then return nil end
	local ch = p.Character
	local h = ch and ch:FindFirstChildOfClass("Humanoid")
	if not (h and h.Health > 0) then return nil end
	local part = aimPart(ch)
	if not part then return nil end
	local pos, on = Cam:WorldToViewportPoint(part.Position)
	if not on then return nil end
	local d = (Vector2.new(pos.X, pos.Y) - c0).Magnitude
	if d > limit then return nil end
	if C.WallCheck and not clear(part, ch) then return nil end
	return part, d
end

local lockP -- alvo travado (evita ficar trocando de pessoa)
local function target(c0)
	updateEnemy()
	if lockP and lockP.Parent then
		local part = candidate(lockP, c0, C.FOV * 1.25)
		if part then return part end
	end
	lockP = nil
	local best, bd, bp = nil, C.FOV, nil
	for _, p in ipairs(Players:GetPlayers()) do
		local part, d = candidate(p, c0, bd)
		if part and d < bd then best, bd, bp = part, d, p end
	end
	lockP = bp
	return best
end

local function aim(dt)
	if C.AimHold and not mobile and not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
		lockP = nil
		return
	end
	local t = target(center())
	if t then
		local goal = CFrame.new(Cam.CFrame.Position, t.Position)
		local a = 1
		if C.AimSpeed < 20 then a = 1 - math.exp(-C.AimSpeed * 4.2 * dt) end
		Cam.CFrame = Cam.CFrame:Lerp(goal, math.clamp(a, 0.03, 1))
	end
end

-- ==========================================
-- ESP
-- ==========================================
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
local function getp(o, ch, n)
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
	local oy = C.ESPY
	local mine = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")

	for p, o in pairs(ESP) do
		local ch = p.Character
		local h = ch and ch:FindFirstChildOfClass("Humanoid")
		local rt = ch and getp(o, ch, "HumanoidRootPart")
		if not (h and h.Health > 0 and rt) or (C.ESPTeam and p.Team ~= nil and p.Team == LP.Team) then
			hide(o)
		else
			-- tudo e calculado a partir do HumanoidRootPart (nao treme com a animacao)
			local base = rt.Position
			local rp, on = Cam:WorldToViewportPoint(base)
			if not on then
				hide(o)
			else
				local top = Cam:WorldToViewportPoint(base + Vector3.new(0, 2.7, 0))
				local bot = Cam:WorldToViewportPoint(base - Vector3.new(0, 3.1, 0))
				local topY, botY = top.Y + oy, bot.Y + oy
				local hh = math.abs(botY - topY)
				local ww = hh * 0.55
				local cx = rp.X

				o.ln.Visible = C.Line
				if C.Line then
					-- linha saindo do topo da tela ate a cabeca do jogador
					o.ln.From = Vector2.new(vp.X / 2, 0)
					o.ln.To = Vector2.new(cx, topY)
				end

				o.bx.Visible = C.Box
				if C.Box then
					o.bx.Size = Vector2.new(ww, hh)
					o.bx.Position = Vector2.new(cx - ww / 2, topY)
				end

				o.nm.Visible = C.Name
				if C.Name then
					o.nm.Text = p.DisplayName
					o.nm.Position = Vector2.new(cx, topY - 16)
				end

				o.hp.Visible = C.Health
				if C.Health then
					local f = math.clamp(h.Health / math.max(h.MaxHealth, 1), 0, 1)
					local x = cx - ww / 2 - 5
					o.hp.From = Vector2.new(x, topY + hh)
					o.hp.To = Vector2.new(x, topY + hh * (1 - f))
					o.hp.Color = Color3.new(1 - f, f, 0.25)
				end

				o.ds.Visible = C.Dist
				if C.Dist and mine then
					o.ds.Text = math.floor((rt.Position - mine.Position).Magnitude) .. "m"
					o.ds.Position = Vector2.new(cx, topY + hh + 2)
				end

				local list = getp(o, ch, "UpperTorso") and R15 or R6
				for i = 1, #list do
					local b = o.bn[i]
					if not b then
						b = line()
						o.bn[i] = b
					end
					b.Visible = false
					if C.Skel then
						local a, c = getp(o, ch, list[i][1]), getp(o, ch, list[i][2])
						if a and c then
							local pa, va = Cam:WorldToViewportPoint(a.Position)
							local pc, vc = Cam:WorldToViewportPoint(c.Position)
							if va and vc then
								b.From = Vector2.new(pa.X, pa.Y + oy)
								b.To = Vector2.new(pc.X, pc.Y + oy)
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

-- ==========================================
-- PLAYER / MISC
-- ==========================================
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
CB.Aim = function(v) if not v then lockP = nil end end

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

-- ==========================================
-- LOOP PRINCIPAL
-- ==========================================
local origFOV

-- mira + movimento (roda junto da camera)
local function stepMain(dt)
	Cam = WS.CurrentCamera
	if C.Aim then pcall(aim, dt) end

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

-- ESP + circulo FOV (roda por ultimo, depois da camera parar de mexer)
-- o circulo FOV e independente do aimbot: aparece so se "Mostrar circulo FOV" estiver ligado
local function stepDraw()
	Cam = WS.CurrentCamera
	if fov then
		fov.Visible = C.ShowFOV
		if C.ShowFOV then
			fov.Radius = C.FOV
			fov.Position = center()
		end
	end
	if draw then pcall(esp) end
end

local bound = pcall(function()
	RS:BindToRenderStep("NetrixHubLoop", Enum.RenderPriority.Camera.Value + 1, stepMain)
end)
local conn
if not bound then conn = RS.RenderStepped:Connect(stepMain) end

local boundDraw = pcall(function()
	RS:BindToRenderStep("NetrixHubDraw", Enum.RenderPriority.Last.Value, stepDraw)
end)
local conn2
if not boundDraw then conn2 = RS.RenderStepped:Connect(stepDraw) end

Gui.Destroying:Connect(function()
	if bound then pcall(function() RS:UnbindFromRenderStep("NetrixHubLoop") end) end
	if conn then conn:Disconnect() end
	if boundDraw then pcall(function() RS:UnbindFromRenderStep("NetrixHubDraw") end) end
	if conn2 then conn2:Disconnect() end
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
