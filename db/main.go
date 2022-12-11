package main

import (
	"fmt"
	"log"
	"os"
)

func main() {
	dirname, err := os.UserHomeDir()
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(dirname)
}
