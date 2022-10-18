extends "res://baseTemplate/entity.gd"

enum Class {human,elf,demon,dwarf,goblin,orc,orge,
			android,mutant}
export(Class) var ClassType
enum Job {Mage,Warlock,Warrior,Archer,Trickster,Tank,Healer}
export (Job) var JobType
onready var healthBar = $healthBar
var motion = Vector2()
const GRAVITY = 600
export var speed = 40

var knockback = 100
var knockup = 300
var playerNear = false
var can_jump = true

enum all_state {IDLE,MOVE,CHASE,SEARCH,COMBAT,HURT,FIGHT,SLEEP,PICKUP,RETREAT}
export (all_state) var STATE

var is_moving = true

func _ready():
	hp = maxHp
	healthBar.max_value = maxHp
	healthBar.value = hp
	motion.x = speed

func _physics_process(delta):
	falling(delta)
	if is_moving:
		movement(delta)
	$Label.text = str(all_state.keys()[STATE])
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
	damageLabel.rect_scale.x = scale.y
#	print(status)

func movement(delta):
	move_and_slide(motion,Vector2.UP)

func falling(delta):
	if !is_on_floor() or is_on_ceiling():
		motion.y += GRAVITY * delta
	else:
		motion.y += 0
	if !can_jump and $checkFloor.is_colliding():
		can_jump = true 

func checkHealth(stat) -> int:
	if status.has(stat):
		return 1
	else:
		return 0

func _on_healthTimer_timeout():
	pass

func _on_hitbox_area_entered(area):
	pass

func jump():
	if can_jump:
		motion.y -= 80
		can_jump = false

func knock(distance_bool):
	pass
#	can_jump = false
#	motion.x = lerp(motion.x,-knockup,0.5)
#	motion = move_and_slide(motion,Vector2.UP)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		$AnimationPlayer.play("RESET")

func _on_AttackBox_area_entered(area):
	if area.is_in_group("player"):
		area.get_parent().knock(global_position>area.global_position)

func _on_AttackBox_area_exited(area):
	pass # Replace with function body.
