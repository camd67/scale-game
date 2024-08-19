extends RigidBody3D
class_name Grabbable

@export var weighable: Weighable
@export var is_static := false
@export var is_player_grabbable := true
@export var tooltip: String

var tooltip_node: Tooltip

func _ready() -> void:
	if tooltip != null or tooltip != "":
		init_tooltip()

	if is_static:
		# Wait a moment for physics simulation to settle, then freeze everything
		await get_tree().create_timer(1).timeout
		freeze = true
		freeze_mode = FreezeMode.FREEZE_MODE_STATIC


func init_tooltip() -> void:
	#input_event.connect(_on_pickable_input_event)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_ray_pickable = true
	#tooltip_node = load("res://scene/ui/tooltip/tooltip.tscn").instantiate() as Tooltip
	#tooltip_node.tooltip_text = tooltip
	#tooltip_node.visible = false
	#add_child(tooltip_node)


func _on_mouse_entered() -> void:
	GameEvents.emit_tooltip_requested(tooltip)
	#tooltip_node.visible = true
	#tooltip_node.visible = not get_viewport().get_camera_3d().is_position_behind(global_transform.origin)
	#tooltip_node.position = get_viewport().get_camera_3d().unproject_position(global_transform.origin)

func _on_mouse_exited() -> void:
	GameEvents.emit_tooltip_done(tooltip)
