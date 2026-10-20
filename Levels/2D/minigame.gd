extends Node2D
class_name MiniGame

@export_group("Dev Tools")
@export var autoload_level: int = 1

@export_group("Required Scenes")
@export var player_hud: PackedScene = null
@export var night1: PackedScene = null
@export var night2: PackedScene = null
@export var night3: PackedScene = null
@export var night4: PackedScene = null

@onready var player: Player2D = $Player
@onready var spawner: EnemySpawner = $Systems/Spawner

var spawn_node: Node2D = null
var instanced_level: int = 0



func _ready():
    player.killed.connect(_on_player_death)
    SignalBus.game2d_restart.connect(restart_game)
    start_game(autoload_level) # TODO: Temp, need the 3D scene to call this later



func start_game(level_number: int):
    instanced_level = level_number
    var scene: Node2D
    match level_number:
        1: scene = night1.instantiate()
        2: scene = night2.instantiate()
        3: scene = night3.instantiate()
        4: scene = night4.instantiate()
        _: scene = null
    if !scene:
        printerr("%d is an invalid level number, value should be between 1 and 4" % level_number)
        return
    add_child(scene)
    spawn_node = scene.find_child("Spawn")
    player.teleport_to_point(spawn_node.global_position)
    SignalBus.game2d_start.emit.bind(player).call_deferred()
    spawner.start_spawning(player, level_number, 1 / float(level_number) * 4)

    await get_tree().create_timer(10).timeout
    stop_game()



func restart_game(): # Respawning player and clearing enemies (probably keep player levels?)
    spawner.clear_and_stop_spawning()
    player.respawn(spawn_node.global_position)
    spawner.start_spawning(player, instanced_level, 1 / float(instanced_level) * 4)
    SignalBus.transition_respawn_show.emit()


# Expected to be called by the 3D scene once 5 minutes have passed then freed after
func stop_game():
    process_mode = Node.PROCESS_MODE_DISABLED



func _on_player_death():
    SignalBus.transition_respawn_hide.emit()