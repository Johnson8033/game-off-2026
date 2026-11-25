class_name SchedulingScreen
extends Control

signal schedule_confirmed(day_employees: Array[Employee.Id])

@export var employee_buttons: Array[EmployeeButton]
@export var selection_label: Label
@export var confirm_button: Button
@export var title_label: Label
@export var day_employees_label: Label
@export var night_employees_label: Label

var selected_employees: Array[Employee.Id] = []


func _ready() -> void:
	for button in employee_buttons:
		button.toggle_mode = true
		button.toggled.connect(
			_on_employee_toggled.bind(button.employee_id)
		)

	confirm_button.pressed.connect(_on_confirm_pressed)
	_update_ui()


func set_day(day: GameState.Day) -> void:
	var day_name := str(GameState.Day.keys()[day]).capitalize()
	title_label.text = "%s — Staff Schedule" % day_name


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

	var day_names: Array[String] = []
	var night_names: Array[String] = []

	for button in employee_buttons:
		var is_selected := button.employee_id in selected_employees

		button.disabled = (
			selected_employees.size() == 2
			and not is_selected
		)

		if is_selected:
			day_names.append(button.text)
		else:
			night_names.append(button.text)

	while day_names.size() < 2:
		day_names.append("Empty slot")

	day_employees_label.text = "\n".join(day_names)

	if selected_employees.size() == 2:
		night_employees_label.text = "\n".join(night_names)
	else:
		night_employees_label.text = "Pending\nPending"


func _on_confirm_pressed() -> void:
	schedule_confirmed.emit(selected_employees.duplicate())


func reset_selection() -> void:
	selected_employees.clear()

	for button in employee_buttons:
		button.set_pressed_no_signal(false)

	_update_ui()
