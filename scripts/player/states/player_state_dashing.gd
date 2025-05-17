extends PlayerStateBase

func start():
	player.dash_available = false
	player.squash_tween()
	player.player_animated_sprite.play("dash")
	if player.get_input_vector():
		player.dash_direction = player.get_input_vector()
	else:
		player.dash_direction = Vector2(player.graphics.transform.x.x,0)
	
func on_physics_process(delta: float) -> void:
	super(delta)
	if !player.dash_particles.emitting:
		player.dash_particles.emitting = true
	player.dashing_to()
	player.dash_duration_timer -= delta
	if player.dash_duration_timer <= 0:
		state_machine.change_to("Falling" if !player.is_on_floor() else "Idle")
		return

func end():
	if player.dash_particles.emitting:
		player.dash_particles.emitting = false
	player.dash_duration_timer = player.DASH_DURATION_TIME
