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
			fmt.Println("Olá ", name)

		} else {

			msg := "Você pode tentar o comando abaixo:"
			msg2 := "curl -X POST localhost:" + PORT + " -d \"name=jefferson\""

			text := fmt.Sprintf("\033[0;36m%s%s", msg, Sufix)
			text2 := fmt.Sprintf("\033[0;33m%s%s", msg2, Sufix)

			msg3 := "\n####################################################"
			msg4 := "\n       " + text
			msg5 := "\n####################################################"
			msg6 := "\n\n-----------------------COMANDO----------------------"
			msg7 := "\n" + text2
			msg8 := "\n----------------------------------------------------\n\n"

			fmt.Fprintf(w, msg3)
			fmt.Fprintf(w, msg4)
			fmt.Fprintf(w, msg5)
			fmt.Fprintf(w, msg6)
			fmt.Fprintf(w, msg7)
			fmt.Fprintf(w, msg8)

			// permitindo a saida
			// para descarregar
			// no log
			fmt.Println(msg3)
			fmt.Println(msg4)
			fmt.Println(msg5)
			fmt.Println(msg6)
			fmt.Println(msg7)
			fmt.Println(msg8)
		}

	} else {

		w.WriteHeader(http.StatusMethodNotAllowed)
		http.Error(w, "POST only", http.StatusMethodNotAllowed)

		// permitindo a saida
		// para descarregar
		// no log
		fmt.Println("Error, Post only")
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
