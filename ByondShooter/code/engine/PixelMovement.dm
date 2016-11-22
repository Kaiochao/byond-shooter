atom/movable
	var
		sub_step_x = 0
		sub_step_y = 0

	proc
		PixelMove(X, Y, AllowIndependentAxes = TRUE)
			var whole_x = 0, whole_y = 0
			if(X)
				sub_step_x += X
				whole_x = round(sub_step_x, 1)
				sub_step_x -= whole_x
			if(Y)
				sub_step_y += Y
				whole_y = round(sub_step_y, 1)
				sub_step_y -= whole_y
			if(whole_x || whole_y)
				step_size = max(abs(whole_x), abs(whole_y)) + 1
				if(AllowIndependentAxes && X && Y)
					if(!Move(loc, dir, step_x + whole_x, step_y + whole_y))
						return Move(loc, dir, step_x + whole_x, step_y
								) + Move(loc, dir, step_x, step_y + whole_y)
				else return Move(loc, dir, step_x + whole_x, step_y + whole_y)
