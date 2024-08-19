extends AudioStreamPlayer

enum SFX {
	DOOR_OPEN = 0,
	LOCK_MOVE = 1,
	LOCK_UNLOCK = 2,
	LOCK_FALL = 3,
	DISTANT_BOOMS = 4,
	LOW_GROWL = 5,
	TEDDY = 6,
	EERIE_GHOST = 7,
	RATTLE = 8
}

const MIN_NOISE_BUFFER = 15
const NOISE_RANGE = 15

@export var sfx_list: Array[AudioStream]
@onready var timer: Timer = $PlayOpenTimer
@onready var random_noise_player: AudioStreamPlayer = $RandomNoisePlayer
@onready var random_noise_timer: Timer = $RandomNoisePlayer/RandomNoiseTimer


func _ready() -> void:
	GameEvents.play_pressed.connect(on_play_pressed)
	timer.timeout.connect(on_play_open_timeout)
	random_noise_timer.timeout.connect(on_random_noise_timeout)
	random_noise_timer.wait_time = MIN_NOISE_BUFFER + randi_range(0,NOISE_RANGE)
	random_noise_timer.start()

func on_play_pressed() -> void:
	stream = sfx_list[SFX.DOOR_OPEN]
	play()
	timer.wait_time = stream.get_length() + 1
	timer.start()

func on_play_open_timeout() -> void:
	VoiceManager.play_random_start()
	VoiceManager.start_random_timer()


func on_random_noise_timeout() -> void:
	var sfx_choice: int = randi_range(4,SFX.keys().size())
	var timer_wait: int = MIN_NOISE_BUFFER
	random_noise_player.stream = sfx_list[sfx_choice]
	random_noise_player.play()
	timer_wait += random_noise_player.stream.get_length() + randi_range(0,NOISE_RANGE)
	random_noise_timer.wait_time = timer_wait
	random_noise_timer.start()


func play_lock_move() -> void:
	stream = sfx_list[SFX.LOCK_MOVE]
	play()

func play_lock_unlock() -> void:
	stream = sfx_list[SFX.LOCK_UNLOCK]
	play()

func play_lock_fall() -> void:
	stream = sfx_list[SFX.LOCK_FALL]
	play()
