extends Control

onready var helmet = $Panel/helmet
onready var weapon = $Panel/weapon

func _ready():
	Global.Equipment = self
