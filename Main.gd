extends Node2D

# Equipped combat items
var equipped_weapon = null
var equipped_spell = null

# Only way to actually avoid UI clicks from activating inside the game...
var play_area = Rect2(1, 1, 277, 156)


func _ready():
	# Load save game, if available
	SaveGame.load_game()

	if SaveGame.save_data and name in SaveGame.save_data:
		load_state(SaveGame.save_data[name])
		var _ret = SaveGame.save_data.erase(name)
	else:
		InventorySignals.emit_signal("init_inventory")

	# warning-ignore:return_value_discarded
	InventorySignals.connect("item_equipped", self, "equip_item")
	# warning-ignore:return_value_discarded
	InventorySignals.connect("item_removed", self, "remove_item")


# play_area and get_viewport().get_mouse_position() required if mouse is used in _process or _physics_process
func _unhandled_input(_event):
	# Process input that interacts with Inventory
	if Input.is_action_just_pressed("left_click") and play_area.has_point(get_viewport().get_mouse_position()):
		if equipped_weapon:
			if equipped_weapon.owner.activate_item_cooldown():
				print("Weapon activated")

	if Input.is_action_just_released("left_click"):
		pass

	if Input.is_action_just_pressed("right_click") and play_area.has_point(get_viewport().get_mouse_position()):
		if equipped_spell and equipped_spell.has_action and equipped_spell.owner.cooldown.is_stopped():
			print("Spell activated")
			var _ret = yield(equipped_spell.owner.activate_item(), "completed")


func equip_item(item):
	if not item:
		# This should never happen
		return

	if item.type == Inventory.SlotType.SLOT_MAIN_HAND:
		equipped_weapon = item

	if item.type == Inventory.SlotType.SLOT_SPELL:
		equipped_spell = item

	if item.bonus:
		match item.bonus:
			"power":
				pass
			"spell_power":
				pass
			"defense":
				pass
			"health":
				pass
			"speed":
				pass


func remove_item(item):
	if not item:
		# This should never happen
		return

	if item.type == Inventory.SlotType.SLOT_MAIN_HAND:
		equipped_weapon = null

	if item.type == Inventory.SlotType.SLOT_SPELL:
		equipped_spell = null

	if item.bonus:
		match item.bonus:
			"power":
				pass
			"spell_power":
				pass
			"defense":
				pass
			"health":
				pass
			"speed":
				pass


func save_state():
	print("Saving ", name)
	var data = {}
	return data


func load_state(_data):
	print("Loading ", name)
	# Trigger the inventory load now so that any signals will be called on the player
	InventorySignals.emit_signal("load_inventory")


func _on_SaveButton_pressed():
	SaveGame.emit_signal("save_game")


func _on_LoadButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


func _on_DeleteButton_pressed():
	SaveGame.emit_signal("delete_game")
