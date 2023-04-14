
MAXSPEED = 15
PROXRANGE = 0.2
MAXRANGE = 30
W = 0.1
S = 0.01
PSmax = 0.99
PWmin = 0.005
alpha = 0.1
beta = 0.05


states = {RANDWALK = 0, STOP = 1}
currentState = states.RANDWALK
nextState = states.RANDWALK


function init()
    currentState = states.RANDWALK
    nextState = states.RANDWALK
end



function CountRAB()
    number_robot_sensed = 0
    for i = 1, #robot.range_and_bearing do
        -- for each robot seen, check if it is close enough.
        if robot.range_and_bearing[i].range < MAXRANGE and
            robot.range_and_bearing[i].data[1]==1 then
            number_robot_sensed = number_robot_sensed + 1
        end
    end
    return number_robot_sensed
end



function getHigherProximityWithIdx()
    best_value = 0
    best_id = false
    for i=1,#robot.proximity do
		if robot.proximity[i].value > best_value and robot.proximity[i].value <= PROXRANGE then
			best_value = robot.proximity[i].value
			best_id = i
		end
	end
    return best_value, best_id
end



function avoidObstacles()
    best_v, best_id = getHigherProximityWithIdx()
    if best_id then
        if best_id < 7 then
            robot.wheels.set_velocity(MAXSPEED, -MAXSPEED/2)
        elseif best_id > 18 then
            robot.wheels.set_velocity(-MAXSPEED/2, MAXSPEED)
        end
    end
end



function step()
    currentState = nextState
    robot.range_and_bearing.set_data(1,currentState)

    N = CountRAB()

    Ps = math.min(PSmax,S+alpha*N)
    Pw = math.max(PWmin,W-beta*N)

    if currentState == states.RANDWALK then
        robot.wheels.set_velocity(math.random(0, MAXSPEED), math.random(0, MAXSPEED))
        avoidObstacles()
        robot.leds.set_all_colors("black")
        
        if robot.random.uniform() <= Ps then
            nextState = states.STOP
        end
    end

    if currentState == states.STOP then
        robot.wheels.set_velocity(0, 0)
        robot.leds.set_all_colors("red")

        if robot.random.uniform() <= Pw then
            nextState = states.RANDWALK
        end
    end
end



function reset()
    currentState = states.RANDWALK
    nextState = states.RANDWALK
end



function destroy()
    print("Aih!")
end
