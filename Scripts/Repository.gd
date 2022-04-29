extends Node

export(Dictionary) var pokemon = {
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

export(Dictionary) var moves = {
	# Normal
	Tackle = {
		cost = 0,
		damage = 1,
		badge = "Paper",
		type = "Normal"
	}, Scratch = {
		cost = 0,
		damage = 1,
		badge = "Scissor",
		type = "Normal"
	# Electric
	}, Nuzzle = {
		cost = 0,
		damage = 1,
		badge = "Rock",
		type = "Electric"
	# Water
	}, Bubble = {
		cost = 0,
		damage = 1,
		badge = "Rock",
		type = "Water"
	# Fire
	}, Ember = {
		cost = 0,
		damage = 1,
		badge = "Rock",
		type = "Fire"
	# Recover
	}, Growl = {
		recover = 2,
		cost = 0,
		badge = "None",
		damage = 0,
		type = "Normal"
	}
}

class PokemonModel:
	var hp : int
	var affinity : int
	var type : String
