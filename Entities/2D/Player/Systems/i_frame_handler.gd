extends Node
class_name Player2DIFrames

const i_frame_time: float = 1

@onready var player: Player2D = owner as Player2D

var can_be_damaged: bool = true
var time_elapsed: float = 0



func activate_iframes():
    can_be_damaged = false
    time_elapsed = 0



func _process(delta):
    if can_be_damaged: return
    time_elapsed += delta
    can_be_damaged = time_elapsed >= i_frame_time