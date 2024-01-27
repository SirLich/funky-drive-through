extends Node2D

@onready var items: HBoxContainer = $HUD/Items
@onready var recipe_label: Label = $HUD/RecipeLabel
@onready var dropper: Dropper = $Dropper

@export var item_box_ui : PackedScene
@export var default_recipe : Recipe

func _ready() -> void:
	prepare_for_recipe(default_recipe)
	
func prepare_for_recipe(recipe : Recipe):
	recipe_label.text = recipe.name
	for c in items.get_children():
		items.remove_child(c)
		c.queue_free()
		
	for ingredient in recipe.ingredients:
		var new_item = item_box_ui.instantiate()
		items.add_child(new_item)
		new_item.prepare_for_recipe(ingredient)
		
	dropper.prepare_for_recipe(recipe)
		
	
