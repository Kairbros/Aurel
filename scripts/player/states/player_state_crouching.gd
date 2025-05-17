extends PlayerStateBase

func start():
	player.squash_tween()
	player.player_animated_sprite.play("crouch")
	player.player_collider.shape.set("height",12)
	player.player_collider.position.y = -6
	
func on_physics_process(delta: float) -> void:
	super(delta)
	player.moving_to(0,abs(player.velocity.x * 5),delta)
	player.handle_rotation() 
	player.handle_gravity(delta)
	
	for i in player.get_slide_collision_count():
		if (player.get_slide_collision(i).get_collider() as Node2D).is_in_group("platform"):
			if Input.is_action_pressed("jump"):
				player.global_position.y += 3
	
	if player.velocity.y > 0:
		state_machine.change_to("Falling")
		return
	
	if Input.is_action_just_released("down"):
		state_machine.change_to("Idle")
		return

func end():
	player.squash_tween()
	player.player_collider.shape.set("height",16)
	player.player_collider.position.y = -8
