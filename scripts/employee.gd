class_name Employee
extends RefCounted

enum Id {
	ROY,
	CORDELLE,
	OLEYSA,
	DURAI
}

const DIALOGIC_IDS = {
	Id.ROY: "roy",
	Id.CORDELLE: "cordelle",
	Id.OLEYSA: "oleysa",
	Id.DURAI: "durai"
}

static func to_dialogic_id(id: Id) -> String:
	return DIALOGIC_IDS[id]
