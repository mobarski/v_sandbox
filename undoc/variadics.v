fn foo(a int, b ...int) {
	println("a -> $a")
	for x in b {
		println("b -> $x")
	}
}

fn test_foo() {
	//foo(1)
	//foo(1,2)
	foo(1,2,3)
}

//foo(1,2,3)

test_foo()
