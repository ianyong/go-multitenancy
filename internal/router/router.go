package router

import (
	"go-multitenancy/internal/api/handlers"
	"time"

	"github.com/go-chi/chi"
	"github.com/go-chi/chi/middleware"
)

func New() *chi.Mux {
	router := chi.NewRouter()
	setUpMiddleware(router)
	router.MethodFunc("GET", "/", handlers.HandleIndex)
	return router
}

func setUpMiddleware(router *chi.Mux) {
	// Injects a request ID in the context of each request
	router.Use(middleware.RequestID)
	// Sets a http.Request's RemoteAddr to that of either the X-Forwarded-For or X-Real-IP header
	router.Use(middleware.RealIP)
	// Logs requests
	router.Use(middleware.Logger)
	// Recovers from panics and return a 500 Internal Server Error
	router.Use(middleware.Recoverer)
	// Returns a 504 Gateway Timeout after 1 min
	router.Use(middleware.Timeout(60 * time.Second))
}
