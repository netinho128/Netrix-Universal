-- NETRIX HUB UNIVERSAL v12
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
local HS = game:GetService("HttpService")
local TS = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Cam = WS.CurrentCamera

local IMG = "rbxassetid://71668099351887"
local DISCORD = "https://discord.gg/yQyvXYM2CK"
local YOUTUBE_NAME = "Netrix _ OFC"
local VERSION = "v12"
local GUI_NAME = "NetrixHubV12"

local AC = Color3.fromRGB(150, 90, 255)
local AC2 = Color3.fromRGB(205, 130, 255)
local BG = Color3.fromRGB(13, 11, 21)
local BG2 = Color3.fromRGB(22, 17, 38)
local PANEL = Color3.fromRGB(20, 17, 33)
local PANEL2 = Color3.fromRGB(34, 30, 52)
local OFF = Color3.fromRGB(60, 57, 80)
local SUB = Color3.fromRGB(150, 148, 178)
local W = Color3.new(1, 1, 1)
local RED = Color3.fromRGB(210, 60, 90)
local FB, FM = Enum.Font.GothamBold, Enum.Font.GothamMedium
local mobile0 = UIS.TouchEnabled and not UIS.MouseEnabled

-- ==========================================
-- CONFIGURACOES
-- ==========================================
local C = {
	Aim = false, Part = "Cabeca", TeamCheck = false, WallCheck = false,
	ShowFOV = false, FOV = 150,
	Line = false, Box = false, Name = false, Health = false, Dist = false, ECol = "Roxo", ESPTeam = false, ESPOffset = 0,
	Walk = false, WalkVal = 32, Jump = false, JumpVal = 100, InfJump = false, AFK = false,
	Noclip = false, Fly = false, FlyVal = 60,
	Platform = "Auto", Trigger = "Sempre", AimKey = "E", AimMode = "Auto", FOVOrigin = "Centro", MenuKey = "RightShift",
}
local CFGFILE = "NetrixHubUniversal.json"
pcall(function()
	if isfile and readfile and isfile(CFGFILE) then
		local d = HS:JSONDecode(readfile(CFGFILE))
		for k, v in pairs(d) do
			if C[k] ~= nil and type(C[k]) == type(v) then C[k] = v end
		end
	end
end)
-- movimento sempre comeca desligado (evita voar/atravessar parede ao abrir)
C.Noclip, C.Fly = false, false

local function isMobile()
	if C.Platform == "PC" then return false end
	if C.Platform == "Celular" then return true end
	return mobile0
end

local draw = false
pcall(function() draw = Drawing ~= nil and Drawing.new ~= nil end)

