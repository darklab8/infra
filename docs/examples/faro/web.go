package main

import (
	"flag"
	"log"
	"net/http"
)

func addCORS(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		next.ServeHTTP(w, req)
	})
}

func main() {
	port := "9000"
	directory := "."
	flag.Parse()

	handler := addCORS(http.FileServer(http.Dir(directory)))

	log.Printf("Serving %s on HTTP port: %s\n", directory, port)
	log.Fatal(http.ListenAndServe(":"+port, handler))
}
