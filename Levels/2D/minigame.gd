extends Node2D
class_name MiniGame

@export_group("Dev Tools")
@export var autoload_level: int = 1

@export_group("Music Clips")
@export var bgm1: AudioStream = null
@export var bgm2: AudioStream = null
@export var bgm3: AudioStream = null
@export var bgm4: AudioStream = null

@export_group("Required Scenes")
@export var player_hud: PackedScene = null
@export var night1: PackedScene = null
@export var night2: PackedScene = null
@export var night3: PackedScene = null
@export var night4: PackedScene = null

@onready var music_player: AudioStreamPlayer = $BGM
@onready var player: Player2D = $Player
@onready var hud_2d: HUD2D = $LocalViewport/Hud
@onready var spawner: EnemySpawner = $Systems/Spawner

var spawn_node: Node2D = null
var instanced_level: int = 0



func _ready():
    visible = false
    player.visible = false
    hud_2d.hide_hud()
    player.killed.connect(_on_player_death)



func start_game(level_number: int):
    visible = true

    instanced_level = level_number
    var scene: Node2D
    var msg: String
    match level_number:
        1:
            scene = night1.instantiate()
            msg = "LEVEL 1"
            music_player.stream = bgm1
        2:
            scene = night2.instantiate()
            msg = "LEVEL 2"
            music_player.stream = bgm2
        3:
            scene = night3.instantiate()
            msg = "LEVEL 3"
            music_player.stream = bgm3
        4:
            scene = night4.instantiate()
            msg = "YOU BROKE THE META"
            music_player.stream = bgm4
        _: scene = null
    if !scene:
        printerr("%d is an invalid level number, value should be between 1 and 4" % level_number)
        return

    # Show transition and load scene
    SignalBus.transition_message_hide.emit(msg)
    await SignalBus.transition_message_finished
    add_child(scene)
    player.visible = true
    spawn_node = scene.find_child("Spawn")
    player.teleport_to_point(spawn_node.global_position)

    # Start the game
    SignalBus.transition_message_show.emit()
    await SignalBus.transition_message_finished
    music_player.play()
    hud_2d.show_hud()
    player.in_play = true # Activate the player
    SignalBus.game2d_start.emit.bind(player).call_deferred()
    spawner.start_spawning(player, level_number, 1 / float(level_number) * 4)



func restart_game(): # Respawning player and clearing enemies (probably keep player levels?)
    spawner.clear_and_stop_spawning()
    player.respawn(spawn_node.global_position)
    spawner.start_spawning(player, instanced_level, 1 / float(instanced_level) * 4)
    SignalBus.transition_message_show.emit()
    SignalBus.game2d_restart.emit()


# Expected to be called by the 3D scene once 5 minutes have passed then freed after
func stop_game():
    music_player.stop()
    process_mode = Node.PROCESS_MODE_DISABLED



func _on_player_death():
    SignalBus.transition_message_hide.emit("RESPAWNING")
    await SignalBus.transition_message_finished
    restart_game()
    SignalBus.transition_message_show.emit()