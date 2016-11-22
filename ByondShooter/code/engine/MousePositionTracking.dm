#ifndef PARSE_MOUSE_COORDS
#define PARSE_MOUSE_COORDS 1
#endif

#if PARSE_MOUSE_COORDS && !(defined(TILE_WIDTH) && defined(TILE_HEIGHT))
#error Please define TILE_WIDTH and TILE_HEIGHT.
#endif

obj/mouse_catcher
	icon = null
	screen_loc = "SOUTHWEST to NORTHEAST"
	mouse_opacity = 2
	plane = -100
	layer = -1#INF

client
	var
		mouse_tracking_enabled = FALSE

	var global
		obj/MOUSE_CATCHER = new /obj/mouse_catcher
		regex/MOUSE_SCREEN_LOC_REGEX = new /regex ("(?:(.+):)?(\\d+):(\\d+),(\\d+):(\\d+)")

	var tmp
		mouse_screen_loc
		mouse_over_control

	MouseEntered(object, location, control, params)
		if(mouse_tracking_enabled)
			mouse_over_control = control
			SetMouseScreenLoc(params2list(params)["screen-loc"])
		..()

	MouseMove(object, location, control, params)
		if(mouse_tracking_enabled)
			mouse_over_control = control
			SetMouseScreenLoc(params2list(params)["screen-loc"])
		..()

	MouseDrag(src_object, over_object, src_location, over_location, src_control, over_control, params)
		if(mouse_tracking_enabled)
			mouse_over_control = over_control
			SetMouseScreenLoc(params2list(params)["screen-loc"])
		..()

	proc
		EnableMouseTracking()
			if(!mouse_tracking_enabled)
				screen += MOUSE_CATCHER
				mouse_tracking_enabled = TRUE

		DisableMouseTracking()
			if(mouse_tracking_enabled)
				screen -= MOUSE_CATCHER
				mouse_tracking_enabled = FALSE

		SetMouseScreenLoc(ScreenLoc)
			if(!MOUSE_SCREEN_LOC_REGEX.Find(ScreenLoc)) return

			mouse_screen_loc = ScreenLoc

			#if PARSE_MOUSE_COORDS
			ParseMouseCoords(MOUSE_SCREEN_LOC_REGEX.group)
			#endif

		UpdateMouseMapCoords()
			mouse_map_coord_x = mouse_screen_coord_x + bound_x - 1
			mouse_map_coord_y = mouse_screen_coord_y + bound_y - 1

	#if PARSE_MOUSE_COORDS
	var tmp
		mouse_screen_x
		mouse_screen_y
		mouse_screen_pixel_x
		mouse_screen_pixel_y
		mouse_screen_coord_x
		mouse_screen_coord_y
		mouse_map_coord_x
		mouse_map_coord_y

	proc
		ParseMouseCoords(list/Data)
			mouse_screen_x = text2num(Data[2])
			mouse_screen_y = text2num(Data[4])

			mouse_screen_pixel_x = text2num(Data[3])
			mouse_screen_pixel_y = text2num(Data[5])

			mouse_screen_coord_x = mouse_screen_pixel_x + (mouse_screen_x - 1) * TILE_WIDTH
			mouse_screen_coord_y = mouse_screen_pixel_y + (mouse_screen_y - 1) * TILE_HEIGHT
	#endif
