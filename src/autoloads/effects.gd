extends Node


var sounds = []
var assets = {}

func _ready():
	sounds = []


func cough(host, chance : float = 0.002):
	if chance(chance): 
		var sound = random_asset("res://assets/sounds/coughing/")
		if sound != null:
			play(sound, null, host)
	pass

func chance(chance: float):
	randomize()
	return randf() < chance

func random_asset(path: String = "res://"):
	if !assets.has(path):
		assets[path] = dir_contents(path)
	
	if len(assets[path]) > 0:
		randomize()
		return assets[path][randi() % len(assets[path])]
	
	return null
	
# see: https://godot.readthedocs.io/en/stable/classes/class_directory.html
func dir_contents(path: String = "res://") -> Array:
	var list = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and \
				not file_name.begins_with(".") and \
				file_name.ends_with("import"):
				file_name = file_name.replace('.import', '') 
#				print("Found file: " + file_name)
				list.append(path + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return list
		
		

func play(sound, position = null, parent = null):
	var player

	if position != null:
		player = AudioStreamPlayer2D.new()
		player.position = position
		parent = get_node("/root/game/sounds")
	elif parent != null:
		player = AudioStreamPlayer2D.new()
		player.name = "sound"
	else:
		player = AudioStreamPlayer.new()
		parent = get_node("/root/game/sounds")

	# add sound to game scene
	parent.add_child(player)
	# add finished handler
	player.connect("finished", self, "on_sound_finished", [player])

	if typeof(sound) == TYPE_STRING:
	# if sound is string:
		player.stream = load(sound)
	else:
		player.stream = sound
	# play the sound
	player.play()

	# add to list of sounds
	sounds.append(player)

func on_sound_finished(sound):
	# print("sound finished", sound)
	# find sound ?
	sounds.find(sound)
	# if has sound, remove it
	if sounds.has(sound):
		sounds.erase(sound)

	# remove from game scene
	sound.queue_free();
