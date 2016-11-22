#include <kaiochao\shapes\shapes.dme>

#include "engine\UpdateLoop.dm"

#include "component\MovementPlayer.dm"
#include "component\ShootingPlayer.dm"

mob/player
	icon_state = "oval"
	color = "navy"

	transform = matrix(24/32, 0, 0, 0, 24/32, 0)
	bounds = "5,5 to 28,28"

	var
		components_initialized = FALSE

		component
			movement/player/movement
			shooting/player/shooting

		tmp
			loop_lock = null
			last_update_time = null

	Login()
		Respawn()
		EquipGun()
		if(!components_initialized)
			InitializeComponents()

	Logout()
		Dispose()

	proc
		Dispose()
			remove_updater(src)
			loc = null
			key = null

		Respawn()
			loc = pick(spawnpoints) // global in World.dm

		EquipGun()
			overlays += new /obj {
				icon_state = "rect"
				color = "black"
				transform = matrix(4/32, 0, 0, 0, 1, 32)
			}

		InitializeComponents()
			movement = new (src)
			shooting = new (src)
			components_initialized = TRUE
			add_updater(src)

		Update()
			movement.Update(src)
			shooting.Update(src)
