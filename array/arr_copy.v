fn test1<T>(mut a []T) {
	mut b := a[1..3].clone()
	println(b[0]<b[1])
}

fn test2<T>(mut a []T) {
	mut b := a[1..3].map(it)
	println(b[0]<b[1])
}

fn test3<T>(mut a []T) {
	mut b := []T{}
	b << a[1..3]
	println(b[0]<b[1])
}

mut a := [1,3,5,7,9]
test2<int>(mut a)
