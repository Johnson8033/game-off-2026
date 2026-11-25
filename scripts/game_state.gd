class_name GameState
extends RefCounted

enum Day {
	MONDAY,
	TUESDAY,
	WEDNESDAY,
	THURSDAY,
	FRIDAY
}

enum Shift {
	DAY,
	NIGHT
}

var current_day: Day = Day.MONDAY
var current_shift: Shift = Shift.DAY

var day_employees: Array[Employee.Id] = []
var night_employees: Array[Employee.Id] = []


func set_schedule(employees: Array[Employee.Id]) -> void:
	day_employees = employees.duplicate()

	night_employees = [
		Employee.Id.ROY,
		Employee.Id.CORDELLE,
		Employee.Id.OLEYSA,
		Employee.Id.DURAI
	]

	for employee in day_employees:
		night_employees.erase(employee)


func get_current_employees() -> Array[Employee.Id]:
	if current_shift == Shift.DAY:
		return day_employees

	return night_employees
