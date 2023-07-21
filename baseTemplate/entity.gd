extends KinematicBody2D

export(int) var maxHp
var hp = 0
export (Array,Resource) var blessing
export (Array,Resource) var curses
var status = []
onready var damageLabel = $damageLabel
onready var anim = $damageShowAnime
var linear_dir

func checkCurse(curseName):
	for i in curses:
		if i.idName == curseName:
			return true

func checkBlessing(blessingName):
	for i in blessing:
		if i.idName == blessingName:
			return true

func checkCurseAndBlessing(abilityName):
	if checkBlessing(abilityName) or checkCurse(abilityName):
		return true

func hurt(value):
	#melee damage
	if checkCurseAndBlessing("meleeImmune"):
		showImmune()
		return
	damageLabel.text = str(value)
	anim.play("damageShow")
	hp -= value

func damage(value):
	#non melee damage
	damageLabel.text = str(value)
	anim.play("damageShow")
	hp -= value

func showImmune():
	damageLabel.text = str("Immune")
	anim.play("damageShow")

func burn():
	if checkCurseAndBlessing("fireImmune"):
		showImmune()
		return
	elif status.has("wet"):
		status.erase("wet")
		status.erase("burn")
	elif status.has("burn"):
		damage(10)
		print("already burning")
		$StatusTimers/burnTime.start()
	else:
		damage(10)
		status.append("burn")
		$StatusTimers/burnTime.start()
		print("burning")

func poison():
	if status.has("poison"):
		damage(10)
		print("already poisoned")
		$StatusTimers/poisonTime.start()
	else:
		damage(10)
		status.append("poison")
		$StatusTimers/poisonTime.start()
		print("poisoned")

func _on_burnTime_timeout():
	status.erase("burn")

func _on_poisonTime_timeout():
	status.erase("poison")
