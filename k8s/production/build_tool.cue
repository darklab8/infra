package apps

import (
    "encoding/yaml"
	"tool/file"
	"tool/cli"
)

command: build: {
	task: mkdir: file.Mkdir & {
		path: "build"
	}
	task2: mkdir: file.Create & {
		filename: "build/build.yaml"
		contents: yaml.MarshalStream(#build_file)
	}
}

command: dump: {
	task: print: cli.Print & {
		text: yaml.MarshalStream(#build_file)
	}
}


