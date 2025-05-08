local UILibrary = require(game.ReplicatedStorage.UILibrary.MainModule)

local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local myButton = UILibrary.Components.Button.new("Clique Aqui", screenGui)

myButton.MouseButton1Click:Connect(function()
    print("Botão clicado!")
end)
