
extends Control

var codename = ''

var introRunning = false
var lastSort = 0
var totemBG = 0
var bpm = 0
var events = []
var currentEvent = 0
var currentMS = 0
var prenote = preload("res://medula/scenes/note.tscn")
var scoreScene = preload("res://medula/scenes/ScoreBG.tscn")
var scoreAlbumModeScene = preload("res://medula/scenes/AlbumScoreBG.tscn") 
var totempre = preload('res://medula/scenes/TotemUnlock.tscn')
var timeMath = 0
var rows = 3
var notedelay = 0
var notespawnstrech = false
var active = true
var randommode = false
var finished = false
var continueEvent = []
var continueScore = 0
var pausedLostTime = 0
onready var customNoteTEX = load('res://medula/tex/custom/notes/'+global.customNote+'.png')

var ALBUMMODE = false
var isParentofAlbumMode = false
var nextSongInitiated = false

func instanceTransitions():
	if !isParentofAlbumMode:
		return
	for song in global.songlistInOrder:
		if song == global.songlistInOrder[0]:
			continue
		print('instancing '+song+' in album mode')
		var gameplayInstance = load("res://medula/scenes/Gameplay.tscn").instance()
		gameplayInstance.codename = song
		gameplayInstance.get_node('Start').queue_free()
		gameplayInstance.get_node('TotemYgona').queue_free()
		gameplayInstance.get_node("Perfect/AnimationPlayer").play("show")
		gameplayInstance.ALBUMMODE = true
		if song != global.songlistInOrder[-1]:
			gameplayInstance.get_node("Out").queue_free()
		else:
			gameplayInstance.get_node("Out").hide()
		gameplayInstance.hide()
		add_child(gameplayInstance)

func _ready():
	
	if !ALBUMMODE or codename == global.songlistInOrder[0] and ALBUMMODE:
			$Out/AnimationPlayer.play("main")
	
	randomize()
	
	
	if ALBUMMODE:
		$Return.hide()
	
	$song.stream = load(global.returnpath('song', codename))
	global.currentSongfromAlbumMode = 0
	$Perfect.rect_scale = Vector2(1, global.database[codename].bpm/120.0)
	print(global.progressDifficulty[codename])
	match global.progressDifficulty[codename]:
		'm':
			events = load_chart(codename, 'ExpertSingle')
			
		'h':
			events = load_chart(codename, 'ExpertSingle')
		'x':
			events = load_chart(codename, 'ExpertSingle')
		'x2':
			events = load_chart(codename, 'ExpertSingle')
	
	ch2json.SyncTrack = load_chart(codename, 'SyncTrack')
	ch2json.notes = events
	events = ch2json.main()
	bpm = global.database[codename].bpm
	notedelay = global.database[codename].delay
	if events.size() == 0:
		get_tree().quit()
	global.feedback = 50000.0 / events.size()
	print('events size/len:')
	print(events.size())
	print(len(events))
	if ALBUMMODE:
		global.eachFeedback.append(global.feedback)
		if isParentofAlbumMode:
			global.feedback = global.eachFeedback[0]
	global.score = 0
	$SongRemaining.max_value = $song.stream.get_length()
	$BG/Cover_db.texture = load(global.returnpath('cover', codename))
	$TotemYgona/Amount.text = str(global.totems.ygona)
	if get_viewport_rect().size.y > 1920:
		$BG/Cover_db.rect_scale = Vector2(get_viewport_rect().size.y/1920, get_viewport_rect().size.y/1920)

func load_chart(codename, section):
	var currentValue = null
	var currentValueTextArray = []
# warning-ignore:unused_variable
	var chartDict = {}
	var file = 'res://songs/'+codename+'/'+'notes.chart'
	var f = File.new()
	f.open(file, File.READ)
