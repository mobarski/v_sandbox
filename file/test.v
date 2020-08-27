import os
import time

//filename := "test.txt"
//filename := "C:\\repo\\orwell_new\\sample_50v2.tsv"
filename := "usunmnie.txt"

mut f := os.open_file(filename,'r') or { panic(err) }
defer { f.close() }

mut lines := 0

sw := time.new_stopwatch({})
f.set_buffer(100000)
//mut r := new_reader(f)
for {
	//line := f.read_line2() or { break }
	f.read_line() or { break }
	//f.readline() or { break }
	//line,_ := r.read_line() or { break }
	//println("> $line")
	//r.read_line() or { break }
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
