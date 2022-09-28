extends "res://baseTemplate/entity.gd"

enum Class {human,elf,demon,dwarf,goblin,orc,orge,
			android,mutant}
export(Class) var ClassType
enum Job {Mage,Warlock,Warrior,Archer,Trickster,Tank,Healer}
export (Job) var JobType
var status = []

func burn():
	if status.has("wet"):
		status.erase("wet")
	elif status.has("burn"):
		pass
	else:
		status.append("burn")
