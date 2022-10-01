extends TextureRect

var thisData = {"holdItem":null}

func _ready():
	randomize()
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
	if data.get_parent().slotType == 0 or get_parent().slotType == 0 or data.get_parent().slotType == get_parent().slotType:
		return true
	return false

func get_drag_data(position):
	return self
