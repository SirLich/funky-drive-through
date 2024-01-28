extends Node2D

@export var border_left = 750
@export var border_right = 1700
@export var stacked_item : PackedScene
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
var move_speed = 0.1
@export var default_stream : AudioStream

@export var base : Node
@export var top : Node

@export var starting_item : ItemType
	
var last_stacked
func add_new_item(new_item : ItemType):
	if last_stacked is StackedItem:
		last_stacked.remote_transform_2d.remote_path = NodePath()
	
	var stream_to_use
	if new_item.audio:
		stream_to_use = new_item.audio
	else:
		stream_to_use = default_stream
	audio_stream_player.stream = stream_to_use
	audio_stream_player.play()
	
	var new_stacked = stacked_item.instantiate()
	new_stacked.follow = last_stacked
	add_child(new_stacked)
	new_stacked.configure_for_item(new_item)
	last_stacked = new_stacked
	last_stacked.remote_transform_2d.remote_path = top.get_path()


func _ready() -> void:
	last_stacked = base
	for i in range(1):
		add_new_item(starting_item)
	
var tween : Tween
func _process(delta: float) -> void:
	if tween:
		tween.kill()
	
	tween = get_tree().create_tween()
	tween.tween_property(base, "global_position:x", get_global_mouse_position().x, move_speed)
	base.global_position.x = clamp(base.global_position.x, border_left, border_right)

func _on_area_2d_body_entered(body: Node2D) -> void:
	Global.item_collected.emit(body.item)
	add_new_item(body.item)
	body.queue_free()
