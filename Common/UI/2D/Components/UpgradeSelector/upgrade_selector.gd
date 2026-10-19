extends Control

@export var data_set: Array[UpgradeData] = []

@onready var option1: UpgradeSelection = %Selection1
@onready var option2: UpgradeSelection = %Selection2
@onready var option3: UpgradeSelection = %Selection3



func _ready():
    visible = false
    option1.upgrade_selected.connect(_on_selected)
    option2.upgrade_selected.connect(_on_selected)
    option3.upgrade_selected.connect(_on_selected)
    SignalBus.game2d_player_levelup.connect(_open_upgrades)



func _open_upgrades():
    visible = true
    var dupe = data_set.duplicate()
    dupe.shuffle()
    option1.populate_data(dupe.pop_front())
    option2.populate_data(dupe.pop_front())
    option3.populate_data(dupe.pop_front())



func _on_selected(option: UpgradeSelection):
    SignalBus.game2d_player_upgrade.emit(option.type)
    visible = false