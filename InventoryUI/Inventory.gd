extends Control

export var bagSize = 50
var Slot = preload("res://InventoryUI/Slot.tscn")

func _ready():
	randomize()
	for i in range(bagSize):
		var s = Slot.instance()
		if randi() % 5 == 0:
			s.get_child(0).thisData.holdItem = load("res://ResAllItems/weapons/basic_sword.tres")
			s.get_child(0).texture = s.get_child(0).thisData.holdItem.icon
		elif randi() % 5 == 1:
			s.get_child(0).thisData.holdItem = load("res://ResAllItems/weapons/basic_staff.tres")
			s.get_child(0).texture = s.get_child(0).thisData.holdItem.icon
		elif randi() % 5 == 2:
			s.get_child(0).thisData.holdItem = load("res://ResAllItems/spells/fireball.tres")
			s.get_child(0).texture = s.get_child(0).thisData.holdItem.icon
		elif randi() % 5 == 3:
			s.get_child(0).thisData.holdItem = load("res://ResAllItems/spells/poison.tres")
			s.get_child(0).texture = s.get_child(0).thisData.holdItem.icon
		$GridContainer.add_child(s)


func _on_BagButton_toggled(button_pressed):
	visible = button_pressed
	pass # Replace with function body.
