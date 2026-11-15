extends Area2D

var boss1_health = 50
const velocitymultiplier = 0.02

@onready var player = get_node("../player")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$boss1_health.text = "boss1 health: " + str(floor(boss1_health))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (player.global_position.x < global_position.x) and (player.global_position.y > global_position.y):
		$Boss1an.play("botleft")
	elif (player.global_position.x > global_position.x) and (player.global_position.y > global_position.y):
		$Boss1an.play("botright")
	elif (player.global_position.x < global_position.x) and (player.global_position.y < global_position.y):
		$Boss1an.play("topleft")
	elif (player.global_position.x > global_position.x) and (player.global_position.y < global_position.y):
		$Boss1an.play("topright")
	else:
		pass


func _on_body_entered(body: Node2D) -> void:
	
	boss1_health -= velocitymultiplier*player.velocity.length()
	print(boss1_health)
	$boss1_health.text = "boss1 health: " + str(floor(boss1_health))
	if boss1_health <= 0:
		$you_win.text = "YOU WIN!"
		$win.play()
		$Boss1an.play("die")
		Engine.time_scale = 0
	