-- ==========================================
-- AJUDANTES DE INTERFACE
-- ==========================================
local conns = {}
local function keep(c) conns[#conns + 1] = c return c end

local function New(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props or {}) do o[k] = v end
	if parent then o.Parent = parent end
	return o
end
local function Round(o, r) New("UICorner", {CornerRadius = UDim.new(0, r)}, o) return o end
local function Stroke(o, col, th, tr)
	return New("UIStroke", {Color = col, Thickness = th or 1, Transparency = tr or 0}, o)
end
local function Label(par, txt, pos, size, font, ts, col, align)
	return New("TextLabel", {BackgroundTransparency = 1, Position = pos, Size = size, Text = txt, Font = font,
		TextSize = ts, TextColor3 = col, TextXAlignment = align or Enum.TextXAlignment.Left}, par)
end
local ord = 0
local function nextOrder() ord = ord + 1 return ord end

local quick = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local function tween(o, props, info) TS:Create(o, info or quick, props):Play() end

-- remove copias anteriores do hub
pcall(function() RS:UnbindFromRenderStep(GUI_NAME) end)
pcall(function() RS:UnbindFromRenderStep("NetrixHubV10") end)
local roots = {}
pcall(function() if gethui then roots[#roots + 1] = gethui() end end)
pcall(function() roots[#roots + 1] = game:GetService("CoreGui") end)
pcall(function() roots[#roots + 1] = LP:FindFirstChild("PlayerGui") end)
for _, root in ipairs(roots) do
	pcall(function()
		for _, n in ipairs({GUI_NAME, "NetrixHubV10"}) do
			local old = root:FindFirstChild(n)
			if old then old:Destroy() end
		end
	end)
end

local Gui = New("ScreenGui", {Name = GUI_NAME, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
local parented = false
pcall(function() if syn and syn.protect_gui then syn.protect_gui(Gui) end end)
pcall(function() if gethui then Gui.Parent = gethui() parented = Gui.Parent ~= nil end end)
if not parented then pcall(function() Gui.Parent = game:GetService("CoreGui") parented = Gui.Parent ~= nil end) end
if not parented then Gui.Parent = LP:WaitForChild("PlayerGui") end

-- arrastar (e clicar sem arrastar)
local function draggable(handle, target, onClick)
	local dragging, moved, start, startPos, cur = false, false, nil, nil, nil
	handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging, moved, cur = true, false, i
			start, startPos = i.Position, target.Position
		end
	end)
	keep(UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
			or (i.UserInputType == Enum.UserInputType.Touch and i == cur)) then
			local d = i.Position - start
			if d.Magnitude > 6 then moved = true end
			if moved then
				target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end
	end))
	keep(UIS.InputEnded:Connect(function(i)
		if dragging and (i == cur or i.UserInputType == Enum.UserInputType.MouseButton1) then
			dragging = false
			if not moved and onClick then onClick() end
		end
	end))
end

-- ==========================================
-- PAINEL
-- ==========================================
local vp = Cam.ViewportSize
local MW = math.min(500, vp.X - 24)
local MH = math.min(350, vp.Y - 24)

local Main = Round(New("Frame", {Name = "Main", Size = UDim2.new(0, MW, 0, MH), Position = UDim2.new(0.5, -MW / 2, 0.5, -MH / 2),
	BackgroundColor3 = BG, BorderSizePixel = 0, ClipsDescendants = true}, Gui), 14)
New("UIGradient", {Rotation = 90, Color = ColorSequence.new(BG, BG2)}, Main)
local mainStroke = Stroke(Main, AC, 1.5, 0.15)
New("UIGradient", {Rotation = 35, Color = ColorSequence.new(AC, AC2)}, mainStroke)
local scale = New("UIScale", {Scale = 1}, Main)

-- imagem do flutuante no fundo do painel (bem transparente)
Round(New("ImageLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Image = IMG, ImageTransparency = 0.9,
	ScaleType = Enum.ScaleType.Crop, Active = false, ZIndex = 0}, Main), 14)

local Header = New("Frame", {Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1, Active = true}, Main)
Label(Header, "Netrix Hub Universal", UDim2.new(0, 16, 0, 5), UDim2.new(1, -90, 0, 22), FB, 16, W)
Label(Header, "Aimbot  |  ESP  |  Voo  |  Speed", UDim2.new(0, 16, 0, 26), UDim2.new(1, -90, 0, 14), FM, 10, SUB)

local function HeaderBtn(txt, x, hoverCol)
	local b = Round(New("TextButton", {Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, x, 0, 10), BackgroundColor3 = PANEL2,
		Text = txt, Font = FB, TextSize = 12, TextColor3 = W, AutoButtonColor = false, BorderSizePixel = 0}, Header), 7)
	b.MouseEnter:Connect(function() tween(b, {BackgroundColor3 = hoverCol}) end)
	b.MouseLeave:Connect(function() tween(b, {BackgroundColor3 = PANEL2}) end)
	return b
end
local Close = HeaderBtn("X", -38, RED)
local Mini = HeaderBtn("-", -70, AC)
draggable(Header, Main)

New("Frame", {Size = UDim2.new(1, -32, 0, 1), Position = UDim2.new(0, 16, 0, 46), BackgroundColor3 = AC,
	BackgroundTransparency = 0.6, BorderSizePixel = 0}, Main)

local TabBar = New("Frame", {Size = UDim2.new(0, 90, 1, -88), Position = UDim2.new(0, 10, 0, 54), BackgroundTransparency = 1}, Main)
New("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, TabBar)

-- cartao de fundo do conteudo
Round(New("Frame", {Size = UDim2.new(1, -116, 1, -88), Position = UDim2.new(0, 106, 0, 52), BackgroundColor3 = PANEL,
	BackgroundTransparency = 0.35, BorderSizePixel = 0}, Main), 10)

-- rodape
Label(Main, "YouTube: " .. YOUTUBE_NAME, UDim2.new(0, 16, 1, -28), UDim2.new(0.6, 0, 0, 20), FM, 10, SUB)
Label(Main, VERSION, UDim2.new(0.6, 0, 1, -28), UDim2.new(0.4, -16, 0, 20), FB, 10, AC2, Enum.TextXAlignment.Right)

local pages, tabBtns, tabBars = {}, {}, {}
local function showTab(name)
	for n, pg in pairs(pages) do pg.Visible = (n == name) end
	for n, b in pairs(tabBtns) do
		local on = (n == name)
		tween(b, {BackgroundColor3 = on and AC or PANEL2, BackgroundTransparency = on and 0 or 0.25})
		b.TextColor3 = on and W or SUB
		tabBars[n].Visible = on
	end
end

local function addTab(name, label)
	local b = Round(New("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = PANEL2, BackgroundTransparency = 0.25,
		Text = label, Font = FB, TextSize = 11, TextColor3 = SUB, TextXAlignment = Enum.TextXAlignment.Left,
		AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = nextOrder()}, TabBar), 8)
	New("UIPadding", {PaddingLeft = UDim.new(0, 18)}, b)
	local bar = Round(New("Frame", {Size = UDim2.new(0, 3, 0, 16), Position = UDim2.new(0, -12, 0.5, -8), BackgroundColor3 = W,
		BorderSizePixel = 0, Visible = false}, b), 2)
	local pg = New("ScrollingFrame", {Size = UDim2.new(1, -128, 1, -100), Position = UDim2.new(0, 112, 0, 58), BackgroundTransparency = 1,
		BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = AC, CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false}, Main)
	New("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, pg)
	New("UIPadding", {PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 4)}, pg)
	pages[name], tabBtns[name], tabBars[name] = pg, b, bar
	b.MouseButton1Click:Connect(function() showTab(name) end)
	return pg
end

local function Section(pg, txt)
	local f = New("Frame", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, LayoutOrder = nextOrder()}, pg)
	Label(f, string.upper(txt), UDim2.new(0, 2, 0, 0), UDim2.new(1, 0, 1, -4), FB, 10, AC2)
	New("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -3), BackgroundColor3 = AC,
		BackgroundTransparency = 0.75, BorderSizePixel = 0}, f)
end

local function Info(pg, txt, h)
	local t = Label(pg, txt, UDim2.new(), UDim2.new(1, 0, 0, h or 30), FM, 10, SUB)
	t.TextWrapped = true
	t.TextYAlignment = Enum.TextYAlignment.Top
	t.LayoutOrder = nextOrder()
end

local function Row(pg, h)
	local r = Round(New("Frame", {Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = PANEL2, BackgroundTransparency = 0.2,
		BorderSizePixel = 0, LayoutOrder = nextOrder()}, pg), 8)
	local s = Stroke(r, AC, 1, 0.9)
	return r, s
end

local function hoverable(hit, stroke)
	hit.MouseEnter:Connect(function() tween(stroke, {Transparency = 0.55}) end)
	hit.MouseLeave:Connect(function() tween(stroke, {Transparency = 0.9}) end)
end

local function rowTitle(r, txt, desc, right)
	if desc then
		Label(r, txt, UDim2.new(0, 12, 0, 6), UDim2.new(1, -right, 0, 18), FB, 12, W)
		local d = Label(r, desc, UDim2.new(0, 12, 0, 24), UDim2.new(1, -right, 0, 16), FM, 10, SUB)
		d.TextTruncate = Enum.TextTruncate.AtEnd
	else
		Label(r, txt, UDim2.new(0, 12, 0, 0), UDim2.new(1, -right, 1, 0), FB, 12, W)
	end
end

local function Toggle(pg, txt, key, cb, desc)
	local r, s = Row(pg, desc and 46 or 38)
	rowTitle(r, txt, desc, 72)
	local pill = Round(New("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.new(0, 38, 0, 20),
		BackgroundColor3 = C[key] and AC or OFF, BorderSizePixel = 0}, r), 10)
	local knob = Round(New("Frame", {AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.new(0, 14, 0, 14), BackgroundColor3 = W,
		Position = C[key] and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0), BorderSizePixel = 0}, pill), 7)
	local hit = New("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5}, r)
	hoverable(hit, s)
	hit.MouseButton1Click:Connect(function()
		C[key] = not C[key]
		tween(pill, {BackgroundColor3 = C[key] and AC or OFF})
		tween(knob, {Position = C[key] and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)})
		if cb then cb(C[key]) end
	end)
