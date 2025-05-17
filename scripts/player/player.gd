class_name Player extends CharacterBody2D

###########
## Nodes ##
###########

@onready var graphics: Node2D = $Graphics

@onready var sprite_cointainer: Node2D = $Graphics/SpriteCointainer

@onready var player_animated_sprite: AnimatedSprite2D = $Graphics/SpriteCointainer/PlayerAnimatedSprite

@onready var player_collider: CollisionShape2D = $PlayerCollider

@onready var jump_particles: CPUParticles2D = $Graphics/Particles/JumpParticles

@onready var dash_particles: CPUParticles2D = $Graphics/Particles/DashParticles

###############
## Variables ##
###############

@export var player_speed_force : float = 150

@export var player_jump_force : float = 200

@export var player_gravity_force : float = 980

var player_jump_multiplier : float = 1

const PLAYER_JUMP_TIME : float = 0.1

var player_jump_timer : float = PLAYER_JUMP_TIME

const COYOTE_TIME : float = 0.05

var coyote_timer : float = COYOTE_TIME

const INPUT_BUFFER_TIME : float = 0.1

var input_buffer_timer : float = INPUT_BUFFER_TIME

var last_event_input_buffer_action : String = ""

const DASH_DURATION_TIME : float = 0.1

var dash_duration_timer : float = DASH_DURATION_TIME

var dash_direction : Vector2

var dash_available : bool

###############
## Functions ##
###############

func jumping_to():
	velocity.y = -player_jump_force * player_jump_multiplier

func moving_to(speed_potency : float, amount : float, delta : float):
	velocity.x = move_toward(velocity.x, sign(get_input_vector().x) * speed_potency, amount * delta)

func dashing_to():
	velocity = dash_direction * player_speed_force * 2

func handle_gravity(delta : float):
	velocity.y = clamp(velocity.y,-player_gravity_force * 2, player_gravity_force * 0.5)
	if !is_on_floor():
		velocity.y += player_gravity_force * delta

func check_dash_available():
	if is_on_floor() and !dash_available:
		dash_available = true

func handle_rotation():
	if sign(get_input_vector().x):
		if graphics.transform.x.x != sign(get_input_vector().x):
			graphics.transform.x.x = sign(get_input_vector().x)
			squash_tween()

func get_input_vector():
	return Input.get_vector("left","right","up","down")


func freeze_frame(timeScale : float, duration : float):
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration,true,false,true).timeout
	Engine.time_scale = 1.0

func squash_tween():
	var tween = create_tween()
	tween.tween_property(sprite_cointainer,"scale",Vector2(1.1,0.9),0.05)
	tween.tween_property(sprite_cointainer,"scale",Vector2(1,1),0.05)		

#################
## COYOTE TIME ##
#################

func start_coyote_time():
	coyote_timer = 0

func coyote_time(delta : float):
	if coyote_timer < COYOTE_TIME:
		coyote_timer += delta
	else:
		coyote_timer = COYOTE_TIME

func reset_coyote_time():
	if coyote_timer != COYOTE_TIME:
		coyote_timer = COYOTE_TIME

##################
## INPUT BUFFER ##
##################

func input_buffer(delta : float):
	if input_buffer_timer < INPUT_BUFFER_TIME:
		input_buffer_timer += delta
	else:
		reset_input_buffer()

func reset_input_buffer():
	last_event_input_buffer_action = ""
	input_buffer_timer = INPUT_BUFFER_TIME

func start_input_buffer(input : String):
	input_buffer_timer = 0
	last_event_input_buffer_action = input

func get_last_input_buffer(input : String):
	if last_event_input_buffer_action == input:
		return true
	return false
