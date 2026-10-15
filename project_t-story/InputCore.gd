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

# "InputCore.gd"
extends Node2D

var DelayAllUserInput

var KeyboardSpacebarPressed
var KeyboardEnterPressed
var KeyboardBackspacePressed

var KeyTypedOnKeyboard
var ShiftPressedOnKeyboard = false

const JoyCentered			= 0
const JoyUp				 	= 1
const JoyRight				= 2
const JoyDown				= 3
const JoyLeft				= 4
var JoystickDirection = []

const NotPressed			= 0
const Pressed				= 1
var JoyButtonOne = []
var JoyButtonTwo = []
var JoyButtonOneWasPressed = []
var JoyButtonTwoWasPressed = []

var NumberOfGamepads = 0
var FoundGamepadOne = false
var FoundGamepadTwo = false
var FoundGamepadThree = false

var NumberOfGamePadsText

var JoyUpMapped = []
var JoyDownMapped = []
var JoyLeftMapped = []
var JoyRightMapped = []
var JoyButtonOneMapped = []
var JoyButtonTwoMapped = []

var	KeyRotateOneMapped = "z"
var KeyRotateTwoMapped = "x"

var MouseButtonLeftPressed
var MouseButtonRightPressed

var MouseScreenX
var MouseScreenY

var PauseOldMusicVolume

const InputNone			= -1
const InputKeyboard		= 0
const InputMouse		= 1
const InputTouchOne		= 2
const InputTouchTwo		= 3
const InputJoyOne		= 4
const InputJoyTwo		= 5
const InputJoyThree		= 6
const InputCPU			= 7
const InputAny			= 8

var InputNames = []

var InputThatStartedNewGame

var GamePadOneNameText
var GamePadTwoNameText
var GamePadThreeNameText

var GameControllerNames = []

#----------------------------------------------------------------------------------------
func _ready():
	set_process_input(true)

	DelayAllUserInput = 0
	
	KeyboardSpacebarPressed = false
	KeyboardEnterPressed = false

	JoystickDirection.resize(9)
	JoyButtonOne.resize(9)
	JoyButtonOneWasPressed.resize(9)
	JoyButtonTwo.resize(9)
	JoyButtonTwoWasPressed.resize(9)

	for index in range(0, 9):
		JoystickDirection[index] = JoyCentered
		JoyButtonOne[index] = NotPressed
		JoyButtonOneWasPressed[index] = 0
		JoyButtonTwo[index] = NotPressed
		JoyButtonTwoWasPressed[index] = 0

	JoyUpMapped.resize(9)
	for x in range(9):
		JoyUpMapped[x] = []
		JoyUpMapped[x].resize(1)
		for y in range(1):
			JoyUpMapped[x][y] = []

	JoyDownMapped.resize(9)
	for x in range(9):
		JoyDownMapped[x] = []
		JoyDownMapped[x].resize(1)
		for y in range(1):
			JoyDownMapped[x][y] = []

	JoyLeftMapped.resize(9)
	for x in range(9):
		JoyLeftMapped[x] = []
		JoyLeftMapped[x].resize(1)
		for y in range(1):
			JoyLeftMapped[x][y] = []

	JoyRightMapped.resize(9)
	for x in range(9):
		JoyRightMapped[x] = []
		JoyRightMapped[x].resize(1)
		for y in range(1):
			JoyRightMapped[x][y] = []

	JoyButtonOneMapped.resize(9)
	for x in range(9):
		JoyButtonOneMapped[x] = []
		JoyButtonOneMapped[x].resize(1)
		for y in range(1):
			JoyButtonOneMapped[x][y] = []

	JoyButtonTwoMapped.resize(9)
	for x in range(9):
		JoyButtonTwoMapped[x] = []
		JoyButtonTwoMapped[x].resize(1)
		for y in range(1):
			JoyButtonTwoMapped[x][y] = []

	for index in range(0, 9):
		JoyUpMapped[index][0] = 11+10
		JoyDownMapped[index][0] = 12+10
		JoyLeftMapped[index][0] = 13+10
		JoyRightMapped[index][0] = 14+10
		JoyButtonOneMapped[index][0] = 0+10
		JoyButtonTwoMapped[index][0] = 1+10

	MouseButtonLeftPressed = false
	MouseButtonRightPressed = false
	
	InputNames.resize(8)
	InputNames[0] = "Keyboard"
	InputNames[1] = "Mouse"
	InputNames[2] = "Touch 1"
	InputNames[3] = "Touch 2"
	InputNames[4] = "Controller 1"
	InputNames[5] = "Controller 2"
	InputNames[6] = "Controller 3"
	InputNames[7] = "A.I."

	GameControllerNames.resize(3)
	GameControllerNames[0] = "N.A."
	GameControllerNames[1] = "N.A."
	GameControllerNames[2] = "N.A."

	pass

