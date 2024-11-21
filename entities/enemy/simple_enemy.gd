extends CharacterBody2D

var rng := RandomNumberGenerator.new()

@onready var hurt_box: Area2D = $HurtBox
@onready var life: Life = $Life
@onready var ball: Ball = get_tree().get_first_node_in_group('Ball')
@onready var sprite: Sprite2D = $Sprite2D

var enemies : Dictionary = {
	"alien_a":{
		"sprite":"res://assets/alien A.png",
		"type":"alien",
		},
	"alien_b":{
		"sprite":"res://assets/alien B.png",
		"type":"alien",
		},
	"alien_c":{	
		"sprite":"res://assets/alien c.png",
		"type":"cat",
		},
	}
var random_enemy : Dictionary

func _ready() -> void:
	# Escolhe uma key aleatória no dicionario
	random_enemy = enemies[enemies.keys().pick_random()]
	# Carrega a textura a partir do caminho
	sprite.texture = load(random_enemy["sprite"])

func _physics_process(_delta: float) -> void:
	$Rotation.rotate(ball.global_position - global_position)

func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body is Ball:
		AudioManager.play_global("enemy."+random_enemy["type"]+".hit")
		life.damage(1)

func _on_death() -> void:
	# NOTE Maybe play a death sound, or a death animation, then run a timer and finally actually die lmao
	AudioManager.play_global("enemy."+random_enemy["type"]+".death")
	queue_free()
	Waves.pop_enemy()

func on_kick(_direction: float) -> void:
	ball.heat.heat_up()
	
