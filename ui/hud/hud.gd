extends Control

@onready var wave_label := get_node("%wave")
@onready var health_bar := get_node("%health_bar")


func _ready() -> void:
	get_tree().get_first_node_in_group("Player").life.damage_received.connect(on_damage_taken)
	get_tree().get_first_node_in_group("Player").life.healing_received.connect(on_life_healed)
	Waves.changed_wave.connect(change_wave_counter)
	
func on_damage_taken(life_point: int) -> void:
	health_bar.value -= life_point

func on_life_healed(life_point: int) -> void:
	health_bar.value += life_point
	
func change_wave_counter() -> void:
	var current_wave := int(wave_label.text) + 1
	if current_wave == 5:
		wave_label.text = "BOSS"
	else:
		wave_label.text = str(current_wave)
