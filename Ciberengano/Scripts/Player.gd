extends Area2D

# Variáveis para controle do progresso
var progress_value : float = 0.0
var max_progress : float = 1.0
var fill_speed : float = 0.1  # Ajuste para controlar a velocidade do preenchimento das estrelas
#Variável para verificar se está ou não jogando
var isPlaying := false
var isWin := false

# Stars
onready var stars = []
onready var current_star = 0

# Carregamento do som
onready var typing_sound = $PlayerSound

func _ready():
	for i in Array(PoolIntArray(range(5))): #range(5)
		#Instancia cada uma das estrelas no array
		var star = get_node("/root/Game/StarsContainer/Star%d" % (i+1)) 
		star.value = 0
		stars.append(star)

func _process(delta):
	if Input.is_action_pressed("Play"):
		$AnimatedSprite.play("action")
		isPlaying = true
		# Preenchimento e passe das estrelas
		if current_star <= 4:
			fill_stars()
		else:
			isWin = true
			isPlaying = false
			#garantir que o som do teclado não vai tocar mesmo
			typing_sound.stream_paused = true
			get_node("/root/Game/").on_win()
			#get_tree().change_scene("res://Scenes/MainMenu.tscn")
	else:
		$AnimatedSprite.play("idle")
		isPlaying = false
		
	# Controla o som teclando
	if isPlaying:
		if not typing_sound.playing:
			typing_sound.play()
		elif typing_sound.stream_paused:
			typing_sound.stream_paused = false
	else:
		if typing_sound.playing:
			typing_sound.stream_paused = true

func fill_stars():
	stars[current_star].value += 10
	if stars[current_star].value == stars[current_star].max_value:
		current_star += 1
	

