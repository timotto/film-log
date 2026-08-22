package filmlog

import (
	"fmt"
	"strings"
	"time"
)

func (t *Time) UnmarshalJSON(b []byte) error {
	s := strings.Trim(string(b), `"`)
	s = strings.TrimSuffix(s, "Z")
	if val, err := time.Parse("2006-01-02T15:04:05.999999999", s); err != nil {
		return err
	} else {
		*t = Time(val)
		return nil
	}
}

func (f *FilmStockType) UnmarshalJSON(b []byte) error {
	s := strings.Trim(string(b), `"`)
	switch FilmStockType(s) {
	case FilmStockTypeColor:
		fallthrough
	case FilmStockTypeBWPan:
		fallthrough
	case FilmStockTypeBWOrtho:
		fallthrough
	case FilmStockTypeBWIR:
		*f = FilmStockType(s)
		return nil
	default:
		return fmt.Errorf("invalid FilmStockType: %v", s)
	}
}

func (f *FilmStockFormat) UnmarshalJSON(b []byte) error {
	s := strings.Trim(string(b), `"`)
	switch FilmStockFormat(s) {
	case FilmStockFormat120:
		fallthrough
	case FilmStockFormat127:
		fallthrough
	case FilmStockFormat135:
		fallthrough
	case FilmStockFormatOther:
		*f = FilmStockFormat(s)
		return nil
	default:
		return fmt.Errorf("invalid FilmStockFormat: %v", s)
	}
}
