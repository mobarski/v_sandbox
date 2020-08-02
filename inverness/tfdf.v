import time
import regex
import os

fn calc_freq(lines []string) {
  sw := time.new_stopwatch({})
  mut tf := map[string]int
  mut df := map[string]int
  mut tf_sum := 0
  mut df_sum := 0
  mut re,_,_ := regex.regex(r"\s+")

  for line in lines {
    mut line_tf := map[string]int
    for t in re.replace(line,' ').to_lower().split(' ') {
      tf[t]++
      tf_sum++
      line_tf[t]++
    }
    for t,_ in line_tf {
      df[t]++
      df_sum++
    }
  }
  
  calc_tok2i(df) // XXX
  
  dt_us := sw.elapsed().microseconds()
  println("$tf_sum words done in ${dt_us} µs -> ${f64(df_sum)/f64(dt_us)*1_000_000} words/s  ${df.len} unique words\n")
  if false {
	  for k,v in tf {
		println("$k -> $v ${f32(v)/tf_sum}")
	  }
  }
}

fn calc_tok2i(df map[string]int) {
	mut tok2i := map[string]int
	for i,tok in df.keys() {
		tok2i[tok] = i
	}
}


path := "input.txt"
lines := os.read_lines(path) or { panic("cannot open file: $path") }
calc_freq(lines)
