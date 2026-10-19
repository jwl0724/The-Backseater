extends Node
class_name EnemySpawner

@export var enemy_template: PackedScene = null

@export var level1_enemy_set: Array[Enemy2DData] = []
@export var level2_enemy_set: Array[Enemy2DData] = []
@export var level3_enemy_set: Array[Enemy2DData] = []
@export var level4_enemy_set: Array[Enemy2DData] = []

@onready var data_sets: Array = [level1_enemy_set, level2_enemy_set, level3_enemy_set, level4_enemy_set]

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var dead_enemies: Array[Enemy2D] = []
var data_set_number: int = 1
var spawn_interval: float = -1 # Set to -1 as indicator to not run spawning yet

var player: Player2D = null
var time_elapsed: float = 0



func start_spawning(player_ref: Player2D, level: int, frequency: float):
    data_set_number = level - 1 # Level should be between 1 and 4
    spawn_interval = frequency
    player = player_ref



func _spawn_enemy():
    # Re-use dead enemy entity
    var enemy = dead_enemies.pop_back()
    # Create enew entity if no dead enemies in pool
    if !enemy:
        enemy = enemy_template.instantiate() as Enemy2D
        enemy.player = player # Set player reference to start chasing
        enemy.killed.connect(dead_enemies.append.bind(enemy))
        add_child(enemy)
    enemy.load_data(_get_random_enemy_data())
    enemy.spawn_at_position(_get_random_spawn_point())



func _get_random_enemy_data() -> Enemy2DData:
    var weights: Array[float] = []
    for data in data_sets[data_set_number]:
        weights.append(1 / data.xp_worth)
    var index = rng.rand_weighted(weights)
    return data_sets[data_set_number][index]



func _get_random_spawn_point() -> Vector2:
    var view_size = player.camera.get_viewport_rect().size / player.camera.zoom
    var top_left = player.camera.get_screen_center_position() - view_size / 2
    var spawn_rect := Rect2(top_left, view_size).grow(8)
    var side = randi() % 4
    match side:
        0: return Vector2(randf_range(spawn_rect.position.x, spawn_rect.end.x), spawn_rect.position.y) # North
        1: return Vector2(randf_range(spawn_rect.position.x, spawn_rect.end.x), spawn_rect.end.y) # South
        2: return Vector2(spawn_rect.position.x, randf_range(spawn_rect.position.y, spawn_rect.end.y)) # West
        _: return Vector2(spawn_rect.end.x, randf_range(spawn_rect.position.y, spawn_rect.end.y)) # East



func _process(delta):
    if spawn_interval == -1: return
    time_elapsed += delta
    if time_elapsed >= spawn_interval:
        time_elapsed = 0
        _spawn_enemy()