extends Node
@warning_ignore_start("unused_signal")

# Scene Signals
signal back_to_menu()

# Transition Signals
signal transition_fade_show(time: float)
signal transition_fade_hide(time: float)
signal transition_message_show(message: String)
signal transition_message_hide()
signal transition_message_finished()

# 2D HUD Signals
signal hud_2d_requestSend(base_chance: float)
signal hud_2d_sendMessage(message: String)

# 2D Game Signals
signal game2d_start(player: Player2D)
signal game2d_restart() # The signal to restart the 2D game, 3D game will also listen to this to know when to increment aggression on monster
signal game2d_player_levelup()
signal game2d_player_upgrade(type: UpgradeData.UpgradeType)
signal game2d_mechanic_ultraZoom(new_resolution: Vector2) # Night 3 gimmick (Night 2 gimmick is handled by computer)
signal game2d_mechanic_lowFPS(lower_fps: float) # Night 4 gimmick

# 3D HUD Signals
signal game3d_hud_addUI(hud_scene: PackedScene)
signal game3d_tutorial_play(sequence: Array[String])
signal game3d_tutorial_finished()
signal game3d_start_intro(night: int, from_start: bool) # For showing chatlog -> night intro (from_start = true skips chatlog)
signal game3d_start_night() # For notifying game handler to actually start the night and activate everything
signal game3d_end_night() # For when player survives to the end
signal game3d_reset_night() # For when player tries again
signal game3d_gameover() # For when player dies