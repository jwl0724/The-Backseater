extends AudioStreamPlayer3D
class_name GameSoundsFunnel

var capture:AudioEffectCapture
var playback:AudioStreamGeneratorPlayback

var do_funnel: bool = true



func _ready():
	var capture_index = AudioServer.get_bus_index(Constants.AudioBus.Game2D)
	capture = AudioServer.get_bus_effect(capture_index, 0)
	play()
	playback = get_stream_playback()
	fill_buffer()



func disable_funnel(disable: bool):
	do_funnel = disable
	if disable: stop()
	else: play()



func _process(_delta: float) -> void:
	if !do_funnel: return
	fill_buffer()



func fill_buffer():
	var playback_available = playback.get_frames_available()
	var capture_available = capture.get_frames_available()

	if capture_available <= 0: return

	while playback_available > capture_available:
		var buffer = capture.get_buffer(capture_available)
		playback.push_buffer(buffer)

		playback_available -= capture_available
		if playback_available <= 0:
			break
		capture_available = capture.get_frames_available()
		if capture_available <= 0:
			break