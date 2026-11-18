class_name ConversationLoader
extends RefCounted


static func load_conversation(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_error("Conversation file not found: " + path)
		return {}

	var content := FileAccess.get_file_as_string(path)
	var data = JSON.parse_string(content)

	if not data is Dictionary:
		push_error("Invalid conversation JSON: " + path)
		return {}

	if not data.has("lines") or not data["lines"] is Array:
		push_error("Conversation missing lines: " + path)
		return {}

	return data
