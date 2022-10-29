extends "res://baseTemplate/entity.gd"

onready var chestBagUI = $CanvasLayer/chestBag
var detectPlayer = false
var items = {
	"item1" : null,
	"item2" : null,
	"item3" : null,
	"item4" : null,
	"item5" : null,
	"item6" : null,
	"item7" : null,
	"item8" : null,
	"item9" : null,
	"item10" : null,
	"item11" : null,
	"item12" : null,
	"item13" : null,
	"item14" : null,
	"item15" : null,
	"item16" : null
}

func _ready():
	chestBagUI.hide()
	yield(get_tree(),"idle_frame")
	items.item1 = load("res://ResAllItems/weapons/basic_sword.tres")
	for i in chestBagUI.slotChild:
		i.item.thisData.holdItem = items["item"+str(i.get_index()+1)]
		if i.item.thisData.holdItem:
			i.item.texture = i.item.thisData.holdItem.icon
			i.item.thisData.itemType = i.item.thisData.holdItem.itemType
#
#func _physics_process(delta):
#	for i in chestBagUI.slotChild:
#		i.item.thisData.holdItem = items["item"+str(i.get_index()+1)]
#		if i.item.thisData.holdItem:
#			i.item.texture = i.item.thisData.holdItem.icon
#			i.item.thisData.itemType = i.item.thisData.holdItem.itemType

func _input(event):
	if Input.is_action_just_pressed("interact") and detectPlayer:
		chestBagUI.visible = !chestBagUI.visible
		if $AnimatedSprite.animation == "close":
			$AnimatedSprite.play("open")
		else:
			$AnimatedSprite.play("close")

func _on_playerDetect_area_entered(area):
	if area.is_in_group("player"):
		detectPlayer = true

func _on_playerDetect_area_exited(area):
	if area.is_in_group("player"):
		detectPlayer = false
		chestBagUI.visible = false
		$AnimatedSprite.play("close")
