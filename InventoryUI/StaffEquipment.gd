extends Control

var bagSize = min(4,8)

onready var Slot = load("res://InventoryUI/Slot.tscn")

func _ready():
	for i in range(bagSize):
		var s = Slot.instance()
		s.slotType = 6
		$ColorRect/GridContainer.add_child(s)

