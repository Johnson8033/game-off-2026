
extends Node

@export_file("*.json") var conversation_path: String
@export var player: ConversationPlayer


func _ready() -> void:
	player.line_changed.connect(_on_line_changed)
	player.conversation_finished.connect(_on_conversation_finished)

	var conversation := ConversationLoader.load_conversation(
		conversation_path
	)

	if not conversation.is_empty():
		player.start(conversation)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not event.is_echo():
		player.advance()


func _on_line_changed(line: Dictionary) -> void:
	print(line["speaker"], ": ", line["text"])


func _on_conversation_finished() -> void:
	print("Conversation finished!")
