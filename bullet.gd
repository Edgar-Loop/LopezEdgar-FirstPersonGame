extends CharacterBody3D

var speed = 50.0

func _physics_process(delta):
	global_position += -global_transform.basis.z * speed * delta
