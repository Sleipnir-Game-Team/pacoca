extends Area2D

#coloque o Ball_body para a collision layer 2
var Hotness = 0

signal bounce_vector_calculated()


func _ready() -> void:
	area_entered.connect(_on_Area2D_area_entered)
	body_entered.connect(_on_Area2D_Body_entered)

func _process(delta: float) -> void:
	pass
	##for body in get_overlapping_bodies():
		#
		#var position_within_area = to_local(body.position)
		#print("Posição relativa do objeto dentro da área:", position_within_area)
		#
		#var vetor_bounce = position_within_area.normalized()
		#emit_signal("bounce_vector_calculated", vetor_bounce)
	
	
func _on_Area2D_Body_entered(body):
	print("_on_Area2D_Body_entered")
	
	var position_within_area = to_local(body.position)
	print("Posição relativa do objeto dentro da área:", position_within_area)
	
	var vetor_bounce = position_within_area.normalized()
	emit_signal("bounce_vector_calculated", vetor_bounce)
	
	
func _on_Area2D_area_entered(area):
	
	var position_within_area = to_local(area.position)
	print("Posição relativa do objeto dentro da área:", position_within_area)
	
	var vetor_bounce = position_within_area.normalized()
	emit_signal("bounce_vector_calculated", vetor_bounce)
	
	# Verifica se a área que entrou é a "kick"
	if area.name == "kick":
		print("Colidiu com a área 'kick'!")
