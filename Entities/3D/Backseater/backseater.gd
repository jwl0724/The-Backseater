extends Node3D
class_name Backseater

const max_aggression: int = 20
const total_attack_stages: int = 4
const aggression_per_2d_death: int = 3
const attack_delay: float = 5 # Gap between ready to pounce and actually attacking

@export_group("Sounds")
@export var wood_step_noises: AudioStream = null # Play when about to attack with broken door
@export var glass_step_noises: AudioStream = null # Play when about to attack with broken window

@export_group("Attack Targets")
@export var player: Player3D = null
@export var door: RoomDoor = null
@export var window: RoomWindow = null

@export_group("Spawn Positions")
@export var door_kill_point: Node3D = null # Only used when the door is destroyed
@export var door_peek_point: Node3D = null # Only used when the door is still there
@export var window_kill_point: Node3D = null # Only used when the window is destroyed
@export var window_peek_point: Node3D = null # Only used when the window is still there

@onready var audio_player: AudioStreamPlayer3D = $AudioPlayer
@onready var delay_timer: Timer = $DelayTimer

var hide_position: Vector3 = Vector3()
var is_attacking: bool = false
var can_attack: bool = true
var aggression: int = 0
var attack_stage: int = 0



func disable_attacks(disable: bool):
    can_attack = !disable



func _ready():
    # Fired when player dies in 2D game, increase monsters aggression
    SignalBus.game2d_restart.connect(func(): aggression += aggression_per_2d_death)
    delay_timer.wait_time = attack_delay
    hide_position = global_position


# TODO: Probably need to create tweens of the monster running away
# TODO: Need to fix the skybox, looks terrible right now
func cancel_attack():
    if delay_timer.timeout.is_connected(_attack.bind(door)):
        delay_timer.timeout.disconnect(_attack.bind(door))
        door.close_door()

    elif delay_timer.timeout.is_connected(_attack.bind(window)):
        delay_timer.timeout.disconnect(_attack.bind(window))



func _roll_attack_stage_advance():
    if randi() % max_aggression > aggression: return
    attack_stage += 1

    if attack_stage > 4:
        _start_attack()
        return
    else: # Play sounds to mess with player
        if randf() > 0.3: return
        if randi() % 2 == 0: door.knock_door()
        else: window.scratch_window()



func _start_attack():
    attack_stage = 0
    if !can_attack: return

    # Handle door attacks
    if randi() % 2 == 0:
        global_position = door_kill_point.global_position if door.is_vulnerable else door_peek_point.global_position
        global_rotation = door_kill_point.global_rotation if door.is_vulnerable else door_peek_point.global_rotation
        if !door.is_vulnerable:
            door.peek_door()
            delay_timer.start()
            delay_timer.timeout.connect(_attack.bind(door), CONNECT_ONE_SHOT)
        else:
            audio_player.stream = wood_step_noises
            audio_player.play()
            delay_timer.start()
            delay_timer.timeout.connect(_attack.bind(door), CONNECT_ONE_SHOT)

    # Handle window attacks
    else:
        global_position = window_kill_point.global_position if window.is_vulnerable else window_peek_point.global_position
        global_rotation = window_kill_point.global_rotation if window.is_vulnerable else window_peek_point.global_rotation
        if !window.is_vulnerable:
            window.knock_window()
            delay_timer.start()
            delay_timer.timeout.connect(_attack.bind(window), CONNECT_ONE_SHOT)
        else:
            audio_player.stream = glass_step_noises
            audio_player.play()
            delay_timer.start()
            delay_timer.timeout.connect(_attack.bind(window), CONNECT_ONE_SHOT)


# TODO: Probably need to do some quick tweens of the monster moving
func _attack(attack_point: Node3D):
    if attack_point is RoomDoor:
        if door.is_vulnerable: door.destroy_door()
        else: player.kill(Player3D.View.LEFT)

    elif attack_point is RoomWindow:
        if window.is_vulnerable: window.break_window()
        else: player.kill(Player3D.View.RIGHT)