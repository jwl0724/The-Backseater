extends Area2D
class_name Projectile

signal despawned()

@onready var sprite: Sprite2D = $Sprite
@onready var sfx: AudioStreamPlayer2D = $SFX
@onready var screen_notifier: VisibleOnScreenNotifier2D = $ScreenNotifier

var lifespan: float = 5
var projectile_owner: Node2D = null
var projectile_speed: float = 0
var target_direction = Vector2.ZERO

var time_alive: float = 0
var is_active: bool = false



func _ready():
    visible = false
    screen_notifier.screen_exited.connect(despawn)
    body_entered.connect(_on_body_entered)



func set_data(texture: Texture2D, fireSFX: AudioStream):
    sprite.texture = texture
    sfx.stream = fireSFX



func set_shooter(node: Node2D):
    projectile_owner = node
    if node is not CollisionObject2D: return
    var entity = node as CollisionObject2D
    if entity.get_collision_layer_value(roundi(log(Constants.PhysLayers.Player) / log(2)) + 1):
        collision_layer = Constants.PhysLayers.Player
        collision_mask = Constants.PhysLayers.Enemy
    else:
        collision_layer = Constants.PhysLayers.Enemy
        collision_mask = Constants.PhysLayers.Player



func shoot(target_location: Vector2, move_speed: float):
    visible = true
    is_active = true
    global_position = projectile_owner.global_position
    target_direction = global_position.direction_to(target_location)
    projectile_speed = move_speed
    sprite.rotation = Vector2.RIGHT.angle_to(target_direction)



func despawn():
    is_active = false
    visible = false
    time_alive = 0
    despawned.emit()



func _process(delta):
    if !visible: return

    # Handle movement
    global_position += target_direction * projectile_speed * delta

    # Handle timer
    time_alive += delta
    if time_alive >= lifespan: despawn()



func _on_body_entered(body: Node2D):
    if !is_active: return
    if body is Player2D && collision_layer == Constants.PhysLayers.Enemy:
        print("TODO: make some damage function on player and call it here")
    elif body is Enemy2D && collision_layer == Constants.PhysLayers.Player:
        print("TODO: make some damage function on enemy and call it here")