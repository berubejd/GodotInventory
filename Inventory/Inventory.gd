extends Control

const INV_ERROR = -1

# Preloads
var item_preload = preload("res://Inventory/Item.tscn")

# Inventory Containers
onready var hotbar = $HotBar
onready var equipment = $Equipment
onready var bag = $Bag


func _ready():
	# warning-ignore:return_value_discarded
	InventorySignals.connect("pickup_item", self, "pickup_item")
	# warning-ignore:return_value_discarded
	InventorySignals.connect("init_inventory", self, "award_initial_inventory")
	# warning-ignore:return_value_discarded
	InventorySignals.connect("load_inventory", self, "load_inventory")


func _process(_delta):
	pass


func pickup_item(item_id: String, count: int = 1, autoequip: bool = true, save: bool = true, announce = true) -> bool:
	# Make this yieldable and avoid an item which is in progress and isn't completely slotted
	yield(get_tree(), "idle_frame")

	var type = Inventory.get_item(item_id)["type"]
	var slot = null

	# Only try to equip items if asked to, they aren't "typeless", and there isn't something already equipped
	if autoequip and type != Inventory.SlotType.SLOT_DEFAULT:
		for _slot in get_tree().get_nodes_in_group("InventorySlot"):
			slot = _slot
			if slot.slotType == type and not slot.item:
				var result = yield(put_away_item(item_id, count, slot, announce), "completed")
				# Item failed to be put in this selected slot
				if result == INV_ERROR:
					continue
				# Some of the items picked up were able to be put away but some are left
				else:
					count = result

					# Nothing else to put away so exit from loop
					if count == 0:
						break

	# Either this item was sent to the bag directly or can't fit in an equipment slot
	while count:
		# Find a slot that is empty or of the same type and not full yet
		slot = bag.get_free_slot(item_id)

		if slot:
			var result = yield(put_away_item(item_id, count, slot, announce), "completed")

			# Item put away
			if result == 0:
				break
			# Item failed to be put in this selected slot
			elif result == INV_ERROR:
				return false
			# Some of the items picked up were able to be put away but some are left
			else:
				count = result

			if save:
				SaveGame.emit_signal("save_game")

		else:
			var value = Inventory.get_item(item_id)["value"]
			# Increment gold counter wherever it is
			# gold += value

			var message = "Received " + str(value) + " gold for " + item_id + "!"
			print(message)

			return false


	return true


func put_away_item(item_id, count, slot, announce):
	yield(get_tree(), "idle_frame")

	var item_instance = item_preload.instance()

	# Initialise the new item
	if not item_instance.initialize(item_id, count):
		return INV_ERROR

	count = yield(slot.add_item(item_instance), "completed")

	if announce:
		var message = "Found " + item_id + "!"
		print(message)

	return count


func award_initial_inventory():
	# Create inventory items on a new game
	yield(pickup_item("slightly bent dagger", 1, true, false, false), "completed")
	# This item would be autoequipped but there is an existing item equipped in that slot so goes to bag
	yield(pickup_item("staff of striking", 1, true, false, false), "completed")
	# This item should "announce" that it was piced up
	yield(pickup_item("one-half ring", 1, true, false, true), "completed")
	# This item will not be autoloaded based on the parameters used
	yield(pickup_item("fireball", 1, false, false, false), "completed")
	# This should result in a stack of 5 meat equipped and a stack of 4 meat in the bag
	yield(pickup_item("meat", 6, true, false, false), "completed")
	yield(pickup_item("meat", 1, false, false, false), "completed")
	yield(pickup_item("meat", 2, false, false, false), "completed")
	
	# Programmatically add an item to the "disabled" slot that can't be returned from slot once removed
	var disabled_slot = find_node("Slot")
	var item_instance = item_preload.instance()
	
	item_instance.initialize("fireball", 1)
	yield(disabled_slot.add_item(item_instance, true), "completed")

	SaveGame.emit_signal("save_game")


func load_inventory():
	var data = SaveGame.save_data[name]

	if data:
		load_state(data)

	var _ret = SaveGame.save_data.erase(name)


func save_state():
	print("Saving ", name)
	var data = {}

	for _slot in get_tree().get_nodes_in_group("InventorySlot"):
		if _slot.item:
			data[_slot.name] = {
				"id": _slot.item.id,
				"count": _slot.item.stack_size
				}

	return data


func load_state(data):
	print("Loading ", name)
	for slot_name in data.keys():
		var _slot = find_node(slot_name)
		var new_item = data[slot_name]

		if _slot:
			put_away_item(new_item["id"], new_item["count"], _slot, false)
