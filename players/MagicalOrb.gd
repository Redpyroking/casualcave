extends Area2D

var direction = Vector2.RIGHT
var speed = 400
var currentMagic = null
var selfModulate = Color(1,1,1)

func init(pos,isDirRight):
	if currentMagic:
		modulate = selfModulate
	else:
		modulate = Color(1,1,1)
	global_position = pos
	set_as_toplevel(true)
	if isDirRight:
		direction = Vector2.RIGHT
		scale.x = 1
	else:
		direction = Vector2.LEFT
		scale.x = -1

func _process(delta):
	translate(direction*speed*delta)
	modulate = selfModulate

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func addMagic(magic,modulation):
	currentMagic = str(magic)
	selfModulate = modulation
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