# warning-ignore:unused_variable
	var index = 1
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		
		if currentValue != null:
			if line != '{' or line != '}':
				currentValueTextArray.append(line)
			if '}' in line:
				currentValue = null
				print('\nclosed!\n')
		
		if '['+section+']' in line:
			currentValue = 'song'
			print('\nstarted!\n')
		
			
		index += 1
	f.close()
	if 'Single' in section:
		var allEventsArray = []
		#print(currentValueTextArray)
		for event in currentValueTextArray:
			if event == '{' or event == '}':
				continue
			var slippedEvent = event.split(' ')
			var eventDict = {'time': 0, 'dur': 0, 'row': 0}
			if '	' in event:
				eventDict.time = int(slippedEvent[0].replace('	', ''))
			else:
				eventDict.time = int(slippedEvent[2])
			eventDict.dur = int(slippedEvent[-1])
			eventDict.row = int(slippedEvent[-2])
			#print(eventDict)
			allEventsArray.append(eventDict)
			#[, , 864, =, N, 2, 0]
			#print(slippedEvent)
			
		return allEventsArray
	elif section == 'SyncTrack':
		var allEventsArray = []
		#print(currentValueTextArray)
		for event in currentValueTextArray:
			if event == '{' or event == '}':
				continue
			var slippedEvent = event.split(' ')
			var eventDict = {'time': 0, 'bpm': 0}
			
			#allEventsArray.append(eventDict)
			#[, , 864, =, N, 2, 0]
			if slippedEvent[-2] == 'B':
				if '	' in event:
					eventDict.time = int(slippedEvent[0].replace('	', ''))
				else:
					eventDict.time = int(slippedEvent[2])
				eventDict.bpm = int(slippedEvent[-1])
				allEventsArray.append(eventDict)
				
			
		return allEventsArray
		
		
		
		





func load_chartRANDOM(codename, section, chance):
	print("well, you didnt make another chart that isnt an expert one :skull:")
	var currentValue = null
	var currentValueTextArray = []
# warning-ignore:unused_variable
	var chartDict = {}
	var file = 'res://songs/'+codename+'/'+'notes.chart'
	var f = File.new()
	f.open(file, File.READ)
# warning-ignore:unused_variable
	var index = 1
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		
		if currentValue != null:
			if line != '{' or line != '}':
				currentValueTextArray.append(line)
			if '}' in line:
				currentValue = null
				print('\nclosed!\n')
		
		if '['+section+']' in line:
			currentValue = 'song'
			print('\nstarted!\n')
		
			
		index += 1
	f.close()
	if 'Single' in section:
		var allEventsArray = []
		#print(currentValueTextArray)
		for event in currentValueTextArray:
			if event == '{' or event == '}':
				continue
			var slippedEvent = event.split(' ')
			var eventDict = {'time': 0, 'dur': 0, 'row': 0}
			if '	' in event:
				eventDict.time = int(slippedEvent[0].replace('	', ''))
			else:
				eventDict.time = int(slippedEvent[2])
			eventDict.dur = int(slippedEvent[-1])
			eventDict.row = int(slippedEvent[-2])
			#print(eventDict)
			if rand_range(0,1) >= chance:
				allEventsArray.append(eventDict)
			#[, , 864, =, N, 2, 0]
			#print(slippedEvent)
			
		return allEventsArray
		return allEventsArray




func introLogoRunning(tf):
	print(tf)
	if introRunning and !tf:
		$Out/Tween.interpolate_property($Out/Logo, 'rect_position', $Out/Logo.rect_position, Vector2($Out/Logo.rect_position.x, get_viewport_rect().size.y), 1.2, Tween.TRANS_EXPO, Tween.EASE_IN)
		$Out/Tween.start()
	introRunning = tf



# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	if introRunning:
		$Out/Logo.rect_position = Vector2(get_viewport_rect().size.x/2-$Out/Logo.rect_size.x/2, get_viewport_rect().size.y/2-$Out/Logo.rect_size.y/2)
		
	
	if totemBG == 0 and $Totem/AudioStreamPlayer.playing:
		$Totem/AudioStreamPlayer.stop()
	
	if Input.is_action_pressed("ui_up"):
		$song.pitch_scale += 1
	if Input.is_action_pressed("ui_down"):
		$song.pitch_scale -= 1
	
	
	if !$CountdownStart.is_stopped():
		currentMS = -$CountdownStart.time_left*1000
		if currentEvent <= events.size():
			#timeMath = (((events[currentEvent].time/192.0) * ((60000/bpm)/16.0))*16.0) + notedelay
			timeMath = events[currentEvent].time + notedelay + global.delay
			var tobeat_time = 60000/bpm*4.0
			if currentMS >= timeMath-tobeat_time:
				instanceNote()
				if currentEvent <= events.size()-1:
					if events[currentEvent].time == events[currentEvent-1].time:
						instanceNote()
	elif $song.playing:
		
		currentMS = (($song.get_playback_position() + AudioServer.get_time_since_last_mix()) - AudioServer.get_output_latency()) * 1000
		$SongRemaining/Duration.text = str(round($song.get_playback_position()))+' / '+str(round($song.stream.get_length()))
		$SongRemaining.value = $song.get_playback_position()
		if currentEvent <= events.size()-1:
			print(str(currentEvent) + ' / '+ str(events.size()))
			#timeMath = (((events[currentEvent].time/192.0) * ((60000/bpm)/16.0))*16.0) + notedelay
			timeMath = events[currentEvent].time + notedelay + global.delay
			var tobeat_time = 60000/bpm*4.0
			if currentMS >= timeMath-tobeat_time:
				instanceNote()
				if currentEvent <= events.size()-1:
					if events[currentEvent].time == events[currentEvent-1].time:
						print('nota dupla!')
						print(str(currentEvent) + ' / '+ str(events.size()))
						instanceNote()
		
		if ALBUMMODE:
			if $song.get_playback_position() >= $song.stream.get_length()-3 and !nextSongInitiated:
				initiateNextSong_ALBUMMODE()
				nextSongInitiated = true
		else:
			if active:
				$EndTimer.start()
				active = false
		$ScoreLabel.text = str(round(global.score))

func instanceNote():
	var tobeat_timesec = 60.0/bpm*4
#	if events[currentEvent].dur > 0:
#		print('\ndurrr')
#		print(events[currentEvent].dur)
#		print('\n')
	#print((timeMath))
	var note = prenote.instance()
	#note.get_node("AnimationPlayer").play(str(0))
	#note.dur = (events[currentEvent].dur/48) * ((60000/bpm)/2)
	#note.setup()
	#note.get_node("AnimationPlayer").play(str(0))
	match events[currentEvent].row:
		3:
			
			events[currentEvent].row = 0
		4:
			events[currentEvent].row = 1
		5:
			events[currentEvent].row = 0
		6:
			events[currentEvent].row = 2
		7:
			events[currentEvent].row = 2
	var rownode = get_node('by'+str(rows)).get_node(str(events[currentEvent].row))
	note.time = tobeat_timesec
	note.row = events[currentEvent].row
	note.rect_size.x = 360
	note.rect_size.y = 360
	note.currentEvent = currentEvent
	note.get_node("CustomNote").texture = customNoteTEX
	if 'scale' in global.database[codename]:
		note.rect_scale.y = global.database[codename].scale
#	if currentEvent+1 <= events.size()-1:
#		var timetonext = events[currentEvent+1].time - events[currentEvent].time
#		if events[currentEvent+1].row == events[currentEvent].row and timetonext <= 192:
#			note.timetonext = 1
#			notespawnstrech = true
#	if notespawnstrech:
#		note.timetonext = 1
	rownode.add_child(note)
#	notespawnstrech = false
	currentEvent += 1

