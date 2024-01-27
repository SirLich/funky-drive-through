extends Node2D

@onready var items: HBoxContainer = $HUD/Items
@onready var recipe_label: Label = $HUD/RecipeLabel

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
		
	
