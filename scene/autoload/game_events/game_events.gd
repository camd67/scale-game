extends Node


# A level has started
signal level_started()

func emit_level_started() -> void:
	level_started.emit()

# An object has entered the pan
signal pan_entered()

func emit_pan_entered() -> void:
	pan_entered.emit()

# An object has entered the pan
signal pan_exited()

func emit_pan_exited() -> void:
	pan_exited.emit()

# The player has "locked in" and submitted their solution
signal weight_submitted(callback: Callable)

func emit_weight_submitted(callback: Callable) -> void:
	weight_submitted.emit(callback)

# The scale has finished it's weight animation
signal weighing_finished()

func emit_weighing_finished() -> void:
	weighing_finished.emit()

# The player's solution was correct (left pan weight = right pan weight)
signal correct_weight_submitted()

func emit_correct_weight_submitted() -> void:
	correct_weight_submitted.emit()

# The player's solution was incorrect
signal incorrect_weight_submitted()

func emit_incorrect_weight_submitted() -> void:
	incorrect_weight_submitted.emit()

# The play main menu button is pressed
signal play_pressed()

func emit_play_pressed() -> void:
	play_pressed.emit()

# The paning at the start of the game is finished
signal camera_intro_finished

func emit_camera_intro_finished() -> void:
	camera_intro_finished.emit()

signal debug_instant_play()

func emit_debug_instant_play() -> void:
	debug_instant_play.emit()


signal tooltip_requested(text: String)

func emit_tooltip_requested(text: String) -> void:
	tooltip_requested.emit(text)

signal tooltip_done(text: String)

func emit_tooltip_done(text: String) -> void:
	tooltip_done.emit(text)

signal planet_levels_started

func emit_planet_levels_started() -> void:
	planet_levels_started.emit()

signal planet_levels_finished

func emit_planet_levels_finished() -> void:
	planet_levels_finished.emit()

signal game_won

func emit_game_won() -> void:
	game_won.emit()
