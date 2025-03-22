import os
import prantlf.cargs { Input, parse }
import prantlf.json { StringifyOpts, stringify_opt }
import prantlf.yaml { parse_file, parse_text }

const version = '0.3.3'

const usage = 'Converts YAML input to JSON/JSON5 output.

Usage: yaml2json [options] [<yaml-file>]

  <yaml-file>           read the YAML input from a file

Options:
  -o|--output <file>    write the JSON output to a file
	-t|--trailing-commas  insert trailing commas to arrays and objects
	-s|--single-quotes    format single-quoted instead of double-quoted strings
	--escape-slashes      escape slashes by by prefixing them with a backslash
	--escape-unicode      escape multibyte Unicode characters with \\u literals
  -l|--line-break       append a line break to the JSON output
  -p|--pretty           print the JSON output with line breaks and indented
  -V|--version          print the version of the executable and exit
  -h|--help             print th usage information and exit

If no input file is specified, it will be read from standard input.

Examples:
  $ yaml2json config.yaml -o config.json -lp
  $ cat config.yaml | yaml2json > config.json'

struct Opts {
mut:
	output          string
	trailing_commas bool
	single_quotes   bool
	escape_slashes  bool
	escape_unicode  bool
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

	mut dst := stringify_opt(src, &StringifyOpts{
		pretty:          opts.pretty
		trailing_commas: opts.trailing_commas
		single_quotes:   opts.single_quotes
		escape_slashes:  opts.escape_slashes
		escape_unicode:  opts.escape_unicode
	})
	if opts.line_break {
		dst += '\n'
	}
	if opts.output != '' {
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