end

local function Button(pg, txt, label, color, cb, desc)
	local r, s = Row(pg, desc and 46 or 38)
	rowTitle(r, txt, desc, 110)
	local b = Round(New("TextButton", {Size = UDim2.new(0, 84, 0, 22), Position = UDim2.new(1, -94, 0.5, -11), BackgroundColor3 = color,
		Text = label, Font = FB, TextSize = 10, TextColor3 = W, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 6}, r), 6)
	hoverable(b, s)
	b.MouseButton1Click:Connect(function() cb(b) end)
	return b
end

local function Pick(pg, txt, opts, key)
	local i = table.find(opts, C[key]) or 1
	Button(pg, txt, opts[i], AC, function(b)
		i = i % #opts + 1
		b.Text = opts[i]
		C[key] = opts[i]
	end)
end

local listening
local function BindKey(pg, txt, key)
	local r, s = Row(pg, 38)
	rowTitle(r, txt, nil, 110)
	local b = Round(New("TextButton", {Size = UDim2.new(0, 84, 0, 22), Position = UDim2.new(1, -94, 0.5, -11), BackgroundColor3 = OFF,
		Text = C[key], Font = FB, TextSize = 10, TextColor3 = W, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 6}, r), 6)
	hoverable(b, s)
	b.MouseButton1Click:Connect(function()
		listening = {key = key, btn = b}
		b.Text = "Pressione..."
	end)
end

