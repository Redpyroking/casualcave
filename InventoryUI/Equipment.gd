extends Control

onready var helmet = $Panel/helmet
onready var weapon = $Panel/weapon

func _ready():
	Global.Equipment = self

func _on_DressButton_toggled(button_pressed):
	visible = button_pressed
