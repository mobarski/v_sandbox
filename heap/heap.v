// https://www.geeksforgeeks.org/building-heap-from-array/

// max heap

fn heapify(mut arr []int, i int) {
	mut largest := i
	l := 2*i + 1
	r := 2*i + 2
	if l<arr.len && arr[l] > arr[largest] {
		largest = l
	}
	
	if r<arr.len && arr[r] > arr[largest] {
		largest = r
	}
	
	if largest != i {
		arr_i := arr[i]
		arr[i] = arr[largest]
		arr[largest] = arr_i
		heapify(mut arr, largest)
	}
}

fn make_heap(mut arr []int) {
	start := arr.len/2 - 1
	for i := start; i >= 0; i-- {
		heapify(mut arr, i)
	}
}

mut a := [1, 3, 5, 4, 6, 13, 10, 9, 8, 15, 17]
//heapify(mut a,0)
make_heap(mut a)
println(a)
