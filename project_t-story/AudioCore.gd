# Copyright 2025 Team: "BetaMax Heroes"
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software
# and associated documentation files (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge, publish, distribute,
# sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or
# substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# "AudioCore.gd"
extends Node2D

var MusicVolume
var EffectsVolume

var MusicPlayer
var MusicTotal = 13
var MusicCurrentlyPlaying = -1

var EffectPlayer = []
var EffectsTotal = 9

#----------------------------------------------------------------------------------------
func ConvertLinearToDB(volume):
	var returnValue = log(volume) * 8.6858896380650365530225783783321
	return(returnValue)

#----------------------------------------------------------------------------------------
func _ready():
	MusicVolume = 1.0
	EffectsVolume = 0.5

	MusicPlayer = AudioStreamPlayer.new()
	add_child(MusicPlayer)

	var _warnErase = EffectPlayer.resize(3)
	for plr in range(3):
		EffectPlayer[plr] = []
		EffectPlayer[plr].resize(EffectsTotal)
		for index in range(0, EffectsTotal):
			EffectPlayer[plr][index] = []

	for plr in range(3):
		for index in range(0, EffectsTotal):
			EffectPlayer[plr][index] = AudioStreamPlayer.new()
			if index == 0:  EffectPlayer[plr][index].stream = load("res://media/sound/MenuMove.ogg")
			elif index == 1:  EffectPlayer[plr][index].stream = load("res://media/sound/MenuClick.ogg")
			elif index == 2:  EffectPlayer[plr][index].stream = load("res://media/sound/PieceRotate.ogg")
			elif index == 3:  EffectPlayer[plr][index].stream = load("res://media/sound/PieceDrop.ogg")
			elif index == 4:  EffectPlayer[plr][index].stream = load("res://media/sound/PieceCollision.ogg")
			elif index == 5:  EffectPlayer[plr][index].stream = load("res://media/sound/LineCleared.ogg")
			elif index == 6:  EffectPlayer[plr][index].stream = load("res://media/sound/4LinesCleared.ogg")
			elif index == 7:  EffectPlayer[plr][index].stream = load("res://media/sound/IncomingLine.ogg")
			elif index == 8:  EffectPlayer[plr][index].stream = load("res://media/sound/GameOver.ogg")
			add_child(EffectPlayer[plr][index])
			EffectPlayer[plr][index].set_volume_db(ConvertLinearToDB(EffectsVolume))
			EffectPlayer[plr][index].stream.set_loop(false)
		pass
	pass

#----------------------------------------------------------------------------------------
func SetMusicAndEffectsVolume(musicVolume, effectsVolume):
	MusicPlayer.set_volume_db(ConvertLinearToDB(musicVolume))

	for plr in range(3):
		for index in range(0, EffectsTotal):
			EffectPlayer[plr][index].set_volume_db(ConvertLinearToDB(effectsVolume))
		pass
	pass

#----------------------------------------------------------------------------------------
func PlayMusic(index, loop):
	if index < 0 || index > (MusicTotal-1):  return

	if MusicCurrentlyPlaying > -1:
		MusicPlayer.stop()
	
	MusicCurrentlyPlaying = index

	if index == 0:  MusicPlayer.stream = load("res://media/music/TitleBGM.ogg")
	elif index == 1:  MusicPlayer.stream = load("res://media/music/InGame1BGM.ogg")
	elif index == 2:  MusicPlayer.stream = load("res://media/music/InGame2BGM.ogg")
	elif index == 3:  MusicPlayer.stream = load("res://media/music/InGame3BGM.ogg")
	elif index == 4:  MusicPlayer.stream = load("res://media/music/InGame4BGM.ogg")
	elif index == 5:  MusicPlayer.stream = load("res://media/music/InGame5BGM.ogg")
	elif index == 6:  MusicPlayer.stream = load("res://media/music/InGame6BGM.ogg")
	elif index == 7:  MusicPlayer.stream = load("res://media/music/InGame7BGM.ogg")
	elif index == 8:  MusicPlayer.stream = load("res://media/music/InGame8BGM.ogg")
	elif index == 9:  MusicPlayer.stream = load("res://media/music/InGame9BGM.ogg")
	elif index == 10: MusicPlayer.stream = load("res://media/music/WonBGM.ogg")
	elif index == 11: MusicPlayer.stream = load("res://media/music/Ending.ogg")
	elif index == 12: MusicPlayer.stream = load("res://media/music/Intro.ogg")

	MusicPlayer.set_volume_db(ConvertLinearToDB(MusicVolume))
	MusicPlayer.stream.set_loop(loop)
	MusicPlayer.play(0.0)

	pass

#----------------------------------------------------------------------------------------
func PlayEffect(plr, index):
	if index < 0 || index > (EffectsTotal-1):  return

	EffectPlayer[plr][index].set_volume_db(ConvertLinearToDB(EffectsVolume))
	EffectPlayer[plr][index].stream.set_loop(false)
	EffectPlayer[plr][index].play(0.0)

	pass

#----------------------------------------------------------------------------------------
func _process(_delta):

	pass
