extends Node

#@export var scale : Scale


#func _ready() -> void:
	#GameEvents.weighing_finished.connect(on_weighing_finished)
#
#
#func _process(delta: float) -> void:
	#if OS.has_feature("editor"):
		#if Input.is_action_just_pressed("lockin(debug)"):
			#GameEvents.emit_weight_submitted(func(callback: Callable) -> void: print('submitted'))
#
#
#func on_weighing_finished() -> void:
	#print("weight submitted")
	#print("left pan weight: " + str(scale.left_pan_weight))
	#print("right pan weight: " + str(scale.right_pan_weight))
	#if scale.left_pan_weight == scale.right_pan_weight:
		#GameEvents.emit_correct_weight_submitted()
	#else:
		#GameEvents.emit_incorrect_weight_submitted()
