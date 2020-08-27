import time
import os

struct Reader {
mut:
	cfile    voidptr
	buf      byteptr
	buf_len  int
	offset   int
	carry    int
	n_read   int
	is_end   bool
	do_read  bool
	cnt      [3]int
}

fn new_reader(filename string, buf_len int) &Reader {
	r := &Reader{
		cfile:C.fopen(charptr(filename.str), 'r')
		buf:malloc(buf_len)
		buf_len:buf_len
		offset:0
		carry:0
		n_read:0
		is_end:false
		do_read:true
	}
	buf2_len := 1000000
	buf2 := malloc(buf2_len)
	unsafe{ C.setvbuf(r.cfile, buf2, 0, buf2_len) }
	return r
}

[direct_array_access]
fn (mut r Reader) read_line() ?string {
	if r.is_end { return none }
	unsafe {
		if r.do_read {
			r.n_read = C.fread(r.buf+r.carry, 1, r.buf_len-r.carry, r.cfile)
			r.do_read = false
			if r.n_read == 0 { return none }
		}
		
		// */
		// TODO inline (no change) or dont use 
		// TODO dont return option
		
		end := r.buf + r.n_read // move to struct
		start := r.buf + r.offset // move to struct
		mut p := start
		for p < end {
			if *p == `\n` {
				len := int(u64(p) - u64(start))
				r.offset += len+1
				r.cnt[0]++
				return tos(start, len)
			}
			p = byteptr(u64(p)+1)
		}
		len := int(u64(p) - u64(start))
		if r.n_read < r.buf_len-r.carry {
			r.is_end = true
			return tos(start, len)
		}
		// rewrite
		for i in 0..len {
			r.buf[i] = r.buf[r.offset+i]
		}
		r.carry = len
		r.offset = 0
		r.do_read = true
		//println('carry:${r.carry} ${tos(r.buf,r.carry)}')
		//return none
		r.cnt[1]++
		line := r.read_line() or { return none }
		return line
	}
}

// -------------

sw := time.new_stopwatch({})

//filename := "test.txt"
//filename := "C:\\repo\\orwell_new\\sample_50v2.tsv"
filename := "usunmnie.txt"

mut r := new_reader(filename, 100000)
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
println(r.cnt)
