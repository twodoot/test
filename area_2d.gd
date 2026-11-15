extends Area2D

var health = 100
const velocitymultiplier = 0.01

@onready var player = get_node("../player")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	
	health -= velocitymultiplier*player.velocity.length()
	print(health)
	
