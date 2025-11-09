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

# "LogicCore.gd"
extends Node2D

var Version = "110% Retail 3 Final Turbo!"

const ChildMode				= 0
const TeenMode				= 1
const AdultMode				= 2
const TurboMode				= 3

var GameMode = AdultMode

var AllowComputerPlayers = 1

var DisableMultiplayer = 0

var PieceOverlap = false

var GameSpeed = 30

var SecretCode = []
var SecretCodeCombined = 0

var Level

var PieceData = []

var PlayfieldMoveAI = []

var Piece = [];

var PieceBagIndex = []
var PieceBag = []
var PieceSelectedAlready = []

var NextPiece = []

const Current			= 0
const Next				= 1
const DropShadow		= 2
const Temp				= 3
const Fallen			= 4

var PieceRotation = []
var PiecePlayfieldX = []
var PiecePlayfieldY = []

const CollisionNotTrue			= 0
const CollisionWithPlayfield	= 1
const CollisionWithPiece		= 3

var PieceDropTimer = []
var TimeToDropPiece = []

const GameOver 					= -1
const NewPieceDropping 			= 0
const PieceFalling 				= 1
const FlashingCompletedLines 	= 2
const ClearingCompletedLines 	= 3
const ClearingPlayfield 		= 4
var PlayerStatus = []

var PAUSEgame = false
var PauseWasJustPressed = false

var PieceDropStartHeight = []

var PieceBagFirstUse = []

var PieceMovementDelay = []

var PieceRotatedOne = []
var PieceRotatedTwo = []

var PieceRotatedUp = []

var FlashCompletedLinesTimer
var FlashCompletedLinesTimerTwo
var ClearCompletedLinesTimer

var PlayfieldAlpha
var PlayfieldAlphaDir

var BoardFlip

var Score = []
var ScoreChanged

var DropBonus = []

var MovePieceDownDelay = []

var DrawEverything
var PieceMoved

var AndroidMovePieceDownDelay = []
var AndroidMovePieceDownPressed = []
var AndroidMovePieceLeftDelay = []
var AndroidMovePieceRightDelay = []

var PlayerInput = []

var PlayersCanJoinIn

var Player

var MovePieceCollision = []
var MovePieceHeight = []
var MoveTrappedHoles = []
var MoveOneBlockCavernHoles = []
var MovePlayfieldBoxEdges = []
var MoveCompletedLines = []

var MoveBumpiness = []

var MoveTotalHeight = []

var BestMoveX = []
var BestRotation = []
var MovedToBestMove = []

var MaxRotationArray = []

var CPUPlayerMovementSkip = []

const CPUForcedFree			= 0
const CPUForcedLeft			= 1
const CPUForcedRight		= 2
var CPUPlayerForcedDirection = []
var CPUPlayerForcedMinX = []
var CPUPlayerForcedMaxX = []

var CPUPieceTestX = []
var CPURotationTest = []
var CPUComputedBestMove = []

var pTXStep = []
var bestValue = []

var TotalLines
var LevelCleared

var GameWon

var AddRandomBlocksToBottomTimer

var PlayfieldBackup = []

var StillPlaying

var ScoreOneText
var ScoreTwoText
var ScoreThreeText
var LinesLeftText

var MouseTouchRotateDir

var PieceInPlayfieldMemory = []

var PieceLandedResetAI = false

var CurrentProcessedAIPlayer

var PlayfieldNew = []

var MousePlayerStarted

var SkipComputerPlayerMove = []

var SkipOLD

var ComputerPlayersTotalLevelClears
var ComputerPlayersTotalGamesPlayed
var ComputerPlayersAverageLevelClearsText

var AIsystemToUse = 1

var PlayerHeights = []
var PlayerHeightsInOrder = []

var levelAdjust = []

var TEMP_PieceRotation
var TEMP_PiecePlayfieldX
var TEMP_PiecePlayfieldY

var PlayerPlayfield = []
var PlayerInputDone = []

var PlayfieldsAlpha = 1.0
var PlayfieldsAlphaDir = 0

#----------------------------------------------------------------------------------------
func InitializePieceData():
	var _warnErase = PieceData.resize(8)
	for piece in range(8):
		PieceData[piece] = []
		PieceData[piece].resize(5)
		for rotations in range(5):
			PieceData[piece][rotations] = []
			PieceData[piece][rotations].resize(17)

	for piece in range(8):
		for rotations in range(5):
			for box in range(17):
				PieceData[piece][rotations][box] = 0

	# RED "S" Piece
	PieceData [1] [1] [10] = 1 # 01 02 03 04
	PieceData [1] [1] [11] = 1 # 05 06 07 08
	PieceData [1] [1] [13] = 1 # 09 [] [] 12
	PieceData [1] [1] [14] = 1 # [] [] 15 16

	PieceData [1] [2] [ 5] = 1
	PieceData [1] [2] [ 9] = 1
	PieceData [1] [2] [10] = 1
	PieceData [1] [2] [14] = 1

	PieceData [1] [3] [10] = 1
	PieceData [1] [3] [11] = 1
	PieceData [1] [3] [13] = 1
	PieceData [1] [3] [14] = 1

	PieceData [1] [4] [ 5] = 1
	PieceData [1] [4] [ 9] = 1
	PieceData [1] [4] [10] = 1
	PieceData [1] [4] [14] = 1

	# ORANGE "Z" Piece
	PieceData [2] [1] [ 9] = 1
	PieceData [2] [1] [10] = 1
	PieceData [2] [1] [14] = 1
	PieceData [2] [1] [15] = 1

	PieceData [2] [2] [ 6] = 1
	PieceData [2] [2] [ 9] = 1
	PieceData [2] [2] [10] = 1
	PieceData [2] [2] [13] = 1

	PieceData [2] [3] [ 9] = 1
	PieceData [2] [3] [10] = 1
	PieceData [2] [3] [14] = 1
	PieceData [2] [3] [15] = 1

	PieceData [2] [4] [ 6] = 1
	PieceData [2] [4] [ 9] = 1
	PieceData [2] [4] [10] = 1
	PieceData [2] [4] [13] = 1

	# AQUA "T" Piece
	PieceData [3] [1] [ 9] = 1
	PieceData [3] [1] [10] = 1
	PieceData [3] [1] [11] = 1
	PieceData [3] [1] [14] = 1

	PieceData [3] [2] [ 6] = 1
	PieceData [3] [2] [ 9] = 1
	PieceData [3] [2] [10] = 1
	PieceData [3] [2] [14] = 1

	PieceData [3] [3] [ 6] = 1
	PieceData [3] [3] [ 9] = 1
	PieceData [3] [3] [10] = 1
	PieceData [3] [3] [11] = 1

	PieceData [3] [4] [ 6] = 1
	PieceData [3] [4] [10] = 1
	PieceData [3] [4] [11] = 1
	PieceData [3] [4] [14] = 1

	# YELLOW "L" Piece
	PieceData [4] [1] [ 9] = 1
	PieceData [4] [1] [10] = 1
	PieceData [4] [1] [11] = 1
	PieceData [4] [1] [13] = 1

	PieceData [4] [2] [ 5] = 1
	PieceData [4] [2] [ 6] = 1
	PieceData [4] [2] [10] = 1
	PieceData [4] [2] [14] = 1

	PieceData [4] [3] [ 7] = 1
	PieceData [4] [3] [ 9] = 1
	PieceData [4] [3] [10] = 1
	PieceData [4] [3] [11] = 1

	PieceData [4] [4] [ 6] = 1
	PieceData [4] [4] [10] = 1
	PieceData [4] [4] [14] = 1
	PieceData [4] [4] [15] = 1

	# GREEN "Backwards L" Piece
	PieceData [5] [1] [ 9] = 1
	PieceData [5] [1] [10] = 1
	PieceData [5] [1] [11] = 1
	PieceData [5] [1] [15] = 1

	PieceData [5] [2] [ 6] = 1
	PieceData [5] [2] [10] = 1
	PieceData [5] [2] [13] = 1
	PieceData [5] [2] [14] = 1

	PieceData [5] [3] [ 5] = 1
	PieceData [5] [3] [ 9] = 1
	PieceData [5] [3] [10] = 1
	PieceData [5] [3] [11] = 1

	PieceData [5] [4] [ 6] = 1
	PieceData [5] [4] [ 7] = 1
	PieceData [5] [4] [10] = 1
	PieceData [5] [4] [14] = 1

	# BLUE "Box" Piece
	PieceData [6] [1] [10] = 1
	PieceData [6] [1] [11] = 1
	PieceData [6] [1] [14] = 1
	PieceData [6] [1] [15] = 1

	PieceData [6] [2] [10] = 1
	PieceData [6] [2] [11] = 1
	PieceData [6] [2] [14] = 1
	PieceData [6] [2] [15] = 1

	PieceData [6] [3] [10] = 1
	PieceData [6] [3] [11] = 1
	PieceData [6] [3] [14] = 1
	PieceData [6] [3] [15] = 1

	PieceData [6] [4] [10] = 1
	PieceData [6] [4] [11] = 1
	PieceData [6] [4] [14] = 1
	PieceData [6] [4] [15] = 1

	# PURPLE "Line" Piece
	PieceData [7] [1] [ 9] = 1
	PieceData [7] [1] [10] = 1
	PieceData [7] [1] [11] = 1
	PieceData [7] [1] [12] = 1

	PieceData [7] [2] [ 2] = 1
	PieceData [7] [2] [ 6] = 1
	PieceData [7] [2] [10] = 1
	PieceData [7] [2] [14] = 1

	PieceData [7] [3] [ 9] = 1
	PieceData [7] [3] [10] = 1
	PieceData [7] [3] [11] = 1
	PieceData [7] [3] [12] = 1

	PieceData [7] [4] [ 2] = 1
	PieceData [7] [4] [ 6] = 1
	PieceData [7] [4] [10] = 1
	PieceData [7] [4] [14] = 1

	pass

#----------------------------------------------------------------------------------------
func ClearNewPlayfieldsWithCollisionDetection():
	for player in range(3):
		for y in range(26):
			for x in range(15):
				PlayfieldNew[player][x][y] = 255 # Collision detection value

		for y in range(2, 5, 1):
			for x in range(5, 9, 1):
				PlayfieldNew[player][x][y] = 0

		for y in range(5, 24, 1):
			for x in range(2, 12, 1):
				PlayfieldNew[player][x][y] = 0

	pass

#----------------------------------------------------------------------------------------
func FillPieceBag(player):
	var done = false

	PieceBagIndex[player] = 1
	for index in range (0, 8):
		PieceBag[player][0][index] = -1
		PieceSelectedAlready[player][index] = false

	if PieceBagFirstUse[player] == true:
		PieceBagFirstUse[player] = false

		PieceBag[player][0][1] = ( (randi() % 7) + 1 )
		Piece[player] = PieceBag[player][0][1]
		PieceSelectedAlready[player][ PieceBag[player][0][1] ] = true
	else:
		PieceBag[player][0][1] = PieceBag[player][0][8]
		Piece[player] = PieceBag[player][0][1]
		PieceSelectedAlready[player][ PieceBag[player][0][1] ] = true

	while done == false:
		for x in range(2, 8):
			var randomPieceToTry = ( (randi() % 7) + 1 )
			while PieceSelectedAlready[player][randomPieceToTry] == true:
				randomPieceToTry = ( (randi() % 7) + 1 )

			PieceBag[player][0][x] = randomPieceToTry
			PieceSelectedAlready[player][randomPieceToTry] = true

			if x == 7:
				done = true
				x = 777

	PieceBag[player][0][8] = ( (randi() % 7) + 1 )

	if (SecretCodeCombined == 2778 or SecretCodeCombined == 8888):
		Piece[0] = 7
		NextPiece[0] = 7
		for index in range(0, 9):
			PieceBag[0][0][index] = 7
			PieceBag[0][1][index] = 7
		Piece[1] = 7
		NextPiece[1] = 7
		for index in range(0, 9):
			PieceBag[1][0][index] = 7
			PieceBag[1][1][index] = 7
		Piece[2] = 7
		NextPiece[2] = 7
		for index in range(0, 9):
			PieceBag[2][0][index] = 7
			PieceBag[2][1][index] = 7

	pass

