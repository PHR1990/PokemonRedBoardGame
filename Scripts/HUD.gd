extends Node

var ownPokemon
var enemyPokemon
var label

signal change_pokemon_card_pressed(buttonIndex)
signal move_card_was_pressed(cardName)

onready var currentSize = get_viewport().size

onready var enemyPokemonCardPosition = Vector2(currentSize.x / 2 - 160, 25)
onready var ownPokemonCardPosition = Vector2(currentSize.x / 2 -160, 275 )

onready var moveCardScene = load("res://Scenes/MoveCardScene.tscn")
onready var pokemonCardScene = load("res://Scenes/PokemonCardScene.tscn")

onready var moveCardAtPositionOne = Vector2(80, 330)
onready var moveCardAtPositionTwo = Vector2(220, 330)
onready var moveCardAtPositionThree = Vector2(80, 470)
onready var moveCardAtPositionFour = Vector2(220, 470)

onready var dictionary = load("res://Scripts/DataDictionary.gd").new()

var firstMoveElementRef
var secondMoveElementRef
var thirdMoveElementRef
var fourthMoveElementRef

# Called when the node enters the scene tree for the first time.
func _ready():
	label = $Label
	label.text = ""
	$canvasLayer.get_node("buttonOne").connect("pressed", self, "_button_one_pressed")
	$canvasLayer.get_node("buttonOne").set_tooltip("Squirtle")
	$canvasLayer.get_node("buttonTwo").connect("pressed", self, "_button_two_pressed")
	$canvasLayer.get_node("buttonTwo").set_tooltip("Pikachu")
	$canvasLayer.get_node("buttonThree").connect("pressed", self, "_button_three_pressed")
	$canvasLayer.get_node("buttonThree").set_tooltip("Charmander")

	
func display_own_pokemon_card(pokemonName):
	ownPokemon = create_pokemon_card(pokemonCardScene, ownPokemonCardPosition , pokemonName)

func display_enemy_card(pokemonName):
	enemyPokemon = create_pokemon_card(pokemonCardScene, enemyPokemonCardPosition, pokemonName)

func clean_up_own_pokemon_data():
	if is_instance_valid(ownPokemon):
		ownPokemon.queue_free()
	
	if is_instance_valid(firstMoveElementRef):
		firstMoveElementRef.queue_free()
	if is_instance_valid(secondMoveElementRef):
		secondMoveElementRef.queue_free()
	if is_instance_valid(thirdMoveElementRef):
		thirdMoveElementRef.queue_free()
	if is_instance_valid(fourthMoveElementRef):
		fourthMoveElementRef.queue_free()
	
func switch_own_pokemon(pokemonName): 
	clean_up_own_pokemon_data()
	display_own_pokemon_card(pokemonName)
	var moves = dictionary.pokemon.get(pokemonName).Moves
	
	for x in range(0, len(moves)):
		display_move_card(x, moves[x])

func create_pokemon_card(pokemonCardScene, position, pokemonName):
	
	var pokemonInstance = pokemonCardScene.instance()
	
	pokemonInstance.hp = dictionary.pokemon.get(pokemonName).HP
	pokemonInstance.pokemonName = pokemonName
	pokemonInstance.type = dictionary.pokemon.get(pokemonName).Type
	pokemonInstance.affinity = dictionary.pokemon.get(pokemonName).Affinity
	pokemonInstance.set_position(position)
	add_child(pokemonInstance)
	return pokemonInstance

func display_move_card(position, moveName):
	match position:
		0: 
			firstMoveElementRef = create_move_card(moveCardScene, moveName, dictionary.moves.get(moveName), moveCardAtPositionOne)
		1:
			secondMoveElementRef = create_move_card(moveCardScene,moveName, dictionary.moves.get(moveName), moveCardAtPositionTwo)
		2:
			thirdMoveElementRef = create_move_card(moveCardScene,moveName, dictionary.moves.get(moveName), moveCardAtPositionThree)
		3:
			fourthMoveElementRef = create_move_card(moveCardScene,moveName, dictionary.moves.get(moveName), moveCardAtPositionFour)

func create_move_card(moveCardScene, moveName, move, position):
	var instanceName = "Move"
	
	var move_instance = moveCardScene.instance()
	move_instance.name = instanceName
	move_instance.moveName = moveName
	
	move_instance.affinityCostAmount = move.cost
	move_instance.damageAmount = move.damage
	move_instance.type = move.type
	move_instance.badge = move.badge
	
	move_instance.set_position(position)
	move_instance.connect("card_used", self, "_on_MoveCardScene_card_used")
	add_child(move_instance)
	return move_instance
	
func _on_MoveCardScene_card_used(moveName):
	emit_signal("move_card_was_pressed", moveName)
	
func _button_one_pressed():
	emit_signal("change_pokemon_card_pressed", 1)
	
func _button_two_pressed():
	emit_signal("change_pokemon_card_pressed", 2)
	
func _button_three_pressed():
	emit_signal("change_pokemon_card_pressed", 3)

func reset_label():
	label.text = ""

func display_text(text):
	label.text = label.text + text + "\n"
