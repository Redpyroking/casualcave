extends Node2D

onready var magicalOrb = load("res://players/MagicalOrb.tscn")
var weaponRes = null
onready var player = get_parent().get_parent()

func _ready():
	visible = false

func _physics_process(delta):
	weaponRes = Global.Equipment.weapon.get_child(0).thisData
	if Global.Equipment.weapon:
		visible = true
		$Sprite.texture = Global.Equipment.weapon.get_child(0).texture
		if weaponRes.holdItem != null:
			if weaponRes.holdItem.weaponType == 2:
				player.get_parent().get_node("CanvasLayer/StaffEquipment").visible = true
			else:
				player.get_parent().get_node("CanvasLayer/StaffEquipment").visible = false
		else:
			player.get_parent().get_node("CanvasLayer/StaffEquipment").visible = false

func attack():
	if weaponRes.holdItem != null:
		if weaponRes.holdItem.weaponType == 2:
			var m = magicalOrb.instance()
			if m.has_method("init"):
				m.init(global_position,!get_parent().get_parent().get_node("Sprite").flip_h)
				add_child(m)
			var staff_magic1_data = Global.StaffEquipment.grid.get_child(0).item.thisData
			var staff_magic2_data = Global.StaffEquipment.grid.get_child(1).item.thisData
			print(staff_magic1_data)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "swing":
		$AnimationPlayer.play("RESET")
