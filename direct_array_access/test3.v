[direct_array_access]
fn foo() {
	unsafe {
		a := [11,22,33]
		b := &a
		println(a[1])
		println(b[1])
	}
}

fn bar() {
	unsafe {
		a := [11,22,33]
		b := &a
		println(a[1])
		println(b[1])
	}
}

foo()
bar()
