# Advent of Code 2020 Day 4: Passport Processing 
## Description
### Part 1
You arrive at the airport only to realize that you grabbed your North Pole Credentials instead of your passport. While these documents are extremely similar, North Pole Credentials aren't issued by a country and therefore aren't actually valid documentation for travel in most of the world.

It seems like you're not the only one having problems, though; a very long line has formed for the automatic passport scanners, and the delay could upset your travel itinerary.

Due to some questionable network security, you realize you might be able to solve both of these problems at the same time.

The automatic passport scanners are slow because they're having trouble detecting which passports have all required fields. The expected fields are as follows:
```
byr (Birth Year)
iyr (Issue Year)
eyr (Expiration Year)
hgt (Height)
hcl (Hair Color)
ecl (Eye Color)
pid (Passport ID)
cid (Country ID)
```
Passport data is validated in batch files (your puzzle input). Each passport is represented as a sequence of key:value pairs separated by spaces or newlines. Passports are separated by blank lines.

Here is an example batch file containing four passports:
```
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
```
The first passport is valid - all eight fields are present. The second passport is invalid - it is missing hgt (the Height field).

The third passport is interesting; the only missing field is cid, so it looks like data from North Pole Credentials, not a passport at all! Surely, nobody would mind if you made the system temporarily ignore missing cid fields. Treat this "passport" as valid.

The fourth passport is missing two fields, cid and byr. Missing cid is fine, but missing any other field is not, so this passport is invalid.

According to the above rules, your improved system would report 2 valid passports.

Count the number of valid passports - those that have all required fields. Treat cid as optional. In your batch file, how many passports are valid?

### Part 2
The line is moving more quickly now, but you overhear airport security talking about how passports with invalid data are getting through. Better add some data validation, quick!

You can continue to ignore the cid field, but each other field has strict rules about what values are valid for automatic validation:
```
byr (Birth Year) - four digits; at least 1920 and at most 2002.
iyr (Issue Year) - four digits; at least 2010 and at most 2020.
eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
hgt (Height) - a number followed by either cm or in:
If cm, the number must be at least 150 and at most 193.
If in, the number must be at least 59 and at most 76.
hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
pid (Passport ID) - a nine-digit number, including leading zeroes.
cid (Country ID) - ignored, missing or not.
```
Your job is to count the passports where all required fields are both present and valid according to the above rules. Here are some example values:
```
byr valid:   2002
byr invalid: 2003

hgt valid:   60in
hgt valid:   190cm
hgt invalid: 190in
hgt invalid: 190

hcl valid:   #123abc
hcl invalid: #123abz
hcl invalid: 123abc

ecl valid:   brn
ecl invalid: wat

pid valid:   000000001
pid invalid: 0123456789
```
Here are some invalid passports:
```
eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007
```
Here are some valid passports:
```
pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
```
Count the number of valid passports - those that have all required fields and valid values. Continue to treat cid as optional. In your batch file, how many passports are valid?

## Language used
Go

## Solutions:
### Part 1
```go
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
```

### Part 2
```go
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
```

## Source
[Part 1](./code/day4.go)
[Part 2](./code/day4.go)
