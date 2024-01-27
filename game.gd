extends Node2D

@onready var items: HBoxContainer = $HUD/Items
@onready var recipe_label: Label = $HUD/RecipeLabel
@onready var dropper: Dropper = $Dropper
@onready var hud: Control = $HUD
@onready var countdown_label: Label = $CenterContainer/CountdownLabel
@onready var center_container: CenterContainer = $CenterContainer

@export var end_scene : PackedScene
@export var item_box_ui : PackedScene

var is_tutorial = true

# Current recipe
var recipe : Recipe
var food_counts = {}
var bad_count = 0

@onready var tutorial: Control = $Tutorial
		
func is_food_good(check_type : ItemType):
	for item in recipe.ingredients:
		if item.type == check_type:
			if food_counts[check_type] < item.num:
				food_counts[check_type] += 1
				return true
			else:
				# Overfilled!
				return false
	return false

func end_round():
	get_tree().call_group('dropped_item', 'queue_free')
	
	$HUD/FinishScreen.visible = true
	get_tree().paused = true
	
func on_item_collected(item : ItemType):
	if item == Global.top_bun:
		Global.bun_collected.emit()
		await get_tree().create_timer(0.15).timeout
		end_round()
	else:
		if is_food_good(item):
			Global.good_item_collected.emit(item, food_counts[item])
		else:
			bad_count += 1
			Global.bad_item_collected.emit(item, bad_count)

func _ready() -> void:
	prepare_for_recipe(Global.get_recipe())
	Global.item_collected.connect(on_item_collected)
	
func start_dropping():
	dropper.prepare_for_recipe(recipe)
	
func prepare_for_recipe(recipe : Recipe):
	self.recipe = recipe
	hud.prepare_for_recipe(recipe)
	
	# Just setup recipe stuff
	food_counts.clear()
	bad_count = 0
	for item in Global.all_items:
		food_counts[item] = 0
	food_counts[Global.top_bun] = 0
	
	for i in range(3,0,-1):
		countdown_label.text = str(i)
		center_container.scale = Vector2(1,1)
		await get_tree().create_tween().tween_property(center_container, "scale", Vector2(0,0), 0.5).finished
	
	countdown_label.text = "GO!"
	center_container.scale = Vector2(1,1)
	await get_tree().create_tween().tween_property(center_container, "scale", Vector2(0,0), 0.5).finished
		
	start_dropping()
	
