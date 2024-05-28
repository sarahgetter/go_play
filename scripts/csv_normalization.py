package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

// normalize normalizes a slice of float64 values using min-max normalization.
func normalize(data []float64) []float64 {
	min, max := data[0], data[0]
	for _, v := range data {
		if v < min {
			min = v
		}
		if v > max {
			max = v
		}
	}

	normalized := make([]float64, len(data))
	for i, v := range data {
		normalized[i] = (v - min) / (max - min)
	}
	return normalized
}

func main() {
	// Open the CSV file for reading
	file, err := os.Open("input.csv")
	if err != nil {
		fmt.Println("Error opening file:", err)
		return
	}
	defer file.Close()

	// Read the file into a 2D slice
	reader := csv.NewReader(file)
	records, err := reader.ReadAll()
	if err != nil {
		fmt.Println("Error reading CSV file:", err)
		return
	}

	// Assume the first column contains float data to be normalized
	var data []float64
	for _, record := range records {
		if value, err := strconv.ParseFloat(record[0], 64); err == nil {
			data = append(data, value)
		}
	}

	// Normalize the data
	normalizedData := normalize(data)

	// Write the normalized data to a new CSV file
	outputFile, err := os.Create("normalized_output.csv")
	if err != nil {
		fmt.Println("Error creating output file:", err)
		return
	}
	defer outputFile.Close()

	writer := csv.NewWriter(outputFile)
	defer writer.Flush()

	for _, value := range normalizedData {
		record := []string{fmt.Sprintf("%f", value)}
		if err := writer.Write(record); err != nil {
			fmt.Println("Error writing record to CSV:", err)
			return
		}
	}

	fmt.Println("Data normalization complete. Output written to normalized_output.csv")
}
