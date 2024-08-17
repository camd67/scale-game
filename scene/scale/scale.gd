extends Node3D

@onready var left_pan: Area3D = $LeftPan
@onready var left_pan_label: Label3D = $LeftPanLabel
var left_pan_weight: float = 0

@onready var right_pan: Area3D = $RightPan
@onready var right_pan_label: Label3D = $RightPanLabel
var right_pan_weight: float = 0

@export var pan_height_range: float
var starting_pan_height: float = 0


func _ready() -> void:
	starting_pan_height = left_pan.global_position.y


func _on_button_pressed() -> void:
	var pan_difference := right_pan_weight - left_pan_weight
	# Use the right pan as our "baseline" for doing difference computations
	var pan_difference_percent := pan_difference / right_pan_weight
	var pan_height_change := pan_height_range * pan_difference_percent

	var left_pan_mesh := $Visuals/LeftPanMesh as Node3D
	var right_pan_mesh := $Visuals/RightPanMesh as Node3D

	var left_end_pos := Vector3(left_pan_mesh.global_position.x, starting_pan_height + pan_height_change, left_pan_mesh.global_position.z)
	var right_end_pos := Vector3(right_pan_mesh.global_position.x, starting_pan_height - pan_height_change, right_pan_mesh.global_position.z)

	create_tween().bind_node(left_pan_mesh).tween_property(left_pan_mesh, "global_position", left_end_pos, 3).set_ease(Tween.EASE_OUT)
	create_tween().bind_node(right_pan_mesh).tween_property(right_pan_mesh, "global_position", right_end_pos, 3).set_ease(Tween.EASE_OUT)


func update_labels() -> void:
	left_pan_label.text = "Left pan weights %.1f" % left_pan_weight
	right_pan_label.text = "Right pan weights %.1f" % right_pan_weight


func _on_left_pan_body_entered(body: Node3D) -> void:
	if body is Grabbable and body.weighable != null:
		left_pan_weight += body.weighable.weight
		update_labels()
		GameEvents.emit_pan_entered()


func _on_left_pan_body_exited(body: Node3D) -> void:
	if body is Grabbable and body.weighable != null:
		left_pan_weight -= body.weighable.weight
		update_labels()
		GameEvents.emit_pan_exited()


func _on_right_pan_body_entered(body: Node3D) -> void:
	if body is Grabbable and body.weighable != null:
		right_pan_weight += body.weighable.weight
		update_labels()


func _on_right_pan_body_exited(body: Node3D) -> void:
	# Bodies exit when they are frozen, so this is triggering after we freeze all the right pan bodies
	# Skip for now unless we need it later
	if body is Grabbable and body.weighable != null:
		pass
		#right_pan_weight -= body.weighable.weight
		#update_labels()
