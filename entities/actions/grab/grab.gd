class_name Grab
extends AreaTrigger
## Um [b]Grab[/b] extende o [AreaTrigger] e adiciona a lógica necessária para agarrar e arremessar a bola.
##
## O método [method Grab._handler] segue dois fluxos:
## - Caso [member Grab.held_object] seja nulo - Arremesar a bola com [method Ball._on_throw];
## - Caso contrário - Agarrar a bola com [method Ball._on_grab] e [signal Grab.grabbed].
## Os métodos de [Ball] afetam a lógica de rotação da bola (i.e. não rodar enquanto agarrada)
## Já os sinais permitem que  o nó que realizou o Grab faça quaisquer tratamentos (e.g. a animação de mordida no [Player])
##
## [method Node._physics_process] é sobreescrito para manter a posição da bola no [Marker] [b]GrabPoint[\b].

var held_object: Ball = null

@onready var pointer: Marker2D = $GrabPoint

signal grabbed(grabber: Node)
signal thrown(direction: float)

func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)
	if is_holding():
		held_object.global_position = pointer.global_position

func _handler(direction: Vector2, data: Dictionary) -> void:
	var ball: Ball = data.collider 
	
	Logger.info("Comando de grab/throw iniciando")
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
