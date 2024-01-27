extends Node2D

@onready var items: HBoxContainer = $HUD/Items
@onready var recipe_label: Label = $HUD/RecipeLabel
@onready var dropper: Dropper = $Dropper
@onready var hud: Control = $HUD

@export var item_box_ui : PackedScene
@export var default_recipe : Recipe


# Current recipe
var recipe : Recipe
var food_counts = {}

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
	
func on_item_collected(item : ItemType):
	if is_food_good(item):
		Global.good_item_collected.emit(item, food_counts[item])
	else:
		Global.bad_item_collected.emit(item, food_counts[item])

func _ready() -> void:
	prepare_for_recipe(default_recipe)
	Global.item_collected.connect(on_item_collected)
	
func prepare_for_recipe(recipe : Recipe):
	self.recipe = recipe
	hud.prepare_for_recipe(recipe)
	dropper.prepare_for_recipe(recipe)
	
	# Just setup recipe stuff
	food_counts.clear()
	for item in Global.all_items:
		food_counts[item] = 0
		
	
