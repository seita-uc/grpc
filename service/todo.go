package service

import (
	"context"

	"github.com/seita-uc/grpc/proto/go/api"
)

// Todo ...
type Todo struct{}

// Get ...
func (u *Todo) Get(ctx context.Context, req *api.GetTodoRequest) (*api.GetTodoResponse, error) {
	return &api.GetTodoResponse{
		Todo: &api.Todo{
			Id:      req.Id,
			Content: "todo_" + req.Id,
			Status:  api.TodoStatus_TODO_STATUS_DOING,
		},
	}, nil
}

// List ...
func (u *Todo) List(ctx context.Context, req *api.ListTodosRequest) (*api.ListTodosResponse, error) {
	return &api.ListTodosResponse{
		Todos: []*api.Todo{
			{
				Id:      "1",
				Content: "todo_1",
				Status:  api.TodoStatus_TODO_STATUS_TODO,
			},
			{
				Id:      "2",
				Content: "todo_2",
				Status:  api.TodoStatus_TODO_STATUS_DOING,
			},
			{
				Id:      "3",
				Content: "todo_3",
				Status:  api.TodoStatus_TODO_STATUS_DONE,
			},
		},
	}, nil
}

// Create ...
func (u *Todo) Create(ctx context.Context, req *api.CreateTodoRequest) (*api.CreateTodoResponse, error) {
	return &api.CreateTodoResponse{
		Todo: &api.Todo{
			Id:      "1",
			Content: req.Content,
			Status:  api.TodoStatus_TODO_STATUS_TODO,
		},
	}, nil
}

// Update ...
func (u *Todo) Update(ctx context.Context, req *api.UpdateTodoRequest) (*api.UpdateTodoResponse, error) {
	return &api.UpdateTodoResponse{
		Todo: &api.Todo{
			Id:      req.Id,
			Content: req.Content,
			Status:  req.Status,
		},
	}, nil
}

// Delete ...
func (u *Todo) Delete(ctx context.Context, req *api.DeleteTodoRequest) (*api.DeleteTodoResponse, error) {
	return &api.DeleteTodoResponse{}, nil
}
