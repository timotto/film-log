package main

import (
	"fmt"
	"log/slog"
	"math"
	"os"
	"path"

	exif "github.com/dsoprea/go-exif/v3"
	exifcommon "github.com/dsoprea/go-exif/v3/common"
	jis "github.com/dsoprea/go-jpeg-image-structure/v2"
	"github.com/timotto/film-log/cli/cmd/internal/filmlog"
)

var (
	targets              []string
	imageFilenamePattern = "Image_%02d.jpg"
	log                  *slog.Logger

	jmp = jis.NewJpegMediaParser()
)

func main() {
	setupLogger()
	parseArgs()
	sanitizeArgs()
	validateArgs()

	for _, t := range targets {
		if err := handleTarget(t); err != nil {
			panic(fmt.Errorf("failed to handle %s: %w", t, err))
		}
	}
}

func handleTarget(target string) error {
	filmInfo, err := filmlog.ParseFilmLogData(path.Join(target, "film.json"))
	if err != nil {
		return err
	}

	for _, photo := range filmInfo.Photos {
		imageFilename := fmt.Sprintf(imageFilenamePattern, photo.FrameNumber)
		if !verifyFileExists(path.Join(target, imageFilename)) {
			//log.Info("image file for camera frame does not exist", "filename", imageFilename, "frameNumber", photo.FrameNumber)
			continue
		}

		fullImagePath := path.Join(target, imageFilename)
		if err := applyExifTo(fullImagePath, photo, filmInfo); err != nil {
			log.Error("failed to apply exif info", "filename", imageFilename, "error", err)
		}
	}

	return nil
}

func applyExifTo(imageFilename string, photo filmlog.Photo, film *filmlog.FilmInstance) error {
	sl, ib, ifdIb, exifIb, gpsIb, err := setupExifWriter(imageFilename)
	if err != nil {
		return err
	}

	changes := 0

	if film.Camera.Manufacturer != "" {
		// Make
		if err := ifdIb.SetStandard(271, film.Camera.Manufacturer); err != nil {
			return err
		}
		changes++
	}
	if film.Camera.Product != "" {
		// Model
		if err := ifdIb.SetStandard(272, film.Camera.Product); err != nil {
			return err
		}
		changes++
	}

	if photo.Lens != nil {
		if photo.Lens.Manufacturer != "" {
			if err := exifIb.SetStandardWithName("LensMake", photo.Lens.Manufacturer); err != nil {
				return err
			}
			changes++
		}
		if photo.Lens.Product != "" {
			if err := exifIb.SetStandardWithName("LensModel", photo.Lens.Product); err != nil {
				return err
			}
			changes++
		}
	}

	if !photo.Timestamp.Value().IsZero() {
		// IFD DateTime
		if err := ifdIb.SetStandard(306, photo.
			Timestamp.
			Value().
			UTC().
			Format("2006:01:02 15:04:05")); err != nil {
			return err
		}

		// IFD/Exif DateTimeOriginal
		if err := exifIb.SetStandard(0x9003, photo.
			Timestamp.
			Value().
			UTC().
			Format("2006:01:02 15:04:05")); err != nil {
			return err
		}

		changes++
	}

	if photo.Location != nil {
		if err := gpsIb.SetStandardWithName("GPSVersionID", []byte{2, 2, 0, 0}); err != nil {
			return err
		}

		ref, rat := gpsLatLonRefValue(photo.Location.Latitude, "N", "S")
		if err := gpsIb.SetStandardWithName("GPSLatitudeRef", ref); err != nil {
			return err
		}
		if err := gpsIb.SetStandardWithName("GPSLatitude", rat.Raw()); err != nil {
			return err
		}

		ref, rat = gpsLatLonRefValue(photo.Location.Longitude, "E", "W")
		if err := gpsIb.SetStandardWithName("GPSLongitudeRef", ref); err != nil {
			return err
		}
		if err := gpsIb.SetStandardWithName("GPSLongitude", rat.Raw()); err != nil {
			return err
		}

		changes++
	}

	if expoTimeVal, ok := exposureTimeRational(photo.Shutter); ok {
		if err := exifIb.SetStandardWithName("ExposureTime", []exifcommon.Rational{expoTimeVal}); err != nil {
			return err
		}
	}

	if photo.Aperture != nil {
		//// IFD/Exif FNumber
		if err := exifIb.SetStandardWithName("FNumber", []exifcommon.Rational{{
			Numerator:   uint32(*photo.Aperture * 100),
			Denominator: 100,
		}}); err != nil {
			return err
		}

		changes++
	}

	iso := float64(0)
	if film.ActualIso != 0 {
		iso = film.ActualIso
	} else if film.FilmStock.Iso != 0 {
		iso = film.FilmStock.Iso
	}
	if iso != 0 {
		if err := exifIb.SetStandardWithName("ISOSpeed", []uint32{uint32(iso)}); err != nil {
			return err
		}
		changes++
	}

	if changes == 0 {
		return nil
	}

	log.Info("writing exif info", "item_count", changes, "filename", imageFilename)

	if err := sl.SetExif(ib); err != nil {
		return err
	}

	file, err := os.OpenFile(imageFilename, os.O_RDWR, 0644)
	if err != nil {
		return err
	}
	defer func() { _ = file.Close() }()

	if err := sl.Write(file); err != nil {
		return err
	}

	return nil
}

func gpsLatLonRefValue(value float64, refPos, refNeg string) (ref string, rational exif.GpsDegrees) {
	if value < 0 {
		ref = refNeg
		value = -value
	} else {
		ref = refPos
	}

	deg := math.Floor(value)
	m := math.Floor(60 * (value - deg))
	s := math.Floor(3600 * (value - deg - m/60))

	rational = exif.GpsDegrees{
		Degrees: deg,
		Minutes: m,
		Seconds: s,
	}

	return
}

//func setupExifReader(imageFilename string) (rootIfd, gpsIfd *exif.Ifd, err error) {
//	rawExif, err := exif.SearchFileAndExtractExif(imageFilename)
//	if err != nil {
//		return
//	}
//	im, err := exifcommon.NewIfdMappingWithStandard()
//	if err != nil {
//		return
//	}
//	ti := exif.NewTagIndex()
//	_, index, err := exif.Collect(im, ti, rawExif)
//	if err != nil {
//		return
//	}
//	rootIfd = index.RootIfd
//	gpsIfd, err = rootIfd.ChildWithIfdPath(exifcommon.IfdGpsInfoStandardIfdIdentity)
//	if err != nil {
//		return
//	}
//
//	return
//}

func setupExifWriter(imageFilename string) (sl *jis.SegmentList, ib, ifdIb, exifIb, gpsIb *exif.IfdBuilder, err error) {
	intfc, err := jmp.ParseFile(imageFilename)
	if err != nil {
		return
	}

	sl = intfc.(*jis.SegmentList)

	if ib, err = sl.ConstructExifBuilder(); err != nil {
		return
	}

	if ifdIb, err = exif.GetOrCreateIbFromRootIb(ib, "IFD"); err != nil {
		return
	}

	if exifIb, err = exif.GetOrCreateIbFromRootIb(ib, "IFD/Exif"); err != nil {
		return
	}

	if gpsIb, err = exif.GetOrCreateIbFromRootIb(ib, "IFD/GPSInfo"); err != nil {
		return
	}

	return
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

func setupLogger() {
	log = slog.New(slog.NewTextHandler(os.Stderr, &slog.HandlerOptions{Level: slog.LevelDebug}))
}
