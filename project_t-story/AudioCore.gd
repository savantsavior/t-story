# Copyright 2026 Team: "BetaMax Heroes"
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
var MusicTotal = 12
var MusicCurrentlyPlaying = -1

var EffectPlayer = []
var EffectsTotal = 11

#----------------------------------------------------------------------------------------
func _ready():
	MusicVolume = 0.5
	EffectsVolume = 0.25

	MusicPlayer = AudioStreamPlayer.new()
	add_child(MusicPlayer)

	EffectPlayer.resize(3)
	for plr in range(3):
		EffectPlayer[plr] = []
		EffectPlayer[plr].resize(EffectsTotal)
		for index in range(0, EffectsTotal):
			EffectPlayer[plr][index] = []

	for plr in range(3):
		for index in range(0, EffectsTotal):
			EffectPlayer[plr][index] = AudioStreamPlayer.new()
			if index == 0:  EffectPlayer[plr][index].stream = load("res://media/sound/MenuMove.wav")
			elif index == 1:  EffectPlayer[plr][index].stream = load("res://media/sound/MenuClick.wav")
			elif index == 2:  EffectPlayer[plr][index].stream = load("res://media/sound/PieceRotate.wav")
			elif index == 3:  EffectPlayer[plr][index].stream = load("res://media/sound/PieceDrop.wav")
			elif index == 4:  EffectPlayer[plr][index].stream = load("res://media/sound/PieceCollision.wav")
			elif index == 5:  EffectPlayer[plr][index].stream = load("res://media/sound/LineCleared.wav")
			elif index == 6:  EffectPlayer[plr][index].stream = load("res://media/sound/4LinesCleared.wav")
			elif index == 7:  EffectPlayer[plr][index].stream = load("res://media/sound/IncomingLine.wav")
			elif index == 8:  EffectPlayer[plr][index].stream = load("res://media/sound/GameOver.wav")
			elif index == 9:  EffectPlayer[plr][index].stream = load("res://media/sound/LogoSay.wav")
			elif index == 10:  EffectPlayer[plr][index].stream = load("res://media/sound/Danger.wav")
			add_child(EffectPlayer[plr][index])
			EffectPlayer[plr][index].set_volume_db(linear_to_db(EffectsVolume))
		pass
	pass

#----------------------------------------------------------------------------------------
func SetMusicAndEffectsVolume(musicVolume, effectsVolume):
	MusicPlayer.set_volume_db(linear_to_db(musicVolume))

	for plr in range(3):
		for index in range(0, EffectsTotal):
			EffectPlayer[plr][index].set_volume_db(linear_to_db(effectsVolume))
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

	MusicPlayer.set_volume_db(linear_to_db(MusicVolume))
	MusicPlayer.stream.set_loop(loop)
	MusicPlayer.play(0.0)

	pass

#----------------------------------------------------------------------------------------
func PlayEffect(plr, index):
	if index < 0 || index > (EffectsTotal-1):  return

	EffectPlayer[plr][index].set_volume_db(linear_to_db(EffectsVolume))
	EffectPlayer[plr][index].play(0.0)

	pass

#----------------------------------------------------------------------------------------
func _process(_delta):

	pass
