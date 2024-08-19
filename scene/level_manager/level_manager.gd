extends Node

@export var level_definitions: Array[LevelDefinition]
@export var spawner: Spawner

var current_level: LevelDefinition
var current_level_number := 0


func _ready() -> void:
	GameEvents.camera_intro_finished.connect(on_camera_intro_finished)
	GameEvents.correct_weight_submitted.connect(on_correct_weight_submitted)


func on_correct_weight_submitted() -> void:
	current_level_number += 1
	current_level = level_definitions[current_level_number]
	spawner.level_definition = current_level
	spawner.begin_level()


func on_camera_intro_finished() -> void:
	current_level = level_definitions[0]
	spawner.level_definition = current_level
	spawner.begin_level()
