package main

import (
	"net/http"

	"github.com/go-chi/chi/v5"

	_ "github.com/danielgtaylor/huma/v2/formats/cbor"
)

func main() {
	router := chi.NewMux()

	RegisterAPI(router)

	http.ListenAndServe("127.0.0.1:8888", router)
}
