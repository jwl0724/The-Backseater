extends Control
class_name LoadingScreen

signal loading_finished(scene: Node)

var loading_uid: String = ""
var scene_ready: bool = false
var load_tween: Tween = null



func _ready():
	SignalBus.transition_fade_show.emit(0)



func _process(_delta: float):
	if scene_ready || loading_uid == "": return

	var status = ResourceLoader.load_threaded_get_status(loading_uid)
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		scene_ready = true
		_start_off_thread_instantiate(ResourceLoader.load_threaded_get(loading_uid))



func thread_load_scene(scene_uid: String):
	loading_uid = scene_uid
	ResourceLoader.load_threaded_request(scene_uid)



func _start_off_thread_instantiate(packed: PackedScene):
	var thread = Thread.new()
	thread.start(_thread_loading.bind(packed, thread))



func _thread_loading(packed: PackedScene, thread: Thread):
	var scene = packed.instantiate()
	close_loading_screen.call_deferred(scene, thread)



func close_loading_screen(loaded_scene: Node, thread: Thread):
	thread.wait_to_finish()

	if load_tween && load_tween.is_running(): load_tween.kill()
	load_tween = create_tween()
	load_tween.tween_callback(loading_finished.emit.bind(loaded_scene))
	load_tween.play()