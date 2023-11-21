package main

import (
	"fmt"
	"math/rand"
	"time"
)

// generateData continuously generates random numbers and sends them to a channel.
func generateData(dataChan chan<- float64) {
	for {
		dataChan <- rand.Float64() * 100 // Generate a random number between 0 and 100
		time.Sleep(time.Second)          // Simulate time delay between data readings
	}
}

// movingAverage computes the moving average of the data stream.
// windowSize determines the number of data points considered for the average.
func movingAverage(dataChan <-chan float64, windowSize int) {
	var window []float64
	for data := range dataChan {
		window = append(window, data)
		if len(window) > windowSize {
			window = window[1:] // Remove the oldest element
		}

		var sum float64
		for _, v := range window {
			sum += v
		}
		avg := sum / float64(len(window))
		fmt.Printf("Moving Average (last %d): %.2f\n", windowSize, avg)
	}
}

func main() {
	rand.Seed(time.Now().UnixNano()) // Initialize the random number generator

	dataChan := make(chan float64)
	windowSize := 5 // Size of the moving average window

	go generateData(dataChan)           // Start generating data
	movingAverage(dataChan, windowSize) // Start processing data
}
