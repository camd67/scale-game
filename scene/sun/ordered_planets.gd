extends Node3D

const lowered_amount := 0.132


func _ready() -> void:
	GameEvents.planet_levels_started.connect(on_planet_levels_started)
	GameEvents.planet_levels_finished.connect(on_planet_levels_finished)


func on_planet_levels_started() -> void:
	var position_node := $Position as Node3D

	var tween := create_tween()
	tween.bind_node(position_node)
	tween.tween_property(position_node, "global_position:y", position_node.global_position.y - lowered_amount, 2)


func on_planet_levels_finished() -> void:
	var position_node := $Position as Node3D

	var tween := create_tween()
	tween.bind_node(position_node)
	tween.tween_property(position_node, "global_position:y", position_node.global_position.y + lowered_amount, 2)
