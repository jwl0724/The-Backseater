extends ColorRect

@onready var transition: AnimationPlayer = $AnimationPlayer



func _ready():
    visible = false



func play_hide():
    transition.play("transition_hide")



func play_show():
    transition.play("transition_show")