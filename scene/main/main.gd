extends Node3D

@onready var camera_animation_player: AnimationPlayer = $CameraAnimationPlayer

@onready var out_of_bounds_checker: Area3D = $TableBoundaries/OutOfBoundsChecker
@onready var grabber: Grabber = $Grabber

@onready var table_left_respawn_point: Marker3D = $TableLeftRespawnPoint


func _ready() -> void:
	GameEvents.play_pressed.connect(func() -> void:
		camera_animation_player.play("intro")
	)
	GameEvents.debug_instant_play.connect(func() -> void:
		$MainCamera.global_transform = $InstantDebugCameraMarker.global_transform
		camera_intro_finished()
	)
	out_of_bounds_checker.body_exited.connect(on_oob_checker_exited)


func camera_intro_finished() -> void:
	await get_tree().create_timer(.7).timeout
	GameEvents.emit_camera_intro_finished()


func on_oob_checker_exited(body: Node3D) -> void:
	if body is Grabbable and not body.is_player_grabbable:
		return

	if body is RigidBody3D:
		# Play some audio here?
		# "How'd you do that?"

		# Freeze the body to stop all momentum
		body.freeze = true
		body.global_position = table_left_respawn_point.global_position
		grabber.drop_item()
		await get_tree().physics_frame
		body.freeze = false
	else:
		body.global_position = table_left_respawn_point.global_position
