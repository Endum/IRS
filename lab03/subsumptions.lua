--[[
    Subsumptions controller, each function return new wheel speed,
    or false if decide not to take action.
]]--
local MAX_VEL = 15
local PROX_RANGE = 0.3
local STOP_THR = 0.36

--[[ Local utilities ]]--
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
    return false, false
end

--[[ Simply random walk ]]--
function subs.randomWalk(robot)
    return math.random(0,MAX_VEL), math.random(0,MAX_VEL)
end

--[[ Rotate to light ]]--
function subs.rotateToLight(robot)
    best_v, best_id = getHigherLuminosityWithIdx(robot)
    
    --[[ Light not found ]]--
    if not best_id then
        return false, false
    end

    --[[ Rotate through best sensor ]]--
    if best_id < 13 then
        return -MAX_VEL, MAX_VEL
    else
        return MAX_VEL, -MAX_VEL
    end
end

--[[ Move straight to Light ]]--
function subs.moveToLight(robot)
    best_v, best_id = getHigherLuminosityWithIdx(robot)

    --[[ Light not found in front of robot ]]--
    if not best_id or (best_id >= 3 and best_id <= 22) then
        return false, false
    end

    --[[ Go straight on ]]--
    return MAX_VEL, MAX_VEL
end

--[[ Rotate away from obstacle ]]--
function subs.rotateAwayFromObstacle(robot)
    best_v, best_id = getHigherProximityWithIdx(robot)

    --[[ Obstacle not detected ]]--
    if (not best_id) or best_v <= PROX_RANGE then
        return false, false
    end

    --[[ Rotate away from nearest obstacle ]]--
    if best_id < 13 then
        return MAX_VEL, -MAX_VEL
    else
        return -MAX_VEL, MAX_VEL
    end
end

--[[ Run away from behind obstacle ]]--
function subs.moveAwayFromObstacle(robot)
    best_v, best_id = getHigherProximityWithIdx(robot)

    --[[ Obstacle not detected behind robot ]]--
    if (not best_id) or best_id <= 6 or best_id >= 19 then
        return false, false
    end

    --[[ Run away from behind obstacle ]]--
    return MAX_VEL, MAX_VEL
end

--[[ Safe stop near light ]]--
function subs.safeStopNearLight(robot)
    best_v, best_id = getHigherLuminosityWithIdx(robot)

    --[[ Light not found or too low ]]--
    if not best_id or best_v <= 0.1 then
        return false, false
    end

    --[[ Safe stop near light ]]--
    --opposite = ((best_id + 12) % 25) + math.floor((best_id + 12) / 25)
    --opp_v = robot.light[opposite].value
    if best_v >= STOP_THR then
        return 0, 0
    else
        return false, false
    end
end

return subs