local function Slider(pg, txt, mn, mx, key, cb)
	local r, s = Row(pg, 58)
	Label(r, txt, UDim2.new(0, 12, 0, 6), UDim2.new(0.6, 0, 0, 18), FB, 12, W)
	local val = Label(r, "", UDim2.new(0.6, 0, 0, 6), UDim2.new(0.4, -12, 0, 18), FB, 12, AC2, Enum.TextXAlignment.Right)
	-- area de toque grande: encosta em qualquer lugar da linha e arrasta
	local hit = New("TextButton", {Position = UDim2.new(0, 0, 0, 26), Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1,
		Text = "", AutoButtonColor = false}, r)
	hoverable(hit, s)
	local track = Round(New("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0), Size = UDim2.new(1, -28, 0, 6),
		BackgroundColor3 = OFF, BorderSizePixel = 0}, hit), 3)
	local fill = Round(New("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = AC, BorderSizePixel = 0}, track), 3)
	local knob = Round(New("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 16, 0, 16), BackgroundColor3 = W,
		BorderSizePixel = 0}, track), 8)
	local function set(v)
		v = math.clamp(math.floor(v + 0.5), mn, mx)
		C[key] = v
		local a = (v - mn) / (mx - mn)
		fill.Size = UDim2.new(a, 0, 1, 0)
		knob.Position = UDim2.new(a, 0, 0.5, 0)
		val.Text = tostring(v)
		if cb then cb(v) end
	end
	set(C[key])
	local active
	local function upd(x)
		set(mn + math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1) * (mx - mn))
	end
	hit.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			active = i
			pg.ScrollingEnabled = false
			upd(i.Position.X)
		end
	end)
	keep(UIS.InputChanged:Connect(function(i)
		if active and (i.UserInputType == Enum.UserInputType.MouseMovement
			or (i.UserInputType == Enum.UserInputType.Touch and i == active)) then
			upd(i.Position.X)
		end
	end))
	keep(UIS.InputEnded:Connect(function(i)
		if active and (i == active or i.UserInputType == Enum.UserInputType.MouseButton1) then
			active = nil
			pg.ScrollingEnabled = true
		end
	end))
end

-- ==========================================
-- LOGICA: jogadores
-- ==========================================
local function isAlive(p)
	local ch = p.Character
	local hum = ch and ch:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return false end
	if hum:GetState() == Enum.HumanoidStateType.Dead then return false end
	return ch:FindFirstChild("HumanoidRootPart") ~= nil
end

local function isTeammate(p)
	local a, b = LP.Team, p.Team
	if a and b then return a == b end
	local aa, ba = LP:GetAttribute("Team"), p:GetAttribute("Team")
	if aa ~= nil and ba ~= nil then return aa == ba end
	if not LP.Neutral and not p.Neutral then return LP.TeamColor == p.TeamColor end
	return false
end

local function viewCenter() return Cam.ViewportSize / 2 end
local function center()
	if C.FOVOrigin == "Mouse" then return UIS:GetMouseLocation() end
	return viewCenter() -- FOV fixo no meio da tela
end

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

local rayP = RaycastParams.new()
rayP.FilterType = Enum.RaycastFilterType.Exclude
local function clearShot(part, ch)
	local o = Cam.CFrame.Position
	local list = {ch}
	if LP.Character then list[2] = LP.Character end
	rayP.FilterDescendantsInstances = list
	return WS:Raycast(o, part.Position - o, rayP) == nil
end

local function aimPart(ch)
	if C.Part == "Cabeca" then return ch:FindFirstChild("Head") or ch:FindFirstChild("HumanoidRootPart") end
	return ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso") or ch:FindFirstChild("HumanoidRootPart")
end

local function candidate(p, c0, limit)
	if p == LP or not isAlive(p) then return nil end
	if C.TeamCheck and isTeammate(p) then return nil end
	local ch = p.Character
	local part = aimPart(ch)
	if not part then return nil end
	local pos, on = Cam:WorldToViewportPoint(part.Position)
	if not on or pos.Z <= 0 then return nil end
	local d = (Vector2.new(pos.X, pos.Y) - c0).Magnitude
	if d > limit then return nil end
	if C.WallCheck and not clearShot(part, ch) then return nil end
	return part, d
end

local lockP
local function target(c0)
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

local AIM_SMOOTH = 14 -- forca fixa (quase travada, sem tremer)
local accX, accY = 0, 0

local function triggerOn()
	if isMobile() then return true end
	if C.Trigger == "Botao direito" then
		return UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
	elseif C.Trigger == "Tecla" then
		local okk, kc = pcall(function() return Enum.KeyCode[C.AimKey] end)
		return (okk and kc and UIS:IsKeyDown(kc)) and true or false
	end
	return true
end

local function useMouse()
	if not mousemoverel then return false end
	if C.AimMode == "Mouse" then return true end
	if C.AimMode == "Camera" then return false end
	return (not isMobile()) and UIS.MouseBehavior == Enum.MouseBehavior.LockCenter
end

