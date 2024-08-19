extends Node

@export var level_definition: LevelDefinition


func _ready() -> void:
	GameEvents.correct_weight_submitted.connect(on_correct_weight_submitted)


func on_correct_weight_submitted() -> void:
	print("Go to next level")
