package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"time"
)

type Task struct {
	Title     string
	StartTime time.Time
	EndTime   time.Duration
}

func check(e error) {
	if e != nil {
		log.Panic(e)
	}
}

func (r Task) ElapsedTime() int {
	return int(r.EndTime) / 1000000000
}

func main() {
	reader := bufio.NewReader(os.Stdin)
	start := time.Now()

	taskTitle, err := reader.ReadString('\n')
	check(err)

	task := Task{
		Title:     taskTitle,
		StartTime: start,
		EndTime:   time.Since(start),
	}

	fmt.Printf("Title: %s\nElapsed Time: %d\n", task.Title, task.ElapsedTime())
}
