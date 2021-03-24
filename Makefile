PROTOC ?= protoc
PROTO_DIR := ./proto/idl
PROTOGEN_DIR := ./proto/go

.PHONY: protogen-go
protogen-go-v1.14.6:
	for file in $(shell ls $(PROTO_DIR) | grep -v error.proto) ; do \
		$(PROTOC) \
		-I=/usr/local/include \
		-I=${PROTO_DIR} \
		-I $(GOPATH)/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
		--gogo_out=plugins=grpc:${PROTOGEN_DIR} \
		--grpc-gateway_out ${PROTOGEN_DIR} \
		--grpc-gateway_opt logtostderr=true \
		$${file}; \
	done

protogen-go-v2.3.0:
	for file in $(shell ls $(PROTO_DIR) | grep -v error.proto) ; do \
		$(PROTOC) \
		-I=/usr/local/include \
		-I=${PROTO_DIR} \
		-I $(GOPATH)/src/github.com/googleapis/googleapis \
		--go_out ${PROTOGEN_DIR} \
		--go-grpc_out ${PROTOGEN_DIR} \
		--go-grpc_opt require_unimplemented_servers=false \
		--grpc-gateway_out ${PROTOGEN_DIR} \
		--grpc-gateway_opt logtostderr=true \
		$${file}; \
	done

.PHONY: benchmark-grpc-gateway-v1.14.6
benchmark-grpc-gateway-v1.14.6:
	ghz --insecure \
		--proto ./proto/idl/todo.proto \
		-i $(GOPATH)/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
		--call api.TodoService.List \
		--rps 5 \
		--duration 10s \
		localhost:9000

.PHONY: benchmark-grpc-gateway-v2.3.0
benchmark-grpc-gateway-v2.3.0:
	ghz --insecure \
		--proto ./proto/idl/todo.proto \
		-i $(GOPATH)/src/github.com/googleapis/googleapis \
		--call api.TodoService.List \
		--rps 5 \
		--duration 10s \
		localhost:9000
