-- Declarações
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Interface para ativar/desativar o voo
local ScreenGui = Instance.new("ScreenGui")
local ToggleButtonFly = Instance.new("TextButton")
local ToggleButtonStop = Instance.new("TextButton")

ScreenGui.Name = "Fly_GUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

ToggleButtonFly.Name = "ToggleFly"
ToggleButtonFly.Parent = ScreenGui
ToggleButtonFly.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
ToggleButtonFly.Position = UDim2.new(0, 20, 0, 100)
ToggleButtonFly.Size = UDim2.new(0, 150, 0, 40)
ToggleButtonFly.Font = Enum.Font.SourceSansBold
ToggleButtonFly.Text = "Ativar Voo"
ToggleButtonFly.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButtonFly.TextSize = 18

ToggleButtonStop.Name = "StopFly"
ToggleButtonStop.Parent = ScreenGui
ToggleButtonStop.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleButtonStop.Position = UDim2.new(0, 20, 0, 150)
ToggleButtonStop.Size = UDim2.new(0, 150, 0, 40)
ToggleButtonStop.Font = Enum.Font.SourceSansBold
ToggleButtonStop.Text = "Parar Voo"
ToggleButtonStop.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButtonStop.TextSize = 18

-- Fly Control
local flying = false
local speed = 100 -- Ajuste a velocidade conforme necessário
local jumpPower = 500 -- Ajuste a potência de subida
local bodyGyro, bodyVelocity

-- Função para ativar o voo
local function activateFly()
    if flying then return end

    flying = true
    local character = LocalPlayer.Character
    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")

    -- Cria os objetos necessários para voar
    bodyGyro = Instance.new("BodyGyro")
    bodyVelocity = Instance.new("BodyVelocity")

    bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp

    bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    bodyVelocity.Velocity = Vector3.new(0, jumpPower, 0) -- Velocidade inicial para subir
    bodyVelocity.Parent = hrp

    -- Movimento do voo
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Space then
                bodyVelocity.Velocity = Vector3.new(0, jumpPower, 0) -- Continuar subindo ao apertar espaço
            end
            if input.KeyCode == Enum.KeyCode.S then
                bodyVelocity.Velocity = Vector3.new(0, -jumpPower, 0) -- Descer quando pressionar 'S'
            end
        end
    end)
end

-- Função para desativar o voo
local function deactivateFly()
    if not flying then return end

    flying = false
    local character = LocalPlayer.Character
    local hrp = character:WaitForChild("HumanoidRootPart")

    -- Remove os objetos para parar o voo
    if bodyGyro then
        bodyGyro:Destroy()
    end
    if bodyVelocity then
        bodyVelocity:Destroy()
    end
end

-- Botão para ativar voo
ToggleButtonFly.MouseButton1Click:Connect(function()
    activateFly()
    ToggleButtonFly.Text = "Voo Ativado"
end)

-- Botão para parar voo
ToggleButtonStop.MouseButton1Click:Connect(function()
    deactivateFly()
    ToggleButtonFly.Text = "Ativar Voo"
end)
