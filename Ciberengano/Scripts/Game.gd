extends Node2D

var score := 0
onready var teacher = get_node("Teacher")
onready var student = get_node("Student")
onready var player = get_node("Player")
onready var teacher_timer = get_node("TeacherTimer")
onready var wait_timer = get_node("WaitTimer")

var teacher_sprite: Node
var student_sprite: Node
var teacher_animation_list := ["drinking_start", "walking_to_student", "walking_to_whiteboard"]
var teacher_idle_animation_list := ["idle_arm", "idle_blinking", "idle_step", "idle_talking"]
var all_animation_list := teacher_animation_list + teacher_idle_animation_list
var current_animation := _get_random_animation(teacher_idle_animation_list)

func _ready() -> void:
	teacher_sprite = teacher.get_node("AnimatedSprite")
	student_sprite = student.get_node("AnimatedSprite")
	
	teacher_sprite.play(current_animation)
	student_sprite.play("idle")
	teacher_timer.connect("timeout", self, "_on_teacher_timer_timeout")
	wait_timer.connect("timeout", self, "_on_wait_timer_timeout")
	teacher_timer.start_random()


func _on_teacher_timer_timeout() -> void:
	if teacher_sprite.is_connected("animation_finished", self, "_on_teacher_wait_animation_finished"):
		teacher_sprite.disconnect("animation_finished", self, "_on_teacher_wait_animation_finished")
	wait_timer.stop()
	
	if current_animation == "writing_in_whiteboard":
		var _a = teacher_sprite.connect("animation_finished", self, "_on_teacher_writing_in_whiteboard_finished")
		current_animation = "returning_from_whiteboard"
		teacher_sprite.play(current_animation)
		return
	elif current_animation == "attending_student":
		var _a = teacher_sprite.connect("animation_finished", self, "_on_teacher_animation_finished")
		current_animation = "returning_from_student"
		student_sprite.play("help")
		teacher_sprite.play(current_animation)
		return

	var last_animation = current_animation
	current_animation = _get_random_animation(all_animation_list, last_animation)
	if current_animation in teacher_animation_list:
		print(current_animation)
		teacher_timer.disconnect("timeout", self, "_on_teacher_timer_timeout")
		var _a = teacher_sprite.connect("animation_finished", self, "_on_teacher_animation_finished")
		teacher_sprite.play(current_animation)
	else:
		teacher_sprite.play(current_animation)
		teacher_timer.start_random()

	
func _on_teacher_writing_in_whiteboard_finished() -> void:
	pass


func _on_teacher_animation_finished() -> void:
	teacher_sprite.disconnect("animation_finished", self, "_on_teacher_animation_finished")
	if current_animation == "drinking_start":
		wait_timer.start_random()
		return
	elif current_animation == "drinking_stop":
		current_animation = _get_random_animation(all_animation_list)
	elif current_animation == "walking_to_whiteboard":
		current_animation = "writing_in_whiteboard"
	elif current_animation == "returning_from_whiteboard":
		current_animation = _get_random_animation(all_animation_list, "walking_to_whiteboard")
	elif current_animation == "walking_to_student":
		current_animation = "attending_student"
	elif current_animation == "returning_from_student":
		current_animation = _get_random_animation(all_animation_list, "walking_to_student")
		
	var _a = teacher_timer.connect("timeout", self, "_on_teacher_timer_timeout")
	var _b = teacher_sprite.connect("animation_finished", self, "_on_teacher_wait_animation_finished")
	teacher_sprite.play(current_animation)
	teacher_timer.start_random()


func _on_wait_timer_timeout() -> void:
	if current_animation == "drinking_start":
		var _a = teacher_sprite.connect("animation_finished", self, "_on_teacher_animation_finished")
		current_animation = "drinking_stop"
		teacher_sprite.play(current_animation)
	else:
		var _a = teacher_sprite.connect("animation_finished", self, "_on_teacher_wait_animation_finished")
	
		
func _on_teacher_wait_animation_finished() -> void:
	teacher_sprite.disconnect("animation_finished", self, "_on_teacher_wait_animation_finished")
	teacher_sprite.frame = 0
	teacher_sprite.play()
	wait_timer.start_random()


func _get_random_animation(animation_list: Array, exclude: String = "") -> String:
	var filtered_animations = []
	for animation in animation_list:
		if animation != exclude:
			filtered_animations.append(animation)

	var random_index = randi() % filtered_animations.size()
	return filtered_animations[random_index]
