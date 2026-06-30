extends CharacterBody3D

@onready var timer: Timer = $Timer

var speed = 50.0

func _ready():
	timer.start()

func _physics_process(delta):
	global_position += -global_transform.basis.z * speed * delta
	
func _on_timer_timeout() -> void:
	queue_free()
