extends Control

var bagSize = min(16,20)

onready var Slot = load("res://InventoryUI/Slot.tscn")
onready var grid = $ColorRect/GridContainer

func _ready():
	Global.StaffEquipment = self
	for i in range(bagSize):
		var s = Slot.instance()
		s.slotType = 0
		$ColorRect/GridContainer.add_child(s)
