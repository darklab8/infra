package monitoring

import (
	"tool/file"
    "encoding/yaml"

)

command: build: {
	task1: mkdir: file.Create & {
		filename: "values.yaml"
		contents: yaml.Marshal(values)
	}
	task2: mkdir: file.Create & {
		filename: "Chart.yaml"
		contents: yaml.Marshal(chart)
	}
}