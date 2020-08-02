struct XX {
	y int
}

fn foo(x XX) {
	lock x {
		x.y++
	}
}
