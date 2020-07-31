extends Node

enum SlotType {
	SLOT_DEFAULT = 0,
	SLOT_HELMET,
	SLOT_CLOAK,
	SLOT_ARMOR,
	SLOT_FEET,
	SLOT_RING,
	SLOT_MAIN_HAND,
	SLOT_OFF_HAND,
	SLOT_POTION,
	SLOT_FOOD
}

const ITEMS = {
	"slightly bent dagger": {
		"icon": "res://Inventory/Sprites/Item_00.png",
		"type": SlotType.SLOT_MAIN_HAND,
		"stackable": false,
		"stack_limit": 1,
		"description" : "It's sharp enough... I guess."
	},
	"wand of striking": {
		"icon": "res://Inventory/Sprites/Item_23.png",
		"type": SlotType.SLOT_OFF_HAND,
		"stackable": false,
		"stack_limit": 1,
		"description" : "Well, it's a fancy stick."
	},
	"one-half ring": {
		"icon": "res://Inventory/Sprites/Item_40.png",
		"type": SlotType.SLOT_RING,
		"stackable": false,
		"stack_limit": 1,
		"description" : "A rather plain looking ring."
	},
	"meat": {
		"icon": "res://Inventory/Sprites/Item_58.png",
		"type": SlotType.SLOT_FOOD,
		"stackable": true,
		"stack_limit": 5,
		"description" : "Meat of unknown origin."
	},
}

func get_item(item_id):
	if item_id in ITEMS:
		return ITEMS[item_id]
	else:
		return null


func get_type(slot_type):
	var description = null

	match slot_type:
		0: description = "Stuff"
		1: description = "Helmet"
		2: description = "Cloak"
		3: description = "Armor"
		4: description = "Feet"
		5: description = "Ring"
		6: description = "Main-Hand"
		7: description = "Off-Hand"
		8: description = "Potion"
		9: description = "Food"

	return description
