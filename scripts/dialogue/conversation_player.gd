class_name ConversationPlayer
extends Node

signal line_changed(line: Dictionary)
signal conversation_finished

var _lines: Array = []
var _next_index: int = 0
var _is_playing: bool = false


func start(conversation: Dictionary) -> void:
	_lines = conversation.get("lines", [])
	_next_index = 0
	_is_playing = not _lines.is_empty()

	if _is_playing:
		advance()


func advance() -> void:
	if not _is_playing:
		return

	if _next_index >= _lines.size():
		_is_playing = false
		conversation_finished.emit()
		return

	var line: Dictionary = _lines[_next_index]
	_next_index += 1
	line_changed.emit(line)
