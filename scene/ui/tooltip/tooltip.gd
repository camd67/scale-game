extends Node2D
class_name Tooltip

@onready var label: Label = $PanelContainer/MarginContainer/Label

@export var tooltip_text: String

func _ready() -> void:
	visible = false
	label.text = tooltip_text

	label.draw.connect(on_label_draw)


func on_label_draw() -> void:
	# if our label is too long break it up
	if label.size.x > 200:
		label.custom_minimum_size.x = 200
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.queue_redraw()
