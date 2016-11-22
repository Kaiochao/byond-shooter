client
	fps = 60

	show_popup_menus = FALSE

	Move()

	#ifdef DEBUG
	Stat()
		if(statpanel("Debug"))

			stat("World CPU", world.cpu)

			stat("Screen Loc", mouse_screen_loc)
			stat("Over Control", mouse_over_control)
			stat("Screen X", mouse_screen_x)
			stat("Screen Y", mouse_screen_y)
			stat("Screen Pixel X", mouse_screen_pixel_x)
			stat("Screen Pixel Y", mouse_screen_pixel_y)
			stat("Screen Coord X", mouse_screen_coord_x)
			stat("Screen Coord Y", mouse_screen_coord_y)
			stat("Map Coord X", mouse_map_coord_x)
			stat("Map Coord Y", mouse_map_coord_y)

			var list/buttons = new
			if(IsButtonPressed("MouseLeft")) buttons += "Left"
			if(IsButtonPressed("MouseRight")) buttons += "Right"
			if(IsButtonPressed("MouseMiddle")) buttons += "Middle"
			stat("Buttons", json_encode(buttons))

		..()
	#endif

	MouseDown()
		..()
		var mob/player/player = mob
		if(istype(player))
			player.shooting.Shooting(player, src)