extends Node3D
class_name RoomDoor

@export var door_bash_sfx: AudioStream = null
@export var door_knock_sfx: AudioStream = null
@export var door_squeak_sfx: AudioStream = null
@export var door_slam_sfx: AudioStream = null

@onready var door: Node3D = $"doorway/door 3"
@onready var audio_player: AudioStreamPlayer3D = $AudioPlayer

var is_vulnerable: bool = false

var door_tween: Tween = null



func fix_door():
    if door_tween && door_tween.is_running(): door_tween.kill()
    is_vulnerable = false
    door.rotation_degrees.x = 0
    door.rotation_degrees.y = 0
    door.position = Vector3(-0.142, 0, 0.223)



func destroy_door():
    is_vulnerable = true
    audio_player.stream = door_bash_sfx
    audio_player.play()

    var t = create_tween()
    t.tween_property(door, "rotation_degrees", Vector3(90, 0, 0), 0.5).set_trans(Tween.TRANS_BOUNCE)
    t.parallel().tween_property(door, "position", Vector3(-0.142, 0.32, 0.223), 0.5).set_trans(Tween.TRANS_BOUNCE)
    t.play()



func knock_door():
    audio_player.stream = door_knock_sfx
    audio_player.play()



func close_door():
    audio_player.stream = door_slam_sfx
    audio_player.play()

    door_tween = create_tween()
    door_tween.tween_property(door, "rotation_degrees", Vector3.ZERO, 0.25).set_trans(Tween.TRANS_BOUNCE)
    door_tween.play()



func peek_door():
    audio_player.stream = door_squeak_sfx
    audio_player.play()

    door_tween = create_tween()
    door_tween.tween_property(door, "rotation_degrees", Vector3(0, -21.8, 0), 0.25)
    door_tween.play()