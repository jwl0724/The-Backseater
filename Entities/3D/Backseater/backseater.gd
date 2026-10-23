extends Node3D
class_name Backseater

const roll_interval: int = 5
const max_aggression: int = 20
const total_attack_stages: int = 4
const aggression_per_2d_death: int = 3
const aggression_per_passive_gain: int = 2 # Gain 2 aggression per minute passively
const time_per_aggression_increment: float = 60
const attack_delay: float = 5 # Gap between ready to pounce and actually attacking

@export_group("Sounds")
@export var ambience_sounds: Array[AudioStream] = []
@export var door_prepare_attack: AudioStream = null # Play when about to attack with broken door
@export var window_prepare_attack: AudioStream = null # Play when about to attack with broken window
@export var attack_canceled_sound: AudioStream = null # Play when scared off
@export var attack_sound: AudioStream = null # Sound played during the jumpscare
@export var kill_sound: AudioStream = null # Jumpscare-ish sound

@export_group("Attack Targets")
@export var player: Player3D = null
@export var door: RoomDoor = null
@export var window: RoomWindow = null

@export_group("Spawn Positions")
@export var door_kill_point: Node3D = null # Only used when the door is destroyed
@export var door_peek_point: Node3D = null # Only used when the door is still there
@export var window_kill_point: Node3D = null # Only used when the window is destroyed
@export var window_peek_point: Node3D = null # Only used when the window is still there

@onready var attack_player: AudioStreamPlayer3D = $AttackSounds
@onready var ambient_player: AudioStreamPlayer3D = $AmbientSounds
@onready var delay_timer: Timer = $DelayTimer # Wait time before pouncing for attack
@onready var roll_timer: Timer = $RollTimer # Interval that tests if attack stage goes up
@onready var aggression_timer: Timer = $AggroTimer # Interval at which aggression is increment throughout the night

var hide_position: Vector3 = Vector3()

var can_attack: bool = true
var aggression: int = 0:
    set(val): aggression = clampi(val, 0, 20)
var attack_stage: int = 0



func _ready():
    delay_timer.wait_time = attack_delay
    roll_timer.wait_time = roll_interval
    aggression_timer.wait_time = time_per_aggression_increment
    aggression_timer.timeout.connect(func(): aggression += aggression_per_passive_gain)
    hide_position = global_position

    SignalBus.game2d_restart.connect(func(): aggression += aggression_per_2d_death) # Fired when player dies in 2D game, increase monsters aggression
    roll_timer.timeout.connect(_roll_attack_stage_advance)



func disable_attacks(disable: bool):
    can_attack = !disable



func activate(night: int):
    roll_timer.start()
    aggression_timer.start()
    aggression = (night - 1) * 2 # Set starting aggression level



func reset():
    roll_timer.stop()
    aggression_timer.stop()
    cancel_attack(false)
    aggression = 0
    attack_stage = 0



func reset_position():
    global_position = hide_position



func cancel_attack(start_roll_timer: bool = true):
    delay_timer.stop()
    if delay_timer.timeout.is_connected(_attack.bind(door)):
        delay_timer.timeout.disconnect(_attack.bind(door))

        if !door.is_vulnerable:
            door.close_door()
            _animate_to_node(door_peek_point, false)
        else: _animate_to_node(door_kill_point, false)

    elif delay_timer.timeout.is_connected(_attack.bind(window)):
        delay_timer.timeout.disconnect(_attack.bind(window))

        if !window.is_vulnerable: _animate_to_node(window_peek_point, false)
        else: _animate_to_node(window_kill_point, false)


    if start_roll_timer:
        attack_player.stream = attack_canceled_sound
        attack_player.play()
        roll_timer.start()



func _roll_attack_stage_advance():
    if aggression == max_aggression && can_attack: # If player hit max aggression, force a death
        roll_timer.stop()
        if randi() % 2 == 0: _attack(door)
        else: _attack(window)
        return

    if randi() % max_aggression > aggression: # If failed to increment have a 1% chance to play ambient noise
        if randf() < 0.01 && !ambient_player.playing:
            ambient_player.stream = ambience_sounds.pick_random()
            ambient_player.play()
            return

    attack_stage += 1
    if attack_stage > 4:
        _start_attack()
        return
    else: # Play sounds to mess with player
        if randf() > 0.1: return
        if randi() % 2 == 0: door.knock_door()
        else: window.scratch_window()


# TODO: Fix the animation of the thing flying towards player when repelled from broken window?
func _start_attack():
    attack_stage = 0
    if !can_attack: return
    roll_timer.stop()

    # Handle door attacks
    if randi() % 2 == 0:
        global_rotation = door_kill_point.global_rotation if door.is_vulnerable else door_peek_point.global_rotation
        var target_pos = door_kill_point if door.is_vulnerable else door_peek_point
        _animate_to_node(target_pos, true)

        player.alert_attacking(self, Player3D.View.LEFT)
        if !door.is_vulnerable:
            door.peek_door()
            delay_timer.start()
            delay_timer.timeout.connect(_attack.bind(door), CONNECT_ONE_SHOT)
        else:
            attack_player.stream = door_prepare_attack
            attack_player.play()
            delay_timer.start()
            delay_timer.timeout.connect(_attack.bind(door), CONNECT_ONE_SHOT)

    # Handle window attacks
    else:
        global_rotation = window_kill_point.global_rotation if window.is_vulnerable else window_peek_point.global_rotation
        var target_pos = window_kill_point if window.is_vulnerable else window_peek_point
        _animate_to_node(target_pos, true)

        player.alert_attacking(self, Player3D.View.RIGHT)
        if !window.is_vulnerable:
            window.knock_window()
            delay_timer.start()
            delay_timer.timeout.connect(_attack.bind(window), CONNECT_ONE_SHOT)
        else:
            attack_player.stream = window_prepare_attack
            attack_player.play()
            delay_timer.start()
            delay_timer.timeout.connect(_attack.bind(window), CONNECT_ONE_SHOT)


# TODO: Need to do animation of monster actually killing the player
func _attack(attack_point: Node3D):
    if attack_point is RoomDoor:
        if !door.is_vulnerable:
            door.destroy_door()
            _animate_to_node(door_peek_point, false)
            roll_timer.start()
        else: player.kill(Player3D.View.LEFT)

    elif attack_point is RoomWindow:
        if !window.is_vulnerable:
            window.break_window()
            _animate_to_node(window_peek_point, false)
            roll_timer.start()
        else: player.kill(Player3D.View.RIGHT)



func _animate_to_node(node: Node3D, towards: bool):
    if node == window_kill_point || node == window_peek_point:
        var target_pos = node.global_position if towards else node.global_position + Vector3.DOWN * 10
        if towards: global_position = node.global_position + Vector3.DOWN * 10
        var t = create_tween()
        t.tween_property(self, "global_position", target_pos, 0.3)
        t.play()

    else: # Door position
        var target_pos = node.global_position if towards else node.global_position - transform.basis.z * 10
        if towards: position = node.global_position + -transform.basis.z * 10
        var t = create_tween()
        t.tween_property(self, "global_position", target_pos, 0.3)
        t.play()