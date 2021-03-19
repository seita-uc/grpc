PROTOC ?= protoc
PROTO_DIR := ./proto/idl
PROTOGEN_DIR := ./proto/go

.PHONY: protogen-go
protogen-go:
	protoc -I $(PROTO_DIR) \
	-I $(GOPATH)/src/github.com/grpc-ecosystem/grpc-gateway/ \
	-I $(GOPATH)/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
	--go_out ${PROTOGEN_DIR} \
	--go-grpc_out ${PROTOGEN_DIR} \
	--go-grpc_opt require_unimplemented_servers=false \
	--grpc-gateway_out ${PROTOGEN_DIR} \
	--grpc-gateway_opt logtostderr=true \
	`find $(PROTO_DIR)/ -type f -maxdepth 1 -name "*.proto" -not -name "_index.proto"`
