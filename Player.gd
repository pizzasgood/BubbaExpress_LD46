extends KinematicBody2D

export var max_speed = 300
var velocity = Vector2()
var jumping = false
var jump_speed = 200
var jump_control_time = 500 #ms
var jump_started = 0
var last_state = "null"
var current_state = "null"

var hp = 100 setget hp_set

onready var sprite = find_node("Sprite")

func _ready():
	pass

func _process(delta):
	if current_state != last_state:
		print(current_state)
		last_state = current_state

func _physics_process(delta):
	_handle_input()

	if jumping:
		move_and_slide(velocity, Vector2.UP)
		if is_on_ceiling():
			jumping = false
	else:
		if is_on_floor():
			velocity.y = 0
		else:
			velocity.y += 9.81
		move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)


func _handle_input():
	#left and right
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += max_speed
		sprite.flip_h = false
	if Input.is_action_pressed("ui_left"):
		velocity.x -= max_speed
		sprite.flip_h = true

	#jump
	if Input.is_action_pressed("jump"):
		if is_on_floor():
			jumping = true
			jump_started = OS.get_ticks_msec()
		if OS.get_ticks_msec() < jump_started + jump_control_time:
			velocity.y = -jump_speed
		else:
			jumping = false
	else:
		jumping = false

func _on_DamageFlash_timeout():
	sprite.modulate = Color(1, 1, 1, 1)

func hp_set(new_hp):
	if new_hp > hp:
		sprite.modulate = Color(0, 1, 0.25, 1)
	else:
		sprite.modulate = Color(1, 0, 0, 1)
	$DamageFlash.start()
	hp = new_hp
	if hp <= 0:
		call_deferred("die")

func die():
	get_tree().get_current_scene().find_node("GameOver").activate()
