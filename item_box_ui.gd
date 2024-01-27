extends TextureRect

@onready var texture_rect: TextureRect = $ItemBox/TextureRect
@onready var name_label: Label = $NameLabel
@onready var score_label: Label = $ScoreLabel


var item : RecipeItem

func set_count(n):
	score_label.text = str(n) + "/" + str(item.num)
	
func prepare_for_recipe(recipe_item : RecipeItem):
	self.item = recipe_item
	set_count(0)
	texture_rect.texture = recipe_item.type.icon
	name_label.text = recipe_item.type.name
