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

# "ScreensCore.gd"
extends Node2D

var ItchBuild = false

var NewGroundsBuild = false

var VideoHTML5 = false
var VideoAndroid = false

var SeeEndingStaff = false

var OptionsTextMusicVol
var OptionsTextEffectsVol
var OptionsTextAspectRatio
var OptionsTextGamepads
var OptionsTextGameMode
var OptionsTextCompPlayers
var OptionsTextCompPlayersSys
var OptionsTextCodeOne
var OptionsTextCodeTwo
var OptionsTextCodeThree
var OptionsTextCodeFour
var OptionsTextDisableMultiplayer

var PlayerInputText = []

const FadingIdle			= -1
const FadingFromBlack		= 0
const FadingToBlack			= 1
var ScreenFadeStatus
var ScreenFadeTransparency

var ScreenDisplayTimer

const HTML5Screen			= -1
const GodotScreen			= 0
const FASScreen				= 1
const TitleScreen			= 2
const OptionsScreen			= 3
const HowToPlayScreen		= 4
const HighScoresScreen		= 5
const AboutScreen			= 6
const MusicTestScreen		= 7
const PlayingGameScreen		= 8
const CutSceneScreen		= 9
const NewHighScoreScreen	= 10
const WonGameScreen			= 11
const InputScreen			= 12
const NoCPUScreen			= 13

var ScreenToDisplay
var ScreenToDisplayNext

const OSDesktop				= 1
const OSHTMLFive			= 2
const OSAndroid				= 3
var OperatingSys = 0

var TS1ScreenY

var DemoTextIndex
var DemoRotation
var DemoRotationDirection

var StaffScreenTSOneScale

var CutSceneTextIndex = []
var CutSceneTextScale = []
var CutSceneTextScaleIndex

var CutSceneScene
var CutSceneSceneTotal = []

var NewHighScoreString = " "
var NewHighScoreStringIndex

var videostream = VideoStreamTheora.new()
var videoplayer = VideoStreamPlayer.new()

var NewHighScoreNameInputJoyX
var NewHighScoreNameInputJoyY

const JoySetupNotStarted		= 0
const JoySetup1Up				= 1
const JoySetup1Down				= 2
const JoySetup1Left				= 3
const JoySetup1Right			= 4
const JoySetup1Button1			= 5
const JoySetup1Button2			= 6
const JoySetup2Up				= 7
const JoySetup2Down				= 8
const JoySetup2Left				= 9
const JoySetup2Right			= 10
const JoySetup2Button1			= 11
const JoySetup2Button2			= 12
const JoySetup3Up				= 13
const JoySetup3Down				= 14
const JoySetup3Left				= 15
const JoySetup3Right			= 16
const JoySetup3Button1			= 17
const JoySetup3Button2			= 18
var JoystickSetupIndex = JoySetupNotStarted

var WonSunsetY
var WonHimX
var WonHerX

var P1ScoreText
var P2ScoreText
var P3ScoreText
var LevelText

var fps = []

var TSOneDisplayTimer

var DontDisplayJoinIn

var JoinInFlash

var InputNameOne
var InputNameTwo
var InputNameThree

var PlayingExited = false

#----------------------------------------------------------------------------------------
func _ready():
	ScreenFadeStatus = FadingFromBlack
	ScreenFadeTransparency = 1.0

	ScreenToDisplay = GodotScreen
	ScreenToDisplayNext = FASScreen

	if (OS.get_name() == "Windows" or OS.get_name() == "Linux"):
		OperatingSys = OSDesktop
	elif OS.get_name() == "Web":
		OperatingSys = OSHTMLFive
	elif OS.get_name() == "Android":
		OperatingSys = OSAndroid

	if (VideoAndroid == true):
		OperatingSys = OSAndroid

#	OperatingSys = OSAndroid

	var _warnErase = CutSceneTextIndex.resize(7)
	_warnErase = CutSceneTextScale.resize(7)
	CutSceneTextScale[0] = 0.0
	CutSceneTextScale[1] = 0.0
	CutSceneTextScale[2] = 0.0
	CutSceneTextScale[3] = 0.0
	CutSceneTextScale[4] = 0.0
	CutSceneTextScale[5] = 0.0
	CutSceneTextScale[6] = 0.0
	CutSceneTextScaleIndex = 0

	_warnErase = CutSceneSceneTotal.resize(10)
	CutSceneSceneTotal[1] = 1
	CutSceneSceneTotal[2] = 2
	CutSceneSceneTotal[3] = 2
	CutSceneSceneTotal[4] = 1
	CutSceneSceneTotal[5] = 3
	CutSceneSceneTotal[6] = 4
	CutSceneSceneTotal[7] = 1
	CutSceneSceneTotal[8] = 3
	CutSceneSceneTotal[9] = 1

	_warnErase = fps.resize(4)
	fps[0] = 20
	fps[1] = 45
	fps[2] = 30
	fps[3] = 60

	_warnErase = PlayerInputText.resize(3)

	pass

#----------------------------------------------------------------------------------------
func _process(_delta):

	pass

#----------------------------------------------------------------------------------------
func ApplyScreenFadeTransition():
	if ScreenFadeStatus == FadingIdle: return
	
	if ScreenFadeStatus == FadingFromBlack:
		if ScreenFadeTransparency > 0.25:
			ScreenFadeTransparency-=0.25
		else:
			ScreenFadeTransparency = 0.0
			ScreenFadeStatus = FadingIdle
	elif ScreenFadeStatus == FadingToBlack:
		if ScreenFadeTransparency < 0.75:
			ScreenFadeTransparency+=0.25
		else:
			ScreenFadeTransparency = 1.0
			ScreenFadeStatus = FadingFromBlack
			
			VisualsCore.MoveAllActiveSpritesOffScreen()
			VisualsCore.DeleteAllTexts()
			InterfaceCore.DeleteAllGUI()
			InterfaceCore.InitializeGUI(false)

			ScreenToDisplay = ScreenToDisplayNext

	RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[0], Color(1.0, 1.0, 1.0, ScreenFadeTransparency))

	pass