local function aim(dt)
	if not triggerOn() then lockP, accX, accY = nil, 0, 0 return end
	local part = target(center())
	if not part then accX, accY = 0, 0 return end
	local point = part.Position
	local a = math.clamp(1 - math.exp(-0.8 * AIM_SMOOTH * AIM_SMOOTH * dt), 0, 1)

	if useMouse() then
		local pos = Cam:WorldToViewportPoint(point)
		local ref = viewCenter()
		if UIS.MouseBehavior ~= Enum.MouseBehavior.LockCenter then ref = UIS:GetMouseLocation() end
		local dx, dy = pos.X - ref.X, pos.Y - ref.Y
		if math.sqrt(dx * dx + dy * dy) < 1.5 then return end
		local g = math.min(a, 0.6)
		accX, accY = accX + dx * g, accY + dy * g
		local mx = accX >= 0 and math.floor(accX) or math.ceil(accX)
		local my = accY >= 0 and math.floor(accY) or math.ceil(accY)
		accX, accY = accX - mx, accY - my
		if mx ~= 0 or my ~= 0 then mousemoverel(mx, my) end
		return
	end

	local camPos = Cam.CFrame.Position
	local cur = Cam.CFrame.LookVector
	local want = point - camPos
	if want.Magnitude < 0.1 then return end
	want = want.Unit

	-- terceira pessoa: a camera gira em volta do jogador; resolve a direcao
	-- contando com a nova posicao da camera (mira cai na cabeca, sem ficar alta)
	local focus = Cam.Focus.Position
	local toFocus = focus - camPos
	local zd = toFocus.Magnitude
	local third = zd > 0.5 and zd < 120 and cur:Dot(toFocus.Unit) > 0.999
	if third then
		for _ = 1, 4 do
			local d2 = point - (focus - want * zd)
			if d2.Magnitude < 0.1 then break end
			want = d2.Unit
		end
	end

	if math.acos(math.clamp(cur:Dot(want), -1, 1)) < math.rad(0.05) then return end
	local newLook = want
	if a < 1 then
		local l = cur:Lerp(want, a)
		if l.Magnitude > 1e-3 then newLook = l.Unit end
	end
	local pos = third and (focus - newLook * zd) or camPos
	Cam.CFrame = CFrame.lookAt(pos, pos + newLook)
end

-- ==========================================
-- ESP
-- Usa a propria projecao da camera (WorldToViewportPoint), a mesma do aimbot,
-- e roda por ultimo no frame: a caixa acompanha o corpo sem escorregar.
-- ==========================================
local COLS = {Roxo = Color3.fromRGB(170, 110, 255), Vermelho = Color3.fromRGB(255, 70, 90), Verde = Color3.fromRGB(70, 230, 130),
	Azul = Color3.fromRGB(80, 170, 255), Branco = W}
local ESP, espShown = {}, false

local function makeObj()
	local o
	pcall(function()
		o = {Line = Drawing.new("Line"), Box = Drawing.new("Square"), Text = Drawing.new("Text")}
		o.Line.Thickness = 1.5
		o.Box.Thickness = 1.5
		o.Box.Filled = false
		o.Text.Size = 13
		o.Text.Center = true
		o.Text.Outline = true
		for _, d in pairs(o) do d.Visible = false end
	end)
	return o
end
local function hideObj(o)
	o.Line.Visible = false
	o.Box.Visible = false
	o.Text.Visible = false
end
local function killObj(o)
	for _, d in pairs(o) do pcall(function() d:Remove() end) end
end

keep(Players.PlayerRemoving:Connect(function(p)
	local o = ESP[p]
	if o then
		killObj(o)
		ESP[p] = nil
	end
	if lockP == p then lockP = nil end
end))

