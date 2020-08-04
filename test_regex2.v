import regex
import regex2

if true {
	mut re,_,_ := regex.regex("a")
	println(re.find("xx aaa xx"))
}

if true {
	mut re := regex2.regex("a") or { panic(err) }
	println(re.find("xx aaa xx"))
}

if true {
	mut re := regex2.new_regex()
	re.compile("a") or { panic(err) }
	println(re.find("xx aaa xx"))
}
