import os

fn C.fgetc(voidptr) i8

f := os.open('test.txt')?
cfile := unsafe{*(voidptr(f))}
for _ in 0..10 {
	print(C.fgetc(cfile))
}

