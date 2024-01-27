extends Node2D

@onready var items: HBoxContainer = $HUD/Items
@onready var recipe_label: Label = $HUD/RecipeLabel
@onready var dropper: Dropper = $Dropper
@onready var hud: Control = $HUD

@export var item_box_ui : PackedScene
@export var default_recipe : Recipe


# Current recipe
var recipe

func on_item_collected(item : ItemType):
	print('test')

func _ready() -> void:
	prepare_for_recipe(default_recipe)
	Global.item_collected.connect(on_item_collected)
	
func prepare_for_recipe(recipe : Recipe):
	self.recipe = recipe
	hud.prepare_for_recipe(recipe)
	dropper.prepare_for_recipe(recipe)
		
	
