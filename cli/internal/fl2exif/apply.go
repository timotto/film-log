package fl2exif

import (
	"os"

	exifcommon "github.com/dsoprea/go-exif/v3/common"
	"github.com/timotto/film-log/cli/internal/filmlog"
)

func (f Fl2Exif) applyExifTo(imageFilename string, photo filmlog.Photo, film *filmlog.FilmInstance) error {
	sl, ib, ifdIb, exifIb, gpsIb, err := f.setupExifWriter(imageFilename)
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

	f.log.Info("writing exif info", "item_count", changes, "filename", imageFilename)

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
