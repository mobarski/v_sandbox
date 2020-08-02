type String = string

fn (s String) str() string { return s }
fn (s String) foo() String { return String("foo $s") }

println(String("FOO").to_lower())
