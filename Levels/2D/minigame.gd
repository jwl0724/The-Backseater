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


func _ready():
    start_game(autoload_level) # TODO: Temp, need the 3D scene to call this later



func start_game(level_number: int):
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
    var spawn_point: Node2D = scene.find_child("Spawn")
    player.teleport_to_point(spawn_point.global_position)
    SignalBus.game2d_start.emit.bind(player).call_deferred()
    spawner.start_spawning(player, level_number, 1 / float(level_number) * 4)


# Expected to be called by the 3D scene once 5 minutes have passed then freed after
func stop_game():
    player.set_process(false)
    spawner.set_process(false)