extends Node2D

@onready var items: HBoxContainer = $HUD/Items
@onready var recipe_label: Label = $HUD/RecipeLabel
@onready var dropper: Dropper = $Dropper
@onready var hud: Control = $HUD
@onready var countdown_label: Label = $CenterContainer/CountdownLabel
@onready var center_container: CenterContainer = $CenterContainer
@onready var finish_screen: Control = $HUD/FinishScreen

@onready var success_text: Label = $HUD/FinishScreen/ColorRect/VBoxContainer/SuccessText
@onready var goal_label: Label = $HUD/FinishScreen/ColorRect/VBoxContainer/GoalRow/GoalLabel
@onready var mistakes_label: Label = $HUD/FinishScreen/ColorRect/VBoxContainer/MistakesRow/MistakesLabel


@export var end_scene : PackedScene
@export var item_box_ui : PackedScene

var is_tutorial = true

# Current recipe
var recipe : Recipe
var food_counts = {}
var bad_count = 0
var good_count = 0

@onready var tutorial: Control = $Tutorial

func calculate_good_goal():
	var total = 0
	for item in recipe.ingredients:
		total += item.num
	
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

func did_win():
	return true
	
func end_round():
	get_tree().call_group('dropped_item', 'queue_free')
	
	finish_screen.visible = true
	if did_win():
		success_text.text = "Success!"
	else:
		success_text.text = "Failure!"
	
	goal_label.text = "Goals: " + str(good_count) + "/" + str(calculate_good_goal())
	mistakes_label.text = "Mistakes: " + str(bad_count) + "/" + str(recipe.allowed_mistakes)
	get_tree().paused = true
	
func on_item_collected(item : ItemType):
	if item == Global.top_bun:
		Global.bun_collected.emit()
		await get_tree().create_timer(0.15).timeout
		end_round()
	else:
		if is_food_good(item):
			Global.good_item_collected.emit(item, food_counts[item])
			good_count += 1
		else:
			bad_count += 1
			Global.bad_item_collected.emit(item, bad_count)

func _ready() -> void:
	finish_screen.visible = false
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
	good_count = 0
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
	
