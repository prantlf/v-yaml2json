import os
import regex
import prantlf.json { StringifyOpts, stringify }
import prantlf.yaml { parse_file, parse_text }

const version = '0.0.1'

fn usage() {
	println('yaml2json ${version}
  Converts YAML input to JSON output.

Usage: yaml2json [options] [<yaml-file>]

  <yaml-file>         read the YAML input from a file

Options:
  -o|--output <file>  write the JSON output to a file
  -l|--line-break     append a line break to the JSON output
  -p|--pretty         prints the JSON output with line breaks and indented
  -V|--version        prints the version of the executable and exits
  -h|--help           prints th usage information and exits

If no input file is specified, it will be read from standard input.

Examples:
  $ yaml2json config.yaml -o config.json -p
  $ cat config.yaml | yaml2json > config.json')
}

struct Config {
	input  			string
	output 			string
	line_break	bool
	pretty 			bool
}

fn parse_args() !&Config {
	hint := '(use -h for help)'
	query := '^(?:--?)(no-)?([a-zA-Z][-a-z]*)$'
	mut re := regex.regex_opt(query) or { panic(err) }
	mut input := ''
	mut output := ''
	mut line_break := false
	mut pretty := false
	mut i := 1
	l := os.args.len
	for i < l {
		arg := os.args[i]
		i++
		if arg == '--' {
			break
		}
		start, _ := re.match_string(arg)
		if start >= 0 {
			groups := re.get_group_list()
			flag := if groups[0].start >= 0 {
				arg[groups[0].start..groups[0].end] != 'no-'
			} else {
				true
			}
			opt := arg[groups[1].start..groups[1].end]
			match opt {
				'o', 'output' {
					if i == l {
						return error('missing file name ${hint}')
					}
					output = os.args[i]
					i++
				}
				'l', 'line-break' {
					line_break = flag
				}
				'p', 'pretty' {
					pretty = flag
				}
				'V', 'version' {
					println(version)
					exit(0)
				}
				'h', 'help' {
					usage()
					exit(0)
				}
				else {
					return error('unknown argument "${arg}" ${hint}')
				}
			}
			continue
		}
		input = arg
	}
	if i < l {
		input = os.args[i]
	}
	return &Config{
		input: input
		output: output
		line_break: line_break
		pretty: pretty
	}
}

fn convert() ! {
	config := parse_args()!

	src := if config.input.len > 0 {
		parse_file(config.input)!
	} else {
		input := os.get_raw_lines_joined()
		parse_text(input)!
	}

	mut dst := stringify(src, StringifyOpts{ pretty: config.pretty })
	if config.output.len > 0 {
		if config.line_break {
			dst += '\n'
		}
		os.write_file(config.output, dst)!
	} else {
		print(dst)
		if config.line_break {
			println('')
		}
	}
}

fn main() {
	convert() or {
		eprintln(err)
		exit(1)
	}
}
