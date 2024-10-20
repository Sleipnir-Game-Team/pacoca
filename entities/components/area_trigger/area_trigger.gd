class_name AreaTrigger
extends ShapeCast2D


var last_direction: Vector2 = Vector2(0,0)
var offset: float = 0

@export var cooldown_seconds: float = 1
@export var distance: int = 15

@onready var cooldown_timer: Timer = %CooldownTimer

## The emmited object is a dictionary containing the following fields:
## [collider_id]: The colliding object's ID.
## [linear_velocity]: The colliding object's velocity Vector2. If the object is an Area2D, the result is (0, 0).
## [normal]: The object's surface normal at the intersection point.
## [point]: The intersection point.
## [rid]: The intersecting object's RID.
## [shape]: The shape index of the colliding shape.
signal hit(direction: Vector2, data: Dictionary)

func _ready() -> void:
	offset = -target_position.x / 2
	
	# Adjust cooldown time according to exported property
	cooldown_timer.wait_time = cooldown_seconds

func trigger(direction: Vector2) -> void:
	last_direction = direction
	
	cooldown_timer.start()
	
	enabled = true
	force_shapecast_update()
	match collision_result:
		[var data]:
			_handler.call(direction, data)
			hit.emit(direction, data)
	enabled = false

func _handler(_direction: Vector2, _data: Dictionary) -> void:
	push_error("MUST OVERRIDE _HANDLER")


func can_trigger() -> bool:
	return cooldown_timer.is_stopped()