#----------------------------------------------------------------------------------------
func ReadPlayerHeight(player):
	var height = 23
	for posX in range(2, 12):
		for posYtwo in range(23, 5, -1):
			if ( (PlayfieldNew[player][posX][posYtwo] > 29 && PlayfieldNew[player][posX][posYtwo] < 39) ):
				if (posYtwo < height):
					height = posYtwo

	return(height)

#----------------------------------------------------------------------------------------
func ApplyDifficulty():
	if (ScreensCore.OperatingSys != ScreensCore.OSAndroid):
		if (GameMode == ChildMode):
			levelAdjust[0] = 5
		elif (GameMode == TeenMode):
			levelAdjust[1] = 15
		elif (GameMode == AdultMode):
			levelAdjust[2] = 10
		elif (GameMode == TurboMode):
			levelAdjust[3] = 20
	elif (ScreensCore.OperatingSys == ScreensCore.OSAndroid):
		if (GameMode == ChildMode):
			levelAdjust[0] = 4
		elif (GameMode == TeenMode):
			levelAdjust[1] = 8
		elif (GameMode == AdultMode):
			levelAdjust[2] = 6
		elif (GameMode == TurboMode):
			levelAdjust[3] = 10

	if (AllowComputerPlayers == 2):
		if (GameMode == ChildMode):
			levelAdjust[0] = 1
		elif (GameMode == TeenMode):
			levelAdjust[1] = 1
		elif (GameMode == AdultMode):
			levelAdjust[2] = 1
		elif (GameMode == TurboMode):
			levelAdjust[3] = 1

	pass

#----------------------------------------------------------------------------------------
func SetupForNewGame():
	for index in range(0, 5):
		InputCore.AndroidTouchOnePressed[index] = false
		InputCore.AndroidTouchOnePressedX[index] = 9999999
		InputCore.AndroidTouchOnePressedY[index] = 9999999
		InputCore.AndroidTouchOnePressed[index] = false
		InputCore.AndroidTouchOnePressedX[index] = 9999999
		InputCore.AndroidTouchOnePressedY[index] = 9999999

	ClearNewPlayfieldsWithCollisionDetection()

	ApplyDifficulty()

	PieceLandedResetAI = false

	for player in range(0, 3):
		PieceBagFirstUse[player] = true
		FillPieceBag(player)
		NextPiece[player] = PieceBag[player][0][2]

		PieceRotation[player] = 1

		PieceDropTimer[player] = 0
		TimeToDropPiece[player] = 47

		PieceRotatedOne[player] = false
		PieceRotatedTwo[player] = false

		PieceRotatedUp[player] = false

		Score[player] = 0

		DropBonus[player] = 0

		MovePieceDownDelay[player] = 0

		AndroidMovePieceDownDelay[player] = 0
		AndroidMovePieceDownPressed[player] = false
		AndroidMovePieceLeftDelay[player] = 0
		AndroidMovePieceRightDelay[player] = 0

		BestMoveX[player] = -1
		BestRotation[player] = -1
		MovedToBestMove[player] = false

		PieceMovementDelay[player] = 0

		CPUPlayerMovementSkip[player] = 0

		CPUPlayerForcedDirection[player] = CPUForcedFree
		CPUPlayerForcedMinX[player] = 0
		CPUPlayerForcedMaxX[player] = 31

		CPUPieceTestX[player] = 0
		CPURotationTest[player] = 1
		CPUComputedBestMove[player] = false

		pTXStep[player] = 1

		CPUPieceTestX[player] = 0

		bestValue[player] = 99999

		CPUPieceTestX[player] = PiecePlayfieldX[player]

		PieceInPlayfieldMemory[player] = false

		SkipComputerPlayerMove[player] = 0

	ScoreChanged = true

	PieceOverlap = false

	Level = 1

	PiecePlayfieldX[0] = 5
	PiecePlayfieldY[0] = 0

	PiecePlayfieldX[1] = 5
	PiecePlayfieldY[1] = 0

	PiecePlayfieldX[2] = 5
	PiecePlayfieldY[2] = 0

	for index in range (0, 9):
		VisualsCore.PlayfieldSpriteCurrentIndex[index] = 0

	for index in range (0, 8):
		VisualsCore.PieceSpriteCurrentIndex[index] = 0

	PlayerStatus[0] = GameOver
	PlayerStatus[1] = NewPieceDropping
	PlayerStatus[2] = GameOver

	PAUSEgame = false

	VisualsCore.KeyboardControlsAlphaTimer = 1.0

	FlashCompletedLinesTimer = 0
	FlashCompletedLinesTimerTwo = 0
	ClearCompletedLinesTimer = 0

	PlayfieldAlpha = 1
	PlayfieldAlphaDir = 0

	BoardFlip = 0

	DrawEverything = 3
	PieceMoved = 1

	for index in range(0, 4):
		InterfaceCore.Icons.IconAnimationTimer[index] = -1

	PlayersCanJoinIn = true

	if (AllowComputerPlayers == 2):
		PlayerStatus[0] = NewPieceDropping
		PlayerStatus[1] = NewPieceDropping
		PlayerStatus[2] = NewPieceDropping
		PlayerInput[0] = InputCore.InputCPU
		PlayerInput[1] = InputCore.InputCPU
		PlayerInput[2] = InputCore.InputCPU
		PlayersCanJoinIn = false
	elif (ScreensCore.OperatingSys != ScreensCore.OSAndroid):
		PlayerInput[0] = InputCore.InputNone
		if (InputCore.HTML5input == InputCore.InputTouchOne):
			PlayerInput[1] = InputCore.InputTouchOne
		else:
			PlayerInput[1] = InputCore.InputKeyboard
		PlayerInput[2] = InputCore.InputNone
	else:
		PlayerInput[0] = InputCore.InputNone
		PlayerInput[1] = InputCore.InputTouchOne
		PlayerInput[2] = InputCore.InputNone

	TotalLines = 0
	LevelCleared = false

	GameWon = false

	AddRandomBlocksToBottomTimer = 0

	StillPlaying = true

	if (SecretCodeCombined == 6161):
		PlayerStatus[0] = NewPieceDropping
		PlayerStatus[1] = NewPieceDropping
		PlayerStatus[2] = NewPieceDropping
		PlayerInput[0] = InputCore.InputJoyOne
		PlayerInput[1] = InputCore.InputKeyboard
		PlayerInput[2] = InputCore.InputMouse

		PlayersCanJoinIn = false

		Score[0] = 1257465
		Score[1] = 1166456
		Score[2] = 1299665

		Level = 8

		Piece[0] = 7
		Piece[1] = 7
		Piece[2] = 7

		for x in range(2, 12):
			for y in range(24-4, 24):
				if (x < 5 or x > 5):  PlayfieldNew[0][x][y] = 30 + ( (randi() % 7) + 1 )

		for x in range(2, 12):
			for y in range(24-4, 24):
				if (x < 8 or x > 8):  PlayfieldNew[1][x][y] = 30 + ( (randi() % 7) + 1 )

		for x in range(2, 12):
			for y in range(24-4, 24):
				if (x < 11 or x > 11):  PlayfieldNew[2][x][y] = 30 + ( (randi() % 7) + 1 )

	CurrentProcessedAIPlayer = 0

	MousePlayerStarted = false

	if (SecretCodeCombined == 3777):
		for x in range(3, 12):
			for y in range(20-4, 24):
				PlayfieldNew[0][x][y] = 30 + ( (randi() % 7) + 1 )

		for x in range(2, 12):
			for y in range(20-4, 24):
				PlayfieldNew[1][x][y] = 30 + ( (randi() % 7) + 1 )

		for x in range(2, 12):
			for y in range(20-4, 24):
				PlayfieldNew[2][x][y] = 30 + ( (randi() % 7) + 1 )

	SkipOLD = 3

	if (ScreensCore.OperatingSys == ScreensCore.OSHTMLFive):
		if (InputCore.HTML5input == InputCore.InputMouse):
			PlayerInput[1] = InputCore.InputMouse
			MousePlayerStarted = true
			PlayersCanJoinIn = false

			PlayerStatus[0] = NewPieceDropping
			PlayerStatus[2] = NewPieceDropping
			PlayerInput[0] = InputCore.InputCPU
			PlayerInput[2] = InputCore.InputCPU

	if (SecretCodeCombined == 8889):
		PlayerStatus[0] = NewPieceDropping
		PlayerStatus[1] = NewPieceDropping
		PlayerStatus[2] = NewPieceDropping
		PlayerInput[0] = InputCore.InputCPU
		PlayerInput[1] = InputCore.InputCPU
		PlayerInput[2] = InputCore.InputCPU

	if (SecretCodeCombined == 7171):  Score[1] = 1166456

	PlayerPlayfield[0] = 0
	PlayerPlayfield[1] = 1
	PlayerPlayfield[2] = 2
	
	PlayerInputDone[0] = InputCore.InputNone
	PlayerInputDone[1] = InputCore.InputNone
	PlayerInputDone[2] = InputCore.InputNone

	if (SecretCodeCombined == 7171):
		Score[0] = 0
		Score[1] = 1166456
		Score[2] = 0

	if (SecretCodeCombined == 7070):
		Score[0] = 0
		Score[1] = 0
		Score[2] = 1166456

	ScreensCore.PlayingExited = false

	pass

#----------------------------------------------------------------------------------------
func PieceCollision(player):
	var box = 1
	var returnValue = CollisionNotTrue

	for y in range(0, 4):
		for x in range(0, 4):
			if (   (  ( (PlayfieldNew[player][ PiecePlayfieldX[player] + x ][ PiecePlayfieldY[player] + y ] > 0)
			&& (PlayfieldNew[player][ PiecePlayfieldX[player] + x ][ PiecePlayfieldY[player] + y ] < 40) )
			|| (PlayfieldNew[player][ PiecePlayfieldX[player] + x ][ PiecePlayfieldY[player] + y ] == 255)
			|| (PlayfieldNew[player][ PiecePlayfieldX[player] + x ][ PiecePlayfieldY[player] + y ] > 99999)  )
			&& (PieceData [Piece[player]] [PieceRotation[player]] [box] > 0)   ):
				returnValue = CollisionWithPlayfield

			box+=1

	return(returnValue)

