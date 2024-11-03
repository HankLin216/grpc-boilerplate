package main

import (
	"github.com/HankLin216/go-utils/config"
	"github.com/HankLin216/go-utils/config/file"
	"go.uber.org/zap"
)

func main() {

	conf := config.New(
		config.WithSource(
			file.NewSource(flagconf),
		),
	)

	logger, err := zap.NewDevelopment()
	if err != nil {
		panic(err)
	}
	logger.Debug("this is debug message")
	logger.Info("this is info message")
	logger.Info("this is info message with fileds",
		zap.Int("age", 37),
		zap.String("agender", "man"),
	)
	logger.Warn("this is warn message")
	logger.Error("this is error message")
}
