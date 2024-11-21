extends CharacterBody2D

var is_dizzy := false

var rng_x := RandomNumberGenerator.new()
var rng_y := RandomNumberGenerator.new()
var grab_count : int

@onready var life: Life = $life
@onready var ball: Ball = get_tree().get_first_node_in_group('Ball')
@onready var grab: Grab = $Grab
@onready var hold_time: Timer = $hold_time 
@onready var boss_sprite: Sprite2D = $boss_sprite 
@onready var hurt_animation: AnimationPlayer = $damage_animation 

@export var max_grab_count := 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grab_count = max_grab_count
	life.damage_received.connect(on_damage)

func on_damage(_damage: int) -> void:
	hurt_animation.play("hurt_animation")
	Logger.info("Boss levou dano, vida atual: "+str(life.entity_life))
	AudioManager.play_global("boss.crab.hit")

func _on_death() -> void:
	AudioManager.play_global("boss.crab.death")
	queue_free()
	Waves.pop_enemy()

func grab_ball() -> void:
	if grab_count > 0:
		grab.start(Vector2(0, 0))
		hold_time.start()

func _on_grabable_area_area_entered(_area: Area2D) -> void:
	if !is_dizzy:
		boss_sprite.texture = load("res://assets/boss A grab.png")
		grab_ball()
		Logger.info("Boss pegou a bola")
	else:
		life.damage(1)

func _on_hold_time_timeout() -> void:
	var x := rng_x.randf_range(-1,1)
	var y := rng_y.randf_range(0.9, 1)
	Logger.info("Tempo de grab acabou, o boss vai arremessar")
	
	if grab_count == 3 or grab_count == 2:
		grab.held_object.heat.heat_up(5)
	elif grab_count == 1:
		grab.held_object.heat.heat = 0
	AudioManager.play_global("boss.crab.attack")
	grab.start(Vector2(x, y))
	
	grab_count -= 1
	
	if grab_count == 0:
		is_dizzy = true
	sprite_manage()

func sprite_manage() -> void:
	if grab_count == 3 or grab_count == 2:
		boss_sprite.texture = load("res://assets/boss A .png")
	elif grab_count == 1:
		boss_sprite.texture = load("res://assets/boss A cansado.png")
	elif grab_count == 0:
		boss_sprite.texture = load("res://assets/boss A broxado.png")


func _on_damage_animation_animation_finished(_anim_name: StringName) -> void:
	is_dizzy = false
	grab_count = max_grab_count
	sprite_manage()
