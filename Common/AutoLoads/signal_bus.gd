extends Node
@warning_ignore_start("unused_signal")

# Transition Signals
signal transition_fade_show(time: float)
signal transition_fade_hide(time: float)
signal transition_message_show(message: String)
signal transition_message_hide()
signal transition_message_finished()

# 2D HUD Signals
signal hud_2d_sendMessage(message: String)

# 2D Game Signals
signal game2d_start(player: Player2D)
signal game2d_restart() # The signal to restart the 2D game, 3D game will also listen to this to know when to increment aggression on monster
signal game2d_player_levelup()
signal game2d_player_upgrade(type: UpgradeData.UpgradeType)
signal game2d_mechanic_noAudio() # Night 2 gimmick
signal game2d_mechanic_lowResolution(new_resolution: Vector2) # Night 3 gimmick
signal game2d_mechanic_lowFPS(lower_fps: float) # Night 4 gimmick

# 3D HUD Signals
signal game3d_hud_addUI(hud_scene: PackedScene)
signal game3d_tutorial_play(sequence: Array[String])
signal game3d_tutorial_finished()