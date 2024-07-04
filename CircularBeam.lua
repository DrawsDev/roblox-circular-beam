-- Types
export type BeamParams = {
	Color : Color3,
	LightEmission : number,
	LightInfluence : number,
	TextureId : number,
	TextureLength : number,
	TextureSpeed : number,
	Transparency : number,
	Segments : number,
	Width0 : number,
	Width1 : number
}

-- Variables
local DEFAULT_PARAMS : BeamParams = {
	Color = Color3.new(255, 255, 255),
	LightEmission = 1,
	LightInfluence = 0,
	TextureId = 18302051506,
	TextureLength = 1,
	TextureSpeed = 0,
	Transparency = 0.5,
	Segments = 10,
	Width0 = 2,
	Width1 = 2
}

-- Functions
local function CalculateCurveSize(radius : number)
	return (radius * 4) / 3
end

local function CreateBeam(radius, beamParams, attachment0, attachment1, inverse, name, parent)
	local curveSize = CalculateCurveSize(radius)
	
	local beam = Instance.new("Beam")
	beam.Color = ColorSequence.new(beamParams.Color or DEFAULT_PARAMS.Color)
	beam.LightEmission = beamParams.LightEmission or DEFAULT_PARAMS.LightEmission
	beam.LightInfluence = beamParams.LightInfluence or DEFAULT_PARAMS.LightInfluence
	beam.Texture = "rbxassetid://" .. (beamParams.TextureId or DEFAULT_PARAMS.TextureId)
	beam.TextureLength = beamParams.TextureLength or DEFAULT_PARAMS.TextureLength
	beam.TextureSpeed = beamParams.TextureSpeed or DEFAULT_PARAMS.TextureSpeed
	beam.Transparency = NumberSequence.new(beamParams.Transparency or DEFAULT_PARAMS.Transparency)
	beam.Segments = beamParams.Segments or DEFAULT_PARAMS.Segments
	beam.Width0 = beamParams.Width0 or DEFAULT_PARAMS.Width0
	beam.Width1 = beamParams.Width1 or DEFAULT_PARAMS.Width1
	beam.Name = name
	beam.Parent = parent

	if inverse then
		beam.Attachment0, beam.Attachment1 = attachment1, attachment0
		beam.CurveSize0,  beam.CurveSize1  = curveSize, -curveSize
	else
		beam.Attachment0, beam.Attachment1 = attachment0, attachment1
		beam.CurveSize0,  beam.CurveSize1  = -curveSize, curveSize
	end
	
	return beam
end

local function CreateAttachment(position, name, parent)
	local attachment = Instance.new("Attachment")
	attachment.Position = position
	attachment.Orientation = Vector3.new(0, 90, 180)
	attachment.Name = name
	attachment.Parent = parent
	return attachment
end

local function CreateRoot()
	local root = Instance.new("Part")
	root.CastShadow = false
	root.Transparency = 1
	root.Size = Vector3.one
	root.Anchored = true
	root.CanCollide = false
	root.CanTouch = false
	root.Name = "CircularBeam"
	return root	
end

local function CreateCircularBeam(radius, beamParams)
	local root = CreateRoot()
	local attachment0 = CreateAttachment(Vector3.new( radius, root.Size.Y / 2, 0), "Attachment0", root)
	local attachment1 = CreateAttachment(Vector3.new(-radius, root.Size.Y / 2, 0), "Attachment1", root)
	local beam0 = CreateBeam(radius, beamParams, attachment0, attachment1, false, "Beam0", root)
	local beam1 = CreateBeam(radius, beamParams, attachment0, attachment1, true,  "Beam1", root)
	return root
end

-- Class
local CircularBeam = {}
CircularBeam.__index = CircularBeam

-- Methods
function CircularBeam.Create(radius : number, beamParams : BeamParams?)
	return CreateCircularBeam(radius, if not beamParams then DEFAULT_PARAMS else beamParams)
end

function CircularBeam.Resize(circularBeam : BasePart, radius : number)
	local curveSize = CalculateCurveSize(radius)
	
	local attachment0 = circularBeam:FindFirstChild("Attachment0")
	local attachment1 = circularBeam:FindFirstChild("Attachment1")
	local beam0 = circularBeam:FindFirstChild("Beam0")
	local beam1 = circularBeam:FindFirstChild("Beam1")
	
	if attachment0 and attachment1 and beam0 and beam1 then
		attachment0.Position = Vector3.new(radius, circularBeam.Size.Y / 2, 0)
		attachment1.Position = Vector3.new(-radius, circularBeam.Size.Y / 2, 0)
		beam0.CurveSize0, beam0.CurveSize1 = -curveSize, curveSize
		beam1.CurveSize0, beam1.CurveSize1 = curveSize, -curveSize
	end
end

return CircularBeam
