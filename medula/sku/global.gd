extends Node

const defaultColors = [Color('#a500ff'),Color('#3f00ff')] # a mais clara e a mais escura
const BOT = false
const ALBUM = 'Versus'
var allSongs = []
var database = {
	'dummy1': {'Title': '1DummyTitle', 'Artist': 'DummyArtist', 'bpm': 136, 'delay': 441.1764, 'existTransition': true, 'preview': 0, 'hard': false},
	'dummy2': {'Title': '2DummyTitle', 'Artist': 'DummyArtist', 'bpm': 136, 'delay': 441.1764, 'existTransition': true, 'preview': 54.4, 'hard': false},
	'dummy3': {'Title': '3DummyTitle', 'Artist': 'DummyArtist', 'bpm': 136, 'delay': 441.1764, 'existTransition': true, 'preview': 25.4, 'hard': false},
	}
var songlist = []
var codename = ''
var songlistInOrder = ['dummy1','dummy2','dummy3']
# ou = database.keys, se as músicas ja estiverem na ordem correta no dicionario

#album mode
var currentSongfromAlbumMode = 0
var albumModeScores = []
var eachFeedback = []


var progressDifficulty = {}
var songaudios = {}
var score = 50000
var hiscores = {}
var feedback = 0
var cupomLista = 0
var cupomMusica = 0
var mariedas = 0
var songlength = 0
var musicaPreco = 5
var customNote = 'maria1'
var customNotesBought = ['maria1', 'tulla1']
var totems = {'ygona': 0}
var delay = 0
var tips = ['1000 pontos equivalem a 1 maricoins?', 
	'você usa fichas para comprar músicas? esse é o nome do ícone.', 
	'esse jogo demorou mais de 2 anos em desenvolvimento pra chegar em uma versão 1.0?', 
	'não ganhamos nenhum dinheiro com esses jogos?', 
	'o put4 records começou em 2021? e entre vários projetos cancelados, o "put4 studio" sobreviveu.', 
	'a cada música comprada, há uma chance de 50% de aumentar o preço em 5 fichas de músicas?', 
	'a ficha ao lado da ficha de músicas é chamada de ficha de álbum? ganha-se uma a cada 50000 pontos em uma música', 
	'estamos em todas as redes sociais? se desejar falar sobre esse jogo, nos te escutaremos.',
	'tem como jogar com fones sem fio? sincronize o áudio nas configurações!',
	'esse jogo usa uma nova forma de IA? a Burrice Artificial!',
	'pode pedir uma versão do Put4Ritmo só de algum artista? se a mona deixar, a gente pode fazer!',
	'existe um modo '+ALBUM+'? É basicamente um desafio, você tem que jogar todas as músicas do álbum de uma vez, sem parar, ao jogar esse desafio, você zera o jogo!'
	
	]
var tasksDatabase = ['points','playsong','spend','stars','usetotem','getcupom','getmariedas']

var dummyTask = {
	'type': 'none',
	'amount': 5000,
	'reward': '',
	'rewardAmount': 0,
	'which': '',
	'phrase': '',
	'progress': 0
	}
var currentTasks = [dummyTask, dummyTask, dummyTask]

