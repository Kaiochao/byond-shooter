#include <kaiochao\shapes\shapes.dme>

#include "Target.dm"

turf
	grass
		icon_state = "rect"
		color = "green"

	wall
		icon_state = "rect"
		color = rgb(64, 64, 64)
		density = TRUE
		layer = TURF_LAYER + 1/2
