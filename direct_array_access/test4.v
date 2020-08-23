[direct_array_access]
fn foo() {
	unsafe {
		mut a := [11,22,33]
		mut b := &a
		a[1] = 42
		println(a[1])
		b[1] = 24
		println(b[1])
	}
}

fn bar() {
	unsafe {
		mut a := [11,22,33]
		mut b := &a
		a[1] = 42
		println(a[1])
		b[1] = 24
		println(b[1])
	}
}

foo()
bar()
