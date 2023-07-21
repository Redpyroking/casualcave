extends Area2D

var velocity = Vector2.RIGHT
var speed = 400
var currentMagic = null
var selfModulate = Color(1,1,1)

func init(pos,rot):
	if currentMagic:
		modulate = selfModulate
	else:
		modulate = Color(1,1,1)
	global_position = pos
	global_rotation = rot
	velocity = velocity.rotated(rot)
	set_as_toplevel(true)

func _process(delta):
	position += velocity.normalized() *speed* delta
	modulate = selfModulate

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func addMagic(magic,modulation):
	currentMagic = str(magic)
	selfModulate = modulation
#	direction = dir
	
#match magic:
#		"fire":
#			currentMagic = "fire"
#		"poison":
#			currentMagic = "poison"

func _on_MagicalOrb_body_entered(body):
	if body is TileMap:
		queue_free()
	elif body:
		match currentMagic:
			"fire":
				body.burn()
			"poison":
				body.poison()
		queue_free()
