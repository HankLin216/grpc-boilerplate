package main

import (
	"github.com/HankLin216/go-utils/config"
	"github.com/HankLin216/go-utils/config/file"
	"github.com/HankLin216/grpc-boilerplate/internal/conf"
	"go.uber.org/zap"
)

func main() {
	logger, err := zap.NewDevelopment()
	if err != nil {
		panic(err)
	}
	defer logger.Sync()

	// config
	c := config.New(
		logger,
		config.WithSource(
			file.NewSource("../../configs"),
		),
	)
	defer c.Close()

	if err := c.Load(); err != nil {
		panic(err)
	}

	var bc conf.Bootstrap
	if err := c.Scan(&bc); err != nil {
		panic(err)
	}

	// some log
	logger.Debug("this is debug message")
	logger.Info("this is info message")
	logger.Info("this is info message with fileds",
		zap.Int("age", 37),
		zap.String("agender", "man"),
	)
	logger.Warn("this is warn message")
	logger.Error("this is error message")
}
