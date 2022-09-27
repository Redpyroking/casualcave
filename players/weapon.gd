extends Node2D

onready var magicalOrb = load("res://players/MagicalOrb.tscn")
var weaponRes = null

func _ready():
	visible = false

func _physics_process(delta):
	weaponRes = Global.Equipment.weapon.get_child(0).thisData
	if Global.Equipment.weapon:
		visible = true
		$Sprite.texture = Global.Equipment.weapon.get_child(0).texture
		

func attack():
	if weaponRes.weapon != null:
		if weaponRes.weapon.weaponType == 2:
			var m = magicalOrb.instance()
			if m.has_method("init"):
				m.init(global_position,!get_parent().get_parent().get_node("Sprite").flip_h)
			add_child(m)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "swing":
		$AnimationPlayer.play("RESET")
