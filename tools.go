//go:build tools
// +build tools

// This file serves as a placeholder to ensure 'frkr-common' corresponds to a real dependency
// in go.mod. This is required because we use 'go list -m -f {{.Dir}} ...' to locate
// migration files from frkr-common to sync them into this helm chart.
package tools

import (
	_ "github.com/frkr-io/frkr-common/db"
)
