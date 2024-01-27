extends VBoxContainer
class_name ItemBoxUI

@onready var texture_rect: TextureRect = $ItemBox/TextureRect
@onready var name_label: Label = $NameLabel
@onready var score_label: Label = $ScoreLabel


var item : RecipeItem

func set_count(n):
	score_label.text = str(n) + "/" + str(item.num)

func _ready() -> void:
	pass
	
func prepare_for_recipe(recipe_item : RecipeItem):
	item = recipe_item
	set_count(0)
	
	# TODO: Consider scene support here!
	texture_rect.texture = item.type.icon
	texture_rect.modulate = item.type.color
	texture_rect.scale *= item.type.scale_factor
	name_label.text = item.type.name

