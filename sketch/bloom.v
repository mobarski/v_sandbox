import hash

// TODO struct
// TODO benchmark for other data types: u8 u 16 u32

const (
	n_bits = 64
)

fn bloom_idx_mask(b []u64, item string, salt u64) (u64,u64) {
	val := hash.sum64_string(item, salt)
	max := u64(b.len) * n_bits
	pos := val % max
	idx := pos / n_bits
	bit_pos := pos % n_bits
	mask := u64(1)<<bit_pos
	return idx, mask
}

fn bloom_add(mut b []u64, k int, item string) {
	for i in 0..k {
		idx,mask := bloom_idx_mask(b, item, u64(i))
		b[idx] |= mask
	}
}

fn bloom_has(b []u64, k int, item string) bool {
	for i in 0..k {
		idx,mask := bloom_idx_mask(b, item, u64(i))
		if b[idx] & mask == 0 { return false }
	}
	return true
}

mut bloom := []u64{len:2}

bloom_add(mut bloom, 1, "this")
bloom_add(mut bloom, 1, "is")
bloom_add(mut bloom, 1, "a")
bloom_add(mut bloom, 1, "test")

println(bloom)
println(bloom.len)

println(bloom_has(bloom, 1, "this"))
println(bloom_has(bloom, 1, "is"))
println(bloom_has(bloom, 1, "a"))
println(bloom_has(bloom, 1, "test"))
println("")
println(bloom_has(bloom, 1, "aaa"))
println(bloom_has(bloom, 1, "xyz"))
println(bloom_has(bloom, 1, "other"))
println(bloom_has(bloom, 1, "nope"))
