subs = require("subsumptions")

subSumptions = {}

function init()
	robot.wheels.set_velocity(0,0)
	subSumptions = {
		subs.checkCollision,
		subs.randomWalk,
		subs.rotateToLight,
		subs.moveToLight,
		subs.rotateAwayFromObstacle,
		subs.moveAwayFromObstacle,
		subs.safeStopNearLight
	}
end

function step()
	lwheel = robot.wheels.velocity_left
	rwheel = robot.wheels.velocity_right
	--[[ Get action from sub sumptions. ]]--
	for i, sub in ipairs(subSumptions) do
		l, r = sub(robot)
		lwheel = l or lwheel
		rwheel = r or rwheel
	end
	--[[ Apply action choosed. ]]--
	robot.wheels.set_velocity(lwheel, rwheel)
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
