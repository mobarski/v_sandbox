[direct_array_access]
fn foo() {
	unsafe {
		a := [11,22,33]
		mut b := 42
		mut c := &b
		mut d := &b
		c = &a[0]
		*d = a[0]
		println(*c)
		println(*d)
	}
}

fn bar() {
	unsafe {
		a := [11,22,33]
		mut b := 42
		mut c := &b
		mut d := &b
		c = &a[0]
		*d = a[0]
		println(*c)
		println(*d)
	}
}

foo()
bar()
