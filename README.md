# yaml2json

Converts YAML input to JSON output.

Uses [json] and [yaml].

## Synopsis

Convert a file `config.yaml` to a file `config.json`, append a trailing line break to the JSON putput and make the output more readable by indentation:

    yaml2json config.yaml -o config.json -l -p

Convert files using standard input and standard ouptut, as condensed as possible, no trailing line break:

    cat config.yaml | yaml2json > config.json

## Usage

    Usage: yaml2json [options] [<yaml-file>]

    Options:
      -o|--output <file>  write the JSON output to a file
      -l|--line-break     append a line break to the JSON output
      -p|--pretty         prints the JSON output with line breaks and indented
      -V|--version        prints the version of the executable and exits
      -h|--help           prints th usage information and exits

    If no input file is specified, it will be read from standard input.

## Build

    v -prod yaml2json.v
    v fmt -w .
    v vet .

[json]: https://github.com/prantlf/v-json
[yaml]: https://github.com/prantlf/v-yaml
