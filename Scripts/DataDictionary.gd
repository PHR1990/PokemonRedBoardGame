extends Node

export var pokemon : Dictionary = {
	Charmander = {
		HP = 4,
		Affinity = 3,
		Type = "Fire"
	}, Squirtle = {
		HP = 4,
		Affinity = 3,
		Type = "Water"
	}, Pikachu = {
		HP = 3,
		Affinity = 4,
		Type = "Electric"
	}
}

export var moves : Dictionary = {
	# Normal
	Tackle = {
		cost = 0,
		damage = 1,
		badge = "Paper"
	}, Scratch = {
		cost = 0,
		damage = 1,
		badge = "Scissor"
	# Electric
	}, Nuzzle = {
		cost = 0,
		damage = 1,
		badge = "Rock"
	# Water
	}, Bubble = {
		cost = 0,
		damage = 1,
		badge = "Rock"
	# Fire
	}, Ember = {
		cost = 0,
		damage = 1,
		badge = "Rock"
	# Recover
	}, Growl = {
		recover = 2,
		cost = 0,
		damage = 0,
	}
}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