#----------------------------------------------------------------------------------------
func DisplayHTML5Screen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS A BUTTON ON", 0, 25, 1, 34, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "ALL GAME CONTROLLERS NOW", 0, 25+55, 1, 34, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "TO INITIALIZE!", 0, 25+110, 1, 34, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "MAXIMUM OF 3", 0, 25+165, 1, 34, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		InputCore.NumberOfGamePadsText = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "0", 0, 300, 1, 34, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "GAME CONTROLLER(S) FOUND", 0, 300+50, 1, 34, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		InterfaceCore.CreateButton (5, (VisualsCore.ScreenWidth/2.0), VisualsCore.ScreenHeight-25)

	if (InputCore.FoundGamepadOne == false):
		if ( InputCore.GetJoystickInputForMapping(0, 0) != -1 ):
			InputCore.ThereAreGamepads = true
			InputCore.FoundGamepadOne = true
			InputCore.NumberOfGamepads +=1
			VisualsCore.DrawText(InputCore.NumberOfGamePadsText, str(InputCore.NumberOfGamepads), 0, 300, 1, 34, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

	if (InputCore.FoundGamepadTwo == false):
		if ( InputCore.GetJoystickInputForMapping(1, 0) != -1 ):
			InputCore.ThereAreGamepads = true
			InputCore.FoundGamepadTwo = true
			InputCore.NumberOfGamepads +=1
			VisualsCore.DrawText(InputCore.NumberOfGamePadsText, str(InputCore.NumberOfGamepads), 0, 300, 1, 34, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

	if (InputCore.FoundGamepadThree == false):
		if ( InputCore.GetJoystickInputForMapping(2, 0) != -1 ):
			InputCore.ThereAreGamepads = true
			InputCore.FoundGamepadThree = true
			InputCore.NumberOfGamepads +=1
			VisualsCore.DrawText(InputCore.NumberOfGamePadsText, str(InputCore.NumberOfGamepads), 0, 300, 1, 34, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

	if (InterfaceCore.ThisButtonWasPressed(0) == true):
		ScreenFadeStatus = FadingToBlack

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		ScreenToDisplayNext = GodotScreen
		InputCore.DelayAllUserInput = 15

	pass

#----------------------------------------------------------------------------------------
func DisplayGodotScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		if (ScreensCore.OperatingSys == OSHTMLFive):
			if (InputCore.HTML5input == InputCore.InputTouchOne):
				var window: Window = get_tree().get_root()
				window.mode = Window.Mode.MODE_FULLSCREEN

		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
		VisualsCore.DrawSprite(5, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, DataCore.GODOT_VERSION, 445+10, 185+20, 0, 23, 1.0, 1.0, 0, 0.7, 0.7, 0.7, 1.0, 0.9, 0.9, 0.9)

		ScreenDisplayTimer = (160*2)

		if (VideoHTML5 == true or VideoAndroid == true):
			ScreenDisplayTimer+=2000

	if (InputCore.DelayAllUserInput == -1 && (InputCore.MouseButtonLeftPressed == true || InputCore.KeyboardSpacebarPressed == true || InputCore.KeyboardEnterPressed == true || InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed)) && ScreenDisplayTimer > 1:
		ScreenDisplayTimer = 1
		InputCore.DelayAllUserInput = 20

	if 	ScreenDisplayTimer > 1:
		ScreenDisplayTimer-=1
	elif ScreenDisplayTimer == 1:
		ScreenToDisplayNext = FASScreen
		ScreenFadeStatus = FadingToBlack
		ScreenDisplayTimer = -1
		if InputCore.MouseButtonLeftPressed == true || InputCore.KeyboardSpacebarPressed == true || InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed:  AudioCore.PlayEffect(1, 1)

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		ScreenToDisplayNext = FASScreen
		InputCore.DelayAllUserInput = 15

	pass

#----------------------------------------------------------------------------------------
func DisplayFASScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:

		RenderingServer.set_default_clear_color(Color(0.1, 0.1, 0.1, 1.0))

		VisualsCore.DrawSprite(7, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

		ScreenDisplayTimer = (160*2)

	if (InputCore.DelayAllUserInput == -1 && (InputCore.MouseButtonLeftPressed == true || InputCore.KeyboardSpacebarPressed == true || InputCore.KeyboardEnterPressed == true || InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed)) && ScreenDisplayTimer > 1:
		ScreenDisplayTimer = 1
		InputCore.DelayAllUserInput = 15

	if 	ScreenDisplayTimer > 1:
		ScreenDisplayTimer-=1
	elif ScreenDisplayTimer == 1:
		ScreenToDisplayNext = TitleScreen
		ScreenFadeStatus = FadingToBlack
		ScreenDisplayTimer = -1
		if InputCore.MouseButtonLeftPressed == true || InputCore.KeyboardSpacebarPressed == true || InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed:  AudioCore.PlayEffect(1, 1)

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		ScreenToDisplayNext = TitleScreen
		InputCore.DelayAllUserInput = 15

		AudioCore.PlayMusic(0, true)

	pass

#----------------------------------------------------------------------------------------
func DisplayTitleScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		DataCore.SaveOptionsAndHighScores()
		
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
		VisualsCore.DrawSprite(10, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

		if (AudioCore.MusicVolume == 0.0 && AudioCore.EffectsVolume == 0.0):
			InterfaceCore.CreateIcon(110, 40, 40, " ")
		else:
			InterfaceCore.CreateIcon(111, 40, 40, " ")

		InterfaceCore.CreateIcon(117, 1024-40, 40, " ")

		VisualsCore.DrawSprite(21, VisualsCore.ScreenWidth/2.0, 107.0-32+2, 1.5, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

		VisualsCore.DrawSprite(30, VisualsCore.ScreenWidth/2.0, 150+45-30-7-1, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

		var highScoreFullText
		highScoreFullText = "''"+DataCore.HighScoreName[LogicCore.GameMode][0]+"'' Scored: "+str(DataCore.HighScoreScore[LogicCore.GameMode][0])
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, highScoreFullText, 0, 170+35+15-20-10-4, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawSprite(31, VisualsCore.ScreenWidth/2.0, 194+35+20-20-10-4, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

		if (LogicCore.SecretCodeCombined != 5432 and LogicCore.SecretCodeCombined != 5431):
			var buttonY = 223+70-10-30
			var buttonOffsetY = 51+20

			InterfaceCore.CreateButton (0, (VisualsCore.ScreenWidth/2.0), (buttonY))
			buttonY+=buttonOffsetY
			InterfaceCore.CreateButton (1, (VisualsCore.ScreenWidth/2.0), (buttonY))
			buttonY+=buttonOffsetY
			InterfaceCore.CreateButton (2, (VisualsCore.ScreenWidth/2.0), (buttonY))
			buttonY+=buttonOffsetY
			InterfaceCore.CreateButton (3, (VisualsCore.ScreenWidth/2.0), (buttonY))
			buttonY+=buttonOffsetY
			InterfaceCore.CreateButton (4, (VisualsCore.ScreenWidth/2.0), (buttonY))
			buttonY+=buttonOffsetY
		else:
			var buttonY = 223+70-10-30
			var buttonOffsetY = 59

			InterfaceCore.CreateButton (0, (VisualsCore.ScreenWidth/2.0), (buttonY))
			buttonY+=buttonOffsetY
			InterfaceCore.CreateButton (1, (VisualsCore.ScreenWidth/2.0), (buttonY))
			buttonY+=buttonOffsetY
			InterfaceCore.CreateButton (2, (VisualsCore.ScreenWidth/2.0), (buttonY))
			buttonY+=buttonOffsetY
			InterfaceCore.CreateButton (3, (VisualsCore.ScreenWidth/2.0), (buttonY))
			buttonY+=buttonOffsetY
			InterfaceCore.CreateButton (4, (VisualsCore.ScreenWidth/2.0), (buttonY))
			buttonY+=buttonOffsetY

			InterfaceCore.CreateButton (8, (VisualsCore.ScreenWidth/2.0), (buttonY))
			buttonY+=buttonOffsetY

		VisualsCore.DrawSprite(32, VisualsCore.ScreenWidth/2.0, 602-15, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Team: ''BetaMax Heroes''", 0, 640-19-4, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		InterfaceCore.ArrowSetSelectedByKeyboardLast = -1

		LogicCore.GameWon = false

	if InterfaceCore.ThisIconWasPressed(0) == true:
		if (AudioCore.MusicVolume == 0.0 && AudioCore.EffectsVolume == 0.0):
			AudioCore.MusicVolume = 1.0
			AudioCore.EffectsVolume = 0.5
			RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[110], Transform2D(0.0, Vector2(1.0, 1.0), 0.0, Vector2(-99999, -99999)))
			InterfaceCore.Icons.IconSprite[0]  = 111
		else:
			AudioCore.MusicVolume = 0.0
			AudioCore.EffectsVolume = 0.0
			RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[111], Transform2D(0.0, Vector2(1.0, 1.0), 0.0, Vector2(-99999, -99999)))
			InterfaceCore.Icons.IconSprite[0]  = 110

		AudioCore.SetMusicAndEffectsVolume(AudioCore.MusicVolume, AudioCore.EffectsVolume)
		DataCore.SaveOptionsAndHighScores()

	var _value

	if (InterfaceCore.ThisIconWasPressed(1) == true):
		if (ScreensCore.OperatingSys != ScreensCore.OSHTMLFive):
			get_tree().quit()

	if InterfaceCore.ThisButtonWasPressed(0) == true:
		CutSceneScene = 1
		if (LogicCore.AllowComputerPlayers > 0):
			ScreenToDisplayNext = CutSceneScreen
			AudioCore.PlayMusic(1, true)
		elif (LogicCore.DisableMultiplayer == 0):
			ScreenToDisplayNext = NoCPUScreen
		else:
			ScreenToDisplayNext = CutSceneScreen
			AudioCore.PlayMusic(1, true)

		InputCore.DelayAllUserInput = 25
		DontDisplayJoinIn = false
		
		LogicCore.SetupForNewGame()

		if (LogicCore.SecretCodeCombined != 8889):
			if (LogicCore.AllowComputerPlayers != 2):  LogicCore.PlayerInput[1] = InputCore.InputThatStartedNewGame
		else:
			LogicCore.ComputerPlayersTotalLevelClears = 0.0
			LogicCore.ComputerPlayersTotalGamesPlayed = 0.0
		
		ScreenFadeStatus = FadingToBlack
	elif InterfaceCore.ThisButtonWasPressed(1) == true:
		ScreenToDisplayNext = OptionsScreen
		InputCore.OptionsInJoySetup = false
		JoystickSetupIndex = JoySetupNotStarted
		ScreenFadeStatus = FadingToBlack
	elif InterfaceCore.ThisButtonWasPressed(2) == true:
		ScreenToDisplayNext = HowToPlayScreen
		ScreenFadeStatus = FadingToBlack
	elif InterfaceCore.ThisButtonWasPressed(3) == true:
		ScreenToDisplayNext = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	elif InterfaceCore.ThisButtonWasPressed(4) == true:
		ScreenToDisplayNext = AboutScreen
		ScreenFadeStatus = FadingToBlack

	if (LogicCore.SecretCodeCombined == 5432 || LogicCore.SecretCodeCombined == 5431):
		if InterfaceCore.ThisButtonWasPressed(5) == true:
			ScreenToDisplayNext = MusicTestScreen
			ScreenFadeStatus = FadingToBlack

			if AudioCore.MusicVolume == 0.0:
				AudioCore.MusicVolume = 1.0
				AudioCore.EffectsVolume = 1.0
				AudioCore.SetMusicAndEffectsVolume(AudioCore.MusicVolume, AudioCore.EffectsVolume)
				AudioCore.PlayMusic(0, true)

	if (SeeEndingStaff == true):
		InputCore.DelayAllUserInput = 100
		SeeEndingStaff = false
		LogicCore.GameWon = true
		LogicCore.Score[0] = 0
		LogicCore.Score[1] = 1000000
		LogicCore.Score[2] = 0
		LogicCore.Level = 10
		DataCore.CheckForNewHighScore()
		ScreenFadeStatus = FadingToBlack
		ScreenToDisplayNext = WonGameScreen

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		InputCore.DelayAllUserInput = 15

	pass

#----------------------------------------------------------------------------------------
func DisplayInputScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))

		InterfaceCore.CreateIcon(180, (VisualsCore.ScreenWidth/2.0), (VisualsCore.ScreenHeight/2.0)-160, " ")
		InterfaceCore.CreateIcon(181, (VisualsCore.ScreenWidth/2.0), (VisualsCore.ScreenHeight/2.0)+160, " ")

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "CHOOSE YOUR INPUT!", 0, (VisualsCore.ScreenHeight/2.0)-40-9, 1, 113, 1.0, 1.0, 0, 0.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

		ScreenDisplayTimer = 100

	if InterfaceCore.ThisIconWasPressed(0) == true:
		InputCore.HTML5input = InputCore.InputKeyboard
		ScreenDisplayTimer = 1
		InputCore.DelayAllUserInput = 20
	elif InterfaceCore.ThisIconWasPressed(1) == true:
		InputCore.HTML5input = InputCore.InputTouchTwo
		ScreenDisplayTimer = 1
		InputCore.DelayAllUserInput = 20

	if ScreenDisplayTimer == 1:
		ScreenToDisplayNext = GodotScreen
		ScreenFadeStatus = FadingToBlack
		ScreenDisplayTimer = -1
		if InputCore.MouseButtonLeftPressed == true || InputCore.KeyboardSpacebarPressed == true || InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed:  AudioCore.PlayEffect(1, 1)

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		ScreenToDisplayNext = GodotScreen
		InputCore.DelayAllUserInput = 15

	pass

#----------------------------------------------------------------------------------------
func DisplayOptionsScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
		if (JoystickSetupIndex == JoySetupNotStarted):
			VisualsCore.DrawSprite(10, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.5)
	
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "O  P  T  I  O  N  S:", 0, 12, 1, 22, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawSprite(30, VisualsCore.ScreenWidth/2.0, 30, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " ", 0, 0, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Music Volume:", 75, 65-8, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
	
			InterfaceCore.CreateArrowSet(0, 65-8)
			if AudioCore.MusicVolume == 1.0:
				OptionsTextMusicVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "100% Volume", -75, 65-8, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.75:
				OptionsTextMusicVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "75% Volume", -75, 65-8, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.5:
				OptionsTextMusicVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "50% Volume", -75, 65-8, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.25:
				OptionsTextMusicVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "25% Volume", -75, 65-8, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.0:
				OptionsTextMusicVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "0% Volume", -75, 65-8, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Sound Effects Volume:", 75, 65+50-8-5, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(1, 65+50-8-5)
			if AudioCore.EffectsVolume == 1.0:
				OptionsTextEffectsVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "100% Volume", -75, 65+50-8-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.75:
				OptionsTextEffectsVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "75% Volume", -75, 65+50-8-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.5:
				OptionsTextEffectsVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "50% Volume", -75, 65+50-8-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.25:
				OptionsTextEffectsVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "25% Volume", -75, 65+50-8-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.0:
				OptionsTextEffectsVol = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "0% Volume", -75, 65+50-8-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Full Screen Mode:", 75, 65+50+50-8-5-6, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(2, 65+50+50-8-5-6)
			if (VisualsCore.FullScreenMode == true):
				OptionsTextAspectRatio = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "On", -75, 65+50+50-8-5-6, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif (VisualsCore.FullScreenMode == false):
				OptionsTextAspectRatio = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Off", -75, 65+50+50-8-5-6, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Screen Display Option:", 75, 65+50+50+50-8-5-6-5, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(6, 65+50+50+50-8-5-6-5)
			if (VisualsCore.KeepAspectRatio == 0):
				OptionsTextCompPlayersSys = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Stretch & Fill Screen", -75,65+50+50+50-8-5-6-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif (VisualsCore.KeepAspectRatio == 1):
				OptionsTextCompPlayersSys = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Keep Aspect Ratio", -75, 65+50+50+50-8-5-6-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawSprite(31, VisualsCore.ScreenWidth/2.0, 250-30, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Game Mode:", 75, 70+50+50+50+65-7-29, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(4, 70+50+50+50+65-7-29)
			if LogicCore.GameMode == LogicCore.ChildMode:
				OptionsTextGameMode = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Child Mode", -75, 70+50+50+50+65-7-29, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TeenMode:
				OptionsTextGameMode = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Teen Mode", -75, 70+50+50+50+65-7-29, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.AdultMode:
				OptionsTextGameMode = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Adult Mode", -75, 70+50+50+50+65-7-29, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TurboMode:
				OptionsTextGameMode = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Turbo Mode", -75, 70+50+50+50+65-7-29, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Computer A.I. Players:", 75, 70+50+50+50+72, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(5, 70+50+50+50+72)
			if LogicCore.AllowComputerPlayers == 2:
				OptionsTextCompPlayers = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "[All Players Test Mode!] On", -75, 70+50+50+50+72, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.AllowComputerPlayers == 1:
				OptionsTextCompPlayers = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "On", -75, 70+50+50+50+72, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.AllowComputerPlayers == 0:
				OptionsTextCompPlayers = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Off", -75, 70+50+50+50+72, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Disable Multiplayer:", 75, 70+50+50+50+65+50-14+65-14-7-30, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(6, 70+50+50+50+65+50-14+65-14-7-30)
			if LogicCore.DisableMultiplayer == 1:
				OptionsTextDisableMultiplayer = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "True", -75, 70+50+50+50+65+50-14+65-14-7-30, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.DisableMultiplayer == 0:
				OptionsTextDisableMultiplayer = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "False", -75, 70+50+50+50+65+50-14+65-14-7-30, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawSprite(32, VisualsCore.ScreenWidth/2.0, 70+50+50+50+65+50-14+65-14-9, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Secret Code 1:", 75, 70+50+65+50+50+70+37, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(7, 70+50+65+50+50+70+37)
			OptionsTextCodeOne = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(LogicCore.SecretCode[0]), -75, 70+50+65+50+50+70+37, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Secret Code 2:", 75, 70+50+65+50+50+70+80, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(8, 70+50+65+50+50+70+80)
			OptionsTextCodeTwo = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(LogicCore.SecretCode[1]), -75, 70+50+65+50+50+70+80, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Secret Code 3:", 75, 70+50+65+50+50+70+80+45, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(9, 70+50+65+50+50+70+80+45)
			OptionsTextCodeThree = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(LogicCore.SecretCode[2]), -75, 70+50+65+50+50+70+80+45, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Secret Code 4:", 75, 70+50+65+50+50+70+80+45+45, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InterfaceCore.CreateArrowSet(10, 70+50+65+50+50+70+80+45+45)
			OptionsTextCodeFour = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(LogicCore.SecretCode[3]), -75, 70+50+65+50+50+70+80+45+45, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			DataCore.SaveOptionsAndHighScores()

			VisualsCore.DrawSprite(33, VisualsCore.ScreenWidth/2.0, 583-35, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)
			InterfaceCore.CreateButton (6, (VisualsCore.ScreenWidth/2.0), VisualsCore.ScreenHeight-25)

			if (InputCore.NumberOfGamepads > 0 or InputCore.num_controllers > 0):
				VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [F1] TO MAP GAME CONTROLLER[S]", 0.0, (VisualsCore.ScreenHeight/2.0)+250, 1, 21, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup1Up):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [UP] ON GAMEPAD 1", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup1Down):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [DOWN] ON GAMEPAD 1", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup1Left):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [LEFT] ON GAMEPAD 1", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup1Right):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [RIGHT] ON GAMEPAD 1", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup1Button1):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [BUTTON 1] ON GAMEPAD 1", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup1Button2):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [BUTTON 2] ON GAMEPAD 1", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup2Up):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [UP] ON GAMEPAD 2", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup2Down):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [DOWN] ON GAMEPAD 2", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup2Left):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [LEFT] ON GAMEPAD 2", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup2Right):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [RIGHT] ON GAMEPAD 2", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup2Button1):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [BUTTON 1] ON GAMEPAD 2", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup2Button2):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [BUTTON 2] ON GAMEPAD 2", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup3Up):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [UP] ON GAMEPAD 3", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup3Down):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [DOWN] ON GAMEPAD 3", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup3Left):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [LEFT] ON GAMEPAD 3", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup3Right):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [RIGHT] ON GAMEPAD 3", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup3Button1):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [BUTTON 1] ON GAMEPAD 3", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif (JoystickSetupIndex == JoySetup3Button2):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [BUTTON 2] ON GAMEPAD 3", 0.0, VisualsCore.ScreenHeight/2.0, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

		if (JoystickSetupIndex > JoySetupNotStarted):
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PRESS [F1] TO QUIT[Resetting Config]", 0.0, (VisualsCore.ScreenHeight/2.0)+75, 1, 45, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

	if InputCore.DelayAllUserInput == -1 and Input.is_action_pressed("ConfigureJaoysticks"):
		InputCore.DelayAllUserInput = 50

		ScreenToDisplayNext = OptionsScreen
		ScreenFadeStatus = FadingToBlack

		if ( InputCore.OptionsInJoySetup == false and ( InputCore.NumberOfGamepads > 0 or InputCore.num_controllers > 0) ):
			JoystickSetupIndex = JoySetup1Up
			InputCore.OptionsInJoySetup = true
		else:
			JoystickSetupIndex =  JoySetupNotStarted
			InputCore.OptionsInJoySetup = false

			for index in range(0, 9):
				InputCore.JoyUpMapped[index][0] = 11+10
				InputCore.JoyDownMapped[index][0] = 12+10
				InputCore.JoyLeftMapped[index][0] = 13+10
				InputCore.JoyRightMapped[index][0] = 14+10
				InputCore.JoyButtonOneMapped[index][0] = 0+10
				InputCore.JoyButtonTwoMapped[index][0] = 1+10

		AudioCore.PlayEffect(1, 2)

	if (JoystickSetupIndex == JoySetup1Up):
		if ( InputCore.GetJoystickInputForMapping(0, false) != -1):
			InputCore.JoyUpMapped[0][0] = InputCore.GetJoystickInputForMapping(0, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1, 1)
	elif (JoystickSetupIndex == JoySetup1Down):
		if ( InputCore.GetJoystickInputForMapping(0, false) != -1):
			InputCore.JoyDownMapped[0][0] = InputCore.GetJoystickInputForMapping(0, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1, 1)
	elif (JoystickSetupIndex == JoySetup1Left):
		if ( InputCore.GetJoystickInputForMapping(0, false) != -1):
			InputCore.JoyLeftMapped[0][0] = InputCore.GetJoystickInputForMapping(0, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1, 1)
	elif (JoystickSetupIndex == JoySetup1Right):
		if ( InputCore.GetJoystickInputForMapping(0, false) != -1):
			InputCore.JoyRightMapped[0][0] = InputCore.GetJoystickInputForMapping(0, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1, 1)
	elif (JoystickSetupIndex == JoySetup1Button1):
		if ( InputCore.GetJoystickInputForMapping(0, true) != -1):
			InputCore.JoyButtonOneMapped[0][0] = InputCore.GetJoystickInputForMapping(0, true)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1, 1)
	elif (JoystickSetupIndex == JoySetup1Button2):
		if ( InputCore.GetJoystickInputForMapping(0, true) != -1):
			InputCore.JoyButtonTwoMapped[0][0] = InputCore.GetJoystickInputForMapping(0, true)
			AudioCore.PlayEffect(1, 1)

			if ( InputCore.NumberOfGamepads > 1 or InputCore.num_controllers > 1):
				JoystickSetupIndex = JoySetup2Up
			else:
				JoystickSetupIndex = JoySetupNotStarted

			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
	elif (JoystickSetupIndex == JoySetup2Up):
		if ( InputCore.GetJoystickInputForMapping(1, false) != -1):
			InputCore.JoyUpMapped[1][0] = InputCore.GetJoystickInputForMapping(1, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1, 1)
	elif (JoystickSetupIndex == JoySetup2Down):
		if ( InputCore.GetJoystickInputForMapping(1, false) != -1):
			InputCore.JoyDownMapped[1][0] = InputCore.GetJoystickInputForMapping(1, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1, 1)
	elif (JoystickSetupIndex == JoySetup2Left):
		if ( InputCore.GetJoystickInputForMapping(1, false) != -1):
			InputCore.JoyLeftMapped[1][0] = InputCore.GetJoystickInputForMapping(1, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1, 1)
	elif (JoystickSetupIndex == JoySetup2Right):
		if ( InputCore.GetJoystickInputForMapping(1, false) != -1):
			InputCore.JoyRightMapped[1][0] = InputCore.GetJoystickInputForMapping(1, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1, 1)
	elif (JoystickSetupIndex == JoySetup2Button1):
		if ( InputCore.GetJoystickInputForMapping(1, true) != -1):
			InputCore.JoyButtonOneMapped[1][0] = InputCore.GetJoystickInputForMapping(1, true)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1, 1)
	elif (JoystickSetupIndex == JoySetup2Button2):
		if ( InputCore.GetJoystickInputForMapping(1, true) != -1):
			InputCore.JoyButtonTwoMapped[1][0] = InputCore.GetJoystickInputForMapping(1, true)
			AudioCore.PlayEffect(1, 1)

			if ( InputCore.NumberOfGamepads > 2 or InputCore.num_controllers > 2 ):
				JoystickSetupIndex = JoySetup3Up
			else:
				JoystickSetupIndex = JoySetupNotStarted

			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
	elif (JoystickSetupIndex == JoySetup3Up):
		if ( InputCore.GetJoystickInputForMapping(2, false) != -1):
			InputCore.JoyUpMapped[2][0] = InputCore.GetJoystickInputForMapping(2, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1, 1)
	elif (JoystickSetupIndex == JoySetup3Down):
		if ( InputCore.GetJoystickInputForMapping(2, false) != -1):
			InputCore.JoyDownMapped[2][0] = InputCore.GetJoystickInputForMapping(2, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1, 1)
	elif (JoystickSetupIndex == JoySetup3Left):
		if ( InputCore.GetJoystickInputForMapping(2, false) != -1):
			InputCore.JoyLeftMapped[2][0] = InputCore.GetJoystickInputForMapping(2, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1, 1)
	elif (JoystickSetupIndex == JoySetup3Right):
		if ( InputCore.GetJoystickInputForMapping(2, false) != -1):
			InputCore.JoyRightMapped[2][0] = InputCore.GetJoystickInputForMapping(2, false)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1, 1)
	elif (JoystickSetupIndex == JoySetup3Button1):
		if ( InputCore.GetJoystickInputForMapping(2, true) != -1):
			InputCore.JoyButtonOneMapped[2][0] = InputCore.GetJoystickInputForMapping(2, true)
			JoystickSetupIndex+=1
			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
			AudioCore.PlayEffect(1, 1)
	elif (JoystickSetupIndex == JoySetup3Button2):
		if ( InputCore.GetJoystickInputForMapping(2, true) != -1):
			InputCore.JoyButtonTwoMapped[2][0] = InputCore.GetJoystickInputForMapping(2, true)
			AudioCore.PlayEffect(1, 1)

			JoystickSetupIndex = JoySetupNotStarted

			InputCore.DelayAllUserInput = 30
			ScreenToDisplayNext = OptionsScreen
			ScreenFadeStatus = FadingToBlack
	elif (JoystickSetupIndex == JoySetupNotStarted):
		if InterfaceCore.ThisArrowWasPressed(0) == true:
			if AudioCore.MusicVolume > 0.0:
				AudioCore.MusicVolume-=0.25
			else:  AudioCore.MusicVolume = 1.0
			
			if AudioCore.MusicVolume == 1.0:
				VisualsCore.DrawText(OptionsTextMusicVol, "100% Volume", -75, 65-8, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.75:
				VisualsCore.DrawText(OptionsTextMusicVol, "75% Volume", -75, 65-8, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.5:
				VisualsCore.DrawText(OptionsTextMusicVol, "50% Volume", -75, 65-8, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.25:
				VisualsCore.DrawText(OptionsTextMusicVol, "25% Volume", -75, 65-8, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.0:
				VisualsCore.DrawText(OptionsTextMusicVol, "0% Volume", -75, 65-8, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			
			AudioCore.SetMusicAndEffectsVolume(AudioCore.MusicVolume, AudioCore.EffectsVolume)
		elif InterfaceCore.ThisArrowWasPressed(0.5) == true:
			if AudioCore.MusicVolume < 1.0:
				AudioCore.MusicVolume+=0.25
			else:  AudioCore.MusicVolume = 0.0
			
			if AudioCore.MusicVolume == 1.0:
				VisualsCore.DrawText(OptionsTextMusicVol, "100% Volume", -75, 65-8, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.75:
				VisualsCore.DrawText(OptionsTextMusicVol, "75% Volume", -75, 65-8, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.5:
				VisualsCore.DrawText(OptionsTextMusicVol, "50% Volume", -75, 65-8, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.25:
				VisualsCore.DrawText(OptionsTextMusicVol, "25% Volume", -75, 65-8, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.MusicVolume == 0.0:
				VisualsCore.DrawText(OptionsTextMusicVol, "0% Volume", -75, 65-8, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			AudioCore.SetMusicAndEffectsVolume(AudioCore.MusicVolume, AudioCore.EffectsVolume)
		elif InterfaceCore.ThisArrowWasPressed(1.0) == true:
			if AudioCore.EffectsVolume > 0.0:
				AudioCore.EffectsVolume-=0.25
			else:  AudioCore.EffectsVolume = 1.0
			
			if AudioCore.EffectsVolume == 1.0:
				VisualsCore.DrawText(OptionsTextEffectsVol, "100% Volume", -75, 65+50-8-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.75:
				VisualsCore.DrawText(OptionsTextEffectsVol, "75% Volume", -75, 65+50-8-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.5:
				VisualsCore.DrawText(OptionsTextEffectsVol, "50% Volume", -75, 65+50-8-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.25:
				VisualsCore.DrawText(OptionsTextEffectsVol, "25% Volume", -75, 65+50-8-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.0:
				VisualsCore.DrawText(OptionsTextEffectsVol, "0% Volume", -75, 65+50-8-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			AudioCore.SetMusicAndEffectsVolume(AudioCore.MusicVolume, AudioCore.EffectsVolume)
		elif InterfaceCore.ThisArrowWasPressed(1.5) == true:
			if AudioCore.EffectsVolume < 1.0:
				AudioCore.EffectsVolume+=0.25
			else:  AudioCore.EffectsVolume = 0.0

			if AudioCore.EffectsVolume == 1.0:
				VisualsCore.DrawText(OptionsTextEffectsVol, "100% Volume", -75, 65+50-8-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.75:
				VisualsCore.DrawText(OptionsTextEffectsVol, "75% Volume", -75, 65+50-8-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.5:
				VisualsCore.DrawText(OptionsTextEffectsVol, "50% Volume", -75, 65+50-8-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.25:
				VisualsCore.DrawText(OptionsTextEffectsVol, "25% Volume", -75, 65+50-8-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif AudioCore.EffectsVolume == 0.0:
				VisualsCore.DrawText(OptionsTextEffectsVol, "0% Volume", -75, 65+50-8-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			
			AudioCore.SetMusicAndEffectsVolume(AudioCore.MusicVolume, AudioCore.EffectsVolume)
		elif InterfaceCore.ThisArrowWasPressed(2.0) == true:
			if VisualsCore.FullScreenMode == true:
				VisualsCore.FullScreenMode = false
			else:  VisualsCore.FullScreenMode = true

			if (ScreensCore.OperatingSys == ScreensCore.OSAndroid):
				VisualsCore.FullScreenMode = true
			else:
				VisualsCore.SetFullScreenMode()

			if (VisualsCore.FullScreenMode == true):
				VisualsCore.DrawText(OptionsTextAspectRatio, "On", -75, 65+50+50-8-5-6, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif (VisualsCore.FullScreenMode == false):
				VisualsCore.DrawText(OptionsTextAspectRatio, "Off", -75, 65+50+50-8-5-6, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(2.5) == true:
			if VisualsCore.FullScreenMode == false:
				VisualsCore.FullScreenMode = true
			else:  VisualsCore.FullScreenMode = false

			if (ScreensCore.OperatingSys == ScreensCore.OSAndroid):
				VisualsCore.FullScreenMode = true
			else:
				VisualsCore.SetFullScreenMode()

			if (VisualsCore.FullScreenMode == true):
				VisualsCore.DrawText(OptionsTextAspectRatio, "On", -75, 65+50+50-8-5-6, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif (VisualsCore.FullScreenMode == false):
				VisualsCore.DrawText(OptionsTextAspectRatio, "Off", -75, 65+50+50-8-5-6, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		elif InterfaceCore.ThisArrowWasPressed(3.0) == true:
			if VisualsCore.KeepAspectRatio == 0:
				VisualsCore.KeepAspectRatio = 1
			else:  VisualsCore.KeepAspectRatio = 0

			if (VisualsCore.KeepAspectRatio == 0):
				VisualsCore.DrawText(OptionsTextCompPlayersSys, "Stretch & Fill Screen", -75, 65+50+50+50-8-5-6-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif (VisualsCore.KeepAspectRatio == 1):
				VisualsCore.DrawText(OptionsTextCompPlayersSys, "Keep Aspect Ratio", -75, 65+50+50+50-8-5-6-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.SetScreenStretchMode()

		elif InterfaceCore.ThisArrowWasPressed(3.5) == true:
			if VisualsCore.KeepAspectRatio == 0:
				VisualsCore.KeepAspectRatio = 1
			else:  VisualsCore.KeepAspectRatio = 0

			if (VisualsCore.KeepAspectRatio == 0):
				VisualsCore.DrawText(OptionsTextCompPlayersSys, "Stretch & Fill Screen", -75, 65+50+50+50-8-5-6-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif (VisualsCore.KeepAspectRatio == 1):
				VisualsCore.DrawText(OptionsTextCompPlayersSys, "Keep Aspect Ratio", -75, 65+50+50+50-8-5-6-5, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.SetScreenStretchMode()

		elif InterfaceCore.ThisArrowWasPressed(4.0) == true:
			if LogicCore.GameMode > 0:
				LogicCore.GameMode-=1
			else:  LogicCore.GameMode = 3
			
			if LogicCore.GameMode == LogicCore.ChildMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Child Mode", -75, 70+50+50+50+65-7-29, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TeenMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Teen Mode", -75, 70+50+50+50+65-7-29, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.AdultMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Adult Mode", -75, 70+50+50+50+65-7-29, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TurboMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Turbo Mode", -75, 70+50+50+50+65-7-29, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(4.5) == true:
			if LogicCore.GameMode < 3:
				LogicCore.GameMode+=1
			else:  LogicCore.GameMode = 0
			
			if LogicCore.GameMode == LogicCore.ChildMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Child Mode", -75, 70+50+50+50+65-7-29, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TeenMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Teen Mode", -75, 70+50+50+50+65-7-29, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.AdultMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Adult Mode", -75, 70+50+50+50+65-7-29, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.GameMode == LogicCore.TurboMode:
				VisualsCore.DrawText(OptionsTextGameMode, "Turbo Mode", -75, 70+50+50+50+65-7-29, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(5.0) == true:
			if LogicCore.AllowComputerPlayers > 0:
				LogicCore.AllowComputerPlayers-=1
			else:  LogicCore.AllowComputerPlayers = 2

			if (LogicCore.SecretCodeCombined != 2777 && LogicCore.AllowComputerPlayers == 2):  LogicCore.AllowComputerPlayers = 1

			if (LogicCore.DisableMultiplayer == 1):  LogicCore.AllowComputerPlayers = 0

			if LogicCore.AllowComputerPlayers == 2:
				VisualsCore.DrawText(OptionsTextCompPlayers, "[All Players Test Mode!] On", -75, 70+50+50+50+72, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.AllowComputerPlayers == 1:
				VisualsCore.DrawText(OptionsTextCompPlayers, "On", -75, 70+50+50+50+72, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.AllowComputerPlayers == 0:
				VisualsCore.DrawText(OptionsTextCompPlayers, "Off", -75, 70+50+50+50+72, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(5.5) == true:
			if LogicCore.AllowComputerPlayers < 2:
				LogicCore.AllowComputerPlayers+=1
			else:  LogicCore.AllowComputerPlayers = 0

			if (LogicCore.SecretCodeCombined != 2777 && LogicCore.AllowComputerPlayers == 2):  LogicCore.AllowComputerPlayers = 0

			if (LogicCore.DisableMultiplayer == 1):  LogicCore.AllowComputerPlayers = 0

			if LogicCore.AllowComputerPlayers == 2:
				VisualsCore.DrawText(OptionsTextCompPlayers, "[All Players Test Mode!] On", -75, 70+50+50+50+72, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.AllowComputerPlayers == 1:
				VisualsCore.DrawText(OptionsTextCompPlayers, "On", -75, 70+50+50+50+72, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif LogicCore.AllowComputerPlayers == 0:
				VisualsCore.DrawText(OptionsTextCompPlayers, "Off", -75, 70+50+50+50+72, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(6.0) == true:
			if  LogicCore.DisableMultiplayer == 0:
				LogicCore.DisableMultiplayer = 1
			else:   LogicCore.DisableMultiplayer = 0

			if ( LogicCore.DisableMultiplayer == 0):
				VisualsCore.DrawText(OptionsTextDisableMultiplayer, "False", -75, 70+50+50+50+65+50-14+65-14-7-30, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif ( LogicCore.DisableMultiplayer == 1):
				VisualsCore.DrawText(OptionsTextDisableMultiplayer, "True", -75, 70+50+50+50+65+50-14+65-14-7-30, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			if ( LogicCore.DisableMultiplayer == 1):
				LogicCore.AllowComputerPlayers = 0
				VisualsCore.DrawText(OptionsTextCompPlayers, "Off", -75, 70+50+50+50+72, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(6.5) == true:
			if  LogicCore.DisableMultiplayer == 0:
				LogicCore.DisableMultiplayer = 1
			else:   LogicCore.DisableMultiplayer = 0

			if ( LogicCore.DisableMultiplayer == 0):
				VisualsCore.DrawText(OptionsTextDisableMultiplayer, "False", -75, 70+50+50+50+65+50-14+65-14-7-30, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif ( LogicCore.DisableMultiplayer == 1):
				VisualsCore.DrawText(OptionsTextDisableMultiplayer, "True", -75, 70+50+50+50+65+50-14+65-14-7-30, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			if ( LogicCore.DisableMultiplayer == 1):
				LogicCore.AllowComputerPlayers = 0
				VisualsCore.DrawText(OptionsTextCompPlayers, "Off", -75, 70+50+50+50+72, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(7.0) == true:
			if LogicCore.SecretCode[0] > 0:
				LogicCore.SecretCode[0]-=1
			else:  LogicCore.SecretCode[0] = 9

			VisualsCore.DrawText(OptionsTextCodeOne, str(LogicCore.SecretCode[0]), -75, 70+50+65+50+50+70+37, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(7.5) == true:
			if LogicCore.SecretCode[0] < 9:
				LogicCore.SecretCode[0]+=1
			else:  LogicCore.SecretCode[0] = 0

			VisualsCore.DrawText(OptionsTextCodeOne, str(LogicCore.SecretCode[0]), -75, 70+50+65+50+50+70+37, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(8.0) == true:
			if LogicCore.SecretCode[1] > 0:
				LogicCore.SecretCode[1]-=1
			else:  LogicCore.SecretCode[1] = 9

			VisualsCore.DrawText(OptionsTextCodeTwo, str(LogicCore.SecretCode[1]), -75, 70+50+65+50+50+70+80, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(8.5) == true:
			if LogicCore.SecretCode[1] < 9:
				LogicCore.SecretCode[1]+=1
			else:  LogicCore.SecretCode[1] = 0

			VisualsCore.DrawText(OptionsTextCodeTwo, str(LogicCore.SecretCode[1]), -75, 70+50+65+50+50+70+80, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(9.0) == true:
			if LogicCore.SecretCode[2] > 0:
				LogicCore.SecretCode[2]-=1
			else:  LogicCore.SecretCode[2] = 9

			VisualsCore.DrawText(OptionsTextCodeThree, str(LogicCore.SecretCode[2]), -75, 70+50+65+50+50+70+80+45, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(9.5) == true:
			if LogicCore.SecretCode[2] < 9:
				LogicCore.SecretCode[2]+=1
			else:  LogicCore.SecretCode[2] = 0

			VisualsCore.DrawText(OptionsTextCodeThree, str(LogicCore.SecretCode[2]), -75, 70+50+65+50+50+70+80+45, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(10.0) == true:
			if LogicCore.SecretCode[3] > 0:
				LogicCore.SecretCode[3]-=1
			else:  LogicCore.SecretCode[3] = 9

			VisualsCore.DrawText(OptionsTextCodeFour, str(LogicCore.SecretCode[3]), -75, 70+50+65+50+50+70+80+45+45, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif InterfaceCore.ThisArrowWasPressed(10.5) == true:
			if LogicCore.SecretCode[3] < 9:
				LogicCore.SecretCode[3]+=1
			else:  LogicCore.SecretCode[3] = 0

			VisualsCore.DrawText(OptionsTextCodeFour, str(LogicCore.SecretCode[3]), -75, 70+50+65+50+50+70+80+45+45, 2, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		if (InterfaceCore.ThisButtonWasPressed(0) == true):
			ScreenToDisplayNext = TitleScreen
			ScreenFadeStatus = FadingToBlack

	LogicCore.SecretCodeCombined = (LogicCore.SecretCode[0]*1000)+(LogicCore.SecretCode[1]*100)+(LogicCore.SecretCode[2]*10)+(LogicCore.SecretCode[3]*1)
	if (LogicCore.SecretCodeCombined == 2777 || LogicCore.SecretCodeCombined == 8888 || LogicCore.SecretCodeCombined == 8889):
		VisualsCore.FramesPerSecondText.TextImage[0].global_position.x = 10
	else:
		VisualsCore.FramesPerSecondText.TextImage[0].global_position.x = -9999

	if (InputCore.MouseButtonRightPressed == true):
		ScreenFadeStatus = FadingToBlack
		ScreenFadeTransparency = 0.0
		ScreenToDisplayNext = TitleScreen
		AudioCore.PlayEffect(1, 1)
		InputCore.MouseButtonRightPressed = false

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		LogicCore.SecretCodeCombined = (LogicCore.SecretCode[0]*1000)+(LogicCore.SecretCode[1]*100)+(LogicCore.SecretCode[2]*10)+(LogicCore.SecretCode[3]*1)

	pass

#----------------------------------------------------------------------------------------
func DisplayHowToPlayScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
		VisualsCore.DrawSprite(10, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.5)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "H  O  W   T  O   P  L  A  Y:", 0, 12, 1, 22, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawSprite(30, VisualsCore.ScreenWidth/2.0, 30, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " ", 0, 0, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

		var yOffset = 0
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Pieces will fall from the top.", 0, 65+yOffset, 1, 57, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		yOffset += 70
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Move and rotate the falling pieces", 0, 65+yOffset, 1, 57, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		yOffset += 60
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "to create complete lines.", 0, 65+yOffset, 1, 57, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		yOffset += 60
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Complete lines will be cleared.", 0, 65+yOffset, 1, 57, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		yOffset += 70
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "When the boxes reach the top,", 0, 65+yOffset, 1, 57, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		yOffset += 60
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "the game will be over.", 0, 65+yOffset, 1, 57, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		yOffset += 70
		DemoTextIndex = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Do You Have The Skill", 0, 65+yOffset, 1, 57, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		yOffset += 60
		DemoTextIndex = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "To Cooperate & Win?", 0, 65+yOffset, 1, 57, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawSprite(32, VisualsCore.ScreenWidth/2.0, 583, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)
		InterfaceCore.CreateButton (6, (VisualsCore.ScreenWidth/2.0), VisualsCore.ScreenHeight-25.0)

	if InterfaceCore.ThisButtonWasPressed(0) == true:
		ScreenToDisplayNext = TitleScreen
		ScreenFadeStatus = FadingToBlack

	if (InputCore.MouseButtonRightPressed == true):
		ScreenFadeStatus = FadingToBlack
		ScreenFadeTransparency = 0.0
		ScreenToDisplayNext = TitleScreen
		AudioCore.PlayEffect(1, 1)
		InputCore.MouseButtonRightPressed = false

#	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
#		ScreenToDisplayNext = TitleScreen

	pass

#----------------------------------------------------------------------------------------
func DisplayHighScoresScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
		VisualsCore.DrawSprite(10, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.5)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "H  I  G  H    S  C  O  R  E  S:", 0, 12, 1, 22, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawSprite(30, VisualsCore.ScreenWidth/2.0, 30, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

		InterfaceCore.CreateArrowSet(0, 70)

		VisualsCore.DrawSprite(31, VisualsCore.ScreenWidth/2.0, 583, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

		if (LogicCore.SecretCodeCombined != 2777 && LogicCore.SecretCodeCombined != 8888):
			InterfaceCore.CreateButton (6, (VisualsCore.ScreenWidth/2.0), VisualsCore.ScreenHeight-25)
		else:
			InterfaceCore.CreateButton (6, (VisualsCore.ScreenWidth/2.0), VisualsCore.ScreenHeight-25)
			InterfaceCore.CreateButton (7, (VisualsCore.ScreenWidth/2.0), VisualsCore.ScreenHeight-25-67)
			InterfaceCore.ButtonSelectedByKeyboard = 1

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " ", 0, 0, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

		if LogicCore.GameMode == LogicCore.ChildMode:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Child Mode''", 0, 70, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif LogicCore.GameMode == LogicCore.TeenMode:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Teen Mode''", 0, 70, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif LogicCore.GameMode == LogicCore.AdultMode:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Adult Mode''", 0, 70, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		elif LogicCore.GameMode == LogicCore.TurboMode:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Turbo Mode''", 0, 70, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "NAME:", 55, 120, 0, 21, 1.0, 1.0, 0, 0.7, 0.7, 0.7, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "LEVEL:", 690, 120, 0, 21, 1.0, 1.0, 0, 0.7, 0.7, 0.7, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "SCORE:", 820, 120, 0, 21, 1.0, 1.0, 0, 0.7, 0.7, 0.7, 1.0, 0.0, 0.0, 0.0)
	
		var screenY = 154
		var blue
		for rank in range(0, 10):
			blue = 1.0
			if (LogicCore.Score[DataCore.PlayerWithHighestScore] == DataCore.HighScoreScore[LogicCore.GameMode][rank] and LogicCore.Level == DataCore.HighScoreLevel[LogicCore.GameMode][rank]):
				blue = 0
	
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(1+rank)+".", 15-4, screenY, 0, 25, 1.0, 1.0, 0, 1.0, blue, blue, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, DataCore.HighScoreName[LogicCore.GameMode][rank], 55, screenY, 0, 25, 1.0, 1.0, 0, 1.0, blue, blue, 1.0, 0.0, 0.0, 0.0)

			var level = int(DataCore.HighScoreLevel[LogicCore.GameMode][rank])
			if level < 10:
				VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(DataCore.HighScoreLevel[LogicCore.GameMode][rank]), 690, screenY, 0, 25, 1.0, 1.0, 0, 1.0, blue, blue, 1.0, 0.0, 0.0, 0.0)
			elif (LogicCore.GameMode == LogicCore.ChildMode || LogicCore.GameMode == LogicCore.TeenMode || LogicCore.GameMode == LogicCore.AdultMode || LogicCore.GameMode == LogicCore.TurboMode):
				VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "WON!", 690, screenY, 0, 25, 1.0, 1.0, 0, 1.0, blue, blue, 1.0, 0.0, 0.0, 0.0)
			else:
				VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(DataCore.HighScoreLevel[LogicCore.GameMode][rank]), 690, screenY, 0, 25, 1.0, 1.0, 0, 1.0, blue, blue, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(DataCore.HighScoreScore[LogicCore.GameMode][rank]), 820, screenY, 0, 25, 1.0, 1.0, 0, 1.0, blue, blue, 1.0, 0.0, 0.0, 0.0)

			screenY+=37

	if InterfaceCore.ThisArrowWasPressed(0) == true:
		if LogicCore.GameMode > 0:
			LogicCore.GameMode-=1
		else:  LogicCore.GameMode = 3
		
		ScreenToDisplayNext = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	elif InterfaceCore.ThisArrowWasPressed(0.5) == true:
		if LogicCore.GameMode < 3:
			LogicCore.GameMode+=1
		else:  LogicCore.GameMode = 0
		
		ScreenToDisplayNext = HighScoresScreen
		ScreenFadeStatus = FadingToBlack

	if InterfaceCore.ThisButtonWasPressed(1) == true:
		DataCore.ClearHighScores()
		ScreenToDisplayNext = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	elif InterfaceCore.ThisButtonWasPressed(0) == true:
		ScreenToDisplayNext = TitleScreen
		ScreenFadeStatus = FadingToBlack

	if (InputCore.MouseButtonRightPressed == true):
		ScreenFadeStatus = FadingToBlack
		ScreenFadeTransparency = 0.0
		ScreenToDisplayNext = TitleScreen
		AudioCore.PlayEffect(1, 1)
		InputCore.MouseButtonRightPressed = false

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		InputCore.DelayAllUserInput = 10

	pass

#----------------------------------------------------------------------------------------
func DisplayAboutScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))

		VisualsCore.SetFramesPerSecond(30)

		VisualsCore.LoadAboutScreenTexts()

		TS1ScreenY = (VisualsCore.Texts.TextImage[VisualsCore.AboutTextsEndIndex-1].global_position.y + 390+150)
		StaffScreenTSOneScale = 1.0

		if (LogicCore.GameWon == false):
			VisualsCore.DrawSprite(10, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.5)
		elif (LogicCore.GameWon == true):
			AudioCore.MusicPlayer.stop()

			videostream = VideoStreamTheora.new()
			videoplayer = VideoStreamPlayer.new()
			videostream.set_file("res://media/videos/WonGame.ogv")
			videoplayer.stream = videostream
			videoplayer.set_expand(true)
			videoplayer.set_size(Vector2(1024, 640), false)
			add_child(videoplayer)
			videoplayer.modulate = Color(1.0, 1.0, 1.0, 0.6)
			videoplayer.play()

		TSOneDisplayTimer = 125

	var textScrollSpeed = (1.32*1.8)
	if (LogicCore.GameWon == false):
		textScrollSpeed = (2.0*1.8)

	if (VisualsCore.Sprites.SpriteScreenY[23] > (VisualsCore.ScreenHeight/2.0)):
		for index in range(VisualsCore.AboutTextsStartIndex, VisualsCore.AboutTextsEndIndex):
			VisualsCore.Texts.TextImage[index].global_position.y-=textScrollSpeed
		TS1ScreenY-=textScrollSpeed

	if (LogicCore.GameWon == false):
		if (InputCore.JoystickDirection[0] == InputCore.JoyUp and TS1ScreenY > 320):
			for index in range(VisualsCore.AboutTextsStartIndex, VisualsCore.AboutTextsEndIndex):
				VisualsCore.Texts.TextImage[index].global_position.y-=20.0
			TS1ScreenY = TS1ScreenY - 20.0

	if VisualsCore.Texts.TextImage[VisualsCore.AboutTextsEndIndex-1].global_position.y != -99999: # BANDAID - FIX IT
		if (InputCore.DelayAllUserInput == -1 && (InputCore.MouseButtonLeftPressed == true || InputCore.KeyboardSpacebarPressed == true || InputCore.KeyboardEnterPressed == true || InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed)):
			ScreenFadeStatus = FadingToBlack
			
	if (InputCore.MouseButtonLeftPressed == true || InputCore.KeyboardSpacebarPressed == true || InputCore.KeyboardEnterPressed == true || InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed): 
		InputCore.DelayAllUserInput = 30
		ScreenFadeStatus = FadingToBlack
	elif (TS1ScreenY <= (VisualsCore.ScreenHeight/2.0)):
		if (TSOneDisplayTimer > 0):
			TSOneDisplayTimer-=1
		else:
			StaffScreenTSOneScale = StaffScreenTSOneScale - 0.01

			if (StaffScreenTSOneScale < 0):
				ScreenFadeStatus = FadingToBlack

				InputCore.DelayAllUserInput = 30

	VisualsCore.DrawSprite(23, VisualsCore.ScreenWidth/2.0, TS1ScreenY, StaffScreenTSOneScale, StaffScreenTSOneScale, 0, 1.0, 1.0, 1.0, 1.0)

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		if (LogicCore.GameWon == true && DataCore.NewHighScoreRank < 999):
			videoplayer.stop()
			videoplayer.free()

			AudioCore.PlayMusic(0, true)

			LogicCore.GameWon = false

			ScreenToDisplayNext = NewHighScoreScreen
		elif (LogicCore.GameWon == true):
			LogicCore.GameWon = false

			AudioCore.PlayMusic(0, true)

			videoplayer.stop()
			videoplayer.free()

			ScreenToDisplayNext = HighScoresScreen
		else:
			ScreenToDisplayNext = TitleScreen

	pass

#----------------------------------------------------------------------------------------
func DisplayMusicTestScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
		VisualsCore.DrawSprite(10, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.5)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "B . G . M .   M  U  S  I  C   T  E  S  T:", 0, 12, 1, 22, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawSprite(30, VisualsCore.ScreenWidth/2.0, 30, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " ", 0, 0, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

		var offset = 170-245
		var textOffset = 20

		InterfaceCore.CreateArrowSet( 0, (VisualsCore.ScreenHeight/4.0)+offset )
		if AudioCore.MusicCurrentlyPlaying == 0:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: Title", 0, (VisualsCore.ScreenHeight/4.0)+offset, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Fight To Win, Win For Love''", 0, 360+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "By:", 0, 420+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Suno.com A.I. Music", 0, 475+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
#			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "[Final]", 0, 530, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif AudioCore.MusicCurrentlyPlaying == 1:
			VisualsCore.DrawSprite(140+AudioCore.MusicCurrentlyPlaying, VisualsCore.ScreenWidth/2.0, 175+65, 0.45, 0.45, 0, 1.0, 1.0, 1.0, 1.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: InGame Level 1", 0, (VisualsCore.ScreenHeight/4.0)+offset, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Spirit''", 0, 360+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "By:", 0, 420+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Alexander Nakarada", 0, 475+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
#			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "[Final]", 0, 530, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif AudioCore.MusicCurrentlyPlaying == 2:
			VisualsCore.DrawSprite(140+AudioCore.MusicCurrentlyPlaying, VisualsCore.ScreenWidth/2.0, 175+65, 0.45, 0.45, 0, 1.0, 1.0, 1.0, 1.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: InGame Level 2", 0, (VisualsCore.ScreenHeight/4.0)+offset, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''You're Welcome[Instrumental]''", 0, 360+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "By:", 0, 420+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "RYYZN", 0, 475+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
#			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "[Final]", 0, 530, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif AudioCore.MusicCurrentlyPlaying == 3:
			VisualsCore.DrawSprite(140+AudioCore.MusicCurrentlyPlaying, VisualsCore.ScreenWidth/2.0, 175+65, 0.45, 0.45, 0, 1.0, 1.0, 1.0, 1.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: InGame Level 3", 0, (VisualsCore.ScreenHeight/4.0)+offset, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Voyage''", 0, 360+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "By:", 0, 420+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "LEMMiNO", 0, 475+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
#			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "[Final]", 0, 530, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif AudioCore.MusicCurrentlyPlaying == 4:
			VisualsCore.DrawSprite(140+AudioCore.MusicCurrentlyPlaying, VisualsCore.ScreenWidth/2.0, 175+65, 0.45, 0.45, 0, 1.0, 1.0, 1.0, 1.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: InGame Level 4", 0, (VisualsCore.ScreenHeight/4.0)+offset, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Deja Vu''", 0, 360+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "By:", 0, 420+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "RYYZN", 0, 475+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
#			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "[Final]", 0, 530, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif AudioCore.MusicCurrentlyPlaying == 5:
			VisualsCore.DrawSprite(140+AudioCore.MusicCurrentlyPlaying, VisualsCore.ScreenWidth/2.0, 175+65, 0.45, 0.45, 0, 1.0, 1.0, 1.0, 1.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: InGame Level 5", 0, (VisualsCore.ScreenHeight/4.0)+offset, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Dragon Slayer''", 0, 360+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "By:", 0, 420+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Makai Symphony", 0, 475+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
#			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "[Final]", 0, 530, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif AudioCore.MusicCurrentlyPlaying == 6:
			VisualsCore.DrawSprite(140+AudioCore.MusicCurrentlyPlaying, VisualsCore.ScreenWidth/2.0, 175+65, 0.45, 0.45, 0, 1.0, 1.0, 1.0, 1.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: InGame Level 6", 0, (VisualsCore.ScreenHeight/4.0)+offset, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Eyes_and_See''", 0, 360+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "By:", 0, 420+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "PEOPLE OF THE PARALLEL", 0, 475+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
#			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "[Final]", 0, 530, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif AudioCore.MusicCurrentlyPlaying == 7:
			VisualsCore.DrawSprite(140+AudioCore.MusicCurrentlyPlaying, VisualsCore.ScreenWidth/2.0, 175+65, 0.45, 0.45, 0, 1.0, 1.0, 1.0, 1.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: InGame Level 7", 0, (VisualsCore.ScreenHeight/4.0)+offset, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''My Heart Blows Up [Explosions]''", 0, 360+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "By:", 0, 420+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "ANTON LEUBA", 0, 475+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
#			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "[Final]", 0, 530, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif AudioCore.MusicCurrentlyPlaying == 8:
			VisualsCore.DrawSprite(140+AudioCore.MusicCurrentlyPlaying, VisualsCore.ScreenWidth/2.0, 175+65, 0.45, 0.45, 0, 1.0, 1.0, 1.0, 1.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: InGame Level 8", 0, (VisualsCore.ScreenHeight/4.0)+offset, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Absolution''", 0, 360+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "By:", 0, 420+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Scott Buckley", 0, 475+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
#			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "[Final]", 0, 530, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif AudioCore.MusicCurrentlyPlaying == 9:
			VisualsCore.DrawSprite(140+AudioCore.MusicCurrentlyPlaying, VisualsCore.ScreenWidth/2.0, 175+65, 0.45, 0.45, 0, 1.0, 1.0, 1.0, 1.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: InGame Level 9", 0, (VisualsCore.ScreenHeight/4.0)+offset, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Warrior''", 0, 360+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "By:", 0, 420+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "yoitrax", 0, 475+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
#			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "[Final]", 0, 530, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif AudioCore.MusicCurrentlyPlaying == 10:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "BGM: Won", 0, (VisualsCore.ScreenHeight/4.0)+offset, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''UPBEAT 2''", 0, 360+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "By:", 0, 420+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Aries Beats", 0, 475+textOffset, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawSprite(31, VisualsCore.ScreenWidth/2.0, 583, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)
		InterfaceCore.CreateButton (6, (VisualsCore.ScreenWidth/2.0), VisualsCore.ScreenHeight-25.0)

	for alphaFix in range(0, 10):
		VisualsCore.Sprites.SpriteColorAlpha[140+alphaFix] = 1.0
		RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[141+alphaFix], Color(1.0, 1.0, 1.0, VisualsCore.Sprites.SpriteColorAlpha[141+alphaFix]))
		RenderingServer.canvas_item_set_draw_index(VisualsCore.Sprites.ci_rid[141+alphaFix], 0)

	if InterfaceCore.ThisArrowWasPressed(0.0):
		if AudioCore.MusicCurrentlyPlaying > 0:
			AudioCore.MusicCurrentlyPlaying-=1
			AudioCore.PlayMusic(AudioCore.MusicCurrentlyPlaying, true)
		else:
			AudioCore.MusicCurrentlyPlaying = (AudioCore.MusicTotal - 1 -2)
			AudioCore.PlayMusic(AudioCore.MusicCurrentlyPlaying, true)

		ScreenToDisplayNext = MusicTestScreen
		ScreenFadeStatus = FadingToBlack
	elif InterfaceCore.ThisArrowWasPressed(0.5):
		if AudioCore.MusicCurrentlyPlaying < (AudioCore.MusicTotal - 1 -2):
			AudioCore.MusicCurrentlyPlaying+=1
			AudioCore.PlayMusic(AudioCore.MusicCurrentlyPlaying, true)
		else:
			AudioCore.MusicCurrentlyPlaying = 0
			AudioCore.PlayMusic(AudioCore.MusicCurrentlyPlaying, true)

		ScreenToDisplayNext = MusicTestScreen
		ScreenFadeStatus = FadingToBlack

	if InterfaceCore.ThisButtonWasPressed(0) == true:
		ScreenToDisplayNext = TitleScreen
		ScreenFadeStatus = FadingToBlack

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		if ScreenToDisplayNext == TitleScreen:  AudioCore.PlayMusic(0, true)

		for alphaFix in range(0, 10):
			RenderingServer.canvas_item_set_draw_index(VisualsCore.Sprites.ci_rid[141+alphaFix], -5)

	pass

#----------------------------------------------------------------------------------------
func DisplayCutSceneScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Act "+str(LogicCore.Level), 0, 35, 1, 60, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		CutSceneTextScale[0] = 1.0
		CutSceneTextScale[1] = 1.0
		CutSceneTextScale[2] = 1.0
		CutSceneTextScale[3] = 1.0
		CutSceneTextScale[4] = 1.0
		CutSceneTextScale[5] = 1.0
		CutSceneTextScale[6] = 1.0
		CutSceneTextScaleIndex = 0

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " ", 0, 0, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

		if (LogicCore.Level == 1 && CutSceneSceneTotal[1] == 1):
			VisualsCore.DrawSprite(150, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "It is the day of the Grand Royal Party,", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "where a proper suiter will be choosen", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "for the kingdom's Princess.", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "All Princes near and far, have come to", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "this special occasion for a chance", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "to win her heart...", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " ", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.Level == 2 && CutSceneScene == 1):
			VisualsCore.DrawSprite(151, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "As you approach the castle entrance,", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "your heart beats uncontrollably.", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Having only your heart & love to offer", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "the young, beautiful Princess, you", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "start to wonder if you have any chance", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "at all, conscidering that there are much", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "richer Princes, both ahead and behind.", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.Level == 2 && CutSceneScene == 2):
			VisualsCore.DrawSprite(152, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Your turn has come up, and you approach", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "the Queen & her daughter, the Princess.", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Upon first look of each other,", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "something magical happens between you &", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "the Princess...", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.Level == 3 && CutSceneScene == 1):
			VisualsCore.DrawSprite(153, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Kneeling before the Queen & the Princess", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "you are overwhelmed by her brilliance.", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Seeing that her daughter approves,", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "the Queen offers you a challenge.", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Seek the red rose", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "in the cave of no return''...", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.Level == 3 && CutSceneScene == 2):
			VisualsCore.DrawSprite(154, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "The Princess, in fear of never seeing", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "you again, gives you a kiss for luck.", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "A fire begins to burn within your heart", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "And you leave the castle to get the", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "red rose, to win the heart", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "of the Princess...", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.Level == 4 && CutSceneScene == 1):
			VisualsCore.DrawSprite(155, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "You are at the entrance to the cave.", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "An overwhelming sense of fear overcomes", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "you as you stare deep into the", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "cave's darkness.", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "You think of the Princess' kiss, & gain", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "the courage to enter the cave...", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.Level == 5 && CutSceneScene == 1):
			VisualsCore.DrawSprite(156, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "You are confronted by a dragon.", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "The dragon looks you in the eye & speaks", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Many have entered this cave,", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "none have left alive''...", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.Level == 5 && CutSceneScene == 2):
			VisualsCore.DrawSprite(156, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "You are different then them, though.", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "You entered this cave with a strong", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "heart, as you did not draw your sword.", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "You are worthy of thy rose,", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " I hope she likes it...", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "You leave the cave with the rose!", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.Level == 5 && CutSceneScene == 3):
			VisualsCore.DrawSprite(157, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "You goto the beach, where you are to", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "meet the Princess before sunset.", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "But, The Dark Prince stands before you", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "and the woman you love...", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "You drop the rose, and draw your sword", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "in a fight to death...", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.Level == 6 && CutSceneScene == 1):
			VisualsCore.DrawSprite(158, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Waiting at the shore, the Princess", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "stares off into the darkening shadows", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "of the beach's sand.", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "She thinks to herself:", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''Will my Prince ever return", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "in time?''", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.Level == 6 && CutSceneScene == 2):
			VisualsCore.DrawSprite(159, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "The battle for love wages on...", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "With swords locked, The Dark Prince", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "speaks:", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "''The Princess is mine!", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "The Queen choose me; because", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "I am the richest!''", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.Level == 6 && CutSceneScene == 3):
			VisualsCore.DrawSprite(159, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "With the sun setting in the distance,", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "the sounds of metal hitting metal", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "continue...", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "You defend yourself against each strike,", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "and realize that only one will walk away", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "alive...", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.Level == 6 && CutSceneScene == 4):
			VisualsCore.DrawSprite(159, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Knowing the Princess loves you,", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "you gather all your remaining strength", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "and strike a fatal blow", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "to The Dark Prince...", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "If he had a heart,", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "your sword would have went", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "straight through it...", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.Level == 7 && CutSceneScene == 1):
			VisualsCore.DrawSprite(160, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "You stare off into the distance...", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "The scenery, although quite beautiful,", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "doesn't help the way you feel one bit.", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Your too late.", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "The Princess is gone.", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "You drop your sword & fall to your knees.", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.Level == 8 && CutSceneScene == 1):
			VisualsCore.DrawSprite(161, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "The Princess, now far away at sea,", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "stares at the beach she just left...", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "She starts to think that perhaps", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "she should ahve waited longer...", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "As she looks into the distance,", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "she notices something sparkle...", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.Level == 8 && CutSceneScene == 2):
			VisualsCore.DrawSprite(162, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Feeling something deep within her heart,", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "the Princess jumps overboard...", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "The tide is deadly,", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "but she uses all her strength", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "to swim to the shore...", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.Level == 8 && CutSceneScene == 3):
			VisualsCore.DrawSprite(163, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "The Princess reaches the shore, alive.", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Her heart beating faster then its ever,", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "She is greeted with a deserted beach.", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "All that remains of her Prince, are", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "his footprints leading into the sunset,", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "& the Rose he fought so hard to get her.", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.Level == 9 && CutSceneScene == 1):
			VisualsCore.DrawSprite(164, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)-137, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			CutSceneTextIndex[0] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "With her remaining strength,", 0, 300, 1, 35, CutSceneTextScale[0], CutSceneTextScale[0], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[1] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "the Princess follows", 0, 300+(1*47), 1, 35, CutSceneTextScale[1], CutSceneTextScale[1], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[2] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "her Prince's footsteps...", 0, 300+(2*47), 1, 35, CutSceneTextScale[2], CutSceneTextScale[2], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[3] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Clenching tightly to her rose,", 0, 300+(3*47), 1, 35, CutSceneTextScale[3], CutSceneTextScale[3], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[4] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "she follows her heart...", 0, 300+(4*47), 1, 35, CutSceneTextScale[4], CutSceneTextScale[4], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[5] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(5*47), 1, 35, CutSceneTextScale[5], CutSceneTextScale[5], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			CutSceneTextIndex[6] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "", 0, 300+(6*47), 1, 35, CutSceneTextScale[6], CutSceneTextScale[6], 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		ScreenDisplayTimer = (70*4)
		if (LogicCore.AllowComputerPlayers == 2):  ScreenDisplayTimer = 5

		InputCore.DelayAllUserInput = 30

	if (LogicCore.Level < 10):
		if (ScreenDisplayTimer > 1):
			ScreenDisplayTimer-=1
		elif ScreenDisplayTimer == 1:
			if (CutSceneScene < CutSceneSceneTotal[LogicCore.Level]):
				CutSceneScene+=1
				ScreenDisplayTimer = (110*2)
				ScreenToDisplayNext = CutSceneScreen
				ScreenFadeStatus = FadingToBlack
			else:
				ScreenToDisplayNext = PlayingGameScreen
				ScreenFadeStatus = FadingToBlack
				ScreenDisplayTimer = -1

		if (InputCore.DelayAllUserInput == -1 && (InputCore.MouseButtonLeftPressed == true || InputCore.KeyboardSpacebarPressed == true || InputCore.KeyboardEnterPressed == true || InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed)) && ScreenDisplayTimer > 1:
			ScreenDisplayTimer = 1
			AudioCore.PlayEffect(1, 1)
			InputCore.DelayAllUserInput = 25
	else:
		LogicCore.SetupForNewLevel()
		ScreenToDisplayNext = PlayingGameScreen
		ScreenFadeStatus = FadingToBlack

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		InputCore.DelayAllUserInput = 15
		LogicCore.SetupForNewLevel()
		if ScreensCore.OperatingSys == ScreensCore.OSAndroid:
			InputCore.InputThatStartedNewGame = InputCore.InputTouchOne
			LogicCore.PlayerInput[1] = InputCore.InputTouchOne

	pass

#----------------------------------------------------------------------------------------
func DisplayNoCPUScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
		VisualsCore.DrawSprite(10, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.5)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "H  O  W   T  O   P  L  A  Y:", 0, 12, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawSprite(30, VisualsCore.ScreenWidth/2.0, 30, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " ", 0, 0, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "In this game mode,", 0, 20+30, 1, 57, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "there are no computer A.I. players.", 0, 20+30+45, 1, 57, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Human players must play all game playfields.", 0, 20+30+45+75, 1, 57, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Keyboard & joystick players must press [UP]", 0, 20+30+45+75+45+45, 1, 57, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "to change their active game playfield.", 0, 20+30+45+75+45+45+45, 1, 57, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Mouse & touch players must press", 0, 20+30+45+75+45+45+45+75, 1, 57, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "[Switch Playfield] icon on screen", 0, 20+30+45+75+45+45+45+75+45, 1, 57, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "to change their active game playfield.", 0, 20+30+45+75+45+45+45+75+45+45, 1, 57, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawSprite(32, VisualsCore.ScreenWidth/2.0, 583, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)
		InterfaceCore.CreateButton (0, (VisualsCore.ScreenWidth/2.0), VisualsCore.ScreenHeight-25.0)

	if InterfaceCore.ThisButtonWasPressed(0) == true:
		ScreenToDisplayNext = CutSceneScreen
		AudioCore.PlayMusic(1, true)
		ScreenFadeStatus = FadingToBlack

#	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
#		ScreenToDisplayNext = TitleScreen

	pass

#----------------------------------------------------------------------------------------
func DisplayPlayingGameScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		if LogicCore.GameMode == LogicCore.ChildMode:
			VisualsCore.SetFramesPerSecond(fps[0])
		elif LogicCore.GameMode == LogicCore.TeenMode:
			VisualsCore.SetFramesPerSecond(fps[1])
		elif LogicCore.GameMode == LogicCore.AdultMode:
			VisualsCore.SetFramesPerSecond(fps[2])
		elif LogicCore.GameMode == LogicCore.TurboMode:
			VisualsCore.SetFramesPerSecond(fps[3])

		if (LogicCore.SecretCodeCombined == 8888 or LogicCore.SecretCodeCombined == 8889):
			VisualsCore.SetFramesPerSecond(999999) # SHOW MAXIMUM FRAMES PER SECOND ON THIS PLATFORM
		elif (LogicCore.SecretCodeCombined == 2776):
			VisualsCore.SetFramesPerSecond(5)
		elif (LogicCore.SecretCodeCombined == 2779 or LogicCore.SecretCodeCombined == 2772):
			VisualsCore.SetFramesPerSecond(999)
		elif (LogicCore.SecretCodeCombined == 2771):
			VisualsCore.SetFramesPerSecond(5)
		elif (LogicCore.SecretCodeCombined == 2777 and LogicCore.GameMode == LogicCore.TurboMode):
			VisualsCore.SetFramesPerSecond(999999)

		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))

		VisualsCore.DrawSprite(131, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0), 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

		VisualsCore.DrawSprite(132, (VisualsCore.ScreenWidth/2.0)-130, (VisualsCore.ScreenHeight/2.0)+25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		VisualsCore.DrawSprite(134, (VisualsCore.ScreenWidth/2.0)+130, (VisualsCore.ScreenHeight/2.0)+25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

		VisualsCore.DrawSprite(135, (VisualsCore.ScreenWidth/2.0)-9999, (VisualsCore.ScreenHeight/2.0)-9999, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.75)

		var width = VisualsCore.Sprites.SpriteImageWidth[131]
		var height = VisualsCore.Sprites.SpriteImageHeight[131]
		RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[131], Transform2D(0.0, Vector2(1.0, 1.0), 0.0, Vector2(VisualsCore.Sprites.SpriteScreenX[131]-(width/2), VisualsCore.Sprites.SpriteScreenY[131]-(height/2))))#x - (sprite_size.x / 2.0), y - (sprite_size.y / 2.0))))

		VisualsCore.DrawSprite(130, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0), 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		RenderingServer.canvas_item_set_draw_index(VisualsCore.Sprites.ci_rid[130], -1)
		
		VisualsCore.DrawSprite(140+LogicCore.Level, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)+27, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.6)
		RenderingServer.canvas_item_set_draw_index(VisualsCore.Sprites.ci_rid[140+LogicCore.Level], -1000)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " ", 0, 0, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

		LogicCore.ScoreOneText = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(LogicCore.Score[0]), (VisualsCore.ScreenWidth/2.0)-260, 12, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		LogicCore.ScoreTwoText = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(LogicCore.Score[1]), VisualsCore.ScreenWidth/2.0, 12, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		LogicCore.ScoreThreeText = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(LogicCore.Score[2]), (VisualsCore.ScreenWidth/2.0)+260, 12, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		if (LogicCore.SecretCodeCombined != 6161):
			InputNameOne = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " ", (VisualsCore.ScreenWidth/2.0)-260, 12, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InputNameTwo = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " ", VisualsCore.ScreenWidth/2.0, 12, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InputNameThree = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " ", (VisualsCore.ScreenWidth/2.0)+260, 12, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		else:
			InputNameOne = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "C.P.U.", (VisualsCore.ScreenWidth/2.0)-260, VisualsCore.ScreenHeight-19, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InputNameTwo = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Touch 1", VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight-19, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			InputNameThree = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "Touch 2", (VisualsCore.ScreenWidth/2.0)+260, VisualsCore.ScreenHeight-19, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		if (LogicCore.SecretCodeCombined == 8889):
			if (LogicCore.ComputerPlayersTotalGamesPlayed > 0):
				var temp = floor( (LogicCore.ComputerPlayersTotalLevelClears / LogicCore.ComputerPlayersTotalGamesPlayed) * 100.0 )

				print("Level Clears="+str(LogicCore.ComputerPlayersTotalLevelClears)+" /Games Played="+str(LogicCore.ComputerPlayersTotalGamesPlayed)+" /Average Success Rate="+str(temp)+"%")

				VisualsCore.DrawText(VisualsCore.TextCurrentIndex, str(temp)+"%", 0, VisualsCore.ScreenHeight/2.0, 1, 113, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			else:
				VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "100%", 0, VisualsCore.ScreenHeight/2.0, 1, 113, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		for indexStart in range(10000, 17000, 1000):
			for index in range (0, 624):
				VisualsCore.DrawSprite(indexStart+index, -9999, -9999, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

		var maxIndex = (4*3*2)
		for indexStart in range(19000, 19800, 100):
			for index in range (0, maxIndex):
				VisualsCore.DrawSprite(indexStart+index, -9999, -9999, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
				if (indexStart == 19700):
					RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[index], Color(1.0, 1.0, 1.0, 0.5))
				else:
					RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[index], Color(1.0, 1.0, 1.0, 1.0))

				RenderingServer.canvas_item_set_draw_index(VisualsCore.Sprites.ci_rid[indexStart+index], 100)

		InterfaceCore.CreateIcon(117, VisualsCore.ScreenWidth-34, VisualsCore.ScreenHeight-34, " ")

		if (OperatingSys != OSAndroid and LogicCore.SecretCodeCombined != 6161):
			InterfaceCore.CreateIcon( 105, 34+99999, VisualsCore.ScreenHeight-34, " " )

		if (OperatingSys == OSAndroid or LogicCore.SecretCodeCombined == 6161):
			InterfaceCore.CreateIcon( 105, 34, VisualsCore.ScreenHeight-34, " " )

		if ( OperatingSys == OSHTMLFive and LogicCore.PlayerInput[1] == InputCore.InputTouchTwo):
			InterfaceCore.CreateIcon(119, VisualsCore.ScreenWidth-59+999999, 147+90+92+93, " ")
		elif (LogicCore.DisableMultiplayer == 0):
			InterfaceCore.CreateIcon(119, VisualsCore.ScreenWidth-59, 147+90+92+93, " ")

		var yOffset = 0
		if (LogicCore.AllowComputerPlayers > 0):  yOffset = 999999

		if (OperatingSys == OSAndroid):# or LogicCore.SecretCodeCombined == 6161):
			InterfaceCore.CreateIcon( 120, 30, 147, " " )
			InterfaceCore.CreateIcon( 121, 30+57, 147, " " )
			InterfaceCore.CreateIcon( 122, 59, 147+90, " " )
			InterfaceCore.CreateIcon( 123, 59, 147+90+92, " " )
			if (LogicCore.DisableMultiplayer == 0):
				InterfaceCore.CreateIcon( 101, 59, 147-100+yOffset, " " )
				if (LogicCore.SecretCodeCombined == 6161):  InterfaceCore.Icons.IconScreenX[7] = -9999

				InterfaceCore.CreateIcon( 125, VisualsCore.ScreenWidth-30-57, 147, " " )
				InterfaceCore.CreateIcon( 126, VisualsCore.ScreenWidth-30, 147, " " )
				InterfaceCore.CreateIcon( 127, VisualsCore.ScreenWidth-59, 147+90, " " )
				InterfaceCore.CreateIcon( 128, VisualsCore.ScreenWidth-59, 147+90+92, " " )
				InterfaceCore.CreateIcon( 102, VisualsCore.ScreenWidth-59, 147-100+yOffset, " " )
				if (LogicCore.SecretCodeCombined == 6161):  InterfaceCore.Icons.IconScreenX[12] = -9999
		else:
			if (LogicCore.DisableMultiplayer == 0):
				InterfaceCore.CreateIcon( 120, VisualsCore.ScreenWidth-30-57, 147, " " )
				InterfaceCore.CreateIcon( 121, VisualsCore.ScreenWidth-30, 147, " " )
				InterfaceCore.CreateIcon( 122, VisualsCore.ScreenWidth-59, 147+90, " " )
				InterfaceCore.CreateIcon( 123, VisualsCore.ScreenWidth-59, 147+90+92, " " )
				InterfaceCore.CreateIcon( 102, VisualsCore.ScreenWidth-59, 147-100+yOffset, " " )

		if ( OperatingSys == OSHTMLFive and LogicCore.PlayerInput[1] == InputCore.InputTouchTwo):
			LogicCore.PlayerInput[1] = InputCore.InputTouchOne
			if (LogicCore.AllowComputerPlayers > 0):
				LogicCore.PlayersCanJoinIn = false
				LogicCore.PlayerInput[0] = InputCore.InputCPU
				LogicCore.PlayerInput[2] = InputCore.InputCPU
				LogicCore.PlayerStatus[0] = LogicCore.NewPieceDropping
				LogicCore.PlayerStatus[2] = LogicCore.NewPieceDropping
			elif (LogicCore.AllowComputerPlayers == 0):
				LogicCore.PlayersCanJoinIn = false
				LogicCore.PlayerInput[0] = InputCore.InputNone
				LogicCore.PlayerInput[2] = InputCore.InputNone
				LogicCore.PlayerStatus[0] = LogicCore.NewPieceDropping
				LogicCore.PlayerStatus[2] = LogicCore.NewPieceDropping

		if (LogicCore.DisableMultiplayer == 1):
			LogicCore.PlayersCanJoinIn = false
			LogicCore.PlayerInput[0] = InputCore.InputNone
			LogicCore.PlayerInput[2] = InputCore.InputNone
			LogicCore.PlayerStatus[0] = LogicCore.GameOver
			LogicCore.PlayerStatus[2] = LogicCore.GameOver

		if LogicCore.SecretCodeCombined == 8888 || LogicCore.SecretCodeCombined == 8889:
			VisualsCore.SetFramesPerSecond(999999)

		VisualsCore.DrawSprite(137, (VisualsCore.ScreenWidth/2.0)-260, (VisualsCore.ScreenHeight/2.0)+30, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		VisualsCore.DrawSprite(138, (VisualsCore.ScreenWidth/2.0)+260, (VisualsCore.ScreenHeight/2.0)+30, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		JoinInFlash = 0

		if (LogicCore.AllowComputerPlayers == 2):
			LogicCore.PlayerStatus[0] = LogicCore.NewPieceDropping
			LogicCore.PlayerStatus[1] = LogicCore.NewPieceDropping
			LogicCore.PlayerStatus[2] = LogicCore.NewPieceDropping
			LogicCore.PlayerInput[0] = InputCore.InputCPU
			LogicCore.PlayerInput[1] = InputCore.InputCPU
			LogicCore.PlayerInput[2] = InputCore.InputCPU

	if (LogicCore.PlayersCanJoinIn == true and LogicCore.PAUSEgame == false):
		JoinInFlash+=1

		if (JoinInFlash == 15):
			if (LogicCore.PlayerInput[0] == InputCore.InputNone && InputCore.ThereAreGamepads == true):  VisualsCore.DrawSprite(137, (VisualsCore.ScreenWidth/2.0)-260, (VisualsCore.ScreenHeight/2.0)+30, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.0)
			if (LogicCore.PlayerInput[2] == InputCore.InputNone):  VisualsCore.DrawSprite(138, (VisualsCore.ScreenWidth/2.0)+260, (VisualsCore.ScreenHeight/2.0)+30, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.0)
		elif (JoinInFlash > 15+5):
			if (LogicCore.PlayerInput[0] == InputCore.InputNone && OperatingSys != OSAndroid):  VisualsCore.DrawSprite(137, (VisualsCore.ScreenWidth/2.0)-260, (VisualsCore.ScreenHeight/2.0)+30, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
			if (LogicCore.PlayerInput[2] == InputCore.InputNone):  VisualsCore.DrawSprite(138, (VisualsCore.ScreenWidth/2.0)+260, (VisualsCore.ScreenHeight/2.0)+30, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			JoinInFlash = 0

	#if (LogicCore.SecretCodeCombined == 6161):
		#LogicCore.PlayerInput[0] = InputCore.InputJoyOne
		#LogicCore.PlayerInput[1] = InputCore.InputKeyboard
		#LogicCore.PlayerInput[2] = InputCore.InputMouse

	if (LogicCore.PlayersCanJoinIn == false && LogicCore.PlayerStatus[2] != LogicCore.GameOver && DontDisplayJoinIn == false):  DontDisplayJoinIn = true

	LogicCore.RunPuzzleGameCore()

	if (LogicCore.PAUSEgame == false and LogicCore.PauseWasJustPressed == true):
		if (OperatingSys != OSAndroid):
			VisualsCore.DrawSprite(135, (VisualsCore.ScreenWidth/2.0)-9999, (VisualsCore.ScreenHeight/2.0)-9999, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		elif (OperatingSys == OSAndroid):
			VisualsCore.DrawSprite(136, (VisualsCore.ScreenWidth/2.0)-9999, (VisualsCore.ScreenHeight/2.0)-9999, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
		LogicCore.PauseWasJustPressed = false
	if (LogicCore.PAUSEgame == true and LogicCore.PauseWasJustPressed == true):
		if (LogicCore.SecretCodeCombined != 2778 && LogicCore.SecretCodeCombined != 2777):
			if (OperatingSys != OSAndroid):
				VisualsCore.DrawSprite(135, (VisualsCore.ScreenWidth/2.0), (VisualsCore.ScreenHeight/2.0), 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.85)
			elif (OperatingSys == OSAndroid):
				VisualsCore.DrawSprite(136, (VisualsCore.ScreenWidth/2.0), (VisualsCore.ScreenHeight/2.0), 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.85)

		LogicCore.PauseWasJustPressed = false

	if (OperatingSys == OSAndroid and LogicCore.PAUSEgame == true and InputCore.DelayAllUserInput == -1):
		for indexTouch in range(0,5):
			if (InputCore.AndroidTouchOnePressed[indexTouch] == true):
				LogicCore.PAUSEgame = false
				VisualsCore.DrawSprite(136, (VisualsCore.ScreenWidth/2.0)-9999, (VisualsCore.ScreenHeight/2.0)-9999, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

				InterfaceCore.Icons.IconScreenX[1] = 34

				AudioCore.MusicVolume = InputCore.OldMusicVolume
				if (AudioCore.MusicVolume > 0.0):  AudioCore.MusicPlayer.set_volume_db(AudioCore.ConvertLinearToDB(AudioCore.MusicVolume))

				InputCore.DelayAllUserInput = 20

	LogicCore.AddToPlayfieldAllPlayerPiecesAndDropShadows()

	var boxSizeHalf = (VisualsCore.Sprites.SpriteImageWidth[10000] / 2)

	for index in range (0, 9):
		VisualsCore.PlayfieldSpriteCurrentIndex[index] = 0
#	LogicCore.DrawEverything = 1
	if (LogicCore.DrawEverything > 0): # DRAW EVERYTHING
		LogicCore.PieceMoved = -1
		LogicCore.DrawEverything-=1

		var pos = Vector2(-9999, -9999)
		for indexStart in range(10000, 18000, 1000):
			for index in range (0, 624):
				if (VisualsCore.Sprites.SpriteActive[indexStart+index] == true):
					RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[indexStart+index], Transform2D().translated(pos))

		var maxIndex = (4*3*4)
		for indexStart in range(19000, 19800, 100):
			for index in range (0, maxIndex):
				RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[indexStart+index], Transform2D().translated(pos))

		for index in range (0, 9):
			VisualsCore.PieceSpriteCurrentIndex[index] = 0

		if (LogicCore.PlayfieldsAlphaDir == 0):
			LogicCore.PlayfieldsAlpha-=0.05
			if (LogicCore.PlayfieldsAlpha < 0.0):
				LogicCore.PlayfieldsAlpha = 0.0
				LogicCore.PlayfieldsAlphaDir = 1
		elif (LogicCore.PlayfieldsAlphaDir == 1):
			LogicCore.PlayfieldsAlpha+=0.05
			if (LogicCore.PlayfieldsAlpha > 1.0):
				LogicCore.PlayfieldsAlpha = 1.0
				LogicCore.PlayfieldsAlphaDir = 0

		LogicCore.PlayfieldsAlpha = 1.0

		var screenX = 135
		var screenY = -5
		var startBoxIndex = 10000
		var adjustedBox
		for y in range(0, 24):
			for p in range(3):
				for x in range(2, 12):
					if (LogicCore.PlayfieldNew[p][x][y] > 10 && LogicCore.PlayfieldNew[p][x][y] < 20): # Next Piece
						adjustedBox = LogicCore.PlayfieldNew[p][x][y]
						adjustedBox-=10
						startBoxIndex = 10000 + ( (adjustedBox-1)*1000 )

						RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[startBoxIndex+VisualsCore.PlayfieldSpriteCurrentIndex[adjustedBox]], Transform2D().translated(Vector2(screenX-(boxSizeHalf), screenY-(boxSizeHalf))))

						VisualsCore.PlayfieldSpriteCurrentIndex[adjustedBox]+=1
					elif (LogicCore.PlayfieldNew[p][x][y] > 30 && LogicCore.PlayfieldNew[p][x][y] < 40): # Fallen Colored Box Pieces In Playfield
						adjustedBox = LogicCore.PlayfieldNew[p][x][y]
						adjustedBox-=30
						startBoxIndex = 10000 + ( (adjustedBox-1)*1000 )

						RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[startBoxIndex+VisualsCore.PlayfieldSpriteCurrentIndex[adjustedBox]], Transform2D().translated(Vector2(screenX-(boxSizeHalf), screenY-(boxSizeHalf))))
						RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[startBoxIndex+VisualsCore.PlayfieldSpriteCurrentIndex[adjustedBox]], Color(1.0, 1.0, 1.0, LogicCore.PlayfieldsAlpha))
						VisualsCore.PlayfieldSpriteCurrentIndex[adjustedBox]+=1
					elif (LogicCore.PlayfieldNew[p][x][y] > 99998): # Flashing White Completed Line(s)
						RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[17000+VisualsCore.PlayfieldSpriteCurrentIndex[8]], Transform2D().translated(Vector2(screenX-(boxSizeHalf), screenY-(boxSizeHalf))))
						VisualsCore.PlayfieldSpriteCurrentIndex[8]+=1

					screenX+=26

			screenX = 135
			screenY+=26

	LogicCore.PieceMoved = 1
	if (LogicCore.PieceMoved > 0): # DRAW CURRENT FALLING PIECE(S) WITH DROP SHADOW(S)
		LogicCore.PieceMoved-=1

		for index in range (0, 9):
			VisualsCore.PieceSpriteCurrentIndex[index] = 0

		var pos = Vector2(-9999, -9999)
		var maxIndex = (4*3*4)
		for indexStart in range(19000, 19800, 100):
			for index in range (0, maxIndex):
				RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[indexStart+index], Transform2D().translated(pos))

		var screenX = 135
		var screenY = -5
		var startBoxIndex = 10000
		var adjustedBox
		for y in range(0, 24):
			for p in range(3):
				for x in range(2, 12):
					if (LogicCore.PlayfieldNew[p][x][y] > 1000 && LogicCore.PlayfieldNew[p][x][y] < 1010): # Falling Piece
						adjustedBox = LogicCore.PlayfieldNew[p][x][y]
						adjustedBox-=1000
						startBoxIndex = 19000 + ( (adjustedBox-1)*100 )
						RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[startBoxIndex+VisualsCore.PieceSpriteCurrentIndex[adjustedBox]], Transform2D().translated(Vector2(screenX-(boxSizeHalf), screenY-(boxSizeHalf))))
						VisualsCore.PieceSpriteCurrentIndex[adjustedBox]+=1
					elif (LogicCore.PlayfieldNew[p][x][y] == 2000): # Drop Shadow
						RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[19700+VisualsCore.PieceSpriteCurrentIndex[8]], Transform2D().translated(Vector2(screenX-(boxSizeHalf), screenY-(boxSizeHalf))))
						RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[19700+VisualsCore.PieceSpriteCurrentIndex[8]], Color(1.0, 1.0, 1.0, 0.5))
						VisualsCore.PieceSpriteCurrentIndex[8]+=1

					screenX+=26

			screenX = 135
			screenY+=26

	if LogicCore.ScoreChanged == true:
		if (LogicCore.SecretCodeCombined != 8889):
			VisualsCore.DrawText(LogicCore.ScoreOneText, str(LogicCore.Score[0]), -260, 12, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(LogicCore.ScoreTwoText, str(LogicCore.Score[1]), 0, 12, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			VisualsCore.DrawText(LogicCore.ScoreThreeText, str(LogicCore.Score[2]), 260, 12, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			if (LogicCore.SecretCodeCombined != 6161):
				if (LogicCore.PlayerInput[0] > -1):
					VisualsCore.DrawText(InputNameOne, str(InputCore.InputNames[LogicCore.PlayerInput[0]]), -260, VisualsCore.ScreenHeight-19+13, 1, 15, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
				else:  VisualsCore.DrawText(InputNameOne, " ", -260, VisualsCore.ScreenHeight-19, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

				if (LogicCore.PlayerInput[1] > -1):
					VisualsCore.DrawText(InputNameTwo, str(InputCore.InputNames[LogicCore.PlayerInput[1]]), 0, VisualsCore.ScreenHeight-19+13, 1, 15, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
				else:  VisualsCore.DrawText(InputNameTwo, " ", 0, VisualsCore.ScreenHeight-19, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

				if (LogicCore.PlayerInput[2] > -1):
					VisualsCore.DrawText(InputNameThree, str(InputCore.InputNames[LogicCore.PlayerInput[2]]), 260, VisualsCore.ScreenHeight-19+13, 1, 15, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
				else:  VisualsCore.DrawText(InputNameThree, " ", 260, VisualsCore.ScreenHeight-19, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			if (LogicCore.SecretCodeCombined == 6161):
				VisualsCore.DrawText(InputNameOne, "C.P.U.", -260, VisualsCore.ScreenHeight-15, 1, 21, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
				VisualsCore.DrawText(InputNameTwo, "Keyboard", 0, VisualsCore.ScreenHeight-15, 1, 21, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
				VisualsCore.DrawText(InputNameThree, "Mouse", 260, VisualsCore.ScreenHeight-15, 1, 21, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		elif (LogicCore.SecretCodeCombined == 8889):
			if (LogicCore.PlayerStatus[0] != LogicCore.GameOver):  VisualsCore.DrawText(LogicCore.ScoreOneText, str(LogicCore.Score[0]), -260, 12, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			else:  VisualsCore.DrawText(LogicCore.ScoreOneText, "Game Over?", -260, 12, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
				
			if (LogicCore.PlayerStatus[1] != LogicCore.GameOver):  VisualsCore.DrawText(LogicCore.ScoreTwoText, str(LogicCore.Score[1]), 0, 12, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			else:  VisualsCore.DrawText(LogicCore.ScoreTwoText, "Game Over?", 0, 12, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			
			if (LogicCore.PlayerStatus[2] != LogicCore.GameOver):  VisualsCore.DrawText(LogicCore.ScoreOneText, str(LogicCore.Score[2]), -260, 12, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			else:  VisualsCore.DrawText(LogicCore.ScoreThreeText, "Game Over?", 260, 12, 1, 25, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		LogicCore.ScoreChanged = false

	if ( VisualsCore.KeyboardControlsAlphaTimer > 0.0 && ScreensCore.OperatingSys != ScreensCore.OSAndroid && (InputCore.HTML5input == InputCore.InputKeyboard)):
		if (InputCore.HTML5input != InputCore.InputMouse):
			VisualsCore.DrawSprite(19980, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)+60, 0.4, 0.4, 0, 1.0, 1.0, 1.0, VisualsCore.KeyboardControlsAlphaTimer)
			VisualsCore.KeyboardControlsAlphaTimer-=0.01
		else:  VisualsCore.KeyboardControlsAlphaTimer = 0.0

	LogicCore.DeleteFromPlayfieldAllPlayerPiecesAndDropShadows()

	if (LogicCore.PAUSEgame == false):
		if (InterfaceCore.ThisIconWasPressed(0) == true):
			PlayingExited = true
			ScreensCore.ScreenToDisplayNext = ScreensCore.TitleScreen
			ScreensCore.ScreenFadeStatus = ScreensCore.FadingToBlack
		elif (InterfaceCore.ThisIconWasPressed(1) == true):
			if (LogicCore.PAUSEgame == false):
				LogicCore.PAUSEgame = true
				LogicCore.PauseWasJustPressed = true

				InterfaceCore.Icons.IconScreenX[1] = -9999

				InputCore.OldMusicVolume = AudioCore.MusicVolume
				AudioCore.MusicPlayer.set_volume_db(AudioCore.ConvertLinearToDB(0.0))

				InputCore.DelayAllUserInput = 25
		elif (LogicCore.PlayersCanJoinIn == true):
			if (InterfaceCore.ThisIconWasPressed(1+1) == true):
				LogicCore.ScoreChanged = true
				InterfaceCore.Icons.IconScreenX[1+1] = -9999
				InterfaceCore.Icons.IconScreenY[1+1] = -9999

				if (LogicCore.MousePlayerStarted == false):
					LogicCore.MousePlayerStarted = true
					VisualsCore.DrawSprite(138, (VisualsCore.ScreenWidth/2.0)+260, (VisualsCore.ScreenHeight/2.0)+9999, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

					if (LogicCore.PlayerStatus[2] == LogicCore.GameOver):
						if (OperatingSys != OSAndroid):
							LogicCore.PlayerInput[2] = InputCore.InputMouse
						else:
							LogicCore.PlayerInput[2] = InputCore.InputTouchTwo

						LogicCore.PlayerStatus[2] = LogicCore.NewPieceDropping
						LogicCore.ScoreChanged = true
		elif (LogicCore.PlayersCanJoinIn == false):
			VisualsCore.DrawSprite(137, (VisualsCore.ScreenWidth/2.0)+260, (VisualsCore.ScreenHeight/2.0)+9999, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
			VisualsCore.DrawSprite(138, (VisualsCore.ScreenWidth/2.0)+260, (VisualsCore.ScreenHeight/2.0)+9999, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

		if (InputCore.ThereAreGamepads == false): VisualsCore.DrawSprite(137, (VisualsCore.ScreenWidth/2.0)+260, (VisualsCore.ScreenHeight/2.0)+9999, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

		var numberOfPlayers = 0
		for indexPlayer in range(0,3):
			if (LogicCore.PlayerInput[indexPlayer] != InputCore.InputNone and LogicCore.PlayerInput[indexPlayer] != InputCore.InputCPU):
				if (LogicCore.PlayersCanJoinIn == false):  numberOfPlayers+=1

		if (ScreensCore.OperatingSys == ScreensCore.OSAndroid and numberOfPlayers == 1):
			if (LogicCore.AllowComputerPlayers == 0):
				InterfaceCore.Icons.IconScreenX[8] = -9999
				InterfaceCore.Icons.IconScreenX[9] = -9999
				InterfaceCore.Icons.IconScreenX[10] = -9999
				InterfaceCore.Icons.IconScreenX[11] = -9999
				InterfaceCore.Icons.IconScreenX[12] = -9999
			else:
				InterfaceCore.Icons.IconScreenX[7] = -9999
				InterfaceCore.Icons.IconScreenX[8] = -9999
				InterfaceCore.Icons.IconScreenX[9] = -9999
				InterfaceCore.Icons.IconScreenX[10] = -9999
				InterfaceCore.Icons.IconScreenX[11] = -9999
		elif (ScreensCore.OperatingSys != ScreensCore.OSAndroid and numberOfPlayers == 1):
				InterfaceCore.Icons.IconScreenX[3] = -9999
				InterfaceCore.Icons.IconScreenX[4] = -9999
				InterfaceCore.Icons.IconScreenX[5] = -9999
				InterfaceCore.Icons.IconScreenX[6] = -9999
				InterfaceCore.Icons.IconScreenX[7] = -9999

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		VisualsCore.SetFramesPerSecond(30)

		if (PlayingExited == false):
			if (LogicCore.StillPlaying == false):
				DataCore.CheckForNewHighScore()
				if (LogicCore.GameWon == true):
					ScreenToDisplayNext = WonGameScreen
				elif (DataCore.NewHighScoreRank < 999):
					ScreenToDisplayNext = NewHighScoreScreen
				elif (DataCore.NewHighScoreRank == 999):
					ScreenToDisplayNext = HighScoresScreen
		else:
			ScreenToDisplayNext = TitleScreen
			AudioCore.PlayMusic(0, true)
			InputCore.DelayAllUserInput = 50

		if (LogicCore.SecretCodeCombined == 8889):
			if (LogicCore.StillPlaying == true):  LogicCore.ComputerPlayersTotalLevelClears+=1

			LogicCore.SetupForNewGame()

			LogicCore.ComputerPlayersTotalGamesPlayed+=1
			
			ScreenToDisplayNext = PlayingGameScreen

	pass

#----------------------------------------------------------------------------------------
func DisplayNewHighScoreScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		NewHighScoreString = " "
		NewHighScoreStringIndex = 0

		NewHighScoreNameInputJoyX = 0
		NewHighScoreNameInputJoyY = 0

		NewHighScoreString = NewHighScoreString.left(-1)

		RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
		VisualsCore.DrawSprite(10, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.5)
		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "N E W   H I G H   S C O R E:", 0, 12, 1, 22, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)
		VisualsCore.DrawSprite(30, VisualsCore.ScreenWidth/2.0, 30, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, " ", 0, 0, 0, 25, 1.0, 1.0, 0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawText(VisualsCore.TextCurrentIndex, "You Achieved A New High Score! Please Enter Your Name:", 0, 70, 1, 19, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		var screenY = 230
		var screenX = 68
		var offsetX = 75
		var spriteIndex = 0
		for index in range(65, 78):
			InterfaceCore.CreateIcon( 200+(spriteIndex), screenX, screenY, char(index) )
			screenX+=offsetX
			spriteIndex+=1

		screenY = 230+75
		screenX = 68
		for index in range(78, 91):
			InterfaceCore.CreateIcon( 200+(spriteIndex), screenX, screenY, char(index) )
			screenX+=offsetX
			spriteIndex+=1

		screenY = 230+75+75
		screenX = 68
		for index in range(97, 110):
			InterfaceCore.CreateIcon( 200+(spriteIndex), screenX, screenY, char(index) )
			screenX+=offsetX
			spriteIndex+=1

		screenY = 230+75+75+75
		screenX = 68
		for index in range(110, 123):
			InterfaceCore.CreateIcon( 200+(spriteIndex), screenX, screenY, char(index) )
			screenX+=offsetX
			spriteIndex+=1

		screenY = 230+75+75+75+75
		screenX = 68
		for index in range(48, 58):
			InterfaceCore.CreateIcon( 200+(spriteIndex), screenX, screenY, char(index) )
			screenX+=offsetX
			spriteIndex+=1

		InterfaceCore.CreateIcon( 200+(spriteIndex), screenX, screenY, char(43) )
		spriteIndex+=1
		InterfaceCore.CreateIcon( 200+(spriteIndex), screenX+75, screenY, char(95) )
		spriteIndex+=1
		InterfaceCore.CreateIcon( 200+(spriteIndex), screenX+75+75+9999, screenY, char(60) )

		InterfaceCore.CreateIcon( 200+(spriteIndex+1), screenX+75+75, screenY, "<" )

		var _lastIndex = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, NewHighScoreString, 0, 70+55, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

		VisualsCore.DrawSprite(32, VisualsCore.ScreenWidth/2.0, 583, 2.85, 2.0, 0, 1.0, 1.0, 0.0, 1.0)
		InterfaceCore.CreateButton (5, (VisualsCore.ScreenWidth/2.0), VisualsCore.ScreenHeight-25.0)

	var highScoreNameTextIndex = 77

	if (InputCore.KeyTypedOnKeyboard != "`"):
		var letter = InputCore.KeyTypedOnKeyboard.unicode_at(0)
		if (letter > 64 && letter < 91):
			InterfaceCore.Icons.IconAnimationTimer[letter-65] = 3
			InputCore.DelayAllUserInput = 2
		elif (letter > 96 && letter < 123):
			InterfaceCore.Icons.IconAnimationTimer[(letter-96)+25] = 3
			InputCore.DelayAllUserInput = 2
		elif (letter > 47 && letter < 58):
			InterfaceCore.Icons.IconAnimationTimer[(letter-46)+50] = 3
			InputCore.DelayAllUserInput = 2
		elif (letter == 43):
			InterfaceCore.Icons.IconAnimationTimer[62] = 3
			InputCore.DelayAllUserInput = 2
		elif (letter == 95):
			InterfaceCore.Icons.IconAnimationTimer[63] = 3
			InputCore.DelayAllUserInput = 2

	if (InputCore.KeyboardBackspacePressed == true):
		InterfaceCore.Icons.IconAnimationTimer[65] = 3
		InputCore.DelayAllUserInput = 5

	for index in range(0, 100):
		RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[200+index], Color(1.0, 1.0, 1.0, 1.0))

	for index in range(40, 50):
		RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[index], Color(1.0, 1.0, 1.0, 1.0))

	for index in range(0, 10):
		RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[40+index], Color(1.0, 1.0, 1.0, 1.0))

	if (NewHighScoreNameInputJoyY == 0):
		RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[200+NewHighScoreNameInputJoyX], Color(0.0, 1.0, 1.0, 1.0))
	elif (NewHighScoreNameInputJoyY == 1):
		RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[200+13+NewHighScoreNameInputJoyX], Color(0.0, 1.0, 1.0, 1.0))
	elif (NewHighScoreNameInputJoyY == 2):
		RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[200+26+NewHighScoreNameInputJoyX], Color(0.0, 1.0, 1.0, 1.0))
	elif (NewHighScoreNameInputJoyY == 3):
		RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[200+39+NewHighScoreNameInputJoyX], Color(0.0, 1.0, 1.0, 1.0))
	elif (NewHighScoreNameInputJoyY == 4):
		RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[200+52+NewHighScoreNameInputJoyX], Color(0.0, 1.0, 1.0, 1.0))

	if (InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed):
		InputCore.DelayAllUserInput = 5
		AudioCore.PlayEffect(1, 1)

		if (NewHighScoreNameInputJoyY == 0):
			InterfaceCore.Icons.IconAnimationTimer[NewHighScoreNameInputJoyX] = 3
		elif (NewHighScoreNameInputJoyY == 1):
			InterfaceCore.Icons.IconAnimationTimer[13+NewHighScoreNameInputJoyX] = 3
		elif (NewHighScoreNameInputJoyY == 2):
			InterfaceCore.Icons.IconAnimationTimer[26+NewHighScoreNameInputJoyX] = 3
		elif (NewHighScoreNameInputJoyY == 3):
			InterfaceCore.Icons.IconAnimationTimer[39+NewHighScoreNameInputJoyX] = 3
		elif (NewHighScoreNameInputJoyY == 4):
			InterfaceCore.Icons.IconAnimationTimer[52+NewHighScoreNameInputJoyX] = 3
		elif (NewHighScoreNameInputJoyY == 5):
			ScreenFadeStatus = FadingToBlack
	elif (InputCore.JoyButtonTwo[InputCore.InputAny] == InputCore.Pressed):
		InputCore.DelayAllUserInput = 5
		AudioCore.PlayEffect(1, 1)

		if (NewHighScoreStringIndex > 0):
			NewHighScoreString = NewHighScoreString.left(-1)
			NewHighScoreStringIndex-=1
			VisualsCore.DrawText(highScoreNameTextIndex, NewHighScoreString, 0, 70+55, 1, 35, 1.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

	if (InputCore.JoystickDirection[InputCore.InputAny] == InputCore.JoyUp):
		InputCore.DelayAllUserInput = 5
		AudioCore.PlayEffect(1, 0)
		if (NewHighScoreNameInputJoyY > 0):
			NewHighScoreNameInputJoyY-=1
		else:
			NewHighScoreNameInputJoyY = 5
	elif (InputCore.JoystickDirection[InputCore.InputAny] == InputCore.JoyDown):
		InputCore.DelayAllUserInput = 5
		AudioCore.PlayEffect(1, 0)
		if (NewHighScoreNameInputJoyY < 5):
			NewHighScoreNameInputJoyY+=1
		else:
			NewHighScoreNameInputJoyY = 0
	elif (InputCore.JoystickDirection[InputCore.InputAny] == InputCore.JoyLeft):
		InputCore.DelayAllUserInput = 5
		AudioCore.PlayEffect(1, 0)
		if (NewHighScoreNameInputJoyX > 0):
			NewHighScoreNameInputJoyX-=1
		else:
			NewHighScoreNameInputJoyX = 12
	elif (InputCore.JoystickDirection[InputCore.InputAny] == InputCore.JoyRight):
		InputCore.DelayAllUserInput = 5
		AudioCore.PlayEffect(1, 0)
		if (NewHighScoreNameInputJoyX < 12):
			NewHighScoreNameInputJoyX+=1
		else:
			NewHighScoreNameInputJoyX = 0

	for index in range(0, InterfaceCore.NumberOfIconsOnScreen):
		if (InterfaceCore.ThisIconWasPressed(index)):
			if (index < 63 && NewHighScoreStringIndex < 20):
				NewHighScoreString+=InterfaceCore.Icons.IconText[index]
				NewHighScoreStringIndex+=1
				if (InputCore.MouseButtonLeftPressed == true || InputCore.TouchTwoPressed == true):  InputCore.DelayAllUserInput = 10
				AudioCore.PlayEffect(1, 0)
				VisualsCore.DrawText(highScoreNameTextIndex, NewHighScoreString, 0, 70+55, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif (index == 63 && NewHighScoreStringIndex < 20):
				NewHighScoreString+=" "
				NewHighScoreStringIndex+=1
				if (InputCore.MouseButtonLeftPressed == true || InputCore.TouchTwoPressed == true):  InputCore.DelayAllUserInput = 10
				AudioCore.PlayEffect(1, 0)
				VisualsCore.DrawText(highScoreNameTextIndex, NewHighScoreString, 0, 70+55, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif (index == 65):
				if (NewHighScoreStringIndex > 0):
					NewHighScoreString = NewHighScoreString.left(-1)
					NewHighScoreStringIndex-=1
					if (InputCore.MouseButtonLeftPressed == true || InputCore.TouchTwoPressed == true):  InputCore.DelayAllUserInput = 10
					AudioCore.PlayEffect(1, 0)
					VisualsCore.DrawText(highScoreNameTextIndex, NewHighScoreString, 0, 70+55, 1, 35, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

	if InterfaceCore.ThisButtonWasPressed(0) == true:
		ScreenFadeStatus = FadingToBlack

	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:
		ScreenToDisplayNext = HighScoresScreen
		InputCore.DelayAllUserInput = 25

		if (NewHighScoreStringIndex == 0):
			NewHighScoreString = " "
			
		DataCore.HighScoreName[LogicCore.GameMode][DataCore.NewHighScoreRank] = NewHighScoreString

		for index in range(0, 100):
			RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[200+index], Color(1.0, 1.0, 1.0, 1.0))

		for index in range(0, 10):
			RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[40+index], Color(1.0, 1.0, 1.0, 1.0))

	pass

#----------------------------------------------------------------------------------------
func DisplayWonGameScreen():
	if ScreenFadeStatus == FadingFromBlack && ScreenFadeTransparency == 1.0:
		RenderingServer.set_default_clear_color(Color(0.1, 0.1, 0.1, 1.0))
		
		VisualsCore.SetFramesPerSecond(30)

		WonSunsetY = (VisualsCore.ScreenHeight/2.0)-75.0
		WonHimX = 200
		WonHerX = (1024-200)

		VisualsCore.DrawSprite(170, VisualsCore.ScreenWidth/2.0, WonSunsetY, 3.15, 3.15, 0, 1.0, 1.0, 1.0, 1.0)
		VisualsCore.DrawSprite(171, VisualsCore.ScreenWidth/2.0, (VisualsCore.ScreenHeight/2.0)+75, 3.15, 3.15, 0, 1.0, 1.0, 1.0, 1.0)

		VisualsCore.DrawSprite(172, WonHimX, (VisualsCore.ScreenHeight/2.0)+72, 3.15, 3.15, 0, 1.0, 1.0, 1.0, 1.0)
		VisualsCore.DrawSprite(173, WonHerX, (VisualsCore.ScreenHeight/2.0)+72, 3.15, 3.15, 0, 1.0, 1.0, 1.0, 1.0)

		AudioCore.PlayMusic(11, false)

	if (WonSunsetY < 360):
		WonSunsetY+=0.2
		VisualsCore.DrawSprite(170, VisualsCore.ScreenWidth/2.0, WonSunsetY, 3.15, 3.15, 0, 1.0, 1.0, 1.0, 1.0)
	else:
		ScreenFadeStatus = FadingToBlack
		ScreenToDisplayNext = AboutScreen

	if ( WonHimX < (1024.0/2.0)-38.0 ):
		WonHimX+=2
		WonHerX-=2

		VisualsCore.DrawSprite(172, WonHimX, (VisualsCore.ScreenHeight/2.0)+72, 3.15, 3.15, 0, 1.0, 1.0, 1.0, 1.0)
		VisualsCore.DrawSprite(173, WonHerX, (VisualsCore.ScreenHeight/2.0)+72, 3.15, 3.15, 0, 1.0, 1.0, 1.0, 1.0)

#	if ScreenFadeStatus == FadingToBlack && ScreenFadeTransparency == 0.5:

	pass

#----------------------------------------------------------------------------------------
func ProcessScreenToDisplay():
	if ScreenToDisplay == HTML5Screen:
		DisplayHTML5Screen()
	elif ScreenToDisplay == GodotScreen:
		DisplayGodotScreen()
	elif ScreenToDisplay == FASScreen:
		DisplayFASScreen()
	elif ScreenToDisplay == TitleScreen:
		DisplayTitleScreen()
	elif ScreenToDisplay == InputScreen:
		DisplayInputScreen()
	elif ScreenToDisplay == OptionsScreen:
		DisplayOptionsScreen()
	elif ScreenToDisplay == HowToPlayScreen:
		DisplayHowToPlayScreen()
	elif ScreenToDisplay == HighScoresScreen:
		DisplayHighScoresScreen()
	elif ScreenToDisplay == AboutScreen:
		DisplayAboutScreen()
	elif ScreenToDisplay == MusicTestScreen:
		DisplayMusicTestScreen()
	elif ScreenToDisplay == PlayingGameScreen:
		DisplayPlayingGameScreen()
	elif ScreenToDisplay == CutSceneScreen:
		DisplayCutSceneScreen()
	elif ScreenToDisplay == NewHighScoreScreen:
		DisplayNewHighScoreScreen()
	elif ScreenToDisplay == WonGameScreen:
		DisplayWonGameScreen()
	elif ScreenToDisplay == NoCPUScreen:
		DisplayNoCPUScreen()

	if (ScreenToDisplay != PlayingGameScreen):
		InterfaceCore.DrawAllButtons()
		InterfaceCore.DrawAllArrowSets()

	InterfaceCore.DrawAllIcons()

	ApplyScreenFadeTransition()

	if (LogicCore.SecretCodeCombined == 2777 || LogicCore.SecretCodeCombined == 8888 || LogicCore.SecretCodeCombined == 8889):
		VisualsCore.FramesPerSecondText.TextImage[0].global_position.x = (10)

		VisualsCore.FramesPerSecondFrames = (VisualsCore.FramesPerSecondFrames + 1)

		var ticks = Time.get_ticks_msec()
		if (ticks > (1000+VisualsCore.FramesPerSecondLastSecondTick)):
			VisualsCore.FramesPerSecondLastSecondTick = ticks

			VisualsCore.FramesPerSecondArrayIndex = (VisualsCore.FramesPerSecondArrayIndex + 1)
			if (VisualsCore.FramesPerSecondArrayIndex > 9):  VisualsCore.FramesPerSecondArrayIndex = 0

			VisualsCore.FramesPerSecondArray[VisualsCore.FramesPerSecondArrayIndex] = VisualsCore.FramesPerSecondFrames

			VisualsCore.FramesPerSecondFrames = 0

			VisualsCore.FramesPerSecondAverage = 0
			for index in range(0, 10):
				VisualsCore.FramesPerSecondAverage+=VisualsCore.FramesPerSecondArray[index]

			VisualsCore.FramesPerSecondAverage = (VisualsCore.FramesPerSecondAverage / 10)
			VisualsCore.FramesPerSecondAverage = floor(VisualsCore.FramesPerSecondAverage)

			if (ScreenToDisplay == PlayingGameScreen):
				VisualsCore.FramesPerSecondText.TextImage[0].text = (" "+str(VisualsCore.FramesPerSecondAverage)+"/"+str(fps[LogicCore.GameMode]))
			elif (ScreenToDisplay != PlayingGameScreen):
				VisualsCore.FramesPerSecondText.TextImage[0].text = (" "+str(VisualsCore.FramesPerSecondAverage)+"/30")
	else:
		VisualsCore.FramesPerSecondText.TextImage[0].global_position.x = -9999

	pass