#----------------------------------------------------------------------------------------
func GetJoystickInputForMapping(index, _buttons):
	if (DelayAllUserInput > 0):
		return(-1)

	for indexThree in range(0, 127):
		if (Input.is_joy_button_pressed (index, indexThree) == true):
			return(indexThree+10)

	return(-1)

#----------------------------------------------------------------------------------------
func _process(_delta):
	for index in range(1, 9):
		JoystickDirection[index] = JoyCentered
		JoyButtonOne[index] = NotPressed
		JoyButtonTwo[index] = NotPressed

	if DelayAllUserInput > -1:
		DelayAllUserInput-=1
		return

	#if Input.is_action_pressed("KeyboardUp"):
		#JoystickDirection[InputKeyboard] = JoyUp
	#elif Input.is_action_pressed("KeyboardRight"):
		#JoystickDirection[InputKeyboard] = JoyRight
	#elif Input.is_action_pressed("KeyboardDown"):
		#JoystickDirection[InputKeyboard] = JoyDown
	#elif Input.is_action_pressed("KeyboardLeft"):
		#JoystickDirection[InputKeyboard] = JoyLeft

	#if (Input.is_action_pressed("ButtonOne")):
		#if (ScreensCore.ScreenToDisplay != ScreensCore.NewHighScoreScreen):  JoyButtonOne[InputKeyboard] = Pressed
		#InputThatStartedNewGame = InputKeyboard
