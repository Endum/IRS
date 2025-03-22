--[[
    Motorschema controller, each function return new vector
        with his weighted length and angle,
    0 on length if it doesn't want to contrib.
]]--
local vector = require "vector"
local MAX_VEL = 15
local VAL_MULT = 1
local VAL_DIV = 10

--[[ Local utilities ]]--
function randomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
end

function getHigherLuminosityWithIdx(robot)
    best_value = 0
    best_id = false
    for i=1,#robot.light do
		if robot.light[i].value > best_value then
			best_value = robot.light[i].value
			best_id = i
		end
	end
    return best_value, best_id
end

function getHigherProximityWithIdx(robot)
    best_value = 0
    best_id = false
    for i=1,#robot.proximity do
		if robot.proximity[i].value > best_value then
			best_value = robot.proximity[i].value
			best_id = i
		end
	end
    return best_value, best_id
end

local subs = {}

--[[ Check if colliding ]]--
function subs.checkCollision(robot)
    best_v, best_id = getHigherProximityWithIdx(robot)

    --[[ Log a collision if robot touches anything ]]--
    if best_v == 1 then
        log("Collision!")
    end

    --[[ Just not affect robot behaviour ]]--
    return vector.vec2_polar(0,0)
end

--[[ Random front walk biased by sensors activation ]]--
function subs.randomWalk(robot)
    rndvel = MAX_VEL
    v, p_id = getHigherProximityWithIdx(robot)
    v, l_id = getHigherLuminosityWithIdx(robot)
    if p_id or l_id then
        rndvel = 0
    end
    return vector.vec2_polar(rndvel,randomFloat(-math.pi/4,math.pi/4))
end

--[[ Attractive light field ]]--
function subs.lightField(robot)
    lpol = vector.vec2_polar(0,0)

    --[[ Polar sum all sensors. ]]--
    for i=1,#robot.light do
        lpol = vector.vec2_polar_sum(lpol, vector.vec2_polar(robot.light[i].value * VAL_MULT, robot.light[i].angle))
    end

    --[[ Divide if obstacle detected. ]]--
    DIVI = 1
    opol = subs.obstacleField(robot)
    if opol.length > 0 then
        DIVI = VAL_DIV
    end

    --[[ Return fixed length pol. ]]--
    if lpol.length > 0 then
        return vector.vec2_polar(MAX_VEL/DIVI, lpol.angle)
    else
        return vector.vec2_polar(0, lpol.angle)
    end
end

--[[ Repulsive obstacle field ]]--
function subs.obstacleField(robot)
    opol = vector.vec2_polar(0,0)

    --[[
        Polar sum all sensors, with opposite angle.
        To get the opposite angle i follow those steps:
        1) sum pi to map from -pi,pi to 0,2pi
        2) sum pi to move to opposite angle
        3) apply mod 2pi to map back exceeding values
        4) subtract pi to map back to -pi,pi
    ]]--
    for i=1,#robot.proximity do
        opol = vector.vec2_polar_sum(opol, vector.vec2_polar(
            robot.proximity[i].value * VAL_MULT, (robot.proximity[i].angle + 2*math.pi) % (2*math.pi) - math.pi
        ))
    end

    --[[ Return fixed length pol. ]]--
    if opol.length > 0 then
        return vector.vec2_polar(MAX_VEL, opol.angle)
    else
        return vector.vec2_polar(0, opol.angle)
    end
end

--[[ Safe stop near light ]]--
function subs.safeStopNearLight(robot)

end

return subs
