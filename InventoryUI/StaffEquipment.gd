extends Control


var bagSize = min(2,3)

onready var Slot = load("res://InventoryUI/Slot.tscn")
onready var grid = $ColorRect/GridContainer

func _ready():
	Global.StaffEquipment = self
	for i in range(bagSize):
		var s = Slot.instance()
		s.slotType = 6
		$ColorRect/GridContainer.add_child(s)


