extends Button
class_name UpgradeSelection

signal upgrade_selected(this: UpgradeSelection)

@onready var upgrade_icon: TextureRect = %Icon
@onready var upgrade_name: Label = %Name
@onready var upgrade_desc: Label = %Description

var type: UpgradeData.UpgradeType = UpgradeData.UpgradeType.DAMAGE



func _ready():
    pressed.connect(upgrade_selected.emit.bind(self))



func populate_data(data: UpgradeData):
    type = data.upgrade_type
    upgrade_icon.texture = data.upgrade_icon
    upgrade_desc.text = data.upgrade_description
    upgrade_name.text = data.upgrade_display_title