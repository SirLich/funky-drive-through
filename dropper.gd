extends Node2D
class_name Dropper

@export var max_width = 400
@export var drop_time_min = 0.5
@export var drop_time_max = 1.5
@export var item_scene : PackedScene

var good_items : Array[ItemType]
var bad_items : Array[ItemType]

@export var bun_chance = 0.1
@export var good_chance = 0.3

func prepare_for_recipe(recipe: Recipe):
	good_items.clear()
	bad_items.clear()
	
	for c in recipe.ingredients:
		good_items.append(c.type)
	
	for c in Global.all_items:
		if c not in good_items:
			bad_items.append(c)
	
	
func _ready() -> void:
	randomize_drop_time()

func _process(delta: float) -> void:
	pass

func randomize_drop_time():
	$Timer.wait_time = randf_range(drop_time_min, drop_time_max)

func get_random_item():
	if randf() < bun_chance:
		return Global.top_bun
		
	if randf() < good_chance:
		return good_items.pick_random()

	return bad_items.pick_random()
	
func drop_item():
	var item = get_random_item()
	var new_drop = item_scene.instantiate()
	add_child(new_drop)
	new_drop.configure_for_item(item)
	new_drop.global_position.y = self.global_position.y
	new_drop.global_position.x = self.global_position.x + randi_range(0, max_width)
	
func _on_timer_timeout() -> void:
	randomize_drop_time()
	drop_item()