func map_start():
	$song.play()
	$BG/Cover_db/CoverChange.start()
	if ALBUMMODE:
		$AlbumModeSongHint/anim.play("showHint")
		if isParentofAlbumMode:
			global.feedback = global.eachFeedback[0]

func _on_Button_pressed():
	$anim.play("start")
	$CountdownStart.start()
	$Start/AnimationPlayer.play("bye")
	$TotemYgona/AnimationPlayer.play("exit")
	$sucessototal.play()
	$Perfect/AnimationPlayer.play("show")

func perfect():
	$BG/Cover_db/Tween.interpolate_property($BG/Cover_db, 'modulate', Color(1,1,1,0.8), Color(1,1,1,0.3), 1, Tween.TRANS_QUART, Tween.EASE_OUT)
	$feedback/anim.stop(true)
	$feedback/anim.play('perfect')
func good():
	$feedback/anim.stop(true)
	$feedback/anim.play('good')

func lost(which):
	#totemBG é pra dizer oq ta acontecendo c o bg do totem. 0 = nada, a gameplay ta normal; 
	#1 = a opçao apareceu e ta ali; 2 = opção saindo
	if !global.totems.ygona > 0:
		print(global.totems.ygona)
		realLost()
		return
	
	continueEvent.append(which)
	continueScore = global.score
	if !totemBG:
		totemBG = 1
		$Totem/AnimationPlayer.play("enter")
		pausedLostTime = $song.get_playback_position()
		$Totem/BG/TotemYgona/Amount.text = str(global.totems.ygona)

func realLost():
	print('realmente, perdi')
	if ! finished:
		_on_song_finished()
		print('foi duas vezes?')
		finished = true

func createScoreInstance():
	if ALBUMMODE:
		$ScoreHolder.add_child(scoreAlbumModeScene.instance())
	else:
		$ScoreHolder.add_child(scoreScene.instance())

func _on_song_finished():
	print('tchau por aqui! terminou a música')
	if finished or totemBG != 0:
		print('so que nao kkkk a mensagem do totem ta ativa')
		return
	finished = true
	totemBG = 3
	$EndTimer.stop()
	if !ALBUMMODE:
		$anim.play("scoreopen")
		if !$Out/AnimationPlayer.is_playing():
			$Out/AnimationPlayer.play_backwards("transition-off")
	
	
	global.score = round(global.score)
	$song.stop()
	
	if codename == global.songlistInOrder[-1] and ALBUMMODE:
		print('ultima musica do modo de album')
		$anim.play("scoreopen")
		if !$Out/AnimationPlayer.is_playing():
			$Out/AnimationPlayer.play_backwards("transition-off")
		global.albumModeScores.append(global.score)
		
	
	if global.score > 50000:
		global.score = 50000
	if global.score > global.hiscores[codename]:
		global.hiscores[codename] = global.score
	if global.score >= 50000:
		match global.progressDifficulty[codename]:
			'm':
				global.progressDifficulty[codename] = 'h'
			'h':
				global.progressDifficulty[codename] = 'x'
			'x':
				global.progressDifficulty[codename] = 'x2'
		global.cupomLista += 1
	if global.score >= 9000:
		global.cupomMusica += 1
	if global.score >= 18000:
		global.cupomMusica += 1
	if global.score >= 27000:
		global.cupomMusica += 1
	if global.score >= 36000:
		global.cupomMusica += 1
	if global.score >= 45000:
		global.cupomMusica += 1
	print('two')
	if global.score != 0:
		global.mariedas += round(global.score/1000)
	
	global.store_save()
	if ALBUMMODE and global.currentSongfromAlbumMode != global.songlistInOrder.size()-1:
		var nextSongNode = null
		if isParentofAlbumMode:
			nextSongNode = get_child(get_children().size()-(global.songlistInOrder.size()-1)+global.currentSongfromAlbumMode)
		else:
			nextSongNode = get_parent().get_child(get_parent().get_children().size()-(global.songlistInOrder.size()-1)+global.currentSongfromAlbumMode)
		
		nextSongNode.get_node('BG').show()
		nextSongNode.get_node('Perfect').show()
		nextSongNode.get_node('SongRemaining').show()
		nextSongNode.get_node('ScoreLabel').show()
