extends Timer

export(float, 0.1, 10, 0.1) var min_timer: float
export(float, 0.1, 10, 0.1) var max_timer: float

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	if autostart:
		start(_get_random_wait_time())
	else:
		wait_time = _get_random_wait_time()
	
func _on_Timer_timeout() -> void:
	if !one_shot:
		start(_get_random_wait_time())
	else:
		wait_time = _get_random_wait_time()

func _get_random_wait_time() -> float:
	return rng.randf_range(min_timer, max_timer)
	
func start_random() -> void:
	start(_get_random_wait_time())
