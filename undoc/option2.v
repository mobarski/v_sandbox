fn test() ?(int,int) {
	return 1,2
}

x,y := test() or { int(-1),int(-2) }
println("$x $y")
