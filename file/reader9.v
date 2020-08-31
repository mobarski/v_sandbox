import time
import os

const (
	default_buf_len = 128*1024 // large for fast reading of big(ish) files
	default_buf_max = 0        // 0 -> no limit
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
fn new_reader(file os.File, args ...int) &Reader {
	// handle buffer size args
	mut buf_len := default_buf_len
	mut buf_max := default_buf_max
	if args.len>0 { // buf_len
		buf_len = args[0]
	}
	if args.len>1 { // buf_max
		buf_max = args[1]
	}
	assert buf_len >= 2
	assert buf_len <= buf_max || buf_max==0	
	// create
	r := &Reader{
		file:      file
		buf:       []byte{len:buf_len, cap:buf_len}
		buf_max:   buf_max
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

// TODO take generic delim, not only `\n`

// read_line
[direct_array_access]
fn (mut r Reader) read_line() ? (string,bool) {
	unsafe {
		
		// read file into buffer (when necessary)
		if r.do_read {
			if r.is_end { return none } // it's faster when it's here vs before if r.do_read			
			r.n_read = r.file.read_bytes_into(r.buf[r.carry..], r.buf.len-r.carry) + r.carry // TODO rename r.n_read
			//eprintln('BUF ${r.carry} ${r.n_read} ${r.buf}')
			r.do_read = false
			if r.n_read == 0 { return none }
		}
		
		// scan buffer
		start := r.offset
		idx := r.buf[start..r.n_read].index(`\n`)
				
		// found
		if idx>=0 {
			mut len := idx
			r.offset += len+1
			if idx>0 && r.buf[start+len-1]==`\r` { len-- }
			return tos(&r.buf[start], len),false
		}
		
		mut len := r.n_read - start
		
		// not found, last line
		if r.n_read < r.buf.len {
			r.is_end = true
			r.do_read = true // required for r.is_end to be checked
			if len>1 && r.buf[start+len-1]==`\r` { len-- }
			return tos(&r.buf[start], len),false // TODO check golang 
		}
		
		// not found (and line is longer than the buffer)
		if start == 0 {
			
			// buffer size limit reached
			if r.buf_max != 0 && r.buf.len >= r.buf_max {
				r.carry = 0
				r.do_read = true
				if len>1 && r.buf[start+len-1]==`\r` { len-- }
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
			//eprintln('growing to $new_size')
			r.buf << [byte(0)].repeat(new_size-r.buf.len) // TODO better way?
		
		// not found, carry start of the line to the buffer's head
		} else {
			r.carry = r.n_read - start
			for i in 0..r.carry {
				r.buf[i] = r.buf[start+i]
			}
		}
		
		// continue scanning
		r.offset = 0
		r.do_read = true
		return r.read_line() ?
	}
}

// ---[ TEST / BENCH ]----------------------------------------------------------

{
	//filename := "test.txt"
	//filename := "C:\\repo\\orwell_new\\sample_50v2.tsv"
	filename := "usunmnie.txt"

	f := os.open(filename) ?
	mut lines := 0
	mut line := ''
	mut is_prefix := false

	mut r := new_reader(f)
	//mut fo := os.create("output.txt") ?
	sw := time.new_stopwatch({})
	for {
		line,is_prefix = r.read_line() or { break }
		//fo.writeln(line)
		lines++
		//println('$lines > "$line" $is_prefix')
	}
	elapsed := sw.elapsed().seconds()
	//fo.close()

	size := os.file_size(filename)
	size_mb := f64(size)/1_000_000
	rate_mbps := size_mb/elapsed
	println('filesize [MB]: $size_mb')
	println('elapsed [s]:   $elapsed')
	println('rate [MB/s]:   $rate_mbps')
	println('lines: $lines')
}

/*

import os
import io

//f := os.open('example.txt')?
mut r := io.new_reader(f)
for {
	line,_ := r.read_line() or { break }
	println('> $line')
}

*/

