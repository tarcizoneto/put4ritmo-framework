extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var totempre = preload('res://medula/scenes/TotemUnlock.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	$NewMusicBG/AlbumBG/Info.add_theme_color_override("font_outline_color", global.defaultColors[1])
	$NewMusicBG/AlbumBG/Artist.add_theme_color_override("font_outline_color", global.defaultColors[0])
	$VersusMode/Label.text = 'Modo '+global.ALBUM
	$VersusMode.show()
	$UpgradesBG.visible=false
	$CustomBG.visible = false
	$RandomMusic/Price.text = str(global.musicaPreco)
	if global.songlist.size() >= global.database.keys().size():
		$RandomMusic.disabled = true
		$VersusMode.disabled = false
	#aq é pra ver se ainda tem alguma musica pra  comprar
	
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func sortcovers():
	$RandomMusic/Container/Cover.texture = load(global.returnpath('cover', global.returnRandomSong()))

func newmusic():
	randomize()
	if randf_range(0, 1) >= 0.5:
		global.musicaPreco += 5
	
	var randomsong = global.database.keys()[round(randf_range(0, len(global.database.keys())-1))]
	while true:
		if randomsong in global.songlist:
			randomsong = global.database.keys()[round(randf_range(0, len(global.database.keys())-1))]
		else:
			global.songlist.append(randomsong)
			global.codename = randomsong
			break
	$NewMusicBG/AlbumBG/Cover.texture = load(global.returnpath('cover', randomsong))
	$NewMusicBG/AlbumBG/Info.text = global.database[randomsong].Title 
	$NewMusicBG/AlbumBG/Artist.text = global.database[randomsong].Artist
	#global.database[randomsong].Title
	if global.songlist.size() >= global.database.keys().size():
		$RandomMusic.disabled = true
		$VersusMode.disabled = false
		print('habilitandor....')
		print($VersusMode.disabled)
	else:
		$VersusMode.disabled = true
		print('desabilitandorrr....')
	if visible and $RandomMusic.disabled:
		$RandomMusic/AnimationPlayer.play("disabled")
		$VersusMode/AnimationPlayer.play("show")
	$NewMusicBG/anim.play("main")
	global.store_save()
	get_parent().reloadInfo()
	
	

func _on_RandomMusic_pressed():
	get_parent().get_node("click").play()
	if global.cupomMusica >= global.musicaPreco:
		global.cupomMusica -= global.musicaPreco
		newmusic()
		$Buy.play()
	else:
		$RandomMusic/AnimationPlayer.play("enoughCoins")


func _on_Exit_pressed():
	get_parent().get_node("click").play()
	$NewMusicBG/anim.play_backwards("exit")
	$NewMusicBG.visible = false
	global.loadAllSongAudios()
	$RandomMusic/Price.text = str(global.musicaPreco)
	


func _on_Store_visibility_changed():
	if visible:
		$RandomMusic/Container/AnimationPlayer.play("cover_show")
		$RandomMusic/Container/CPUParticles2D.emitting = true
		if global.songlist.size() == global.database.keys().size():
			$RandomMusic.disabled = true
			$VersusMode.disabled = false
			print('habilitandor....')
			print($VersusMode.disabled)
	else:
		$RandomMusic/Container/CPUParticles2D.emitting = false
		$RandomMusic/Container/AnimationPlayer.stop(true)
	


func _on_RandomMusic_visibility_changed():
	if global.songlist.size() == global.database.keys().size():
		$RandomMusic.disabled = true
	if visible and $RandomMusic.disabled:
		$RandomMusic/AnimationPlayer.play("disabled")
		$VersusMode/AnimationPlayer.play("show")


func _on_ChangeShop_pressed():
	get_parent().get_node("click").play()
	$UpgradesBG.visible = true


func _on_BackUpgrade_pressed():
	get_parent().get_node("click").play()
	$UpgradesBG.visible = false


func _on_TotemYgona_pressed():
	
	get_parent().get_node("click").play()
	buyTotem('ygona', 50)

func buyTotem(totem, price):
	if global.mariedas >= price:
		global.mariedas -= price
		global.addProgressTask('spend', price)
		global.totems[totem] += 1
		
		
		add_child(totempre.instantiate())
		$Buy.play()
		global.store_save()
		get_parent().reloadInfo(false)
	else:
		$UpgradesBG/AnimationPlayer.play("enoughCoins")

func _on_MusicPrice_pressed():
	
	get_parent().get_node("click").play()
	
	if global.cupomLista >= 5:
		if !global.musicaPreco >= 5:
			return
		global.cupomLista -= 5
		global.musicaPreco -= 5
		
		
		$UpgradesBG/ScrollContainer/VBoxContainer/MusicPrice/BuySFX.play()
		$RandomMusic/Price.text = str(global.musicaPreco)
		$Buy.play()
		global.store_save()
		get_parent().reloadInfo(false)
	else:
		$UpgradesBG/AnimationPlayer.play("enoughCupom")


func _on_BackCustom_pressed():
	get_parent().get_node("click").play()
	$CustomBG.visible = false


func _on_ChangeShopCustom_pressed():
	get_parent().get_node("click").play()
	$CustomBG.visible = true


func _on_VersusMode_pressed():
	print('albummode click')
	if $VersusMode.disabled:
		print('albummode disabled more')
		return
	get_parent().get_node("click").play()
	
	if global.cupomMusica >= 10:
		
		
		#get_parent().albumModeInstance()
		#$Buy.play()
		
		$VersusModeHint/BG/Because.text = 'Mas, mona... que coragem!\n\nTem certeza que quer iniciar o modo '+global.ALBUM+'?\n\nAntes, seria bom ver quantos totens você tem, já que esse modo não tem pausa ou saída, toca o álbum inteiro de uma vez\n\nAo jogar esse modo, você, finalmente, zera o jogo!\n\nLembra de escolher sua tecla favorita!'
		$VersusModeHint/BG/TotemYgona/Amount.text = str(global.totems.ygona)
		$VersusModeHint/AnimationPlayer.play("enter")
		global.store_save()
	else:
		$UpgradesBG/AnimationPlayer.play("enoughCupom")


func _on_Yes_pressed():
	$VersusModeHint/AnimationPlayer.play("exit")
	get_parent().albumModeInstance()
	global.albumModeScores = []
	
	$Buy.play()
	global.cupomLista -= 10
	global.store_save()


func _on_No_pressed():
	$VersusModeHint/AnimationPlayer.play("exit")
