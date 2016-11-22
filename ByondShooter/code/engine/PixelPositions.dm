#if !defined(TILE_WIDTH) || !defined(TILE_HEIGHT)
#error Please define TILE_WIDTH and TILE_HEIGHT.
#endif

atom
	proc
		GetWidth()
			return TILE_WIDTH

		GetHeight()
			return TILE_HEIGHT

		GetLowerX()
			return 1 + (x - 1) * TILE_WIDTH

		GetLowerY()
			return 1 + (y - 1) * TILE_HEIGHT

		GetCenterX()
			return GetLowerX() + GetWidth() / 2

		GetCenterY()
			return GetLowerY() + GetHeight() / 2

		AtWorldEdge()
			return x == 1 || y == 1 || x == world.maxx || y == world.maxy

	movable
		GetWidth()
			return bound_width

		GetHeight()
			return bound_height

		GetLowerX()
			return ..() + bound_x + step_x

		GetLowerY()
			return ..() + bound_y + step_y

		AtWorldEdge()
			return x == 1			&& step_x == -bound_x \
				|| x == world.maxx	&& step_x == TILE_WIDTH - bound_x - bound_width \
				|| y == 1			&& step_y == -bound_y \
				|| y == world.maxy	&& step_y == TILE_HEIGHT - bound_y - bound_height
