struct SparseBitmap {
	per_part int = 128
	parts map[string]Part
}

struct Part {
	typ int
	data []int
}

fn (b SparseBitmap) add(i int) {
	part_i = i / b.per_part
}
