#include "Component.dm"

#include "..\engine\PixelMovement.dm"

component/movement
	var
		velocity_x = 0
		velocity_y = 0

	Update(atom/movable/M)
		Velocity(M)

		if(velocity_x != 0 || velocity_y != 0)
			M.PixelMove(velocity_x * world.tick_lag,
						velocity_y * world.tick_lag)

	proc
		Velocity(atom/movable/M)
