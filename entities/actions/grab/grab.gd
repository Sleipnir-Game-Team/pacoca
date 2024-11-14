class_name Grab
extends AreaTrigger

var held_object: Ball = null

@onready var pointer: Marker2D = $GrabPoint

signal grabbed(grabber: Node)
signal thrown(direction: float)

func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)
	if is_holding():
		held_object.global_position = pointer.global_position

func _handler(direction: Vector2, data: Dictionary) -> void:
	buffering = false
	var ball: Ball = data.collider 
	
	Logger.info("Comando de grap/trow iniciando")
	if held_object != null and (16 < ball.position.x and ball.position.x < 794): # THROWING
		Logger.info("A bola será arremessada")
		held_object = null
		ball._on_throw(rad_to_deg(direction.angle()))
		thrown.emit(rad_to_deg(direction.angle()))
	else: # GRABBING
		Logger.info("A bola será capturada")
		ball._on_grab(get_parent())
		grabbed.emit(get_parent())
		held_object = ball
		cooldown_timer.stop()

func is_holding() -> bool:
	return held_object != null
