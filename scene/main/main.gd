extends Node3D

@onready var camera_animation_player: AnimationPlayer = $CameraAnimationPlayer


func _ready() -> void:
	$MainMenu.play_pressed.connect(func() -> void:
		camera_animation_player.play("intro")
	)
	$MainMenu.debug_instant_play.connect(func() -> void:
		$MainCamera.global_transform = $InstantDebugCameraMarker.global_transform
	)
