extends Node

@onready var animation_player: AnimationPlayer = $scaledungeon/AnimationPlayer

func _ready() -> void:
	animation_player.play("MagicBallAction")
