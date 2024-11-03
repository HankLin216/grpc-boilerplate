package main

import (
	"flag"
	"time"

	"github.com/HankLin216/go-utils/config"
	"github.com/HankLin216/go-utils/config/file"
	"github.com/HankLin216/grpc-boilerplate/internal/conf"
	"go.uber.org/zap"
)

var (
	Name           = "grpc-boilerplate"
	Version        = "v1.0.0"
	Env            = "Development"
	ConfFolderPath = "../../configs"
	BuildTime      = time.Now().Format(time.RFC3339)
)

func init() {
	flag.StringVar(&Version, "version", Version, "input the service version")
	flag.StringVar(&Env, "env", Env, "input the environment")
	flag.StringVar(&ConfFolderPath, "ConfFolderPath", ConfFolderPath, "input the config path")
}

func main() {
	// flag
	flag.Parse()

	// logger
	var logger *zap.Logger
	var err error
	if Env == "Production" {
		logger, err = zap.NewProduction()
	} else {
		logger, err = zap.NewDevelopment()
	}
	if err != nil {
		panic(err)
	}
	defer logger.Sync()
	logger.Info("Server infos",
		zap.String("Name", Name),
		zap.String("Version", Version),
		zap.String("Env", Env),
		zap.String("ConfigFolderPath", ConfFolderPath),
		zap.String("BuildTime", BuildTime),
	)

	// config
	c := config.New(
		logger,
		config.WithSource(
			file.NewSource(ConfFolderPath),
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
}