func returnRandomTask():
	
	randomize()
	var randomTask = tasksDatabase[round(randf_range(0, tasksDatabase.size()-1))]
	var task = {
	'type': 'none',
	'amount': 0,
	'reward': '',
	'rewardAmount': 0,
	'which': '',
	'phrase': '',
	'progress': 0
	}
	match randomTask:
		'points':
			task.type = 'points'
			task.amount = 50000*round(randf_range(2, 4))
			task.reward = 'totem_ygona'
			task.rewardAmount = round(randf_range(1, 3))
			task.phrase = 'Consiga '+str(task.amount)+ ' pontos'
			return task
		'playsong':
			task.type = 'playsong'
			task.amount = 1
			task.which = returnRandomSong()
			task.reward = 'mariedas'
			task.rewardAmount = 5*round(randf_range(4, 20))
			task.phrase = 'Jogue a música '+database[task.which].Title + ' e alcance mais de 3 estrelas'
			return task
		'spend':
			task.type = 'spend'
			task.amount = 5*round(randf_range(10, 30))
			task.reward = 'cupom_musica'
			task.rewardAmount = round(randf_range(1, 6))
			task.phrase = 'Gaste '+str(task.amount)+ ' maricoins em qualquer coisa'
			return task
		'stars':
			task.type = 'stars'
			task.amount = 5*round(randf_range(2, 5))
			task.reward = 'totem_ygona'
			task.rewardAmount = round(randf_range(1, 3))
			task.phrase = 'Consiga '+str(task.amount)+ ' estrelas'
			return task
		'usetotem':
			task.type = 'usetotem'
			task.amount = round(randf_range(2, 6))
			task.reward = 'mariedas'
			task.rewardAmount = 5*round(randf_range(10, 15))
			task.phrase = 'Use '+str(task.amount)+ ' totem(ns) da Ygona'
			return task
		'getcupom':
			task.type = 'getcupom'
			task.amount = 5*round(randf_range(2, 4))
			task.reward = 'mariedas'
			task.rewardAmount = 5*round(randf_range(3, 10))
			task.phrase = 'Consiga '+str(task.amount)+ ' fichas de música'
			return task
		'getmariedas':
			task.type = 'getmariedas'
			task.amount = 50*round(randf_range(2, 4))
			task.reward = 'cupom_musica'
			task.rewardAmount = round(randf_range(3, 8))
			task.phrase = 'Consiga '+str(task.amount)+ ' maricoins'
			return task

func getRewardTask(index : int):
	var task = currentTasks[index]
	match currentTasks[index].reward:
		'mariedas':
			mariedas += currentTasks[index].rewardAmount
		'totem_ygona':
			totems.ygona += currentTasks[index].rewardAmount
		'cupom_musica':
			cupomMusica += currentTasks[index].rewardAmount

func addProgressTask(type : String, progressAdd: int, song = null):
	if type == 'playsong':
		for task in currentTasks:
			if task.type == 'playsong' and task.which == song:
				task.progress += progressAdd
	else:
		for task in currentTasks:
			if task.type == type:
				task.progress += progressAdd
	

func returnRandomSong():
	return database.keys()[round(randf_range(0, len(database.keys())-1))]

func loadAllSongAudios():
	for i in database.keys():
		songaudios[i] = load(returnpath('song', i))

func _ready():
	for i in allSongs:
		database[i].delay = 60000.00000 / database[i].bpm
	
	fixDatabaseInfo_UsingIni()
	#OS.request_permissions()
	load_save()
	loadAllSongAudios()
	codename = songlist[-1]

func fixDatabaseInfo_UsingIni():
	
	
	
	
	
# warning-ignore:unused_variable
	
	
	for i in allSongs:
		
		
		var title = null
		var artist = null
		var preview = null
		
		
		var chartDict = {}
		var file = 'res://songs/'+i+'/song.ini'
		if not FileAccess.file_exists(file):
			continue
		var f = FileAccess.open(file, FileAccess.READ)
	# warning-ignore:unused_variable
		var index = 1
		while not f.eof_reached(): # iterate through all lines until the end of file is reached
			var line = f.get_line()
			
			if 'name = ' in line:
				var splitted = line.split(' = ')
				title = splitted[1]
			if 'name=' in line:
				var splitted = line.split('=')
				title = splitted[1]
			if 'artist = ' in line:
				var splitted = line.split(' = ')
				artist = splitted[1]
			if 'artist=' in line:
				var splitted = line.split('=')
				artist = splitted[1]
			if 'preview_start_time = ' in line:
				var splitted = line.split(' = ')
				preview = int(splitted[1]) / 1000.0
			if 'preview_start_time=' in line:
				var splitted = line.split('=')
				preview = int(splitted[1]) / 1000.0
			
			
			index += 1
		f.close()


	
	
		
		if title == null or artist == null:
			print(i)
			print(title, i)
			print(artist,i)
			continue
		
		if preview == null:
			randomize()
			preview = randf_range(0, 30)
		
		var nonfixed = database[i]
		nonfixed.Title = title
		nonfixed.Artist = artist
		nonfixed.preview = preview
		database[i] = nonfixed


