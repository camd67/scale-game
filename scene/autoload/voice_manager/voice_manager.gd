extends AudioStreamPlayer

signal voice_playback_start()
signal voice_playback_end()


@export var voices_correct: Array[AudioStream]
@export var voices_wrong: Array[AudioStream]
@export var voices_random: Array[AudioStream]
@export var voices_time: Array[AudioStream]
@export var voices_start: Array[AudioStream]
@export var voices_fall: Array[AudioStream]
@export var voices_placement: Array[AudioStream]

@onready var voices_correct_trash: Array[AudioStream]
@onready var voices_wrong_trash: Array[AudioStream]
@onready var voices_random_trash: Array[AudioStream]
@onready var voices_time_trash: Array[AudioStream]
@onready var voices_start_trash: Array[AudioStream]
@onready var voices_fall_trash: Array[AudioStream]
@onready var voices_placement_trash: Array[AudioStream]

@onready var timer: Timer = $Timer
@onready var randomVoiceTimer: Timer = $RandomVoiceTimer

var voice_ready: bool = true
const VOICE_BUFFER: int = 2
const RANDOM_BUFFER: int = 20


func _ready() -> void:
	#DirAccess does not work with web
	"""
	voices_correct.append_array(load_streams_at_path("res://audio/voice/correct/"))
	voices_wrong.append_array(load_streams_at_path("res://audio/voice/wrong/"))
	voices_random.append_array(load_streams_at_path("res://audio/voice/random/"))
	voices_time.append_array(load_streams_at_path("res://audio/voice/triggered/time/"))
	voices_start.append_array(load_streams_at_path("res://audio/voice/triggered/start/"))
	voices_fall.append_array(load_streams_at_path("res://audio/voice/triggered/fall/"))
	voices_placement.append_array(load_streams_at_path("res://audio/voice/triggered/placement/"))
	"""

	GameEvents.pan_entered.connect(on_pan_entered)
	GameEvents.pan_exited.connect(on_pan_exited)
	randomVoiceTimer.wait_time = RANDOM_BUFFER
	timer.timeout.connect(on_timeout)
	randomVoiceTimer.timeout.connect(on_random_voice_timer_timeout)
	finished.connect(on_audio_playback_finished)
	voice_playback_start.connect(on_voice_activity)
	GameEvents.correct_weight_submitted.connect(on_correct_weight_submitted)
	GameEvents.incorrect_weight_submitted.connect(on_incorrect_weight_submitted)


func on_audio_playback_finished() -> void:
	voice_playback_end.emit()


func load_streams_at_path(path: String) -> Array[AudioStream]:
	var streams: Array[AudioStream]
	for file in DirAccess.get_files_at(path):
		if file.get_extension() == "mp3":
			file = path + file
			# Uncomment to debug which audio files are loaded
			#print("Loading Audio File: " + file)
			var voice: AudioStream = load(file)
			streams.append(voice)

	return streams

func play_random_correct() -> void:
	if voices_correct.size() > 0:
		var index: int = randi_range(0, voices_correct.size() - 1)
		var chosen_stream: AudioStream = voices_correct.pop_at(index)
		voices_correct_trash.append(chosen_stream)
		stream = chosen_stream
		play()
		voice_playback_start.emit()
		if voices_correct.size() == 0:
			voices_correct.append_array(voices_correct_trash)
			voices_correct_trash.clear()


func play_random_wrong() -> void:
	if voices_wrong.size() > 0:
		var index: int = randi_range(0, voices_wrong.size() - 1)
		var chosen_stream: AudioStream = voices_wrong.pop_at(index)
		voices_wrong_trash.append(chosen_stream)
		stream = chosen_stream
		play()
		voice_playback_start.emit()
		if voices_wrong.size() == 0:
			voices_wrong.append_array(voices_wrong_trash)
			voices_wrong_trash.clear()


func play_random_random() -> void:
	if voices_random.size() > 0:
		var index: int = randi_range(0, voices_random.size() - 1)
		var chosen_stream: AudioStream = voices_random.pop_at(index)
		voices_random_trash.append(chosen_stream)
		stream = chosen_stream
		play()
		voice_playback_start.emit()
		if voices_random.size() == 0:
			voices_random.append_array(voices_random_trash)
			voices_random_trash.clear()


func play_random_time() -> void:
	if voices_time.size() > 0:
		var index: int = randi_range(0, voices_time.size() - 1)
		var chosen_stream: AudioStream = voices_time.pop_at(index)
		voices_time_trash.append(chosen_stream)
		stream = chosen_stream
		play()
		voice_playback_start.emit()
		if voices_time.size() == 0:
			voices_time.append_array(voices_time_trash)
			voices_time_trash.clear()


func play_random_start() -> void:
	if voices_start.size() > 0:
		var index: int = randi_range(0, voices_start.size() - 1)
		var chosen_stream: AudioStream = voices_start.pop_at(index)
		voices_start_trash.append(chosen_stream)
		stream = chosen_stream
		play()
		voice_playback_start.emit()
		if voices_start.size() == 0:
			voices_start.append_array(voices_start_trash)
			voices_start_trash.clear()


func play_random_fall() -> void:
	if voices_fall.size() > 0:
		var index: int = randi_range(0, voices_fall.size() - 1)
		var chosen_stream: AudioStream = voices_fall.pop_at(index)
		voices_fall_trash.append(chosen_stream)
		stream = chosen_stream
		play()
		voice_playback_start.emit()
		if voices_fall.size() == 0:
			voices_fall.append_array(voices_fall_trash)
			voices_fall_trash.clear()


func play_random_placement() -> void:
	if voices_placement.size() > 0:
		var index: int = randi_range(0, voices_placement.size() - 1)
		var chosen_stream: AudioStream = voices_placement.pop_at(index)
		voices_placement_trash.append(chosen_stream)
		stream = chosen_stream
		play()
		voice_playback_start.emit()
		if voices_placement.size() == 0:
			voices_placement.append_array(voices_placement_trash)
			voices_placement_trash.clear()


func on_timeout() -> void:
	voice_ready = true


func voice_cooldown() -> void:
	timer.wait_time = stream.get_length() + VOICE_BUFFER
	timer.start()


func on_pan_entered() -> void:
	if voice_ready:
		voice_ready = false
		play_random_placement()
		voice_cooldown()


func on_pan_exited() -> void:
	if voice_ready:
		voice_ready = false
		play_random_fall()
		voice_cooldown()


func start_random_timer() -> void:
	randomVoiceTimer.start()


func on_random_voice_timer_timeout() -> void:
	if voice_ready:
		play_random_random()
		randomVoiceTimer.start()
		voice_cooldown()


func on_voice_activity() -> void:
		randomVoiceTimer.stop()
		randomVoiceTimer.start()
		

func on_correct_weight_submitted() -> void:
	voice_ready = false
	play_random_correct()
	voice_cooldown()
	


func on_incorrect_weight_submitted() -> void:
	voice_ready = false
	play_random_wrong()
	voice_cooldown()
	
