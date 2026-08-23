package main

import (
	"fmt"
	"log/slog"
	"os"
	"path"

	"github.com/timotto/film-log/cli/internal/fl2exif"
)

var (
	targets              []string
	imageFilenamePattern = "Image_%02d.jpg"
	log                  *slog.Logger
)

func main() {
	setupLogger()
	parseArgs()
	sanitizeArgs()
	validateArgs()

	f2e := fl2exif.NewFl2Exif(log, imageFilenamePattern)
	for _, t := range targets {
		if err := f2e.HandleTarget(t); err != nil {
			panic(fmt.Errorf("failed to handle %s: %w", t, err))
		}
	}
}

func parseArgs() {
	switch len(os.Args) {
	case 1:
		wd, err := os.Getwd()
		if err != nil {
			panic(err)
		}

		targets = []string{wd}

	default:
		targets = os.Args[1:]
	}

	return
}

func sanitizeArgs() {
	for i, val := range targets {
		dir, file := path.Split(val)
		if file == "film.json" {
			targets[i] = dir
			val = dir
		}
	}
}

func validateArgs() {
	var validateItem = func(info os.FileInfo, err error) error {
		if err != nil {
			return err
		} else if info.IsDir() {
			return fmt.Errorf("%s is a directory", info.Name())
		}
		return nil
	}

	for _, dir := range targets {
		if err := validateItem(os.Stat(path.Join(dir, "film.json"))); err != nil {
			panic(err)
		}
	}
}

func setupLogger() {
	log = slog.New(slog.NewTextHandler(os.Stderr, &slog.HandlerOptions{Level: slog.LevelDebug}))
}
