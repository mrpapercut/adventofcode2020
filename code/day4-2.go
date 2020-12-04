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
	
	re_byr := regexp.MustCompile("^19[2-9][0-9]|200[0-2]$")
	re_iyr := regexp.MustCompile("^201[0-9]|2020$")
	re_eyr := regexp.MustCompile("^202[0-9]|2030$")
	re_hgt := regexp.MustCompile("^(1[5-8][0-9]|19[0-3])cm|(59|6[0-9]|7[0-6])in$")
	re_hcl := regexp.MustCompile("^#[0-9a-fA-F]{6}$")
	re_ecl := regexp.MustCompile("^amb|blu|brn|gry|grn|hzl|oth$")
	re_pid := regexp.MustCompile("^[0-9]{9}$")

	requiredTerms := [7]string{"byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"}

	// Keep track of valid passports in counter
	validCounter := 0
	for _, line := range lines {
		var reqTerms = map[string]string{}

		// Split up individual terms
		terms := reSplitTerms.Split(line, -1)

		for _, term := range terms {
			found := reTerms.FindStringSubmatch(term)

			if found == nil {
				fmt.Printf("No match found")
			}

			reqTerms[found[1]] = found[2]
		}

		// Check if each required term exists in line
		invalidTerms := 0
		for _, requiredTerm := range requiredTerms {
			if _, ok := reqTerms[requiredTerm]; ! ok {
				invalidTerms++
			}
		}

		// For each value of required term, check if it matches required format
		if invalidTerms == 0 {
			errMatch := false
			for key, value := range reqTerms {
				switch key {
				case "byr":
					if ! re_byr.MatchString(value) { errMatch = true }
				case "iyr":
					if ! re_iyr.MatchString(value) { errMatch = true }
				case "eyr":
					if ! re_eyr.MatchString(value) { errMatch = true }
				case "hgt":
					if ! re_hgt.MatchString(value) { errMatch = true }
				case "hcl":
					if ! re_hcl.MatchString(value) { errMatch = true }
				case "ecl":
					if ! re_ecl.MatchString(value) { errMatch = true }
				case "pid":
					if ! re_pid.MatchString(value) { errMatch = true }
				default:
					// fmt.Printf("%s: %s\n", key, value)
				}
			}

			if (errMatch == false) {
				validCounter++
			}
		}
	}

	fmt.Println(validCounter)
}
