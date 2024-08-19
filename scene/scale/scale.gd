extends Node3D
class_name Scale

@onready var left_pan: Area3D = $LeftPan
var left_pan_weight: float = 0

@onready var right_pan: Area3D = $RightPan
var right_pan_weight: float = 0

@export var pan_height_range: float
var starting_pan_height: float = 0

var last_pan_difference := 0


func _ready() -> void:
	#starting_pan_height = left_pan.global_position.y
	starting_pan_height = ($Visuals/PanR as Node3D).global_position.y
	GameEvents.weight_submitted.connect(on_weight_submitted)


func on_weight_submitted(result_callback: Callable) -> void:
	var pan_difference := right_pan_weight - left_pan_weight
	# Use the right pan as our "baseline" for doing difference computations
	var pan_difference_percent := pan_difference / right_pan_weight
	var pan_height_change := pan_height_range * pan_difference_percent

	var left_pan_mesh := $Visuals/PanR as Node3D
	var right_pan_mesh := $Visuals/PanL as Node3D

	var left_end_pos := Vector3(left_pan_mesh.global_position.x, starting_pan_height + pan_height_change, left_pan_mesh.global_position.z)
	var right_end_pos := Vector3(right_pan_mesh.global_position.x, starting_pan_height - pan_height_change, right_pan_mesh.global_position.z)

	var tween_time := 3 if pan_difference != last_pan_difference else 0

	var left_tween := create_tween().bind_node(left_pan_mesh)
	var right_tween := create_tween().bind_node(right_pan_mesh)

	# Teeter the pans first to give them some motion
	teeter_pans(left_tween, right_tween)

	left_tween.tween_property(left_pan_mesh, "global_position", left_end_pos, 3).set_ease(Tween.EASE_OUT)
	right_tween.tween_property(right_pan_mesh, "global_position", right_end_pos, 3).set_ease(Tween.EASE_OUT)
	left_tween.tween_callback(func() -> void: result_callback.call())
	last_pan_difference = pan_difference

	if (pan_difference == 0):
		left_tween.tween_callback(func() -> void: GameEvents.emit_correct_weight_submitted())
	else:
		left_tween.tween_callback(func() -> void: GameEvents.emit_incorrect_weight_submitted())


func teeter_pans(left_tween: Tween, right_tween: Tween) -> void:
	var left_pan_mesh := $Visuals/PanR as Node3D
	var right_pan_mesh := $Visuals/PanL as Node3D

	left_tween.tween_property(left_pan_mesh, "global_position", left_pan_mesh.global_position + Vector3.UP * .01, .4)
	left_tween.tween_property(left_pan_mesh, "global_position", left_pan_mesh.global_position + Vector3.UP * -.01, .6)
	left_tween.tween_property(left_pan_mesh, "global_position", left_pan_mesh.global_position + Vector3.UP * 0, .4)

	right_tween.tween_property(right_pan_mesh, "global_position", right_pan_mesh.global_position + Vector3.UP * -.01, .4)
	right_tween.tween_property(right_pan_mesh, "global_position", right_pan_mesh.global_position + Vector3.UP * .01, .6)
	right_tween.tween_property(right_pan_mesh, "global_position", right_pan_mesh.global_position + Vector3.UP * 0, .4)



func update_labels() -> void:
	pass


func _on_left_pan_body_entered(body: Node3D) -> void:
	if body is Grabbable and body.weighable != null and body.is_player_grabbable:
		left_pan_weight += body.weighable.weight
		print("left weight: " + str(left_pan_weight))
		update_labels()
		GameEvents.emit_pan_entered()


func _on_left_pan_body_exited(body: Node3D) -> void:
	if body is Grabbable and body.weighable != null and body.is_player_grabbable:
		left_pan_weight -= body.weighable.weight
		print("left weight: " + str(left_pan_weight))
		update_labels()
		GameEvents.emit_pan_exited()


func _on_right_pan_body_entered(body: Node3D) -> void:
	if body is Grabbable and body.weighable != null and not body.is_player_grabbable:
		right_pan_weight += body.weighable.weight
		print("right weight: " + str(right_pan_weight))
		update_labels()


func _on_right_pan_body_exited(body: Node3D) -> void:
	# Bodies exit when they are frozen, so this is triggering after we freeze all the right pan bodies
	# Skip for now unless we need it later
	if body is Grabbable and body.weighable != null and not body.is_player_grabbable:
		pass
		right_pan_weight -= body.weighable.weight
		update_labels()
