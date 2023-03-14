-- Put your global variables here

MAX_VEL = 10
prox_range = 0.4

--[[ This function is executed every time you press the 'execute'
     button ]]
function init()
	robot.wheels.set_velocity(0,0)
end



--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
	--[[ First of all, mini check of currently collisioning ]]--
	for i=1,#robot.proximity do
		if robot.proximity[i].value == 1 then
			log("Collision!")
		end
	end

	--[[ 
		If light detected more on left, turn left and vice versa.
		If sensor with greatest value is on front goes straight.
		If there's no light goes straight.
	]]--
	left = 0
	right = 0
	best_value = 0
	best_id = -1
	for i=1,#robot.light do
		if i < 13 then
			left = left + robot.light[i].value
		else
			right = right + robot.light[i].value
		end
		if robot.light[i].value > best_value then
			best_value = robot.light[i].value
			best_id = i
		end
	end
	--[[ Apply rules upper described ]]--
	if best_id == 2 or best_id == 23 or (left == 0 and right == 0) then
		robot.wheels.set_velocity(MAX_VEL, MAX_VEL)
	else
		if left > right then
			robot.wheels.set_velocity(-MAX_VEL, MAX_VEL)
		else
			robot.wheels.set_velocity(MAX_VEL, -MAX_VEL)
		end
	end

	--[[ 
		If proximity detected on top left corner, turn right and vice versa, entering escape mode.
		In escape mode robot continue escape meanwhile proximity detected on front.
		Else if proximity detected on back goes straight.
	]]--
	left = false
	right = false
	back = false
	for i=1,#robot.proximity do
		if i < 7 then
			left = left or (robot.proximity[i].value > prox_range)
		elseif i > 18 then
			right = right or (robot.proximity[i].value > prox_range)
		else
			back = back or (robot.proximity[i].value > 0.2)
		end
	end
	--[[ Check if escape mode is needed ]]--
	if left or right then
		prox_range = 0
	else
		prox_range = 0.3
	end
	--[[ Apply rules upper described ]]--
	if left then
		robot.wheels.set_velocity(MAX_VEL, -MAX_VEL)
	elseif right then
		robot.wheels.set_velocity(-MAX_VEL, MAX_VEL)
	elseif back then
		robot.wheels.set_velocity(MAX_VEL, MAX_VEL)
	end
end



--[[ This function is executed every time you press the 'reset'
     button in the GUI. It is supposed to restore the state
     of the controller to whatever it was right after init() was
     called. The state of sensors and actuators is reset
     automatically by ARGoS. ]]
function reset()
	robot.wheels.set_velocity(0,0)
end



--[[ This function is executed only once, when the robot is removed
     from the simulation ]]
function destroy()
   x = robot.positioning.position.x
   y = robot.positioning.position.y
   d = math.sqrt((x-1.5)^2 + y^2)
   print('f_distance ' .. d)
end
