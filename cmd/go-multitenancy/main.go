package main

import (
	"go-multitenancy/internal/router"
	"net/http"
)

func main() {
	router := router.New()
	http.ListenAndServe(":3000", router)
}
