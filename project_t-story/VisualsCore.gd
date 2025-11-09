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

# "VisualsCore.gd"
extends Node2D

var DEBUG = true

var FramesPerSecondArrayIndex = 0
var FramesPerSecondArray = []
var FramesPerSecondAverage = 0
var FramesPerSecondLastSecondTick = Time.get_ticks_msec()
var FramesPerSecondFrames = 0

class FPSClass:
	var TextImage = []
	var TextIndex = []
	var TextScreenX = []
	var TextScreenY = []
	var TextHorizontalJustification = []
	var TextSize = []
	var TextScaleX = []
	var TextScaleY = []
	var TextRotation = []
	var TextColorRed  = []
	var TextColorGreen = []
	var TextColorBlue = []
	var TextColorAlpha = []
	var TextOutlineRed = []
	var TextOutlineGreen = []
	var TextOutlineBlue = []
var FramesPerSecondText = FPSClass.new()

var ScreenWidth = 1024
var ScreenHeight = 640

class SpriteClass:
	var ci_rid = []
	var SpriteImage = []
	var SpriteImageWidth = []
	var SpriteImageHeight = []
	var SpriteActive = []
	var SpriteScreenX = []
	var SpriteScreenY = []
	var SpriteScaleX = []
	var SpriteScaleY = []
	var SpriteRotation = []
	var SpriteColorRed = []
	var SpriteColorGreen = []
	var SpriteColorBlue = []
	var SpriteColorAlpha = []
var Sprites = SpriteClass.new()

var FontTTF = []

var TextIsUsed = []

var TextCurrentIndex;

class TextClass:
	var TextImage = []
	var TextIndex = []
	var TextScreenX = []
	var TextScreenY = []
	var TextHorizontalJustification = []
	var TextSize = []
	var TextScaleX = []
	var TextScaleY = []
	var TextRotation = []
	var TextColorRed  = []
	var TextColorGreen = []
	var TextColorBlue = []
	var TextColorAlpha = []
	var TextOutlineRed = []
	var TextOutlineGreen = []
	var TextOutlineBlue = []
var Texts = TextClass.new()

class AboutText:
	var AboutTextsText = []
	var AboutTextsBlue = []
var AboutTexts = AboutText.new()

var AboutTextsStartIndex
var AboutTextsEndIndex

var PieceSpriteCurrentIndex = []
var PlayfieldSpriteCurrentIndex = []

var KeyboardControlsAlphaTimer;

var KeepAspectRatio
var FullScreenMode

