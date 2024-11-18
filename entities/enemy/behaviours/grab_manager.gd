extends Node

var rng_x := RandomNumberGenerator.new()
var rng_y := RandomNumberGenerator.new()

@onready var grab: Grab = $"../Grab"
@onready var hold_time: Timer = $"../hold_time"
@onready var ball: Ball = get_tree().get_first_node_in_group('Ball')

# Função para iniciar o "grab"
func grab_ball(ball: Node2D) -> void:
	Logger.info("Iniciando o grab em: " + str(ball.name))
	grab.start(Vector2(0, 0))  # Pode ajustar a direção inicial conforme necessário
	hold_time.start()  # Começa a contagem do tempo de segurar

# Função chamada quando o tempo de segurar acaba
func _on_hold_time_timeout() -> void:
	if not grab.is_holding():
		Logger.info("Nada para arremessar!")
		return

	# Define direção aleatória para arremesso
	var x := rng_x.randf_range(-1, 1)
	var y := rng_y.randf_range(0.9, 1)
	var direction := Vector2(x, y).normalized()

	Logger.info("Tempo de grab acabou, arremessando na direção: " + str(direction))
	grab.start(direction)

# Função chamada quando algo entra na área de grab
func _on_grabable_area_body_entered(body: Node2D) -> void:
	if body is Ball:  # Verifica se o corpo que entrou é do tipo Ball
		Logger.info("Bola detectada: " + str(body.name))
		grab_ball(body)  # Chama a função para pegar a bola
	else:
		Logger.warn("Corpo detectado não é uma bola: " + str(body.name))
