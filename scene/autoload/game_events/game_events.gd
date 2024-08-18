extends Node


# An object has entered the pan
signal pan_entered()

func emit_pan_entered() -> void:
	pan_entered.emit()

# An object has entered the pan
signal pan_exited()

func emit_pan_exited() -> void:
	pan_exited.emit()

# The player has "locked in" and submitted their solution
signal weight_submitted()

func emit_weight_submitted() -> void:
	weight_submitted.emit()

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

signal play_pressed()

func emit_play_pressed() -> void:
	play_pressed.emit()

signal debug_instant_play()

func emit_debug_instant_play() -> void:
	debug_instant_play.emit()
