class_name Utils



static func play_pitch_shift_sfx(player: AudioStreamPlayer, lower: float = 0.8, upper: float = 1.2):
    player.pitch_scale = randf_range(lower, upper)
    player.play()
    await player.finished
    player.pitch_scale = 1