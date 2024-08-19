extends Node3D
class_name Grabber

@export_group("Required Fields")
# Camera for raycast stuff
@export var camera: Camera3D
# How far away we can grab something
# tbh this really should've just been a collider check with the plane everything lives on
@export var max_grab_distance: float
@export var snap_velocity: float
# How far away the mouse needs to be before we deem it "detached"
# Note this is in addition to the "grab item moved since last frame" check
@export var drop_distance: float
# How far away you are before we cap your speed.
# This prevents moving the mouse super fast and
# clipping the grab item through colliders.
@export var max_drag_distance: float

var is_grabbing := false
var grab_item: RigidBody3D = null
var grabbed_item_plane: Plane = Plane.PLANE_YZ
var last_mouse_pos: Vector2 = Vector2.ZERO

var last_grab_item_pos := Vector3.ZERO

@onready var grab_ray: RayCast3D = $GrabRay


func _ready() -> void:
	global_position = camera.global_position


func drop_item() -> void:
	is_grabbing = false
	if grab_item != null:
		var grab_item_closure := grab_item
		get_tree().create_timer(.25).timeout.connect(func() -> void:
			if grab_item_closure != null and not grab_item_closure.is_queued_for_deletion():
				grab_item_closure.can_sleep = true
		)
		grab_ray.clear_exceptions()
		grab_item = null
		last_grab_item_pos = Vector3.ZERO


func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		last_mouse_pos = event.position
		# Move target to where we're pointing at
		grab_ray.target_position = camera.project_ray_normal(event.position) * max_grab_distance
		# This is the same every frame if the camera never moves, but let's be safe
		grab_ray.global_position = camera.project_ray_origin(event.position)

	if event is InputEventMouseButton:
		if event.is_pressed():
			# Signal to the physics process we need to start grabbing something next frame (if possible)
			is_grabbing = true
		elif event.is_released():
			# Stop grabbing anything we may be grabbing
			drop_item()

func _physics_process(delta: float) -> void:
	if is_grabbing and grab_item == null and grab_ray.is_colliding():
		var maybe_grab_item := grab_ray.get_collider() as RigidBody3D
		if maybe_grab_item is Grabbable and\
		 not maybe_grab_item.is_static and\
		 maybe_grab_item.is_player_grabbable:
			# Grab the item and apply "first time grab" properties
			grab_item = maybe_grab_item
			grab_item.can_sleep = false
			grab_ray.add_exception(grab_item)
			grabbed_item_plane = Plane(Vector3.FORWARD, grab_item.global_position)

	if grab_item == null:
		# We couldn't find anything to grab this frame, stop trying to grab
		# Without this we could press our grab button and drag over an object to pick it up
		# rather than clicking on it directly
		drop_item()

	if grab_item != null:
		# Move the grabbed item each frame
		var grab_point := grabbed_item_plane.intersects_ray(\
			camera.project_ray_origin(last_mouse_pos),\
			camera.project_ray_normal(last_mouse_pos)\
		) as Vector3
		# This should never be null... but just in case
		if grab_point != null:
			var direction := grab_item.global_transform.origin.direction_to(grab_point).normalized()
			var distance := grab_item.global_transform.origin.distance_to(grab_point)
			grab_item.linear_velocity = direction * min(distance, max_drag_distance) * 10.0

			if is_zero_approx(grab_item.global_position.distance_squared_to(last_grab_item_pos))\
			 and distance > drop_distance:
				drop_item()
			else:
				last_grab_item_pos = grab_item.global_position
