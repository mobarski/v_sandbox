import time
import rand

fn quicksort<T>(mut tab []T) {
	mut left  := 0
	mut right := 0
	mut stack1 := []int{len:1024} // TODO
	mut stack2 := []int{len:1024} // TODO
	stack1[0] = 0
	stack1[1] = tab.len-1 
	mut s1 := 2 // stack1 index
	mut s2 := 0 // stack2 index
	
	for {

		if s1==0 {
			if s2==0 { return }
			left,right = stack2[s2-2],stack2[s2-1]
			s2 -= 2
		} else {
			left,right = stack1[s1-2],stack1[s1-1]
			s1 -= 2
		}
		mut i := left
		mut j := right
		mut pivot := tab[(left+right)>>1] // fixed pivot
		//mut pivot := tab[left+rand.intn(right-left)] // random pivot

		for {
			for tab[i] < pivot { i++ } // cmp
			for tab[j] > pivot { j-- } // cmp
			if i<=j {
				tab[i],tab[j] = tab[j],tab[i]
				i++
				j--
			}
			if i>j { break }
		}

		if left<j  {
			stack1[s1] = left
			stack1[s1+1] = j
			s1 += 2
		}
		if right>i {
			stack2[s2] = i
			stack2[s2+1] = right
			s2 += 2
		}
	}
}

mut total1 := i64(0)
mut total2 := i64(0)
for _ in 0..100 {
	mut a := []int{}
	for _ in 0..100000 {
		a << rand.intn(10000)
	}
	mut b := a.clone()
	sw1 := time.new_stopwatch({})
	quicksort<int>(mut a)
	total1 += sw1.elapsed().microseconds()
	sw2 := time.new_stopwatch({})
	b.sort()
	total2 += sw2.elapsed().microseconds()
	//println(a)
	//println(b)
	assert a==b
}
println("quicksort<T>: $total1")
println("array.sort:   $total2")
