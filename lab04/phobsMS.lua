local mosc = require("motorschema")
local vector = require "vector"

MAX_VEL = 15

motorSchema = {}
L = 0

function init()
	robot.wheels.set_velocity(0,0)
	motorSchema = {
		mosc.checkCollision,
		mosc.randomWalk,
		mosc.lightField,
		mosc.obstacleField,
		--mosc.safeStopNearLight
	}
	L = robot.wheels.axis_length
end

function step()
	pol = vector.vec2_polar(0,0)

	--[[ Calculate for each schema his vector, accumulating by polar sum. ]]--
	for i, schema in ipairs(motorSchema) do
		pol = vector.vec2_polar_sum(pol, schema(robot))
	end

	--[[ Translate from polar vector to wheel velocities. ]]--
	vel = vector.polar_to_vel(pol, L)

	--[[ Apply calculated velocities. ]]--
	robot.wheels.set_velocity(math.min(vel.vl, MAX_VEL), math.min(vel.vr, MAX_VEL))
end



function reset()
	robot.wheels.set_velocity(0,0)
end



function destroy()
   x = robot.positioning.position.x
   y = robot.positioning.position.y
   d = math.sqrt((x-1.5)^2 + y^2)
   print('f_distance ' .. d)
end
