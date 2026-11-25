class_name ShiftScreen
extends Control
signal shift_completed

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
	start_button.disabled = true
	shift_completed.emit()



func configure(
	employees: Array[Employee.Id],
	day: GameState.Day,
	shift: GameState.Shift
) -> bool:
	if employees.size() != 2:
		return false

	var ids: Array[String] = []

	for employee in employees:
		ids.append(Employee.to_dialogic_id(employee))

	ids.sort()

	var day_id := str(GameState.Day.keys()[day]).to_lower()
	var shift_id := str(GameState.Shift.keys()[shift]).to_lower()

	var path := "res://dialogic/timelines/%s/%s/%s_%s.dtl" % [
		day_id, shift_id, ids[0], ids[1]
	]

	if not ResourceLoader.exists(path):
		push_warning("Timeline not found: " + path)
		return false

	timeline = load(path) as DialogicTimeline

	if timeline == null:
		return false

	status_label.text = "%s %s\n%s + %s" % [
		day_id.capitalize(),
		shift_id.capitalize(),
		ids[0].capitalize(),
		ids[1].capitalize()
	]

	start_button.disabled = false

	return true
