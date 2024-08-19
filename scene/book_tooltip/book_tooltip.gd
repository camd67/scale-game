extends Node3D
class_name BookTooltip

@onready var open_animation_player: AnimationPlayer = $OpenAnimationPlayer

func _ready() -> void:
	$TooltipLabel.scale.x = 0


func update_text(text: String) -> void:
	$TooltipLabel.text = text


func open_book() -> void:
	open_animation_player.play("open")


func close_book() -> void:
	open_animation_player.play_backwards("open")
