package apps

import (
    "encoding/yaml"
	"tool/file"
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
