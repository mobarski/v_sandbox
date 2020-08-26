filename := "test1.txt"
f := C.fopen(charptr(filename.str), 'r')
buf := [1000]byte{}
for C.fgets(charptr(buf),1000,f) != 0 {
	line := tos(byteptr(buf), vstrlen(byteptr(buf)))
	print("> $line")
}
