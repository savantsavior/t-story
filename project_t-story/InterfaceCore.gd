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

# "InterfaceCore.gd"
extends Node2D

var ButtonText = []

class ButtonsClass:
	var ButtonImageIndex = []
	var ButtonTextIndex = []
	var ButtonIndex = []
	var ButtonScreenX = []
	var ButtonScreenY = []
	var ButtonAnimationTimer = []
	var ButtonScale = []
var Buttons = ButtonsClass.new()

var NumberOfButtonsOnScreen
var ButtonSelectedByKeyboard

class ArrowSetsClass:
	var ArrowSetIndex = []
	var ArrowSetScreenY = []
	var ArrowSetLeftAnimationTimer = []
	var ArrowSetRightAnimationTimer = []
	var ArrowSetLeftScale = []
	var ArrowSetRightScale = []
	var ArrowSetTextStringIndex = []
var ArrowSets = ArrowSetsClass.new()

var NumberOfArrowSetsOnScreen
var ArrowSetSelectedByKeyboard
var ArrowSetSelectedByKeyboardLast

var IconText = []

class IconClass:
	var IconIndex = []
	var IconSprite = []
	var IconScreenX = []
	var IconScreenY = []
	var IconAnimationTimer = []
	var IconScale = []
	var IconText = []
	var IconTextIndex = []
var Icons = IconClass.new()

var NumberOfIconsOnScreen