# warning-ignore:shadowed_variable
func returnpath(path, codename):
	match path:
		'chart':
			return 'res://songs/'+codename+'/notes.chart'
		'song':
			var rl = ResourceLoader
			if rl.exists('res://songs/'+codename+'/song.ogg'):
				return 'res://songs/'+codename+'/song.ogg'
			elif rl.exists('res://songs/'+codename+'/song.mp3'):
				return 'res://songs/'+codename+'/song.mp3'
		'cover':
			var rl = ResourceLoader
			var pathwithoutext = 'res://songs/'+codename+'/cover'
			if rl.exists(pathwithoutext+'.jpg'):
				return pathwithoutext+'.jpg'
			elif rl.exists(pathwithoutext+'.png'):
				return pathwithoutext+'.png'
			pathwithoutext = 'res://songs/'+codename+'/album'
			if rl.exists(pathwithoutext+'.jpg'):
				return pathwithoutext+'.jpg'
			elif rl.exists(pathwithoutext+'.png'):
				return pathwithoutext+'.png'
			else:
				return 'res://songs/nonecover.jpg'
		'info':
			return 'res://songs/'+codename+'/song.ini'
			

# saves
var saveDict = {"firsttime": 2, "hiscores": {}, "progressDifficulty": {}, 'totems': {'ygona': 0},  'songlist': ['arroto', 'p'], 'cupomMusica': 0, 'cupomLista': 0, 'mariedas': 0, 'musicaPreco': 5, 'customNote': 'maria1', 'customNotesBought': ['maria1']}
var saveDictTEMPLATE = saveDict

var save_file = "user://user.save"

func load_save():
	if FileAccess.file_exists(save_file):
		var f = FileAccess.open(save_file, FileAccess.READ)
		saveDict = f.get_var()
		print('carreguei')
		if typeof(saveDict) != TYPE_DICTIONARY:
			print('save burlado')
			savedictisnulo()
			return
		if saveDict == null or not 'songlist' in saveDict:
			print('save burlado')
			savedictisnulo()
			return
		hiscores = saveDict.hiscores
		progressDifficulty = saveDict.progressDifficulty
		songlist = saveDict.songlist
		cupomMusica = saveDict.cupomMusica
		cupomLista = saveDict.cupomLista
		mariedas = saveDict.mariedas
		totems = saveDict.totems
		musicaPreco = saveDict.musicaPreco
		customNote = saveDict.customNote
		customNotesBought = saveDict.customNotesBought
		for i in songlist:
			if i in hiscores:
				hiscores[i] = saveDict.hiscores[i]
			else:
				hiscores[i] = 0
			
			if i in progressDifficulty:
				progressDifficulty[i] = saveDict.progressDifficulty[i]
			else:
				progressDifficulty[i] = 'm'
				
		f.close()
		store_save()
	else: # definindo o primeiro save, tudo que você quiser que comece com o jogador, defina aqui
		print('[load_save] first time')
		songlist = ['dummy3'] # músc
		for i in songlist:
			hiscores[i] = 0
			progressDifficulty[i] = 'm'
		cupomLista = 0
		cupomMusica = 0
		mariedas = 0
		totems = {'ygona': 0}
		customNote = 'maria1'
		customNotesBought = ['maria1','tulla1'] # aquisições defaults
		store_save()
	
	

func savedictisnulo():
	saveDict = saveDictTEMPLATE
	print('[load_save] first time')
	for i in songlist:
		hiscores[i] = 0
		progressDifficulty[i] = 'm'
	store_save()

func store_save():
	var f = FileAccess.open(save_file, FileAccess.WRITE)
	if f == null:
		push_error("Could not open save file for writing: " + error_string(FileAccess.get_open_error()))
		return
	saveDict.hiscores = hiscores
	saveDict.progressDifficulty = progressDifficulty
	saveDict.songlist = songlist
	saveDict.cupomMusica = cupomMusica
	saveDict.cupomLista = cupomLista
	saveDict.mariedas = mariedas
	saveDict.musicaPreco = musicaPreco
	saveDict.totems = totems
	saveDict.customNote = customNote
	saveDict.customNotesBought = customNotesBought
	for i in songlist:
		if ! i in hiscores:
			hiscores[i] = 0
		
		if ! i in progressDifficulty:
			progressDifficulty[i] = 'm'
	f.store_var(saveDict)
	f.close()

func break_save():
	var f = FileAccess.open(save_file, FileAccess.WRITE)
	if f == null:
		push_error("Could not open save file for writing: " + error_string(FileAccess.get_open_error()))
		return
	f.store_var(0)
	f.close()
