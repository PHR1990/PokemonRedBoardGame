extends Node

var animationsPlaying := 0

signal released_lock()

func enqueue_animation():
	
	animationsPlaying+=1

func dequeue_animation():
	animationsPlaying-=1

func is_playing_animation() -> bool:
	print("Is playing ", animationsPlaying > 0)
	return animationsPlaying > 0
		

func wait_all_animations():
	while animationsPlaying > 0:
		yield(get_tree().create_timer(0.05), "timeout")
	return
