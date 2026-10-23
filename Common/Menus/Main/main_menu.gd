extends Control


@onready var play_button: Button = %Play
@onready var credits_button: Button = %Credits
@onready var quit_button: Button = %Quit
@onready var credits: CreditsMenu = $CreditsMenu



func _ready():
    SignalBus.transition_fade_show.emit(1)
    if OS.has_feature("web"): quit_button.visible = false



func _on_play():
    SignalBus.transition_fade_hide.emit(2)
    print("TODO: Make the actual game and connect it here")



func _on_credits():
    credits.show_credits()



func _on_quit():
    SignalBus.transition_fade_hide.emit(2)
    get_tree().quit()