package main

import exifcommon "github.com/dsoprea/go-exif/v3/common"

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
