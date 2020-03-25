extends Node

class_name Virus

# how long does it take until someone can spread the virus
const time_to_infection = 20
# how long does it take for someone to see symptoms
const time_to_symptoms = 50
# how long does it take to get cured (once in hospitality)
const time_to_cure = 100

# how likely it is to infect other people
const chance_to_infection : float = 0.5
# how likely it is to be cured at all
const chance_to_cure : float = 0.9
# how likely it is to stay immune after beeing cured
const chance_to_immune : float = 1.0

# TODO - differ time and chances depending on available hospitality

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# if d1 and d2 meet
func meet(d1: Dot, d2: Dot):
	if d1.is_contagious and d2.is_vulnerable:
		if chance(chance_to_infection):
			d2.infect(self)
		
	elif d2.is_contagious and d1.is_vulnerable:
		d1.is_infected = chance(chance_to_infection)
		
	#if d1.is_contagious && d2.:
	pass


func chance(chance: float):
	randomize()
	return randf() < chance

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
