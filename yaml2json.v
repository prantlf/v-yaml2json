import os
import prantlf.cargs { Input, parse }
import prantlf.json { StringifyOpts, stringify }
import prantlf.yaml { parse_file, parse_text }

const version = '0.0.3'

const usage = 'Converts YAML input to JSON output.

Usage: yaml2json [options] [<yaml-file>]

  <yaml-file>         read the YAML input from a file

Options:
  -o|--output <file>    write the JSON output to a file
	-t|--trailing-commas  insert trailing commas to arrays and objects
  -l|--line-break       append a line break to the JSON output
  -p|--pretty           prints the JSON output with line breaks and indented
  -V|--version          prints the version of the executable and exits
  -h|--help             prints th usage information and exits

If no input file is specified, it will be read from standard input.

Examples:
  $ yaml2json config.yaml -o config.json -lp
  $ cat config.yaml | yaml2json > config.json'

struct Opts {
mut:
	output          string
	trailing_commas bool
	line_break      bool
	pretty          bool
}

fn convert() ! {
	opts, args := parse[Opts](usage, Input{ version: version })!

	src := if args.len > 0 {
		if args.len > 1 {
			return error('too many input files')
		}
		parse_file(args[0])!
	} else {
		input := os.get_raw_lines_joined()
		parse_text(input)!
	}

	mut dst := stringify(src, StringifyOpts{
		pretty: opts.pretty
		trailing_commas: opts.trailing_commas
	})
	if opts.line_break {
		dst += '\n'
	}
	if opts.output.len > 0 {
		os.write_file(opts.output, dst)!
	} else {
		print(dst)
	}
}

fn main() {
	convert() or {
		eprintln(err)
		exit(1)
	}
}