#----------------------------------------------------------------------------------------
func PieceCollisionDown(player):
	var box = 1
	var returnValue = CollisionNotTrue

	for y in range(1, 5):
		for x in range(0, 4):
			if (   (  ( (PlayfieldNew[player][ PiecePlayfieldX[player] + x ][ PiecePlayfieldY[player] + y ] > 0)
			&& (PlayfieldNew[player][ PiecePlayfieldX[player] + x ][ PiecePlayfieldY[player] + y ] < 40) )
			|| (PlayfieldNew[player][ PiecePlayfieldX[player] + x ][ PiecePlayfieldY[player] + y ] == 255)
			|| (PlayfieldNew[player][ PiecePlayfieldX[player] + x ][ PiecePlayfieldY[player] + y ] > 99999)  )
			&& (PieceData [Piece[player]] [PieceRotation[player]] [box] > 0)   ):
				returnValue = CollisionWithPlayfield

			box+=1

	return(returnValue)

#----------------------------------------------------------------------------------------
func PieceCollisionLeft(player):
	var box = 1
	var returnValue = CollisionNotTrue

	for y in range(0, 4):
		for x in range(-1, 3):
			if (   (  ( (PlayfieldNew[player][ PiecePlayfieldX[player] + x ][ PiecePlayfieldY[player] + y ] > 0)
			&& (PlayfieldNew[player][ PiecePlayfieldX[player] + x ][ PiecePlayfieldY[player] + y ] < 40) )
			|| (PlayfieldNew[player][ PiecePlayfieldX[player] + x ][ PiecePlayfieldY[player] + y ] == 255)
			|| (PlayfieldNew[player][ PiecePlayfieldX[player] + x ][ PiecePlayfieldY[player] + y ] > 99999)  )
			&& (PieceData [Piece[player]] [PieceRotation[player]] [box] > 0)   ):
				returnValue = CollisionWithPlayfield

			box+=1

	return(returnValue)

#----------------------------------------------------------------------------------------
func PieceCollisionRight(player):
	var box = 1
	var returnValue = CollisionNotTrue

	for y in range(0, 4):
		for x in range(1, 5):
			if (   (  ( (PlayfieldNew[player][ PiecePlayfieldX[player] + x ][ PiecePlayfieldY[player] + y ] > 0)
			&& (PlayfieldNew[player][ PiecePlayfieldX[player] + x ][ PiecePlayfieldY[player] + y ] < 40) )
			|| (PlayfieldNew[player][ PiecePlayfieldX[player] + x ][ PiecePlayfieldY[player] + y ] == 255)
			|| (PlayfieldNew[player][ PiecePlayfieldX[player] + x ][ PiecePlayfieldY[player] + y ] > 99999)  )
			&& (PieceData [Piece[player]] [PieceRotation[player]] [box] > 0)   ):
				returnValue = CollisionWithPlayfield

			box+=1

	return(returnValue)

#----------------------------------------------------------------------------------------
func CheckForCompletedLines(player):
	var numberOfCompletedLines = 0

	DrawEverything= 1

	AddCurrentPieceToPlayfieldMemory(player, Fallen)

	PiecePlayfieldX[player] = 5

	PiecePlayfieldY[player] = 0

	var boxTotal
	if (LogicCore.DisableMultiplayer == 0):
		for y in range(4, 24):
			boxTotal = 0
			for p in range(3):
				for x in range (2, 12):
					if (PlayfieldNew[p][x][y] > 30 && PlayfieldNew[p][x][y] < 40):
						boxTotal+=1

			if (boxTotal == 30):
				numberOfCompletedLines+=1
	elif (LogicCore.DisableMultiplayer == 1):
		for y in range(4, 24):
			boxTotal = 0
			for x in range (2, 12):
				if (PlayfieldNew[1][x][y] > 30 && PlayfieldNew[1][x][y] < 40):
					boxTotal+=1

			if (boxTotal == 10):
				numberOfCompletedLines+=1

	if (numberOfCompletedLines > 0):
		if (numberOfCompletedLines == 1):
			Score[player] += (40 * (Level+1) * 10)
			if (SecretCodeCombined != 2778):  TotalLines+=1
		elif (numberOfCompletedLines == 2):
			Score[player] += (100 * (Level+1) * 10)
			if (SecretCodeCombined != 2778):  TotalLines+=2
		elif (numberOfCompletedLines == 3):
			Score[player] += (300 * (Level+1) * 10)
			if (SecretCodeCombined != 2778):  TotalLines+=3
		elif (numberOfCompletedLines == 4):
			Score[player] += (1200 * (Level+1) * 10)
			if (SecretCodeCombined != 2778):  TotalLines+=4
			AudioCore.PlayEffect(player, 6)
		ScoreChanged = true

		PlayerStatus[player] = FlashingCompletedLines
		FlashCompletedLinesTimer = 0
		FlashCompletedLinesTimerTwo = 0
		
	else:
		SetupNewPiece(player)

	pass

#----------------------------------------------------------------------------------------
func FlashCompletedLines(player):
	if (FlashCompletedLinesTimer < 10):
		FlashCompletedLinesTimer+=1

	var boxTotal
	if (LogicCore.DisableMultiplayer == 0):
		for y in range (4, 24):
			boxTotal = 0
			for p in range(3):
				for x in range (2, 12):
					if (PlayfieldNew[p][x][y] > 30 && PlayfieldNew[p][x][y] < 40):
						boxTotal+=1
					elif (PlayfieldNew[p][x][y] > 99998):
						boxTotal+=1

				if (boxTotal == 30):
					DrawEverything = 1

					for pTwo in range(3):
						if (FlashCompletedLinesTimer % 2 == 0):
							for xTwo in range (2, 12):
								PlayfieldNew[pTwo][xTwo][y]-=99999
						else:
							for xThree in range(2, 12):
								PlayfieldNew[pTwo][xThree][y]+=99999
	elif (LogicCore.DisableMultiplayer == 1):
		for y in range (4, 24):
			boxTotal = 0
			for x in range (2, 12):
				if (PlayfieldNew[1][x][y] > 30 && PlayfieldNew[1][x][y] < 40):
					boxTotal+=1
				elif (PlayfieldNew[1][x][y] > 99998):
					boxTotal+=1

			if (boxTotal == 10):
				DrawEverything = 1

				if (FlashCompletedLinesTimer % 2 == 0):
					for xTwo in range (2, 12):
						PlayfieldNew[1][xTwo][y]-=99999
				else:
					for xThree in range(2, 12):
						PlayfieldNew[1][xThree][y]+=99999

	if FlashCompletedLinesTimer == 10:
		PlayerStatus[player] = ClearingCompletedLines
		ClearCompletedLinesTimer = 0

	pass

#----------------------------------------------------------------------------------------
func ClearCompletedLines(player):
	var thereWasACompletedLine = false

	var boxTotal
	if (LogicCore.DisableMultiplayer == 0):
		for y in range (4, 24):
			boxTotal = 0

			for p in range(3):
				for x in range (2, 12):
					if (PlayfieldNew[p][x][y] > 30 && PlayfieldNew[p][x][y] < 40):
						boxTotal+=1

			if boxTotal == 30:
				thereWasACompletedLine = true

				DrawEverything = 1

				if ClearCompletedLinesTimer < 40:
					ClearCompletedLinesTimer+=1

				if ClearCompletedLinesTimer % 10 == 0:
					for playerIndex in range(3):
						for yTwo in range(y, 5, -1):
							for xTwo in range(2, 12):
								if (PlayfieldNew[playerIndex][xTwo][yTwo-1] < 1000 or PlayfieldNew[playerIndex][xTwo][yTwo-1] > 1009):  PlayfieldNew[playerIndex][xTwo][yTwo] = PlayfieldNew[playerIndex][xTwo][yTwo-1]

					for playerIndex in range(3):
						for x in range(2, 12):
							PlayfieldNew[playerIndex][x][4] = 0

					#if (PlayerInput[player] != InputCore.InputCPU): AudioCore.PlayEffect(player, 5)
	elif (LogicCore.DisableMultiplayer == 1):
		for y in range (4, 24):
			boxTotal = 0

			for x in range (2, 12):
				if (PlayfieldNew[1][x][y] > 30 && PlayfieldNew[1][x][y] < 40):
					boxTotal+=1

			if boxTotal == 10:
				thereWasACompletedLine = true

				DrawEverything = 1

				if ClearCompletedLinesTimer < 40:
					ClearCompletedLinesTimer+=1

				if ClearCompletedLinesTimer % 10 == 0:
					for yTwo in range(y, 5, -1):
						for xTwo in range(2, 12):
							if (PlayfieldNew[1][xTwo][yTwo-1] < 1000 or PlayfieldNew[1][xTwo][yTwo-1] > 1009):  PlayfieldNew[1][xTwo][yTwo] = PlayfieldNew[1][xTwo][yTwo-1]

					for x in range(2, 12):
						PlayfieldNew[1][x][4] = 0

					#if (PlayerInput[player] != InputCore.InputCPU): AudioCore.PlayEffect(player, 5)

	if thereWasACompletedLine == false:
		DrawEverything = 1
		SetupNewPiece(player)
		PlayerStatus[player] = NewPieceDropping

	pass

#----------------------------------------------------------------------------------------
func MovePieceDown(player):
	var moveIt = true
	if (moveIt == true):
		PieceMoved = 1

		PiecePlayfieldY[player]+=1

		if PieceCollision(player) == CollisionWithPlayfield:
			var processMovement = true
			for p in range(3):
				if (PlayerStatus[p] != GameOver && PlayerStatus[p] != NewPieceDropping && PlayerStatus[p] != PieceFalling):  processMovement = false

			if (processMovement == false):
				PiecePlayfieldY[player]-=1
				return

			if (PlayersCanJoinIn == true && AllowComputerPlayers < 2):
				PlayersCanJoinIn = false

				if (AllowComputerPlayers > 0):
					PlayerInput[0] = InputCore.InputCPU
					PlayerStatus[0] = NewPieceDropping

					if (PlayerStatus[2] == GameOver):
						PlayerInput[2] = InputCore.InputCPU
						PlayerStatus[2] = NewPieceDropping
				elif (LogicCore.AllowComputerPlayers == 0):
					if (PlayerInput[0] == InputCore.InputNone):  PlayerStatus[0] = NewPieceDropping

					if (PlayerInput[2] == InputCore.InputNone):  PlayerStatus[2] = NewPieceDropping

			PiecePlayfieldY[player]-=1

			if (PlayerInput[player] != InputCore.InputCPU): AudioCore.PlayEffect(player, 4)

			Score[player]+=DropBonus[player]
			ScoreChanged = true
			DropBonus[player] = 0

			if PlayerStatus[player] == NewPieceDropping:
				AddCurrentPieceToPlayfieldMemory(player, Current)
				PlayerStatus[player] = GameOver
			else:
				CheckForCompletedLines(player)

	pass

#----------------------------------------------------------------------------------------
func MovePieceLeft(player):
	PieceMoved = 1

	if PlayerStatus[player] == NewPieceDropping:  return

	if (PlayerInput[player] == InputCore.InputCPU):
		PiecePlayfieldX[player]-=1

		if (PieceCollision(player) == CollisionWithPlayfield):
			PiecePlayfieldX[player]+=1
	elif (ScreensCore.OperatingSys != ScreensCore.OSAndroid):
		if PieceMovementDelay[player] > -8:
			PieceMovementDelay[player]-=1

		if (PieceMovementDelay[player] == -1 || PieceMovementDelay[player] < -7):
			PiecePlayfieldX[player]-=1

		if (PieceCollision(player) == CollisionWithPlayfield):
			PiecePlayfieldX[player]+=1
	elif (PlayerInput[player] != InputCore.InputCPU):
		if (AndroidMovePieceLeftDelay[player] == 1 || AndroidMovePieceLeftDelay[player] == 1+7 || AndroidMovePieceLeftDelay[player] == 8+6 || AndroidMovePieceLeftDelay[player] == 14+5 || AndroidMovePieceLeftDelay[player] > 19+4):
			PiecePlayfieldX[player]-=1

		if (PieceCollision(player) == CollisionWithPlayfield || PieceCollision(player) == CollisionWithPiece):
			PiecePlayfieldX[player]+=1

	pass

