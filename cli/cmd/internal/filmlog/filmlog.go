package filmlog

import (
	"encoding/json"
	"os"
)

func ParseFilmLogData(filename string) (*FilmInstance, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer func() { _ = file.Close() }()

	var result FilmInstance
	if err := json.NewDecoder(file).Decode(&result); err != nil {
		return nil, err
	}

	return &result, nil
}
