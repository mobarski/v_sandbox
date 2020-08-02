fn new_counter() fn() {
	mut n := 0
	counter := fn() {
		n++
		println(n)
	}
	return counter
}

c1 := new_counter()
c2 := new_counter()

c1()
c1()
c2()
c1()
c2()
c2()
