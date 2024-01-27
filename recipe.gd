extends Resource
class_name Recipe

@export var name : String
@export var ingredients : Array[RecipeItem]
@export var allowed_mistakes : int
@export var good_chance = 0.5
@export var bun_chance = 0.2
