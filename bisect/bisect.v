//module bisect
import time

// TODO float version
// TODO string version

// bisect - find insertion point to maintain sorted order
fn bisect(a []int, val int) int {
	mut i := a.len / 2
	mut delta := i
	if a.len==0 { return 0 }
	// for iter in 0..50 {
	for {
		delta >>= 1
		if delta==0 { delta=1 }
		//println("val:$val  iter:$iter  i:$i  delta:$delta  len:$a.len")
		if i+1 >= a.len { return a.len }
		if val == a[i] { return i }
		if val < a[i] {
			if i==0 { return i }
			i -= delta
			continue
		}
		if val > a[i] {
			if val < a[i+1] { return i+1 }
			i += delta
			continue
		}
	}
}

// bisect - find insertion point to maintain sorted order
fn bisect_f64(a []f64, val f64) int {
	mut i := a.len / 2
	mut delta := i
	if a.len==0 { return 0 }
	// for iter in 0..50 {
	for {
		delta >>= 1
		if delta==0 { delta=1 }
		//println("val:$val  iter:$iter  i:$i  delta:$delta  len:$a.len")
		if i+1 >= a.len { return a.len }
		if val == a[i] { return i }
		if val < a[i] {
			if i==0 { return i }
			i -= delta
			continue
		}
		if val > a[i] {
			if val < a[i+1] { return i+1 }
			i += delta
			continue
		}
	}
}

// bisect - find insertion point to maintain sorted order
//          prefer positions to the left
fn bisect_left(a []int, val int) int {
	mut i := a.len / 2
	mut delta := i
	if a.len==0 { return 0 }
	//for iter in 0..50 {
	for {
		delta >>= 1
		if delta==0 { delta=1 }
		//println("val:$val  iter:$iter  i:$i  delta:$delta  len:$a.len")
		if val == a[i] {
			if i==0 { return 0 }
			if val > a[i-1] { return i }
			i -= delta
			continue
		}
		if val < a[i] {
			if i==0 { return i }
			i -= delta
			continue
		}
		if val > a[i] {
			if i+1 >= a.len { return a.len } // ???
			if val < a[i+1] { return i+1 }
			i += delta
			continue
		}
	}
}

// bisect - find insertion point to maintain sorted order
//          prefer positions to the right
fn bisect_right(a []int, val int) int {
	mut i := a.len / 2
	mut delta := i
	if a.len==0 { return 0 }
	//for iter in 0..50 {
	for {
		delta >>= 1
		if delta==0 { delta=1 }
		//println("val:$val  iter:$iter  i:$i  delta:$delta  len:$a.len")
		if i+1 >= a.len { return a.len }
		if val == a[i] {
			if val < a[i+1] { return i+1 }
			i += delta
			continue
		}
		if val < a[i] {
			if i==0 { return i }
			i -= delta
			continue
		}
		if val > a[i] {
			if val < a[i+1] { return i+1 }
			i += delta
			continue
		}
	}
}

fn bench(n int) {
	mut a := []int{}
	for i in 0..n {
		a << i*2
	}
	sw := time.new_stopwatch({})
	for i in 0..n*2 {
		bisect(a,i)
	}
	dt := sw.elapsed().milliseconds()
	println("elapsed: ${dt} ms  ${i64(f64(n*2)/dt*1000)} ops")
}

bench(1000000)

// a := [2,4,6,8]
// println(bisect_left(a,0))
// println(bisect_left(a,1))
// println(bisect_left(a,2))
// println(bisect_left(a,3))
// println(bisect_left(a,4))
// println(bisect_left(a,5))
// println(bisect_left(a,6))
// println(bisect_left(a,7))
// println(bisect_left(a,8))
// println(bisect_left(a,9))
