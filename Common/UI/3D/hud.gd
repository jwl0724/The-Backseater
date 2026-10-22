extends Control
class_name HUD3D

@onready var game_over: GameOverScreen = $GameOver
@onready var night_intro: NightIntro = $NightIntro
@onready var chatlog_screen: StartScreen = $StartScreen



func _ready():
    SignalBus.game3d_start_intro.connect(_on_intro_request)



func _on_intro_request(night: int, from_start: bool):
    if !from_start:
        night_intro.play_intro(night)
        await night_intro.finished
        SignalBus.game3d_start_night.emit()