#----------------------------------------------------------------------------------------
func InitializeGUI(createTexts):
	Buttons.ButtonImageIndex.clear()
	Buttons.ButtonTextIndex.clear()
	Buttons.ButtonIndex.clear()
	Buttons.ButtonScreenX.clear()
	Buttons.ButtonScreenY.clear()
	Buttons.ButtonAnimationTimer.clear()
	Buttons.ButtonScale.clear()

	for index in range(0, 10):
		Buttons.ButtonImageIndex.append(40+index)
		
		if createTexts == true:
			VisualsCore.DrawText(VisualsCore.TextCurrentIndex, ButtonText[index], 0, -99999, 1, 24, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
		
		Buttons.ButtonTextIndex.append(index)
		Buttons.ButtonIndex.append(-1)
		Buttons.ButtonScreenX.append(0)
		Buttons.ButtonScreenY.append(-99999)
		Buttons.ButtonAnimationTimer.append(-1)
		Buttons.ButtonScale.append(1.0)

	NumberOfButtonsOnScreen = 0
	ButtonSelectedByKeyboard = 0

	ArrowSets.ArrowSetScreenY.clear()
	ArrowSets.ArrowSetLeftAnimationTimer.clear()
	ArrowSets.ArrowSetRightAnimationTimer.clear()
	ArrowSets.ArrowSetLeftScale.clear()
	ArrowSets.ArrowSetRightScale.clear()
	ArrowSets.ArrowSetTextStringIndex.clear()

	for _index in range(0, 30):
		ArrowSets.ArrowSetIndex.append(-1)
		ArrowSets.ArrowSetScreenY.append(-99999)
		ArrowSets.ArrowSetLeftAnimationTimer.append(-1)
		ArrowSets.ArrowSetRightAnimationTimer.append(-1)
		ArrowSets.ArrowSetLeftScale.append(1.0)
		ArrowSets.ArrowSetRightScale.append(1.0)
		ArrowSets.ArrowSetTextStringIndex.append(" ")

	NumberOfArrowSetsOnScreen = 0
	ArrowSetSelectedByKeyboard = 0
	
	for _index in range(0, 100):
		Icons.IconIndex.append(-1)
		Icons.IconSprite.append(-1)
		Icons.IconScreenX.append(-99999)
		Icons.IconScreenY.append(-99999)
		Icons.IconAnimationTimer.append(-1)
		Icons.IconScale.append(1.0)
		Icons.IconText.append(" ")
		Icons.IconTextIndex.append(0)

	NumberOfIconsOnScreen = 0

	pass

#----------------------------------------------------------------------------------------
func _ready():
	ButtonText.append("START!")
	ButtonText.append("Options")
	ButtonText.append("How To Play")
	ButtonText.append("High Scores")
	ButtonText.append("About")
	ButtonText.append("Exit")
	ButtonText.append("Back")
	ButtonText.append("CLEAR!")
	ButtonText.append("BGM Test")
	ButtonText.append("N.A.")

	InitializeGUI(true)
	
	NumberOfArrowSetsOnScreen = 0
	ArrowSetSelectedByKeyboard = 0

	ArrowSetSelectedByKeyboardLast = -1

	pass

#----------------------------------------------------------------------------------------
func CreateButton (index, screenX, screenY):
	ButtonSelectedByKeyboard = 0

	Buttons.ButtonIndex[NumberOfButtonsOnScreen] = index
	Buttons.ButtonScreenX[NumberOfButtonsOnScreen] = screenX
	Buttons.ButtonScreenY[NumberOfButtonsOnScreen] = screenY
	Buttons.ButtonAnimationTimer[NumberOfButtonsOnScreen] = -1
	Buttons.ButtonScale[NumberOfButtonsOnScreen] = 1.0

	NumberOfButtonsOnScreen+=1

	pass

#----------------------------------------------------------------------------------------
func DrawAllButtons():
	if NumberOfButtonsOnScreen == 0:  return

	for index in range(0, NumberOfButtonsOnScreen):
		if Buttons.ButtonIndex[index] > -1:
			if Buttons.ButtonAnimationTimer[index] == 1:
				Buttons.ButtonScale[index] = 0.95
				VisualsCore.DrawText(Buttons.ButtonIndex[index], ButtonText[Buttons.ButtonIndex[index]], VisualsCore.Texts.TextScreenX[Buttons.ButtonIndex[index]], VisualsCore.Texts.TextScreenY[Buttons.ButtonIndex[index]], 1, 22, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)
			elif Buttons.ButtonAnimationTimer[index] == 0:
				Buttons.ButtonScale[index] = 1.0
				VisualsCore.DrawText(Buttons.ButtonIndex[index], ButtonText[Buttons.ButtonIndex[index]], VisualsCore.Texts.TextScreenX[Buttons.ButtonIndex[index]], VisualsCore.Texts.TextScreenY[Buttons.ButtonIndex[index]], 1, 24, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

			VisualsCore.DrawSprite(40+index, Buttons.ButtonScreenX[index], Buttons.ButtonScreenY[index], Buttons.ButtonScale[index], Buttons.ButtonScale[index], 0.0, 1.0, 1.0, 1.0, 1.0)

			if (index == ButtonSelectedByKeyboard && NumberOfButtonsOnScreen > 1 && ScreensCore.OperatingSys != ScreensCore.OSAndroid):
				VisualsCore.DrawSprite(50, (VisualsCore.ScreenWidth/2.0)-154.0, Buttons.ButtonScreenY[index], 1.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0)
				VisualsCore.DrawSprite(51, (VisualsCore.ScreenWidth/2.0)+154.0, Buttons.ButtonScreenY[index], 1.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0)

		var textHeight = VisualsCore.Texts.TextImage[index].get_theme_font("normal_font").get_string_size(VisualsCore.Texts.TextImage[index].text).y
		VisualsCore.Texts.TextImage[Buttons.ButtonIndex[index]].global_position.y = (Buttons.ButtonScreenY[index]-(textHeight / 2) - 12)

		if (ScreensCore.ScreenToDisplay != ScreensCore.NewHighScoreScreen):
			for indexTwo in range(40, 50):
				RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[indexTwo], Color(1.0, 1.0, 1.0, 1.0))
		elif (ScreensCore.ScreenToDisplay == ScreensCore.NewHighScoreScreen):
			for indexThree in range(40, 50):
				if (ScreensCore.NewHighScoreNameInputJoyY == 5):
					RenderingServer.canvas_item_set_modulate(VisualsCore.Sprites.ci_rid[indexThree], Color(0.0, 1.0, 1.0, 1.0))

	pass

#----------------------------------------------------------------------------------------
func ThisButtonWasPressed(buttonToCheck):
	if NumberOfButtonsOnScreen == 0:  return false

	for index in range (0, NumberOfButtonsOnScreen):
		if index == buttonToCheck:
			if (InputCore.DelayAllUserInput < 1):
				if InputCore.JoystickDirection[InputCore.InputAny] == InputCore.JoyUp && NumberOfButtonsOnScreen > 1:
					if ButtonSelectedByKeyboard > 0:
						ButtonSelectedByKeyboard-=1
					else:
						ButtonSelectedByKeyboard = NumberOfButtonsOnScreen-1

					AudioCore.PlayEffect(1, 0)

					InputCore.DelayAllUserInput = 4
				elif InputCore.JoystickDirection[InputCore.InputAny] == InputCore.JoyDown && NumberOfButtonsOnScreen > 1:
					if ButtonSelectedByKeyboard < (NumberOfButtonsOnScreen-1):
						ButtonSelectedByKeyboard+=1
					else:
						ButtonSelectedByKeyboard = 0

					AudioCore.PlayEffect(1, 0)

					InputCore.DelayAllUserInput = 4

				if ( (ScreensCore.ScreenToDisplay == ScreensCore.OptionsScreen) && (InputCore.JoyButtonOne[InputCore.InputJoyOne] == InputCore.Pressed && InputCore.JoyButtonOnePressedCounter[InputCore.InputJoyOne][0] < 30) ):
					if buttonToCheck == ButtonSelectedByKeyboard:
						Buttons.ButtonAnimationTimer[ButtonSelectedByKeyboard] = 2
						AudioCore.PlayEffect(1, 1)
						InputCore.DelayAllUserInput = 30
				elif ( (ScreensCore.ScreenToDisplay == ScreensCore.OptionsScreen) && (InputCore.JoyButtonOne[InputCore.InputJoyTwo] == InputCore.Pressed && InputCore.JoyButtonOnePressedCounter[InputCore.InputJoyTwo][0] < 30) ):
					if buttonToCheck == ButtonSelectedByKeyboard:
						Buttons.ButtonAnimationTimer[ButtonSelectedByKeyboard] = 2
						AudioCore.PlayEffect(1, 1)
						InputCore.DelayAllUserInput = 30
				elif ( (ScreensCore.ScreenToDisplay == ScreensCore.OptionsScreen) && (InputCore.JoyButtonOne[InputCore.InputJoyThree] == InputCore.Pressed && InputCore.JoyButtonOnePressedCounter[InputCore.InputJoyThree][0] < 30) ):
					if buttonToCheck == ButtonSelectedByKeyboard:
						Buttons.ButtonAnimationTimer[ButtonSelectedByKeyboard] = 2
						AudioCore.PlayEffect(1, 1)
						InputCore.DelayAllUserInput = 30
				elif ( (ScreensCore.ScreenToDisplay != ScreensCore.OptionsScreen && ScreensCore.ScreenToDisplay != ScreensCore.NewHighScoreScreen) && (InputCore.JoyButtonOne[InputCore.InputAny] == InputCore.Pressed) ):
					if buttonToCheck == ButtonSelectedByKeyboard:
						Buttons.ButtonAnimationTimer[ButtonSelectedByKeyboard] = 2
						AudioCore.PlayEffect(1, 1)
						InputCore.DelayAllUserInput = 30
				elif ( (ScreensCore.ScreenToDisplay != ScreensCore.NewHighScoreScreen) && (InputCore.KeyboardEnterPressed == true || InputCore.KeyboardSpacebarPressed == true) ):
					if buttonToCheck == ButtonSelectedByKeyboard:
						Buttons.ButtonAnimationTimer[ButtonSelectedByKeyboard] = 2
						AudioCore.PlayEffect(1, 1)
						InputCore.DelayAllUserInput = 15
				elif ( (ScreensCore.ScreenToDisplay == ScreensCore.NewHighScoreScreen) && (InputCore.KeyboardEnterPressed == true) ):
					if buttonToCheck == ButtonSelectedByKeyboard:
						Buttons.ButtonAnimationTimer[ButtonSelectedByKeyboard] = 2
						AudioCore.PlayEffect(1, 1)
						InputCore.DelayAllUserInput = 15

				if InputCore.MouseButtonLeftPressed == true:
					var _addVerticalMobile = 0

					if InputCore.MouseScreenY > (Buttons.ButtonScreenY[index]-30) && InputCore.MouseScreenY < (Buttons.ButtonScreenY[index]+30) && InputCore.MouseScreenX > (Buttons.ButtonScreenX[index]-127) && InputCore.MouseScreenX < (Buttons.ButtonScreenX[index]+127):
						ButtonSelectedByKeyboard = index
						Buttons.ButtonAnimationTimer[ButtonSelectedByKeyboard] = 2
						AudioCore.PlayEffect(1, 1)
						InputCore.DelayAllUserInput = 15

			if Buttons.ButtonAnimationTimer[index] > -1:
				Buttons.ButtonAnimationTimer[index]-=1
				if Buttons.ButtonAnimationTimer[index] == -1:  return true

	pass

#----------------------------------------------------------------------------------------
func CreateArrowSet(index, screenY):
	if ArrowSetSelectedByKeyboardLast == -1:
		ArrowSetSelectedByKeyboard = 0
	else:  ArrowSetSelectedByKeyboard = ArrowSetSelectedByKeyboardLast
	
	ArrowSets.ArrowSetIndex[NumberOfArrowSetsOnScreen] = index
	ArrowSets.ArrowSetScreenY[NumberOfArrowSetsOnScreen] = screenY
	ArrowSets.ArrowSetLeftAnimationTimer[NumberOfArrowSetsOnScreen] = -1
	ArrowSets.ArrowSetRightAnimationTimer[NumberOfArrowSetsOnScreen] = -1
	ArrowSets.ArrowSetLeftScale[NumberOfArrowSetsOnScreen] = 1.0
	ArrowSets.ArrowSetRightScale[NumberOfArrowSetsOnScreen] = 1.0

	NumberOfArrowSetsOnScreen+=1

	pass

#----------------------------------------------------------------------------------------
func DrawAllArrowSets():
	if NumberOfArrowSetsOnScreen == 0:  return

	for index in range(0, NumberOfArrowSetsOnScreen):
		if ArrowSets.ArrowSetIndex[index] > -1:
			VisualsCore.DrawSprite(70+(index*2), VisualsCore.ScreenWidth-30, ArrowSets.ArrowSetScreenY[index], 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
			VisualsCore.DrawSprite(71+(index*2), 30, ArrowSets.ArrowSetScreenY[index], 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			if ArrowSets.ArrowSetLeftAnimationTimer[(index*2)] == 3:
				VisualsCore.DrawSprite(71+(index*2), 30, ArrowSets.ArrowSetScreenY[index], 0.85, 0.85, 0, 1.0, 1.0, 1.0, 1.0)
			elif ArrowSets.ArrowSetLeftAnimationTimer[(index*2)] == 2:
				VisualsCore.DrawSprite(71+(index*2), 30, ArrowSets.ArrowSetScreenY[index], 0.9, 0.9, 0, 1.0, 1.0, 1.0, 1.0)
			elif ArrowSets.ArrowSetLeftAnimationTimer[(index*2)] == 1:
				VisualsCore.DrawSprite(71+(index*2), 30, ArrowSets.ArrowSetScreenY[index], 0.95, 0.95, 0, 1.0, 1.0, 1.0, 1.0)
			elif ArrowSets.ArrowSetLeftAnimationTimer[(index*2)] == 0:
				VisualsCore.DrawSprite(71+(index*2), 30, ArrowSets.ArrowSetScreenY[index], 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

			if ArrowSets.ArrowSetRightAnimationTimer[(index*2)] == 3:
				VisualsCore.DrawSprite(70+(index*2),  VisualsCore.ScreenWidth-30, ArrowSets.ArrowSetScreenY[index], 0.85, 0.85, 0, 1.0, 1.0, 1.0, 1.0)
			elif ArrowSets.ArrowSetRightAnimationTimer[(index*2)] == 2:
				VisualsCore.DrawSprite(70+(index*2),  VisualsCore.ScreenWidth-30, ArrowSets.ArrowSetScreenY[index], 0.9, 0.9, 0, 1.0, 1.0, 1.0, 1.0)
			elif ArrowSets.ArrowSetRightAnimationTimer[(index*2)] == 1:
				VisualsCore.DrawSprite(70+(index*2),  VisualsCore.ScreenWidth-30, ArrowSets.ArrowSetScreenY[index], 0.95, 0.95, 0, 1.0, 1.0, 1.0, 1.0)
			elif ArrowSets.ArrowSetRightAnimationTimer[(index*2)] == 0:
				VisualsCore.DrawSprite(70+(index*2),  VisualsCore.ScreenWidth-30, ArrowSets.ArrowSetScreenY[index], 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

	VisualsCore.DrawSprite(60, VisualsCore.ScreenWidth/2.0, ArrowSets.ArrowSetScreenY[ArrowSetSelectedByKeyboard], 1.0, 1.0, 0, 1.0, 1.0, 1.0, 0.3)

	pass

#----------------------------------------------------------------------------------------
func ThisArrowWasPressed(arrowToCheck):
	if NumberOfArrowSetsOnScreen == 0:  return false

	var arrowSetToCheck = -1
	for index in range(0, NumberOfArrowSetsOnScreen):
		if ArrowSets.ArrowSetLeftAnimationTimer[(index*2)] > -1:
			arrowSetToCheck = index
		elif ArrowSets.ArrowSetRightAnimationTimer[(index*2)] > -1:
			arrowSetToCheck = (index+0.5)

	if (arrowSetToCheck == arrowToCheck):
		if ArrowSets.ArrowSetLeftAnimationTimer[(arrowSetToCheck*2)] > -1:
			ArrowSets.ArrowSetLeftAnimationTimer[(arrowSetToCheck*2)]-=1
			if (ArrowSets.ArrowSetLeftAnimationTimer[(arrowSetToCheck*2)] == 0 && arrowToCheck == (arrowSetToCheck)):  return true
		elif ArrowSets.ArrowSetRightAnimationTimer[(floor(arrowSetToCheck)*2)] > -1:
			ArrowSets.ArrowSetRightAnimationTimer[(floor(arrowSetToCheck)*2)]-=1
			if (ArrowSets.ArrowSetRightAnimationTimer[(floor(arrowSetToCheck)*2)] == 0 && arrowToCheck == (arrowSetToCheck)):  return true

	if InputCore.DelayAllUserInput > 0:  return false

	if InputCore.MouseButtonLeftPressed == true:
		for index in range(0, NumberOfArrowSetsOnScreen):
			if ArrowSets.ArrowSetIndex[index] > -1:
				if InputCore.MouseScreenY > (ArrowSets.ArrowSetScreenY[index]-21) && InputCore.MouseScreenY < (ArrowSets.ArrowSetScreenY[index]+21) && InputCore.MouseScreenX > (30-25) && InputCore.MouseScreenX < (30+25):
					ArrowSetSelectedByKeyboard = index

					InputCore.JoystickDirection[InputCore.InputAny] = InputCore.JoyLeft
				elif InputCore.MouseScreenY > (ArrowSets.ArrowSetScreenY[index]-21) && InputCore.MouseScreenY < (ArrowSets.ArrowSetScreenY[index]+21) && InputCore.MouseScreenX > ((VisualsCore.ScreenWidth-30)-25) && InputCore.MouseScreenX < ((VisualsCore.ScreenWidth-30)+25):
					ArrowSetSelectedByKeyboard = index

					InputCore.JoystickDirection[InputCore.InputAny] = InputCore.JoyRight

	if InputCore.JoystickDirection[InputCore.InputAny] == InputCore.JoyLeft && ArrowSetSelectedByKeyboard == arrowToCheck:
		ArrowSets.ArrowSetLeftAnimationTimer[(ArrowSetSelectedByKeyboard*2)] = 3
		InputCore.DelayAllUserInput = 7
		ArrowSetSelectedByKeyboardLast = ArrowSetSelectedByKeyboard
		AudioCore.PlayEffect(1, 0)
	elif InputCore.JoystickDirection[InputCore.InputAny] == InputCore.JoyRight && (ArrowSetSelectedByKeyboard+0.5) == arrowToCheck:
		ArrowSets.ArrowSetRightAnimationTimer[(ArrowSetSelectedByKeyboard*2)] = 3
		InputCore.DelayAllUserInput = 7
		ArrowSetSelectedByKeyboardLast = ArrowSetSelectedByKeyboard
		AudioCore.PlayEffect(1, 0)
	elif InputCore.JoystickDirection[InputCore.InputAny] == InputCore.JoyUp && NumberOfArrowSetsOnScreen > 1:
		if ArrowSetSelectedByKeyboard > 0:
			ArrowSetSelectedByKeyboard-=1
		else:  ArrowSetSelectedByKeyboard = (NumberOfArrowSetsOnScreen-1)
		ArrowSetSelectedByKeyboardLast = ArrowSetSelectedByKeyboard

		RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[60], Transform2D(VisualsCore.Sprites.SpriteRotation[60], Vector2(0.85, 0.85), 0.0, Vector2(VisualsCore.ScreenWidth/2.0, ArrowSets.ArrowSetScreenY[ArrowSetSelectedByKeyboard])))

		AudioCore.PlayEffect(1, 0)
		InputCore.DelayAllUserInput = 7
	elif InputCore.JoystickDirection[InputCore.InputAny] == InputCore.JoyDown && NumberOfArrowSetsOnScreen > 1:
		if ArrowSetSelectedByKeyboard < (NumberOfArrowSetsOnScreen-1):
			ArrowSetSelectedByKeyboard+=1
		else:  ArrowSetSelectedByKeyboard = 0
		ArrowSetSelectedByKeyboardLast = ArrowSetSelectedByKeyboard
		
		RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[60], Transform2D(VisualsCore.Sprites.SpriteRotation[60], Vector2(0.85, 0.85), 0.0, Vector2(VisualsCore.ScreenWidth/2.0, ArrowSets.ArrowSetScreenY[ArrowSetSelectedByKeyboard])))

		AudioCore.PlayEffect(1, 0)
		InputCore.DelayAllUserInput = 7
	pass

#----------------------------------------------------------------------------------------
func CreateIcon(spriteIndex, screenX, screenY, text):
	Icons.IconIndex[NumberOfIconsOnScreen] = NumberOfIconsOnScreen
	Icons.IconSprite[NumberOfIconsOnScreen] = spriteIndex
	Icons.IconScreenX[NumberOfIconsOnScreen] = screenX
	Icons.IconScreenY[NumberOfIconsOnScreen] = screenY
	Icons.IconAnimationTimer[NumberOfIconsOnScreen] = -1
	Icons.IconScale[NumberOfIconsOnScreen] = 1.0

	RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[Icons.IconSprite[NumberOfIconsOnScreen]], Transform2D(0.0, Vector2(1.0, 1.0), 0.0, Vector2(VisualsCore.Sprites.SpriteScreenX[Icons.IconSprite[NumberOfIconsOnScreen]] - (VisualsCore.Sprites.SpriteImageWidth[Icons.IconSprite[NumberOfIconsOnScreen]] / 2.0), VisualsCore.Sprites.SpriteScreenY[Icons.IconSprite[NumberOfIconsOnScreen]] - (VisualsCore.Sprites.SpriteImageHeight[Icons.IconSprite[NumberOfIconsOnScreen]] / 2.0))))

	Icons.IconText[NumberOfIconsOnScreen] = text
	Icons.IconTextIndex[NumberOfIconsOnScreen] = VisualsCore.DrawText(VisualsCore.TextCurrentIndex, text, (screenX-3.0)-(VisualsCore.ScreenWidth/2.0), screenY-23, 1, 35, 1.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0)

	NumberOfIconsOnScreen+=1

	pass

#----------------------------------------------------------------------------------------
func DrawAllIcons():
	if NumberOfIconsOnScreen == 0: return

	for index in range (0, NumberOfIconsOnScreen):
		if (ScreensCore.ScreenToDisplay == ScreensCore.PlayingGameScreen && ScreensCore.DontDisplayJoinIn == true):
			if (Icons.IconSprite[index] == 119):
				Icons.IconScreenX[index] = -9999
				Icons.IconScreenY[index] = -9999
				RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[Icons.IconSprite[index]], Transform2D(0.0, Vector2(0.85, 0.85), 0.0, Vector2(-9999, -9999)))#Vector2(Icons.IconScreenX[index] - ((VisualsCore.Sprites.SpriteImageWidth[Icons.IconSprite[index]]*0.85) / 2.0), Icons.IconScreenY[index] - ((VisualsCore.Sprites.SpriteImageHeight[Icons.IconSprite[index]]*0.85) / 2.0))))

		RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[Icons.IconSprite[index]], Transform2D(0.0, Vector2(1.0, 1.0), 0.0, Vector2(Icons.IconScreenX[index] - (VisualsCore.Sprites.SpriteImageWidth[Icons.IconSprite[index]] / 2.0), Icons.IconScreenY[index] - (VisualsCore.Sprites.SpriteImageHeight[Icons.IconSprite[index]] / 2.0))))

		if Icons.IconAnimationTimer[index] == 3:
			RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[Icons.IconSprite[index]], Transform2D(0.0, Vector2(0.85, 0.85), 0.0, Vector2(Icons.IconScreenX[index] - ((VisualsCore.Sprites.SpriteImageWidth[Icons.IconSprite[index]]*0.85) / 2.0), Icons.IconScreenY[index] - ((VisualsCore.Sprites.SpriteImageHeight[Icons.IconSprite[index]]*0.85) / 2.0))))
			if (ScreensCore.ScreenToDisplay == ScreensCore.NewHighScoreScreen):
				VisualsCore.DrawnTextChangeScaleRotation(Icons.IconTextIndex[index], 0.85, 0.85, 0)
		elif Icons.IconAnimationTimer[index] == 2:
			RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[Icons.IconSprite[index]], Transform2D(0.0, Vector2(0.90, 0.90), 0.0, Vector2(Icons.IconScreenX[index] - ((VisualsCore.Sprites.SpriteImageWidth[Icons.IconSprite[index]]*0.90) / 2.0), Icons.IconScreenY[index] - ((VisualsCore.Sprites.SpriteImageHeight[Icons.IconSprite[index]]*0.90) / 2.0))))
			if (ScreensCore.ScreenToDisplay == ScreensCore.NewHighScoreScreen):
				VisualsCore.DrawnTextChangeScaleRotation(Icons.IconTextIndex[index], 0.9, 0.9, 0)
		elif Icons.IconAnimationTimer[index] == 1:
			RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[Icons.IconSprite[index]], Transform2D(0.0, Vector2(0.95, 0.95), 0.0, Vector2(Icons.IconScreenX[index] - ((VisualsCore.Sprites.SpriteImageWidth[Icons.IconSprite[index]]*0.90) / 2.0), Icons.IconScreenY[index] - ((VisualsCore.Sprites.SpriteImageHeight[Icons.IconSprite[index]]*0.95) / 2.0))))
			if (ScreensCore.ScreenToDisplay == ScreensCore.NewHighScoreScreen):
				VisualsCore.DrawnTextChangeScaleRotation(Icons.IconTextIndex[index], 0.95, 0.95, 0)
		elif Icons.IconAnimationTimer[index] == 0:
			RenderingServer.canvas_item_set_transform(VisualsCore.Sprites.ci_rid[Icons.IconSprite[index]], Transform2D(0.0, Vector2(1.0, 1.0), 0.0, Vector2(Icons.IconScreenX[index] - ((VisualsCore.Sprites.SpriteImageWidth[Icons.IconSprite[index]]*1.0) / 2.0), Icons.IconScreenY[index] - ((VisualsCore.Sprites.SpriteImageHeight[Icons.IconSprite[index]]*1.0) / 2.0))))
			if (ScreensCore.ScreenToDisplay == ScreensCore.NewHighScoreScreen):
				VisualsCore.DrawnTextChangeScaleRotation(Icons.IconTextIndex[index], 1.0, 1.0, 0)

	pass

