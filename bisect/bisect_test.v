module bisect

// bisect

fn test_bisect_between() {
	a := [2,4,6]
	assert bisect(a,0) == 0
	assert bisect(a,1) == 0
	assert bisect(a,3) == 1
	assert bisect(a,5) == 2
	assert bisect(a,7) == 3
}

fn test_bisect_same() {
	a := [1,1,1,1,1,1]
	assert bisect(a,1) == 3
}

fn test_bisect_empty() {
	a := []int{}
	assert bisect(a,0) == 0
	assert bisect(a,1) == 0
	assert bisect(a,2) == 0
}

// bisect_left

fn test_bisect_left_between() {
	a := [2,4,6]
	assert bisect_left(a,0) == 0
	assert bisect_left(a,1) == 0
	assert bisect_left(a,2) == 0
	assert bisect_left(a,3) == 1
	assert bisect_left(a,4) == 1
	assert bisect_left(a,5) == 2
	assert bisect_left(a,6) == 2
	assert bisect_left(a,7) == 3
}

fn test_bisect_left_same() {
	a := [1,1,1,1,1,1]
	assert bisect_left(a,1) == 0
}

fn test_bisect_left_empty() {
	a := []int{}
	assert bisect_left(a,0) == 0
	assert bisect_left(a,1) == 0
	assert bisect_left(a,2) == 0
}

// bisect_right

fn test_bisect_right_between() {
	a := [2,4,6]
	assert bisect_right(a,0) == 0
	assert bisect_right(a,1) == 0
	assert bisect_right(a,2) == 1
	assert bisect_right(a,3) == 1
	assert bisect_right(a,4) == 2
	assert bisect_right(a,5) == 2
	assert bisect_right(a,6) == 3
	assert bisect_right(a,7) == 3
}

fn test_bisect_right_same() {
	a := [1,1,1,1,1,1]
	assert bisect_right(a,1) == 6
}

fn test_bisect_right_empty() {
	a := []int{}
	assert bisect_right(a,0) == 0
	assert bisect_right(a,1) == 0
	assert bisect_right(a,2) == 0
}

