import time
import os

struct Reader {
	filename string
	buf_len int
	file voidptr
	buf  charptr
	sys_buf charptr
}

fn new_reader(filename string, buf_len int, sys_buf_len int) ?&Reader {
	fp := C.fopen(charptr(filename.str), 'r')
	if fp==0 { return error('cannot open file: $filename') }
	buf := malloc(buf_len)
	mut sys_buf := 0
	if sys_buf_len > 0 {
		sys_buf = malloc(sys_buf_len)
		unsafe{ C.setvbuf(fp, sys_buf, 0, sys_buf_len) }
	}
	r := &Reader {
		filename: filename
		buf_len: buf_len
		file: fp
		buf: buf
		sys_buf: sys_buf
	}
	return r
}

fn (r Reader) read_line() ?string {
	if C.fgets(r.buf, r.buf_len, r.file) == 0 { return none }
	return tos(r.buf, vstrlen(byteptr(r.buf)))
}

fn (mut r Reader) close() {
	C.fclose(r.file)
	if r.sys_buf !=0 { free(r.sys_buf) }
	if r.buf !=0 { free(r.buf) }
} 

// ---[ EXAMPLE ]---------------------------------------------------------------

sw := time.new_stopwatch({})

//filename := "test.txt"
//filename := "C:\\repo\\orwell_new\\sample_50v2.tsv"
filename := "usunmnie.txt"

mut r := new_reader(filename, 10000, 100000*1) or { panic(err) }
defer { r.close() }
mut lines := 0
for {
	r.read_line() or { break }
	// line := r.read_line() or { break }
	// println('> $line')
	lines++
}

size := os.file_size(filename)
size_mb := f64(size)/1_000_000
elapsed := sw.elapsed().seconds()
rate_mbps := size_mb/elapsed
println('filesize [MB]: $size_mb')
println('elapsed [s]:   $elapsed')
println('rate [MB/s]:   $rate_mbps')
println('lines: $lines')
