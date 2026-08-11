extends Control

var indexTask = 0
var currentUnlockingTask = 0
var taskTypes = []
var anotherTasksToRedeem = []


# Called when the node enters the scene tree for the first time.
func _ready():
	
	randomize()
	refreshTask(0)
	refreshTask(1)
	refreshTask(2)

func refreshTask(index):
	print('refreshing No'+str(index+1))
	taskTypes = []
	if index == 999:
		index = currentUnlockingTask
		print('coming from animation')
		print(currentUnlockingTask)
	var taskNode = get_node("ScrollContainer/VBoxContainer/Task"+str(index))
#	var taskNode = get_node("VBoxContainer/Task0")
	
	for i in global.currentTasks:
		if i == null:
			continue
		taskTypes.append(i.type)
	
	var newTask = global.returnRandomTask()
	while true:
		if newTask.type in taskTypes:
			newTask = global.returnRandomTask()
		else:
			global.currentTasks[index] = newTask
			break
	print(newTask)
	print(index)
	print('\n\n\n')
	print(global.currentTasks)
	var task = global.currentTasks[index]
	taskNode.get_node("Info").text = task.phrase
	taskNode.get_node("ProgressBar/ProgressPercent").text = str(task.progress)+' / '+str(task.amount)
	taskNode.get_node("Reward").texture = load('res://medula/tex/'+task.reward+'.png')
	taskNode.get_node("Reward/Amount").text = str(task.rewardAmount)
	taskNode.get_node("ProgressBar").max_value = task.amount
	taskNode.get_node("ProgressBar").value = 0
	
	if len(anotherTasksToRedeem) >= 1:
		unlockRewardTask(anotherTasksToRedeem[0])
		anotherTasksToRedeem.remove(0)
		print(anotherTasksToRedeem)

func unlockRewardTask(index):
	get_node("ScrollContainer/VBoxContainer/Task"+str(index)+'/AnimationPlayer').play('unlock')
	var task = global.currentTasks[index]
	get_parent().get_node("anim").play(task.reward+"glow")
	print('play it!')
	print(index)
	currentUnlockingTask = index
	global.getRewardTask(index)
	global.store_save()
	
	
	

func simple_refreshTasks():
	indexTask = 0
	if $Cooldown.time_left < 6 and $Cooldown.time_left != 0:
		print('tá clicando muito rapido hein')
		return
	$Cooldown.start()
	print(global.currentTasks)
	# index 0 task
	var task = global.currentTasks[0]
	get_node("ScrollContainer/VBoxContainer/Task0/ProgressBar/ProgressPercent").text = str(task.progress)+' / '+str(task.amount)
	get_node("ScrollContainer/VBoxContainer/Task0/ProgressBar").value = task.progress
	# index 1 task
	task = global.currentTasks[1]
	get_node("ScrollContainer/VBoxContainer/Task1/ProgressBar/ProgressPercent").text = str(task.progress)+' / '+str(task.amount)
	get_node("ScrollContainer/VBoxContainer/Task1/ProgressBar").value = task.progress
	# index 2 task
	task = global.currentTasks[2]
	get_node("ScrollContainer/VBoxContainer/Task2/ProgressBar/ProgressPercent").text = str(task.progress)+' / '+str(task.amount)
	get_node("ScrollContainer/VBoxContainer/Task2/ProgressBar").value = task.progress
	
	var taskRedeem = false
	for taskInList in global.currentTasks:
		
#		print('start for in \n\n')
#		print(taskInList)
		if taskInList.progress >= taskInList.amount:
			if !taskRedeem:
				unlockRewardTask(indexTask)
				print('progress reached'+str(indexTask))
				taskRedeem = true
			else:
				print('(appended to anotherTasksToRedeem) -- progress reached'+str(indexTask))
				anotherTasksToRedeem.append(indexTask)
				
		
		indexTask += 1
		print(indexTask)

func makeRewardParentGlow():
	print('ganhou e vai levar')
	
