extends CharacterBody2D

var is_dizzy = false
var invincibility = false

var rng_x = [-1, 1]
var rng_y = RandomNumberGenerator.new()
var grab_count

@onready var life: Life = %life
@onready var ball: Ball = get_tree().get_first_node_in_group('Ball')
@onready var grab: Grab = %Grab
@onready var grab_position = $Grab_position as Marker2D
@onready var hold_time = $hold_time as Timer
@onready var dizzy_time = $dizzy_time as Timer
@onready var boss_sprite = $boss_sprite as Sprite2D
@onready var hurt_animation = $damage_animation as AnimationPlayer

@export var max_grab_count = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grab_count = max_grab_count

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if grab_count == 0:
		is_dizzy = true
	
	if grab.is_holding():
		grab.held_object.global_position = grab_position.global_position

func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body is Ball:
		AudioManager.play_global("boss.crab.hit")
		life.damage(1)

func _on_life_defeat_signal() -> void:
	AudioManager.play_global("boss.crab.death")
	queue_free()
	Waves.pop_enemy()

func grab_ball():
	if grab_count > 0:
		grab.trigger(Vector2(0, 0))
		hold_time.start()

func _on_grabable_area_area_entered(area: Area2D) -> void:
	if !is_dizzy:
		print("boss pegou a bola")
		boss_sprite.texture = load("res://assets/boss A grab.png")
		grab_ball()
	elif !invincibility:
		print("boss levou dano")
		AudioManager.play_global("boss.crab.hit")
		life.damage(1)
		dizzy_time.stop()
		invincibility_frame()

func _on_hold_time_timeout() -> void:
	var x = rng_x.pick_random()
	var y = rng_y.randf_range(0.25, 1)
	
	if grab_count == 3 or grab_count == 2:
		grab.held_object.heat.heat_gain = 5
		grab.held_object.heat.heat_up()
	elif grab_count == 1:
		grab.held_object.set("heat",1)
		
	AudioManager.play_global("boss.crab.attack")
	grab.trigger(Vector2(x, y))
	grab_count -= 1
	sprite_manage()

func _on_dizzy_time_timeout() -> void:
	grab_count = max_grab_count
	sprite_manage()
	is_dizzy = false
	
func invincibility_frame():
	invincibility = true
	hurt_animation.play("hurt_animation")

func sprite_manage():
	if grab_count == 3 or grab_count == 2:
		boss_sprite.texture = load("res://assets/boss A .png")
	elif grab_count == 1:
		boss_sprite.texture = load("res://assets/boss A cansado.png")
	elif grab_count == 0:
		boss_sprite.texture = load("res://assets/boss A broxado.png")


func _on_damage_animation_animation_finished(anim_name: StringName) -> void:
	is_dizzy = false
	invincibility = false
	grab_count = max_grab_count
	sprite_manage()
