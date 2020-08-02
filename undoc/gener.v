fn compare<T>(a, b T) int {
    if a < b {
        return -1
    }
    if a > b {
        return 1
    }
    return 0
}

println(compare<int>(1,0)) // Outputs: 1
println(compare<int>(1,1)) //          0
println(compare<int>(1,2)) //         -1

println(compare<string>('1','0')) // Outputs: 1
println(compare<string>('1','1')) //          0
println(compare<string>('1','2')) //         -1

println(compare<float>(1.1, 1.0)) // Outputs: 1 
println(compare<float>(1.1, 1.1)) //          0
println(compare<float>(1.1, 1.2)) //         -1
