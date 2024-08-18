extends AudioStreamPlayer

enum SFX {
	DOOR_OPEN = 0
}

@export var sfx_list: Array[AudioStream]
@onready var timer: Timer = $PlayOpenTimer


func _ready() -> void:
	GameEvents.play_pressed.connect(on_play_pressed)
	timer.timeout.connect(on_play_open_timeout)
	
	
func on_play_pressed() -> void:
	stream = sfx_list[SFX.DOOR_OPEN]
	play()
	timer.wait_time = stream.get_length() + 1
	timer.start()
	
func on_play_open_timeout() -> void:
	VoiceManager.play_random_start()
	VoiceManager.start_random_timer()
	
