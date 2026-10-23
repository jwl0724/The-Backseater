extends Node3D
class_name RoomWindow

@export var window_knock_sfx: AudioStream = null
@export var window_break_sfx: AudioStream = null
@export var window_scratch_sfx: AudioStream = null

@onready var window: Node3D = $wallWindow/window
@onready var audio_player: AudioStreamPlayer3D = $AudioPlayer

var default_window_pos: Vector3 = Vector3()
var default_window_rot: Vector3 = Vector3()

var broken_pos: Vector3 = Vector3(-1.564, -0.189, -1.883)
var broken_rot: Vector3 = Vector3(37.3, 0, 0)

var is_vulnerable: bool = false

var window_tween: Tween = null



func _ready():
    default_window_pos = window.position
    default_window_rot = window.rotation



func fix_window():
    if window_tween && window_tween.is_running(): window_tween.kill()
    is_vulnerable = false
    window.position = default_window_pos
    window.rotation = default_window_rot



func break_window():
    is_vulnerable = true
    audio_player.stream = window_break_sfx
    audio_player.play()

    window_tween = create_tween()
    window_tween.tween_property(window, "position", broken_pos, 0.3).set_trans(Tween.TRANS_CUBIC)
    window_tween.parallel().tween_property(window, "rotation_degrees", broken_rot, 0.35).set_trans(Tween.TRANS_BOUNCE)
    window_tween.play()



func knock_window():
    audio_player.stream = window_knock_sfx
    audio_player.play()



func scratch_window():
    audio_player.stream = window_scratch_sfx
    audio_player.play()