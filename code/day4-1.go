package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"reflect"
	"regexp"
	"strings"
)

func getFile() string {
	data, err := ioutil.ReadFile("../input/day4.txt")
	if err != nil {
		log.Fatal("File reading error %v", err)
	}

	return string(data)
}

// Checks if item exists in array
func termExists(arrayType interface{}, item interface{}) bool {
	arr := reflect.ValueOf(arrayType)

	if arr.Kind() != reflect.Array {
		log.Fatal("Invalid data type")
	}

	for i := 0; i < arr.Len(); i++ {
		if arr.Index(i).Interface() == item {
			return true
		}
	}

	return false
}

func main() {
	inputfile := getFile()
	lines := strings.Split(inputfile, "\n\n")

	// Precompile regexes
	reSplitTerms := regexp.MustCompile("\\s|\\n")
	reTerms := regexp.MustCompile("(byr|iyr|eyr|hgt|hcl|ecl|pid|cid):(.+)")

	requiredTerms := [7]string{"byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"}

	// Keep track of valid passports in counter
	validCounter := 0
	for _, line := range lines {
		var reqTerms [8]string

		// Split up individual terms
		terms := reSplitTerms.Split(line, -1)

		for i, term := range terms {
			found := reTerms.FindStringSubmatch(term)

			if found == nil {
				fmt.Printf("No match found")
			}

			reqTerms[i] = found[1]
		}

		// Check if each required term exists in line
		invalidTerms := 0
		for _, requiredTerm := range requiredTerms {
			if ! termExists(reqTerms, requiredTerm) {
				invalidTerms++
			}
		}

		if invalidTerms == 0 {
			validCounter++
		}
	}

	fmt.Print(validCounter)
}
