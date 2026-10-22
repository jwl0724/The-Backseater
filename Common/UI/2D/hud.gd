extends Control
class_name HUD2D

@onready var msg_window: Control = $MessageWindow
@onready var msg_trans: Control = $MessageTransition
@onready var hud: Control = $HudBars
@onready var cursor: Sprite2D = $Cursor



func show_hud():
    cursor.visible = true
    hud.visible = true
    msg_window.visible = true



func hide_hud():
    cursor.visible = false
    hud.visible = false
    msg_window.visible = false