#----------------------------------------------------------------------------------------
func _ready():
	for _index in range(0, 10):
		FramesPerSecondArray.append(0)

	for _index in range(0, 20001):
		Sprites.ci_rid.append(-1)
		Sprites.ci_rid[_index] = RenderingServer.canvas_item_create()
		RenderingServer.canvas_item_set_parent(Sprites.ci_rid[_index], get_canvas_item())
		Sprites.SpriteImage.append(-1)
		Sprites.SpriteImageWidth.append(0)
		Sprites.SpriteImageHeight.append(0)
		Sprites.SpriteActive.append(false)
		Sprites.SpriteScreenX.append(-99999)
		Sprites.SpriteScreenY.append(-99999)
		Sprites.SpriteScaleX.append(1.0)
		Sprites.SpriteScaleY.append(1.0)
		Sprites.SpriteRotation.append(0)
		Sprites.SpriteColorRed.append(1.0)
		Sprites.SpriteColorGreen.append(1.0)
		Sprites.SpriteColorBlue.append(1.0)
		Sprites.SpriteColorAlpha.append(1.0)

	for _index in range(0, 1000):
		TextIsUsed.append(false)

	Sprites.SpriteImage[0] = load("res://media/images/backgrounds/FadingBlackBG.png")
	Sprites.SpriteActive[0] = true

	Sprites.SpriteImage[5] = load("res://media/images/logos/GodotLogo.png")
	Sprites.SpriteActive[5] = true

	Sprites.SpriteImage[7] = load("res://media/images/logos/BetaMaxHeroes_Logo.png")
	Sprites.SpriteActive[7] = true

	Sprites.SpriteImage[10] = load("res://media/images/backgrounds/BG_Title.png")
	Sprites.SpriteActive[10] = true

	Sprites.SpriteImage[21] = load("res://media/images/logos/Logo2.png")
	Sprites.SpriteActive[21] = true

	Sprites.SpriteImage[23] = load("res://media/images/backgrounds/TS1.png")
	Sprites.SpriteActive[23] = true

	for index in range(30, 40):
		Sprites.SpriteImage[index] = load("res://media/images/gui/ScreenLine.png")
		Sprites.SpriteActive[index] = true

	for index in range(40, 50):
		Sprites.SpriteImage[index] = load("res://media/images/gui/Button2.png")
		Sprites.SpriteActive[index] = true

	Sprites.SpriteImage[50] = load("res://media/images/gui/ButtonSelectorLeft.png")
	Sprites.SpriteActive[50] = true
	Sprites.SpriteImage[51] = load("res://media/images/gui/ButtonSelectorRight.png")
	Sprites.SpriteActive[51] = true

	Sprites.SpriteImage[60] = load("res://media/images/gui/SelectorLine.png")
	Sprites.SpriteActive[60] = true

	for index in range(70, 100, 2):
		Sprites.SpriteImage[index] = load("res://media/images/gui/ButtonSelectorLeft.png")
		Sprites.SpriteActive[index] = true
		Sprites.SpriteImage[index+1] = load("res://media/images/gui/ButtonSelectorRight.png")
		Sprites.SpriteActive[index+1] = true

	Sprites.SpriteImage[101] = load("res://media/images/gui/SwitchPlayfield.png")
	Sprites.SpriteActive[101] = true

	Sprites.SpriteImage[102] = load("res://media/images/gui/SwitchPlayfield.png")
	Sprites.SpriteActive[102] = true

	Sprites.SpriteImage[105] = load("res://media/images/gui/Pause.png")
	Sprites.SpriteActive[105] = true

	Sprites.SpriteImage[106] = load("res://media/images/gui/Play.png")
	Sprites.SpriteActive[106] = true

	Sprites.SpriteImage[110] = load("res://media/images/gui/SpeakerOFF.png")
	Sprites.SpriteActive[110] = true
	Sprites.SpriteImage[111] = load("res://media/images/gui/SpeakerON.png")
	Sprites.SpriteActive[111] = true

	Sprites.SpriteImage[117] = load("res://media/images/gui/Exit2.png")
	Sprites.SpriteActive[117] = true

	Sprites.SpriteImage[119] = load("res://media/images/gui/JoinIn.png")
	Sprites.SpriteActive[119] = true

	Sprites.SpriteImage[120] = load("res://media/images/gui/IconLeft.png")
	Sprites.SpriteActive[120] = true
	Sprites.SpriteImage[121] = load("res://media/images/gui/IconRight.png")
	Sprites.SpriteActive[121] = true
	Sprites.SpriteImage[122] = load("res://media/images/gui/IconDown.png")
	Sprites.SpriteActive[122] = true
	Sprites.SpriteImage[123] = load("res://media/images/gui/IconRotate.png")
	Sprites.SpriteActive[123] = true

	Sprites.SpriteImage[125] = load("res://media/images/gui/IconLeft.png")
	Sprites.SpriteActive[125] = true
	Sprites.SpriteImage[126] = load("res://media/images/gui/IconRight.png")
	Sprites.SpriteActive[126] = true
	Sprites.SpriteImage[127] = load("res://media/images/gui/IconDown.png")
	Sprites.SpriteActive[127] = true
	Sprites.SpriteImage[128] = load("res://media/images/gui/IconRotate.png")
	Sprites.SpriteActive[128] = true

	Sprites.SpriteImage[130] = load("res://media/images/playing/Board3PlayerNew.png")
	Sprites.SpriteActive[130] = true
	Sprites.SpriteImage[131] = load("res://media/images/playing/Board3PlayerNewBG.png")
	Sprites.SpriteActive[131] = true
	Sprites.SpriteImage[132] = load("res://media/images/playing/BoardDivider.png")
	Sprites.SpriteActive[132] = true
	Sprites.SpriteImage[134] = load("res://media/images/playing/BoardDivider.png")
	Sprites.SpriteActive[134] = true

	Sprites.SpriteImage[135] = load("res://media/images/playing/PauseBG.png")
	Sprites.SpriteActive[135] = true

	Sprites.SpriteImage[136] = load("res://media/images/playing/Pause2BG.png")
	Sprites.SpriteActive[136] = true

	Sprites.SpriteImage[137] = load("res://media/images/playing/JoinIn.png")
	Sprites.SpriteActive[137] = true
	Sprites.SpriteImage[138] = load("res://media/images/playing/JoinIn.png")
	Sprites.SpriteActive[138] = true

	Sprites.SpriteImage[141] = load("res://media/images/story/BG_Story-1.png")
	Sprites.SpriteActive[141] = true
	Sprites.SpriteImage[142] = load("res://media/images/story/BG_Story-2.png")
	Sprites.SpriteActive[142] = true
	Sprites.SpriteImage[143] = load("res://media/images/story/BG_Story-3.png")
	Sprites.SpriteActive[143] = true
	Sprites.SpriteImage[144] = load("res://media/images/story/BG_Story-4.png")
	Sprites.SpriteActive[144] = true
	Sprites.SpriteImage[145] = load("res://media/images/story/BG_Story-5.png")
	Sprites.SpriteActive[145] = true
	Sprites.SpriteImage[146] = load("res://media/images/story/BG_Story-6.png")
	Sprites.SpriteActive[146] = true
	Sprites.SpriteImage[147] = load("res://media/images/story/BG_Story-7.png")
	Sprites.SpriteActive[147] = true
	Sprites.SpriteImage[148] = load("res://media/images/story/BG_Story-8.png")
	Sprites.SpriteActive[148] = true
	Sprites.SpriteImage[149] = load("res://media/images/story/BG_Story-9.png")
	Sprites.SpriteActive[149] = true

	Sprites.SpriteImage[150] = load("res://media/images/story/CutScene-1.png")
	Sprites.SpriteActive[150] = true
	Sprites.SpriteImage[151] = load("res://media/images/story/CutScene-2.png")
	Sprites.SpriteActive[151] = true
	Sprites.SpriteImage[152] = load("res://media/images/story/CutScene-3.png")
	Sprites.SpriteActive[152] = true
	Sprites.SpriteImage[153] = load("res://media/images/story/CutScene-4.png")
	Sprites.SpriteActive[153] = true
	Sprites.SpriteImage[154] = load("res://media/images/story/CutScene-5.png")
	Sprites.SpriteActive[154] = true
	Sprites.SpriteImage[155] = load("res://media/images/story/CutScene-6.png")
	Sprites.SpriteActive[155] = true
	Sprites.SpriteImage[156] = load("res://media/images/story/CutScene-7.png")
	Sprites.SpriteActive[156] = true
	
	Sprites.SpriteImage[157] = load("res://media/images/story/CutScene-8.png")
	Sprites.SpriteActive[157] = true

	Sprites.SpriteImage[158] = load("res://media/images/story/CutScene-9.png")
	Sprites.SpriteActive[158] = true
	
	Sprites.SpriteImage[159] = load("res://media/images/story/CutScene-10.png")
	Sprites.SpriteActive[159] = true
	
	Sprites.SpriteImage[160] = load("res://media/images/story/CutScene-11.png")
	Sprites.SpriteActive[160] = true
	Sprites.SpriteImage[161] = load("res://media/images/story/CutScene-12.png")
	Sprites.SpriteActive[161] = true
	Sprites.SpriteImage[162] = load("res://media/images/story/CutScene-13.png")
	Sprites.SpriteActive[162] = true
	Sprites.SpriteImage[163] = load("res://media/images/story/CutScene-14.png")
	Sprites.SpriteActive[163] = true
	Sprites.SpriteImage[164] = load("res://media/images/story/CutScene-15.png")
	Sprites.SpriteActive[164] = true

	Sprites.SpriteImage[170] = load("res://media/images/story/Sunset.png")
	Sprites.SpriteActive[170] = true
	Sprites.SpriteImage[171] = load("res://media/images/story/Beach.png")
	Sprites.SpriteActive[171] = true
	Sprites.SpriteImage[172] = load("res://media/images/story/Him.png")
	Sprites.SpriteActive[172] = true
	Sprites.SpriteImage[173] = load("res://media/images/story/Her.png")
	Sprites.SpriteActive[173] = true

	for index in range(0, 100):
		Sprites.SpriteImage[200+index] = load("res://media/images/gui/NameInputButton2.png")
		Sprites.SpriteActive[200+index] = true

	var maxIndex = 999
	for index in range(10000, 10000+maxIndex):
		Sprites.SpriteImage[index] = load("res://media/images/playing/BoxRed1.png")
		Sprites.SpriteActive[index] = true

	for index in range(11000, 11000+maxIndex):
		Sprites.SpriteImage[index] = load("res://media/images/playing/BoxOrange1.png")
		Sprites.SpriteActive[index] = true

	for index in range(12000, 12000+maxIndex):
		Sprites.SpriteImage[index] = load("res://media/images/playing/BoxAqua1.png")
		Sprites.SpriteActive[index] = true

	for index in range(13000, 13000+maxIndex):
		Sprites.SpriteImage[index] = load("res://media/images/playing/BoxYellow1.png")
		Sprites.SpriteActive[index] = true

	for index in range(14000, 14000+maxIndex):
		Sprites.SpriteImage[index] = load("res://media/images/playing/BoxGreen1.png")
		Sprites.SpriteActive[index] = true

	for index in range(15000, 15000+maxIndex):
		Sprites.SpriteImage[index] = load("res://media/images/playing/BoxBlue1.png")
		Sprites.SpriteActive[index] = true

	for index in range(16000, 16000+maxIndex):
		Sprites.SpriteImage[index] = load("res://media/images/playing/BoxPurple1.png")
		Sprites.SpriteActive[index] = true

	for index in range(17000, 17000+maxIndex):
		Sprites.SpriteImage[index] = load("res://media/images/playing/BoxWhite1.png")
		Sprites.SpriteActive[index] = true

	var _warnErase = PlayfieldSpriteCurrentIndex.resize(9)
	for index in range (0, 8):
		PlayfieldSpriteCurrentIndex[index] = 0

	maxIndex = (4*3*4)
	for index in range(19000, 19000+maxIndex):
		Sprites.SpriteImage[index] = load("res://media/images/playing/BoxRed1.png")
		Sprites.SpriteActive[index] = true

	for index in range(19100, 19100+maxIndex):
		Sprites.SpriteImage[index] = load("res://media/images/playing/BoxOrange1.png")
		Sprites.SpriteActive[index] = true

	for index in range(19200, 19200+maxIndex):
		Sprites.SpriteImage[index] = load("res://media/images/playing/BoxAqua1.png")
		Sprites.SpriteActive[index] = true

	for index in range(19300, 19300+maxIndex):
		Sprites.SpriteImage[index] = load("res://media/images/playing/BoxYellow1.png")
		Sprites.SpriteActive[index] = true

	for index in range(19400, 19400+maxIndex):
		Sprites.SpriteImage[index] = load("res://media/images/playing/BoxGreen1.png")
		Sprites.SpriteActive[index] = true

	for index in range(19500, 19500+maxIndex):
		Sprites.SpriteImage[index] = load("res://media/images/playing/BoxBlue1.png")
		Sprites.SpriteActive[index] = true

	for index in range(19600, 19600+maxIndex):
		Sprites.SpriteImage[index] = load("res://media/images/playing/BoxPurple1.png")
		Sprites.SpriteActive[index] = true

	for index in range(19700, 19700+maxIndex):
		Sprites.SpriteImage[index] = load("res://media/images/playing/BoxWhite1.png")
		Sprites.SpriteActive[index] = true

	_warnErase = PieceSpriteCurrentIndex.resize(9)
	for index in range (0, 9):
		PieceSpriteCurrentIndex[index] = 0

	Sprites.SpriteImage[19980] = load("res://media/images/playing/KeyboardControls.png")
	Sprites.SpriteActive[19980] = true

	Sprites.SpriteImage[19999] = load("res://media/images/backgrounds/FadingBlackBG.png")
	Sprites.SpriteActive[19999] = true

	for index in range(0, 20001):
		if Sprites.SpriteActive[index] == true:
			var spriteSize = Sprites.SpriteImage[index].get_size()
			Sprites.SpriteImageWidth[index] = spriteSize.x
			Sprites.SpriteImageHeight[index] = spriteSize.y
			RenderingServer.canvas_item_add_texture_rect(Sprites.ci_rid[index], Rect2(Vector2.ZERO, spriteSize), Sprites.SpriteImage[index])
			var xform = Transform2D().translated(Vector2(-99999 - spriteSize.x / 2.0, -99999 - spriteSize.y / 2.0))
			RenderingServer.canvas_item_set_transform(Sprites.ci_rid[index], xform)

			if (index == 0):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 500)
			elif (index == 10):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -25)
			elif (index == 130):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -100)
			elif (index > 39 && index < 49):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -10)
			elif (index > 49 && index < 129):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -3)
			elif (index > 139 && index < 150):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -5)
			elif (index == 170):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -20)
			elif (index == 171):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -15)
			elif (index == 172):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -10)
			elif (index == 173):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -5)
			elif (index > 9999 && index < 19980):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -2)
			elif (index == 131):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], -99999)
			elif (index == 132):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 1)
			elif (index == 134):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 1)
			elif (index == 135):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 250)
			elif (index == 136):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 250)
			elif (index == 19980):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 100)
			elif (index == 20000):
				RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[index], 600)

	FontTTF.append(-1)
	FontTTF[0] = load("res://media/fonts/Font_01.ttf")
	FontTTF.append(-1)
	FontTTF[1] = load("res://media/fonts/Font_02.ttf")
	TextCurrentIndex = 0

	AboutTextsStartIndex = 0
	AboutTextsEndIndex = 0

	RenderingServer.canvas_item_set_transform(Sprites.ci_rid[60], Transform2D().scaled(Vector2(2.845, 1.0)))#xform)

	RenderingServer.canvas_item_set_modulate(Sprites.ci_rid[60], Color(1.0, 1.0, 1.0, 0.4))

	var sprite_size = Sprites.SpriteImage[60].get_size()
	RenderingServer.canvas_item_set_transform(Sprites.ci_rid[60], Transform2D().translated(Vector2(-99999 - sprite_size.x / 2.0, -99999 - sprite_size.y / 2.0)))

	RenderingServer.canvas_item_set_draw_index(Sprites.ci_rid[60], 1000)
	
	DrawSprite(0, VisualsCore.ScreenWidth/2.0, VisualsCore.ScreenHeight/2.0, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)
	FramesPerSecondText.TextImage.append(RichTextLabel.new())
	add_child(FramesPerSecondText.TextImage[0])
	var fontToUseIndex = 1
	var fontSize = 26

	FramesPerSecondText.TextImage[0].text = "30/30"
	FramesPerSecondText.TextImage[0].set_use_bbcode(false)

	FramesPerSecondText.TextImage[0].clip_contents = false
	FramesPerSecondText.TextImage[0].add_theme_font_override("normal_font", FontTTF[fontToUseIndex])
	FramesPerSecondText.TextImage[0].add_theme_font_size_override("normal_font_size", fontSize)
	FramesPerSecondText.TextImage[0].add_theme_color_override("default_color", Color(1.0, 1.0, 1.0, 1.0))
	FramesPerSecondText.TextImage[0].add_theme_constant_override("outline_size", 15.0)
	FramesPerSecondText.TextImage[0].add_theme_color_override("font_outline_color", Color(0.2, 0.2, 0.2, 1.0))

	var textHeight = FramesPerSecondText.TextImage[0].get_theme_font("normal_font").get_string_size(FramesPerSecondText.TextImage[0].text).y

	FramesPerSecondText.TextImage[0].global_position.x = 1
	FramesPerSecondText.TextImage[0].global_position.y = 605
	FramesPerSecondText.TextImage[0].set_size(Vector2(VisualsCore.ScreenWidth, VisualsCore.ScreenHeight), false)
	FramesPerSecondText.TextImage[0].pivot_offset = Vector2((VisualsCore.ScreenWidth / 2.0), (textHeight / 2.0))
	FramesPerSecondText.TextImage[0].scale = Vector2(1.0, 1.0)
	FramesPerSecondText.TextImage[0].rotation = 0.0

	FullScreenMode = false

	pass

