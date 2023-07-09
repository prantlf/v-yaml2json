# yaml2json

Converts [YAML] input to [JSON]/[JSON5] output.

Uses [prantlf.json] and [prantlf.yaml]. See also the [jsonlint] tool.

## Synopsis

Convert a file `config.yaml` to a file `config.json`, append a trailing line break to the JSON output and make the output more readable by indentation:

    yaml2json config.yaml -o config.json -lp

Convert a file using standard input and standard output, as condensed as possible, no trailing line break:

    cat config.yaml | yaml2json > config.json

## Usage

    yaml2json [options] [<yaml-file>]

    Options:
      -o|--output <file>    write the JSON output to a file
      -t|--trailing-commas  insert trailing commas to arrays and objects
      -s|--single-quotes    format single-quoted instead of double-quoted strings
      -l|--line-break       append a line break to the JSON output
      -p|--pretty           prints the JSON output with line breaks and indented
      -V|--version          prints the version of the executable and exits
      -h|--help             prints th usage information and exits

    If no input file is specified, it will be read from standard input.

## Build

    v -prod yaml2json.v
    v fmt -w .
    v vet .
    npx conventional-changelog-cli -p angular -i CHANGELOG.md -s

## TODO

This is a work in progress.

* Finish the [JSON5] support.

[prantlf.json]: https://github.com/prantlf/v-json
[prantlf.yaml]: https://github.com/prantlf/v-yaml
[jsonlint]: https://github.com/prantlf/v-jsonlint
[JSON]: https://www.json.org/
[JSON5]: https://spec.json5.org/
[YAML]: https://yaml.org/
