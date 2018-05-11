/*
* Golang HptpHello
*
* @package     main
* @author      @jeffotoni
* @size        05/2018
 */

package main

import (
	"fmt"
	"log"
	"net/http"
)

const (
	PORT  = "8080"
	Sufix = "\033[0m"
)

// handler hello
func Hello(w http.ResponseWriter, r *http.Request) {

	if r.Method == "POST" {

		r.ParseForm()

		name := r.PostFormValue("name")

		w.WriteHeader(http.StatusOK)

		if name != "" {

			fmt.Fprintf(w, "\nOlá %s\n", name)
		} else {

			msg := "Você pode tentar o comando abaixo:"
			msg2 := "curl -X POST localhost:" + PORT + " -d \"name=jefferson\""

			text := fmt.Sprintf("\033[0;36m%s%s", msg, Sufix)
			text2 := fmt.Sprintf("\033[0;33m%s%s", msg2, Sufix)

			fmt.Fprintf(w, "\n####################################################")
			fmt.Fprintf(w, "\n       "+text)
			fmt.Fprintf(w, "\n####################################################")
			fmt.Fprintf(w, "\n\n-----------------------COMANDO----------------------")
			fmt.Fprintf(w, "\n"+text2)
			fmt.Fprintf(w, "\n----------------------------------------------------\n\n")
		}

	} else if r.Method == "GET" {

		w.WriteHeader(http.StatusMethodNotAllowed)

		http.Error(w, "POST only", http.StatusMethodNotAllowed)
	}
}

// nossa funcao
// principal
func main() {

	// show msg
	fmt.Println("Iniciando Hello...")

	// declarando nosso endpoint
	http.HandleFunc("/hello", Hello)

	// apresentando um log na saida caso
	// ocorra algo de errado
	log.Fatal(http.ListenAndServe(":"+PORT, nil))
}
