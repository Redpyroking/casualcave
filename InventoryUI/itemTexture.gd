extends TextureRect

var weapon = null
var thisData = {}
onready var slotType = get_parent().slotType

func _ready():
	randomize()
	if randi() % 10 == 0 and get_parent().get_parent().name != "Panel":
		weapon = load("res://AllItem/weapon/basic_sword.tres")
		texture = weapon.icon
		slotType = 4
	elif randi() % 10 == 1 and get_parent().get_parent().name != "Panel":
		weapon = load("res://AllItem/weapon/basic_staff.tres")
		texture = weapon.icon
		slotType = 4
	thisData["weapon"] = weapon

func drop_data(position, data):
	var temp_texture = null
	var temp_data = data
	var temp_slotType = data.slotType
	if data.texture:
		temp_texture = data.texture
	data.texture = texture
	data = self
	data.slotType = slotType
	if temp_texture:
		texture = temp_texture
		thisData = temp_data
		slotType = temp_slotType
	else:
		texture = null

func can_drop_data(position, data):
	if slotType == 0 or data.slotType ==slotType:
		return true
	return false

func get_drag_data(position):
	return self
