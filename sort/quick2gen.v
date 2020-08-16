import time
import rand

fn quicksort<T>(mut tab []T, left u64, right u64) {
	mut i := left
	mut j := right
	mut pivot := tab[(left+right)>>1] // fixed pivot
	//mut pivot := tab[left+rand.intn(right-left)] // random pivot

	for {
		for tab[i] < pivot { i++ }
		for tab[j] > pivot { j-- }
		if i<=j {
			tab[i],tab[j] = tab[j],tab[i]
			i++
			j--
		}
		if i>j { break }
	}

	if left<j  { quicksort<T>(mut tab, left, j)  }
	if right>i { quicksort<T>(mut tab, i, right) }
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
	quicksort<int>(mut a, 0, a.len-1)
	total1 += sw1.elapsed().microseconds()
	sw2 := time.new_stopwatch({})
	b.sort()
	total2 += sw2.elapsed().microseconds()
	assert a==b
}
println("quicksort<T>: ${total1:8} µs")
println("array.sort:   ${total2:8} µs")
println("quicksort<T>/array.sort: ${f64(total1)/f64(total2)}")

