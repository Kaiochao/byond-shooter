var
	list/updaters
	update_loop_lock

updater
	proc
		Update()

proc
	start_updating()
		set waitfor = FALSE
		if(update_loop_lock) return
		var lock = (update_loop_lock = new /datum)
		var last_update_time
		do
			if(last_update_time == world.time) continue
			last_update_time = world.time
			for(var/u in updaters)
				var updater/updater = u
				updater.Update()
			sleep world.tick_lag
		while(lock == update_loop_lock && updaters)

	stop_updating()
		update_loop_lock = null

	add_updater(updater)
		if(!updaters)
			updaters = new /list
			start_updating()
		updaters |= updater

	remove_updater(updater)
		if(updater in updaters)
			updaters -= updater
			if(!length(updaters))
				updaters = null
