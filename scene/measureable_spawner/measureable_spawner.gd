extends Node3D
class_name Spawner

@onready var portal_spawn_animation_player: AnimationPlayer = $PortalSpawnAnimationPlayer
@onready var portal_particles: GPUParticles3D = $PortalParticles

@export var level_definition: LevelDefinition
@export var left_spawn_location: Node3D
@export var right_spawn_location: Node3D

@export var left_spawn_spread: float

const right_spawn_offset := 0.075

static var grabbable_scene: PackedScene = preload("res://scene/grabbable/grabbable.tscn")
static var weighable_scene: PackedScene = preload("res://scene/weighable/weighable.tscn")


func _ready() -> void:
	portal_particles.visible = false


func _process(delta: float) -> void:
	if OS.has_feature("editor"):
		if Input.is_action_just_pressed("spawn(debug)"):
			spawn()


func begin_level() -> void:
	GameEvents.emit_level_started()
	await get_tree().create_timer(1).timeout
	spawn()


func spawn() -> void:
	portal_particles.visible = true
	var left_side_objects := level_definition.left_side
	var right_side_objects := level_definition.right_side

	var spawning_portal := $SummoningPortalLiving as Node3D
	# Right side spawning
	spawning_portal.scale = Vector3.ZERO
	spawning_portal.global_position = right_spawn_location.global_position + (Vector3.UP * .1)
	portal_particles.global_position = spawning_portal.global_position
	portal_spawn_animation_player.play("spawn_in")
	await portal_spawn_animation_player.animation_finished

	var i := 1
	for object in right_side_objects:
		#spawn_measurable_at_location(object, right_spawn_location.global_position)
		spawn_measurable_at_right_location(object, i)
		i += 1

	portal_particles.emitting = false
	await get_tree().create_timer(.25).timeout
	portal_spawn_animation_player.play_backwards("spawn_in")
	await portal_spawn_animation_player.animation_finished
	spawning_portal.scale = Vector3.ZERO
	await get_tree().create_timer(.5).timeout

	# Left side spawning
	spawning_portal.global_position = left_spawn_location.global_position + (Vector3.UP * .1)
	portal_particles.global_position = spawning_portal.global_position
	portal_particles.emitting = true
	portal_spawn_animation_player.play("spawn_in")
	await portal_spawn_animation_player.animation_finished

	for object in left_side_objects:
		spawn_measurable_at_left_location(object)
		await get_tree().create_timer(.25).timeout

	portal_particles.emitting = false
	portal_spawn_animation_player.play_backwards("spawn_in")
	await portal_spawn_animation_player.animation_finished
	portal_particles.visible = false


func spawn_measurable_at_right_location(measureable: Measureable, order: int) -> void:
	var grabbable := create_grabbable_for_measureable(measureable, false)
	var spawn_deviation := get_right_side_spawn_deviation(order)
	var spawn_location := right_spawn_location.global_position + Vector3.RIGHT * spawn_deviation
	spawn_grabbable_at_location(grabbable, spawn_location)


func get_right_side_spawn_deviation(order: int) -> float:
	if level_definition.right_side.size() == 1:
		return 0

	if order == 1:
		return -right_spawn_offset
	return right_spawn_offset


func spawn_measurable_at_left_location(measureable: Measureable) -> void:
	var grabbable := create_grabbable_for_measureable(measureable, true)
	var spawn_location := left_spawn_location.global_position + (Vector3.RIGHT * randf_range(-left_spawn_spread, left_spawn_spread))
	spawn_grabbable_at_location(grabbable, spawn_location)


func spawn_grabbable_at_location(grabbable: Grabbable, location: Vector3) -> void:
	get_tree().root.add_child(grabbable)
	grabbable.global_position = location


func create_grabbable_for_measureable(measureable: Measureable, player_grabbale: bool) -> Grabbable:
	var grabbable : Grabbable = grabbable_scene.instantiate() as Grabbable
	grabbable.is_player_grabbable = player_grabbale
	add_collision_shape_child(grabbable, measureable.shape)
	add_mesh_child(grabbable, measureable.mesh)
	add_weighable_child(grabbable, measureable.weight)
	return grabbable


func add_collision_shape_child(parent: Node, shape: Shape3D) -> void:
	var collision_shape_3d := CollisionShape3D.new()
	collision_shape_3d.shape = shape
	parent.add_child(collision_shape_3d)


func add_mesh_child(parent: Node, mesh: Mesh) -> void:
	var mesh_instance_3d := MeshInstance3D.new()
	mesh_instance_3d.mesh = mesh
	parent.add_child(mesh_instance_3d)


func add_weighable_child(parent: Grabbable, weight: int) -> void:
	var weighable_instance := weighable_scene.instantiate() as Weighable
	weighable_instance.weight = weight
	parent.weighable = weighable_instance
	parent.add_child(weighable_instance)
