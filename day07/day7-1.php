<?php

class HandyHaversacks {
    public $parsedInput;

    public function __construct($filename) {
        $this->parsedInput = $this->parseInputFile($filename);
    }

    public function parseInputFile($filename) {
        $inputcontents = file_get_contents($filename);
        $inputlines = explode("\n", $inputcontents);

        $bags = [];
        foreach ($inputlines as $line) {
            preg_match('/^(\w+\s\w+)\sbags contain (.*)$/', $line, $linematches);

            list($input, $style, $allchildren) = $linematches;

            if ($allchildren === 'no other bags.') {
                $children = [];
            } else {
                $children = array_map(function ($child) {
                    preg_match('/^(\d+)\s(\w+\s\w+)\sbags?\.?/', $child, $childmatches);
                    return [
                        'amount' => (int) $childmatches[1],
                        'style' => $childmatches[2]
                    ];
                }, explode(', ', $allchildren));
            }

            $bags[] = [
                // 'matches' => $linematches,
                'style' => $style,
                'children' => $children
            ];
        }

        return $bags;
    }

    public function getParentsByChild($childstyle, $parents = []) {
        // Get direct parents
        foreach ($this->parsedInput as $bag) {
            $parentBags = array_filter($bag['children'], function ($childbag) use ($childstyle) {
                return $childbag['style'] === $childstyle;
            });

            if (count($parentBags) > 0) {
                array_push($parents, $bag['style']);
            }
        }

        if (count($parents) > 0) {
            foreach ($parents as $parentStyle) {
                $parents = array_unique(array_merge($parents, $this->getParentsByChild($parentStyle)));
            }
        }

        return $parents;      
    }
}

$handyHaversacks = new HandyHaversacks(__DIR__.'/day7.txt');
$parents = $handyHaversacks->getParentsByChild('shiny gold');

echo count($parents);
