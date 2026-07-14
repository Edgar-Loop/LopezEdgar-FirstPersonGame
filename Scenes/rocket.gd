extends CharacterBody3D

@onready var timer: Timer = $Timer

var speed = 25.0

func _ready():
	timer.start()
	
func _physics_process(delta):
	global_position += -global_transform.basis.z * speed * delta

func _on_timer_timeout() -> void:
	get_parent().queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	#if body.is_in_group("Env"):
		print(body.name)
		get_parent().queue_free()
