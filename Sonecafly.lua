-- Serviços e referências
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Interface para ativar/desativar ESP
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Name = "ESP_GUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

ToggleButton.Name = "ToggleESP"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Position = UDim2.new(0, 20, 0, 100)
ToggleButton.Size = UDim2.new(0, 100, 0, 40)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "ESP: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18

-- Controle do ESP
local espEnabled = false
local espObjects = {}

-- Função para criar ESP em jogadores
function createESP(player)
    if player == LocalPlayer then return end

    local nameTag = Drawing.new("Text")
    nameTag.Size = 16
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.Visible = false

    local line = Drawing.new("Line")
    line.Thickness = 1
    line.Color = Color3.fromRGB(255, 0, 0)
    line.Visible = false

    local function update()
        if not espEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            nameTag.Visible = false
            line.Visible = false
            return
        end

        local hrp = player.Character.HumanoidRootPart
        local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

        -- Verificação de team (Team Check)
        if player.Team == LocalPlayer.Team then
            nameTag.Visible = false
            line.Visible = false
            return
        end

        if onScreen then
            local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
            nameTag.Text = string.format("%s [%.0fm]", player.Name, distance)
            nameTag.Position = Vector2.new(screenPos.X, screenPos.Y - 20)
            nameTag.Color = Color3.fromRGB(255, 0, 0)
            nameTag.Visible = true

            line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            line.To = Vector2.new(screenPos.X, screenPos.Y)
            line.Color = Color3.fromRGB(255, 0, 0)
            line.Visible = true
        else
            nameTag.Visible = false
            line.Visible = false
        end
    end

    -- Atualização contínua
    local connection = RunService.RenderStepped:Connect(update)

    -- Limpeza
    player.AncestryChanged:Connect(function(_, parent)
        if not parent then
            nameTag:Remove()
            line:Remove()
            if connection then connection:Disconnect() end
        end
    end)

    espObjects[player] = { nameTag = nameTag, line = line, connection = connection }
end

-- Limpa todos os ESPs
function clearESP()
    for _, v in pairs(espObjects) do
        if v.nameTag then v.nameTag:Remove() end
        if v.line then v.line:Remove() end
        if v.connection then v.connection:Disconnect() end
    end
    espObjects = {}
end

-- Botão liga/desliga
ToggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ToggleButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"

    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            createESP(player)
        end

        Players.PlayerAdded:Connect(function(player)
            task.wait(1)
            createESP(player)
        end)
    else
        clearESP()
    end
end)
