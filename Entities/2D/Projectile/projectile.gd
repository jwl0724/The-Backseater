extends Area2D
class_name Projectile

const lifespan: float = 5

signal despawned()

@onready var sprite: Sprite2D = $Sprite
@onready var sfx: AudioStreamPlayer = $SFX
@onready var screen_notifier: VisibleOnScreenNotifier2D = $ScreenNotifier

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
        area_entered.connect(_on_area_entered) # Needed since hitbox and collision box aren't the same



func shoot(direction: Vector2, move_speed: float):
    visible = true
    is_active = true
    global_position = projectile_owner.global_position
    target_direction = direction
    projectile_speed = move_speed
    sprite.rotation = Vector2.RIGHT.angle_to(target_direction)
    sfx.play()



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
        (body as Player2D).hurt_via_projectile(self)
    elif body is Enemy2D && collision_layer == Constants.PhysLayers.Player:
        (body as Enemy2D).hurt_enemy(self)



func _on_area_entered(area: Area2D):
    if !is_active: return
    if !area.get_collision_layer_value(roundi(log(Constants.PhysLayers.Player) / log(2)) + 1): return
    var player = area.owner as Player2D # Works because player will never be instantiated through code
    player.hurt_via_projectile(self)
    despawn() # Despawn enemy projectiles if they hit player