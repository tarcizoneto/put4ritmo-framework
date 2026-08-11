extends ColorRect

var currentStar = 0
var tosummon = []
#var preMusicaCupom = preload("res://scenes/CupomMusica.tscn")#
var preScoreBar = preload("res://medula/scenes/ScoreBar_fromScoreBG.tscn")
var preSongTitleforScore = preload("res://medula/scenes/SongTitle_fromScoreBG.tscn")
var trofeu = preload("res://medula/scenes/TrofeuUnlock.tscn")
var cupommusicaAmount = 0
var mariedasAmount = 0
var cupomListaAmount = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	if get_viewport_rect().size.y > 1920:
		$Cover.rect_scale = Vector2(get_viewport_rect().size.y/1920, get_viewport_rect().size.y/1920)
	$AnimationPlayer.play("enter")
	randomize()
	#color = Color(rand_range(0, .35),rand_range(0, .35),rand_range(0, .35))
	$Cover.texture = load(global.returnpath('cover', global.codename))
	$CoverDeco.texture = load(global.returnpath('cover', global.codename))
	
	var newStyleBoxPlayNormal = load('res://styles/ButtonStyleBox.tres')
	var newStyleBoxPlayPressed = load('res://styles/ButtonStyleBoxP.tres')
	
	newStyleBoxPlayNormal.border_color = global.defaultColors[0]
	newStyleBoxPlayPressed.border_color = global.defaultColors[1]
	
	$ContinueHolder/Continue.add_stylebox_override("normal", newStyleBoxPlayNormal)
	$ContinueHolder/Continue.add_stylebox_override("pressed", newStyleBoxPlayPressed)
	$ContinueHolder/Continue.add_stylebox_override("hover", newStyleBoxPlayPressed)
	
	var currentSonginScore = 0
	for score in global.albumModeScores:
		var newSongTitle = preSongTitleforScore.instance()
		newSongTitle.text = global.database[global.songlistInOrder[currentSonginScore]].Title + ' — ' + global.database[global.songlistInOrder[currentSonginScore]].Artist
		$ScrollContainer/ScoresVBoxContainer.add_child(newSongTitle)
		var newScoreBar = preScoreBar.instance()
		newScoreBar.score = score
		$ScrollContainer/ScoresVBoxContainer.add_child(newScoreBar)
		currentSonginScore += 1

func score_tween():
	for score in $ScrollContainer/ScoresVBoxContainer.get_children():
		if 'ScoreBar' in score.name:
			score.score_tween()
	$HBoxContainer/Mariedas/anim.play("+1")
	$HBoxContainer/CupomMusicaHolder/anim.play("+1")

func _process(delta):
		$HBoxContainer/CupomMusicaHolder/Amount.text = str(cupommusicaAmount)
		$HBoxContainer/Mariedas/Amount.text = str(mariedasAmount)
		$HBoxContainer/CupomListaAchieved/Amount.text = str(cupomListaAmount)

func _on_Continue_pressed():
	
	
	
	# ENTER CREDITS
	
	
	
	
	get_parent().get_parent().get_parent().reloadInfo(true, tosummon)
	get_parent().get_child(get_parent().get_child_count()-1).queue_free()
	$AnimationPlayer.play_backwards("left")
	
	global.store_save()
	get_parent().get_parent().queue_free()



func _on_Tween_tween_all_completed():
	$ContinueHolder/AnimationPlayer.play("main")
	$SURTOCHEER.play('main')
	add_child(trofeu.instance())
	$TrofeuShowTimer.start()
	$HBoxContainer/Mariedas/anim.stop(true)
	$HBoxContainer/CupomMusicaHolder/anim.stop()
#	global.addProgressTask('getmariedas', round(global.score/1000))
#	global.addProgressTask('points', round(global.score))

func holdermusica(isMarieda = false, isCUpom = false):
	if isMarieda:
		mariedasAmount +=1
		global.addProgressTask('getmariedas', 1)
		return
	if isCUpom:
		cupomListaAmount += 1
		$HBoxContainer/CupomListaAchieved/anim.play("main")
		return
	cupommusicaAmount += 1
	global.addProgressTask('stars', 1)
	global.addProgressTask('getcupom', 1)



func _on_PlayAgain_pressed():
	get_parent().get_parent().get_parent()._on_Button_pressed()
	
	get_parent().get_child(get_parent().get_child_count()-1).queue_free()
	get_parent().get_parent().queue_free()


func _on_TrofeuShowTimer_timeout():
	add_child(trofeu.instance())
