package apps

import (
    "encoding/yaml"
	"tool/cli"
)

command: dump: {
	task: print: cli.Print & {
		text: yaml.MarshalStream(build_file)
	}
}
