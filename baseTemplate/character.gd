extends "res://baseTemplate/entity.gd"

enum Class {human,elf,demon,dwarf,goblin,orc,orge,
			android,mutant}
export(Class) var ClassType
enum Job {Mage,Warlock,Warrior,Archer,Trickster,Tank,Healer}
export (Job) var JobType
var status = []
var max_hp = 100
var hp

func _ready():
	hp = max_hp

func burn():
	if status.has("wet"):
		status.erase("wet")
	elif status.has("burn"):
		print("burning")
	else:
		status.append("burn")
