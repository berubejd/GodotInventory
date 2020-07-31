extends Panel
class_name Slot

export(Inventory.SlotType) var slotType = Inventory.SlotType.SLOT_DEFAULT;

var item = null

onready var bag = get_tree().get_root().find_node("Bag", true, false)
onready var typelabel = $TypeLabel

func _ready():
# warning-ignore:return_value_discarded
	connect("mouse_entered", self, "mouse_enter_slot")
# warning-ignore:return_value_discarded
	connect("mouse_exited", self, "mouse_exit_slot")
	
	# Setup label
	typelabel.text = Inventory.get_type(slotType).rsplit("_", true, 1)[0]
	typelabel.visible = false


func _process(_delta):
	if item:
		typelabel.visible = false
	else:
		if slotType != Inventory.SlotType.SLOT_DEFAULT:
			typelabel.visible = true


func _gui_input(event : InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				pass
			else:
				pass


func add_item(new_item):
	# Return if this is the wrong slot type for the item
	if not slotType == Inventory.SlotType.SLOT_DEFAULT and not slotType == new_item.type:
		return false

	# Return immediately if the item to be added is already in this slot
	if item == new_item:
		return false

	# If slot is occupied move current item to a different free slot first
	if item:
		return swap_slots(item, new_item)

	# Clear out the older owner information if this was previously slotted
	if new_item.owner:
		new_item.owner.clear_slot()

	item = new_item
	add_child(item)
	item.set_owner(self)

	# Reset position in case item was dragged to a new slot
	item.rect_position = Vector2(1, 1)

	return true


func clear_slot():
	var old_item = null
	if item:
		old_item = item
	item = null

	for child in get_children():
		if child is Item:
			remove_child(child)

	return old_item


func mouse_enter_slot():
	if self.item:
		InventorySignals.emit_signal("display_tooltip", self.item)


func mouse_exit_slot():
	InventorySignals.emit_signal("hide_tooltip")


func swap_slots(current_item, new_item):
	var current_item_handle = current_item
	var current_item_destination = null

	if new_item.owner.slotType == Inventory.SlotType.SLOT_DEFAULT:
		# Swap slots if the new_item is coming from the bag
		current_item_destination = new_item.owner
	else:
		# if new_item is somewhere other than the bag then find a new slot in the bag if available
		current_item_destination = bag.get_free_slot()

		if not current_item_destination:
			return false

	# Clean up slot and item
	current_item_handle.clear_item()
	clear_slot()

	# Add new item to this slot
	add_item(new_item)

	# Add original item to the newly opened slot
	current_item_destination.add_item(current_item_handle)

	return true
