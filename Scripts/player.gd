extends CharacterBody3D

@onready var head: Node3D = $Head
@onready var standing_collision_shape: CollisionShape3D = $standing_collision_shape
@onready var crouching_collision_shape: CollisionShape3D = $crouching_collision_shape
@onready var ray_cast_3d: RayCast3D = $RayCast3D



var current_speed = 5.0
const walking_speed = 5.0
const sprint_speed = 15.0
const crouch_speed = 3.0
const jump_velocity = 8.5

const mouse_sens = 0.4

var lerp_speed = 10.0
var direction = Vector3.ZERO
var crouching_depth = -0.9


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var bullet = load("res://Scenes/bullet.tscn")
@onready var pos = $Head/Camera3D/Gun/barrel

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))
func _physics_process(delta: float) -> void:

	if Input.is_action_pressed("Quit"):
		get_tree().quit()
	
	if Input.is_action_pressed("Crouch"):
		current_speed = crouch_speed
		head.position.y = lerp(head.position.y, 1.0 + crouching_depth, delta * lerp_speed)
		standing_collision_shape.disabled = true
		crouching_collision_shape.disabled = false
	elif !ray_cast_3d.is_colliding():
		standing_collision_shape.disabled = false
		crouching_collision_shape.disabled = true
		head.position.y = lerp(head.position.y, 1.0, delta * lerp_speed)
		if Input.is_action_pressed("Sprint"):
			current_speed = sprint_speed
		else:
			current_speed = walking_speed
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backwards")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_speed)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	if Input.is_action_just_pressed("Shoot"):
		var instance = bullet.instantiate()
		instance.global_transform = pos.global_transform
		get_parent().add_child(instance)

		print("Bullet spawned at: ", instance.global_position)
	move_and_slide()
