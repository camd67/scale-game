extends Node2DS


@onready var timer: Timer = $Timer
@onready var voice_manager: AudioStreamPlayer = $VoiceManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(on_timeout)
	timer.start()


func on_timeout() -> void:
	var voice_type: int = randi_range(1,7)
	if voice_type == 1:
		voice_manager.play_random_correct()
	if voice_type == 2:
		voice_manager.play_random_wrong()
	if voice_type == 3:
		voice_manager.play_random_random()
	if voice_type == 4:
		voice_manager.play_random_time()
	if voice_type == 5:
		voice_manager.play_random_start()
	if voice_type == 6:
		voice_manager.play_random_fall()
	if voice_type == 7:
		voice_manager.play_random_placement()

	var seconds: int = voice_manager.stream.get_length()
	timer.wait_time = seconds + 1
	timer.start()
