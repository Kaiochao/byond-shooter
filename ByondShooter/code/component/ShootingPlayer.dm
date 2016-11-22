#include "Shooting.dm"

#include "..\engine\MousePositionTracking.dm"
#include "..\engine\ButtonTracking.dm"
#include "..\engine\PixelPositions.dm"

component/shooting/player
	var
		matrix/rotation
		last_dx
		last_dy
		last_shot_time
		shot_cooldown = 1

	New(mob/M)
		M.client.EnableMouseTracking()

	Update(mob/M)
		var client/c = M.client
		c.UpdateMouseMapCoords()
		Aiming(M, c)
		Shooting(M, c)

	proc
		Aiming(mob/M, client/C)
			var
				// delta vector from player to mouse
				dx = C.mouse_map_coord_x - M.GetCenterX()
				dy = C.mouse_map_coord_y - M.GetCenterY()

			// don't update the direction if the delta is zero or hasn't changed
			if(!(dx || dy) || dx == last_dx && dy == last_dy) return

			last_dx = dx
			last_dy = dy

			var
				// distance from player to mouse
				d = sqrt(dx * dx + dy * dy)

				// normalized delta vector from player to mouse
				nx = dx / d
				ny = dy / d

				matrix/old_rotation = rotation || new

			// rotation from north to the direction from player to mouse
			rotation = matrix(ny, nx, 0, -nx, ny, 0)

			animate(M, time = world.tick_lag,
				flags = ANIMATION_END_NOW,
				transform = M.transform * ~old_rotation * rotation)

		Shooting(mob/M, client/C)
			if(last_shot_time + shot_cooldown <= world.time && C.IsButtonPressed(BUTTON_MOUSE_LEFT))
				last_shot_time = world.time
				var obj/bullet/b = new (M, rotation)
				b.PixelMove(40 * rotation.b, 40 * rotation.a)
				if(!b.bumped) b.Go()

obj/bullet
	icon_state = "oval"
	color = "yellow"
	transform = matrix(2/32, 0, 0, 0, 8/32, -4)
	density = TRUE
	bounds = "15,15 to 16,16"

	var
		atom/bumped
		speed = 48
		velocity_x
		velocity_y
		matrix/rotation

	Bump(atom/Obstacle)
		bumped = Obstacle

		if(ismob(Obstacle))
			var mob/m = Obstacle
			m.Shot(src)

		Destroy()

	New(mob/Shooter, matrix/Rotation)
		loc = Shooter.loc
		step_x = Shooter.step_x
		step_y = Shooter.step_y
		rotation = Rotation

	proc
		Go()
			transform *= rotation
			velocity_x = rotation.b * speed
			velocity_y = rotation.a * speed
			add_updater(src)

		Update()
			PixelMove(velocity_x, velocity_y)
			if(AtWorldEdge())
				loc = null
				return

		Destroy()
			SpawnDust()
			remove_updater(src)
			loc = null

		SpawnDust()
			set waitfor = FALSE

			var obj/o = new (loc)
			o.step_x = step_x
			o.step_y = step_y
			o.layer = TURF_LAYER + 1/3
			o.icon_state = "oval"
			o.transform *= 1/32

			var time = rand() * 2 + 2
			animate(o, time = time,
				easing = SINE_EASING | EASE_OUT,
				transform = matrix() * (rand(8, 24)/32),
				alpha = 0)
			sleep time

			o.loc = null
