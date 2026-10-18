extends Node
class_name GameController

@export_group("Required Scenes")
@export var load_screen: PackedScene = null

@export_group("Dev Tools")
@export var enable_debug: bool = false
@export var debug_scene: PackedScene = null
@export var debug_guis: Array[PackedScene] = []

@onready var gui_layer: Control = $GUI/Root
@onready var pause_layer: Control = $Pause/Root
@onready var transition_layer: Control = $Transition/Root
@onready var debug_layer: Control = $Debug/Root

@onready var running_node: Node3D = $Running



func _ready():
    # TODO: Need actual launch scene here, for now just have it launch the debug scene by default
    var launch_scene = debug_scene.instantiate()
    running_node.add_child(launch_scene)



func direct_change_scenes(new_scene: PackedScene) -> void:
    if !_free_current_running(): return
    running_node.add_child(new_scene.instantiate())



func thread_change_scenes(scene_uid: String):
    if !_free_current_running(): return
    var loading = load_screen.instantiate() as LoadingScreen
    running_node.add_child(loading)
    loading.thread_load_scene(scene_uid)
    loading.loading_finished.connect(_on_finished_loading, CONNECT_ONE_SHOT)



func _on_finished_loading(node: Node):
    if _free_current_running(): return
    running_node.add_child(node)



func _free_current_running() -> bool: # Returns true if successfully removed, false otherwise
    if running_node.get_child_count() > 1:
        printerr("Running node should not have more than one child, multiple scenes were added to running")
        return false
    else:
        running_node.get_child(0).queue_free()
        return true