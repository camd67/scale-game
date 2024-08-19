extends Node3D

@onready var book_animation_player: AnimationPlayer = $BookAnimationPlayer

@onready var book_tooltip: BookTooltip = $BookTooltip
@onready var open_timer: Timer = $OpenTimer
@onready var close_timer: Timer = $CloseTimer

var currently_active_text: String

var is_book_open := false

var is_tooltip_active := false
var is_currently_closing := false

var has_seen_atleast_one_tooltip := false

func _ready() -> void:
	# Check the miro board for the tooltip state diagram
	open_timer.timeout.connect(on_open_timeout)
	close_timer.timeout.connect(on_close_timeout)
	book_animation_player.animation_finished.connect(on_animation_finished)
	GameEvents.tooltip_requested.connect(tooltip_requested)
	GameEvents.tooltip_done.connect(tooltip_done)


func is_grabbing_item() -> bool:
	# This really should be stored somehwere more properly but.. it's less than 24 hours before
	# the jam end...
	return owner.grabber.is_grabbing


func tooltip_requested(text: String) -> void:
	if is_grabbing_item():
		# If we're grabbing an item and request a tooltip, stop immediately
		return

	book_tooltip.update_text(text)
	currently_active_text = text
	close_timer.stop()

	if not is_tooltip_active and open_timer.is_stopped():
		is_tooltip_active = true
		if has_seen_atleast_one_tooltip:
			open_timer.start()
		else:
			# First tooltip is extra quick so they see it
			open_timer.start(0.5)


func tooltip_done(text: String) -> void:
	if not open_timer.is_stopped():
		# We haven't even opened up yet
		open_timer.stop()
		is_tooltip_active = false
		is_currently_closing = false
		currently_active_text = ""
	elif currently_active_text == text and close_timer.is_stopped() and not is_currently_closing:
		# We were open and the current tooltip is the one we want to close
		# we have also not yet started the close timer
		close_timer.start()


func on_open_timeout() -> void:
	if is_grabbing_item():
		# If we requested a tooltip, but then grabbed something, stop
		is_tooltip_active = false
		is_currently_closing = false
		currently_active_text = ""
		return

	has_seen_atleast_one_tooltip = true
	book_animation_player.play("appear")


func on_close_timeout() -> void:
	book_animation_player.play_backwards("appear")
	is_currently_closing = true


func on_animation_finished(anim_name: String) -> void:
	if is_currently_closing:
		is_tooltip_active = false
		is_currently_closing = false
		currently_active_text = ""


func toggle_book_open() -> void:
	if is_book_open:
		book_tooltip.close_book()
	else:
		book_tooltip.open_book()

	is_book_open = not is_book_open
