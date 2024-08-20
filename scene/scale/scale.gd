extends Node3D
class_name Scale

const PAN_DROP_POINT := .33

@onready var left_pan: Area3D = $Visuals/PanR/LeftPan
var left_pan_weight: float = 0

@onready var right_pan: Area3D = $Visuals/PanL/RightPan
var right_pan_weight: float = 0

@export var pan_height_range: float
var starting_pan_height: float = 0

var last_pan_difference := 0.0


func _ready() -> void:
	#starting_pan_height = left_pan.global_position.y
	starting_pan_height = ($Visuals/PanR as Node3D).global_position.y
	GameEvents.weight_submitted.connect(on_weight_submitted)


func on_weight_submitted(result_callback: Callable) -> void:
	var pan_difference := right_pan_weight - left_pan_weight
	# Use the right pan as our "baseline" for doing difference computations
	var pan_difference_percent := pan_difference / (right_pan_weight + left_pan_weight)
	var pan_height_change := pan_height_range * pan_difference_percent

	var left_pan_mesh := $Visuals/PanR as Node3D
	var right_pan_mesh := $Visuals/PanL as Node3D
	var beam_mesh := $Visuals/Beam as Node3D

	var tween_time := 3 if pan_difference != last_pan_difference else 0

	var left_tween := create_tween().bind_node(left_pan_mesh)
	var right_tween := create_tween().bind_node(right_pan_mesh)
	var beam_tween := create_tween().bind_node(beam_mesh)

	# Teeter the pans first to give them some motion
	teeter_pans(left_tween, right_tween, beam_tween)

	tween_balancing(left_tween, right_tween, beam_tween, pan_height_change, 3)

	left_tween.tween_callback(func() -> void: result_callback.call())
	last_pan_difference = pan_difference

	if (pan_difference == 0):
		left_tween.tween_callback(func() -> void: GameEvents.emit_correct_weight_submitted())
	else:
		left_tween.tween_callback(func() -> void: GameEvents.emit_incorrect_weight_submitted())


func teeter_pans(left_tween: Tween, right_tween: Tween, beam_tween: Tween) -> void:
	var left_pan_mesh := $Visuals/PanR as Node3D
	var right_pan_mesh := $Visuals/PanL as Node3D

	var left_pan_relative_starting_height := left_pan_mesh.global_position.y - starting_pan_height

	tween_balancing(left_tween, right_tween, beam_tween, left_pan_relative_starting_height + .01, .4)
	tween_balancing(left_tween, right_tween, beam_tween, left_pan_relative_starting_height + -.01, .6)
	tween_balancing(left_tween, right_tween, beam_tween, left_pan_relative_starting_height + .0, .4)


# Tweens the movement of pans and beam to end at a height relative to the neutral position
func tween_balancing(left_pan_tween: Tween, right_pan_tween: Tween, beam_tween: Tween, \
					left_relative_end_height: float, duration: float) -> void:

	# Create tweens if called without
	left_pan_tween = create_tween() if left_pan_tween == null else left_pan_tween
	right_pan_tween = create_tween() if right_pan_tween == null else right_pan_tween
	beam_tween = create_tween() if beam_tween == null else beam_tween

	# Position Pans
	var left_pan_mesh := $Visuals/PanR as Node3D
	var right_pan_mesh := $Visuals/PanL as Node3D
	left_pan_tween.tween_property(left_pan_mesh, "global_position:y", starting_pan_height + left_relative_end_height, duration)\
					.set_ease(Tween.EASE_IN_OUT)
	right_pan_tween.tween_property(right_pan_mesh, "global_position:y", starting_pan_height + -left_relative_end_height, duration)\
					.set_ease(Tween.EASE_IN_OUT)

	# Rotate beam
	var beam_mesh := $Visuals/Beam as Node3D
	var rads := -asin(left_relative_end_height / PAN_DROP_POINT)
	beam_tween.tween_property(beam_mesh, "rotation:z", rads, duration)\
				.set_ease(Tween.EASE_IN_OUT)


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
