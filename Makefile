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

.PHONY: benchmark-grpc-gateway-v1.14.6
benchmark-grpc-gateway-v1.14.6:
	ghz --insecure \
		--proto ./proto/idl/todo.proto \
		-i $(GOPATH)/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
		--call api.TodoService.Get \
		-d '{"id":"test"}' \
		localhost:9000

.PHONY: benchmark-grpc-gateway-v2.3.0
benchmark-grpc-gateway-v2.3.0:
	ghz --insecure \
		--proto ./proto/idl/todo.proto \
		-i $(GOPATH)/src/github.com/googleapis/googleapis \
		--call api.TodoService.Get \
		-d '{"id":"test"}' \
		localhost:9000
