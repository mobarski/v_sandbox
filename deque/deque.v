/*

	Deque (double-ended queue) implemented as a circular buffer

	Deque.data layout:
	
		0                            data.len-1
		|                                |
		|    data     |  empty  |  data  |
		|             |         |        |
		oooooooooooooo...........ooooooooo
		              ^         ^
		           tail         head (negative index)
		
	negative head/tail index -> counting from the end to the left
		
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
	d.head = -1
	d.tail = 0
	d.len  = 0
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


[direct_array_access]
fn (mut d Deque) push_many(vals []int) {
	if d.len + vals.len >= d.cap {
		d.grow()
	}
	panic('TODO: ${@STRUCT}.${@FN}') // TODO
}


[direct_array_access]
fn (mut d Deque) prepend_many(vals []int) {
	if d.len + vals.len >= d.cap {
		d.grow()
	}
	panic('TODO: ${@STRUCT}.${@FN}') // TODO
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


fn (d Deque) peek(pos int) int {
	if pos >= d.len || pos < -d.len {
		panic('.peek() out of bounds')
		
	}
	if pos >= 0 {
		return d.data[mod(d.head+1+pos, d.cap)]
	} else {
		return d.data[mod(d.tail+pos, d.cap)]
		//                      ^ pos is negative so -(-pos) -> +pos
	}
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
	panic('TODO: ${@STRUCT}.${@FN}') // TODO
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


// ---[ TEST ]------------------------------------------------------------------


mut d := new_deque(3)

// test_push_and_grow
d.push(1)
d.push(2)
d.push(3)
d.push(4) // this will make the Deque grow
println(d.data)
assert d.len == 4
assert d.peek(0) == 1
assert d.peek(1) == 2
assert d.peek(2) == 3
assert d.peek(3) == 4
assert d.peek(-1) == 4
assert d.peek(-2) == 3
assert d.peek(-3) == 2
assert d.peek(-4) == 1

// test_pop
println(d.pop())
println(d.pop())
assert d.len == 2
assert d.peek(0) == 1
assert d.peek(1) == 2
assert d.peek(-1) == 2
assert d.peek(-2) == 1

// test_push_after_pop
d.push(5)
d.push(6)
println(d.data)
assert d.len == 4
assert d.peek(0) == 1
assert d.peek(1) == 2
assert d.peek(2) == 5
assert d.peek(3) == 6
assert d.peek(-1) == 6
assert d.peek(-2) == 5
assert d.peek(-3) == 2
assert d.peek(-4) == 1

// test_grow
d.grow()
println(d.data)
d.grow()
println(d.data)
assert d.len == 4
assert d.cap == 24
assert d.peek(0) == 1
assert d.peek(1) == 2
assert d.peek(2) == 5
assert d.peek(3) == 6
assert d.peek(-1) == 6
assert d.peek(-2) == 5
assert d.peek(-3) == 2
assert d.peek(-4) == 1

// test_push_after_grow
d.push(7)
d.push(8)
println(d.data)
assert d.len == 6
assert d.peek(0) == 1
assert d.peek(1) == 2
assert d.peek(2) == 5
assert d.peek(3) == 6
assert d.peek(4) == 7
assert d.peek(5) == 8
assert d.peek(-1) == 8
assert d.peek(-2) == 7
assert d.peek(-3) == 6
assert d.peek(-4) == 5
assert d.peek(-5) == 2
assert d.peek(-6) == 1

// test_preppend
d.prepend(-1)
d.prepend(-2)
println(d.data)
assert d.len == 8
assert d.peek(0) == -2
assert d.peek(1) == -1
assert d.peek(2) == 1
assert d.peek(3) == 2
assert d.peek(-1) == 8 
assert d.peek(-2) == 7
assert d.peek(-3) == 6
assert d.peek(-4) == 5
