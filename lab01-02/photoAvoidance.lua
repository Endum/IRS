---@diagnostic disable: undefined-global, lowercase-global
MOVE_STEPS = 15
MAX_VELOCITY = 10
LIGHT_THRESHOLD = 1.5

value = -1
ignoreLight = false
iterationsToIgnoreLight = 0

function init()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
	value = -1
	ignoreLight = false
	iterationsToIgnoreLight = 0
end

function step()
	if ignoreLight == false then
		log("light")
		for i=1,#robot.light do
			if value < robot.light[i].value then
				idx = i
				value = robot.light[i].value
			end
		end

		if idx == 1 or idx == 24 then
			left_v = MAX_VELOCITY
			right_v = MAX_VELOCITY
		elseif idx > 1 and idx < 13 then
			left_v = -MAX_VELOCITY
			right_v = MAX_VELOCITY
		else
			left_v = MAX_VELOCITY
			right_v = -MAX_VELOCITY
		end
	end

	if ignoreLight == true then
		log("random")
		left_v = robot.random.uniform(0,MAX_VELOCITY)
		right_v = robot.random.uniform(0,MAX_VELOCITY)
	end

	for i=1,#robot.proximity do
		log("proximity")
		value = robot.proximity[i].value

		if ignoreLight == false then
			ignoreLight = true
		end
		iterationsToIgnoreLight = iterationsToIgnoreLight + 1

		if i < 13 then
			left_v = left_v + (value*20)
			right_v = right_v - (value*20)
		else
			left_v = left_v - (value*20)
			right_v = right_v + (value*20)
		end
	end

	robot.wheels.set_velocity(left_v,right_v)

	if (iterationsToIgnoreLight > 20) then
		ignoreLight = false
		iterationsToIgnoreLight = 0
	end

end


function reset()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
	robot.leds.set_all_colors("black")
end


function destroy()
	x = robot.positioning.position.x
	y = robot.positioning.position.y
	d = math.sqrt((x-1.5)^2 + y^2)
	print("f_distance: "..d)
end
