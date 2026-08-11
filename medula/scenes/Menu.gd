extends Control

var gameplayScene = preload("res://medula/scenes/Gameplay.tscn")
var gameplayInstance = null
var songinsonglist = preload("res://medula/scenes/Song_insonglist.tscn")
var cupomAnimation = preload("res://medula/scenes/CupomMusica.tscn")
var Sync = preload("res://medula/scenes/SyncMenu.tscn")
var longTitle = 0
var tempSonglist = []
var introRunning = false

func _ready():
	randomize()
	$Intro/AnimationPlayer.play("main")
	$Intro.visible = true
	var lightColor_Darker = global.defaultColors[0]
	var darkColor_Darker = global.defaultColors[1]
	print(lightColor_Darker)
	print(darkColor_Darker)
	lightColor_Darker.r -= 0.35
	lightColor_Darker.g -= 0.35
	lightColor_Darker.b -= 0.35
	darkColor_Darker.r -= 0.35
	darkColor_Darker.g -= 0.35
	darkColor_Darker.b -= 0.35
	
	var newStyleBoxPlayNormal = load('res://medula/styles/ButtonStyleBox.tres')
	var newStyleBoxPlayPressed = load('res://medula/styles/ButtonStyleBoxP.tres')
	var newStyleBoxSonglist = load('res://medula/styles/SonglistStyleBox.tres')
	var newStyleBoxSonglistP = load('res://medula/styles/SonglistStyleBoxP.tres')
	
	newStyleBoxPlayNormal.border_color = global.defaultColors[0]
	newStyleBoxPlayPressed.border_color = global.defaultColors[1]
	newStyleBoxSonglist.bg_color = darkColor_Darker
	newStyleBoxSonglistP.bg_color = lightColor_Darker
	
	
	$Main/Play.add_stylebox_override("normal", newStyleBoxPlayNormal)
	$Main/Songlist.add_stylebox_override("normal", newStyleBoxSonglist)
	$Main/Play.add_stylebox_override("pressed", newStyleBoxPlayPressed)
	$Main/Play.add_stylebox_override("hover", newStyleBoxPlayPressed)
	$Main/Songlist.add_stylebox_override("pressed", newStyleBoxSonglistP)
	$Main/Songlist.add_stylebox_override("hover", newStyleBoxSonglistP)
	
func reloadInfo(reloadSong = true, tosummon = []):
	$Main/Title/Tween.stop_all()
	$Main/Title.rect_size.x = 1080
	$Main/Title.rect_position.x = 0
	$CupomMusicaHolder/Amount.text = str(global.cupomMusica)
	$CupomListaHolder/Amount.text = str(global.cupomLista)
	$Mariedas/Amount.text = str(global.mariedas)
	
	
	
#	if comingFromScore:
#		for i in tosummon:
#			match i:
#				'musica':
#					var cupom = cupomAnimation.instance()
#					cupom.initialPOS = Vector2(540,960)
#					cupom.finalPOS = Vector2(701,102)
#					cupom.delay = true
#					add_child(cupom)
#				'lista':
#					var cupom = cupomAnimation.instance()
#					cupom.type = 'lista'
#					cupom.initialPOS = Vector2(540,960)
#					cupom.finalPOS = Vector2(942,102)
#					cupom.delay = true
#					add_child(cupom)
	
	$Main/Cover.texture = load(global.returnpath('cover', global.codename))
	match global.progressDifficulty[global.codename]:
		'm':
			$Main/Medals/e.visible = false
			$Main/Medals/m.visible = false
			$Main/Medals/h.visible = false
			$Main/Difficulty.text = 'Normal'
			$Main/Difficulty.add_color_override("font_outline_modulate", Color('a8a8a8'))
			
		'h': 
			$Main/Medals/e.visible = true
			$Main/Medals/m.visible = false
			$Main/Medals/h.visible = false
			$Main/Difficulty.text = 'Difícil'
			$Main/Difficulty.add_color_override("font_outline_modulate", Color('ff9700'))
		'x': 
			$Main/Medals/e.visible = true 
			$Main/Medals/m.visible = true
			$Main/Medals/h.visible = false
			#$Main/Difficulty.text = 'Extremo'
			$Main/Difficulty.add_color_override("font_outline_modulate", Color(1, 0, 0, 1))
		'x2': 
			$Main/Medals/e.visible = true 
			$Main/Medals/m.visible = true
			$Main/Medals/h.visible = true
			$Main/Difficulty.text = 'Extremo'
			$Main/Difficulty.add_color_override("font_outline_modulate", Color(1, 0, 0, 1))
	global.load_save()
	if global.hiscores[global.codename] > 0:
	
		$Main/HiScore.text = str(global.hiscores[global.codename])
		$Main/HiScore.modulate.a = 1
	else:
		$Main/HiScore.modulate.a = 0
	
	if reloadSong:
		$Main/preview.stop()
		$Main/Title.text = global.database[global.codename].Title
		$Main/Artist.text = global.database[global.codename].Artist
		$anim.stop()
		$anim.play("enter")
		$Main/preview.stream = global.songaudios[global.codename]
		$Main/preview.stream_paused = false
		$Main/preview.play(global.database[global.codename].preview)
		$Main/PreviewTime.start()
		$Main/Title/Tween.stop_all()
		$Main/Title.rect_size.x = 1080
		$Main/Title.rect_position.x = 0
		if global.database[global.codename].hard:
			$Main/Title/AnimationPlayer.play("hardSong")
			$Main/Title/.text += ' (extrema)'
		else:
			$Main/Title/AnimationPlayer.play("normalSong")
		
		for songOrder in global.songlistInOrder:
			if songOrder in global.songlist:
				tempSonglist.append(songOrder)
		print(tempSonglist)
		global.songlist = tempSonglist
		tempSonglist = []
	

