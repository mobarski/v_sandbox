[direct_array_access]
fn foo() {
	mut a := [11,22,33,44]
	x := a[0]
	a[0] = 21
	a[1] += 2
	a[2] = x + 3
	a[3] -= a[1]
	println(a)
}

fn bar() {
	mut a := [11,22,33,44]
	x := a[0]
	a[0] = 21
	a[1] += 2
	a[2] = x + 3
	a[3] -= a[1] 
	println(a)	
}

foo()
bar()
