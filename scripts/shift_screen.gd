class_name ShiftScreen
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


func configure(day_employees: Array[Employee.Id]) -> bool:
	if day_employees.size() != 2:
		return false

	var ids: Array[String] = []

	for employee in day_employees:
		ids.append(Employee.to_dialogic_id(employee))

	ids.sort()

	var path := "res://dialogic/timelines/monday/day/%s_%s.dtl" % [
		ids[0], ids[1]
	]

	if not ResourceLoader.exists(path):
		push_warning("Timeline not found: " + path)
		return false

	timeline = load(path) as DialogicTimeline

	if timeline == null:
		return false

	status_label.text = "Ready: %s + %s" % [
		ids[0].capitalize(),
		ids[1].capitalize()
	]

	return true
