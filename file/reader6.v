import time
import os

fn C.memchr(charptr, int, size_t) charptr

struct Reader {
mut:
	cfile     voidptr
	buf       byteptr
	buf_len   int
	buf_max   int
	offset    int
	carry     int
	n_read    int
	is_end    bool
	do_read   bool
	is_prefix bool
}

// TODO filename -> file   cfile -> file
fn new_reader(filename string, buf_len int, buf_max int) &Reader {
	r := &Reader{
		cfile:     C.fopen(charptr(filename.str), 'r')
		buf:       malloc(buf_len)
		buf_len:   buf_len
		buf_max:   buf_max
		offset:    0
		carry:     0
		n_read:    0
		is_end:    false
		do_read:   true
		is_prefix: false
	}
	return r
}

fn (mut r Reader) close() {
	C.fclose(r.cfile)
}


//[direct_array_access]
fn (mut r Reader) read_line() ?string {
	unsafe {
		if r.do_read {
			if r.is_end { return none }
			r.n_read = C.fread(r.buf+r.carry, 1, r.buf_len-r.carry, r.cfile) + r.carry
			r.do_read = false
			r.is_prefix = false
			if r.n_read == 0 { return none }
		}
		
		// */
		// TODO inline (no change) or dont use 
		// TODO dont return option
		
		start := r.buf + r.offset
		loc := C.memchr(start,`\n`,r.n_read-r.offset)
		if loc!=0 {
			len := int(u64(loc) - u64(start))
			r.offset += len+1
			return tos(start, len)
		}
		len := r.n_read - r.offset
		if r.n_read < r.buf_len-r.carry {
			// last line
			r.is_end = true
			r.do_read = true
			return tos(start, len)
		}
		if r.offset == 0 {
			// grow limit reached -> is_prefix
			if r.buf_max != 0 && r.buf_len >= r.buf_max {
				r.is_prefix = true
				r.carry = 0
				r.do_read = true
				return tos(r.buf, len)
			}
			// grow
			r.carry = r.buf_len
			mut new_size := r.buf_len*2
			if r.buf_max != 0 {
				if new_size > r.buf_max {
					new_size = r.buf_max
				}
			}
			// reallocate 
			println('growing $new_size')
			r.buf_len = new_size
			r.buf = C.realloc(r.buf, r.buf_len)
		} else {
			// carry
			C.memcpy(r.buf, r.buf+r.offset, r.n_read-r.offset)
			r.carry = r.n_read - r.offset
		}
		r.offset = 0
		r.do_read = true
		line := r.read_line() or { return none }
		return line
	}
}

// -------------

sw := time.new_stopwatch({})

// filename := "test.txt"
//filename := "C:\\repo\\orwell_new\\sample_50v2.tsv"
filename := "usunmnie.txt"

mut r := new_reader(filename, 100_000, 0)
mut lines := 0
for {
	r.read_line() or { break }
	// line := r.read_line() or { err=='' } 
	// println('>>$line<<')
	lines++
	//println(lines)
}

size := os.file_size(filename)
size_mb := f64(size)/1_000_000
elapsed := sw.elapsed().seconds()
rate_mbps := size_mb/elapsed
println('filesize [MB]: $size_mb')
println('elapsed [s]:   $elapsed')
println('rate [MB/s]:   $rate_mbps')
println('lines: $lines')


/*
import os
import io

f := os.open_file('example.txt','r')
mut r := io.new_reader(f, 1000, 0)

for {
	line,_ := r.read_line() or { break }
	println('> $line')
}

*/