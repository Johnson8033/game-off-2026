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

enum ShiftOutcome {
	UNKNOWN,
	GOOD,
	BAD
}

var current_day: Day = Day.MONDAY
var current_shift: Shift = Shift.DAY

var day_employees: Array[Employee.Id] = []
var night_employees: Array[Employee.Id] = []
var shift_history: Array[Dictionary] = []


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


func record_shift(outcome: ShiftOutcome) -> void:
	shift_history.append({
		"day": current_day,
		"shift": current_shift,
		"employees": get_current_employees().duplicate(),
		"outcome": outcome
	})


func count_good_shifts() -> int:
	return shift_history.filter(
		func(result): return result["outcome"] == ShiftOutcome.GOOD
	).size()


func count_bad_shifts() -> int:
	return shift_history.filter(
		func(result): return result["outcome"] == ShiftOutcome.BAD
	).size()