local function esp()
	if not draw then return end
	if not (C.Line or C.Box or C.Name or C.Health or C.Dist) then
		if espShown then
			for _, o in pairs(ESP) do hideObj(o) end
			espShown = false
		end
		return
	end
	espShown = true
	local col = COLS[C.ECol] or COLS.Roxo
	local camPos = Cam.CFrame.Position
	local vsize = Cam.ViewportSize
	local yoff = C.ESPOffset

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP then
			local o = ESP[p]
			if not o then o = makeObj() ESP[p] = o end
			if o then
				local shown = false
				if isAlive(p) and not (C.ESPTeam and isTeammate(p)) then
					local ch = p.Character
					local root = ch:FindFirstChild("HumanoidRootPart")
					local hum = ch:FindFirstChildOfClass("Humanoid")
					local head = ch:FindFirstChild("Head")
					local rp = Cam:WorldToViewportPoint(root.Position)
					if rp.Z > 0 then
						-- caixa presa no corpo: topo na cabeca, base nos pes
						local topW = head and (head.Position + Vector3.new(0, head.Size.Y / 2 + 0.15, 0)) or (root.Position + Vector3.new(0, 2.5, 0))
						local feet = math.max(3, hum.HipHeight + root.Size.Y / 2)
						local tp = Cam:WorldToViewportPoint(topW)
						local bp = Cam:WorldToViewportPoint(root.Position - Vector3.new(0, feet, 0))
						if tp.Z > 0 and bp.Z > 0 then
							local top = math.min(tp.Y, bp.Y) + yoff
							local h = math.abs(bp.Y - tp.Y)
							local w = h * 0.55
							local cx, cy = rp.X, rp.Y + yoff
							if h >= 4 then
								shown = true

								o.Line.Visible = C.Line
								if C.Line then
									o.Line.Color = col
									o.Line.From = Vector2.new(vsize.X / 2, 0) -- a linha vem de cima da tela
									o.Line.To = Vector2.new(cx, cy)
								end

								o.Box.Visible = C.Box
								if C.Box then
									o.Box.Color = col
									o.Box.Size = Vector2.new(w, h)
									o.Box.Position = Vector2.new(cx - w / 2, top)
								end

								local parts = {}
								if C.Name then parts[#parts + 1] = p.Name end
								if C.Health then parts[#parts + 1] = "[" .. math.floor(hum.Health) .. " HP]" end
								if C.Dist then parts[#parts + 1] = math.floor((root.Position - camPos).Magnitude) .. "m" end
								o.Text.Visible = #parts > 0
								if #parts > 0 then
									o.Text.Color = col
									o.Text.Text = table.concat(parts, " ")
									o.Text.Position = Vector2.new(cx, top - 16)
								end
							end
						end
					end
				end
				if not shown then hideObj(o) end
			end
		end
	end
end

-- ==========================================
-- SPEED, PULO, NOCLIP, VOO E ANTI AFK
-- ==========================================
local function hum()
	local ch = LP.Character
	return ch and ch:FindFirstChildOfClass("Humanoid")
end

keep(RS.Heartbeat:Connect(function()
	if not (C.Walk or C.Jump) then return end
	local h = hum()
	if not h then return end
	if C.Walk and h.WalkSpeed ~= C.WalkVal then h.WalkSpeed = C.WalkVal end
	if C.Jump then
		h.UseJumpPower = true
		if h.JumpPower ~= C.JumpVal then h.JumpPower = C.JumpVal end
	end
end))

keep(UIS.JumpRequest:Connect(function()
	if C.InfJump then
		local h = hum()
		if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end))

-- Noclip: atravessa paredes. Guarda quais partes foram alteradas para devolver depois.
local clipped = {}
local function restoreClip()
	for part in pairs(clipped) do
		if part.Parent then part.CanCollide = true end
		clipped[part] = nil
	end
end

keep(RS.Stepped:Connect(function()
	if not C.Noclip then return end
	local ch = LP.Character
	if not ch then return end
	for _, d in ipairs(ch:GetChildren()) do
		if d:IsA("BasePart") and d.CanCollide then
			d.CanCollide = false
			clipped[d] = true
		end
	end
end))

-- Voo: PC usa W A S D + Espaco (sobe) + Shift (desce). Celular usa o analogico
-- (anda para onde a camera olha) e os botoes SUBIR / DESCER.
local flyBV, flyBG
local upHeld, downHeld = false, false

local function flyOff()
	if flyBV then flyBV:Destroy() flyBV = nil end
	if flyBG then flyBG:Destroy() flyBG = nil end
	local h = hum()
	if h then h.PlatformStand = false end
end

local FlyUI = New("Frame", {Name = "FlyUI", Size = UDim2.new(0, 70, 0, 100), AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -18, 0.5, 0), BackgroundTransparency = 1, Visible = false, ZIndex = 30}, Gui)
local function flyBtn(txt, y, setter)
	local b = Round(New("TextButton", {Size = UDim2.new(1, 0, 0, 44), Position = UDim2.new(0, 0, 0, y), BackgroundColor3 = BG2,
		BackgroundTransparency = 0.15, Text = txt, Font = FB, TextSize = 11, TextColor3 = W, AutoButtonColor = false,
		BorderSizePixel = 0, ZIndex = 31}, FlyUI), 10)
	Stroke(b, AC, 1.2, 0.2)
	b.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
			setter(true)
			tween(b, {BackgroundColor3 = AC})
		end
	end)
	b.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
			setter(false)
			tween(b, {BackgroundColor3 = BG2})
		end
	end)
end
flyBtn("SUBIR", 0, function(v) upHeld = v end)
flyBtn("DESCER", 56, function(v) downHeld = v end)

keep(RS.Heartbeat:Connect(function()
	local showUI = C.Fly and isMobile()
	if FlyUI.Visible ~= showUI then FlyUI.Visible = showUI end

	if not C.Fly then
		if flyBV or flyBG then flyOff() end
		upHeld, downHeld = false, false
		return
	end

	local ch = LP.Character
	local root = ch and ch:FindFirstChild("HumanoidRootPart")
	local h = hum()
	if not root or not h or h.Health <= 0 then return end

	if not flyBV or flyBV.Parent ~= root then
		if flyBV then flyBV:Destroy() end
		if flyBG then flyBG:Destroy() end
		flyBV = New("BodyVelocity", {MaxForce = Vector3.new(1e9, 1e9, 1e9), Velocity = Vector3.new(0, 0, 0)}, root)
		flyBG = New("BodyGyro", {MaxTorque = Vector3.new(1e9, 1e9, 1e9), P = 9e4, D = 1e3, CFrame = root.CFrame}, root)
	end
	h.PlatformStand = true

	local cf = Cam.CFrame
	local look = cf.LookVector
	local move = Vector3.new(0, 0, 0)

	if isMobile() then
		local md = h.MoveDirection
		if md.Magnitude > 0.05 then
			local flat = Vector3.new(look.X, 0, look.Z)
			local fl = math.max(flat.Magnitude, 0.1)
			local f = flat.Magnitude > 0.01 and md:Dot(flat.Unit) or 0
			move = md + Vector3.new(0, f * look.Y / fl, 0)
		end
	else
		if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + look end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - look end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cf.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cf.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then upHeld = true end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then downHeld = true end
	end
	if upHeld then move = move + Vector3.new(0, 1, 0) end
	if downHeld then move = move - Vector3.new(0, 1, 0) end
	if not isMobile() then upHeld, downHeld = false, false end

	if move.Magnitude > 0.05 then
		flyBV.Velocity = move.Unit * C.FlyVal
	else
		flyBV.Velocity = Vector3.new(0, 0, 0)
	end

	local flat = Vector3.new(look.X, 0, look.Z)
	if flat.Magnitude > 0.01 then
		flyBG.CFrame = CFrame.lookAt(root.Position, root.Position + flat)
	end
end))