#----------------------------------------------------------------------------------------
func MovePieceRight(player):
	PieceMoved = 1

	if PlayerStatus[player] == NewPieceDropping:  return

	if (PlayerInput[player] == InputCore.InputCPU):
		PiecePlayfieldX[player]+=1

		if (PieceCollision(player) == CollisionWithPlayfield):
			PiecePlayfieldX[player]-=1
	elif (ScreensCore.OperatingSys != ScreensCore.OSAndroid):
		if PieceMovementDelay[player] < 8:
			PieceMovementDelay[player]+=1

		if (PieceMovementDelay[player] == 1 || PieceMovementDelay[player] > 7):
			PiecePlayfieldX[player]+=1

		if (PieceCollision(player) == CollisionWithPlayfield):
			PiecePlayfieldX[player]-=1
	elif (PlayerInput[player] != InputCore.InputCPU):
		if (AndroidMovePieceRightDelay[player] == 1 || AndroidMovePieceRightDelay[player] == 1+7 || AndroidMovePieceRightDelay[player] == 8+6 || AndroidMovePieceRightDelay[player] == 14+5 || AndroidMovePieceRightDelay[player] > 19+4):
			PiecePlayfieldX[player]+=1

		if (PieceCollision(player) == CollisionWithPlayfield || PieceCollision(player) == CollisionWithPiece):
			PiecePlayfieldX[player]-=1

	pass

#----------------------------------------------------------------------------------------
func RotatePieceCounterClockwise(player):
	if PlayerStatus[player] == NewPieceDropping:  return

	if PieceRotation[player] > 1:
		PieceRotation[player]-=1
	else:
		PieceRotation[player] = 4

	if PieceCollision(player) == CollisionNotTrue:
		if (PlayerInput[player] != InputCore.InputCPU): AudioCore.PlayEffect(player, 2)
		PieceMoved = 1
		return(true)
	else:
		if PieceRotation[player] < 4:
			PieceRotation[player]+=1
		else:
			PieceRotation[player] = 1

		if (MouseTouchRotateDir == 0):  MouseTouchRotateDir = 1
		else:  MouseTouchRotateDir = 0

	return(false)

#----------------------------------------------------------------------------------------
func RotatePieceClockwise(player):
	if PlayerStatus[player] == NewPieceDropping:  return

	if PieceRotation[player] < 4:
		PieceRotation[player]+=1
	else:
		PieceRotation[player] = 1

	if PieceCollision(player) == CollisionNotTrue:
		if (PlayerInput[player] != InputCore.InputCPU): AudioCore.PlayEffect(player, 2)
		PieceMoved = 1
		return(true)
	else:
		if PieceRotation[player] > 1:
			PieceRotation[player]-=1
		else:
			PieceRotation[player] = 4

		if (MouseTouchRotateDir == 0):  MouseTouchRotateDir = 1
		else:  MouseTouchRotateDir = 0

	return(false)

#----------------------------------------------------------------------------------------
func SetupNewPiece(player):
	AndroidMovePieceDownDelay[player] = 0
	AndroidMovePieceDownPressed[player] = false
	AndroidMovePieceLeftDelay[player] = 0
	AndroidMovePieceRightDelay[player] = 0

	PieceRotation[player] = 1

	PiecePlayfieldX[player] = 5

	PiecePlayfieldY[player] = 0

	if PieceBagIndex[player] < 7:
		PieceBagIndex[player]+=1
		Piece[player] = (PieceBag[player][0][ PieceBagIndex[player] ])
		NextPiece[player] = PieceBag[player][0][ PieceBagIndex[player] + 1 ]
	elif PieceBagIndex[player] == 7:
		FillPieceBag(player)
		Piece[player] = PieceBag[player][0][1]
		NextPiece[player] = PieceBag[player][0][2]
		PieceBagIndex[player] = 1

	PlayerStatus[player] = NewPieceDropping

	PieceDropTimer[player] = 0

	MovePieceDownDelay[player] = 0

	PieceRotatedOne[player] = false
	PieceRotatedTwo[player] = false

	PieceRotatedUp[player] = false

	BestMoveX[player] = -1
	BestRotation[player] = -1
	MovedToBestMove[player] = false

	CPUPlayerMovementSkip[player] = 0

	CPUPlayerForcedDirection[player] = CPUForcedFree
	CPUPlayerForcedMinX[player] = 0
	CPUPlayerForcedMaxX[player] = 31

	CPUPieceTestX[player] = 0
	CPURotationTest[player] = 1
	CPUComputedBestMove[player] = false

	pTXStep[player] = 1

	CPUPieceTestX[player] = 0

	bestValue[player] = 99999

	BestMoveX[player] = -1
	BestRotation[player] = -1

	CPUPieceTestX[player] = PiecePlayfieldX[player]

	PieceLandedResetAI = true

	SkipComputerPlayerMove[player] = 0

	pass

#----------------------------------------------------------------------------------------
func SetupForNewLevel():
	if (Level == 1 or SecretCodeCombined == 6161):  return

	for index in range(0, 5):
		InputCore.AndroidTouchOnePressed[index] = false
		InputCore.AndroidTouchOnePressedX[index] = 9999999
		InputCore.AndroidTouchOnePressedY[index] = 9999999
		InputCore.AndroidTouchOnePressed[index] = false
		InputCore.AndroidTouchOnePressedX[index] = 9999999
		InputCore.AndroidTouchOnePressedY[index] = 9999999

	ClearNewPlayfieldsWithCollisionDetection()

	PieceLandedResetAI = false

	for player in range(0, 3):
		PieceBagFirstUse[player] = true
		FillPieceBag(player)
		NextPiece[player] = PieceBag[player][0][2]

		PieceRotation[player] = 1

		PieceDropTimer[player] = 0
		TimeToDropPiece[player] = 47

		PieceRotatedOne[player] = false
		PieceRotatedTwo[player] = false

		PieceRotatedUp[player] = false

		DropBonus[player] = 0

		MovePieceDownDelay[player] = 0

		AndroidMovePieceDownDelay[player] = 0
		AndroidMovePieceDownPressed[player] = false
		AndroidMovePieceLeftDelay[player] = 0
		AndroidMovePieceRightDelay[player] = 0

		BestMoveX[player] = -1
		BestRotation[player] = -1
		MovedToBestMove[player] = false

		PieceMovementDelay[player] = 0

		CPUPlayerMovementSkip[player] = 0

		CPUPlayerForcedDirection[player] = CPUForcedFree
		CPUPlayerForcedMinX[player] = 0
		CPUPlayerForcedMaxX[player] = 31

		CPUPieceTestX[player] = 0
		CPURotationTest[player] = 1
		CPUComputedBestMove[player] = false

		pTXStep[player] = 1

		CPUPieceTestX[player] = 0

		bestValue[player] = 99999

		CPUPieceTestX[player] = PiecePlayfieldX[player]

		PieceInPlayfieldMemory[player] = false

		SkipComputerPlayerMove[player] = 0

		PlayerStatus[player] = NewPieceDropping

	ScoreChanged = true

	PiecePlayfieldX[0] = 5
	PiecePlayfieldY[0] = 0

	PiecePlayfieldX[1] = 5
	PiecePlayfieldY[1] = 0

	PiecePlayfieldX[2] = 5
	PiecePlayfieldY[2] = 0

	for index in range (0, 9):
		VisualsCore.PlayfieldSpriteCurrentIndex[index] = 0

	for index in range (0, 8):
		VisualsCore.PieceSpriteCurrentIndex[index] = 0

	PAUSEgame = false

	VisualsCore.KeyboardControlsAlphaTimer = 0.0

	FlashCompletedLinesTimer = 0
	FlashCompletedLinesTimerTwo = 0
	ClearCompletedLinesTimer = 0

	PlayfieldAlpha = 1
	PlayfieldAlphaDir = 0

	BoardFlip = 0

	DrawEverything = 1

	for index in range(0, 4):
		InterfaceCore.Icons.IconAnimationTimer[index] = -1

	PlayersCanJoinIn = false

	TotalLines = 0
	LevelCleared = false

	AddRandomBlocksToBottomTimer = 0

	pass

#----------------------------------------------------------------------------------------
func AddCurrentPieceToPlayfieldMemory(player, pieceValue):
	if (pieceValue == Temp):
		if (PieceInPlayfieldMemory[player] == true):  return(false)

	var value

	var tempPiece = Piece[player]
	var tempX = PiecePlayfieldX[player]
	var tempY = PiecePlayfieldY[player]
	var tempRot = PieceRotation[player]

	if (pieceValue == Fallen):
		value = (Piece[player] + 30)
	elif (pieceValue) == Temp:
		value = (Piece[player] + 1000)
	elif (pieceValue == Next):
		value = (NextPiece[player] + 10)

		DrawEverything = 1
		Piece[player] = NextPiece[player]
		PieceRotation[player] = 1

		PiecePlayfieldX[player] = 5

		PiecePlayfieldY[player] = 0
	elif (pieceValue == DropShadow && PlayerStatus[player] == PieceFalling):
		value = 2000
		for y in range(PiecePlayfieldY[player], 23):
			PiecePlayfieldY[player] = y
			if PieceCollision(player) != CollisionNotTrue:
				if (y - tempY) > 4:
					PiecePlayfieldY[player] = y-1
					break
				else:
					Piece[player] = tempPiece
					PiecePlayfieldX[player] = tempX
					PiecePlayfieldY[player] = tempY
					PieceRotation[player] = tempRot
					return

	if PieceData [Piece[player]] [PieceRotation[player]] [ 1] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]][PiecePlayfieldY[player]] = value
	if PieceData [Piece[player]] [PieceRotation[player]] [ 2] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+1][PiecePlayfieldY[player]] = value
	if PieceData [Piece[player]] [PieceRotation[player]] [ 3] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+2][PiecePlayfieldY[player]] = value
	if PieceData [Piece[player]] [PieceRotation[player]] [ 4] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+3][PiecePlayfieldY[player]] = value

	if PieceData [Piece[player]] [PieceRotation[player]] [ 5] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]][PiecePlayfieldY[player]+1] = value
	if PieceData [Piece[player]] [PieceRotation[player]] [ 6] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+1][PiecePlayfieldY[player]+1] = value
	if PieceData [Piece[player]] [PieceRotation[player]] [ 7] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+2][PiecePlayfieldY[player]+1] = value
	if PieceData [Piece[player]] [PieceRotation[player]] [ 8] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+3][PiecePlayfieldY[player]+1] = value

	if PieceData [Piece[player]] [PieceRotation[player]] [ 9] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]][PiecePlayfieldY[player]+2] = value
	if PieceData [Piece[player]] [PieceRotation[player]] [10] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+1][PiecePlayfieldY[player]+2] = value
	if PieceData [Piece[player]] [PieceRotation[player]] [11] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+2][PiecePlayfieldY[player]+2] = value
	if PieceData [Piece[player]] [PieceRotation[player]] [12] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+3][PiecePlayfieldY[player]+2] = value

	if PieceData [Piece[player]] [PieceRotation[player]] [13] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]][PiecePlayfieldY[player]+3] = value
	if PieceData [Piece[player]] [PieceRotation[player]] [14] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+1][PiecePlayfieldY[player]+3] = value
	if PieceData [Piece[player]] [PieceRotation[player]] [15] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+2][PiecePlayfieldY[player]+3] = value
	if PieceData [Piece[player]] [PieceRotation[player]] [16] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+3][PiecePlayfieldY[player]+3] = value

	Piece[player] = tempPiece
	PiecePlayfieldX[player] = tempX
	PiecePlayfieldY[player] = tempY
	PieceRotation[player] = tempRot

	if (pieceValue == Temp):
		PieceInPlayfieldMemory[player] = true

	return(true)

