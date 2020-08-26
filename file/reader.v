struct LineReader {
	filename string
	buf_len int
	file voidptr
	buf  charptr
}

fn new_linereader(filename string, buf_len int) &LineReader {
	r := &LineReader{
		filename: filename
		buf_len: buf_len
		file: C.fopen(charptr(filename.str), 'r')
		buf: charptr([]byte{cap:buf_len}.data) // is this safe?
	}
	return r
}

fn (r LineReader) readline() ?string {
	if C.fgets(r.buf, r.buf_len, r.file) == 0 { return none }
	return tos(r.buf, vstrlen(byteptr(r.buf)))
}

// ---[ EXAMPLE ]---------------------------------------------------------------

f := new_linereader("reader.v", 1000)
for {
	line := f.readline() or { break }
	print("> $line")
}
