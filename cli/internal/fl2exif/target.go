package fl2exif

import (
	"fmt"
	"log/slog"
	"path"

	jis "github.com/dsoprea/go-jpeg-image-structure/v2"
	"github.com/timotto/film-log/cli/internal/filmlog"
)

type Fl2Exif struct {
	log                  *slog.Logger
	imageFilenamePattern string
	jmp                  *jis.JpegMediaParser
}

func NewFl2Exif(log *slog.Logger, imageFilenamePattern string) *Fl2Exif {
	return &Fl2Exif{
		log:                  log,
		imageFilenamePattern: imageFilenamePattern,
		jmp:                  jis.NewJpegMediaParser(),
	}
}

func (f Fl2Exif) HandleTarget(target string) error {
	filmInfo, err := filmlog.ParseFilmLogData(path.Join(target, "film.json"))
	if err != nil {
		return err
	}

	for _, photo := range filmInfo.Photos {
		imageFilename := fmt.Sprintf(f.imageFilenamePattern, photo.FrameNumber)
		if !verifyFileExists(path.Join(target, imageFilename)) {
			//log.Info("image file for camera frame does not exist", "filename", imageFilename, "frameNumber", photo.FrameNumber)
			continue
		}

		fullImagePath := path.Join(target, imageFilename)
		if err := f.applyExifTo(fullImagePath, photo, filmInfo); err != nil {
			f.log.Error("failed to apply exif info", "filename", imageFilename, "error", err)
		}
	}

	return nil
}
