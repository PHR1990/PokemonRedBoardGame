extends Node

export(Dictionary) var pokemon = {
	Bulbasaur = {
		HP = 4,
		Affinity = 3,
		Type = "Grass",
		Moves = ["Tackle", "Growl", "RazorLeaf"]
	}, Charmander = {
		HP = 4,
		Affinity = 3,
		Type = "Fire",
		Moves = ["Scratch", "Growl", "Ember", "FlameWheel"]
	}, Squirtle = {
		HP = 4,
		Affinity = 3,
		Type = "Water",
		Moves = ["Tackle", "Growl", "Bubble", "WaterGun"]
	}, Pikachu = {
		HP = 3,
		Affinity = 4,
		Type = "Electric",
		Moves = ["Nuzzle", "Growl"]
	}, Poliwag = {
		HP = 3,
		Affinity = 2,
		Type = "Water",
		Moves = ["Tackle", "Growl", "Bubble"]
	}, Vulpix = {
		HP = 3,
		Affinity = 4,
		Type = "Fire",
		Moves = ["Scratch", "Growl", "Ember"]
	}, Jigglypuff = {
		HP = 4,
		Affinity = 2,
		Type = "Normal",
		Moves = ["Nuzzle", "Ember", "Bubble", "Tackle"]
	}, Arcanine = {
		HP = 8,
		Affinity = 6,
		Type = "Fire",
		Moves = ["FlameWheel", "Ember", "Tackle"]
	}, Charizard = {
		HP = 7,
		Affinity = 7,
		Type = "Fire",
		Moves = ["FlameWheel", "Ember", "Slash"]
	}, Fearow = {
		HP = 6,
		Affinity = 5,
		Type = "Normal",
		Moves = ["Slash", "Growl", "Scratch"]
	},
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
	}, Slash = {
		cost = 2,
		damage = 2,
		badge = "Scissor",
		type = "Normal"
	# Electric
	}, Nuzzle = {
		cost = 0,
		damage = 1,
		badge = "Rock",
		type = "Electric"
	}, Bolt = {
		cost = 1,
		damage = 2,
		badge = "Rock",
		type = "Electric"
	# Water
	}, Bubble = {
		cost = 0,
		damage = 1,
		badge = "Rock",
		type = "Water"
	}, WaterGun = {
		cost = 1,
		damage = 2,
		badge = "Rock",
		type = "Water"
	}, Surf = {
		cost = 4,
		damage = 4,
		badge = "Rock",
		type = "Water"
	# Fire
	}, Ember = {
		cost = 1,
		damage = 1,
		badge = "Rock",
		type = "Fire"
	}, FlameWheel = {
		cost = 1,
		damage = 2,
		badge = "Rock",
		type = "Fire"
	# Grass
	}, RazorLeaf = {
		cost = 1,
		damage = 2,
		badge = "Rock",
		type = "Grass"
	# Recover
	}, Growl = {
		recover = 2,
		cost = 0,
		badge = "None",
		damage = 0,
		type = "Normal"
	}
}
