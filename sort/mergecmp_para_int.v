import rand
import time
import sync


[inline]
fn compare(a int, b int) int {
	if a < b { return -1 }
	if a > b { return  1 }
	return 0
}


// parallel mergesort
fn mergesort2(mut tab []int, left int, right int) {
	mut wg := sync.new_waitgroup()
	wg.add(1)
	mergesort_para(mut tab, left, right, 0, 3, mut wg)
	wg.wait()
}


// parallel mergesort internal function
fn mergesort_para(mut tab []int, left int, right int, depth int, max_depth int, mut wg_parent sync.WaitGroup) {
	if left < right {
		mid := left + (right-1)>>1
		if depth < max_depth {
			mut wg := sync.new_waitgroup()
			wg.add(2)
			go mergesort_para(mut tab, left,  mid,   depth+1, max_depth, mut wg)
			go mergesort_para(mut tab, mid+1, right, depth+1, max_depth, mut wg)
			wg.wait()
		} else {
			mergesort(mut tab, left,  mid)
			mergesort(mut tab, mid+1, right)
		}
		merge(mut tab, left, mid, right)
	}
	wg_parent.done()
}


fn mergesort(mut tab []int, left int, right int) {
	if left < right {
		mid := left + (right-1)>>1
		mergesort(mut tab, left, mid)
		mergesort(mut tab, mid+1, right)
		merge(mut tab, left, mid, right)
	}
}


// merge two sorted lists stored in one array
fn merge(mut tab []int, left int, mid int, right int) {

	// handle of the simplest case
	if right-left == 1 {
		if compare(tab[left],tab[right]) > 0 { // cmp
			tab[left],tab[right] = tab[right],tab[left]
		}
		return
	}

	// clone arrays
	mut left_tab := []int{len:mid-left+1}
	mut right_tab := []int{len:right-mid}
	for i in 0..mid-left+1 {
		left_tab[i] = tab[left+i]
	}
	for i in 0..right-mid {
		right_tab[i] = tab[mid+i+1]
	}
	
	// merge
	mut i := 0
	mut j := 0
	mut k := left
	for i<left_tab.len && j<right_tab.len {
		if compare(left_tab[i],right_tab[j]) <= 0 { // cmp
			tab[k] = left_tab[i]
			i++
		} else {
			tab[k] = right_tab[j]
			j++
		}
		k++
	}
	
	// the rest of left_tab
	for i < mid - left + 1 {
		tab[k] = left_tab[i]
		i++
		k++
	}
	
	// the rest of right_tab
	for j < right - mid {
		tab[k] = right_tab[j]
		j++
		k++
	}
}

// ---[ TEST / BENCH ]---------------------------------------------------------

mut total1 := i64(0)
mut total2 := i64(0)
for _ in 0..10 {
	mut a := []int{}
	for _ in 0..1_000_000 {
		a << rand.intn(1_000_000)
	}
	mut b := a.clone()
	sw1 := time.new_stopwatch({})
	mergesort2(mut a, 0, a.len-1)
	total1 += sw1.elapsed().microseconds()
	sw2 := time.new_stopwatch({})
	b.sort()
	total2 += sw2.elapsed().microseconds()
	//println(a)
	//println(b)
	assert a==b
}
println("mergesort2: ${total1:8} µs")
println("array.sort: ${total2:8} µs")
println("mergesort2/array.sort: ${f64(total1)/f64(total2)}")
