import time
import os

const (
	// value optimized for reading big files
	default_buf_len = 128*1024
	default_buf_max = 0
)

struct Reader {
mut:
	file      os.File
	buf       []byte
	buf_max   int
	offset    int  // start of line offset
	carry     int  // number of bytes to carry between file reads
	n_read    int  // number of bytes read in the last file read op
	is_end    bool // end of file reached
	do_read   bool // file read operation should be perfomed on next call
}
// */
fn new_reader(file os.File) &Reader {
	r := &Reader{
		file:      file
		buf:       []byte{}
		buf_max:   0
		offset:    0
		carry:     0
		n_read:    0
		is_end:    false
		do_read:   true
	}
	return r
}

fn (mut r Reader) close() {
	r.file.close()
	// TODO free the buffer ?
}

// private
fn (mut r Reader) set_buffer(buf_len int, buf_max int) {
	assert buf_len >= 2
	assert buf_len >= r.buf.len
	assert buf_len <= buf_max || buf_max==0
	r.buf << [byte(0)].repeat(buf_len-r.buf.len)
	r.buf_max = buf_max
}

// TODO take generic delim, not only `\n`
// TODO \r removal

// read_line
[direct_array_access]
fn (mut r Reader) read_line() ? (string,bool) {
	unsafe {
		
		// read file into buffer (when necessary)
		if r.do_read {
			if r.is_end { return none } // it's faster when it's here vs before if r.do_read
			if r.buf.len == 0 { // doing it here allows call to .set_buffer to be optional
				r.set_buffer(default_buf_len, default_buf_max)
			} 
			r.n_read = r.file.read_bytes_into(r.buf[r.carry..], r.buf.len-r.carry) + r.carry // TODO rename r.n_read
			//eprintln('BUF ${r.carry} ${r.n_read} ${r.buf}')
			r.do_read = false
			if r.n_read == 0 { return none }
		}
		
		// scan buffer
		idx := r.buf[r.offset..r.n_read].index(`\n`)
				
		// found
		if idx>=0 {
			len := idx
			r.offset += len+1
			return tos(&r.buf[r.offset], len),false
		}
		
		len := r.n_read - r.offset
		
		// not found, last line
		if r.n_read < r.buf.len-r.carry {
			r.is_end = true
			r.do_read = true
			return tos(&r.buf[r.offset], len),false // TODO check golang 
		}
		
		// not found (and line is longer than the buffer)
		if r.offset == 0 {
			
			// buffer size limit reached
			if r.buf_max != 0 && r.buf.len >= r.buf_max {
				r.carry = 0
				r.do_read = true
				return tos(&r.buf[0], len),true
			}
			
			// grow the buffer
			r.carry = r.buf.len
			mut new_size := r.buf.len*2
			if r.buf_max != 0 {
				if new_size > r.buf_max {
					new_size = r.buf_max
				}
			} 
			eprintln('growing to $new_size')
			r.buf << [byte(0)].repeat(new_size-r.buf.len) // TODO better way?
		
		// not found, carry start of the line to the buffer's head
		} else {
			r.carry = r.n_read - r.offset
			for i in 0..r.carry {
				r.buf[i] = r.buf[r.offset+i]
			}
		}
		
		// continue scanning
		r.offset = 0
		r.do_read = true
		return r.read_line() ?
	}
}

// ---[ TEST / BENCH ]----------------------------------------------------------

sw := time.new_stopwatch({})

//filename := "test.txt"
//filename := "C:\\repo\\orwell_new\\sample_50v2.tsv"
filename := "usunmnie.txt"

f := os.open(filename) ?
mut r := new_reader(f)
//r.set_buffer(512*1024,0)
mut lines := 0
for {
	r.read_line() or { break }
	//line,_ := r.read_line() or { break } 
	//println('>>$line<<')
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

//f := os.open('example.txt')?
f := os.vfopen('example.txt','r')?
mut r := io.new_reader(f, 1000, 0)

for {
	line,_ := r.read_line() or { break }
	println('> $line')
}

*/

