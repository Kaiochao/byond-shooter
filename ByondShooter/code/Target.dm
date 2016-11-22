mob/target
	icon_state = "oval"
	color = "maroon"

	Shot()
		set waitfor = FALSE
		density = FALSE
		animate(src, time = 5,
			easing = SINE_EASING | EASE_OUT,
			transform = matrix() * (1 / 32),
			alpha = 0)
		sleep 5
		loc = null
