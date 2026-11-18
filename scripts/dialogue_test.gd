extends Node

@export_file("*.json") var conversation_path: String


func _ready() -> void:
	var conversation := ConversationLoader.load_conversation(
		conversation_path
	)

	for line in conversation.get("lines", []):
		print(line["speaker"], ": ", line["text"])