#----------------------------------------------------------------------------------------
func SetFramesPerSecond(fpsValue):
	Engine.max_fps = fpsValue
	Engine.physics_ticks_per_second = fpsValue

	pass

#----------------------------------------------------------------------------------------
func SetFullScreenMode():
	if (FullScreenMode == true):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN, 0)
	elif (FullScreenMode == false):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED, 0)

	pass

#----------------------------------------------------------------------------------------
# Godot Version 3.5 To 4.0 Beta 2+ Conversion By: "flairetic":
func SetScreenStretchMode():
	var window = get_tree().root 
	window.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
	if (VisualsCore.KeepAspectRatio == 1):
		window.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP_WIDTH
	elif (VisualsCore.KeepAspectRatio == 0):
		window.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_IGNORE

	pass
#                             Godot Version 3.5 To 4.0 Beta 2+ Conversion By: "flairetic"
#----------------------------------------------------------------------------------------
func MoveAllActiveSpritesOffScreen():
	for index in range(1, 20001):
		if Sprites.SpriteActive[index] == true:
			var sprite_size = Sprites.SpriteImage[index].get_size()
			RenderingServer.canvas_item_set_transform(Sprites.ci_rid[index], Transform2D().translated(Vector2(-99999 - sprite_size.x / 2.0, -99999 - sprite_size.y / 2.0)))

	pass

