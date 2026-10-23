extends Node
class_name GameController

@export_group("Required Scenes")
@export var launch_scene: PackedScene = null
@export var ingame_scene: PackedScene = null
@export var main_menu_scene: PackedScene = null
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
    SignalBus.game3d_hud_addUI.connect(_on_addUI)
    SignalBus.back_to_menu.connect(_on_back_to_menu)
    SignalBus.to_ingame.connect(_on_ingame)

    if enable_debug && debug_scene: direct_change_scenes(debug_scene)
    else: direct_change_scenes(launch_scene)



func _on_addUI(packed: PackedScene):
    if gui_layer.get_child_count() == 1: gui_layer.get_child(0).queue_free() # Assumes each game state has 1 menu
    gui_layer.add_child(packed.instantiate())



func _on_back_to_menu():
    for child in gui_layer.get_children():
        child.queue_free()
    direct_change_scenes(main_menu_scene)



func _on_ingame():
    thread_change_scenes("uid://c5vsswhadftvh")



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
    if !_free_current_running(): return
    running_node.add_child(node)



func _free_current_running() -> bool: # Returns true if successfully removed, false otherwise
    if running_node.get_child_count() > 1:
        printerr("Running node should not have more than one child, multiple scenes were added to running")
        return false
    elif running_node.get_child_count() == 1:
        running_node.get_child(0).queue_free()
        return true
    else:
        return true