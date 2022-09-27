extends Resource

class_name Weapon

export (Texture) var icon
export (String) var alias
export (String) var idName
export (int) var level = 1
export (int) var melee_damage
enum Type {sword,bow,staff}
export (Type) var weaponType
export (float) var weight
export (Array) var spellItem
