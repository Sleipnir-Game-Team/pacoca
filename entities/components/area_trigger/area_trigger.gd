class_name AreaTrigger
extends ShapeCast2D
## Um [b]AreaTrigger[/b] é um componente utilizado para detectar objetos (por padrão, nós do tipo `PhysicsBody2D`)
## e realizar alguma ação que tenha efeito sobre os objetos detectados.
## Esse componente é a base para os componentes de [Grab] e [Kick] utilizados tanto pelo jogador quanto pelos inimigos.
##
## O nó raiz do [b]AreaTrigger[/b] é um [ShapeCast2D]:
## - "Uma forma 2D que varre uma região do espaço para detectar objetos."
## - Como raycasts, para formas além de linhas retas.
## - Permite detectar objetos instantaneamente em qualquer frame (Ao contrário do nó [Area2D] que é mais limitado).
##
## O código presente no script [code]area_trigger.gd[/code] é responsável por:
## - Um método [method AreaTrigger.start] que inicia a detecção e ação associada.
##
## - Emitir um sinal [signal AreaTrigger.hit] quando encontra um objeto
##   O sinal carrega consigo informações do objeto detectado e da direção em que o trigger foi usado.
##
## - Buffering, que permite detectar objetos por um período em segundos (ao invés de em um único frame) 
##   O período de buffering pode ser controlado utilizando [member AreaTrigger.buffering_duration_seconds].
##
## - Cooldown, que permite definir um tempo minimo entre chamadas de [method AreaTrigger.start]
##   O tempo de cooldown pode ser controlado utilizando [member AreaTrigger.cooldown_seconds].

var current_direction: Vector2

@export var cooldown_seconds: float = 1

@onready var cooldown_timer: Timer = %CooldownTimer

@export var buffering_duration_seconds: float = 0.1
var buffering: bool = false
var buffering_duration: float = 0.0

var available: bool = true

## The emmited object is a dictionary containing the following fields:
## [collider_id]: The colliding object's ID.
## [linear_velocity]: The colliding object's velocity Vector2. If the object is an Area2D, the result is (0, 0).
## [normal]: The object's surface normal at the intersection point.
## [point]: The intersection point.
## [rid]: The intersecting object's RID.
## [shape]: The shape index of the colliding shape.
signal hit(direction: Vector2, data: Dictionary)

signal started
signal failed

func _ready() -> void:
	# Adjust cooldown time according to exported property
	cooldown_timer.wait_time = cooldown_seconds

func trigger() -> void:
	cooldown_timer.start()
	
	enabled = true
	force_shapecast_update()
	match collision_result:
		[var data]:
			reset_buffering()
			_handler(current_direction, data)
			hit.emit(current_direction, data)
	enabled = false

func _physics_process(delta: float) -> void:
	if not buffering: return;
	
	if buffering_duration < buffering_duration_seconds:
		buffering_duration += delta
		trigger()
	else:
		failed.emit()
		reset_buffering()

func reset_buffering() -> void:
	buffering = false
	buffering_duration = 0

func start(direction: Vector2) -> void:
	if available and can_trigger():
		started.emit()
		current_direction = direction
		buffering = true
	else:
		Logger.debug("O trigger tentou ser iniciado com available %s e can_trigger() %s " % [available, can_trigger()])

func _handler(_direction: Vector2, _data: Dictionary) -> void:
	push_error("MUST OVERRIDE _HANDLER")

func can_trigger() -> bool:
	return cooldown_timer.is_stopped()
