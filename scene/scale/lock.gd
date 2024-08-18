extends Node3D

@onready var lock_animation_player: AnimationPlayer = $LockAnimationPlayer

var has_been_unlocked := false

func _ready() -> void:
	$LockArea.input_event.connect(on_lock_input_event)
	$LockArea.mouse_entered.connect(on_lock_mouse_enter)
	$LockArea.mouse_exited.connect(on_lock_mouse_exit)


func on_lock_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if has_been_unlocked:
		return

	if event is InputEventMouseButton and event.is_pressed():
		lock_animation_player.play("unlock")
		has_been_unlocked = true


func on_lock_mouse_exit() -> void:
	pass


func on_lock_mouse_enter() -> void:
	if has_been_unlocked:
		return

	lock_animation_player.play("hover")


func play_lock_move() -> void:
	SoundManager.play_lock_move()
	
	
func play_lock_unlock() -> void:
	SoundManager.play_lock_unlock()
