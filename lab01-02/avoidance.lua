-- Put your global variables here

MIN_VELOCITY = 5
MAX_VELOCITY = 10
MOVE_STEPS = 3
PROX_MULT = 5

n_steps = 0

--[[ This function is executed every time you press the 'execute' button ]]
function init()
	left_v = robot.random.uniform(MIN_VELOCITY,MAX_VELOCITY)
	right_v = robot.random.uniform(MIN_VELOCITY,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)

	n_steps = 0
end

--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
	n_steps = n_steps + 1
	if n_steps % MOVE_STEPS == 0 then
		left_v = robot.random.uniform(MIN_VELOCITY,MAX_VELOCITY)
		right_v = robot.random.uniform(MIN_VELOCITY,MAX_VELOCITY)
	end

	for i=1,#robot.proximity do
		prox = robot.proximity[i].value
		prox_det = prox > 0 and 1 or 0
		if prox == 1 then
			log("Collision!!")
		end
		--[[ Increment and decrement speed based on sensor position
			If sensor on the left, increment speed on the left and 
			decrement wheel speed on the right and vice versa.
		]]--
		if i < 13 then
			left_v = left_v + (prox_det * PROX_MULT)
			right_v = right_v - (prox_det * PROX_MULT)
		else
			right_v = right_v + (prox_det * PROX_MULT)
			left_v = left_v - (prox_det * PROX_MULT)
		end
	end

	robot.wheels.set_velocity(left_v,right_v)

end

--[[ This function is executed every time you press the 'reset'
     button in the GUI. It is supposed to restore the state
     of the controller to whatever it was right after init() was
     called. The state of sensors and actuators is reset
     automatically by ARGoS. ]]
function reset()
	left_v = robot.random.uniform(MIN_VELOCITY,MAX_VELOCITY)
	right_v = robot.random.uniform(MIN_VELOCITY,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)

	n_steps = 0
end