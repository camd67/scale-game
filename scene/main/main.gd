extends Node3D

@onready var camera_animation_player: AnimationPlayer = $CameraAnimationPlayer

@onready var out_of_bounds_checker: Area3D = $TableBoundaries/OutOfBoundsChecker
@onready var grabber: Grabber = $Grabber

@onready var table_left_spawn_point: Marker3D = $TableLeftSpawnPoint


func _ready() -> void:
	GameEvents.play_pressed.connect(func() -> void:
		camera_animation_player.play("intro")
	)
	GameEvents.debug_instant_play.connect(func() -> void:
		$MainCamera.global_transform = $InstantDebugCameraMarker.global_transform
	)
	out_of_bounds_checker.body_exited.connect(on_oob_checker_exited)


func on_oob_checker_exited(body: Node3D) -> void:
	if body is RigidBody3D:
		# Play some audio here?
		# "How'd you do that?"

		# Freeze the body to stop all momentum
		body.freeze = true
		body.global_position = table_left_spawn_point.global_position
		grabber.drop_item()
		await get_tree().physics_frame
		body.freeze = false
	else:
		body.global_position = table_left_spawn_point.global_position
