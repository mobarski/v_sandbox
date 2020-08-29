mut a := []byte{len:1000}
a[999] = `x`

for _ in 0..1_000_000 {
	mut x := a.index(`x`)
	x++
}
