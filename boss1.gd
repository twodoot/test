extends CharacterBody2D


var health = 100
var fight_state = 0
var sheiled_state = 0 #full shiled =0,moving sheiled = 1



func _physics_process(delta: float) -> void:
	
	for i in $Area2D.get_overlapping_bodies():
		print (i.name)
		if i.name == "player":
			health -= 10
			print(str(health))
