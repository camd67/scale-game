extends AudioStreamPlayer

enum SFX {
	DOOR_OPEN = 0,
	LOCK_MOVE = 1,
	LOCK_UNLOCK = 2,
	LOCK_UNLOCK_REVERSE = 3,
	PORTAL_NOISE = 4,
	PORTAL_BLOOP = 5,
	DISTANT_BOOMS = 6,
	LOW_GROWL = 7,
	TEDDY = 8,
	EERIE_GHOST = 9,
	RATTLE = 10,
	HELP_ME = 11
}

const MIN_NOISE_BUFFER = 15
const NOISE_RANGE = 15

@export var sfx_list: Array[AudioStream]
@onready var timer: Timer = $PlayOpenTimer
@onready var random_noise_player: AudioStreamPlayer = $RandomNoisePlayer
@onready var random_noise_timer: Timer = $RandomNoisePlayer/RandomNoiseTimer
@onready var fire_crackle_player: AudioStreamPlayer = $FireCracklePlayer
@onready var portal_player: AudioStreamPlayer = $PortalPlayer


func _ready() -> void:
	GameEvents.play_pressed.connect(on_play_pressed)
	timer.timeout.connect(on_play_open_timeout)
	random_noise_timer.timeout.connect(on_random_noise_timeout)
	random_noise_timer.wait_time = MIN_NOISE_BUFFER + randi_range(0,NOISE_RANGE)
	random_noise_timer.start()
	fire_crackle_player.finished.connect(on_fire_crackle_finished)
	portal_player.stream = sfx_list[SFX.PORTAL_NOISE]

func on_play_pressed() -> void:
	stream = sfx_list[SFX.DOOR_OPEN]
	play()
	timer.wait_time = stream.get_length() + 1
	timer.start()

func on_play_open_timeout() -> void:
	VoiceManager.play_random_start()
	VoiceManager.start_random_timer()


func on_random_noise_timeout() -> void:
	var sfx_choice: int = randi_range(SFX.DISTANT_BOOMS,SFX.keys().size() - 1)
	var timer_wait: float = MIN_NOISE_BUFFER
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


func play_lock_unlock_reverse() -> void:
	stream = sfx_list[SFX.LOCK_UNLOCK_REVERSE]
	play()


func on_fire_crackle_finished() -> void:
	fire_crackle_player.play()


func play_portal_noise() -> void:
	portal_player.play()


func stop_portal_noise() -> void:
	portal_player.stop()


func play_portal_bloop() -> void:
	stream = sfx_list[SFX.PORTAL_BLOOP]
	play()
