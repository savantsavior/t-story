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

# "DataCore.gd"
extends Node2D

var HighScoreName = []
var HighScoreLevel = []
var HighScoreScore = []

var PlayerWithHighestScore
var NewHighScoreRank

const FILE_NAME = "user://TetriStory-3_0_1eRRb-game-data.json"
var godot_Temp_Version = Engine.get_version_info()
var GODOT_VERSION = godot_Temp_Version.string

#----------------------------------------------------------------------------------------
func CheckForNewHighScore():
	PlayerWithHighestScore = 0

	if (LogicCore.Score[1] > LogicCore.Score[0]):
		PlayerWithHighestScore = 1
	
	if (LogicCore.Score[2] > LogicCore.Score[1]):
		PlayerWithHighestScore = 2

	NewHighScoreRank = 999
	for index in range(9, -1, -1):
		if (LogicCore.Score[PlayerWithHighestScore] > HighScoreScore[LogicCore.GameMode][index]):
			NewHighScoreRank = index

	if (LogicCore.PlayerInput[PlayerWithHighestScore] == InputCore.InputCPU):
		NewHighScoreRank = 999
		return

	if (NewHighScoreRank == 999):
		return

	for index in range(9, NewHighScoreRank, -1):
		HighScoreName[LogicCore.GameMode][index] = HighScoreName[LogicCore.GameMode][index-1]
		HighScoreLevel[LogicCore.GameMode][index] = HighScoreLevel[LogicCore.GameMode][index-1]
		HighScoreScore[LogicCore.GameMode][index] = HighScoreScore[LogicCore.GameMode][index-1]

	HighScoreName[LogicCore.GameMode][NewHighScoreRank] = " "
	HighScoreLevel[LogicCore.GameMode][NewHighScoreRank] = LogicCore.Level
	HighScoreScore[LogicCore.GameMode][NewHighScoreRank] = LogicCore.Score[PlayerWithHighestScore]

	pass

#----------------------------------------------------------------------------------------
func ClearHighScores():
	for mode in range(0, 6):
		HighScoreName[mode][0] = "JeZxLee"
		HighScoreName[mode][1] = "flairetic"
		HighScoreName[mode][2] = "EvanR"
		HighScoreName[mode][3] = "Daotheman"
		HighScoreName[mode][4] = "theweirdn8"
		HighScoreName[mode][5] = "mattmatteh"
		HighScoreName[mode][6] = "Oshi Bobo"
		HighScoreName[mode][7] = "D.J. Fading Twilight"
		HighScoreName[mode][8] = "Godot Engine Version 4.5+"
		HighScoreName[mode][9] = "You!"

		HighScoreLevel[mode][0] = 10
		HighScoreLevel[mode][1] = 9
		HighScoreLevel[mode][2] = 8
		HighScoreLevel[mode][3] = 7
		HighScoreLevel[mode][4] = 6
		HighScoreLevel[mode][5] = 5
		HighScoreLevel[mode][6] = 4
		HighScoreLevel[mode][7] = 3
		HighScoreLevel[mode][8] = 2
		HighScoreLevel[mode][9] = 1

		HighScoreScore[mode][0] = 10000
		HighScoreScore[mode][1] = 9000
		HighScoreScore[mode][2] = 8000
		HighScoreScore[mode][3] = 7000
		HighScoreScore[mode][4] = 6000
		HighScoreScore[mode][5] = 5000
		HighScoreScore[mode][6] = 4000
		HighScoreScore[mode][7] = 3000
		HighScoreScore[mode][8] = 2000
		HighScoreScore[mode][9] = 1000
	pass

