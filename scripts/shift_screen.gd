extends Control

@export var status_label: Label
@export var start_button: Button
@export var timeline: DialogicTimeline


func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	Dialogic.timeline_ended.connect(_on_timeline_ended)


func _on_start_pressed() -> void:
	if Dialogic.current_timeline != null:
		return

	if timeline == null:
		push_error("No timeline assigned!")
		return

	start_button.disabled = true
	status_label.text = "Shift in progress"

	Dialogic.start_timeline(timeline)


func _on_timeline_ended() -> void:
	status_label.text = "Shift complete!"
	start_button.disabled = false
