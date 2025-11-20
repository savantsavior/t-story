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
#
# ------------------------------------------------------------------------------------------------
#                              Cross-Platform / M.I.T. Open-Source
#           "Grand National GNX" v2 Godot Engine 4.5+ Stable 2D Video Game Framework
# ------------------------------------------------------------------------------------------------
#                               "Fight To Win, Win For Love!"
#  ___________                     _________ __                         ____ ___________  _   /\TM
#  \__    ___/                    /   _____//  |_  ___________ ___.__. /_   /_   \   _  \/ \ / /
#    |    |                       \_____  \\   __\/  _ \_  __ <   |  |  |   ||   /  /_\  \_// /_
#    |    |                       /        \|  | (  <_> )  | \/\___  |  |   ||   \  \_/   \/ // \
#    |____|                      /_______  /|__|  \____/|__|   / ____|  |___||___|\_____  / / \_/
#                                        \/                    \/           T U R B O   \/\/
#                                                    TM
#                                       "T-Story 110%"
#                                @>-/---------- ---------\-<@
#
#                                 Retail Triple Final Beta 1
#
#                       HTML5 Enabled Desktop/Laptop Internet Browsers
#
#                           (C)opyright 2025 - Team "BetaMax Heroes"
# ------------------------------------------------------------------------------------------------
extends Node2D

#----------------------------------------------------------------------------------------
func _ready():
	VisualsCore.SetFramesPerSecond(30)

	VisualsCore.KeepAspectRatio = 1

	if (ScreensCore.OperatingSys == ScreensCore.OSAndroid):  VisualsCore.FullScreenMode = true

	DataCore.LoadOptionsAndHighScores()

	VisualsCore.SetScreenStretchMode()

	VisualsCore.SetFullScreenMode()

	randomize()

	InputCore.HTML5input = InputCore.InputKeyboard
	
	ScreensCore.ScreenToDisplay = ScreensCore.FASScreen

	pass

#----------------------------------------------------------------------------------------
func _physics_process(_delta):

	ScreensCore.ProcessScreenToDisplay()

	pass

# A 110% By Team "BetaMax Heroes"!
