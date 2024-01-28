extends Node2D

@onready var fail_sound: AudioStreamPlayer = $Sounds/FailSound
@onready var success_sound: AudioStreamPlayer = $Sounds/SuccessSound

@onready var ui_animation: AnimationPlayer = $HUD/UIAnimation


@onready var items: HBoxContainer = $HUD/Items
@onready var recipe_label: Label = $HUD/RecipeLabel
@onready var dropper: Dropper = $Dropper
@onready var hud: Control = $HUD
@onready var countdown_label: Label = $CenterContainer/CountdownLabel
@onready var center_container: CenterContainer = $CenterContainer
@onready var finish_screen: Control = $HUD/FinishScreen
@onready var spawn_position: Marker2D = $SpawnPosition

@export var win_scene : PackedScene

@onready var success_text: Label = $HUD/FinishScreen/ColorRect/VBoxContainer/SuccessText
@onready var goal_label: Label = $HUD/FinishScreen/ColorRect/VBoxContainer/GoalRow/GoalLabel
@onready var mistakes_label: Label = $HUD/FinishScreen/ColorRect/VBoxContainer/MistakesRow/MistakesLabel


@onready var goal_image_fail: TextureRect = $HUD/FinishScreen/ColorRect/VBoxContainer/GoalRow/GoalImageFail
@onready var goal_image_ok: TextureRect = $HUD/FinishScreen/ColorRect/VBoxContainer/GoalRow/GoalImageOK
@onready var mistakes_image_fail: TextureRect = $HUD/FinishScreen/ColorRect/VBoxContainer/MistakesRow/MistakesImageFail
@onready var mistakes_image_ok: TextureRect = $HUD/FinishScreen/ColorRect/VBoxContainer/MistakesRow/MistakesImageOK

@onready var finish_button_text: Label = $HUD/FinishScreen/ColorRect/FinishButton/FinishButtonText



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
	return total
	
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
	return goals_pass() and mistakes_pass()
	
func goals_pass():
	return good_count == calculate_good_goal()

func mistakes_pass():
	return bad_count <= recipe.allowed_mistakes
	
func end_round():
	get_tree().call_group('dropped_item', 'queue_free')
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.is_pending_finish = false
	finish_screen.visible = true
	Global.reached_end_screen.emit(did_win())
	if did_win():
		success_sound.play()
		finish_button_text.text = "Next"
		success_text.text = "Success!"
	else:
		fail_sound.play()
		finish_button_text.text = "Restart"
		success_text.text = "Failure!"
	
	goal_label.text = "Goals: " + str(good_count) + "/" + str(calculate_good_goal())
	mistakes_label.text = "Mistakes: " + str(bad_count) + "/" + str(recipe.allowed_mistakes)
	
	if goals_pass():
		goal_image_fail.visible = false
		goal_image_ok.visible = true
	else:
		goal_image_fail.visible = true
		goal_image_ok.visible = false
	
	if mistakes_pass():
		mistakes_image_fail.visible = false
		mistakes_image_ok.visible = true
	else:
		mistakes_image_fail.visible = true
		mistakes_image_ok.visible = false
		
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
	if goals_pass():
		Global.is_pending_finish = true

func _ready() -> void:
	finish_screen.visible = false
	prepare_for_recipe(Global.get_recipe())
	Global.item_collected.connect(on_item_collected)
	
func start_dropping():
	dropper.prepare_for_recipe(recipe)
	
func prepare_for_recipe(recipe : Recipe):
	Global.is_pending_finish = false
	self.recipe = recipe
	hud.prepare_for_recipe(recipe)
	
	print(recipe.gravity)
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, recipe.gravity)
	var new_character = recipe.character.instantiate()
	spawn_position.add_child(new_character)
	
	# Just setup recipe stuff
	food_counts.clear()
	bad_count = 0
	good_count = 0
	for item in Global.all_items:
		food_counts[item] = 0
	food_counts[Global.top_bun] = 0
	
	ui_animation.stop(true)
	ui_animation.play("begin")
	
	await ui_animation.animation_finished
	for i in range(3,0,-1):
		countdown_label.text = str(i)
		center_container.scale = Vector2(1,1)
		await get_tree().create_tween().tween_property(center_container, "scale", Vector2(0,0), 0.5).finished
	
	countdown_label.text = "GO!"
	center_container.scale = Vector2(1,1)
	await get_tree().create_tween().tween_property(center_container, "scale", Vector2(0,0), 0.5).finished
		
	start_dropping()
	


func _on_finish_button_pressed() -> void:
	if did_win():
		Global.current_recipe += 1
		
		if Global.current_recipe >= Global.recipes.size():
			get_tree().change_scene_to_file("res://menu.tscn")
		else:
			get_tree().change_scene_to_file("res://game.tscn")
	else:
		get_tree().change_scene_to_file("res://game.tscn")
