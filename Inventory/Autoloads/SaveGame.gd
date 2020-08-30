extends Node

const SAVE_PATH = "res://savegame.json"

var save_data: Dictionary = {}

# warning-ignore:unused_signal
signal save_game
# warning-ignore:unused_signal
signal delete_game

func _ready():
	# warning-ignore:return_value_discarded
	connect("save_game", self, "save_game")

	# warning-ignore:return_value_discarded
	connect("delete_game", self, "delete_game")


func save_game():
	# Wait for an idle frame to make sure all the signals (and associated yields) have completed
	yield(get_tree(), "idle_frame")

	# Open or create new save file
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)

	# All the nodes to save are in a group called "persistent" (set in the editor, in the node tab of the inspector)
	var save_dict = {}

	# Collect and call the "save" method on every node in the group
	var backup_list = get_tree().get_nodes_in_group("Backup")
	for node in backup_list:
		# Save the requested node's information under a key representing their node path
		save_dict[node.name] = node.save_state()

	# Store the collected information into the file in JSON format
	save_file.store_line(to_json(save_dict))
	save_file.close()

	print("Save file created.")


func load_game():
	# Verify file exists and open if available
	var save_file = File.new()
	if not save_file.file_exists(SAVE_PATH):
		print("The save file does not exist.")
		return

	save_file.open(SAVE_PATH, File.READ)

	# Convert JSON back to dictionary
	save_data = parse_json(save_file.get_as_text())
	save_file.close()

	print("Save file loaded.")


func delete_game():
	# Verify file exists and open if available
	var save_file = File.new()
	if not save_file.file_exists(SAVE_PATH):
		print("The save file does not exist.")
		return

	var dir = Directory.new()
	dir.remove(SAVE_PATH)

	print("Save file deleted.")
