extends Node3D

@onready var left_pan: Area3D = $LeftPan
@onready var left_pan_label: Label3D = $LeftPanLabel

@onready var right_pan: Area3D = $RightPan
@onready var right_pan_label: Label3D = $RightPanLabel


func _physics_process(delta: float) -> void:
	apply_pan_labels(left_pan.get_overlapping_bodies(), left_pan_label)
	apply_pan_labels(right_pan.get_overlapping_bodies(), right_pan_label)


func apply_pan_labels(bodies: Array[Node3D], parent_label: Label3D) -> void:
	parent_label.text = "There are %s bodies in this pan" % bodies.size()
	var children := parent_label.get_children()
	for body_idx: int in min(bodies.size(), 4):
		parent_label.get_child(body_idx).text = bodies[body_idx].name
	for child_idx: int in 4 - bodies.size():
		parent_label.get_child(3 - child_idx).text = ""
