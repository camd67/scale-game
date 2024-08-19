extends OmniLight3D

@export var max_energy_deviation : float = .05

@onready var timer: Timer = %Timer

var current_energy_deviation : float = 0
var base_energy : float


func _ready() -> void:
	base_energy = light_energy
	timer.timeout.connect(on_flicker_timer_timeout)


func on_flicker_timer_timeout() -> void:
	current_energy_deviation += randf_range(-.1, .1)
	current_energy_deviation = clampf(current_energy_deviation, -max_energy_deviation, max_energy_deviation)
	light_energy = base_energy + current_energy_deviation
