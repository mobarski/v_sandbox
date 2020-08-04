struct Array2d {
	w int
	h int
mut:
	data [][]int
}
fn (mut a Array2d) init() {
	for _ in 0..a.w {
		a.data << []int{len:a.h}
	}
}

if false {
	mut a := Array2d{3,4}
	a.init()
	println(a)
}

// -----------------------------------------------------------------------------

if false {
	mut a := [][]int{}
	for i in 0..3 {
		a << []int{len:4}
		for j in 0..a[i].len {
			a[i][j] = i*10 + j
		}
	}
	println(a) // Output: [[0, 1, 2, 3], [10, 11, 12, 13], [20, 21, 22, 23]]
}

// -----------------------------------------------------------------------------

if false {
	mut a := [][]int{}
	for i in 0..3 {
		mut row := []int{len:4}
		for j in 0..row.len {
			row[j] = i*10 + j
		}
		a << row
	}
	println(a) // Output: [[0, 1, 2, 3], [10, 11, 12, 13], [20, 21, 22, 23]]
}

if false {
	mut a := [][]int{}
	for _ in 0..3 {
		a << []int{len:4}
	}
	println(a) // Output: [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
}

if true {
	mut a := [][]int{len:2}
	a = a.map([]int{len:3})
	a[0][1] = 2
	println(a) // Output: [[0, 2, 0], [0, 0, 0]]
}

if true {
	mut a := [][]bool{len:2}
	a = a.map([]bool{len:3, init:false})
	a[0][1] = true
	println(a) // Output: [[false, true, false], [false, false, false]]
}

if true {
	mut a := [][][]int{len:2}
	a = a.map([][]int{len:3}.map([]int{len:2}))
	a[0][1][1] = 2
	println(a) // Output: [[[0, 0], [0, 2], [0, 0]], [[0, 0], [0, 2], [0, 0]]]
	           //  ERROR:                                        ~~~ 
}


if true {
	mut a := [][][]int{len:2}
	a = a.map([][]int{len:3})
	for i in 0..a.len {
		for j in 0..a[i].len {
			a[i][j] = []int{len:2}
		}
	}
	a[0][1][1] = 2
	println(a) // Output: [[[0, 0], [0, 2], [0, 0]], [[0, 0], [0, 0], [0, 0]]]
}

if true {
	w := 2
	h := 3
	mut a := [][]int{len:w}
	a = a.map([]int{len:h})
	a[0][1] = 2
	println(a) // Output: [[0, 2, 0], [0, 0, 0]]
}

if true {
	mut a := [][]int{len:2}.map([]int{len:3})
	a[0][1] = 2
	println(a) // [[0, 2, 0], [0, 0, 0]]
}


if true {
	mut a := [][][]int{len:2}
	a = a.map([][]int{len:3}.map([]int{len:2}))
	a[0][1][1] = 2
	println(a) // Output: [[[0, 0], [0, 2], [0, 0]], [[0, 0], [0, 0], [0, 0]]]
}