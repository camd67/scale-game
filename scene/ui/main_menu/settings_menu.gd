extends MarginContainer

@onready var music_slider: HSlider = $"Settings Section/MusicSliderBox/HSlider"
@onready var sfx_slider: HSlider = $"Settings Section/SfxSliderBox/HSlider"
@onready var main_slider: HSlider = $"Settings Section/MainSliderBox/HSlider"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_slider.value_changed.connect(on_volume_slider_changed.bind(0))
	main_slider.drag_ended.connect(func(value: float) -> void: VoiceManager.play_random_correct())
	main_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))

	music_slider.value_changed.connect(on_volume_slider_changed.bind(1))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))

	sfx_slider.value_changed.connect(on_volume_slider_changed.bind(2))
	sfx_slider.drag_ended.connect(func(value: float) -> void: VoiceManager.play_random_placement())
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))


func on_volume_slider_changed(value: float, bus_index: int) -> void:
	var volume_db := linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
