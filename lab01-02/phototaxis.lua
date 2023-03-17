-- Put your global variables here

VELOCITY_MULT = 20

--[[ This function is executed every time you press the 'execute'
     button ]]
function init()
	robot.wheels.set_velocity(0,0)
end



--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
	--[[ Find light direction ]]--

	--[[ Follow greatest sensor value ]]--
	--[[value = 0
	idx = 0
	for i=1,#robot.light do
		if value < robot.light[i].value then
			idx = i
			value = robot.light[i].value
		end
	end
	robot.wheels.set_velocity(idx, 25-idx)]]--

	--[[ Sum sensor value, left ones contrib on right wheel, and vice versa ]]--
	left = 0
	right = 0
	for i=1,#robot.light do
		if i < 13 then
			left = left + robot.light[i].value
		else
			right = right + robot.light[i].value
		end
	end
	robot.wheels.set_velocity(right*VELOCITY_MULT, left*VELOCITY_MULT)
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
   -- put your code here
end
