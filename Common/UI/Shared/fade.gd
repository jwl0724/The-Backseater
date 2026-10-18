extends ColorRect



func _ready():
    SignalBus.transition_fade_show.connect(_on_transition_show_request)
    SignalBus.transition_fade_hide.connect(_on_transition_hide_request)
    visible = false



func _on_transition_show_request(time: float):
    # Set properties
    visible = true
    modulate = Color.WHITE

    if time == 0: # Skip tweening if time = 0
        visible = false
        modulate = Color.TRANSPARENT
        return

    # Setup transitioning tween
    var t = create_tween()
    t.tween_property(self, "modulate", Color.TRANSPARENT, time)
    t.tween_callback(func(): visible = false)
    t.play()



func _on_transition_hide_request(time: float):
    # Set properties
    visible = true
    modulate = Color.TRANSPARENT

    if time == 0: # Skip tweening if time = 0
        modulate = Color.WHITE
        return

    # Setup transitioning tween
    var t = create_tween()
    t.tween_property(self, "modulate", Color.WHITE, time)
    t.play()