#----------------------------------------------------------------------------------------
func DeleteCurrentPieceFromPlayfieldMemory(player, pieceValue):
	var tempPiece = Piece[player]
	var tempX = PiecePlayfieldX[player]
	var tempY = PiecePlayfieldY[player]
	var tempRot = PieceRotation[player]

	if (pieceValue == Next):
		DrawEverything = 1
		Piece[player] = NextPiece[player]
		PieceRotation[player] = 1

		PiecePlayfieldX[player] = 5

		PiecePlayfieldY[player] = 0
	elif (pieceValue == DropShadow && PlayerStatus[player] == PieceFalling):
		for y in range(PiecePlayfieldY[player], 23):
			PiecePlayfieldY[player] = y
			if PieceCollision(player) != CollisionNotTrue:
				if (y - tempY) > 4:
					PiecePlayfieldY[player] = y-1
					break
				else:
					Piece[player] = tempPiece
					PiecePlayfieldX[player] = tempX
					PiecePlayfieldY[player] = tempY
					PieceRotation[player] = tempRot
					return

	if PieceData [Piece[player]] [PieceRotation[player]] [ 1] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]][PiecePlayfieldY[player]] = 0
	if PieceData [Piece[player]] [PieceRotation[player]] [ 2] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+1][PiecePlayfieldY[player]] = 0
	if PieceData [Piece[player]] [PieceRotation[player]] [ 3] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+2][PiecePlayfieldY[player]] = 0
	if PieceData [Piece[player]] [PieceRotation[player]] [ 4] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+3][PiecePlayfieldY[player]] = 0

	if PieceData [Piece[player]] [PieceRotation[player]] [ 5] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]][PiecePlayfieldY[player]+1] = 0
	if PieceData [Piece[player]] [PieceRotation[player]] [ 6] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+1][PiecePlayfieldY[player]+1] = 0
	if PieceData [Piece[player]] [PieceRotation[player]] [ 7] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+2][PiecePlayfieldY[player]+1] = 0
	if PieceData [Piece[player]] [PieceRotation[player]] [ 8] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+3][PiecePlayfieldY[player]+1] = 0

	if PieceData [Piece[player]] [PieceRotation[player]] [ 9] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]][PiecePlayfieldY[player]+2] = 0
	if PieceData [Piece[player]] [PieceRotation[player]] [10] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+1][PiecePlayfieldY[player]+2] = 0
	if PieceData [Piece[player]] [PieceRotation[player]] [11] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+2][PiecePlayfieldY[player]+2] = 0
	if PieceData [Piece[player]] [PieceRotation[player]] [12] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+3][PiecePlayfieldY[player]+2] = 0

	if PieceData [Piece[player]] [PieceRotation[player]] [13] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]][PiecePlayfieldY[player]+3] = 0
	if PieceData [Piece[player]] [PieceRotation[player]] [14] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+1][PiecePlayfieldY[player]+3] = 0
	if PieceData [Piece[player]] [PieceRotation[player]] [15] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+2][PiecePlayfieldY[player]+3] = 0
	if PieceData [Piece[player]] [PieceRotation[player]] [16] == 1:
		PlayfieldNew[player][PiecePlayfieldX[player]+3][PiecePlayfieldY[player]+3] = 0

	Piece[player] = tempPiece
	PiecePlayfieldX[player] = tempX
	PiecePlayfieldY[player] = tempY
	PieceRotation[player] = tempRot

	if (pieceValue == Temp):
		PieceInPlayfieldMemory[player] = false

	return(true)

#----------------------------------------------------------------------------------------
func AddRandomBlocksToBottom():
	if (SecretCodeCombined == 8888):  return

	DrawEverything = 1
	PieceMoved = 1

	var thereWillBeNoDownwardCollisions = true
	if (PlayerStatus[0] == PieceFalling):
		if (PieceCollisionDown(0) != CollisionNotTrue):
			thereWillBeNoDownwardCollisions = false
	if (PlayerStatus[1] == PieceFalling):
		if (PieceCollisionDown(1) != CollisionNotTrue):
			thereWillBeNoDownwardCollisions = false
	if (PlayerStatus[2] == PieceFalling):
		if (PieceCollisionDown(2) != CollisionNotTrue):
			thereWillBeNoDownwardCollisions = false

	if (thereWillBeNoDownwardCollisions == false):
		return

	for p in range(3):
		for y in range(4, 24):
			for x in range(2, 12):
				PlayfieldNew[p][x][y] = PlayfieldNew[p][x][y+1]

	var boxCount = 0
	for pTwo in range(3):
		for x in range(2, 12):
			if (boxCount < 29):
				var randomBox= (  ( randi() % 8 )  )
				if (randomBox > 0):
					PlayfieldNew[pTwo][x][23] = (randomBox + 30)
				else:
					PlayfieldNew[pTwo][x][23] = 0
			else:
				PlayfieldNew[pTwo][x][23] = 0

			if (PlayfieldNew[pTwo][x][23] > 0):
				boxCount+=1

	AudioCore.PlayEffect(1, 7)

	pass

