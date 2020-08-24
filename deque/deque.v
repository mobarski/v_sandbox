/*

	Deque.data layout:
	
		0                              len-1
		|                                |
		|    data     |  empty  |  data  |
		|             |         |        |
		oooooooooooooo...........ooooooooo
		              ^         ^
		           tail         head (negative index)

*/


struct Deque {
mut:
	cap  int
	len  int
	head int
	tail int
	data []int
}

fn new_deque(cap int) Deque {
	mut d := Deque{cap:cap}
	d.data = []int{len:cap}
	d.tail = 0
	d.head = -1 // 
	d.cap  = cap
	return d
}

fn (mut d Deque) push(val int) {
	if d.len == d.cap {
		d.grow()
	}
	d.data[mod(d.tail, d.cap)] = val
	d.tail++
	d.len++
}

fn (mut d Deque) prepend(val int) {
	if d.len == d.cap {
		d.grow()
	}
	d.data[mod(d.head, d.cap)] = val
	d.head--
	d.len++
}

fn (mut d Deque) pop() int {
	if d.len <= 0 {
		panic('.pop() from an empty Deque')
	}
	d.tail--
	d.len--
	return d.data[mod(d.tail, d.cap)]
}

fn (mut d Deque) shift() int {
	if d.len <= 0 {
		panic('.shift() from an empty Deque')
	}
	d.head++
	d.len--
	return d.data[mod(d.head, d.cap)]
}

[direct_array_access]
fn (mut d Deque) grow() {
	old_cap := d.cap
	d.data << [0].repeat(d.cap) // TODO optimize
	d.cap = d.data.len
	for i in 0..d.len {
		d.tail--
		d.data[d.cap-1-i] = d.data[mod(d.tail, old_cap)]
	}
	d.tail = 0
	d.head = d.cap - d.len - 1
}

fn (mut d Deque) shrink() {
	// TODO
}

[inline]
fn mod(a int, b int) int {
	x := a % b
	if x < 0 {
		return x+b
	} else {
		return x
	}
}

// ---[ MAIN ]------------------------------------------------------------------


mut d := new_deque(6)
d.push(1)
d.push(2)
d.push(3)
d.push(4)
println(d.data)
println(d.pop())
println(d.pop())
d.push(5)
d.push(6)
println(d.data)
d.grow()
println(d.data)
d.grow()
println(d.data)
d.push(7)
d.push(8)
println(d.data)
d.prepend(-1)
d.prepend(-2)
println(d.data)