#----------------------------------------------------------------------------------------
func DrawSprite(index, x, y, scaleX, scaleY, rotationVal, red, green, blue, alpha):
	var sprite_size = Sprites.SpriteImage[index].get_size()
	sprite_size.x = sprite_size.x * scaleX
	sprite_size.y = sprite_size.y * scaleY
	var rotationDegree = ( rotationVal * (180/PI) )

	RenderingServer.canvas_item_set_transform(Sprites.ci_rid[index], Transform2D(rotationDegree, Vector2(scaleX, scaleY), 0.0, Vector2(x - (sprite_size.x / 2.0), y - (sprite_size.y / 2.0))))
	RenderingServer.canvas_item_set_modulate(Sprites.ci_rid[index], Color(red, green, blue, alpha))

	Sprites.SpriteActive[index] = true
	Sprites.SpriteScreenX[index] = x
	Sprites.SpriteScreenY[index] = y
	Sprites.SpriteScaleX[index] = scaleX
	Sprites.SpriteScaleY[index] = scaleY
	Sprites.SpriteRotation[index] = rotationVal
	Sprites.SpriteColorRed[index] = red
	Sprites.SpriteColorGreen[index] = green
	Sprites.SpriteColorBlue[index] = blue
	Sprites.SpriteColorAlpha[index] = alpha

	pass

#----------------------------------------------------------------------------------------
func DeleteAllTexts():
	var size = (TextCurrentIndex - 1)

	for index in range(size, 9, -1):
		if (TextIsUsed[index] == true):
			remove_child(Texts.TextImage[index])

	for _index in range(0, TextCurrentIndex):
		TextIsUsed[_index] = false

	TextCurrentIndex = 10

	pass

