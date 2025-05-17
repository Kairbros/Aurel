extends PlayerStateBase

func start():
	player.player_animated_sprite.play("idle")

func on_physics_process(delta: float) -> void:
	super(delta)
	player.moving_to(0,abs(player.velocity.x * 10),delta)
	player.handle_gravity(delta)
	player.check_dash_available()
	
	if sign(player.get_input_vector().x):
		state_machine.change_to("Walking")
		return
		
	if Input.is_action_just_pressed("jump"):
		state_machine.change_to("Jumping")
		return
		
	if player.velocity.y > 0:
		state_machine.change_to("Falling")
		return
	
	if Input.is_action_pressed("down"):
		state_machine.change_to("Crouching")
		return
	
	if Input.is_action_just_pressed("dash") and player.dash_available:
		state_machine.change_to("Dashing")
		return
