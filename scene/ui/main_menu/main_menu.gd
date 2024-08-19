extends Control
class_name MainMenu

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var settings_back_button: Button = %SettingsBackButton
@onready var play_button: Button = %PlayButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	if OS.has_feature("editor"):
		var quick_button := Button.new()
		quick_button.text = "Press this or click anywhere to play NOW (editor build only)"
		quick_button.add_theme_font_size_override("font_size", 32)
		quick_button.position = Vector2.ZERO
		quick_button.pressed.connect(func() -> void: instant_play())
		$ColorRect.gui_input.connect(func(e: InputEvent) -> void: if e is InputEventMouseButton: instant_play())
		add_child(quick_button)


	if OS.has_feature("web"):
		quit_button.visible = false

	play_button.pressed.connect(_on_play_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	settings_back_button.pressed.connect(on_settings_back_button_pressed)

	get_tree().root.get_viewport().size_changed.connect(on_viewport_size_changed)

	play_button.grab_focus()


func instant_play() -> void:
	GameEvents.emit_debug_instant_play()
	queue_free()


func _on_play_button_pressed() -> void:
	settings_button.disabled = true
	play_button.disabled = true
	quit_button.disabled = true
	animation_player.play("remove_main_menu")
	GameEvents.emit_play_pressed()


func _on_settings_button_pressed() -> void:
	animation_player.play("settings_in")
	settings_back_button.grab_focus()


func on_settings_back_button_pressed() -> void:
	animation_player.play_backwards("settings_in")
	play_button.grab_focus()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func on_viewport_size_changed() -> void:
	var viewport_size := get_tree().root.get_viewport().get_visible_rect().size
	$Title.position = (viewport_size / 2) - ($Title.size / 2)
