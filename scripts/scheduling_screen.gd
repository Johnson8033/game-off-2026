class_name SchedulingScreen
extends Control

signal schedule_confirmed(day_employees: Array[Employee.Id])

@export var employee_buttons: Array[EmployeeButton]
@export var selection_label: Label
@export var confirm_button: Button

var selected_employees: Array[Employee.Id] = []


func _ready() -> void:
	for button in employee_buttons:
		button.toggle_mode = true
		button.toggled.connect(
			_on_employee_toggled.bind(button.employee_id)
		)

	confirm_button.pressed.connect(_on_confirm_pressed)
	_update_ui()


func _on_employee_toggled(
	is_selected: bool,
	employee_id: Employee.Id
) -> void:
	if is_selected:
		selected_employees.append(employee_id)
	else:
		selected_employees.erase(employee_id)

	_update_ui()


func _update_ui() -> void:
	selection_label.text = "Selected: %d/2" % selected_employees.size()

	confirm_button.disabled = selected_employees.size() != 2

	for button in employee_buttons:
		button.disabled = (
			selected_employees.size() == 2
			and button.employee_id not in selected_employees
		)


func _on_confirm_pressed() -> void:
	schedule_confirmed.emit(selected_employees.duplicate())


func reset_selection() -> void:
	selected_employees.clear()

	for button in employee_buttons:
		button.set_pressed_no_signal(false)

	_update_ui()
