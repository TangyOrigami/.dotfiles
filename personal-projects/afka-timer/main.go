package main

import (
	"bufio"
	"fmt"
	"os"
	"time"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	start := time.Now()

	text, _ := reader.ReadString('\n')
	elapsed := time.Since(start)
	elapsed = elapsed / 1000000000

	fmt.Printf("Took: %d, Wrote: %s", elapsed, text)
}
