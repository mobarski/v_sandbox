type String = string

fn (s String) str() string { return s }
fn (s String) foo() String { return "FOO $s" }
fn (s String) lower() String { return s.to_lower() }
x := String("BAR")
y := x.foo().lower().foo()
println(y)

