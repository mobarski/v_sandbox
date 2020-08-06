module bisect

// first_available - find insertion point to maintain sorted order
//                   use first available position
pub fn first_available<T>(a []T, val T) int {
	if a.len==0 { return 0 }
	if val < a[0] { return 0 }
	mut i := a.len / 2
	mut delta := i
	//for iter in 0..50 {
	for {
		if delta>1 { delta >>=1 }
		//println("iter:$iter  i:$i  delta:$delta  len:$a.len")
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

// left - find insertion point to maintain sorted order
//        prefer positions to the left
pub fn left<T>(a []T, val T) int {
	if a.len==0 { return 0 }
	mut i := a.len / 2
	mut delta := i
	//for iter in 0..50 {
	for {
		if delta>1 { delta >>=1 }
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

// right - find insertion point to maintain sorted order
//         prefer positions to the right
pub fn right<T>(a []T, val T) int {
	if a.len==0 { return 0 }
	mut i := a.len / 2
	mut delta := i
	//for iter in 0..50 {
	for {
		if delta>1 { delta >>=1 }
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
