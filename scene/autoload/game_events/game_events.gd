extends Node


# An object has entered the pan
signal pan_entered()

func emit_pan_entered() -> void:
	pan_entered.emit()
	
# An object has entered the pan
signal pan_exited()

func emit_pan_exited() -> void:
	pan_exited.emit()


signal play_pressed()

func emit_play_pressed() -> void:
	play_pressed.emit()

signal debug_instant_play()

func emit_debug_instant_play() -> void:
	debug_instant_play.emit()
