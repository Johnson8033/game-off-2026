
extends Control

@export var scheduling_screen: SchedulingScreen
@export var shift_screen: ShiftScreen

var game_state := GameState.new()


func _ready() -> void:
	shift_screen.hide()

	scheduling_screen.schedule_confirmed.connect(
		_on_schedule_confirmed
	)

	shift_screen.shift_completed.connect(
		_on_shift_completed, CONNECT_DEFERRED
	)


func _on_schedule_confirmed(
	day_employees: Array[Employee.Id]
) -> void:
	game_state.set_schedule(day_employees)

	if not _prepare_current_shift():
		scheduling_screen.selection_label.text = (
            "No conversation available for this pairing."
		)
		return

	scheduling_screen.hide()
	shift_screen.show()


func _prepare_current_shift() -> bool:
	return shift_screen.configure(
		game_state.get_current_employees(),
		game_state.current_day,
		game_state.current_shift
	)


func _on_shift_completed() -> void:
	if game_state.current_shift == GameState.Shift.DAY:
		game_state.current_shift = GameState.Shift.NIGHT

		if not _prepare_current_shift():
			shift_screen.status_label.text = "Night timeline missing."
	else:
		shift_screen.status_label.text = "Monday complete!"
