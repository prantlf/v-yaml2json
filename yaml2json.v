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
  $ yaml2json config.yaml -o config.json -lp
  $ cat config.yaml | yaml2json > config.json')
}

struct Config {
mut:
	input      string
	output     string
	line_break bool
	pretty     bool
}

const hint = '(use -h for help)'

fn parse_args() !&Config {
	query := '^(--?)(no-)?([0-9a-zA-Z][-0-9a-zA-Z]*)(?:=(.*))?$'
	mut re := regex.regex_opt(query)!
	mut i := 1
	l := os.args.len
	mut cfg := &Config{}
	for i < l {
		arg := os.args[i]
		i++
		if arg == '--' {
			break
		}
		start, _ := re.match_string(arg)
		if start >= 0 {
			groups := re.get_group_list()
			parse_arg := fn [arg, i, l, groups, mut cfg] (opt string, flag bool) !int {
				match opt {
					'o', 'output' {
						if groups[3].start >= 0 {
							cfg.output = arg[groups[3].start..groups[3].end]
						} else {
							if i == l {
								return error('missing file name ${hint}')
							}
							cfg.output = os.args[i]
							return 1
						}
					}
					'l', 'L', 'line-break' {
						cfg.line_break = flag
					}
					'p', 'P', 'pretty' {
						cfg.pretty = flag
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
				return 0
			}
			lead := groups[0].end - groups[0].start
			opt := arg[groups[2].start..groups[2].end]
			if lead == 1 {
				for ch in opt {
					flag := ch < `A` || ch > `Z`
					i += parse_arg(rune(ch).str(), flag)!
				}
			} else {
				flag := if groups[1].start >= 0 {
					arg[groups[1].start..groups[1].end] != 'no-'
				} else {
					true
				}
				i += parse_arg(opt, flag)!
			}
			continue
		}
		cfg.input = arg
	}
	if i < l {
		cfg.input = os.args[i]
	}
	return cfg
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
