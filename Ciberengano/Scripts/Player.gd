extends Area2D

func _ready():
	pass 

func _process(delta):
	if Input.is_action_pressed("Play"):
		$AnimatedSprite.play("action")
	else:
		$AnimatedSprite.play("idle")	
