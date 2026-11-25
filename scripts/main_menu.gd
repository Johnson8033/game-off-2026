extends Control

@export var play_button: Button
@export var credits_button: Button
@export var quit_button: Button
@export var credits_label: Label


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	credits_label.hide()

	if OS.has_feature("web"):
		quit_button.hide()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_credits_pressed() -> void:
	credits_label.visible = not credits_label.visible


func _on_quit_pressed() -> void:
	get_tree().quit()