func albumModeInstance():
	$click.play()
	$Main/PreviewTime.stop()
	$Main/preview.stop()
	$Main/preview.stream_paused = true
	gameplayInstance = gameplayScene.instance()
	gameplayInstance.codename = global.songlistInOrder[0]
	gameplayInstance.ALBUMMODE = true
	gameplayInstance.isParentofAlbumMode = true
	add_child(gameplayInstance)

func _on_Button_pressed():
	$click.play()
	$Main/PreviewTime.stop()
	$Main/preview.stop()
	$Main/preview.stream_paused = true
	gameplayInstance = gameplayScene.instance()
	gameplayInstance.codename = global.codename
	add_child(gameplayInstance)

func remakeSonglist():
	for i in global.songlist:
		var song = songinsonglist.instance()
		song.codename = i
		$SonglistBG/ScrollContainer/VBoxContainer.add_child(song)

func songlistSelected(code):
	$SonglistBG.visible = false
	for i in $SonglistBG/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	global.codename = code
	reloadInfo()
	

func destroySonglist():
	$SonglistBG.visible = false
	for i in $SonglistBG/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()

func _on_Songlist_pressed():
	$click.play()
	$SonglistBG.visible = true
	remakeSonglist()


func _on_PreviewTime_timeout():
	$Main/preview.play(global.database[global.codename].preview)
	$Main/PreviewTime.start()


func _on_Back_pressed():
	$click.play()
	destroySonglist()


func _on_Store_pressed():
	$click.play()
	$Store.visible = true
	$Main.visible = false
	$Tasks.hide()


func _on_Home_pressed():
	$click.play()
	$Main.visible = true
	$Store.visible = false
	$Tasks.hide()
	


func _on_CupomMusicaHolder_mouse_entered():
	global.cupomMusica += 5
	global.break_save()
	reloadInfo()


func _on_AnimationPlayer_animation_finished(anim_name):
	reloadInfo()
	$Intro.queue_free()

func introLogoRunning(tf):
	if introRunning and !tf:
		$Intro/Tween.interpolate_property($Intro/Logo, 'rect_position', $Intro/Logo.rect_position, Vector2($Intro/Logo.rect_position.x, get_viewport_rect().size.y), 1.2, Tween.TRANS_EXPO, Tween.EASE_IN)
		$Intro/Tween.start()
	introRunning = tf



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if introRunning:
		$Intro/Logo.rect_position = Vector2(get_viewport_rect().size.x/2-$Intro/Logo.rect_size.x/2, get_viewport_rect().size.y/2-$Intro/Logo.rect_size.y/2)
		
	if $Main/Title.rect_size.x > 1080 and !$Main/Title/Tween.is_active():
		if longTitle == 0:
			$Main/Title/Tween.interpolate_property($Main/Title, "rect_position",  Vector2(0, $Main/Title.rect_position.y), Vector2(+(1080-$Main/Title.rect_size.x), $Main/Title.rect_position.y), 3, Tween.TRANS_LINEAR)
			longTitle = 1
		else:
			$Main/Title/Tween.interpolate_property($Main/Title, "rect_position",  Vector2(+(1080-$Main/Title.rect_size.x), $Main/Title.rect_position.y), Vector2(0, $Main/Title.rect_position.y), 3, Tween.TRANS_LINEAR)
			longTitle = 0
		$Main/Title/Tween.start()
			
	if get_viewport_rect().size.y > 1920:
		$Main/Cover.rect_scale = Vector2(get_viewport_rect().size.y/1920, get_viewport_rect().size.y/1920)

func _on_BackConfig_pressed():
	$Config.hide()
	$Main/preview.volume_db = 0


func _on_Settings_pressed():
	$Config.show()


func _on_Sync_pressed():
	add_child(Sync.instance())
	$Main/preview.volume_db = -99


func _on_Chests_pressed():
	$Tasks.show()
	$Main.hide()
	$Store.hide()
	$Tasks.simple_refreshTasks()
