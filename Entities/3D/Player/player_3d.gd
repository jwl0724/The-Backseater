extends Camera3D
class_name Player3D

enum View { LEFT, RIGHT, CENTER, GAME }

@export var left_view_node: Node3D = null
@export var right_view_node: Node3D = null
@export var center_view_node: Node3D = null
@export var game_view_node: Node3D = null

var look_tween: Tween = null



func goto_view(view_type: View):
    var view_node: Node3D
    match view_type:
        View.LEFT: view_node = left_view_node
        View.RIGHT: view_node = right_view_node
        View.CENTER: view_node = center_view_node
        View.GAME: view_node = game_view_node

    var over_shoot: Vector3 = view_node.rotation
    if view_node.position.x < position.x: over_shoot.y += deg_to_rad(0.5)
    elif view_node.position.x > position.x: over_shoot.y -= deg_to_rad(0.5)

    if look_tween && look_tween.is_running(): look_tween.kill()
    look_tween = create_tween()
    look_tween.tween_property(self, "position", view_node.position, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
    look_tween.parallel().tween_property(self, "rotation", over_shoot, 0.15).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
    look_tween.tween_property(self, "rotation", view_node.rotation, 0.03).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
    look_tween.play()