extends Label
class_name TutorialText

const seconds_per_line: float = 5
const seconds_per_transition: float = 0.15
const transition_distance: float = 5
const gap_per_message: float = 2

var running_tutorial_tween: Tween = null



func _ready():
    visible = false
    SignalBus.hud_3d_tutorial_play.connect(_on_tutorial_request)



func _on_tutorial_request(tutorial_sequence: Array[String]):
    if running_tutorial_tween && running_tutorial_tween.is_running(): return

    # Set pre-tween stats
    visible = true
    position.y += transition_distance
    modulate = Color.TRANSPARENT
    running_tutorial_tween = create_tween()

    for line: String in tutorial_sequence:
        running_tutorial_tween.tween_callback(func(): text = line)
        running_tutorial_tween.tween_property(self, "modulate", Color.WHITE, seconds_per_transition)
        running_tutorial_tween.parallel().tween_property(self, "position", position + Vector2.UP * transition_distance, seconds_per_transition)

        running_tutorial_tween.tween_interval(seconds_per_line)

        running_tutorial_tween.tween_property(self, "modulate", Color.TRANSPARENT, seconds_per_transition)
        running_tutorial_tween.parallel().tween_property(self, "position", position + Vector2.DOWN * transition_distance, seconds_per_transition)
        running_tutorial_tween.tween_interval(gap_per_message)

    running_tutorial_tween.tween_callback(func():
        visible = false
        position.y -= transition_distance)
    running_tutorial_tween.play()