extends PlayerStateBase

func start():
	player.jump_particles.emitting = true
	player.check_dash_available()
	player.squash_tween()
	player.jumping_to()
	player.player_animated_sprite.play("fall")

func on_physics_process(delta: float) -> void:
	super(delta)
	player.moving_to(player.player_speed_force,player.player_speed_force * 25,delta)
	player.handle_rotation()
	player.handle_gravity(delta)

	if Input.is_action_pressed("jump") and player.player_jump_timer > 0:
		player.player_jump_timer -= delta
		player.player_jump_multiplier += 2.5  * delta
		player.jumping_to()
	else:
		player.player_jump_timer = 0
	
	if player.velocity.y > 0:
		state_machine.change_to("Falling")
		return
	
	if Input.is_action_just_pressed("dash") and player.dash_available:
		state_machine.change_to("Dashing")
		return

func end():
	player.player_jump_multiplier = 1
	player.player_jump_timer = player.PLAYER_JUMP_TIME
