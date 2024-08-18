extends RigidBody3D
class_name Grabbable

@export var weighable: Weighable
@export var is_static := false
@export var is_player_grabbable := true

func _ready() -> void:
	if is_static:
		# Wait a moment for physics simulation to settle, then freeze everything
		await get_tree().create_timer(1).timeout
		freeze = true
		freeze_mode = FreezeMode.FREEZE_MODE_STATIC
