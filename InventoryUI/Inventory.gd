extends Control

export var bagSize = 50
var Slot = preload("res://InventoryUI/Slot.tscn")

func _ready():
	for i in range(bagSize):
		$GridContainer.add_child(Slot.instance())
