package fl2exif

import (
	"fmt"
	"os"
)

func verifyFileExists(filename string) bool {
	info, err := os.Stat(filename)
	if os.IsNotExist(err) {
		return false
	}
	if err != nil {
		panic(fmt.Errorf("failed to stat %s: %w", filename, err))
	}
	return !info.IsDir()
}
