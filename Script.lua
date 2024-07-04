local Selection = game:GetService("Selection")
local Workspace = game:GetService("Workspace")

local Camera = Workspace.Camera

local folder = script.Parent
local circularBeamModule = require(folder.CircularBeam)
local toolbar = plugin:CreateToolbar("Circular Beam")
local createButton = toolbar:CreateButton(
	"New Circular Beam",
	"Create a new circular beam.",
	"rbxassetid://18329485600"
)
local resizeButton = toolbar:CreateButton(
	"Resize Circular Beam",
	"Resize the selected circular beam.",
	"rbxassetid://18329700935"
)
local resizeWidget = plugin:CreateDockWidgetPluginGui(
	"resizeCircularBeam",
	DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Float,
		false,
		true,
		250,
		60,
		250,
		60
	)
)
local resizeGui = folder.ResizeGui
local resizeGuiSet = resizeGui.Main.Set
local resizeGuiValue = resizeGui.Main.Value
local resizeGuiInfo = resizeGui.Info

resizeWidget.Title = "Resize Circular Beam"
resizeGui.Parent = resizeWidget

local function SetCursor(cursorAsset)
	plugin:GetMouse().Icon = cursorAsset
end

local function GetPosition()
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {}
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.IgnoreWater = false
	
	local raycastResult = Workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector * 1000, raycastParams)
	if raycastResult then
		return raycastResult.Position
	else
		return Camera.CFrame.Position + Camera.CFrame.LookVector * 100
	end
end

resizeGuiSet.MouseEnter:Connect(function()
	resizeGuiSet.BackgroundColor3 = Color3.fromHex("35B5FF")
	SetCursor("rbxasset://SystemCursors/PointingHand")
end)

resizeGuiSet.MouseLeave:Connect(function()
	resizeGuiSet.BackgroundColor3 = Color3.fromHex("00A2FF")
	SetCursor("")
end)

resizeGuiSet.MouseButton1Down:Connect(function()
	resizeGuiSet.BackgroundColor3 = Color3.fromHex("006DCC")
end)

resizeGuiSet.MouseButton1Up:Connect(function()
	resizeGuiSet.BackgroundColor3 = Color3.fromHex("00A2FF")
end)

resizeGui.Main.Set.MouseButton1Click:Connect(function()
	local size = tonumber(resizeGui.Main.Value.Text)
	if size then
		for _, child in Selection:Get() do
			circularBeamModule.Resize(child, size)
		end		
	end
end)

createButton.Click:Connect(function()
	local new = circularBeamModule.Create(5)
	new.Position = GetPosition()
	new.Parent = Workspace
	
	Selection:Set({new})
end)

resizeButton.Click:Connect(function()
	resizeWidget.Enabled = not resizeWidget.Enabled
end)

while true do
	task.wait(1)
	
	local circularBeams = 0
	for _, child in Selection:Get() do
		if child.Name == "CircularBeam" and child:FindFirstChild("Beam0") then
			circularBeams += 1
		end
	end
	
	resizeGuiInfo.Text = `Apply to {circularBeams} selected circular beams.`
end
