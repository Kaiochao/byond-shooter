#include "Movement.dm"

#include "..\engine\ButtonTracking.dm"

component/movement/player
	var
		max_speed = 20

		move_north = "W"
		move_south = "S"
		move_east = "D"
		move_west = "A"

	New(mob/M)
		M.client.EnableButtonTracking()

	Velocity(mob/M)
		var
			client/c = M.client
			list/analog = c.GetAnalogValues(ANALOG_LEFT)
			analog_x = analog[1]
			analog_y = analog[2]
			ix = analog_x || c.IsButtonPressed(move_east) - c.IsButtonPressed(move_west)
			iy = analog_y || c.IsButtonPressed(move_north) - c.IsButtonPressed(move_south)

		if(!(analog_x || analog_y) && ix && iy)
			ix /= sqrt(2)
			iy /= sqrt(2)

		velocity_x = ix * max_speed
		velocity_y = iy * max_speed
