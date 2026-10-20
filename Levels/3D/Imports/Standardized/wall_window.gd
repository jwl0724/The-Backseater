extends Node3D
class_name RoomWindow

@export var window_knock_sfx: AudioStream = null
@export var window_break_sfx: AudioStream = null

@onready var window: Node3D = $wallWindow/window
@onready var audio_player: AudioStreamPlayer3D = $AudioPlayer

var default_window_pos: Vector3 = Vector3()
var default_window_rot: Vector3 = Vector3()

var broken_pos: Vector3 = Vector3(-1.564, -0.189, -1.883)
var broken_rot: Vector3 = Vector3(37.3, 0, 0)



func _ready():
    default_window_pos = window.position
    default_window_rot = window.rotation

    await get_tree().create_timer(1).timeout
    break_window()
    await get_tree().create_timer(3).timeout
    fix_window()




func fix_window():
    window.position = default_window_pos
    window.rotation = default_window_rot



func break_window():
    audio_player.stream = window_break_sfx
    audio_player.play()

    var t = create_tween()
    t.tween_property(window, "position", broken_pos, 0.3).set_trans(Tween.TRANS_CUBIC)
    t.parallel().tween_property(window, "rotation_degrees", broken_rot, 0.35).set_trans(Tween.TRANS_BOUNCE)
    t.play()



func knock_window():
    audio_player.stream = window_knock_sfx
    audio_player.play()