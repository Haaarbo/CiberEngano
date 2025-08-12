extends Control

var toque_contador := 0
onready var paper_sprite := $TextureRect_Paper/Paper
onready var som_assinatura := $Assinatura

func _ready():
	paper_sprite.playing = false

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		toque_contador += 1

		if toque_contador == 1:
			print("Primeiro toque - tocando animação")
			paper_sprite.play("lose") # Troque pelo nome real da animação
			som_assinatura.play()

		elif toque_contador == 2:
			print("Segundo toque - indo para MainMenu")
			get_tree().change_scene("res://Scenes/MainMenu.tscn")
			if get_tree().paused:
				get_tree().paused = false