#		nextSongNode.map_start()
		print('STARTING '+str(global.currentSongfromAlbumMode)+' song')
		global.currentSongfromAlbumMode += 1 
		
		
		global.albumModeScores.append(global.score)
		global.score = 0
		global.feedback = global.eachFeedback[global.currentSongfromAlbumMode]
		
		
#		if ALBUMMODE and !isParentofAlbumMode:
#			queue_free()

func initiateNextSong_ALBUMMODE():
	print('[ ]'+self.name)
	var nextSongNode = null
	if isParentofAlbumMode:
		nextSongNode = get_child(get_children().size()-(global.songlistInOrder.size()-1)+global.currentSongfromAlbumMode)
	else:
		nextSongNode = get_parent().get_child(get_parent().get_children().size()-(global.songlistInOrder.size()-1)+global.currentSongfromAlbumMode)
	
	print(nextSongNode.name)
	nextSongNode.show()
	nextSongNode.get_node('BG').hide()
	nextSongNode.get_node('Perfect').hide()
	nextSongNode.get_node('SongRemaining').hide()
	nextSongNode.get_node('ScoreLabel').hide()
	nextSongNode.get_node('CountdownStart').start()
	
	print('initiating '+str(global.currentSongfromAlbumMode)+' song')
	

func _on_Timer_timeout():
	$beat.play()


func _on_CountdownStart_timeout():
	map_start()


func _on_EndTimer_timeout():
	$song.stop()


func _on_CoverChange_timeout():
	$BG/Cover_db/Tween.interpolate_property($BG/Cover_db, 'modulate', $BG/Cover_db.modulate, Color(1,1,1,((AudioServer.get_bus_peak_volume_right_db(0, 0)/100.0)+0.25)*1.3), .15, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$BG/Cover_db/Tween.start()



func _on_Pause_pressed():
	pass # Replace with function body.


func _on_NoTotemButton_pressed():
	if totemBG == 2:
		return
	totemBG = 0
	realLost()
	$Totem/AnimationPlayer.play("exit")
	


func _on_OKTotem_pressed():
	if totemBG == 2 or totemBG == 0:
		return
	totemBG = 2
	global.addProgressTask('usetotem', 1)
	$Totem/AnimationPlayer.play("longExit")
	add_child(totempre.instance())
	global.totems.ygona -= 1

func moveOn():
	
	print('move on! totem selected')
	print(continueEvent)
	currentEvent = continueEvent[0]
	global.score = continueScore
	if (events[currentEvent].time - 2000 - notedelay)/1000 > 0:
		$song.play((events[currentEvent].time - 2000 - notedelay)/1000)
	else:
		$song.play(0)
	print()
	continueEvent = []

func moveOnResettingTotem(): #bugfix pra caso outra peça perder na hora que o totem tiver saindo
	totemBG = 0

func _on_Return_pressed():
	get_parent().reloadInfo(true)
	queue_free()

func sortTip():
	randomize()
	var sort = round(rand_range(0, len(global.tips)-1))
	while true:
		if sort == lastSort:
			sort = round(rand_range(0, len(global.tips)-1))
		else:
			break
	$Out/Tips.text = 'você sabia que '+global.tips[sort]
	print(sort)
	lastSort=sort


func updateAlbumModeHint(which):
	match which:
		'title':
			$AlbumModeSongHint.text = global.database[codename].Title
		'artist':
			$AlbumModeSongHint.text = global.database[codename].Artist
		'currentSong':
			$AlbumModeSongHint.text = 'Música '+str(global.currentSongfromAlbumMode+1)+' de '+str(global.songlistInOrder.size())
