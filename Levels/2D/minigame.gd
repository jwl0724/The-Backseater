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

# TODO: remove below later
@onready var enemy: Enemy2D = $Enemy
@export var data: Enemy2DData = null



func _ready():
    enemy.player = player
    enemy.load_data(data)
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

    # TODO: Below might not be necessary when there's subviewport, but will have to see when there
    SignalBus.game2d_player_addHUD.emit.call_deferred(player_hud)
    SignalBus.game2d_start.emit.bind(player).call_deferred()

    enemy.spawn_at_position(player.global_position + Vector2.LEFT * 200) # TODO: Remove later when theres actually dynamic enemy spawning


# Expected to be called by the 3D scene once 5 minutes have passed then freed after
func stop_game():
    player.set_process(false)
    spawner.set_process(false)