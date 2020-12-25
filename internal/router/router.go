package router

import (
	"go-multitenancy/internal/api/handlers"

	"github.com/go-chi/chi"
)

func New() *chi.Mux {
	r := chi.NewRouter()
	r.MethodFunc("GET", "/", handlers.HandleIndex)
	return r
}
