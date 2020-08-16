import rand

fn insertsort<T>(mut tab []T, left u64, right u64) {	
	for i in left+1..right+1 {
		x := tab[i]
		for j in left..i {
			if tab[j] > x {
				for k:=i; k>j; k-- {
					tab[k] = tab[k-1]
				}
				tab[j] = x
				break
			}
		}
	}
}

mut a := []int{}
for _ in 0..10 {
	a << rand.intn(10000)
}
insertsort<int>(mut a, 0, a.len-1)
println(a)
