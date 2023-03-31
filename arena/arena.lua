local http = require("socket.http")

function init()
	print(robot.id)
	local body, code, headers, status = http.request("https://www.google.com")
	print(body, code, headers, status)
end


function step()
	
end


function reset()

end


function destroy()

end