#
	#if (Input.is_action_pressed("ButtonTwo")):
		#if (ScreensCore.ScreenToDisplay != ScreensCore.NewHighScoreScreen):  JoyButtonTwo[InputKeyboard] = Pressed

	for index in range (0, 3):
		if ( (FoundGamepadOne == true && index == 0) || (FoundGamepadTwo == true && index == 1)  || (FoundGamepadThree == true && index == 2) ):
			for indexButton in range (0, 127):
				if (JoyUpMapped[index][0] == 10+indexButton && Input.is_joy_button_pressed (index, indexButton) == true):
					JoystickDirection[InputJoyOne+index] = JoyUp
				elif (JoyDownMapped[index][0] == 10+indexButton && Input.is_joy_button_pressed (index, indexButton) == true):
					JoystickDirection[InputJoyOne+index] = JoyDown
				elif (JoyLeftMapped[index][0] == 10+indexButton && Input.is_joy_button_pressed (index, indexButton) == true):
					JoystickDirection[InputJoyOne+index] = JoyLeft
				elif (JoyRightMapped[index][0] == 10+indexButton && Input.is_joy_button_pressed (index, indexButton) == true):
					JoystickDirection[InputJoyOne+index] = JoyRight

				if (ScreensCore.ScreenToDisplay != ScreensCore.HTML5Screen):
					if (JoyButtonOneMapped[index][0] == 10+indexButton && Input.is_joy_button_pressed (index, indexButton) == true):
						JoyButtonOne[InputJoyOne+index] = Pressed
						InputCore.InputThatStartedNewGame = InputJoyOne+index

					if (JoyButtonTwoMapped[index][0] == 10+indexButton && Input.is_joy_button_pressed (index, indexButton) == true):
						JoyButtonTwo[InputJoyOne+index] = Pressed

			for indexAxis in range (0, 10):
				if (JoyUpMapped[index][0] == indexAxis && Input.is_joy_button_pressed (index, indexAxis) == true):
					JoystickDirection[InputJoyOne+index] = JoyUp

	if (FoundGamepadOne == true):
		var velocityZero = Input.get_vector("Joy0LeftAnalogLeft", "Joy0LeftAnalogRight", "Joy0LeftAnalogUp", "Joy0LeftAnalogDown")
		if (velocityZero.y < -0.85):
			JoystickDirection[InputJoyOne] = JoyUp
		elif (velocityZero.y > 0.85):
			JoystickDirection[InputJoyOne] = JoyDown
		elif (velocityZero.x < -0.85):
			JoystickDirection[InputJoyOne] = JoyLeft
		elif (velocityZero.x > 0.85):
			JoystickDirection[InputJoyOne] = JoyRight

	if (FoundGamepadTwo == true):
		var velocityOne = Input.get_vector("Joy1LeftAnalogLeft", "Joy1LeftAnalogRight", "Joy1LeftAnalogUp", "Joy1LeftAnalogDown")
		if (velocityOne.y < -0.85):
			JoystickDirection[InputJoyTwo] = JoyUp
		elif (velocityOne.y > 0.85):
			JoystickDirection[InputJoyTwo] = JoyDown
		elif (velocityOne.x < -0.85):
			JoystickDirection[InputJoyTwo] = JoyLeft
		elif (velocityOne.x > 0.85):
			JoystickDirection[InputJoyTwo] = JoyRight

	if (FoundGamepadThree == true):
		var velocityTwo = Input.get_vector("Joy2LeftAnalogLeft", "Joy2LeftAnalogRight", "Joy2LeftAnalogUp", "Joy2LeftAnalogDown")
		if (velocityTwo.y < -0.85):
			JoystickDirection[InputJoyThree] = JoyUp
		elif (velocityTwo.y > 0.85):
			JoystickDirection[InputJoyThree] = JoyDown
		elif (velocityTwo.x < -0.85):
			JoystickDirection[InputJoyThree] = JoyLeft
		elif (velocityTwo.x > 0.85):
			JoystickDirection[InputJoyThree] = JoyRight

	for index in range (0, 8):
		if (JoystickDirection[index] != JoyCentered):
			JoystickDirection[InputAny] = JoystickDirection[index]

		if (JoyButtonOne[index] != NotPressed):
			JoyButtonOne[InputAny] = JoyButtonOne[index]

		if (JoyButtonTwo[index] != NotPressed):
			JoyButtonTwo[InputAny] = JoyButtonTwo[index]

	if Input.is_action_pressed("Shift"):
		ShiftPressedOnKeyboard = true
	else:
		ShiftPressedOnKeyboard = false

	if ( Input.is_action_pressed("Pause") && LogicCore.GameOverDisplayTimer == -1 ):
		if (DelayAllUserInput < 1 && ScreensCore.ScreenToDisplay == ScreensCore.PlayingGameScreen):
			if (LogicCore.PAUSEgame == false):
				LogicCore.PAUSEgame = true
				LogicCore.PauseWasJustPressed = true

				PauseOldMusicVolume = AudioCore.MusicVolume
				AudioCore.MusicPlayer.set_volume_db(linear_to_db(0.0))
			elif (LogicCore.PAUSEgame == true):
				LogicCore.PAUSEgame = false
				LogicCore.PauseWasJustPressed = true

				AudioCore.MusicVolume = PauseOldMusicVolume
				if (AudioCore.MusicVolume > 0.0):  AudioCore.MusicPlayer.set_volume_db(linear_to_db(AudioCore.MusicVolume))

			AudioCore.PlayEffect(1, 1)
			DelayAllUserInput = 50
	elif Input.is_action_pressed("SeeEnding"):
		if (ScreensCore.ScreenToDisplay == ScreensCore.TitleScreen && LogicCore.SecretCodeCombined == 2777):
			ScreensCore.SeeEndingStaff = true
			ScreensCore.ScreenFadeStatus = ScreensCore.FadingToBlack

	pass

