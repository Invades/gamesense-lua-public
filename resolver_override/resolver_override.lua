-- menu shit
override = ui.new_checkbox("RAGE", "Other", "Resolver override")
override_color = ui.new_color_picker("RAGE", "Other", "\n flag")
override_key = ui.new_hotkey("RAGE", "Other", "Override key")
override_indicator = ui.new_combobox("RAGE", "Other", "Indicator type", "-", "Default", "Crosshair")

local function update_menu(visible)
	if ui.get(override, true) then
		ui.set_visible(override_color, true)
		ui.set_visible(override_key, true)
		ui.set_visible(override_indicator, true)
	else
		ui.set_visible(override_color, false)
		ui.set_visible(override_key, false)
		ui.set_visible(override_indicator, false)
	end
end
client.set_event_callback("paint", update_menu)

-- references men
selectedplayer = ui.reference("PLAYERS", "Players", "Player list")
forcebody = ui.reference("PLAYERS", "Adjustments", "Force body yaw")
resetlist = ui.reference("PLAYERS", "Players", "Reset all")
correction_active = ui.reference("PLAYERS", "Adjustments", "Correction active")
applyall = ui.reference("players", "adjustments", "Apply to all")
body_slider = ui.reference("PLAYERS", "Adjustments", "Force body yaw value")

-- override key

function setbodyyaw()
	if ui.get(override, true) then
	else
		return
	end
	if ui.get(body_slider) == 0 and canManual == true then
		ui.set(forcebody, true)
		ui.set(body_slider, 60)
		ui.set(applyall, true)
		canManual = false
	end
	if ui.get(body_slider) == 60 and canManual == true then
		ui.set(forcebody, true)
		ui.set(body_slider, -60)
		ui.set(applyall, true)
		canManual = false
	end
    if ui.get(body_slider) == -60 and canManual == true then
		ui.set(forcebody, false)
		ui.set(body_slider, 0)
		ui.set(applyall, true)
		canManual = false
    end
end

function on_paint()
	if ui.get(override, true) then
	else
		return
	end
	if ui.get(override_key) then
		if canManual == true then
			setbodyyaw()
			canManual = false
		end
	else
		canManual = true
	end
end
client.set_event_callback("paint", on_paint)

-- overide flag

local r, g, b = ui.get(override_color) --this doesn't work cus flags are really weird so I'm just setting a static color instead, if anyone knows how to make this work then please let me know

client.register_esp_flag("LEFT", 255, 0, 255, function(c)
	if ui.get(body_slider) == 60 then return true end
end)
client.register_esp_flag("RIGHT", 255, 0, 255, function(c)
	if ui.get(body_slider) == -60 then return true end
end)

-- override indicators

client.set_event_callback("paint", function()

	local r, g, b, a = ui.get(override_color)
	local w, h = client_screen_size()
	local center = { w/2, h/2 }
	local y = (center[2])
	
	if ui.get(override, true) and ui.get(override_indicator) == "Default" then
		if ui.get(body_slider) == -60 then
			renderer.indicator(r, g, b, a, "RIGHT")
		elseif ui.get(body_slider) == 60 then
			renderer.indicator(r, g, b, a, "LEFT")
		elseif ui.get(forcebody) == false then
			renderer.indicator(r, g, b, a, "DEFAULT")
		end
	end
	if ui.get(override, true) and ui.get(override_indicator) == "Crosshair" then
		if ui.get(body_slider) == -60 then
			renderer.text(center[1] + 7, y + 25, r, g, b, a, "c", 0, "RIGHT ⮞")
		elseif ui.get(body_slider) == 60 then
			renderer.text(center[1] - 7, y + 25, r, g, b, a, "c", 0, "⮜ LEFT")
		elseif ui.get(forcebody) == false then
			renderer.text(center[1], y + 25, 255, 255, 255, a, "c", 0, "DEFAULT")
		end
	end
end)

-- reset override on round start
client.set_event_callback("round_start", function()
	ui.set(body_slider, 0)
	ui.set(forcebody, false)
	ui.set(applyall, true)
end)