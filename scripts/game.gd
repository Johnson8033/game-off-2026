
extends Control

@export var scheduling_screen: SchedulingScreen
@export var shift_screen: ShiftScreen
@export var ending_screen: EndingScreen

var game_state := GameState.new()


func _ready() -> void:
	shift_screen.hide()
	ending_screen.hide()

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


func _on_shift_completed(
	outcome: GameState.ShiftOutcome
) -> void:
	game_state.record_shift(outcome)
	scheduling_screen.set_day(game_state.current_day)

	print("Good shifts: ", game_state.count_good_shifts())
	print("Bad shifts: ", game_state.count_bad_shifts())

	if game_state.current_shift == GameState.Shift.DAY:
		game_state.current_shift = GameState.Shift.NIGHT

		if not _prepare_current_shift():
			shift_screen.status_label.text = "Night timeline missing."

	elif game_state.advance_day():
		shift_screen.hide()
		scheduling_screen.set_day(game_state.current_day)
		scheduling_screen.reset_selection()
		scheduling_screen.show()

	else:
		_finish_game()


func _finish_game() -> void:
	shift_screen.hide()
	ending_screen.configure(game_state)
	ending_screen.show()
