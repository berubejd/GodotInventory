extends Popup

onready var label_name = $Panel/Label_name
onready var label_type = $Panel/Label_type
onready var label_desc = $Panel/Label_description


func _ready():
# warning-ignore:return_value_discarded
	InventorySignals.connect("display_tooltip", self, "display_tooltip")
# warning-ignore:return_value_discarded
	InventorySignals.connect("hide_tooltip", self, "hide_tooltip")


func display_tooltip(item):
	visible = true
	label_name.text = item.id
	label_type.text = "- " + item.type_description + " -"
	label_desc.text = item.description


func hide_tooltip():
	hide()
