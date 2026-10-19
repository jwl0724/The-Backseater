extends Node2D
class_name XPOrb

const min_attract_speed: float = 1
const max_attract_speed: float = 60

@export var attract_shape: CircleShape2D = null

@onready var hitbox: Area2D = $Hitbox
@onready var attract_radius: Area2D = $AttractRadius

var attract_target: Node2D = null
var current_speed: float = 0
var max_distance: float

var worth: int = 0



func _ready():
    max_distance = attract_shape.radius
    hitbox.body_entered.connect(_on_hitbox_entered)
    attract_radius.body_entered.connect(_on_attract_entered)
    attract_radius.body_exited.connect(_on_attract_exited)



func set_xp_value(value: int):
    worth = value



func _process(delta):
    if attract_target == null: return
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
    if body is not Player2D: return
    print("TODO: Add some sort of function on player to collect this thing and add it to XP")