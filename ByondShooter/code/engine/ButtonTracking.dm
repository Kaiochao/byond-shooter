#define BUTTON_MOUSE_LEFT "MouseLeft"
#define BUTTON_MOUSE_RIGHT "MouseRight"
#define BUTTON_MOUSE_MIDDLE "MouseMiddle"
#define ANALOG_LEFT "GamepadLeftAnalog"
#define ANALOG_RIGHT "GamepadRightAnalog"

client
	var
		list
			buttons_pressed
			analog_values

	MouseDown(object, location, control, params)
		var list/p = params2list(params)
		if(p["left"]) ButtonPress(BUTTON_MOUSE_LEFT)
		if(p["right"]) ButtonPress(BUTTON_MOUSE_RIGHT)
		if(p["middle"]) ButtonPress(BUTTON_MOUSE_MIDDLE)
		..()

	MouseUp(object, location, control, params)
		var list/p = params2list(params)
		if(p["left"]) ButtonRelease(BUTTON_MOUSE_LEFT)
		if(p["right"]) ButtonRelease(BUTTON_MOUSE_RIGHT)
		if(p["middle"]) ButtonRelease(BUTTON_MOUSE_MIDDLE)
		..()

	verb
		ButtonPress(Button as text)
			set
				name = ".button press"
				instant = TRUE
				waitfor = FALSE
			if(!buttons_pressed)
				buttons_pressed = new /list
			buttons_pressed[Button] = TRUE

		ButtonRelease(Button as text)
			set
				name = ".button release"
				instant = TRUE
				waitfor = FALSE

			if(buttons_pressed)
				buttons_pressed -= Button
				if(!buttons_pressed.len)
					buttons_pressed = null

		Analog(Analog as text, X as num, Y as num)
			set
				name = ".analog"
				instant = TRUE
				waitfor = FALSE
			if(X || Y)
				if(!analog_values)
					analog_values = new /list
				else
					var list/old_values = analog_values[Analog]
					if(old_values && old_values[1] == X && old_values[2] == Y)
						return
				analog_values[Analog] = list(X, Y)
			else if(analog_values)
				analog_values -= Analog
				if(!analog_values.len)
					analog_values = null

	proc
		IsButtonPressed(Button as text)
			return buttons_pressed && buttons_pressed[Button]

		GetAnalogValues(Analog as text)
			return analog_values && analog_values[Analog] || list(0, 0)

		DisableButtonTracking()
			winset(src, "AnyKey", "parent=")
			winset(src, "AnyKeyUp", "parent=")
			winset(src, "AnalogLeft", "parent=")
			winset(src, "AnalogRight", "parent=")

		EnableButtonTracking()
			winset(src, "AnyKey", {"
					parent=macro;
					name=Any;
					command=".button-press \[\[*]]"
			"})

			winset(src, "AnyKeyUp", {"
					parent=macro;
					name=Any+UP;
					command=".button-release \[\[*]]"
			"})

			winset(src, "AnalogLeft", {"
					parent=macro;
					name=[ANALOG_LEFT];
					command=".analog \\\"[ANALOG_LEFT]\\\" \[\[x]] \[\[y]]"
			"})

			winset(src, "AnalogRight", {"
					parent=macro;
					name=[ANALOG_RIGHT];
					command=".analog \\\"[ANALOG_RIGHT]\\\" \[\[x]] \[\[y]]"
			"})
