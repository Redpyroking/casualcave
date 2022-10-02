extends "res://baseTemplate/entity.gd"

enum Class {human,elf,demon,dwarf,goblin,orc,orge,
			android,mutant}
export(Class) var ClassType
enum Job {Mage,Warlock,Warrior,Archer,Trickster,Tank,Healer}
export (Job) var JobType
var status = []
var max_hp = 100
var hp
onready var healthBar = $healthBar

func _ready():
	hp = max_hp
	healthBar.max_value = max_hp
	healthBar.value = hp

func _physics_process(delta):
	if status.has("burn"):
		if hp > 0:
			if checkHealth("burn") == 1 and $healthTimer.is_stopped():
				hp -= 1
				$healthTimer.wait_time = 0.2
				$healthTimer.start()
	if status.has("poison"):
		if hp > 0:
			if checkHealth("poison") == 1 and $healthTimer.is_stopped():
				hp -= 1
				$healthTimer.wait_time = 0.6
				$healthTimer.start()
	healthBar.value = hp
	if hp < 1:
		queue_free()
	print(status)

func burn():
	if status.has("wet"):
		status.erase("wet")
		status.erase("burn")
	elif status.has("burn"):
		print("already burning")
		$StatusTimers/burnTime.start()
	else:
		status.append("burn")
		$StatusTimers/burnTime.start()
		print("burning")

func poison():
	if status.has("poison"):
		print("already poisoned")
		$StatusTimers/poisonTime.start()
	else:
		status.append("poison")
		$StatusTimers/poisonTime.start()
		print("poisoned")

func checkHealth(stat) -> int:
	if status.has(stat):
		return 1
	else:
		return 0

func _on_healthTimer_timeout():
	pass

func _on_burnTime_timeout():
	status.erase("burn")

func _on_poisonTime_timeout():
	status.erase("poison")
