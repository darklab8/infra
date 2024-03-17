package scarecrow

import (
    "encoding/yaml"
	"tool/file"
	"tool/cli"
)

command: dump: {
	task: print: cli.Print & {
		text: yaml.MarshalStream(#files)
	}
}
