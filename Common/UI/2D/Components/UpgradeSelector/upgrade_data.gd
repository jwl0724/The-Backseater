extends Resource
class_name UpgradeData

enum UpgradeType {
    DAMAGE,
    MOVE_SPEED,
    HEALTH,
    HEALTH_REGEN,
    ATTACK_SPEED,
    PROJECTILE_COUNT
}

@export var upgrade_type: UpgradeType = UpgradeType.DAMAGE
@export var upgrade_display_title: String = "" ## What the game will display the upgrade as in the UI
@export var upgrade_icon: Texture2D = null ## Icon used for the upgrade type
@export var upgrade_description: String = "" ## Description of the upgrade type