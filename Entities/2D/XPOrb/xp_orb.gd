extends Node2D
class_name XPOrb

const min_attract_speed: float = 1
const max_attract_speed: float = 60

signal xp_collected()

@export var attract_shape: CircleShape2D = null

@onready var audio_player: AudioStreamPlayer = $Collect
@onready var sprite: Sprite2D = $Sprite
@onready var animator: AnimationPlayer = $Animation
@onready var hitbox: Area2D = $Hitbox
@onready var attract_radius: Area2D = $AttractRadius

var attract_target: Node2D = null
var current_speed: float = 0
var max_distance: float

var worth: int = 0
var disabled: bool = true



func _ready():
    visible = true
    sprite.visible = false
    max_distance = attract_shape.radius
    hitbox.body_entered.connect(_on_hitbox_entered)
    attract_radius.body_entered.connect(_on_attract_entered)
    attract_radius.body_exited.connect(_on_attract_exited)



func drop_xp(global_pos: Vector2, value: int):
    disabled = false
    global_position = global_pos
    worth = value
    animator.play("spawn") # Will set visibility to true



func clear_orb():
    disabled = true
    sprite.visible = false



func _process(delta):
    if attract_target == null || disabled: return
    var factor = clamp(1 - (global_position.distance_squared_to(attract_target.global_position) / max_distance ** 2), 0.0, 1.0)
    current_speed = lerp(min_attract_speed, max_attract_speed, factor)
    global_position +=  global_position.direction_to(attract_target.global_position) * current_speed * delta



func _on_attract_entered(body: Node2D):
    if body is not Player2D: return
    attract_target = body



func _on_attract_exited(body: Node2D):
    if body is not Player2D: return
    attract_target = null
    current_speed = 0



func _on_hitbox_entered(body: Node2D):
    if body is not Player2D || disabled: return
    disabled = true
    sprite.visible = false
    Utils.play_pitch_shift_sfx(audio_player)
    (body as Player2D).collect_xp(worth)
    xp_collected.emit()