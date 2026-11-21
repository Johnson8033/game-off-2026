extends Control

@export var scheduling_screen: SchedulingScreen
@export var shift_screen: Control


func _ready() -> void:
	shift_screen.hide()

	scheduling_screen.schedule_confirmed.connect(
		_on_schedule_confirmed
	)


func _on_schedule_confirmed(day_employees: Array[String]) -> void:
	if day_employees != ["Cordelle", "Roy"]:
		scheduling_screen.selection_label.text = (
            "Only Roy and Cordelle are available in this prototype."
		)
		return

	scheduling_screen.hide()
	shift_screen.show()
