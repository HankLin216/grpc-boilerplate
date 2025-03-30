package service

import (
	"context"

	v1 "github.com/HankLin216/grpc-boilerplate/api/greeter/v1"
	"github.com/HankLin216/grpc-boilerplate/internal/biz"
	"go.uber.org/zap"
)

// GreeterService is a greeter service.
type GreeterService struct {
	log *zap.Logger
	v1.UnimplementedGreeterServer

	uc *biz.GreeterUsecase
}

// NewGreeterService new a greeter service.
func NewGreeterService(uc *biz.GreeterUsecase, logger *zap.Logger) *GreeterService {
	return &GreeterService{log: logger, uc: uc}
}

// SayHello implements helloworld.GreeterServer.
func (s *GreeterService) SayHello(ctx context.Context, in *v1.HelloRequest) (*v1.HelloResponse, error) {
	g, err := s.uc.CreateGreeter(ctx, &biz.Greeter{Name: in.Name})
	if err != nil {
		return nil, err
	}
	return &v1.HelloResponse{Message: "Hello " + g.Name}, nil
}