#----------------------------------------------------------------------------------------
func DrawnTextChangeScaleRotation(index, scaleX, scaleY, rotations):
	var textHeight = Texts.TextImage[index].get_theme_font("normal_font").get_string_size(Texts.TextImage[index].text).y
	Texts.TextImage[index].pivot_offset = Vector2((VisualsCore.ScreenWidth / 2.0), (textHeight / 2.0))

	Texts.TextImage[index].scale = Vector2(scaleX, scaleY)
	Texts.TextImage[index].rotation = rotations

	pass

#----------------------------------------------------------------------------------------
# Godot Version 3.5 To 4.0 Beta 2+ Conversion By: "flairetic":
func DrawText(index, text, x, y, horizontalJustification, fontSize, scaleX, scaleY, rotations, red, green, blue, alpha, outlineRed, outlineGreen, outlineBlue):
	if ( index > (TextCurrentIndex-1) ):
		Texts.TextImage.append(RichTextLabel.new())
		add_child(Texts.TextImage[index])
		TextIsUsed[index] = true

	var newTextDrawingOffsetY = 0
	var fontToUseIndex = 0
	if fontSize == 24:
		fontToUseIndex = 0
		fontSize = 23
		newTextDrawingOffsetY = 15.0
	elif fontSize == 10:
		fontToUseIndex = 0
		fontSize = 20
		newTextDrawingOffsetY = 15.0
	elif fontSize == 21:
		fontToUseIndex = 0
		newTextDrawingOffsetY = 15.0
	elif fontSize == 15:
		fontToUseIndex = 0
		fontSize = 10
		newTextDrawingOffsetY = 15.0
	elif fontSize == 25:
		fontToUseIndex = 0
		newTextDrawingOffsetY = 15.0
	elif fontSize == 60:
		fontToUseIndex = 0
		newTextDrawingOffsetY = 36.0
	elif fontSize == 35:
		fontSize = 32
		fontToUseIndex = 0
	elif fontSize == 12:
		fontToUseIndex = 0
	elif fontSize == 22:
		fontToUseIndex = 0
	elif fontSize == 34:
		fontToUseIndex = 1
		fontSize = 35
	elif fontSize == 23:
		fontToUseIndex = 1
		fontSize = 18
	elif fontSize == 13:
		fontToUseIndex = 1
		fontSize = 13
	elif fontSize == 100:
		fontToUseIndex = 0
		fontSize = 65
		newTextDrawingOffsetY = 80.0
	elif fontSize == 57:
		fontToUseIndex = 0
		fontSize = 29
	elif fontSize == 113:
		fontToUseIndex = 1
		fontSize = 75
	elif fontSize == 45:
		fontToUseIndex = 1
		fontSize = 40

	fontSize+=10
	y-=8


	var xValue = x

	if horizontalJustification == 0:
		Texts.TextImage[index].text = text
		Texts.TextImage[index].set_use_bbcode(false)
	elif horizontalJustification == 1:
		Texts.TextImage[index].text = "[center]"+text+"[/center]"
		Texts.TextImage[index].set_use_bbcode(true)
	elif horizontalJustification == 2:
		Texts.TextImage[index].text = "[right]"+text+"[/right]"
		Texts.TextImage[index].set_use_bbcode(true)
	elif horizontalJustification == 4:
		Texts.TextImage[index].text = text
		Texts.TextImage[index].set_use_bbcode(false)

		var textWidth = Texts.TextImage[index].get_theme_font("normal_font").get_string_size(Texts.TextImage[index].text).x
		xValue = x - (textWidth/2)

	#Texts.TextImage[index].add_theme_constant_override("outline_size",10)

	Texts.TextImage[index].clip_contents = false
	Texts.TextImage[index].add_theme_font_override("normal_font", FontTTF[fontToUseIndex])
	Texts.TextImage[index].add_theme_font_size_override("normal_font_size", fontSize)
	Texts.TextImage[index].add_theme_color_override("default_color", Color(red, green, blue, alpha))
	Texts.TextImage[index].add_theme_constant_override("outline_size", 20.0)
	Texts.TextImage[index].add_theme_color_override("font_outline_color", Color(outlineRed, outlineGreen, outlineBlue, alpha)) 

	var textHeight = Texts.TextImage[index].get_theme_font("normal_font").get_string_size(Texts.TextImage[index].text).y

	Texts.TextImage[index].global_position.x = xValue#x
	Texts.TextImage[index].global_position.y = (y - newTextDrawingOffsetY)
	Texts.TextImage[index].set_size(Vector2(VisualsCore.ScreenWidth, VisualsCore.ScreenHeight), false)
	Texts.TextImage[index].pivot_offset = Vector2((VisualsCore.ScreenWidth / 2.0), (textHeight / 2.0))
	Texts.TextImage[index].scale = Vector2(scaleX, scaleY)
	Texts.TextImage[index].rotation = rotations

	Texts.TextIndex.append(index)
	Texts.TextScreenX.append(x)
	Texts.TextScreenY.append(y)
	Texts.TextHorizontalJustification.append(horizontalJustification)
	Texts.TextSize.append(fontSize)
	Texts.TextScaleX.append(scaleX)
	Texts.TextScaleY.append(scaleY)
	Texts.TextRotation.append(rotations)
	Texts.TextColorRed.append(red)
	Texts.TextColorGreen.append(green)
	Texts.TextColorBlue.append(blue)
	Texts.TextColorAlpha.append(alpha)
	Texts.TextOutlineRed.append(outlineRed)
	Texts.TextOutlineGreen.append(outlineGreen)
	Texts.TextOutlineBlue.append(outlineBlue)

	if ( index > (TextCurrentIndex-1) ):
		TextCurrentIndex+=1

	return(TextCurrentIndex-1)