pcall(function()
	local VU = game:GetService("VirtualUser")
	keep(LP.Idled:Connect(function()
		if C.AFK then
			VU:CaptureController()
			VU:ClickButton2(Vector2.new())
		end
	end))
end)

-- ==========================================
-- ABAS
-- ==========================================
local A = addTab("Aim", "AIM")
local E = addTab("ESP", "ESP")
local P = addTab("Player", "PLAYER")
local PCt = addTab("PC", "PC")
local D = addTab("Discord", "DISCORD")

Section(A, "Mira")
Toggle(A, "Ativar Aimbot", "Aim", nil, "Gruda a mira no inimigo mais próximo")
Pick(A, "Mirar em", {"Cabeca", "Tronco"}, "Part")
Section(A, "Filtros")
Toggle(A, "Team Check", "TeamCheck", nil, "Ignora quem é do seu time")
Toggle(A, "Wall Check", "WallCheck", nil, "Só mira em quem está visível")
Section(A, "Círculo FOV")
Toggle(A, "Mostrar círculo", "ShowFOV")
Slider(A, "Tamanho do FOV", 20, 500, "FOV")
Info(A, "O FOV fica fixo no meio da tela. A força da mira é fixa.", 28)

Section(E, "Desenhos")
Toggle(E, "ESP Line", "Line", nil, "Linha do topo da tela até o jogador")
Toggle(E, "ESP Caixa", "Box", nil, "Quadrado em volta do jogador")
Section(E, "Informações")
Toggle(E, "ESP Name", "Name")
Toggle(E, "ESP Vida", "Health")
Toggle(E, "ESP Distância", "Dist")
Section(E, "Ajustes")
Pick(E, "Cor do ESP", {"Roxo", "Vermelho", "Verde", "Azul", "Branco"}, "ECol")
Toggle(E, "Ignorar meu time", "ESPTeam")

Section(P, "Movimento")
Info(P, "Aviso: em alguns jogos o Speed funciona e em outros não.", 28)
Toggle(P, "Speed", "Walk", function(on)
	if on then
		note("Em alguns jogos o Speed funciona e em outros nao.")
	else
		local h = hum()
		if h then h.WalkSpeed = 16 end
	end
end)
Slider(P, "Velocidade", 16, 150, "WalkVal")
Toggle(P, "Pulo alto", "Jump", function(on)
	if not on then
		local h = hum()
		if h then h.JumpPower = 50 end
	end
end)
Slider(P, "Força do pulo", 50, 300, "JumpVal")
Toggle(P, "Pulo infinito", "InfJump")
Section(P, "Voo e colisão")
Toggle(P, "Voar", "Fly", function(on)
	if on then
		note(isMobile() and "Voo ligado: use o analogico e os botoes SUBIR / DESCER." or "Voo ligado: WASD, Espaco sobe, Shift desce.")
	else
		flyOff()
	end
end, "PC: WASD + Espaço/Shift. Celular: botões na tela")
Slider(P, "Velocidade do voo", 20, 200, "FlyVal")
Toggle(P, "Noclip", "Noclip", function(on)
	if not on then restoreClip() end
end, "Atravessa paredes e objetos")
Section(P, "Outros")
Toggle(P, "Anti AFK", "AFK")
Button(P, "Fechar hub", "FECHAR", RED, function() Gui:Destroy() end)

-- aba PC
pcall(function()
	Section(PCt, "Plataforma")
	Pick(PCt, "Plataforma", {"Auto", "PC", "Celular"}, "Platform")
	Section(PCt, "Mira no PC")
	Pick(PCt, "Ativar mira", {"Sempre", "Botao direito", "Tecla"}, "Trigger")
	BindKey(PCt, "Tecla da mira", "AimKey")
	Pick(PCt, "Modo da mira", {"Auto", "Camera", "Mouse"}, "AimMode")
	Pick(PCt, "Centro do FOV", {"Centro", "Mouse"}, "FOVOrigin")
	Section(PCt, "Atalhos")
	BindKey(PCt, "Tecla do painel", "MenuKey")
	Section(PCt, "Ajuste do ESP")
	Slider(PCt, "Ajuste vertical do ESP", -60, 60, "ESPOffset")
	Info(PCt, "Se as caixas aparecerem um pouco acima ou abaixo dos jogadores no seu aparelho, corrija aqui.", 40)
	Section(PCt, "Configuração")
	Button(PCt, "Salvar configuração", "SALVAR", AC, function()
		local okk = pcall(function() writefile(CFGFILE, HS:JSONEncode(C)) end)
		note(okk and "Configuracao salva!" or "Seu executor nao permite salvar arquivos.")
	end)
	Button(PCt, "Apagar configuração", "APAGAR", RED, function()
		local okk = pcall(function() delfile(CFGFILE) end)
		note(okk and "Configuracao apagada." or "Nao ha configuracao salva.")
	end)
	Info(PCt, "Auto = o script escolhe sozinho. Modo Mouse move o cursor até o alvo (jogos com mouse livre); modo Camera gira a câmera. Em Tecla, segure a tecla para mirar. Esc cancela ao escolher uma tecla.", 62)
end)

