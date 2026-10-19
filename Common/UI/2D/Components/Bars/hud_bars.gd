extends Control

var player_ref: Player2D = null

@onready var hp_bar: ProgressBar = %HealthBar
@onready var xp_bar: ProgressBar = %XPBar


func _ready():
    visible = true
    SignalBus.game2d_start.connect(_start_listening)



func _process(_delta):
    if player_ref == null: return
    hp_bar.value = player_ref.health # Need to constantly update cause health regen exists



func _start_listening(player: Player2D):
    print("start listening")
    player_ref = player
    _update_healthbar()
    _update_xpBar()

    player_ref.killed.connect(_update_healthbar)
    player_ref.xp_collected.connect(_update_xpBar)
    SignalBus.game2d_player_levelup.connect(_update_xpBar)
    SignalBus.game2d_player_upgrade.connect(func(type): if type == UpgradeData.UpgradeType.HEALTH: _update_healthbar())



func _update_healthbar():
    hp_bar.max_value = player_ref.max_health
    hp_bar.value = player_ref.health



func _update_xpBar():
    xp_bar.max_value = player_ref.xp_handler.required_xp
    xp_bar.value = player_ref.xp_handler.collected_xp