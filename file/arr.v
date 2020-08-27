mut a := []int{len:1,cap:20}
println(a)
unsafe {
	mut x := &a.len
	*x = 10
}
println(a)
