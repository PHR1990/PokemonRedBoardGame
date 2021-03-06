extends Node

var ownPokemon
var enemyPokemon
var label

signal change_pokemon_card_pressed(buttonIndex)
signal move_card_was_pressed(cardName)

onready var currentSize = get_viewport().size

onready var enemyPokemonCardPosition = Vector2(currentSize.x / 2 - 160, 25)
onready var ownPokemonCardPosition = Vector2(currentSize.x / 2 -160, 270)

onready var moveCardScene = load("res://Scenes/CardBattleScene/MoveCardScene.tscn")
onready var pokemonCardScene = load("res://Scenes/CardBattleScene/PokemonCardScene.tscn")
onready var actionCardScene = load("res://Scenes/CardBattleScene/ActionCardScene.tscn")

onready var moveCardAtPositionOne = Vector2(220, 470)
onready var moveCardAtPositionTwo = moveCardAtPositionOne + Vector2(100,0)
onready var moveCardAtPositionThree = moveCardAtPositionTwo + Vector2(100,0)
onready var moveCardAtPositionFour = moveCardAtPositionThree + Vector2(100,0)


onready var actionCardPositionOne = Vector2(currentSize.x /2 + 50, 235)
onready var actionCardPositionTwo = actionCardPositionOne + Vector2(120,0)
onready var actionCardPositionThree = actionCardPositionTwo + Vector2(120,0)

onready var dictionary = load("res://Scripts/DataDictionary.gd").new()

var firstMoveElementRef
var secondMoveElementRef
var thirdMoveElementRef
var fourthMoveElementRef

var moveCardsArray : Array

var actionCardsArray : Array

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
	
	
func disable_button(buttonIndex):
	match(buttonIndex):
		0: 
			$canvasLayer.get_node("buttonOne").set_disabled(true)
		1:
			$canvasLayer.get_node("buttonTwo").set_disabled(true)
		2:
			$canvasLayer.get_node("buttonThree").set_disabled(true)
	

func set_tooltip_pokemon_switch_button(buttonIndex, pokemonName):
	match(buttonIndex):
		0: 
			$canvasLayer.get_node("buttonOne").set_tooltip(pokemonName)
		1:
			$canvasLayer.get_node("buttonTwo").set_tooltip(pokemonName)
		2:
			$canvasLayer.get_node("buttonThree").set_tooltip(pokemonName)
	
func display_own_pokemon_card_by_data(pokemonData):
	ownPokemon = create_pokemon_card_by_data(pokemonCardScene, ownPokemonCardPosition, pokemonData)
	
func display_enemy_card_by_data(pokemonData):
	print("Displaying", pokemonData)
	enemyPokemon = create_pokemon_card_by_data(pokemonCardScene, enemyPokemonCardPosition, pokemonData)

func clean_up_own_pokemon_data():
	if is_instance_valid(ownPokemon):
		ownPokemon.queue_free()
	
	for x in range(0, moveCardsArray.size()):
		if is_instance_valid(moveCardsArray[x]):
			moveCardsArray[x].queue_free()
	
func switch_own_pokemon_by_data(pokemonData): 
	clean_up_own_pokemon_data()
	display_own_pokemon_card_by_data(pokemonData)
	var moves = dictionary.pokemon.get(pokemonData.pokemon.Name).Moves
	
	for x in range(0, len(moves)):
		display_move_card(x, moves[x])

func create_pokemon_card_by_data(pokemonCardScene, position, pokemonData):
	
	var pokemonInstance = pokemonCardScene.instance()
	
	pokemonInstance.hp = pokemonData.pokemon.HP
	
	pokemonInstance.currentHp = pokemonData.currentHp
	pokemonInstance.pokemonName = pokemonData.pokemon.Name
	pokemonInstance.type = pokemonData.pokemon.Type
	pokemonInstance.affinity = pokemonData.pokemon.Affinity
	pokemonInstance.set_position(position)
	
	add_child(pokemonInstance)
	return pokemonInstance

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
			create_move_card(moveCardScene, moveName, dictionary.moves.get(moveName), moveCardAtPositionOne)
		1:
			create_move_card(moveCardScene,moveName, dictionary.moves.get(moveName), moveCardAtPositionTwo)
		2:
			create_move_card(moveCardScene,moveName, dictionary.moves.get(moveName), moveCardAtPositionThree)
		3:
			create_move_card(moveCardScene,moveName, dictionary.moves.get(moveName), moveCardAtPositionFour)

func display_action(actionName):
	display_action_at_position(actionName, 0)

func display_action_at_position(actionName, position):
	var targetPosition = actionCardPositionOne
	if position == 1:
		targetPosition = actionCardPositionTwo
	elif position == 2:
		targetPosition = actionCardPositionThree
	
	var newActionCardScene = actionCardScene.instance()
	
	newActionCardScene.actionText = actionName;
	newActionCardScene.position = targetPosition
	add_child(newActionCardScene)
	apply_effect_fall_into_board(newActionCardScene)
	actionCardsArray.append(newActionCardScene)
	
func apply_effect_fall_into_board(card):
	var highestSize = 4
	var currentScale = Vector2(highestSize, highestSize)
	while currentScale > Vector2(1,1):
		yield(get_tree().create_timer(0.01), "timeout")
		currentScale -= Vector2(0.25,0.25)
		if is_instance_valid(card):
			card.scale = currentScale
	
	if is_instance_valid(card):
		card.scale = Vector2(1,1)

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
	moveCardsArray.append(move_instance)
	
func _on_MoveCardScene_card_used(moveName):
	emit_signal("move_card_was_pressed", moveName)
	
func _button_one_pressed():
	emit_signal("change_pokemon_card_pressed", 0)
	
func _button_two_pressed():
	emit_signal("change_pokemon_card_pressed", 1)
	
func _button_three_pressed():
	emit_signal("change_pokemon_card_pressed", 2)

func reset_action_cards():
	for x in range(0, actionCardsArray.size()):
		if is_instance_valid(actionCardsArray[x]):
			actionCardsArray[x].queue_free()
