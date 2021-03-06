extends Node

enum SlotType {
	SLOT_DEFAULT = 0,
	SLOT_HEAD,
	SLOT_BACK,
	SLOT_CHEST,
	SLOT_FEET,
	SLOT_RING,
	SLOT_MAIN_HAND,
	SLOT_SPELL,
	SLOT_POTION,
	SLOT_FOOD,
	SLOT_DISABLED
}

enum KeyBind {
	None = -1,
	KEY_0 = 48,
	KEY_1,
	KEY_2,
	KEY_3,
	KEY_4,
	KEY_5,
	KEY_6,
	KEY_7,
	KEY_8,
	KEY_9,
}

const ITEMS = {
	"slightly bent dagger": {
		"icon": "res://Inventory/Sprites/dagger.png",
		"type": SlotType.SLOT_MAIN_HAND,
		"stackable": false,
		"stack_limit": 1,
		"description": "It's sharp enough... I guess.",
		"value": 70,
		"click": null,
		"damage": 2,
		"cooldown": .75,
		"bonus": "power",
		"bonus_amount": 1
	},
	"staff of striking": {
		"icon": "res://Inventory/Sprites/staff.png",
		"type": SlotType.SLOT_MAIN_HAND,
		"stackable": false,
		"stack_limit": 1,
		"description": "Well, it's a fancy stick.",
		"value": 85,
		"click": null,
		"damage": 4,
		"cooldown": 5,
		"bonus": "spell_power",
		"bonus_amount": 1
	},
	"one-half ring": {
		"icon": "res://Inventory/Sprites/ring.png",
		"type": SlotType.SLOT_RING,
		"stackable": false,
		"stack_limit": 1,
		"description": "A rather plain looking ring.",
		"value": 30,
		"click": null,
		"damage": null,
		"cooldown": null,
		"bonus": "health",
		"bonus_amount": 5
	},
	"meat": {
		"icon": "res://Inventory/Sprites/meat.png",
		"type": SlotType.SLOT_FOOD,
		"stackable": true,
		"stack_limit": 5,
		"description": "Meat of unknown origin.",
		"value": 5,
		"click": [
			"action_eat", {}
			],
		"damage": null,
		"cooldown": 15.0,
		"bonus": null,
		"bonus_amount": null
	},
	"fireball": {
		"icon": "res://Inventory/Sprites/spell.png",
		"type": SlotType.SLOT_SPELL,
		"stackable": false,
		"stack_limit": 1,
		"description": "Who doesn't like setting things on fire?",
		"value": 232,
		"click": [
			"action_fireball", {
				"duration": 0.5,
				"damage": 6
				}
			],
		"damage": null,
		"cooldown": 4.0,
		"bonus": null,
		"bonus_amount": null
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
		1: description = "Head"
		2: description = "Back"
		3: description = "Chest"
		4: description = "Feet"
		5: description = "Ring"
		6: description = "Main-Hand"
		7: description = "Spell"
		8: description = "Potion"
		9: description = "Food"
		10: description = ""

	return description
