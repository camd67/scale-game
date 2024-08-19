extends Node3D

@onready var lock_animation_player: AnimationPlayer = $LockAnimationPlayer

var has_been_unlocked := false

const tooltip_text := "Click the scale to unlock it, submitting your guess"

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
		GameEvents.emit_weight_submitted(on_weight_calculated)


func on_lock_mouse_exit() -> void:
	GameEvents.emit_tooltip_done(tooltip_text)


func on_lock_mouse_enter() -> void:
	if has_been_unlocked:
		return

	GameEvents.emit_tooltip_requested(tooltip_text)
	lock_animation_player.play("hover")


func on_weight_calculated() -> void:
	lock_animation_player.play("RESET")
	has_been_unlocked = false


func play_lock_move() -> void:
	SoundManager.play_lock_move()


func play_lock_unlock() -> void:
	SoundManager.play_lock_unlock()


func play_lock_unlock_reverse() -> void:
	SoundManager.play_lock_unlock_reverse()
