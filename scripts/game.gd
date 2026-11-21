extends Control

@export var scheduling_screen: SchedulingScreen
@export var shift_screen: Control


func _ready() -> void:
	shift_screen.hide()

	scheduling_screen.schedule_confirmed.connect(
		_on_schedule_confirmed
	)


func _on_schedule_confirmed(
	day_employees: Array[Employee.Id]
) -> void:
	if not shift_screen.configure(day_employees):
		scheduling_screen.selection_label.text = (
            "No conversation available for this pairing."
		)
		return

	scheduling_screen.hide()
	shift_screen.show()
