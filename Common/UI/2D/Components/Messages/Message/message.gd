extends Panel
class_name Message

signal expired()

@onready var lifespan_timer: Timer = $Lifespan
@onready var picture: TextureRect = %Picture
@onready var sender: Label = %Sender
@onready var content: Label = %Message



func _ready():
    visible = false
    lifespan_timer.timeout.connect(_on_expired)



func show_content(start_timer: bool, linger_time: float = 2):
    modulate = Color.TRANSPARENT
    visible = true
    lifespan_timer.wait_time = linger_time
    if start_timer: lifespan_timer.start()

    var t = create_tween()
    t.tween_property(self, "modulate", Color.WHITE, 0.5)
    t.play()



func fade_content():
    var t = create_tween()
    t.tween_property(self, "modulate", Color.TRANSPARENT, 1)
    t.tween_callback(func():
        visible = false
        expired.emit())
    t.play()



func populate_content(sender_name: String, message: String, profile_picture: Texture2D = null):
    sender.text = sender_name
    content.text = message
    if profile_picture == null: return
    picture.texture = profile_picture # Defaults to monster picture if nothing is provided



func _on_expired():
    fade_content()