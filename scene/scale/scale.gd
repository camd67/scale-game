extends Node3D
class_name Scale

@onready var left_pan: Area3D = $LeftPan
var left_pan_weight: float = 0

@onready var right_pan: Area3D = $RightPan
var right_pan_weight: float = 0

@export var pan_height_range: float
var starting_pan_height: float = 0


func _ready() -> void:
	#starting_pan_height = left_pan.global_position.y
	starting_pan_height = ($Visuals/PanR as Node3D).global_position.y
	GameEvents.weight_submitted.connect(on_level_submitted)

func on_level_submitted() -> void:
	var pan_difference := right_pan_weight - left_pan_weight
	# Use the right pan as our "baseline" for doing difference computations
	var pan_difference_percent := pan_difference / right_pan_weight
	var pan_height_change := pan_height_range * pan_difference_percent

	var left_pan_mesh := $Visuals/PanR as Node3D
	var right_pan_mesh := $Visuals/PanL as Node3D

	var left_end_pos := Vector3(left_pan_mesh.global_position.x, starting_pan_height + pan_height_change, left_pan_mesh.global_position.z)
	var right_end_pos := Vector3(right_pan_mesh.global_position.x, starting_pan_height - pan_height_change, right_pan_mesh.global_position.z)

	var left_tween := create_tween()
	left_tween.bind_node(left_pan_mesh).tween_property(left_pan_mesh, "global_position", left_end_pos, 3).set_ease(Tween.EASE_OUT)
	create_tween().bind_node(right_pan_mesh).tween_property(right_pan_mesh, "global_position", right_end_pos, 3).set_ease(Tween.EASE_OUT)
	left_tween.tween_callback(func() -> void: GameEvents.emit_weighing_finished())



func update_labels() -> void:
	pass


func _on_left_pan_body_entered(body: Node3D) -> void:
	if body is Grabbable and body.weighable != null and body.is_player_grabbable:
		left_pan_weight += body.weighable.weight
		update_labels()
		GameEvents.emit_pan_entered()


func _on_left_pan_body_exited(body: Node3D) -> void:
	if body is Grabbable and body.weighable != null and body.is_player_grabbable:
		left_pan_weight -= body.weighable.weight
		update_labels()
		GameEvents.emit_pan_exited()


func _on_right_pan_body_entered(body: Node3D) -> void:
	if body is Grabbable and body.weighable != null and not body.is_player_grabbable:
		print(body.name)
		right_pan_weight += body.weighable.weight
		update_labels()


func _on_right_pan_body_exited(body: Node3D) -> void:
	# Bodies exit when they are frozen, so this is triggering after we freeze all the right pan bodies
	# Skip for now unless we need it later
	if body is Grabbable and body.weighable != null and not body.is_player_grabbable:
		pass
		#right_pan_weight -= body.weighable.weight
		#update_labels()
