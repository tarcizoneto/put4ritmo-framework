extends Node

var SyncTrack = []
var notes = []


func main():
	var timeInMs = 0
	var currentRelativeTime = 0
	var currentBPM = 120
	var songlength = notes[-1].time
	var currentNote = 0
	var currentSync = 0
	var finalNotes = []
	while currentRelativeTime < songlength:
		if currentSync < SyncTrack.size():
			if currentRelativeTime >= SyncTrack[currentSync].time:
				currentBPM = SyncTrack[currentSync].bpm / 1000.0
				currentSync += 1
		var currentBPMDelay = 60000.0/currentBPM
		
		if currentNote < notes.size():
				if currentRelativeTime >= notes[currentNote].time:
					var chordstart = notes[currentNote].time
					while true:
						
						var eventDict = {'time': 0, 'dur': 0, 'row': 0}
						eventDict.time = float(timeInMs)
						eventDict.dur = int(0)
						eventDict.row = int(notes[currentNote].row)
						#print(str(currentNote) + '   ' + str(timeInMs) + 'original' + str(notes[currentNote].time))
						finalNotes.append(eventDict)
					
						currentNote += 1
						if chordstart != notes[currentNote].time:
							break
		currentRelativeTime += 16
		timeInMs += currentBPMDelay * 16.0/192.0
		
	return finalNotes
