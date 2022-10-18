extends Panel

enum Type {none,helmet,armor,boot,weapon,ring,spellItem}
export (Type) var slotType
onready var item = $TextureRect
