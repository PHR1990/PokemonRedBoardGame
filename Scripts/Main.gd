extends Node

var ownPokemon
var enemyPokemon
var label

# Called when the node enters the scene tree for the first time.
func _ready():
	label = $Label
	label.text = ""
	create_pokemons()
	create_move_cards()
	
func card_was_used():
	writeInLabel("card used")

func create_pokemons():
	var currentSize = get_viewport().size
	
	var pokemon_card_scene = load("res://Scenes/PokemonCardScene.tscn")
	
	ownPokemon = create_pokemon_card(pokemon_card_scene, Vector2(currentSize.x / 2 -160, 275 ), "Squirtle")
	enemyPokemon = create_pokemon_card(pokemon_card_scene, Vector2(currentSize.x / 2 - 160, 25), "Charmander")

func create_pokemon_card(pokemon_card_scene, position, pokemonName):
	
	var pokemonInstance = pokemon_card_scene.instance()
	
	pokemonInstance.hp = pokemon.get(pokemonName).HP
	pokemonInstance.pokemonName = pokemonName
	pokemonInstance.type = pokemon.get(pokemonName).Type
	pokemonInstance.affinity = pokemon.get(pokemonName).Affinity
	pokemonInstance.set_position(position)
	add_child(pokemonInstance)
	return pokemonInstance

func create_move_cards():
	
	var move_card_scene = load("res://Scenes/MoveCardScene.tscn")
	
	var currentSize = get_viewport().size
	
	create_move_card(move_card_scene,"Tackle", moves.get("Tackle"), Vector2(80, 330))
	create_move_card(move_card_scene,"Growl", moves.get("Growl"), Vector2(220 , 330))
	create_move_card(move_card_scene,"Bubble", moves.get("Bubble"), Vector2(80  , 470))
	
	
func create_move_card(move_card_scene,moveName, move, position):
	var move_instance = move_card_scene.instance()
	
	move_instance.moveName = moveName
	move_instance.affinityCostAmount = move.cost
	move_instance.damageAmount = move.damage
	move_instance.type = move.type
	move_instance.badge = move.badge
	
	move_instance.set_position(position)
	move_instance.connect("card_used", self, "_on_MoveCardScene_card_used")
	add_child(move_instance)
	
	
func _on_MoveCardScene_card_used(moveName):
	processAttack(moveName)

func processAttack(moveName):
	label.text = ""
	var ownMove = moves.get(moveName)
	var enemyMove = moves.get(random_move())
	
	var result = rock_paper_scissor_result(ownMove.badge, enemyMove.badge)
	
	writeInLabel("You choose: " + ownMove.badge)
	writeInLabel("Enemy chose: " + enemyMove.badge)
	
	if (result == "Win"):
		writeInLabel("You go first!");
		enemyPokemon.damage(ownMove.damage)
		writeInLabel("Enemy " + str(ownMove.damage) + " damage");
		yield(get_tree().create_timer(2.0), "timeout")
		writeInLabel("You took " + str(enemyMove.damage) + " damage");
		ownPokemon.damage(enemyMove.damage)
	elif (result == "Lost"):
		writeInLabel("Enemy goes first!");
		writeInLabel("You took " + str(enemyMove.damage) + " damage");
		ownPokemon.damage(enemyMove.damage)
		yield(get_tree().create_timer(2.0), "timeout")
		writeInLabel("Enemy " +  str(ownMove.damage) + " damage");
		enemyPokemon.damage(ownMove.damage)
	else:
		writeInLabel("It was a tie!");
		writeInLabel("No damage is dealt!");

func writeInLabel(text):
	
	label.text = label.text + text + "\n"

func rock_paper_scissor_result(ownBadge, enemyBadge):
	if (ownBadge == enemyBadge):
		return "Tie"
	elif (ownBadge == "None"):
		return "Lost"
	elif (enemyBadge == "None"):
		return "Win"
	elif (ownBadge == "Paper" && enemyBadge == "Rock"):
		return "Win"
	elif (ownBadge == "Scissor" && enemyBadge == "Paper"):
		return "Win"
	else:
		return "Lost"
	

func random_move():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randomNumber = rng.randi_range(0, 2)
	if (randomNumber == 0):
		return "Nuzzle"
	elif (randomNumber == 1):
		return "Tackle"
	elif (randomNumber == 2):
		return "Scratch"

var pokemon : Dictionary = {
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

var moves : Dictionary = {
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