#----------------------------------------------------------------------------------------
func ThisIconWasPressed(iconToCheck):
	if NumberOfIconsOnScreen == 0:  return false

	if Icons.IconAnimationTimer[iconToCheck] == 3:
		Icons.IconAnimationTimer[iconToCheck]-=1
	elif Icons.IconAnimationTimer[iconToCheck] == 2:
		Icons.IconAnimationTimer[iconToCheck]-=1
	elif Icons.IconAnimationTimer[iconToCheck] == 1:
		Icons.IconAnimationTimer[iconToCheck]-=1
	elif Icons.IconAnimationTimer[iconToCheck] == 0:
		Icons.IconAnimationTimer[iconToCheck] = -1

		if (ScreensCore.ScreenToDisplay != ScreensCore.PlayingGameScreen):
			return true

	if ( ScreensCore.ScreenToDisplay != ScreensCore.PlayingGameScreen || (Icons.IconSprite[iconToCheck] == 101 || Icons.IconSprite[iconToCheck] == 102) ):
		if InputCore.DelayAllUserInput > 0:  return false

	if (ScreensCore.OperatingSys == ScreensCore.OSHTMLFive):
		if InputCore.MouseButtonLeftPressed == true:
			var sprH = (VisualsCore.Sprites.SpriteImageHeight[Icons.IconSprite[iconToCheck]]/2)
			var sprW = (VisualsCore.Sprites.SpriteImageWidth[Icons.IconSprite[iconToCheck]]/2)
			if (InputCore.MouseScreenY > (Icons.IconScreenY[iconToCheck]-sprH) && InputCore.MouseScreenY < (Icons.IconScreenY[iconToCheck]+sprH) && InputCore.MouseScreenX > (Icons.IconScreenX[iconToCheck]-sprW) && InputCore.MouseScreenX < (Icons.IconScreenX[iconToCheck]+sprW)):
				if (ScreensCore.ScreenToDisplay != ScreensCore.PlayingGameScreen):
					Icons.IconAnimationTimer[iconToCheck] = 3
					if (ScreensCore.ScreenToDisplay != ScreensCore.NewHighScoreScreen):
						AudioCore.PlayEffect(1, 0)

					InputCore.DelayAllUserInput = 20
				else:
					Icons.IconAnimationTimer[iconToCheck] = 3
					return true
	elif (ScreensCore.OperatingSys != ScreensCore.OSAndroid):
		if InputCore.MouseButtonLeftPressed == true:
			var sprH = (VisualsCore.Sprites.SpriteImageHeight[Icons.IconSprite[iconToCheck]]/2)
			var sprW = (VisualsCore.Sprites.SpriteImageWidth[Icons.IconSprite[iconToCheck]]/2)
			if (InputCore.MouseScreenY > (Icons.IconScreenY[iconToCheck]-sprH) && InputCore.MouseScreenY < (Icons.IconScreenY[iconToCheck]+sprH) && InputCore.MouseScreenX > (Icons.IconScreenX[iconToCheck]-sprW) && InputCore.MouseScreenX < (Icons.IconScreenX[iconToCheck]+sprW)):
				if (ScreensCore.ScreenToDisplay != ScreensCore.PlayingGameScreen):
					Icons.IconAnimationTimer[iconToCheck] = 3
					if (ScreensCore.ScreenToDisplay != ScreensCore.NewHighScoreScreen):
						AudioCore.PlayEffect(1, 0)

					InputCore.DelayAllUserInput = 20
				else:
					Icons.IconAnimationTimer[iconToCheck] = 3
					return true
	elif (ScreensCore.OperatingSys == ScreensCore.OSAndroid):
		if (ScreensCore.ScreenToDisplay != ScreensCore.PlayingGameScreen):
			if InputCore.MouseButtonLeftPressed == true:
				var sprH = (VisualsCore.Sprites.SpriteImageHeight[Icons.IconSprite[iconToCheck]]/2)
				var sprW = (VisualsCore.Sprites.SpriteImageWidth[Icons.IconSprite[iconToCheck]]/2)

				if (InputCore.MouseScreenY > (Icons.IconScreenY[iconToCheck]-sprH) && InputCore.MouseScreenY < (Icons.IconScreenY[iconToCheck]+sprH) && InputCore.MouseScreenX > (Icons.IconScreenX[iconToCheck]-sprW) && InputCore.MouseScreenX < (Icons.IconScreenX[iconToCheck]+sprW)):
					InputCore.DelayAllUserInput = 20
					Icons.IconAnimationTimer[iconToCheck] = 3
		elif (ScreensCore.ScreenToDisplay == ScreensCore.PlayingGameScreen):
			var sprH = (VisualsCore.Sprites.SpriteImageHeight[Icons.IconSprite[iconToCheck]]/2)
			var sprW = (VisualsCore.Sprites.SpriteImageWidth[Icons.IconSprite[iconToCheck]]/2)

			for index in range(0, 5):
				if (InputCore.AndroidTouchOnePressed[index] == true):
					if (InputCore.AndroidTouchOnePressedY[index] > (Icons.IconScreenY[iconToCheck]-sprH) && InputCore.AndroidTouchOnePressedY[index] < (Icons.IconScreenY[iconToCheck]+sprH) && InputCore.AndroidTouchOnePressedX[index] > (Icons.IconScreenX[iconToCheck]-sprW) && InputCore.AndroidTouchOnePressedX[index] < (Icons.IconScreenX[iconToCheck]+sprW)):
						Icons.IconAnimationTimer[iconToCheck] = 3
						return true

	return false

