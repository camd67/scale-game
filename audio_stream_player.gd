extends AudioStreamPlayer


@onready var voices_correct: Array[AudioStream]
@onready var voices_wrong: Array[AudioStream]
@onready var voices_random: Array[AudioStream]
@onready var voices_time: Array[AudioStream]
@onready var voices_start: Array[AudioStream]
@onready var voices_fall: Array[AudioStream]
@onready var voices_placement: Array[AudioStream]

@onready var voices_correct_trash: Array[AudioStream]
@onready var voices_wrong_trash: Array[AudioStream]
@onready var voices_random_trash: Array[AudioStream]
@onready var voices_time_trash: Array[AudioStream]
@onready var voices_start_trash: Array[AudioStream]
@onready var voices_fall_trash: Array[AudioStream]
@onready var voices_placement_trash: Array[AudioStream]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	voices_correct.append_array(load_streams_at_path("res://audio/voice/correct/"))
	voices_wrong.append_array(load_streams_at_path("res://audio/voice/wrong/"))
	voices_random.append_array(load_streams_at_path("res://audio/voice/random/"))
	voices_time.append_array(load_streams_at_path("res://audio/voice/triggered/time/"))
	voices_start.append_array(load_streams_at_path("res://audio/voice/triggered/start/"))
	voices_fall.append_array(load_streams_at_path("res://audio/voice/triggered/fall/"))
	voices_placement.append_array(load_streams_at_path("res://audio/voice/triggered/placement/"))


func load_streams_at_path(path: String) -> Array[AudioStream]:
	var streams: Array[AudioStream]
	for file in DirAccess.get_files_at(path):
		if file.get_extension() == "mp3":
			file = path + file
			print("Loading Audio File: " + file)
			var voice: AudioStream = load(file)
			streams.append(voice)
	
	return streams
	
func play_random_correct() -> void:
	var index: int = randi_range(0, voices_correct.size() - 1)
	var chosen_stream: AudioStream = voices_correct.pop_at(index)
	voices_correct_trash.append(chosen_stream)
	stream = chosen_stream
	play()
	if voices_correct.size() == 0:
		voices_correct.append_array(voices_correct_trash)
		voices_correct_trash.clear()


func play_random_wrong() -> void:
	var index: int = randi_range(0, voices_wrong.size() - 1)
	var chosen_stream: AudioStream = voices_wrong.pop_at(index)
	voices_wrong_trash.append(chosen_stream)
	stream = chosen_stream
	play()
	if voices_wrong.size() == 0:
		voices_wrong.append_array(voices_wrong_trash)
		voices_wrong_trash.clear()


func play_random_random() -> void:
	var index: int = randi_range(0, voices_random.size() - 1)
	var chosen_stream: AudioStream = voices_random.pop_at(index)
	voices_random_trash.append(chosen_stream)
	stream = chosen_stream
	play()
	if voices_random.size() == 0:
		voices_random.append_array(voices_random_trash)
		voices_random_trash.clear()


func play_random_time() -> void:
	var index: int = randi_range(0, voices_time.size() - 1)
	var chosen_stream: AudioStream = voices_time.pop_at(index)
	voices_time_trash.append(chosen_stream)
	stream = chosen_stream
	play()
	if voices_time.size() == 0:
		voices_time.append_array(voices_time_trash)
		voices_time_trash.clear()


func play_random_start() -> void:
	var index: int = randi_range(0, voices_start.size() - 1)
	var chosen_stream: AudioStream = voices_start.pop_at(index)
	voices_start_trash.append(chosen_stream)
	stream = chosen_stream
	play()
	if voices_start.size() == 0:
		voices_start.append_array(voices_start_trash)
		voices_start_trash.clear()


func play_random_fall() -> void:
	var index: int = randi_range(0, voices_fall.size() - 1)
	var chosen_stream: AudioStream = voices_fall.pop_at(index)
	voices_fall_trash.append(chosen_stream)
	stream = chosen_stream
	play()
	if voices_fall.size() == 0:
		voices_fall.append_array(voices_fall_trash)
		voices_fall_trash.clear()


func play_random_placement() -> void:
	var index: int = randi_range(0, voices_placement.size() - 1)
	var chosen_stream: AudioStream = voices_placement.pop_at(index)
	voices_placement_trash.append(chosen_stream)
	stream = chosen_stream
	play()
	if voices_placement.size() == 0:
		voices_placement.append_array(voices_placement_trash)
		voices_placement_trash.clear()
