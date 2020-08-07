import bisect
import bench

fn bench_first(runs int, size int) {
	// input data
	mut a := []int{len:size}
	for i in 0..size {
		a[i] = i*2
	}
	// benchmark
	mut b := bench.new("bisect.first_available<int> size=$size n_ops=${2*size} runs=$runs ")
	for _ in 0..runs {
		for i in 0..size*2 {
			bisect.first_available<int>(a,i)
		}
		b.step()
	}
	b.print(size*2)
}

bench_first(15,1_000_000)
bench_first(15,1_000)
