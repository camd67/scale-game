extends Node3D

@onready var scale_vfx_animation_player: AnimationPlayer = $ScaleVfxAnimationPlayer
@onready var smoke_vfx_1: GPUParticles3D = $SmokeVfx1
@onready var smoke_vfx_2: GPUParticles3D = $SmokeVfx2
@onready var star_vfx: GPUParticles3D = $StarVfx

var did_play_horn_glow_intro := false

func _ready() -> void:
	VoiceManager.voice_playback_end.connect(on_voice_playback_end)
	VoiceManager.voice_playback_start.connect(on_voice_playback_start)

func on_voice_playback_end() -> void:
	scale_vfx_animation_player.play_backwards("horn_glow_intro")
	smoke_vfx_1.emitting = false
	smoke_vfx_2.emitting = false
	star_vfx.emitting = false

func on_voice_playback_start() -> void:
	scale_vfx_animation_player.play("horn_glow_intro")
	smoke_vfx_1.emitting = true
	smoke_vfx_2.emitting = true
	star_vfx.emitting = true

func on_horn_glow_intro_end() -> void:
	if did_play_horn_glow_intro:
		did_play_horn_glow_intro = false
		return

	scale_vfx_animation_player.play("horn_glow")
	did_play_horn_glow_intro = true