-- aba Discord
Section(D, "Comunidade")
local banner, bs = Row(D, 96)
Round(New("ImageLabel", {Size = UDim2.new(0, 64, 0, 64), Position = UDim2.new(0, 14, 0.5, -32), BackgroundTransparency = 1,
	Image = IMG, ScaleType = Enum.ScaleType.Crop, BorderSizePixel = 0}, banner), 14)
Label(banner, "Entre no nosso Discord!", UDim2.new(0, 92, 0, 16), UDim2.new(1, -104, 0, 22), FB, 14, W)
local sub = Label(banner, "Novidades, atualizações e suporte do NETRIX HUB. Toque no botão abaixo.", UDim2.new(0, 92, 0, 40),
	UDim2.new(1, -104, 0, 44), FM, 11, SUB)
sub.TextWrapped = true
sub.TextYAlignment = Enum.TextYAlignment.Top
Button(D, "discord.gg/yQyvXYM2CK", "COPIAR", Color3.fromRGB(88, 101, 242), function(b)
	local copied = false
	pcall(function() setclipboard(DISCORD) copied = true end)
	note(copied and "Link do Discord copiado! Cole no navegador para entrar." or DISCORD)
	b.Text = copied and "COPIADO" or "LINK"
	task.delay(2, function() pcall(function() b.Text = "COPIAR" end) end)
end)

showTab("Aim")

-- ==========================================
-- BOTAO FLUTUANTE (quadrado arredondado) E ATALHOS
-- ==========================================
local Fl = Round(New("ImageButton", {Size = UDim2.new(0, 56, 0, 56), Position = UDim2.new(0, 16, 0.5, -28), BackgroundTransparency = 1,
	BorderSizePixel = 0, Image = IMG, ScaleType = Enum.ScaleType.Crop, AutoButtonColor = false, ZIndex = 50}, Gui), 16)

local function setPanel(show)
	if show then
		scale.Scale = 0.92
		Main.Visible = true
		tween(scale, {Scale = 1}, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
	else
		Main.Visible = false
	end
end
local function togglePanel() setPanel(not Main.Visible) end

draggable(Fl, Fl, togglePanel)
Mini.MouseButton1Click:Connect(function() setPanel(false) end)
Close.MouseButton1Click:Connect(function() Gui:Destroy() end)

pcall(function()
	keep(UIS.InputBegan:Connect(function(i, gp)
		if i.UserInputType ~= Enum.UserInputType.Keyboard then return end
		if listening then
			local l = listening
			listening = nil
			if i.KeyCode ~= Enum.KeyCode.Escape then C[l.key] = i.KeyCode.Name end
			l.btn.Text = C[l.key]
			return
		end
		if gp then return end
		if i.KeyCode.Name == C.MenuKey then togglePanel() end
	end))
end)

-- ==========================================
-- LOOP PRINCIPAL (roda depois da camera do jogo)
-- ==========================================
local errShown = false
local function step(dt)
	Cam = WS.CurrentCamera or Cam
	if fov then
		fov.Visible = C.ShowFOV
		if C.ShowFOV then
			fov.Position = center()
			fov.Radius = C.FOV
		end
	end
	if C.Aim then aim(dt) else lockP, accX, accY = nil, 0, 0 end
	esp()
end

local function safeStep(dt)
	local okk, e = pcall(step, dt or 1 / 60)
	if not okk and not errShown then
		errShown = true
		warn("[Netrix Hub] erro no loop: " .. tostring(e))
	end
end

local bound = pcall(function() RS:BindToRenderStep(GUI_NAME, Enum.RenderPriority.Last.Value, safeStep) end)
if not bound then keep(RS.RenderStepped:Connect(safeStep)) end

Gui.Destroying:Connect(function()
	if bound then pcall(function() RS:UnbindFromRenderStep(GUI_NAME) end) end
	for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
	for _, o in pairs(ESP) do killObj(o) end
	if fov then pcall(function() fov:Remove() end) end
	flyOff()
	restoreClip()
	local h = hum()
	if h then
		if C.Walk then h.WalkSpeed = 16 end
		if C.Jump then h.JumpPower = 50 end
	end
end)

note("Painel carregado! Toque na imagem para abrir/fechar.")
if not draw then note("Seu executor nao tem Drawing: ESP e FOV desativados.") end

end)

if not ok then
	warn("[Netrix Hub] erro: " .. tostring(err))
	note("ERRO: " .. string.sub(tostring(err), 1, 150))
end
