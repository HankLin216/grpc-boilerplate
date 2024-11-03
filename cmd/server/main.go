package main

import (
	"github.com/HankLin216/go-utils/config"
	"github.com/HankLin216/go-utils/config/file"
	"github.com/HankLin216/grpc-boilerplate/internal/conf"
)

func main() {
	c := config.New(
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
}
