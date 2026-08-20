extends SceneTree

func _initialize():
	call_deferred("run_smoke_test")

func run_smoke_test():
	await process_frame
	var menu = load("res://medula/scenes/Menu.tscn").instantiate()
	root.add_child(menu)
	await process_frame
	menu.introRunning = false
	menu._on_AnimationPlayer_animation_finished(&"main")
	await process_frame
	menu._on_Button_pressed()
	await process_frame
	var gameplay = menu.gameplayInstance
	if gameplay == null or gameplay.events.size() != 260:
		push_error("Gameplay did not load the expected dummy3 chart")
		quit(1)
		return
	gameplay.instanceNote()
	await process_frame
	if gameplay.currentEvent != 1:
		push_error("Gameplay did not instantiate its first note")
		quit(1)
		return
	root.get_node("global").score = 12000
	gameplay.createScoreInstance()
	await process_frame
	var score_holder = gameplay.get_node("ScoreHolder")
	var score_screen = score_holder.get_child(score_holder.get_child_count() - 1)
	score_screen.score_tween()
	for frame in range(120):
		await process_frame
	print("PORT_SMOKE_OK")
	quit()
