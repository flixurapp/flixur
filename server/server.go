package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/go-chi/chi/middleware"
	"github.com/go-chi/chi/v5"
)

var port = 8787

func main() {
	router := chi.NewMux()
	router.Use(middleware.Compress(5))
	router.Use(middleware.Recoverer)
	router.Use(middleware.RequestID)
	router.Use(middleware.RequestID)

	RegisterAPI(router)

	if Dev {
		log.Print("Running in development mode.")
	} else {
		log.Printf("Listening on port %d.", port)
	}

	http.ListenAndServe(fmt.Sprintf(":%d", port), router)
}
