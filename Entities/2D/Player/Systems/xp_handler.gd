extends Node
class_name Player2DXPHandler

const starting_threshold: int = 5
const exponent: float = 1.25

@onready var player: Player2D = owner as Player2D

var level: int = 0
var collected_xp: int = 0
var required_xp: int = starting_threshold



func add_xp(amount: int):
    collected_xp += amount
    if collected_xp >= required_xp: _level_up()



func reset_levels():
    level = 0
    required_xp = starting_threshold
    collected_xp = 0



func _level_up():
    level += 1
    player.level_sfx.play()
    collected_xp -= required_xp
    required_xp = _get_next_threshold()
    SignalBus.game2d_player_levelup.emit.call_deferred() # Need to wait for next frame, doesn't open menu otherwise\
    SignalBus.hud_2d_requestSend.emit(1)
    await SignalBus.game2d_player_upgrade
    if collected_xp >= required_xp: _level_up()



func _get_next_threshold():
    return int(floor(starting_threshold * pow(level, exponent)))