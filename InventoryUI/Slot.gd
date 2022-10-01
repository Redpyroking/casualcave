extends Panel

enum Type {none,helmet,armor,boot,weapon,necklace,spellItem}
export (Type) var slotType
onready var item = $TextureRect
