extends ColorRect

var currentStar = 0
var tosummon = []
var preMusicaCupom = preload("res://medula/scenes/CupomMusica.tscn")
var cupommusicaAmount = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	if get_viewport_rect().size.y > 1920:
		$Cover.rect_scale = Vector2(get_viewport_rect().size.y/1920, get_viewport_rect().size.y/1920)
	$AnimationPlayer.play("enter")
	randomize()
	color = Color(rand_range(0, .35),rand_range(0, .35),rand_range(0, .35))
	$Cover.texture = load(global.returnpath('cover', global.codename))
	$CoverDeco.texture = load(global.returnpath('cover', global.codename))
	
	var newStyleBoxPlayNormal = load('res://medula/styles/ButtonStyleBox.tres')
	var newStyleBoxPlayPressed = load('res://medula/styles/ButtonStyleBoxP.tres')
	
	newStyleBoxPlayNormal.border_color = global.defaultColors[0]
	newStyleBoxPlayPressed.border_color = global.defaultColors[1]
	
	
	
	$ContinueHolder/Continue.add_stylebox_override("normal", newStyleBoxPlayNormal)
	$ContinueHolder/Continue.add_stylebox_override("pressed", newStyleBoxPlayPressed)
	$ContinueHolder/Continue.add_stylebox_override("hover", newStyleBoxPlayPressed)
	$ContinueHolder/PlayAgain.add_stylebox_override("pressed", newStyleBoxPlayNormal)
	$ContinueHolder/PlayAgain.add_stylebox_override("hover", newStyleBoxPlayNormal)
	$ContinueHolder/PlayAgain.add_stylebox_override("normal", newStyleBoxPlayPressed)

func score_tween():
	if global.score >= 9000:
		$ScoreBar/Tween.interpolate_property($ScoreBar, 'value', 0, global.score, 7, Tween.TRANS_QUART, Tween.EASE_OUT)
	elif global.score < 9000 and global.score > 1000:
		$ScoreBar/Tween.interpolate_property($ScoreBar, 'value', 0, global.score, 3, Tween.TRANS_QUART, Tween.EASE_OUT)
	else:
		$ScoreBar/Tween.interpolate_property($ScoreBar, 'value', 0, global.score, 1, Tween.TRANS_QUART, Tween.EASE_OUT)
	$ScoreBar/Tween.start()
	$Mariedas/anim.play("+1")
	$Riser.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $ScoreBar/Tween.is_active():
		$ScoreLabel/anim.stop()
		$ScoreLabel.text = str(int($ScoreBar.value))
		
		if $ScoreBar.value >= 9000 and currentStar == 0:
			$StarAchieve.play()
			$ScoreBar/.get_node("1/anim").play("explode")
			currentStar += 1
			tosummon.append('musica')
			
			var cupom = preMusicaCupom.instance()
			cupom.initialPOS = Vector2(236,1024)
			cupom.finalPOS = Vector2(357,1329)
			cupom.duration = 2.34241
			add_child(cupom)
		if $ScoreBar.value >= 18000 and currentStar == 1:
			$StarAchieve.play()
			$ScoreBar/.get_node("2/anim").play("explode")
			currentStar += 1
			tosummon.append('musica')
			
			var cupom = preMusicaCupom.instance()
			cupom.initialPOS = Vector2(405,1024)
			cupom.finalPOS = Vector2(357,1329)
			cupom.duration = 2.34241
			add_child(cupom)
		if $ScoreBar.value >= 27000 and currentStar == 2:
			$StarAchieve.play()
			$ScoreBar/.get_node("3/anim").play("explode")
			currentStar += 1
			tosummon.append('musica')
			
			var cupom = preMusicaCupom.instance()
			cupom.initialPOS = Vector2(582,1024)
			cupom.finalPOS = Vector2(357,1329)
			cupom.duration = 2.34241
			add_child(cupom)
		if $ScoreBar.value >= 36000 and currentStar == 3:
			$StarAchieve.play()
			$ScoreBar/.get_node("4/anim").play("explode")
			currentStar += 1
			tosummon.append('musica')
			
			var cupom = preMusicaCupom.instance()
			cupom.initialPOS = Vector2(750,1024)
			cupom.finalPOS = Vector2(357,1329)
			cupom.duration = 2.34241
			add_child(cupom)
		if $ScoreBar.value >= 45000 and currentStar == 4:
			$StarAchieve.play()
			$ScoreBar/.get_node("5/anim").play("explode")
			currentStar += 1
			tosummon.append('musica')
			
			var cupom = preMusicaCupom.instance()
			cupom.initialPOS = Vector2(921,1024)
			cupom.finalPOS = Vector2(357,1329)
			cupom.duration = 2.34241
			add_child(cupom)
		$CupomMusicaHolder/Amount.text = str(cupommusicaAmount)
		$Mariedas/Amount.text = str(round($ScoreBar.value/1000))
		
		
		if $ScoreBar.value >= 50000:
			$Riser.stop()
			if !$FireworkAchieve.playing:
				$FireworkAchieve.play()
			$CupomListaAchieved/anim.play("main")
			tosummon.append('lista')
		
		


func _on_Continue_pressed():
	get_parent().get_parent().get_parent().reloadInfo(true, tosummon)
	get_parent().get_child(get_parent().get_child_count()-1).queue_free()
	$AnimationPlayer.play_backwards("left")
	
	global.store_save()
	get_parent().get_parent().queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	if !$ScoreBar/Tween.is_active():
		queue_free()



func _on_Tween_tween_all_completed():
	$ContinueHolder/AnimationPlayer.play("main")
	$Mariedas/anim.stop(true)
	$Riser.stop()
	if global.score > 27000:
		$Cheer.play()
		global.addProgressTask('playsong', 1, global.codename)
	else:
		$Failure.play()
	global.addProgressTask('getmariedas', round(global.score/1000))
	global.addProgressTask('points', round(global.score))

func holdermusica():
	cupommusicaAmount += 1
	global.addProgressTask('stars', 1)
	global.addProgressTask('getcupom', 1)


func _on_ScoreBar_value_changed(value):
	$ScoreLabel/anim.stop()
	$ScoreLabel/anim.play("perfect")


func _on_PlayAgain_pressed():
	get_parent().get_parent().get_parent()._on_Button_pressed()
	
	get_parent().get_child(get_parent().get_child_count()-1).queue_free()
	get_parent().get_parent().queue_free()
