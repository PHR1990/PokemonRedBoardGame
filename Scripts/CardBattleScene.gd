extends Node

onready var dictionary = load("res://Scripts/DataDictionary.gd").new()

var enemyPokemonName = "Squirtle"

func _ready():
	$HUD.display_enemy_card(enemyPokemonName)
	$HUD.switch_own_pokemon("Charmander")
	
	$HUD.connect("change_pokemon_card_pressed", self, "_change_card")
	$HUD.connect("move_card_was_pressed", self, "_move_card_pressed")


func _change_card(position):
	if position == 1:
		$HUD.switch_own_pokemon("Jigglypuff")
	elif position == 2:
		$HUD.switch_own_pokemon("Bulbasaur")
	else:
		$HUD.switch_own_pokemon("Charmander")
	
	$HUD.display_action("Player \n\n Changed\n pokemon")
		
func _move_card_pressed(moveName):
	$HUD.reset_action_cards()
	var ownMove = dictionary.moves.get(moveName)
	var enemyMove = dictionary.moves.get(random_move())
	
	var result = rock_paper_scissor_result(ownMove.badge, enemyMove.badge)
	
	$HUD.display_action_at_position("You choose \n" + ownMove.badge, 1)
	yield(get_tree().create_timer(0.5), "timeout")
	$HUD.display_action_at_position("Enemy chose \n" + enemyMove.badge, 2)
	
	if enemyMove.cost <= $HUD.enemyPokemon.currentAffinity:
		$HUD.enemyPokemon.consume_affinity(enemyMove.cost)
	
	if "recover" in enemyMove:
		$HUD.enemyPokemon.recover_affinity(enemyMove.recover)
	
	if "recover" in ownMove:
		
		$HUD.ownPokemon.recover_affinity(ownMove.recover)
	
	if ownMove.cost <= $HUD.ownPokemon.currentAffinity:
		$HUD.ownPokemon.consume_affinity(ownMove.cost)
	
	yield(get_tree().create_timer(0.5), "timeout")
	$HUD.reset_action_cards()
	
	if (result == "Win"):
		#$HUD.display_text("You go first!");
		$HUD.enemyPokemon.damage(ownMove.damage)
		$HUD.display_action_at_position("Enemy took \n" + str(ownMove.damage) + " damage", 1);
		yield(get_tree().create_timer(1.0), "timeout")
		$HUD.display_action_at_position("You took \n" + str(enemyMove.damage) + " damage", 2);
		$HUD.ownPokemon.damage(enemyMove.damage)
	elif (result == "Lost"):
		#$HUD.display_text("Enemy goes first!");
		$HUD.display_action_at_position("You took \n" + str(enemyMove.damage) + " damage", 1);
		$HUD.ownPokemon.damage(enemyMove.damage)
		yield(get_tree().create_timer(1.0), "timeout")
		$HUD.display_action_at_position("Enemy took \n" +  str(ownMove.damage) + " damage", 2);
		$HUD.enemyPokemon.damage(ownMove.damage)
	else:
		$HUD.display_action_at_position("It was a tie!", 1);
		yield(get_tree().create_timer(1.0), "timeout")
		$HUD.display_action_at_position("No damage\n was dealt!", 2);

func random_move():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var movesList = dictionary.pokemon.get(enemyPokemonName).Moves
	var randomNumber = rng.randi_range(0, len(movesList)-1)
	
	return movesList[randomNumber]
	

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
