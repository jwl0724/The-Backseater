extends Node3D
class_name RoomDoor

@export var door_bash_sfx: AudioStream = null
@export var door_knock_sfx: AudioStream = null

@onready var door: Node3D = $"doorway/door 3"
@onready var audio_player: AudioStreamPlayer3D = $AudioPlayer



func fix_door():
    door.rotation_degrees.x = 0



func destroy_door():
    audio_player.stream = door_bash_sfx
    audio_player.play()

    var t = create_tween()
    t.tween_property(door, "rotation_degrees", Vector3(90, 0, 0), 0.5).set_trans(Tween.TRANS_BOUNCE)
    t.play()



func knock_door():
    audio_player.stream = door_knock_sfx
    audio_player.play()