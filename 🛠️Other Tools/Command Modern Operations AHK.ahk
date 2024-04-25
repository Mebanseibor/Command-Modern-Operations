space & d::	; doctrine window
	send, {ctrl down}{f9}{ctrl up}
	return

space & s::	; sensor window
	send, {f9}
	return

space & w::	;mission window
	send, {f11}
	return

space & a::	; manual attack
	send, {shift down}{f1}{shift up}
	return

space & q::	; switch sides
	send, {alt down}s{alt up}
	return

if(GetKeyState(space) == "D")
    space::space
    return