#----------------------------------------------------------------------------------------
func CheckForNewPlayers():
	if (LogicCore.DisableMultiplayer == 1):  return

	if (PlayersCanJoinIn == true):
		ScoreChanged = true

		if (InputCore.JoyButtonOne[InputCore.InputKeyboard] == InputCore.Pressed):
			if (PlayerInput[0] != InputCore.InputKeyboard && PlayerInput[1] != InputCore.InputKeyboard && PlayerInput[2] != InputCore.InputKeyboard):
				if (PlayerInput[0] == InputCore.InputNone):
					PlayerStatus[0] = NewPieceDropping
					PlayerInput[0] = InputCore.InputKeyboard
				elif (PlayerInput[2] == InputCore.InputNone):
					PlayerStatus[2] = NewPieceDropping
					PlayerInput[2] = InputCore.InputKeyboard
		elif (InputCore.JoyButtonOne[InputCore.InputJoyOne] == InputCore.Pressed):
			if (PlayerInput[0] != InputCore.InputJoyOne && PlayerInput[1] != InputCore.InputJoyOne && PlayerInput[2] != InputCore.InputJoyOne):
				if (PlayerInput[0] == InputCore.InputNone):
					PlayerStatus[0] = NewPieceDropping
					PlayerInput[0] = InputCore.InputJoyOne
				elif (PlayerInput[2] == InputCore.InputNone):
					PlayerStatus[2] = NewPieceDropping
					PlayerInput[2] = InputCore.InputJoyOne
		elif (InputCore.JoyButtonOne[InputCore.InputJoyTwo] == InputCore.Pressed):
			if (PlayerInput[0] != InputCore.InputJoyTwo && PlayerInput[1] != InputCore.InputJoyTwo && PlayerInput[2] != InputCore.InputJoyTwo):
				if (PlayerInput[0] == InputCore.InputNone):
					PlayerStatus[0] = NewPieceDropping
					PlayerInput[0] = InputCore.InputJoyTwo
				elif (PlayerInput[2] == InputCore.InputNone):
					PlayerStatus[2] = NewPieceDropping
					PlayerInput[2] = InputCore.InputJoyTwo
		elif (InputCore.JoyButtonOne[InputCore.InputJoyThree] == InputCore.Pressed):
			if (PlayerInput[0] != InputCore.InputJoyThree && PlayerInput[1] != InputCore.InputJoyThree && PlayerInput[2] != InputCore.InputJoyThree):
				if (PlayerInput[0] == InputCore.InputNone):
					PlayerStatus[0] = NewPieceDropping
					PlayerInput[0] = InputCore.InputJoyThree
				elif (PlayerInput[2] == InputCore.InputNone):
					PlayerStatus[2] = NewPieceDropping
					PlayerInput[2] = InputCore.InputJoyThree

		if (PlayerInput[0] != InputCore.InputNone):
			VisualsCore.DrawSprite(137, (VisualsCore.ScreenWidth/2.0)+260, (VisualsCore.ScreenHeight/2.0)+9999, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

		if (PlayerInput[2] != InputCore.InputNone):
			VisualsCore.DrawSprite(138, (VisualsCore.ScreenWidth/2.0)+260, (VisualsCore.ScreenHeight/2.0)+9999, 1.0, 1.0, 0, 1.0, 1.0, 1.0, 1.0)

		if (PlayerStatus[0] != GameOver && PlayerStatus[1] != GameOver && PlayerStatus[2] != GameOver):
			PlayersCanJoinIn = false

	pass

#----------------------------------------------------------------------------------------
func ProcessPieceFall(player):
	if (PlayerInput[player] == InputCore.InputCPU and PlayerStatus[player] != PieceFalling):  return

	if (PlayerInput[player] == InputCore.InputKeyboard or PlayerInput[player] == InputCore.InputJoyOne or PlayerInput[player] == InputCore.InputJoyTwo or PlayerInput[player] == InputCore.InputJoyThree):
		if (InputCore.JoystickDirection[PlayerInput[player]] == InputCore.JoyDown):
			PieceDropTimer[player] = 0
			return

	if (player > -1 and player < 3):	
		if PieceDropTimer[player] > TimeToDropPiece[player]:
			if PieceCollisionDown(player) != CollisionWithPiece:
				if (InputCore.JoystickDirection[PlayerInput[player]] != InputCore.JoyDown):
					if (MovePieceDownDelay[player] == 0):
						if (PlayerInput[player] != InputCore.InputCPU):  AudioCore.PlayEffect(player, 3)

				MovePieceDown(player)
				PieceDropTimer[player] = 0
	pass

#----------------------------------------------------------------------------------------
func CheckForChangePlayfield(player):
	if (AllowComputerPlayers > 0):  return

	if (LogicCore.DisableMultiplayer == 1):  return

	if (PlayersCanJoinIn == false && InputCore.DelayAllUserInput == -1):
		InputCore.DelayAllUserInput = 15
		ScoreChanged = true

		var pPF = PlayerPlayfield[player]
		var pPFIndex = -1
		if (PlayerPlayfield[player] == 0):
			if (PlayerInput[1] == InputCore.InputNone):
				AudioCore.PlayEffect(player, 0)
				Score[1] = Score[0]
				Score[0] = 0
				PlayerInput[1] = PlayerInput[0]
				PlayerInput[0] = InputCore.InputNone
				PlayerPlayfield[player] = 1
				pPFIndex = 0
			elif (PlayerInput[2] == InputCore.InputNone):
				AudioCore.PlayEffect(player, 0)
				Score[2] = Score[0]
				Score[0] = 0
				PlayerInput[2] = PlayerInput[0]
				PlayerInput[0] = InputCore.InputNone
				PlayerPlayfield[player] = 2
				pPFIndex = 0
		elif (PlayerPlayfield[player] == 1):
			if (PlayerInput[2] == InputCore.InputNone):
				AudioCore.PlayEffect(player, 0)
				Score[2] = Score[1]
				Score[1] = 0
				PlayerInput[2] = PlayerInput[1]
				PlayerInput[1] = InputCore.InputNone
				PlayerPlayfield[player] = 2
				pPFIndex = 1
			elif (PlayerInput[0] == InputCore.InputNone):
				AudioCore.PlayEffect(player, 0)
				Score[0] = Score[1]
				Score[1] = 0
				PlayerInput[0] = PlayerInput[1]
				PlayerInput[1] = InputCore.InputNone
				PlayerPlayfield[player] = 0
				pPFIndex = 1
		elif (PlayerPlayfield[player] == 2):
			if (PlayerInput[0] == InputCore.InputNone):
				AudioCore.PlayEffect(player, 0)
				Score[0] = Score[2]
				Score[2] = 0
				PlayerInput[0] = PlayerInput[2]
				PlayerInput[2] = InputCore.InputNone
				PlayerPlayfield[player] = 0
				pPFIndex = 2
			elif (PlayerInput[1] == InputCore.InputNone):
				AudioCore.PlayEffect(player, 0)
				Score[1] = Score[2]
				Score[2] = 0
				PlayerInput[1] = PlayerInput[2]
				PlayerInput[2] = InputCore.InputNone
				PlayerPlayfield[player] = 1
				pPFIndex = 2

		PlayerPlayfield[pPFIndex] = pPF

	pass

#----------------------------------------------------------------------------------------
func GetHumanPlayersKeyboardAndGameControllersMoves(player):
	if (ScreensCore.OperatingSys != ScreensCore.OSAndroid):
		if (PlayerInputDone[player] == PlayerInput[player]):  return
		else:  PlayerInputDone[player] = PlayerInput[player]

		if (InputCore.JoystickDirection[PlayerInput[player]] == InputCore.JoyLeft):
			MovePieceLeft(player)
		elif (InputCore.JoystickDirection[PlayerInput[player]] == InputCore.JoyRight):
			MovePieceRight(player)
		else:
			PieceMovementDelay[player] = 0

		if (InputCore.JoystickDirection[PlayerInput[player]] == InputCore.JoyUp):
			if (LogicCore.AllowComputerPlayers > 0):
				if PieceRotatedUp[player] == false:
					var _warnErase = RotatePieceClockwise(player)
					PieceRotatedUp[player] = true
			else:
				CheckForChangePlayfield(player)
		else:
			PieceRotatedUp[player] = false

		if (InputCore.JoystickDirection[PlayerInput[player]] == InputCore.JoyDown):
			MovePieceDownDelay[player]+=1
			MovePieceDown(player)
			DropBonus[player]+=1
		else:
			MovePieceDownDelay[player] = 0
			DropBonus[player] = 0

		if InputCore.JoyButtonOne[PlayerInput[player]] == InputCore.Pressed:
			if PieceRotatedOne[player] == false:
				var _warnErase = RotatePieceCounterClockwise(player)
				PieceRotatedOne[player] = true
		else:
			PieceRotatedOne[player] = false

		if InputCore.JoyButtonTwo[PlayerInput[player]] == InputCore.Pressed:
			if PieceRotatedTwo[player] == false:
				var _warnErase = RotatePieceClockwise(player)
				PieceRotatedTwo[player] = true
		else:
			PieceRotatedTwo[player] = false

	pass

#----------------------------------------------------------------------------------------
func GetHumanPlayerMouseMoves(player):
	if (ScreensCore.OperatingSys != ScreensCore.OSAndroid):
		if PieceDropTimer[player] > TimeToDropPiece[player]:
			if PieceCollisionDown(player) != CollisionWithPiece:
				MovePieceDown(player)
				PieceDropTimer[player] = 0

		if InterfaceCore.ThisIconWasPressed(2+1) == true:
			AndroidMovePieceLeftDelay[player]+=1
			MovePieceLeft(player)
			AndroidMovePieceRightDelay[player] = 0
		elif InterfaceCore.ThisIconWasPressed(3+1) == true:
			AndroidMovePieceRightDelay[player]+=1
			MovePieceRight(player)
			AndroidMovePieceLeftDelay[player] = 0
		else:
			AndroidMovePieceLeftDelay[player] = 0
			AndroidMovePieceRightDelay[player] = 0
			PieceMovementDelay[player] = 0

		if InterfaceCore.ThisIconWasPressed(4+1) == true:
			if PieceCollisionDown(player) != CollisionWithPiece:
				AndroidMovePieceDownDelay[player]+=1
				if (AndroidMovePieceDownDelay[player] == 1 || AndroidMovePieceDownDelay[player] == 6 || AndroidMovePieceDownDelay[player] == 10 || AndroidMovePieceDownDelay[player] == 13 || AndroidMovePieceDownDelay[player] == 15 || AndroidMovePieceDownDelay[player] > 16):
					PieceDropTimer[player] = 0
					DropBonus[player]+=1
					MovePieceDown(player)
					AndroidMovePieceDownPressed[player] = true
		else:
			DropBonus[player] = 0
			AndroidMovePieceDownDelay[player] = 0
			AndroidMovePieceDownPressed[player] = false

		if InterfaceCore.ThisIconWasPressed(5+1) == true:
			if PieceRotatedOne[player] == false:
				var _warnErase
				if (MouseTouchRotateDir == 0):
					_warnErase = RotatePieceClockwise(player)
				elif (MouseTouchRotateDir == 1):
					_warnErase = RotatePieceCounterClockwise(player)

				PieceRotatedOne[player] = true
		else:
			PieceRotatedOne[player] = false

		if (PlayersCanJoinIn == true):  return

		if InterfaceCore.ThisIconWasPressed(6+1) == true:
			CheckForChangePlayfield(player)

	pass

#----------------------------------------------------------------------------------------
func GetHumanPlayerTouchOneMoves(player):
	var offset = 1
	if (LogicCore.DisableMultiplayer == 1):  offset = -1+1
	if InterfaceCore.ThisIconWasPressed(2+offset) == true:
		AndroidMovePieceLeftDelay[player]+=1
		MovePieceLeft(player)
		AndroidMovePieceRightDelay[player] = 0
	elif InterfaceCore.ThisIconWasPressed(3+offset) == true:
		AndroidMovePieceRightDelay[player]+=1
		MovePieceRight(player)
		AndroidMovePieceLeftDelay[player] = 0
	else:
		AndroidMovePieceLeftDelay[player] = 0
		AndroidMovePieceRightDelay[player] = 0
		PieceMovementDelay[player] = 0

	if InterfaceCore.ThisIconWasPressed(4+offset) == true:
		if PieceCollisionDown(player) != CollisionWithPiece:
			AndroidMovePieceDownDelay[player]+=1
			if (AndroidMovePieceDownDelay[player] == 1 || AndroidMovePieceDownDelay[player] == 6 || AndroidMovePieceDownDelay[player] == 10 || AndroidMovePieceDownDelay[player] == 13 || AndroidMovePieceDownDelay[player] == 15 || AndroidMovePieceDownDelay[player] > 16):
				PieceDropTimer[player] = 0
				DropBonus[player]+=1
				MovePieceDown(player)
				AndroidMovePieceDownPressed[player] = true
	else:
		DropBonus[player] = 0
		AndroidMovePieceDownDelay[player] = 0
		AndroidMovePieceDownPressed[player] = false

	if InterfaceCore.ThisIconWasPressed(5+offset) == true:
		if PieceRotatedOne[player] == false:
			var _warnErase = RotatePieceClockwise(player)
			PieceRotatedOne[player] = true
	else:
		PieceRotatedOne[player] = false

	if (PlayersCanJoinIn == false):
		if InterfaceCore.ThisIconWasPressed(6+offset) == true:
			CheckForChangePlayfield(player)

	pass

#----------------------------------------------------------------------------------------
func GetHumanPlayerTouchTwoMoves(player):
	var offset = 7+1
	
	if InterfaceCore.ThisIconWasPressed(offset) == true:
		AndroidMovePieceLeftDelay[player]+=1
		MovePieceLeft(player)
		AndroidMovePieceRightDelay[player] = 0
	elif InterfaceCore.ThisIconWasPressed(offset+1) == true:
		AndroidMovePieceRightDelay[player]+=1
		MovePieceRight(player)
		AndroidMovePieceLeftDelay[player] = 0
	else:
		AndroidMovePieceLeftDelay[player] = 0
		AndroidMovePieceRightDelay[player] = 0
		PieceMovementDelay[player] = 0

	if InterfaceCore.ThisIconWasPressed(offset+2) == true:
		if PieceCollisionDown(player) != CollisionWithPiece:
			AndroidMovePieceDownDelay[player]+=1
			if (AndroidMovePieceDownDelay[player] == 1 || AndroidMovePieceDownDelay[player] == 6 || AndroidMovePieceDownDelay[player] == 10 || AndroidMovePieceDownDelay[player] == 13 || AndroidMovePieceDownDelay[player] == 15 || AndroidMovePieceDownDelay[player] > 16):
				PieceDropTimer[player] = 0
				DropBonus[player]+=1
				MovePieceDown(player)
				AndroidMovePieceDownPressed[player] = true
	else:
		DropBonus[player] = 0
		AndroidMovePieceDownDelay[player] = 0
		AndroidMovePieceDownPressed[player] = false

	if InterfaceCore.ThisIconWasPressed(offset+3) == true:
		if PieceRotatedOne[player] == false:
			var _warnErase = RotatePieceClockwise(player)
			PieceRotatedOne[player] = true
	else:
		PieceRotatedOne[player] = false

	if (PlayersCanJoinIn == false):
		if InterfaceCore.ThisIconWasPressed(offset+4) == true:
			CheckForChangePlayfield(player)

	pass

#----------------------------------------------------------------------------------------
# /\/\________.__  _____  __    ________   _____    _________.__       .__     __ /\/\
# )/)/  _____/|__|/ ____\/  |_  \_____  \_/ ____\  /   _____/|__| ____ |  |___/  |)/)/
#   /   \  ___|  \   __\\   __\  /   |   \   __\   \_____  \ |  |/ ___\|  |  \   __\
#   \    \_\  \  ||  |   |  |   /    |    \  |     /        \|  / /_/  >   Y  \  |
#    \______  /__||__|   |__|   \_______  /__|    /_______  /|__\___  /|___|  /__|
#           \/                          \/                \/   /_____/      \/v5.0
#
# Cooperative Puzzle Artificial Intelligence A.I. By Yiyuan Lee, "JeZxLee", & "flairetic"
#

func ComputeComputerPlayerMove(player):
	if (CPUComputedBestMove[player] == false):
		var TEMP_BreakFromDoubleForLoop
		for posX in range (0, 12):
			for rot in range (1, MaxRotationArray[Piece[player]]+1):
				MovePieceHeight[player][posX][rot] = 0
				MoveTrappedHoles[player][posX][rot] = 0
				MoveOneBlockCavernHoles[player][posX][rot] = 0
				MovePlayfieldBoxEdges[player][posX][rot] = 0
				MoveCompletedLines[player][posX][rot] = 0

				MovePieceCollision[player][posX][rot] = true

#-- Compute, prioritize, & store all player moves ------------------------------
		TEMP_BreakFromDoubleForLoop = false
		for NewCPUPieceTestX in range (0, 12):
			if (TEMP_BreakFromDoubleForLoop == false):
				for NewCPURotationTest in range (1, MaxRotationArray[Piece[player]]+1):
					if (TEMP_BreakFromDoubleForLoop == false):
						TEMP_PieceRotation = PieceRotation[player]
						TEMP_PiecePlayfieldX = PiecePlayfieldX[player]
						TEMP_PiecePlayfieldY = PiecePlayfieldY[player]

						PiecePlayfieldX[player] = NewCPUPieceTestX
						PieceRotation[player] = NewCPURotationTest

						MovePieceCollision[player][NewCPUPieceTestX][NewCPURotationTest] = false
						if (PieceCollision(player) == CollisionNotTrue):
							var TEMP_BreakFromForLoop = false
							for posY in range(PiecePlayfieldY[player], 23):
								if (TEMP_BreakFromForLoop == false):
									PiecePlayfieldY[player] = posY
									if ( PieceCollision(player) == CollisionWithPlayfield ):
										PiecePlayfieldY[player]-=1

										TEMP_BreakFromForLoop = true

										MovePieceHeight[player][NewCPUPieceTestX][NewCPURotationTest] = (23 - PiecePlayfieldY[player])

										AddCurrentPieceToPlayfieldMemory(player, Temp)

										for posX in range(0, 12):
											for posYtwo in range(23, 6, -1):
												if (  (PlayfieldNew[player][posX][posYtwo] == 0) && ( (PlayfieldNew[player][posX][posYtwo-1] > 30 && PlayfieldNew[player][posX][posYtwo-1] < 40) || (PlayfieldNew[player][posX][posYtwo-1] > 1000 && PlayfieldNew[player][posX][posYtwo-1] < 1010) )  ):
													MoveTrappedHoles[player][NewCPUPieceTestX][NewCPURotationTest]+=1

										for posYfour in range(5, 23):
											for posX in range(2, 12):
												if (PlayfieldNew[player][posX][posYfour] == 0 && PlayfieldNew[player][(posX-1)][posYfour] != 0 && PlayfieldNew[player][(posX+1)][posYfour] != 0):
													MoveOneBlockCavernHoles[player][NewCPUPieceTestX][NewCPURotationTest]+=1

										for posYthree in range(5, 23):
											for posX in range(2, 12):
												if ( (PlayfieldNew[player][posX][posYthree] > 30 && PlayfieldNew[player][posX][posYthree] < 40) || (PlayfieldNew[player][posX][posYthree] > 1000 && PlayfieldNew[player][posX][posYthree] < 1010) || PlayfieldNew[player][posX][posYthree] == 255 ):
													if (PlayfieldNew[player][posX][(posYthree-1)] == 0):
														MovePlayfieldBoxEdges[player][NewCPUPieceTestX][NewCPURotationTest]+=1

													if (PlayfieldNew[player][posX][(posYthree+1)] == 0):
														MovePlayfieldBoxEdges[player][NewCPUPieceTestX][NewCPURotationTest]+=1

													if (PlayfieldNew[player][(posX-1)][posYthree] == 0):
														MovePlayfieldBoxEdges[player][NewCPUPieceTestX][NewCPURotationTest]+=1

													if (PlayfieldNew[player][(posX+1)][posYthree] == 0):
														MovePlayfieldBoxEdges[player][NewCPUPieceTestX][NewCPURotationTest]+=1

										var boxTotal
										for y in range(4, 24):
											boxTotal = 0
											for p in range(3):
												for x in range (2, 12):
													if ( (PlayfieldNew[p][x][y] > 30 && PlayfieldNew[p][x][y] < 40) || (PlayfieldNew[p][x][y] > 1000 && PlayfieldNew[p][x][y] < 1010) ):
														boxTotal+=1

											if (boxTotal == 30):
												MoveCompletedLines[player][NewCPUPieceTestX][NewCPURotationTest]+=1

										DeleteCurrentPieceFromPlayfieldMemory(player, Temp)

										PieceRotation[player] = TEMP_PieceRotation
										PiecePlayfieldX[player] = TEMP_PiecePlayfieldX
										PiecePlayfieldY[player] = TEMP_PiecePlayfieldY
						else:
							CPUComputedBestMove[player] = false

							MovePieceCollision[player][NewCPUPieceTestX][NewCPURotationTest] = true
							PieceRotation[player] = TEMP_PieceRotation
							PiecePlayfieldX[player] = TEMP_PiecePlayfieldX
							PiecePlayfieldY[player] = TEMP_PiecePlayfieldY

#-- Choose best move & rotation in either left or right direction ----------------------------------
		var TEMP_BestValue = 9999999.0
		for posX in range (0, 12):
			for rot in range (1, MaxRotationArray[Piece[player]]+1):
				if (MovePieceCollision[player][posX][rot] == false):

					MovePieceHeight[player][posX][rot] -= MoveCompletedLines[player][posX][rot]

					var testValue = ( (3.0*MoveTrappedHoles[player][posX][rot])
									+(1.0*MoveOneBlockCavernHoles[player][posX][rot])
									+(1.0*MovePlayfieldBoxEdges[player][posX][rot])
									+(1.0*MovePieceHeight[player][posX][rot]) )

					if (testValue <= TEMP_BestValue):
						TEMP_BestValue = testValue
						BestMoveX[player] = posX
						BestRotation[player] = rot

		CPUComputedBestMove[player] = true
		MovedToBestMove[player] = false

#-- Rotate & move falling piece to best ------------------------------------------------------------
	elif (CPUComputedBestMove[player] == true):
		if (MovedToBestMove[player] == false):
			if (PieceRotation[player] < BestRotation[player]):
				RotatePieceClockwise(player)
			elif (PieceRotation[player] > BestRotation[player]):
				RotatePieceCounterClockwise(player)
			else:
				if (BestMoveX[player] < PiecePlayfieldX[player]):
					MovePieceLeft(player)
				elif (BestMoveX[player] > PiecePlayfieldX[player]):
					MovePieceRight(player)
				else:
					MovedToBestMove[player] = true
		elif (MovedToBestMove[player] == true):
			for p in range(0, 3):
				PlayerHeights[p] = ReadPlayerHeight(p)

			var skip = 30

			for pTwo in range(0, 3):
				if (player != pTwo):
					if (PlayerHeights[player] > PlayerHeights[pTwo]):
						skip = 0

			if (SkipComputerPlayerMove[player] >= skip):
				SkipComputerPlayerMove[player] = 0
				PieceDropTimer[player] = (TimeToDropPiece[player]+1)
			else:
				SkipComputerPlayerMove[player]+=1
				PieceDropTimer[player] = 0

	pass
#---------------------------------------------------------------------------------------------------

# Cooperative Puzzle Artificial Intelligence A.I. By Yiyuan Lee, "JeZxLee", & "flairetic"

#   /\/\________.__  _____  __    ________   _____    _________.__       .__     __ /\/\
#   )/)/  _____/|__|/ ____\/  |_  \_____  \_/ ____\  /   _____/|__| ____ |  |___/  |)/)/
#     /   \  ___|  \   __\\   __\  /   |   \   __\   \_____  \ |  |/ ___\|  |  \   __\
#     \    \_\  \  ||  |   |  |   /    |    \  |     /        \|  / /_/  >   Y  \  |
#      \______  /__||__|   |__|   \_______  /__|    /_______  /|__\___  /|___|  /__|
#             \/                          \/                \/   /_____/      \/v5.0
#

#----------------------------------------------------------------------------------------
func AddIncompleteLineToBottom(player):
	if (player == 2):
		var allPiecesAreFalling = true
		if (PlayerStatus[0] != PieceFalling && PlayerStatus[0] != GameOver):
			allPiecesAreFalling = false
		if (PlayerStatus[1] != PieceFalling && PlayerStatus[1] != GameOver):
			allPiecesAreFalling = false
		if (PlayerStatus[2] != PieceFalling && PlayerStatus[2] != GameOver):
			allPiecesAreFalling = false

		if (allPiecesAreFalling == true):
			AddRandomBlocksToBottomTimer+=1

			var timeForCrisis = 375+(100*2)
			if (ScreensCore.OperatingSys == ScreensCore.OSAndroid):
				timeForCrisis+=175

			if (AddRandomBlocksToBottomTimer > timeForCrisis):
				AddRandomBlocksToBottom()
				AddRandomBlocksToBottomTimer = 0

	pass

#----------------------------------------------------------------------------------------
func CheckForLevelAdvance():
	if ( TotalLines > (levelAdjust[GameMode]) ):
		TotalLines = 0
		InputCore.DelayAllUserInput = 25
		ScreensCore.ScreenFadeStatus = ScreensCore.FadingToBlack
		ScreensCore.ScreenToDisplayNext = ScreensCore.CutSceneScreen
		Level+=1
		ScreensCore.CutSceneScene = 1
		VisualsCore.SetFramesPerSecond(30)

		LevelCleared = true

		if (Level < 10):
			AudioCore.PlayMusic(Level, true)
		elif (Level == 10):
			InputCore.DelayAllUserInput = 100
			StillPlaying = false
			GameWon = true
			VisualsCore.SetFramesPerSecond(30)

			ScreensCore.ScreenFadeStatus = ScreensCore.FadingToBlack
			ScreensCore.ScreenToDisplayNext = ScreensCore.WonGameScreen

			SecretCode[0] = 5
			SecretCode[1] = 4
			SecretCode[2] = 3
			SecretCode[3] = 1
			SecretCodeCombined = (SecretCode[0]*1000)+(SecretCode[1]*100)+(SecretCode[2]*10)+(SecretCode[3]*1)

	pass

#----------------------------------------------------------------------------------------
func CheckForGameOver():
	if (LogicCore.DisableMultiplayer == 0):
		if ( (PlayerInput[0] != InputCore.InputNone and PlayerStatus[0] == GameOver) or (PlayerInput[1] != InputCore.InputNone and PlayerStatus[1] == GameOver) or (PlayerInput[2] != InputCore.InputNone and PlayerStatus[2] == GameOver) ):
			VisualsCore.SetFramesPerSecond(30)

			AudioCore.PlayEffect(1, 8)
			AudioCore.PlayMusic(0, true)

			StillPlaying = false

			InputCore.DelayAllUserInput = 50

			ScreensCore.ScreenFadeStatus = ScreensCore.FadingToBlack
	elif (LogicCore.DisableMultiplayer == 1):
		if (PlayerStatus[1] == GameOver):
			VisualsCore.SetFramesPerSecond(30)

			AudioCore.PlayEffect(1, 8)
			AudioCore.PlayMusic(0, true)

			StillPlaying = false

			InputCore.DelayAllUserInput = 50

			ScreensCore.ScreenFadeStatus = ScreensCore.FadingToBlack

	pass

#----------------------------------------------------------------------------------------
func AddToPlayfieldAllPlayerPiecesAndDropShadows():
	for player in range(0, 3):
		if (PlayerStatus[player] == PieceFalling or PlayerStatus[player] == NewPieceDropping):
			AddCurrentPieceToPlayfieldMemory(player, DropShadow)
			AddCurrentPieceToPlayfieldMemory(player, Temp)

	pass

#----------------------------------------------------------------------------------------
func DeleteFromPlayfieldAllPlayerPiecesAndDropShadows():
	for player in range(0, 3):
		if (PlayerStatus[player] == PieceFalling or PlayerStatus[player] == NewPieceDropping):
			AddCurrentPieceToPlayfieldMemory(player, Temp)
			DeleteCurrentPieceFromPlayfieldMemory(player, DropShadow)
			DeleteCurrentPieceFromPlayfieldMemory(player, Temp)

	pass

#----------------------------------------------------------------------------------------
func DoAnyPlayersHaveCompletedLine():
	var returnValue = false
	if (PlayerStatus[0] == FlashingCompletedLines || PlayerStatus[0] == ClearingCompletedLines):
		returnValue = true
	if (PlayerStatus[1] == FlashingCompletedLines || PlayerStatus[1] == ClearingCompletedLines):
		returnValue = true
	if (PlayerStatus[2] == FlashingCompletedLines || PlayerStatus[2] == ClearingCompletedLines):
		returnValue = true

	return(returnValue)

#----------------------------------------------------------------------------------------
func RunPuzzleGameCore():
	if PAUSEgame == false:
		CheckForNewPlayers()
		CheckForLevelAdvance()
		CheckForGameOver()

		if (LogicCore.SecretCodeCombined == 2778 or LogicCore.SecretCodeCombined == 2779 or LogicCore.SecretCodeCombined == 1234):
			PlayerStatus[0] = GameOver
			PlayerStatus[2] = GameOver

		for player in range(0, 3):
			if PlayerStatus[player] != GameOver:
				if (LogicCore.SecretCodeCombined != 6161):  PieceDropTimer[player]+=1

				if (PlayerStatus[player] == NewPieceDropping):
					DrawEverything = 1
					PieceMoved = 1

					if PiecePlayfieldY[player] < PieceDropStartHeight[ Piece[player] ]:
						if (PieceCollisionDown(player) == CollisionNotTrue):
							MovePieceDown(player)

						if (PieceCollisionDown(player) == CollisionWithPlayfield):
							PlayerStatus[player] = GameOver
					else:
						AddCurrentPieceToPlayfieldMemory(player, Next)
						PlayerStatus[player] = PieceFalling
				elif PlayerStatus[player] == PieceFalling:
					if (PlayerInput[player] == InputCore.InputCPU and PiecePlayfieldY[player] < 5):  PieceDropTimer[player] = TimeToDropPiece[player]+1

					if (PlayerInput[player] == InputCore.InputKeyboard || PlayerInput[player] == InputCore.InputJoyOne || PlayerInput[player] == InputCore.InputJoyTwo || PlayerInput[player] == InputCore.InputJoyThree):
						GetHumanPlayersKeyboardAndGameControllersMoves(player)
					elif (PlayerInput[player] == InputCore.InputMouse):
						GetHumanPlayerMouseMoves(player)
					elif (PlayerInput[player] == InputCore.InputTouchOne):
						GetHumanPlayerTouchOneMoves(player)
					elif (PlayerInput[player] == InputCore.InputTouchTwo):
						GetHumanPlayerTouchTwoMoves(player)
					elif (PlayerInput[player] == InputCore.InputCPU && AllowComputerPlayers > 0):
						ComputeComputerPlayerMove(player)

					ProcessPieceFall(player)
				else:
					if (PlayerStatus[player] == FlashingCompletedLines):
						FlashCompletedLines(player)
					elif (PlayerStatus[player] == ClearingCompletedLines):
						ClearCompletedLines(player)

		PlayerInputDone[0] = InputCore.InputNone
		PlayerInputDone[1] = InputCore.InputNone
		PlayerInputDone[2] = InputCore.InputNone

	pass

#----------------------------------------------------------------------------------------
func _ready():
	SecretCode.append(0)
	SecretCode.append(0)
	SecretCode.append(0)
	SecretCode.append(0)

	LogicCore.SecretCodeCombined = 0000

	InitializePieceData()

	var _warnErase = PlayfieldNew.resize(3)
	for player in range(3):
		PlayfieldNew[player] = []
		PlayfieldNew[player].resize(15)
		for x in range(15):
			PlayfieldNew[player][x] = []
			PlayfieldNew[player][x].resize(26)
			for y in range(26):
				PlayfieldNew[player][x][y] = []

	_warnErase = PlayfieldMoveAI.resize(35)
	for x in range(35):
		PlayfieldMoveAI[x] = []
		PlayfieldMoveAI[x].resize(26)
		for y in range(26):
			PlayfieldMoveAI[x][y] = []

	_warnErase = PieceBagIndex.resize(3)

	_warnErase = PieceBag.resize(3)
	for player in range(3):
		PieceBag[player] = []
		PieceBag[player].resize(2)
		for bag in range(2):
			PieceBag[player][bag] = []
			PieceBag[player][bag].resize(9)

	_warnErase = PieceSelectedAlready.resize(3)
	for player in range(3):
		PieceSelectedAlready[player] = []
		_warnErase = PieceSelectedAlready[player].resize(9)

	_warnErase = Piece.resize(3)

	_warnErase = NextPiece.resize(3)

	_warnErase = PieceRotation.resize(3)
	_warnErase = PiecePlayfieldX.resize(3)
	_warnErase = PiecePlayfieldY.resize(3)

	_warnErase = PieceDropTimer.resize(3)
	_warnErase = TimeToDropPiece.resize(3)

	_warnErase = PlayerStatus.resize(3)

	_warnErase = PieceDropStartHeight.resize(8)
	PieceDropStartHeight[0] = 0
	PieceDropStartHeight[1] = 4
	PieceDropStartHeight[2] = 4
	PieceDropStartHeight[3] = 4
	PieceDropStartHeight[4] = 4
	PieceDropStartHeight[5] = 4
	PieceDropStartHeight[6] = 3
	PieceDropStartHeight[7] = 5

	_warnErase = PieceBagFirstUse.resize(3)

	_warnErase = PieceMovementDelay.resize(3)

	_warnErase = PieceRotatedOne.resize(3)
	_warnErase = PieceRotatedTwo.resize(3)

	_warnErase = PieceRotatedUp.resize(3)

	_warnErase = Score.resize(3)
	Score[0] = 0
	Score[1] = 0
	Score[2] = 0

	Level = 1

	_warnErase = DropBonus.resize(3)
	
	_warnErase = MovePieceDownDelay.resize(3)

	_warnErase = AndroidMovePieceDownDelay.resize(3)
	_warnErase = AndroidMovePieceDownPressed.resize(3)
	_warnErase = AndroidMovePieceLeftDelay.resize(3)
	_warnErase = AndroidMovePieceRightDelay.resize(3)

	_warnErase = PlayerInput.resize(3)

	_warnErase = MovePieceCollision.resize(3)
	for player in range(3):
		MovePieceCollision[player] = []
		_warnErase = MovePieceCollision[player].resize(35)
		for x in range(35):
			MovePieceCollision[player][x] = []
			_warnErase = MovePieceCollision[player][x].resize(26)

	_warnErase = MovePieceHeight.resize(3)
	for player in range(3):
		MovePieceHeight[player] = []
		_warnErase = MovePieceHeight[player].resize(35)
		for x in range(35):
			MovePieceHeight[player][x] = []
			_warnErase = MovePieceHeight[player][x].resize(26)

	_warnErase = MoveTrappedHoles.resize(3)
	for player in range(3):
		MoveTrappedHoles[player] = []
		MoveTrappedHoles[player].resize(35)
		for x in range(35):
			MoveTrappedHoles[player][x] = []
			MoveTrappedHoles[player][x].resize(26)

	_warnErase = MoveOneBlockCavernHoles.resize(3)
	for player in range(3):
		MoveOneBlockCavernHoles[player] = []
		MoveOneBlockCavernHoles[player].resize(35)
		for x in range(35):
			MoveOneBlockCavernHoles[player][x] = []
			MoveOneBlockCavernHoles[player][x].resize(26)

	_warnErase = MovePlayfieldBoxEdges.resize(3)
	for player in range(3):
		MovePlayfieldBoxEdges[player] = []
		_warnErase = MovePlayfieldBoxEdges[player].resize(35)
		for x in range(35):
			MovePlayfieldBoxEdges[player][x] = []
			_warnErase = MovePlayfieldBoxEdges[player][x].resize(26)

	_warnErase = MoveCompletedLines.resize(3)
	for player in range(3):
		MoveCompletedLines[player] = []
		_warnErase = MoveCompletedLines[player].resize(35)
		for x in range(35):
			MoveCompletedLines[player][x] = []
			_warnErase = MoveCompletedLines[player][x].resize(26)

	_warnErase = MoveBumpiness.resize(3)
	for player in range(3):
		MoveBumpiness[player] = []
		_warnErase = MoveBumpiness[player].resize(35)
		for x in range(35):
			MoveBumpiness[player][x] = []
			_warnErase = MoveBumpiness[player][x].resize(26)

	_warnErase = MoveTotalHeight.resize(3)
	for player in range(3):
		MoveTotalHeight[player] = []
		_warnErase = MoveTotalHeight[player].resize(35)
		for x in range(35):
			MoveTotalHeight[player][x] = []
			_warnErase = MoveTotalHeight[player][x].resize(26)

	_warnErase = BestMoveX.resize(3)
	_warnErase = BestRotation.resize(3)
	_warnErase = MovedToBestMove.resize(3)

	_warnErase = MaxRotationArray.resize(8)
	MaxRotationArray[0] = 0
	MaxRotationArray[1] = 2
	MaxRotationArray[2] = 2
	MaxRotationArray[3] = 4
	MaxRotationArray[4] = 4
	MaxRotationArray[5] = 4
	MaxRotationArray[6] = 1
	MaxRotationArray[7] = 2

	_warnErase = CPUPlayerMovementSkip.resize(3)

	_warnErase = CPUPlayerForcedDirection.resize(3)
	CPUPlayerForcedDirection[0] = CPUForcedFree
	CPUPlayerForcedDirection[1] = CPUForcedFree
	CPUPlayerForcedDirection[2] = CPUForcedFree

	_warnErase = CPUPlayerForcedMinX.resize(3)
	_warnErase = CPUPlayerForcedMaxX.resize(3)
	CPUPlayerForcedMinX[0] = 0
	CPUPlayerForcedMaxX[0] = 31
	CPUPlayerForcedMinX[1] = 0
	CPUPlayerForcedMaxX[1] = 31
	CPUPlayerForcedMinX[2] = 0
	CPUPlayerForcedMaxX[2] = 31

	_warnErase = CPUPieceTestX.resize(3)
	_warnErase = CPURotationTest.resize(3)
	_warnErase = CPUComputedBestMove.resize(3)

	_warnErase = pTXStep.resize(3)
	_warnErase = bestValue.resize(3)

	_warnErase = PlayfieldBackup.resize(35)
	for x in range(35):
		PlayfieldBackup[x] = []
		_warnErase = PlayfieldBackup[x].resize(26)
		for y in range(26):
			PlayfieldBackup[x][y] = []

	GameWon = false

	MouseTouchRotateDir = 0

	_warnErase = PieceInPlayfieldMemory.resize(3)

	_warnErase = SkipComputerPlayerMove.resize(3)

	_warnErase = PlayerHeights.resize(3)
	_warnErase = PlayerHeightsInOrder.resize(3)

	_warnErase = levelAdjust.resize(4)

	_warnErase = PlayerPlayfield.resize(3)
	_warnErase = PlayerInputDone.resize(3)

	pass

#----------------------------------------------------------------------------------------
func _process(_delta):

	pass
