import hash

// number of leading zeros
fn rank<T>(x T) int {
	mut mask := T(1)
	mask <<= T(sizeof(T)*8-1)
	for rank in 0..sizeof(T)*8 {
		//println("$rank ${u64(mask)}")
		if x & mask != T(0) { return rank }
		mask >>= 1
	}
	return int(sizeof(T)*8)
}

fn test_rank() {
	assert rank<byte>(0) == 8
	assert rank<u16>(0) == 16
	assert rank<u32>(0) == 32
	assert rank<u64>(0) == 64
	
	for i in 0..8 {
		assert rank<byte>(byte(1)<<i) == 7-i
	}

	for i in 0..16 {
		assert rank<u16>(u16(1)<<i) == 15-i
	}

	for i in 0..32 {
		assert rank<u32>(u32(1)<<i) == 31-i
	}

	for i in 0..64 {
		assert rank<u64>(u64(1)<<i) == 63-i
	}
}

fn loglog_add(mut data []i8, m int, k int, item string) {
	for i in 0..k {
		val := hash.sum64_string(item, u64(i))
		rnk := i8(rank<u64>(val))
		idx := int(val % u64(m))
		idx2d := i*m + idx
		//println("$i $k $idx $idx2d")
		if rnk > data[idx2d] {
			data[idx2d] = rnk
		}
	}
}

// -----------------------------------------------------------------------------

test_rank()

mut data := []i8{len:16*3, init:-1}
loglog_add(mut data, 16, 3, "test")
println(data)