#----------------------------------------------------------------------------------------
func _input(event):
	KeyboardSpacebarPressed = false
	KeyboardEnterPressed = false
	KeyboardBackspacePressed = false

	KeyTypedOnKeyboard = "`"

	JoystickDirection[0] = JoyCentered
	JoyButtonOne[0] = NotPressed
	JoyButtonTwo[0] = NotPressed

	if Input.is_action_pressed("KeyboardUp"):
		JoystickDirection[InputKeyboard] = JoyUp
	elif Input.is_action_pressed("KeyboardRight"):
		JoystickDirection[InputKeyboard] = JoyRight
	elif Input.is_action_pressed("KeyboardDown"):
		JoystickDirection[InputKeyboard] = JoyDown
	elif Input.is_action_pressed("KeyboardLeft"):
		JoystickDirection[InputKeyboard] = JoyLeft

	if (ScreensCore.ScreenToDisplay != ScreensCore.PlayingGameScreen):
		MouseButtonLeftPressed = false

	if ScreensCore.ScreenFadeStatus != ScreensCore.FadingIdle:  return

	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.pressed:
			if ( (ScreensCore.ScreenToDisplay == ScreensCore.AboutScreen and LogicCore.GameWon == true) or (ScreensCore.ScreenToDisplay == ScreensCore.WonGameScreen) ):
				AudioCore.PlayEffect(1, 1)
			else:
				ScreensCore.ScreenToDisplayNext = ScreensCore.TitleScreen
				ScreensCore.ScreenFadeStatus = ScreensCore.FadingToBlack
				AudioCore.PlayEffect(1, 1)
				AudioCore.PlayMusic(0, true)
		elif event.keycode == KEY_SPACE and event.pressed:
			KeyboardSpacebarPressed = true
			KeyTypedOnKeyboard = "_"
		elif event.keycode == KEY_ENTER and event.pressed:
			KeyboardEnterPressed = true
		elif event.keycode == KEY_BACKSPACE and event.pressed:
			KeyboardBackspacePressed = true

		if (event.pressed && event.keycode != KEY_SHIFT):
			if (event.unicode > 32 && event.unicode < 137):
				KeyTypedOnKeyboard = char(event.unicode)

				if ( KeyRotateOneMapped == KeyTypedOnKeyboard && ScreensCore.ScreenToDisplay != ScreensCore.NewHighScoreScreen ):
					JoyButtonOne[InputKeyboard] = Pressed
					InputThatStartedNewGame = InputKeyboard
				elif ( KeyRotateTwoMapped == KeyTypedOnKeyboard && ScreensCore.ScreenToDisplay != ScreensCore.NewHighScoreScreen ):
					JoyButtonTwo[InputKeyboard] = Pressed

	if event is InputEventMouseMotion:
		MouseScreenX = event.position.x
		MouseScreenY = event.position.y

	if (ScreensCore.OperatingSys != ScreensCore.OSHTMLFive):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if (event.is_pressed() == true):
					MouseButtonLeftPressed = true
					MouseScreenX = event.position.x
					MouseScreenY = event.position.y

					InputThatStartedNewGame = InputKeyboard
				else:
					MouseButtonLeftPressed = false
		if (event is InputEventMouseButton):
			if event.button_index == MOUSE_BUTTON_RIGHT:
				if (event.is_pressed() == true):
					MouseButtonRightPressed = true
	elif (ScreensCore.OperatingSys == ScreensCore.OSHTMLFive):
		if (event is InputEventMouseButton):
			if event.button_index == MOUSE_BUTTON_LEFT:
				if (event.is_pressed() == true):
					MouseButtonLeftPressed = true
					MouseScreenX = event.position.x
					MouseScreenY = event.position.y

					InputThatStartedNewGame = InputKeyboard
		if (event is InputEventMouseButton):
			if event.button_index == MOUSE_BUTTON_RIGHT:
				if (event.is_pressed() == true):
					MouseButtonRightPressed = true
		else:
			MouseButtonLeftPressed = false

	pass
