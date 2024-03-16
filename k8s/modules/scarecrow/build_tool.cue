package scarecrow

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
		contents: yaml.MarshalStream(#files)
	}
}

command: dump: {
	task: print: cli.Print & {
		text: yaml.MarshalStream(#files)
	}
}
