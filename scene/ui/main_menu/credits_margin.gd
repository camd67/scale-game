extends MarginContainer

@onready var settings_section: VBoxContainer = %SettingsSection

func _ready() -> void:
	var credit_data := CreditsData.get_credits_data()
	# Reverse the credits since we push them all back to index 0 (which re-reverses it)
	credit_data.reverse()

	for section: Array in credit_data:
		var hbox := HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 16)

		var left_label := Label.new()
		left_label.text = section[0]
		hbox.add_child(left_label)

		hbox.add_spacer(false)

		var right_label := Label.new()
		right_label.text = section[1]
		right_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		right_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		hbox.add_child(right_label)

		if right_label.text == "":
			# Assume that credits without right text are headers
			left_label.add_theme_font_size_override("font_size", 24)

		if section.size() > 2:
			# add link in
			var link := LinkButton.new()
			link.text = section[2]
			link.uri = section[3]
			hbox.add_child(link)

		settings_section.add_child(hbox)
		settings_section.move_child(hbox, 0)
