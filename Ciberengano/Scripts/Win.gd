extends Control

var toque_contador := 0
onready var paper_sprite := $TextureRect_Paper/Paper
onready var som_folha := $Folha

func _ready():
	som_folha.play()

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		toque_contador += 1

		if toque_contador == 1:
			print("Primeiro toque - tocando animação")
			paper_sprite.play("win") # Troque pelo nome real da animação
			get_tree().change_scene("res://Scenes/MainMenu.tscn")
			if get_tree().paused:
				get_tree().paused = false
