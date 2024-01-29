extends Control

@onready var recipe_label: Label = $Shift/RecipeLabel
@onready var items: HBoxContainer = $Shift/Items
@onready var mistake_label: Label = $Shift/Mistakes/MistakeLabel

@export var item_box_ui : PackedScene
var recipe

func get_box_by_type(item : ItemType) -> ItemBoxUI:
	for child in items.get_children():
		if child.item.type == item:
			return child
	return null
	

func on_bad_item_collected(item: ItemType, count):
	mistake_label.text = str(count) + "/" + str(recipe.allowed_mistakes)
	
func on_good_item_collected(item : ItemType, count):
	var box_child = get_box_by_type(item)
	if box_child:
		box_child.set_count(count)
	
func prepare_for_recipe(recipe : Recipe):
	mistake_label.text =  "0/" + str(recipe.allowed_mistakes)
	self.recipe = recipe
	recipe_label.text = recipe.name
	for c in items.get_children():
		items.remove_child(c)
		c.queue_free()
		
	for ingredient in recipe.ingredients:
		var new_item = item_box_ui.instantiate()
		items.add_child(new_item)
		new_item.prepare_for_recipe(ingredient)
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.good_item_collected.connect(on_good_item_collected)
	Global.bad_item_collected.connect(on_bad_item_collected)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
