extends Node2D

func _ready():
	visible = false

func _physics_process(delta):
	var weaponData = Global.Equipment.weapon.get_child(0).thisData
	var weaponRes = Global.Equipment.weapon.get_child(0).weapon
	if Global.Equipment.weapon:
		visible = true
		$Sprite.texture = Global.Equipment.weapon.get_child(0).texture


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "swing":
		$AnimationPlayer.play("RESET")
