extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_play_button_pressed() -> void:
	animation_player.play("remove_main_menu")


func _on_settings_button_pressed() -> void:
	animation_player.play("settings_in")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
