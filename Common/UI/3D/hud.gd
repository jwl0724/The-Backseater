extends Control
class_name HUD3D

@onready var game_over: GameOverScreen = $GameOver
@onready var night_intro: NightIntro = $NightIntro
@onready var chatlog_screen: StartScreen = $StartScreen



func _ready():
    SignalBus.game3d_start_intro.connect(_on_intro_request)



func _on_intro_request(night: int, from_start: bool):
    if !from_start:
        # Transition from game over to night intro
        SignalBus.transition_fade_hide.emit(1)
        await get_tree().create_timer(1).timeout

        # Play night intro
        SignalBus.transition_fade_show.emit(0)
        night_intro.play_intro(night)
        await night_intro.finished

        # Start the night
        SignalBus.game3d_start_night.emit()

    else:
        # Show chatlog
        chatlog_screen.show_chatlog(night)
        await chatlog_screen.finished

        # Transition from chatlog to night screen
        SignalBus.transition_fade_hide.emit(1)
        await get_tree().create_timer(1).timeout
        chatlog_screen.visible = false

        # Play the night intro
        SignalBus.transition_fade_show.emit(0)
        night_intro.play_intro(night)
        await night_intro.finished

        # Start the night
        SignalBus.game3d_start_night.emit()