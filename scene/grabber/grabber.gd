extends Node3D

@export_group("Required Fields")
@export var camera: Camera3D
@export var max_grab_distance: float

var is_grabbing := false
var grab_item: RigidBody3D = null
var grabbed_item_plane: Plane = Plane.PLANE_YZ
var last_mouse_pos: Vector2 = Vector2.ZERO

@onready var grab_ray: RayCast3D = $GrabRay


func _ready() -> void:
	global_position = camera.global_position


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
			is_grabbing = false
			if grab_item != null:
				grab_item.freeze = false
				grab_ray.clear_exceptions()
				grab_item = null

func _physics_process(delta: float) -> void:
	if is_grabbing and grab_item == null and grab_ray.is_colliding():
		var maybe_grab_item := grab_ray.get_collider() as RigidBody3D
		if maybe_grab_item is Grabbable and not maybe_grab_item.is_static:
			# Grab the item and apply "first time grab" properties
			grab_item = maybe_grab_item
			grab_ray.add_exception(grab_item)
			grabbed_item_plane = Plane(Vector3.FORWARD, grab_item.global_position)
			grab_item.freeze = true

	if grab_item == null:
		# We couldn't find anything to grab this frame, stop trying to grab
		# Without this we could press our grab button and drag over an object to pick it up
		# rather than clicking on it directly
		is_grabbing = false

	if grab_item != null:
		# Move the grabbed item each frame
		var grab_point := grabbed_item_plane.intersects_ray(\
			camera.project_ray_origin(last_mouse_pos),\
			camera.project_ray_normal(last_mouse_pos)\
		) as Vector3
		# This should never be null... but just in case
		if grab_point != null:
			# This causes some visual issues where you can clip through other
			# static physics objects, or push rigidbodies into static ones and
			# cause glitchy behavior
			grab_item.global_position = grab_point
