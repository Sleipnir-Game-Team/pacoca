extends Area2D

var moviment
var power_type
var power_instance

@export var direction: int
@export var speed: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	position.y += speed*direction


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print(power_type)
		power_instance = load(power_type)
		var power = power_instance.instantiate()
		body.call_deferred("add_child", power)
		queue_free()
