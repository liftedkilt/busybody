package main

import (
	"flag"
	"fmt"
	"net/http"
	"net/http/httputil"
)

func main() {

	var port string

	flag.StringVar(&port, "p", "8234", "Port to listen on")

	flag.Parse()

	http.HandleFunc("/", handle)

	if err := http.ListenAndServe(":"+port, nil); err != nil {
		panic(err)
	}
}

func handle(w http.ResponseWriter, r *http.Request) {
	d, err := httputil.DumpRequest(r, true)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(string(d))

	w.WriteHeader(http.StatusOK)
}
