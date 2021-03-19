package main

import (
	"context"
	"log"
	"net"
	"net/http"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"github.com/jottsu/grpc-gateway-sample/proto/go/api"
	"github.com/jottsu/grpc-gateway-sample/service"
	"google.golang.org/grpc"
)

var (
	grpcPort = ":9000"
	httpPort = ":8000"
)

func main() {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	listener, err := net.Listen("tcp", grpcPort)
	if err != nil {
		log.Fatal(err)
	}

	grpcServer := grpc.NewServer()
	api.RegisterAliveServiceServer(grpcServer, &service.Alive{})
	api.RegisterTodoServiceServer(grpcServer, &service.Todo{})
	go grpcServer.Serve(listener)

	mux := runtime.NewServeMux()
	opts := []grpc.DialOption{grpc.WithInsecure()}

	endpoint := "localhost" + grpcPort
	api.RegisterAliveServiceHandlerFromEndpoint(ctx, mux, endpoint, opts)
	api.RegisterTodoServiceHandlerFromEndpoint(ctx, mux, endpoint, opts)
	http.ListenAndServe(httpPort, mux)
}
