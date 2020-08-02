// GENERICS doesn't work right now in tests - commenting out

/*

module bisect

// bisect

fn test_bisect_int_between() {
	a := [2,4,6]
	assert bisect<int>(a,0) == 0
	assert bisect<int>(a,1) == 0
	assert bisect<int>(a,3) == 1
	assert bisect<int>(a,5) == 2
	assert bisect<int>(a,7) == 3
}

fn test_bisect_int_same() {
	a := [1,1,1,1,1,1]
	assert bisect<int>(a,1) == 3
}

fn test_bisect_int_empty() {
	a := []int{}
	assert bisect<int>(a,0) == 0
	assert bisect<int>(a,1) == 0
	assert bisect<int>(a,2) == 0
}

// bisect_left

fn test_bisect_left_int_between() {
	a := [2,4,6]
	assert bisect_left<int>(a,0) == 0
	assert bisect_left<int>(a,1) == 0
	assert bisect_left<int>(a,2) == 0
	assert bisect_left<int>(a,3) == 1
	assert bisect_left<int>(a,4) == 1
	assert bisect_left<int>(a,5) == 2
	assert bisect_left<int>(a,6) == 2
	assert bisect_left<int>(a,7) == 3
}

fn test_bisect_left_int_same() {
	a := [1,1,1,1,1,1]
	assert bisect_left<int>(a,1) == 0
}

fn test_bisect_left_int_empty() {
	a := []int{}
	assert bisect_left<int>(a,0) == 0
	assert bisect_left<int>(a,1) == 0
	assert bisect_left<int>(a,2) == 0
}

// bisect_right

fn test_bisect_right_int_between() {
	a := [2,4,6]
	assert bisect_right<int>(a,0) == 0
	assert bisect_right<int>(a,1) == 0
	assert bisect_right<int>(a,2) == 1
	assert bisect_right<int>(a,3) == 1
	assert bisect_right<int>(a,4) == 2
	assert bisect_right<int>(a,5) == 2
	assert bisect_right<int>(a,6) == 3
	assert bisect_right<int>(a,7) == 3
}

fn test_bisect_right_int_same() {
	a := [1,1,1,1,1,1]
	assert bisect_right<int>(a,1) == 6
}

fn test_bisect_right_int_empty() {
	a := []int{}
	assert bisect_right<int>(a,0) == 0
	assert bisect_right<int>(a,1) == 0
	assert bisect_right<int>(a,2) == 0
}

*/