extends Node
#
func magic_direction(_mdir):
	_mdir = wrapi(_mdir,0,360)
	if _mdir < 0:
		_mdir = 360 - _mdir
	if _mdir < 45:
			return "right"
	if _mdir >= 45:
		if _mdir < 135:
			return "down"
	if _mdir >= 135:
		if _mdir < 225:
			return "left"
	if _mdir >= 225:
		if _mdir < 315:
			return "up"
	if _mdir >= 315:
			return "right"

func form_swap(_form_menu):
	if _form_menu == true:
		return false
	else:
		return true
