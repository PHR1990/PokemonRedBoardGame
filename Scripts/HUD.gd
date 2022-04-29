extends Node

var ownPokemon
var enemyPokemon
var label

onready var currentSize = get_viewport().size

onready var enemyPokemonCardPosition = Vector2(currentSize.x / 2 - 160, 25)
onready var ownPokemonCardPosition = Vector2(currentSize.x / 2 -160, 275 )

onready var moveCardScene = load("res://Scenes/MoveCardScene.tscn")
onready var pokemonCardScene = load("res://Scenes/PokemonCardScene.tscn")

onready var moveCardAtPositionOne = Vector2(80, 330)
onready var moveCardAtPositionTwo = Vector2(220 , 330)
onready var moveCardAtPositionThree = Vector2(80  , 470)

# Called when the node enters the scene tree for the first time.
func _ready():
	label = $Label
	label.text = ""
	display_enemy_card("Charmander")
	display_own_pokemon_card("Squirtle")
	
	display_move_card(1, "Tackle")
	display_move_card(2, "Growl")
	display_move_card(3, "Bubble")

func display_own_pokemon_card(pokemonName):
	ownPokemon = create_pokemon_card(pokemonCardScene, ownPokemonCardPosition , pokemonName)

func display_enemy_card(pokemonName):
	enemyPokemon = create_pokemon_card(pokemonCardScene, enemyPokemonCardPosition, pokemonName)
	
func create_pokemon_card(pokemonCardScene, position, pokemonName):
	
	var pokemonInstance = pokemonCardScene.instance()
	
	pokemonInstance.hp = pokemon.get(pokemonName).HP
	pokemonInstance.pokemonName = pokemonName
	pokemonInstance.type = pokemon.get(pokemonName).Type
	pokemonInstance.affinity = pokemon.get(pokemonName).Affinity
	pokemonInstance.set_position(position)
	add_child(pokemonInstance)
	return pokemonInstance

func display_move_card(position, moveName):
	match position:
		1: 
			create_move_card(moveCardScene, moveName, moves.get(moveName), moveCardAtPositionOne)
		2:
			create_move_card(moveCardScene,moveName, moves.get(moveName), moveCardAtPositionTwo)
		3:
			create_move_card(moveCardScene,moveName, moves.get(moveName), moveCardAtPositionThree)

func create_move_card(moveCardScene,moveName, move, position):
	var move_instance = moveCardScene.instance()
	
	move_instance.moveName = moveName
	move_instance.affinityCostAmount = move.cost
	move_instance.damageAmount = move.damage
	move_instance.type = move.type
	move_instance.badge = move.badge
	
	move_instance.set_position(position)
	move_instance.connect("card_used", self, "_on_MoveCardScene_card_used")
	add_child(move_instance)
	
func _on_MoveCardScene_card_used(moveName):
	process_attack(moveName)

func process_attack(moveName):
	label.text = ""
	var ownMove = moves.get(moveName)
	var enemyMove = moves.get(random_move())
	
	var result = rock_paper_scissor_result(ownMove.badge, enemyMove.badge)
	
	display_text("You choose: " + ownMove.badge)
	display_text("Enemy chose: " + enemyMove.badge)
	
	if (result == "Win"):
		display_text("You go first!");
		enemyPokemon.damage(ownMove.damage)
		display_text("Enemy " + str(ownMove.damage) + " damage");
		yield(get_tree().create_timer(2.0), "timeout")
		display_text("You took " + str(enemyMove.damage) + " damage");
		ownPokemon.damage(enemyMove.damage)
	elif (result == "Lost"):
		display_text("Enemy goes first!");
		display_text("You took " + str(enemyMove.damage) + " damage");
		ownPokemon.damage(enemyMove.damage)
		yield(get_tree().create_timer(2.0), "timeout")
		display_text("Enemy " +  str(ownMove.damage) + " damage");
		enemyPokemon.damage(ownMove.damage)
	else:
		display_text("It was a tie!");
		display_text("No damage is dealt!");

func display_text(text):
	
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
