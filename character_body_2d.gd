extends CharacterBody2D


const SPEED = 1000
const JUMP_VELOCITY = 400.0
const speed_jump_multiplier_y = -0.0005
const speed_jump_multiplier_x = -0.0005


func _physics_process(delta: float) -> void:
	
	#death
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var tilemap = collision.get_collider() as TileMapLayer
		var hit_position = collision.get_position() - collision.get_normal() * 2.0
		var tile_position = tilemap.local_to_map(tilemap.to_local(hit_position))
		
		var tile_data = tilemap.get_cell_tile_data(tile_position)

		if tile_data != null:
			if tile_data.get_custom_data("death"):
				get_tree().call_deferred("reload_current_scene")

	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	# Handle jump.
	if Input.is_action_pressed("ui_accept") and (is_on_floor() or $RightWallRay1.is_colliding() or $RightWallRay2.is_colliding() or $RightWallRay3.is_colliding() or $LeftWallRay1.is_colliding() or $LeftWallRay2.is_colliding() or $LeftWallRay3.is_colliding()):
		
		var normal : Vector2 = Vector2(0,0)
		
		if is_on_floor():
			normal += get_floor_normal()
			
		if $RightWallRay1.is_colliding():
			normal += ($RightWallRay1.get_collision_normal())
		elif $RightWallRay2.is_colliding():
			normal += ($RightWallRay2.get_collision_normal())
		elif $RightWallRay3.is_colliding():
			normal += ($RightWallRay3.get_collision_normal())
			
		if $LeftWallRay1.is_colliding():
			normal += ($LeftWallRay1.get_collision_normal())
		elif $LeftWallRay2.is_colliding():
			normal += ($LeftWallRay2.get_collision_normal())
		elif $LeftWallRay3.is_colliding():
			normal += ($LeftWallRay3.get_collision_normal())
			
			
		
		if Input.is_action_pressed("ui_up"):
			velocity.y=0
			normal.y += -1.5
		normal = normal.normalized()
		
		normal.y += velocity.length()*speed_jump_multiplier_y
		normal.x += velocity.length()*speed_jump_multiplier_x
		
		velocity += normal *JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and (velocity.length() <= 500):
		velocity.x += direction * SPEED *delta
	else:
		if is_on_floor() and not Input.is_action_pressed("ui_accept"):
			velocity.x = move_toward(velocity.x, 0, 30)
		
	move_and_slide()
	
	

	
