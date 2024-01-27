extends Node2D
class_name Animal

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var happy_sound: AudioStreamPlayer = $HappySound
@onready var angry_sound: AudioStreamPlayer = $AngrySound

var end_screen = false
var happy = false

func become_angry():
	angry_sound.play()
	animation_player.play("neutral")
	animation_player.play("angry")
	animation_player.animation_finished.connect(on_animation_finished, CONNECT_ONE_SHOT)

func become_neutral():
	animation_player.play("neutral")

func become_happy():
	happy_sound.play()
	animation_player.play("neutral")
	animation_player.play("happy")
	animation_player.animation_finished.connect(on_animation_finished, CONNECT_ONE_SHOT)
	
func on_animation_finished(anim_name):
	if end_screen:
		if happy:
			become_happy()
		else:
			become_angry()
	become_neutral()

func on_good_item_collected(item_type, count):
	become_happy()
	
func on_reached_end_screen(did_win : bool):
	end_screen = true
	if did_win:
		happy = true
		become_happy()
	else:
		become_angry()
		
		
func on_bad_item_collected(item_type : ItemType, count: int):
	become_angry()

func _ready() -> void:
	become_neutral()
	Global.bad_item_collected.connect(on_bad_item_collected)
	Global.good_item_collected.connect(on_good_item_collected)
	Global.reached_end_screen.connect(on_reached_end_screen)
	
func _process(delta: float) -> void:
	pass
