extends KinematicBody2D

export var max_speed = 300
var velocity = Vector2()
var jumping = false
var jump_speed = 200
var jump_control_time = 500 #ms
var jump_started = 0
var current_drop_zone = null

var max_hp := 100
var hp : int = max_hp setget hp_set
onready var hp_bar : ProgressBar = get_tree().get_current_scene().find_node("PlayerBar")
var friendly := true

var carried_item = null

onready var sprite = find_node("BodySprite")
onready var arm_sprite = find_node("ArmSprite")
onready var weapon_sprite = find_node("WeaponSprite")

var platform_collision_layer = int(pow(2, 2))

func _ready():
	hp_bar.max_value = max_hp
	hp_bar.value = hp

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
	if Input.is_action_pressed("ui_left"):
		velocity.x -= max_speed

	#drop-through platforms
	if Input.is_action_pressed("ui_down"):
		collision_layer &= int(pow(2, 20)) - 1 - platform_collision_layer
		collision_mask &= int(pow(2, 20)) - 1 - platform_collision_layer
	else:
		collision_layer |= platform_collision_layer
		collision_mask |= platform_collision_layer

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

	# animate sprite
	if is_on_floor() and velocity.x != 0:
		sprite.play()
	elif is_on_floor():
		sprite.stop()
		sprite.frame = 0
	else:
		sprite.stop()
		sprite.frame = 1

	# flip if needed
	var mouse_pos = get_viewport().canvas_transform.inverse() * get_viewport().get_mouse_position()
	sprite.flip_h = mouse_pos.x < global_position.x
	arm_sprite.flip_v = mouse_pos.x < global_position.x
	weapon_sprite.flip_v = mouse_pos.x < global_position.x

	# point the gun
	arm_sprite.look_at(mouse_pos)

	# shoot at stuff
	if Input.is_action_pressed("fire"):
		if carried_item != null:
			use_item()
		else:
			weapon_sprite.fire()

func _on_DamageFlash_timeout():
	sprite.modulate = Color(1, 1, 1, 1)

func hp_set(new_hp : int):
	if new_hp > hp:
		sprite.modulate = Color(0, 1, 1, 1)
	else:
		sprite.modulate = Color(1, 0, 0, 1)
	$DamageFlash.start()
	$OwSound.play()
	hp = int(min(new_hp, max_hp))
	hp_bar.value = hp
	if hp <= 0:
		call_deferred("die")

func die():
	get_tree().get_current_scene().find_node("GameOver").activate()

func pick_up(item):
	if carried_item == null:
		carried_item = item
		carried_item.grabbed()
		carried_item.get_parent().remove_child(carried_item)
		arm_sprite.add_child(carried_item)
		carried_item.position = weapon_sprite.position
		weapon_sprite.visible = false

func use_item():
	if carried_item == null:
		return
	if current_drop_zone == null:
		throw_item()
	else:
		deploy_item()

func throw_item():
	if carried_item == null:
		return
	carried_item.position += 30 * Vector2.RIGHT
	var pos = carried_item.global_position
	carried_item.get_parent().remove_child(carried_item)
	get_tree().get_current_scene().find_node("Level").add_child(carried_item)
	carried_item.global_position = pos
	carried_item.linear_velocity = Vector2(0, 0)
	carried_item.thrown()
	item_released()

func item_released():
	carried_item = null
	weapon_sprite.visible = true
	weapon_sprite.dumb_fire()

func set_drop_zone(entered : bool, zone):
	if entered:
		current_drop_zone = zone
	else:
		current_drop_zone = null

func deploy_item():
	if carried_item == null:
		return
	if current_drop_zone.accepts_item(carried_item):
		current_drop_zone.deploy(carried_item)
		item_released()
	else:
		if not $BzztSound.playing:
			$BzztSound.play()