#----------------------------------------------------------------------------------------
func DeleteAllGUI():
	ButtonSelectedByKeyboard = 0

	for index in range (0, 10):
		Buttons.ButtonIndex[index] = -1
		Buttons.ButtonScreenX[index] = -99999
		Buttons.ButtonScreenY[index] = -99999
		Buttons.ButtonAnimationTimer[index] = -1
		Buttons.ButtonScale[index] = 1.0

		VisualsCore.Texts.TextImage[index].global_position.y = -99999

	NumberOfButtonsOnScreen = 0
	ArrowSetSelectedByKeyboard = 0

	for index in range (0, NumberOfArrowSetsOnScreen):
		ArrowSets.ArrowSetIndex[index] = -1
		ArrowSets.ArrowSetScreenY[index] = -99999
		ArrowSets.ArrowSetLeftAnimationTimer[index] = 0
		ArrowSets.ArrowSetRightAnimationTimer[index] = 0
		ArrowSets.ArrowSetLeftScale[index] = 1.0
		ArrowSets.ArrowSetRightScale[index] = 1.0

	NumberOfArrowSetsOnScreen = 0

	for index in range(0, NumberOfIconsOnScreen):
		Icons.IconIndex[index] = -1
		Icons.IconSprite[index] = -1
		Icons.IconScreenX[index] = -99999
		Icons.IconScreenY[index] = -99999
		Icons.IconAnimationTimer[index] = -1
		Icons.IconScale[index] = 1.0
		Icons.IconText[index] = " "

	NumberOfIconsOnScreen = 0

	pass

#----------------------------------------------------------------------------------------
func _process(_delta):

	pass
