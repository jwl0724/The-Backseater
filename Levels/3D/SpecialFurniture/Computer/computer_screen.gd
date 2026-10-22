extends Node3D
class_name RoomComputer

@export var minigame_template: PackedScene = null

@onready var alert_sound: AudioStreamPlayer3D = $AlertSound
@onready var game_window: SubViewport = $GameScreen
@onready var game_sounds: GameSoundsFunnel = $GameSounds

var minigame_instance: MiniGame = null
var is_reading_input: bool = false



func _ready():
    SignalBus.hud_2d_sendMessage.connect(_on_msg_send)



func start_game(level: int):
    minigame_instance = minigame_template.instantiate()
    game_window.add_child(minigame_instance)
    minigame_instance.start_game(level)



func clear_screen():
    if game_window.get_child_count() == 1:
        var last_instance = game_window.get_child(0)
        last_instance.queue_free()



func stop_game():
    minigame_instance.stop_game()




func disable_sounds(disable: bool):
    game_sounds.disable_funnel(disable)



func enable_inputs(enable: bool):
    is_reading_input = enable
    Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN if enable else Input.MOUSE_MODE_VISIBLE

    var event = InputEventAction.new()
    event.action = Constants.Controls.Tab
    event.pressed = enable
    game_window.push_input(event)



func _input(event: InputEvent):
    if !is_reading_input || event is not InputEventMouse: return
    game_window.push_input(event, false) # Forward mouse position to subviewport



func _on_msg_send(_text: String):
    alert_sound.play()