extends Camera3D
class_name Player3D

enum View { LEFT, RIGHT, FRONT, GAME }

@export var hud_scene: PackedScene = null

@export var computer: RoomComputer = null
@export var left_view_node: Node3D = null
@export var right_view_node: Node3D = null
@export var center_view_node: Node3D = null
@export var game_view_node: Node3D = null
@export var dead_view_node: Node3D = null

var is_alive: bool = true
var look_tween: Tween = null
var current_view: View = View.FRONT



func _ready():
	SignalBus.game3d_hud_addUI.emit.call_deferred(hud_scene)



func reset_player():
	is_alive = true
	current_view = View.FRONT
	position = center_view_node.position
	rotation = center_view_node.rotation



func kill(kill_angle: View):
	is_alive = false
	var view_node = left_view_node if kill_angle == View.LEFT else right_view_node # Only door or window
	var neck_angle = view_node.rotation
	neck_angle.z = deg_to_rad(-120) if kill_angle == View.LEFT else deg_to_rad(120)
	var dead_position := dead_view_node.position if kill_angle == View.LEFT else dead_view_node.position + Vector3.LEFT * 5
	var dead_angle := dead_view_node.rotation if kill_angle == View.LEFT else dead_view_node.rotation * -1

	var t = create_tween()
	t.tween_property(self, "position", view_node.position, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	t.parallel().tween_property(self, "rotation", view_node.rotation, 0.18).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	t.tween_interval(0.2)
	t.tween_property(self, "rotation", neck_angle, 0.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	t.tween_interval(0.1)
	t.tween_property(self, "position", dead_position, 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	t.parallel().tween_property(self, "rotation", dead_angle, 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	t.play()



func _input(event: InputEvent):
	if event is not InputEventKey: return
	if !is_alive: return

	if current_view != View.GAME:
		if event.is_action_pressed(Constants.Controls.Left): goto_view(_get_next_view(Constants.Controls.Left))
		elif event.is_action_pressed(Constants.Controls.Right): goto_view(_get_next_view(Constants.Controls.Right))
		elif event.is_action_pressed(Constants.Controls.Tab):
			computer.enable_inputs(current_view == View.FRONT)
			goto_view(_get_next_view(Constants.Controls.Tab))

	else:
		if event.is_action_pressed(Constants.Controls.Tab):
			computer.enable_inputs(false)
			goto_view(_get_next_view(Constants.Controls.Tab))



func goto_view(view_type: View):
	if view_type == current_view: return
	var view_node: Node3D
	match view_type:
		View.LEFT: view_node = left_view_node
		View.RIGHT: view_node = right_view_node
		View.FRONT: view_node = center_view_node
		View.GAME: view_node = game_view_node
	current_view = view_type

	var over_shoot: Vector3 = view_node.rotation
	if view_node.position.x < position.x: over_shoot.y += deg_to_rad(0.5)
	elif view_node.position.x > position.x: over_shoot.y -= deg_to_rad(0.5)

	if look_tween && look_tween.is_running(): look_tween.kill()
	look_tween = create_tween()
	look_tween.tween_property(self, "position", view_node.position, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	look_tween.parallel().tween_property(self, "rotation", over_shoot, 0.15).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	look_tween.tween_property(self, "rotation", view_node.rotation, 0.03).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	look_tween.play()



func _get_next_view(action: String) -> View:
	if current_view == View.LEFT:
		if action == Constants.Controls.Left: return current_view
		else: return View.FRONT

	elif current_view == View.RIGHT:
		if action == Constants.Controls.Right: return current_view
		else: return View.FRONT

	elif current_view == View.FRONT:
		if action == Constants.Controls.Left: return View.LEFT
		elif action == Constants.Controls.Right: return View.RIGHT
		else: return View.GAME # The tab button

	else: # Code path for GAME view
		if action == Constants.Controls.Tab: return View.FRONT
		else: return current_view