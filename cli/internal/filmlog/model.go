package filmlog

import "time"

type FilmInstance struct {
	Id            string  `json:"id"`
	Name          string  `json:"name"`
	Inserted      Time    `json:"inserted"`
	ActualIso     float64 `json:"actualIso"`
	MaxPhotoCount int     `json:"maxPhotoCount"`

	FilmStock FilmStock `json:"stock"`
	Camera    Camera    `json:"camera"`
	Photos    []Photo   `json:"photos"`
}

type FilmStock struct {
	Id           string          `json:"id"`
	Manufacturer string          `json:"manufacturer"`
	Product      string          `json:"product"`
	Iso          float64         `json:"iso"`
	Type         FilmStockType   `json:"type"`
	Format       FilmStockFormat `json:"format"`
}

type Camera struct {
	Id                  string          `json:"id"`
	Name                string          `json:"name"`
	Manufacturer        string          `json:"manufacturer"`
	Product             string          `json:"product"`
	FastestShutterSpeed float64         `json:"fastestShutterSpeed"`
	SlowestShutterSpeed float64         `json:"slowestShutterSpeed"`
	FilmstockFormat     FilmStockFormat `json:"filmstockFormat"`
}

type Photo struct {
	Id          string    `json:"id"`
	Timestamp   Time      `json:"timestamp"`
	FrameNumber int       `json:"frameNumber"`
	Shutter     *float64  `json:"shutter"`
	Aperture    *float64  `json:"aperture"`
	Filters     []Filter  `json:"filters"`
	Lens        *Lens     `json:"lens"`
	Location    *Location `json:"location"`
}

type Filter struct {
	Id           string   `json:"id"`
	Name         string   `json:"name"`
	Manufacturer string   `json:"manufacturer"`
	Product      string   `json:"product"`
	LensIds      []string `json:"lenses"`
}

type Lens struct {
	Id              string   `json:"id"`
	Name            string   `json:"name"`
	Manufacturer    string   `json:"manufacturer"`
	Product         string   `json:"product"`
	CameraIds       []string `json:"cameras"`
	Type            LensType `json:"type"`
	FocalLengthMin  float64  `json:"focalLengthMin"`
	FocalLengthMax  float64  `json:"focalLengthMax"`
	FStopIncrements string   `json:"fStopIncrements"`
	ApertureMin     float64  `json:"apertureMin"`
	ApertureMax     float64  `json:"apertureMax"`
}

type Location struct {
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
}

type Time time.Time

func (t *Time) Value() time.Time {
	return time.Time(*t)
}

type FilmStockType string

const (
	FilmStockTypeColor   FilmStockType = "color"
	FilmStockTypeBWPan   FilmStockType = "blackAndWhitePanchromatic"
	FilmStockTypeBWOrtho FilmStockType = "blackAndWhiteOrthochromatic"
	FilmStockTypeBWIR    FilmStockType = "blackAndWhiteInfrared"
)

type FilmStockFormat string

const (
	FilmStockFormat120   FilmStockFormat = "type120"
	FilmStockFormat127   FilmStockFormat = "type127"
	FilmStockFormat135   FilmStockFormat = "type135"
	FilmStockFormatOther FilmStockFormat = "typeOther"
)

type LensType string

const (
	LensTypePrime LensType = "prime"
	LensTypeZoom  LensType = "zoom"
)
