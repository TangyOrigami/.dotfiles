package main

import (
	"bufio"
	"fmt"
	"os"
	"time"
)

type Task struct {
	Title     string
	StartTime time.Time
	EndTime   time.Duration
}

func (r Task) ElapsedTime() int {
	return int(r.EndTime) / 1000000000
}

func main() {
	reader := bufio.NewReader(os.Stdin)
	start := time.Now()

	taskTitle, _ := reader.ReadString('\n')

	task := Task{
		Title:     taskTitle,
		StartTime: start,
		EndTime:   time.Since(start),
	}

	fmt.Printf("Title: %s\nElapsed Time: %d\n", task.Title, task.ElapsedTime())
}
