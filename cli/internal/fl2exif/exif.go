package fl2exif

import (
	"math"

	"github.com/dsoprea/go-exif/v3"
	exifcommon "github.com/dsoprea/go-exif/v3/common"
	jis "github.com/dsoprea/go-jpeg-image-structure/v2"
)

func (f Fl2Exif) setupExifWriter(imageFilename string) (sl *jis.SegmentList, ib, ifdIb, exifIb, gpsIb *exif.IfdBuilder, err error) {
	intfc, err := f.jmp.ParseFile(imageFilename)
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

func exposureTimeRational(shutter *float64) (rat exifcommon.Rational, ok bool) {
	switch {
	case shutter == nil:

	case *shutter < 0:
		rat = exifcommon.Rational{
			Numerator:   1,
			Denominator: uint32(1 / *shutter),
		}

	case *shutter > 0:
		rat = exifcommon.Rational{
			Numerator:   uint32(*shutter),
			Denominator: 1,
		}
	default:

	}

	return
}
