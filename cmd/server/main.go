package main

import (
	"context"
	"log"
	"net"
	"net/http"

	"github.com/grpc-ecosystem/grpc-gateway/runtime"
	"github.com/seita-uc/grpc/proto/go/api"
	"github.com/seita-uc/grpc/service"
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
	api.RegisterTodoServiceServer(grpcServer, &service.Todo{})
	go grpcServer.Serve(listener)

	mux := runtime.NewServeMux()
	opts := []grpc.DialOption{grpc.WithInsecure()}

	endpoint := "localhost" + grpcPort
	api.RegisterTodoServiceHandlerFromEndpoint(ctx, mux, endpoint, opts)
	http.ListenAndServe(httpPort, mux)
}
