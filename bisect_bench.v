import bisect
import time

fn bench(n int) {
	mut a := []int{}
	for i in 0..n {
		a << i*2
	}
	sw := time.new_stopwatch({})
	for i in 0..n*2 {
		bisect.bisect<int>(a,i)
	}
	dt := sw.elapsed().milliseconds()
	println("elapsed: ${dt} ms  ${i64(f64(n*2)/dt*1000)} op/s")
}

fn bisect_int_between() {
	a := [2,4,6]
	assert bisect.bisect<int>(a,0) == 0
	assert bisect.bisect<int>(a,1) == 0
	assert bisect.bisect<int>(a,3) == 1
	assert bisect.bisect<int>(a,5) == 2
	assert bisect.bisect<int>(a,7) == 3
}

bench(1000000)
// bisect_int_between()
