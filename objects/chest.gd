extends "res://baseTemplate/entity.gd"

onready var chestBagUI = get_parent().get_node("CanvasLayer/chestBag")
var detectPlayer = false

func _physics_process(delta):
	if !detectPlayer:
		chestBagUI.visible = false
	if chestBagUI.visible:
		$AnimatedSprite.play("open")
	else:
		$AnimatedSprite.play("close")

func _input(event):
	if Input.is_action_just_pressed("interact") and detectPlayer:
		chestBagUI.visible = !chestBagUI.visible

func _on_playerDetect_area_entered(area):
	if area.is_in_group("player"):
		detectPlayer = true

func _on_playerDetect_area_exited(area):
	if area.is_in_group("player"):
		detectPlayer = false
