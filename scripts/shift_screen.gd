class_name ShiftScreen
extends Control
signal shift_completed(outcome: GameState.ShiftOutcome)

var outcome: GameState.ShiftOutcome = GameState.ShiftOutcome.UNKNOWN

@export var status_label: Label
@export var start_button: Button
@export var timeline: DialogicTimeline


func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_ended.connect(_on_timeline_ended)


func _input(event: InputEvent) -> void:
	if Dialogic.current_timeline == null:
		return

	if event is InputEventKey:
		if event.keycode == KEY_CTRL and not event.echo:
			Dialogic.Inputs.auto_skip.time_per_event = 0.05
			Dialogic.Inputs.auto_skip.enabled = event.pressed


func _on_start_pressed() -> void:
	if Dialogic.current_timeline != null:
		return

	if timeline == null:
		push_error("No timeline assigned!")
		return

	start_button.disabled = true
	status_label.text = "Shift in progress"
	outcome = GameState.ShiftOutcome.UNKNOWN

	Dialogic.start_timeline(timeline)


func _on_timeline_ended() -> void:
	status_label.text = "Shift complete!"
	start_button.disabled = true
	Dialogic.Inputs.auto_skip.enabled = false

	if outcome == GameState.ShiftOutcome.UNKNOWN:
		push_warning("Timeline ended without a shift outcome.")

	shift_completed.emit(outcome)


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
		path = "res://dialogic/timelines/placeholder.dtl"
		#return false

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


func _on_dialogic_signal(argument: Variant) -> void:
	match argument:
		"shift_good":
			outcome = GameState.ShiftOutcome.GOOD
		"shift_bad":
			outcome = GameState.ShiftOutcome.BAD
