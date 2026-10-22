extends Control
class_name HUD3D

@onready var game_over: GameOverScreen = $GameOver
@onready var night_trans: NightTransition = $NightTransition
@onready var chatlog_screen: StartScreen = $StartScreen



func _ready():
    SignalBus.game3d_start_intro.connect(_on_intro_request)
    SignalBus.game3d_end_night.connect(_on_end_request)
    SignalBus.game3d_gameover.connect(_on_gameover_request)



func _on_intro_request(night: int, from_start: bool):
    if !from_start:
        # Transition from game over to night intro
        SignalBus.transition_fade_hide.emit(1)
        await get_tree().create_timer(1).timeout

        # Play night intro
        SignalBus.transition_fade_show.emit(0)
        night_trans.play_intro(night)
        await night_trans.finished

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
        night_trans.play_intro(night)
        await night_trans.finished

        # Start the night
        SignalBus.game3d_start_night.emit()



func _on_end_request():
    night_trans.play_finish()
    await night_trans.finished

    SignalBus.transition_fade_hide.emit(0)
    SignalBus.game3d_start_nextNightSetup.emit()



func _on_gameover_request():
    game_over.show_screen()
    game_over.closed.connect(_handle_gameover_buttons, CONNECT_ONE_SHOT)



func _handle_gameover_buttons(to_ingame: bool):
    if to_ingame:
        SignalBus.transition_fade_hide.emit(1)
        await get_tree().create_timer(1).timeout
        SignalBus.game3d_reset_night.emit()
        game_over.hide_screen()
    else:
        SignalBus.transition_fade_hide.emit(1)
        await get_tree().create_timer(1).timeout
        SignalBus.back_to_menu.emit()
        game_over.hide_screen()