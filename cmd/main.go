package main

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
	app "github.com/krinklesaurus/helloservice"
	"github.com/krinklesaurus/helloservice/log"
	negronilogrus "github.com/meatballhat/negroni-logrus"
	uuid "github.com/satori/go.uuid"
	"github.com/urfave/negroni"
)

// Struct from the app package
var hello *app.Hello

func handler(w http.ResponseWriter, r *http.Request) {
	if hello == nil {
		hello = &app.Hello{uuid.NewV4().String()}
	}
	fmt.Fprintf(w, "Hi there with love from %v!", hello.Name)
}

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/", handler)
	n := negroni.New()
	n.Use(negronilogrus.NewMiddleware())
	n.UseHandler(r)

	log.Infof("starting server at port %d", 8080)
	http.ListenAndServe(":8080", n)
}
