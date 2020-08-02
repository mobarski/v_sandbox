import bisect
import hash

struct MinHash {
	cap int = 4
mut:
	data []u64
}

fn (mut h MinHash) add(item string) {
	val := hash.sum64_string(item, 0)
	if h.data.len>=h.cap && val >= h.data[h.data.len-1] { return }
	i := bisect.bisect<u64>(h.data, val)
	if i<h.data.len && h.data[i]==val { return }
	h.data.insert(i, val)
	if h.data.len>h.cap { h.data.trim(h.cap) }
}

fn (h MinHash) estimate() int {
	if h.data.len < h.cap { return h.data.len }
	val := f64(0xffffffffffffffff) / h.data[h.data.len-1] * h.cap
	return int(val)
}

mut h := MinHash{100}
for i in 0..20000 {
	h.add(i.str())
	h.add(i.str())
	h.add(i.str())
}
println(h)
println(h.estimate())
