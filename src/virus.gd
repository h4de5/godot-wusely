extends Node

class_name Virus

# how long does it take until someone can spread the virus
const time_to_contagion = 20
# how long does it take for someone to see symptoms
const time_to_symptoms = 50
# how long does it take to get cured (once in hospitality)
const time_to_cure = 100
# how long does it take until you die
const time_to_death = 200

# how likely it is to infect other people
const chance_of_infection : float = 0.5
# how likely it is to be cured at all
const chance_of_cure : float = 0.9
# how likely it is to stay immune after beeing cured
const chance_of_immune : float = 1.0

# TODO - differ time and chances depending on available hospitality

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func chance(chance: float):
	randomize()
	return randf() < chance

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
