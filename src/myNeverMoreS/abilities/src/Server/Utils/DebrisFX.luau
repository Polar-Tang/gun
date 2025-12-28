-- DebrisFX.lua
-- Author: Luau (your assistant)
-- A reusable, physics-based destruction FX generator for abilities.

local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local DebrisFX = {}
DebrisFX.__index = DebrisFX

-- Default settings
local DEFAULT_SETTINGS = {
    amount = 10,
    sizeRange = Vector2.new(1, 3),
    velocity = 50,
    material = Enum.Material.Rock,
    lifetime = 3,
    dust = true,
    shockwave = true,
    radius = 8,
}

-- Utility: random float
local function randf(min, max)
    return min + math.random() * (max - min)
end

-- Utility: random vector
local function randomDirection()
    return Vector3.new(
        randf(-1,1),
        randf(0.2,1),
        randf(-1,1)
    ).Unit
end


---------------------------------------------------------------------
-- 🌋 MAIN ENTRY FUNCTION
---------------------------------------------------------------------

function DebrisFX:GroundSmash(params)
    params = setmetatable(params or {}, { __index = DEFAULT_SETTINGS })

    local position = params.position
    local normal = params.normal or Vector3.new(0,1,0)

    -- Spawn debris chunks
    for _ = 1, params.amount do
        self:_spawnChunk(position, normal, params)
    end

    -- Optional dust cloud
    if params.dust then
        self:_spawnDust(position)
    end

    -- Optional shockwave
    if params.shockwave then
        self:_spawnShockwave(position, params.radius)
    end
end


---------------------------------------------------------------------
-- 🧱 SPAWN A SINGLE DEBRIS CHUNK
---------------------------------------------------------------------

function DebrisFX:_spawnChunk(position, normal, params)
    local size = randf(params.sizeRange.X, params.sizeRange.Y)
    local part = Instance.new("Part")
    part.Size = Vector3.new(size, size, size)
    part.Material = params.material
    part.Color = Color3.new(0.35, 0.35, 0.35)
    part.Position = position + normal * 1.5
    part.Anchored = false
    part.CastShadow = true
    part.Shape = Enum.PartType.Block
    part.CanCollide = true
    part.Parent = workspace

    -- Initial impulse
    part.AssemblyLinearVelocity =
        randomDirection() * randf(params.velocity * 0.5, params.velocity)

    -- Rotational impulse
    part.AssemblyAngularVelocity =
        Vector3.new(randf(-8,8), randf(-8,8), randf(-8,8))

    Debris:AddItem(part, params.lifetime)
end


---------------------------------------------------------------------
-- ☁️ DUST PARTICLES
---------------------------------------------------------------------

function DebrisFX:_spawnDust(position)
    local p = Instance.new("ParticleEmitter")
    p.Texture = "rbxassetid://248625108"      -- nice dust puff texture
    p.Rate = 0
    p.Speed = NumberRange.new(5,15)
    p.Lifetime = NumberRange.new(0.4, 0.8)
    p.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1),
    })
    p.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 4),
        NumberSequenceKeypoint.new(1, 8),
    })
    p.SpreadAngle = Vector2.new(360,360)

    local a = Instance.new("Attachment")
    a.WorldPosition = position
    a.Parent = workspace.Terrain

    p.Parent = a
    p:Emit(40)

    Debris:AddItem(a, 1.5)
end


---------------------------------------------------------------------
-- 🌊 SHOCKWAVE RING
---------------------------------------------------------------------

function DebrisFX:_spawnShockwave(position, radius)
    local ring = Instance.new("Part")
    ring.Shape = Enum.PartType.Cylinder
    ring.Size = Vector3.new(radius, 0.2, radius)
    ring.Material = Enum.Material.ForceField
    ring.Color = Color3.new(1,1,1)
    ring.CanCollide = false
    ring.Anchored = true
    ring.CFrame = CFrame.new(position) * CFrame.Angles(0,0,math.rad(90))
    ring.Transparency = 0.5
    ring.Parent = workspace

    local scaled = 1

    -- Animate ring outward
    task.spawn(function()
        local start = tick()
        local duration = 0.4
        while tick() - start < duration do
            local t = (tick() - start) / duration
            scaled = 1 + t * 3
            ring.Size = Vector3.new(radius * scaled, 0.2, radius * scaled)
            ring.Transparency = 0.5 + t * 0.5
            RunService.Heartbeat:Wait()
        end
        ring:Destroy()
    end)
end


return DebrisFX
