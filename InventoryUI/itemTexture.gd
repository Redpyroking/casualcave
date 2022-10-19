extends TextureRect

var thisData = {"holdItem":null,"itemType":null}

func _ready():
	randomize()
	if thisData.holdItem != null:
		thisData.itemType = thisData.holdItem.itemType
#	thisData["holdItem"] = null

func drop_data(position, data):
	var temp_texture = null
	var temp_data = data.thisData
	if data.texture:
		temp_texture = data.texture
	data.texture = texture
	data.thisData = thisData
	if temp_texture:
		texture = temp_texture
		thisData = temp_data
	else:
		texture = null

func can_drop_data(position, data):
	#data means other one you want to swap with
	if get_parent().slotType == data.thisData.itemType or data.get_parent().slotType == thisData.itemType:
		return true
	elif get_parent().slotType == 0 and data.get_parent().slotType == 0:
		return true
	elif data.thisData.itemType == null and data.get_parent().slotType == 0 and (thisData.itemType == get_parent().slotType):
		return true
	elif thisData.itemType == null and get_parent().slotType == 0 and (data.thisData.itemType == data.get_parent().slotType):
		return true
	return false

func get_drag_data(position):
	return self