#----------------------------------------------------------------------------------------
func LoadOptionsAndHighScores():
	var config = ConfigFile.new()

	var err = config.load(FILE_NAME)

	if err != OK:
		if (ScreensCore.OperatingSys == ScreensCore.OSAndroid):
			LogicCore.AllowComputerPlayers = 0
			LogicCore.DisableMultiplayer = 1
		return

	AudioCore.MusicVolume = config.get_value("Options", "MusicVolume")
	AudioCore.EffectsVolume = config.get_value("Options", "EffectsVolume")
	VisualsCore.FullScreenMode = config.get_value("Options", "FullScreenMode")
	LogicCore.GameMode = config.get_value("Options", "GameMode")
	LogicCore.AllowComputerPlayers = config.get_value("Options", "AllowComputerPlayers")
	LogicCore.SecretCode = config.get_value("Options", "SecretCode")
	HighScoreName = config.get_value("HighScores", "HighScoreName")
	HighScoreLevel = config.get_value("HighScores", "HighScoreLevel")
	HighScoreScore = config.get_value("HighScores", "HighScoreScore")
	VisualsCore.KeepAspectRatio = config.get_value("Options", "KeepAspectRatio")
	LogicCore.DisableMultiplayer = config.get_value("Options", "DisableMultiplayer")

	InputCore.JoyUpMapped = config.get_value("Options", "JoyUpMapped")
	InputCore.JoyDownMapped = config.get_value("Options", "JoyDownMapped")
	InputCore.JoyLeftMapped = config.get_value("Options", "JoyLeftMapped")
	InputCore.JoyRightMapped = config.get_value("Options", "JoyRightMapped")
	InputCore.JoyButtonOneMapped = config.get_value("Options", "JoyButtonOneMapped")
	InputCore.JoyButtonTwoMapped = config.get_value("Options", "JoyButtonTwoMapped")

	LogicCore.SecretCodeCombined = (LogicCore.SecretCode[0]*1000)+(LogicCore.SecretCode[1]*100)+(LogicCore.SecretCode[2]*10)+(LogicCore.SecretCode[3]*1)

	pass

#----------------------------------------------------------------------------------------
func SaveOptionsAndHighScores():
	var config = ConfigFile.new()

	config.set_value("Options", "MusicVolume", AudioCore.MusicVolume)
	config.set_value("Options", "EffectsVolume", AudioCore.EffectsVolume)
	config.set_value("Options", "FullScreenMode", VisualsCore.FullScreenMode)
	config.set_value("Options", "GameMode", LogicCore.GameMode)
	config.set_value("Options", "AllowComputerPlayers", LogicCore.AllowComputerPlayers)
	config.set_value("Options", "SecretCode", LogicCore.SecretCode)
	config.set_value("HighScores", "HighScoreName", HighScoreName)
	config.set_value("HighScores", "HighScoreLevel", HighScoreLevel)
	config.set_value("HighScores", "HighScoreScore", HighScoreScore)
	config.set_value("Options", "KeepAspectRatio", VisualsCore.KeepAspectRatio)
	config.set_value("Options", "DisableMultiplayer", LogicCore.DisableMultiplayer)

	config.set_value("Options", "JoyUpMapped", InputCore.JoyUpMapped)
	config.set_value("Options", "JoyDownMapped", InputCore.JoyDownMapped)
	config.set_value("Options", "JoyLeftMapped", InputCore.JoyLeftMapped)
	config.set_value("Options", "JoyRightMapped", InputCore.JoyRightMapped)
	config.set_value("Options", "JoyButtonOneMapped", InputCore.JoyButtonOneMapped)
	config.set_value("Options", "JoyButtonTwoMapped", InputCore.JoyButtonTwoMapped)

	var _warnErase = config.save(FILE_NAME)

	pass

#----------------------------------------------------------------------------------------
func _ready():
	for x in range(6):
		HighScoreName.append([])
		HighScoreName[x].resize(10)
		for y in range(10):
			HighScoreName[x][y] = null

	for xL in range(6):
		HighScoreLevel.append([])
		HighScoreLevel[xL].resize(10)
		for yL in range(10):
			HighScoreLevel[xL][yL] = null

	for xS in range(6):
		HighScoreScore.append([])
		HighScoreScore[xS].resize(10)
		for yS in range(10):
			HighScoreScore[xS][yS] = null

	ClearHighScores()

	PlayerWithHighestScore = 1
	NewHighScoreRank = 999

	pass

#----------------------------------------------------------------------------------------
func _process(_delta):

	pass