#    Godot Version 3.5 To 4.0 Beta 2+ Conversion By: "flairetic"
#----------------------------------------------------------------------------------------
func AddAboutScreenText(text, blue):
	AboutTexts.AboutTextsText.append(text)
	AboutTexts.AboutTextsBlue.append(blue)

	AboutTextsEndIndex+=1

	pass

#----------------------------------------------------------------------------------------
func LoadAboutScreenTexts():
	AboutTextsStartIndex = 10
	AboutTextsEndIndex = AboutTextsStartIndex

	AddAboutScreenText("TM", 0.0)

	AddAboutScreenText(" ", 0.0)

	AddAboutScreenText("''T-Story 110%™''", 0.0)

	AddAboutScreenText("Copyright 2025 By:", 1.0)
	AddAboutScreenText("Team ''BetaMax Heroes''", 1.0)

	AddAboutScreenText("Original Concept By:", 0.0)
	AddAboutScreenText("Alexey Pajitnov", 1.0)

	AddAboutScreenText("Original Cooperative ''Story+Mode'':", 0.0)
	AddAboutScreenText("(C)opyright 1998 By:", 1.0)
	AddAboutScreenText("Jesse Lee Palser", 1.0)

	AddAboutScreenText("Video Game Made Possible By Our Mentors:", 0.0)
	AddAboutScreenText("Garry Kitchen", 1.0)
	AddAboutScreenText("Andre' LaMothe", 1.0)

	AddAboutScreenText("Made With 100% FREE:", 0.0)
	AddAboutScreenText("''Godot Game Engine''", 1.0)
	AddAboutScreenText(DataCore.GODOT_VERSION, 1.0)
	AddAboutScreenText("[GodotEngine.org]", 1.0)

	AddAboutScreenText("''Godot Game Engine'' Recommended By:", 0.0)
	AddAboutScreenText("''Yuri S.''", 1.0)

	AddAboutScreenText("Game Built On:", 0.0)
	AddAboutScreenText("Genuine ''Linux Mint Cinnamon 64Bit'' Linux OS", 1.0)
	AddAboutScreenText("[LinuxMint.com]", 1.0)
	AddAboutScreenText("Real Programmers Use Linux!", 1.0)

	AddAboutScreenText("Project Produced By:", 0.0)
	AddAboutScreenText("''JeZxLee''", 1.0)

	AddAboutScreenText("Project Directed By:", 0.0)
	AddAboutScreenText("''JeZxLee''", 1.0)

	AddAboutScreenText("Godot " +DataCore.GODOT_VERSION+  " 2-D Game Engine Framework:", 0.0)
	AddAboutScreenText("The ''Grand National GNX'' v2 Engine By:", 1.0)
	AddAboutScreenText("''JeZxLee''", 1.0)
	AddAboutScreenText("''flairetic''", 1.0)

	AddAboutScreenText("Graphics Core(Texts/Sprites) Ported & Turbocharged By:", 0.0)
	AddAboutScreenText("''flairetic''", 1.0)

	AddAboutScreenText("Lead Game Designer:", 0.0)
	AddAboutScreenText("''JeZxLee''", 1.0)

	AddAboutScreenText("Lead Game Programmer:", 0.0)
	AddAboutScreenText("''JeZxLee''", 1.0)

	AddAboutScreenText("Lead Game Tester:", 0.0)
	AddAboutScreenText("''JeZxLee''", 1.0)

	AddAboutScreenText("100% Arcade Perfect To Home Conversion By:", 0.0)
	AddAboutScreenText("''JeZxLee''", 1.0)
	AddAboutScreenText("[Original Gameboy Version]", 1.0)

	AddAboutScreenText("Puzzle Game Artificial Intelligence Programmers:", 0.0)
	AddAboutScreenText("Yiyuan Lee", 1.0)
	AddAboutScreenText("''JeZxLee''", 1.0)
	AddAboutScreenText("''flairetic''", 1.0)

	AddAboutScreenText("Support Game Programmers:", 0.0)
	AddAboutScreenText("''flairetic''", 1.0)
	AddAboutScreenText("''EvanR''", 1.0)
	AddAboutScreenText("''Daotheman''", 1.0)
	AddAboutScreenText("''theweirdn8''", 1.0)
	AddAboutScreenText("''mattmatteh''", 1.0)

	AddAboutScreenText("Lead Graphic Artist:", 0.0)
	AddAboutScreenText("''JeZxLee''", 1.0)

	AddAboutScreenText("Support Graphic Artist:", 0.0)
	AddAboutScreenText("''Oshi Bobo''", 1.0)

	AddAboutScreenText("Story Artist:", 0.0)
	AddAboutScreenText("''J.''", 1.0)

	AddAboutScreenText("Intro/Ending Music:", 0.0)
	AddAboutScreenText("''All That's Left With Hook''", 1.0)
	AddAboutScreenText("by Tunna Beatz", 1.0)
	AddAboutScreenText("[TunnaBeatz.com]", 1.0)

	AddAboutScreenText("Music Soundtrack By:", 0.0)
	AddAboutScreenText("''Free Stock Music''", 1.0)
	AddAboutScreenText("[Free-Stock-Music.com]", 1.0)
	AddAboutScreenText("''Jamendo Music''", 1.0)
	AddAboutScreenText("[Jamendo.com]", 1.0)
	AddAboutScreenText("''YouTube Music''", 1.0)
	AddAboutScreenText("[YouTube.com]", 1.0)

	AddAboutScreenText("Title Music:", 0.0)
	AddAboutScreenText("''Fight To Win, Win For Love'' by Suno A.I. | suno.com", 1.0)

	AddAboutScreenText("Playing Level # 1 Music:", 0.0)
	AddAboutScreenText("''Spirit'' by Alexander Nakarada | serpentsoundstudios.com", 1.0)
	AddAboutScreenText("Music promoted by free-stock-music.com", 1.0)
	AddAboutScreenText("Attribution 4.0 International [CC BY 4.0]", 1.0)
	AddAboutScreenText("creativecommons.org/licenses/by/4.0/", 1.0)

	AddAboutScreenText("Playing Level # 2 Music:", 0.0)
	AddAboutScreenText("''You're Welcome [Instrumental]'' by RYYZN", 1.0)
	AddAboutScreenText("Music promoted by youtube.com", 1.0)

	AddAboutScreenText("Playing Level # 3 Music:", 0.0)
	AddAboutScreenText("''Voyage'' by LEMMiNO", 1.0)
	AddAboutScreenText("Music promoted by outube.com", 1.0)

	AddAboutScreenText("Playing Level # 4 Music:", 0.0)
	AddAboutScreenText("''Deja Vu'' by RYYZN", 1.0)
	AddAboutScreenText("Music promoted by com", 1.0)

	AddAboutScreenText("Playing Level # 5 Music:", 0.0)
	AddAboutScreenText("''Dragon Slayer'' by Makai Symphony | soundcloud.com/makai-symphony", 1.0)
	AddAboutScreenText("Music promoted by free-stock-music.com", 1.0)
	AddAboutScreenText("Creative Commons Attribution-ShareAlike 3.0 Unported", 1.0)
	AddAboutScreenText("creativecommons.org/licenses/by-sa/3.0/deed.en_US", 1.0)

	AddAboutScreenText("Playing Level # 6 Music:", 0.0)
	AddAboutScreenText("''Eyes_and_See'' by PEOPLE OF THE PARALLEL", 1.0)
	AddAboutScreenText("Music promoted by jamendo.com", 1.0)

	AddAboutScreenText("Playing Level # 7 Music:", 0.0)
	AddAboutScreenText("''My Heart Blows Up [Explosions]'' by ANTON LEUBA", 1.0)
	AddAboutScreenText("Music promoted by jamendo.com", 1.0)

	AddAboutScreenText("Playing Level # 8 Music:", 0.0)
	AddAboutScreenText("''Absolution'' by Scott Buckley | soundcloud.com/scottbuckley", 1.0)
	AddAboutScreenText("Music promoted by free-stock-music.com", 1.0)
	AddAboutScreenText("Attribution 4.0 International [CC BY 4.0]", 1.0)
	AddAboutScreenText("creativecommons.org/licenses/by/4.0/", 1.0)

	AddAboutScreenText("Playing Level # 9 Music:", 0.0)
	AddAboutScreenText("''Warrior'' by yoitrax | soundcloud.com/yoitrax", 1.0)
	AddAboutScreenText("Music promoted by free-stock-music.com", 1.0)
	AddAboutScreenText("Creative Commons Attribution 3.0 Unported License", 1.0)
	AddAboutScreenText("creativecommons.org/licenses/by/3.0/deed.en_US", 1.0)

	AddAboutScreenText("Won Music:", 0.0)
	AddAboutScreenText("''UPBEAT 2'' by Aries Beats | soundcloud.com/aries4rce", 1.0)
	AddAboutScreenText("Music promoted by free-stock-music.com", 1.0)
	AddAboutScreenText("Creative Commons Attribution-ShareAlike 3.0 Unported", 1.0)
	AddAboutScreenText("creativecommons.org/licenses/by-sa/3.0/deed.en_US", 1.0)

	AddAboutScreenText("Music Soundtrack Compiled & Edited By:", 0.0)
	AddAboutScreenText("''D.J. Fading Twilight''", 1.0)

	AddAboutScreenText("Sound Effects Compiled & Edited By:", 0.0)
	AddAboutScreenText("''JeZxLee''", 1.0)

	AddAboutScreenText("''Neo's Kiss'' Graphical User Interface By:", 0.0)
	AddAboutScreenText("''JeZxLee''", 1.0)

	AddAboutScreenText("PNG Graphics Edited In:", 0.0)
	AddAboutScreenText("Genuine ''PixelNEO'' For Windows", 1.0)
	AddAboutScreenText("[VisualNEO.com/product/pixelneo]", 1.0)
	AddAboutScreenText("- Free Linux Alternative: ''Krita'' -", 1.0)

	AddAboutScreenText("PNG Graphics Optimized Using:", 0.0)
	AddAboutScreenText("''TinyPNG''", 1.0)
	AddAboutScreenText("[www.TinyPNG.com]", 1.0)

	AddAboutScreenText("OGG Audio Edited In:", 0.0)
	AddAboutScreenText("Genuine ''GoldWave'' For Windows", 1.0)
	AddAboutScreenText("[www.GoldWave.com]", 1.0)
	AddAboutScreenText("- Free Linux Alternative: ''Audacity'' -", 1.0)

	AddAboutScreenText("''T-Story 110%'' Logo Created In:", 0.0)
	AddAboutScreenText("Genuine Microsoft Office 2021 Plus Publisher", 1.0)
	AddAboutScreenText("[Office.com]", 1.0)

	AddAboutScreenText("Game Created On A:", 0.0)
	AddAboutScreenText("Hyper-Custom ''JeZxLee'' Pro-Built Desktop", 1.0)

	AddAboutScreenText("Desktop Code Name: ''Megatron''", 1.0)
	AddAboutScreenText("Build Date: June 11th, 2022", 1.0)
	AddAboutScreenText("Genuine ''Linux Mint Cinnamon 64Bit'' Linux OS", 1.0)
	AddAboutScreenText("Silverstone Tek ATX Mid Tower Case", 1.0)
	AddAboutScreenText("EVGA Supernova 650 GT 80 Plus Gold 650W Power Supply", 1.0)
	AddAboutScreenText("ASUS AM4 TUF Gaming X570-Plus [Wi-Fi] Motherboard", 1.0)
	AddAboutScreenText("AMD Ryzen 7 5800X[4.7GHz Turbo] 8-Core CPU", 1.0)
	AddAboutScreenText("Noctua NH-U12S chromax.Black 120mm CPU Cooler", 1.0)
	AddAboutScreenText("Corsair Vengeance LPX 32GB[2X16GB] DDR4 3200MHz RAM Memory", 1.0)
	AddAboutScreenText("MSI Gaming nVidia GeForce RTX 3060 12GB GDDR6 OC GPU", 1.0)
	AddAboutScreenText("SAMSUNG 980 PRO 2TB PCIe NVMe Gen 4 M.2 Drive", 1.0)
	AddAboutScreenText("Seagate FireCuda 4TB 3.5 Inch Hard Drive", 1.0)

	AddAboutScreenText("HTML5 Version Tested On:", 0.0)
	AddAboutScreenText("Mozilla Firefox", 1.0)
	AddAboutScreenText("Google Chrome", 1.0)
	AddAboutScreenText("Opera", 1.0)
	AddAboutScreenText("Microsoft Edge", 1.0)
	AddAboutScreenText("Apple macOS Safari", 1.0)

	AddAboutScreenText("Big Thank You To People Who Helped Us:", 0.0)
	AddAboutScreenText("''Yuri S.''", 1.0)
	AddAboutScreenText("''TwistedTwigleg''", 1.0)
	AddAboutScreenText("''Megalomaniak''", 1.0)
	AddAboutScreenText("''SIsilicon28''", 1.0)
	AddAboutScreenText("''vimino''", 1.0)
	AddAboutScreenText("( : ''PurpleConditioner'' : )", 1.0)
	AddAboutScreenText("''Kequc''", 1.0)
	AddAboutScreenText("''qeed''", 1.0)
	AddAboutScreenText("''Calinou''", 1.0)
	AddAboutScreenText("''Sosasees''", 1.0)
	AddAboutScreenText("''ArRay_''", 1.0)
	AddAboutScreenText("''blast007''", 1.0)
	AddAboutScreenText("''fogobogo''", 1.0)
	AddAboutScreenText("''CYBEREALITY''", 1.0)
	AddAboutScreenText("''Perodactyl''", 1.0)
	AddAboutScreenText("''floatcomplex''", 1.0)
	AddAboutScreenText("''DaveTheCoder''", 1.0)
	AddAboutScreenText("''Dominus''", 1.0)
	AddAboutScreenText("''lawnjelly''", 1.0)
	AddAboutScreenText("''EvanR''", 1.0)
	AddAboutScreenText("''Zelta''", 1.0)
	AddAboutScreenText("''slidercrank''", 1.0)
	AddAboutScreenText("''epicspaces''", 1.0)
	AddAboutScreenText("''powersnap55''", 1.0)
	AddAboutScreenText("''cybereality''", 1.0)
	AddAboutScreenText("''Unforgiven''", 1.0)
	AddAboutScreenText("''Neil Kenneth David''", 1.0)
	AddAboutScreenText("''gioele''", 1.0)
	AddAboutScreenText("''TatBou''", 1.0)
	AddAboutScreenText("''fire7side''", 1.0)
	AddAboutScreenText("''YaroslavFox''", 1.0)
	AddAboutScreenText("''Erich_L''", 1.0)
	AddAboutScreenText("''Zoinkers''", 1.0)
	AddAboutScreenText("''Sanne''", 1.0)
	AddAboutScreenText("''circuitbone''", 1.0)
	AddAboutScreenText("''duane''", 1.0)	
	AddAboutScreenText("''Pixophir''", 1.0)
	AddAboutScreenText("''Zireael''", 1.0)
	AddAboutScreenText("''Kojack''", 1.0)
	AddAboutScreenText("''akien-mga''", 1.0)
	AddAboutScreenText("''Valedict''", 1.0)
	AddAboutScreenText("''Aliencodex''", 1.0)
	AddAboutScreenText("''leonardus''", 1.0)
	AddAboutScreenText("''Donitz''", 1.0)
	AddAboutScreenText("''furrykef''", 1.0)
	AddAboutScreenText("''Remi Verschelde''", 1.0)
	AddAboutScreenText("''Xananax''", 1.0)
	AddAboutScreenText("''Adam Scott''", 1.0)
	AddAboutScreenText("''sslcon[m]''", 1.0)
	AddAboutScreenText("''TheRookie''", 1.0)
	AddAboutScreenText("''CuffLimbs''", 1.0)
	AddAboutScreenText("''zleap''", 1.0)

	AddAboutScreenText(" ", 1.0)
	AddAboutScreenText("''You!''", 1.0)

	AddAboutScreenText("A 110% By Team ''BetaMax Heroes''!", 0.0)
	AddAboutScreenText(" ", 1.0)

	DrawText(AboutTextsStartIndex, AboutTexts.AboutTextsText[AboutTextsStartIndex], ((ScreenWidth/2.0)+100.0), ScreenHeight+25, 0, 23, 1.0, 1.0, 0, 1.0, 1.0, AboutTexts.AboutTextsBlue[AboutTextsStartIndex-10], 0.0, 0.0, 0.0, 0.0)

	var screenY = ScreenHeight-300
	for index in range(AboutTextsStartIndex+1, AboutTextsEndIndex):
		if (AboutTexts.AboutTextsBlue[index-10] == 1.0 && AboutTexts.AboutTextsBlue[index-1-10] == 0.0):
			screenY+=50
		elif (AboutTexts.AboutTextsBlue[index-10] == 1.0 && AboutTexts.AboutTextsBlue[index-1-10] == 1.0):
			screenY+=50
		else:
			screenY+=180

		var fontSize = 23

		DrawText(index, AboutTexts.AboutTextsText[index-10], 0, screenY, 1, fontSize, 1.0, 1.0, 0, 1.0, 1.0, AboutTexts.AboutTextsBlue[index-10], 1.0, 0.0, 0.0, 0.0)

	Texts.TextImage[AboutTextsEndIndex-2].global_position.y+=(ScreenHeight/2.0)
	Texts.TextImage[AboutTextsEndIndex-1].global_position.y+=(ScreenHeight/2.0)

	pass
