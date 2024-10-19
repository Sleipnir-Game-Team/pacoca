class_name ContactArea
extends Area2D

#coloque o Ball_body para a collision layer 2
var Hotness: int = 0

signal bounce_vector_calculated

func _ready() -> void:
	area_entered.connect(_on_Area2D_area_entered)
	body_entered.connect(_on_Area2D_Body_entered)
	
func _on_Area2D_Body_entered(body: Node2D) -> void:
	print("_on_Area2D_Body_entered")
	
	var position_within_area: Vector2 = to_local(body.position)
	print("Posição relativa do objeto dentro da área:", position_within_area)
	
	var vetor_bounce: Vector2 = position_within_area.normalized()
	bounce_vector_calculated.emit(vetor_bounce)

func _on_Area2D_area_entered(area: Area2D) -> void:
	
	var position_within_area: Vector2 = to_local(area.position)
	print("Posição relativa do objeto dentro da área:", position_within_area)
	
	var vetor_bounce: Vector2 = position_within_area.normalized()
	emit_signal("bounce_vector_calculated", vetor_bounce)
	
	# Verifica se a área que entrou é a "kick"
	if area.name == "kick":
		print("Colidiu com a área 'kick'!")
