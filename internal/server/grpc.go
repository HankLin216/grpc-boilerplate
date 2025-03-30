package server

import (
	v1 "github.com/HankLin216/grpc-boilerplate/api/greeter/v1"
	"github.com/HankLin216/grpc-boilerplate/internal/conf"
	"github.com/HankLin216/grpc-boilerplate/internal/service"
	"go.uber.org/zap"

	"github.com/HankLin216/grpc-boilerplate/pkg/middleware/recovery"
	"github.com/HankLin216/grpc-boilerplate/pkg/transport/grpc"
)

// NewGRPCServer new a gRPC server.
func NewGRPCServer(c *conf.Server, greeter *service.GreeterService, logger *zap.Logger) *grpc.Server {
	var opts = []grpc.ServerOption{
		grpc.Middleware(
			recovery.Recovery(),
		),
	}
	if c.Grpc.Network != "" {
		opts = append(opts, grpc.Network(c.Grpc.Network))
	}
	if c.Grpc.Addr != "" {
		opts = append(opts, grpc.Address(c.Grpc.Addr))
	}
	if c.Grpc.Timeout != nil {
		opts = append(opts, grpc.Timeout(c.Grpc.Timeout.AsDuration()))
	}
	srv := grpc.NewServer(opts...)
	v1.RegisterGreeterServer(srv, greeter)
	return srv
}
