extends Node


# An object has entered the pan
signal pan_entered()

func emit_pan_entered() -> void:
	pan_entered.emit()
	
# An object has entered the pan
signal pan_exited()

func emit_pan_exited() -> void:
	pan_exited.emit()
