extends ProgressBar
class_name EnemyHealthBar

@onready var enemy: Enemy2D = owner as Enemy2D



func _ready():
    _update_values()
    enemy.respawned.connect(_update_values)
    enemy.damaged.connect(_update_values)
    enemy.killed.connect(_update_values)



func _update_values():
    max_value = enemy.max_health
    value = enemy.health