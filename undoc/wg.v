import sync
import time

fn task(id, duration int, mut wg sync.WaitGroup) {
    println("task ${id} begin")
    time.sleep_ms(duration)
    println("task ${id} end")
    wg.done()
}

fn main() {
    mut wg := sync.new_waitgroup()
    wg.add(3)
    go task(1, 500, mut wg)
    go task(2, 900, mut wg)
    go task(3, 100, mut wg)
    wg.wait()
    println('done')
}

// Output: task 1 begin
//         task 2 begin
//         task 3 begin
//         task 3 end
//         task 1 end
//         task 2 end
//         done
