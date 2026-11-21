class_name SchedulingScreen
extends Control

signal schedule_confirmed(day_employees: Array[String])

@export var employee_buttons: Array[Button]
@export var selection_label: Label
@export var confirm_button: Button

var selected_employees: Array[String] = []


func _ready() -> void:
	for button in employee_buttons:
		button.toggle_mode = true
		button.toggled.connect(
			_on_employee_toggled.bind(button)
		)

	confirm_button.pressed.connect(_on_confirm_pressed)
	_update_ui()


func _on_employee_toggled(
	is_selected: bool,
	button: Button
) -> void:
	if is_selected:
		selected_employees.append(button.text)
	else:
		selected_employees.erase(button.text)

	_update_ui()


func _update_ui() -> void:
	selection_label.text = "Selected: %d/2" % selected_employees.size()

	confirm_button.disabled = selected_employees.size() != 2

	for button in employee_buttons:
		button.disabled = (
			selected_employees.size() == 2
			and not button.button_pressed
		)


func _on_confirm_pressed() -> void:
	var day_employees := selected_employees.duplicate()
	day_employees.sort()

	var night_employees: Array[String] = [
		"Roy", "Cordelle", "Oleysa", "Durai"
	]

	for employee in day_employees:
		night_employees.erase(employee)

	print("Day shift: ", day_employees)
	print("Night shift: ", night_employees)

	schedule_confirmed.emit(day_employees)
