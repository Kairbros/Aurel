extends PlayerStateBase

func start():
	if !state_machine.last_state_name in ["Jumping", "Dashing"]:
		player.start_coyote_time()
	player.player_animated_sprite.play("fall")

func on_physics_process(delta: float) -> void:
	super(delta)
	player.moving_to(player.player_speed_force,player.player_speed_force * 25,delta)
	player.handle_rotation()
	player.handle_gravity(delta)
	player.coyote_time(delta)
	player.input_buffer(delta)
	
	if Input.is_action_just_pressed("jump"):
		player.start_input_buffer("Jump")
	
	if player.coyote_timer < player.COYOTE_TIME:
		if Input.is_action_just_pressed("jump"):
			state_machine.change_to("Jumping")
			return
			
	if Input.is_action_just_pressed("dash") and player.dash_available:
		state_machine.change_to("Dashing")
		return
	if player.is_on_floor():
		if player.get_last_input_buffer("Jump") and !Input.is_action_pressed("down"):
			state_machine.change_to("Jumping")
			return
		state_machine.change_to("Idle")
		return

func end():
	player.reset_input_buffer()
	player.reset_coyote_time()
