extends Label

const format: String = "%s is typing..."
var ellipsis_tween: Tween = null



func _ready():
    text = format % Dialogue.backseater_name
    var min_chars: int = text.length() - 3
    var max_chars: int = text.length()

    ellipsis_tween = create_tween()
    ellipsis_tween.set_loops()
    ellipsis_tween.tween_callback(func(): visible_characters = min_chars)
    ellipsis_tween.tween_property(self, "visible_characters", max_chars, 1.5)
    ellipsis_tween.play()