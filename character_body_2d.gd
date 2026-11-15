extends CharacterBody2D

const SPEED = 1000
const JUMP_VELOCITY = 300.0
const BOUNCE_VELOCITY = 200
const speed_jump_multiplier_y = -0.0003
const speed_jump_multiplier_x = -0.0003

var player_health = 20
@onready var player_health_label = $player_health

func _ready() -> void:
	$player_health.text = "Your Health: "  + str(player_health)

func _physics_process(delta: float) -> void:
	$Anim.play("default")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		$Anim.play("fall")
	
	if velocity.x < -100:
		$Anim.play("left")
	elif velocity.x > 100:
		$Anim.play("right")
	
	
	#special attributes
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var tilemap = collision.get_collider() as TileMapLayer
		if tilemap != null:
			var hit_position = collision.get_position() - collision.get_normal() * 2.0
			var tile_position = tilemap.local_to_map(tilemap.to_local(hit_position))
		
			var tile_data = tilemap.get_cell_tile_data(tile_position)

			if tile_data != null:
				if tile_data.get_custom_data("death"):
					player_health -= 1
					$damage.play()
					$player_health.text = "Your Health: "  + str(player_health)
					if player_health <= 0:
						$die.play()
						get_tree().call_deferred("reload_current_scene")
					
					
				if tile_data.get_custom_data("bounce"):
					var normal : Vector2 = Vector2(0,0)
		
					if is_on_floor():
						normal += get_floor_normal()
					
					if $RoofRay1.is_colliding():
						normal += $RoofRay1.get_collision_normal()
					elif $RoofRay2.is_colliding():
						normal += $RoofRay2.get_collision_normal()
					elif $RoofRay3.is_colliding():
						normal += $RoofRay3.get_collision_normal()
			
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
			
					normal = normal.normalized()
		
					normal.y += velocity.length()*speed_jump_multiplier_y
					normal.x += velocity.length()*speed_jump_multiplier_x
		
					velocity += normal *BOUNCE_VELOCITY
					$Anim.play("bounce")
					$bounce.play()
				

	


	
	# Handle jump.
	if Input.is_action_pressed("ui_accept") and (is_on_floor() or $RightWallRay1.is_colliding() or $RightWallRay2.is_colliding() or $RightWallRay3.is_colliding() or $LeftWallRay1.is_colliding() or $LeftWallRay2.is_colliding() or $LeftWallRay3.is_colliding() or $RoofRay1.is_colliding() or $RoofRay2.is_colliding() or $RoofRay3.is_colliding()):
		
		$Anim.play("bounce")
		
		var normal : Vector2 = Vector2(0,0)
		
		if is_on_floor():
			normal += get_floor_normal()
			
		if $RoofRay1.is_colliding():
			normal += $RoofRay1.get_collision_normal()
		elif $RoofRay2.is_colliding():
			normal += $RoofRay2.get_collision_normal()
		elif $RoofRay3.is_colliding():
			normal += $RoofRay3.get_collision_normal()
			
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
		$bounce.play()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and (velocity.length() <= 500):
		velocity.x += direction * SPEED *delta
	else:
		if is_on_floor() and not Input.is_action_pressed("ui_accept"):
			velocity.x = move_toward(velocity.x, 0, 30)
		
	move_and_slide()
	
	
