# Advent of Code 2020 Day 12: Rain Risk
## Description
### Part 1
Your ferry made decent progress toward the island, but the storm came in faster than anyone expected. The ferry needs to take evasive actions!

Unfortunately, the ship's navigation computer seems to be malfunctioning; rather than giving a route directly to safety, it produced extremely circuitous instructions. When the captain uses the PA system to ask if anyone can help, you quickly volunteer.

The navigation instructions (your puzzle input) consists of a sequence of single-character actions paired with integer input values. After staring at them for a few minutes, you work out what they probably mean:

- Action N means to move north by the given value.
- Action S means to move south by the given value.
- Action E means to move east by the given value.
- Action W means to move west by the given value.
- Action L means to turn left the given number of degrees.
- Action R means to turn right the given number of degrees.
- Action F means to move forward by the given value in the direction the ship is currently facing.
The ship starts by facing east. Only the L and R actions change the direction the ship is facing. (That is, if the ship is facing east and the next instruction is N10, the ship would move north 10 units, but would still move east if the following action were F.)

For example:
```
F10
N3
F7
R90
F11
```
These instructions would be handled as follows:

- F10 would move the ship 10 units east (because the ship starts by facing east) to east 10, north 0.
- N3 would move the ship 3 units north to east 10, north 3.
- F7 would move the ship another 7 units east (because the ship is still facing east) to east 17, north 3.
- R90 would cause the ship to turn right by 90 degrees and face south; it remains at east 17, north 3.
- F11 would move the ship 11 units south to east 17, south 8.
At the end of these instructions, the ship's Manhattan distance (sum of the absolute values of its east/west position and its north/south position) from its starting position is 17 + 8 = 25.

Figure out where the navigation instructions lead. What is the Manhattan distance between that location and the ship's starting position?

### Part 2
Before you can give the destination to the captain, you realize that the actual action meanings were printed on the back of the instructions the whole time.

Almost all of the actions indicate how to move a waypoint which is relative to the ship's position:

- Action N means to move the waypoint north by the given value.
- Action S means to move the waypoint south by the given value.
- Action E means to move the waypoint east by the given value.
- Action W means to move the waypoint west by the given value.
- Action L means to rotate the waypoint around the ship left (counter-clockwise) the given number of degrees.
- Action R means to rotate the waypoint around the ship right (clockwise) the given number of degrees.
- Action F means to move forward to the waypoint a number of times equal to the given value.
The waypoint starts 10 units east and 1 unit north relative to the ship. The waypoint is relative to the ship; that is, if the ship moves, the waypoint moves with it.

For example, using the same instructions as above:

- F10 moves the ship to the waypoint 10 times (a total of 100 units east and 10 units north), leaving the ship at east 100, north 10. The waypoint stays 10 units east and 1 unit north of the ship.
- N3 moves the waypoint 3 units north to 10 units east and 4 units north of the ship. The ship remains at east 100, north 10.
- F7 moves the ship to the waypoint 7 times (a total of 70 units east and 28 units north), leaving the ship at east 170, north 38. The waypoint stays 10 units east and 4 units north of the ship.
- R90 rotates the waypoint around the ship clockwise 90 degrees, moving it to 4 units east and 10 units south of the ship. The ship remains at east 170, north 38.
- F11 moves the ship to the waypoint 11 times (a total of 44 units east and 110 units south), leaving the ship at east 214, south 72. The waypoint stays 4 units east and 10 units south of the ship.
After these operations, the ship's Manhattan distance from its starting position is 214 + 72 = 286.

Figure out where the navigation instructions actually lead. What is the Manhattan distance between that location and the ship's starting position?

## Language used
Visual Basic (VB.Net)

## Solutions:
### Part 1
```vb
Imports System
Imports System.Array
Imports System.Collections
Imports System.IO
Imports System.String

Module Day12
    Public Sub Log(ByRef message As String)
        Using sw as StreamWriter = New StreamWriter("./vblog.txt", True)
            sw.WriteLine(message)
        End Using
    End Sub

    Public Class RainRisk
        Private InputFile as ArrayList = New ArrayList()

        Public FacingDirection As String = "E"
        Public XCoor As Integer = 0
        Public YCoor As Integer = 0

        Public Sub ReadFile(ByRef Filename As String)
            Using sr As StreamReader = New StreamReader(Filename)
                Dim line As String
                line = sr.ReadLine()
                While (line <> Nothing)
                    Me.InputFile.Add(line)
                    line = sr.ReadLine()
                End While
            End Using
        End Sub

        Public Sub LogCoor()
            Dim Terms() As String = {Me.XCoor, Me.YCoor, Me.FacingDirection}
            Log(String.Join(" ", Terms))
        End Sub

        Public Sub RotateLeft(ByRef Degrees As Integer)
            Dim Directions() As String = {"N", "W", "S", "E"}
            Dim CurrentFDIndx = System.Array.IndexOf(Directions, Me.FacingDirection)
            Dim NewFDIdx As Long = (CurrentFDIndx + (Degrees / 90)) Mod 4

            Me.FacingDirection = Directions.GetValue(NewFDIdx)
        End Sub

        Public Sub RotateRight(ByRef Degrees As Integer)
            Dim Directions() As String = {"N", "E", "S", "W"}
            Dim CurrentFDIndx = System.Array.IndexOf(Directions, Me.FacingDirection)
            Dim NewFDIdx As Long = (CurrentFDIndx + (Degrees / 90)) Mod 4

            Me.FacingDirection = Directions.GetValue(NewFDIdx)
        End Sub

        Public Sub MoveDirection(ByRef Direction As String, ByRef Units As Integer)
            If (Direction = "N") Then
                Me.XCoor -= Units
            Else If (Direction = "S") Then
                Me.XCoor += Units
            Else If (Direction = "W") Then
                Me.YCoor -= Units
            Else If (Direction = "E") Then
                Me.YCoor += Units
            End If
        End Sub

        Public Sub MoveForward(ByRef Units As Integer)
            Me.MoveDirection(Me.FacingDirection, Units)
        End Sub

        Public Sub GetManhattanDistance()
            Log(Math.Abs(Me.YCoor) + Math.Abs(Me.XCoor))
        End Sub

        Public Sub WalkInstructions()
            For Each i In Me.InputFile
                Dim Action As String = i.Remove(1)
                Dim Units As Integer = i.Remove(0, 1)

                If (Action = "N" Or Action = "S" Or Action = "E" Or Action = "W") Then
                    Me.MoveDirection(Action, Units)
                Else If (Action = "L") Then
                    Me.RotateLeft(Units)
                Else If (Action = "R") Then
                    Me.RotateRight(Units)
                Else If (Action = "F") Then
                    Me.MoveForward(Units)
                End If
            Next i
        End Sub
    End Class

    Sub Main()
        Log("--")
        Dim rr As New RainRisk()
        rr.ReadFile("./day12/day12.txt")

        rr.WalkInstructions()

        rr.GetManhattanDistance()
    End Sub
End Module
```

### Part 2
```vb
Imports System
Imports System.Array
Imports System.Collections
Imports System.IO
Imports System.String

Module Day12
    Public Sub Log(ByRef message As String)
        Using sw as StreamWriter = New StreamWriter("./vblog.txt", True)
            sw.WriteLine(message)
        End Using
    End Sub

    Public Class RainRisk
        Private InputFile as ArrayList = New ArrayList()

        Public FacingDirection As String = "E"
        Public ShipXCoor As Integer = 0
        Public ShipYCoor As Integer = 0
        Public WaypointXCoor As Integer = -1
        Public WaypointYCoor As Integer = 10


        Public Sub ReadFile(ByRef Filename As String)
            Using sr As StreamReader = New StreamReader(Filename)
                Dim line As String
                line = sr.ReadLine()
                While (line <> Nothing)
                    Me.InputFile.Add(line)
                    line = sr.ReadLine()
                End While
            End Using
        End Sub

        Public Sub LogCoor()
            Dim Terms() As String = {
                "ShipX", Me.ShipXCoor,
                "ShipY", Me.ShipYCoor,
                "Direction", Me.FacingDirection,
                "WaypointX", Me.WaypointXCoor,
                "WaypointY", Me.WaypointYCoor
            }
            Log(String.Join(" ", Terms))
        End Sub

        Public Sub Rotate(ByRef Direction As String, ByRef Degrees As Integer)
            Dim TempXCoor As Integer = Me.WaypointXCoor
            Dim TempYCoor As Integer = Me.WaypointYCoor

            If (Degrees = 180) Then
                Me.WaypointXCoor = 0 - TempXCoor
                Me.WaypointYCoor = 0 - TempYCoor
            Else If ((Degrees = 90 And Direction = "L") Or (Degrees = 270 And Direction = "R")) Then
                Me.WaypointXCoor = -TempYCoor
                Me.WaypointYCoor = TempXCoor
            Else If ((Degrees = 90 And Direction = "R") Or (Degrees = 270 And Direction = "L")) Then
                Me.WaypointXCoor = TempYCoor
                Me.WaypointYCoor = -TempXCoor
            End If
        End Sub

        Public Sub RotateLeft(ByRef Degrees As Integer)
            Me.Rotate("L", Degrees)
        End Sub

        Public Sub RotateRight(ByRef Degrees As Integer)
            Me.Rotate("R", Degrees)
        End Sub

        Public Sub MoveDirection(ByRef Direction As String, ByRef Units As Integer)
            If (Direction = "N") Then
                Me.WaypointXCoor -= Units
            Else If (Direction = "S") Then
                Me.WaypointXCoor += Units
            Else If (Direction = "W") Then
                Me.WaypointYCoor -= Units
            Else If (Direction = "E") Then
                Me.WaypointYCoor += Units
            End If
        End Sub

        Public Sub MoveTowardsWaypoint(ByRef Units As Integer)
            Me.ShipXCoor += Units * Me.WaypointXCoor
            Me.ShipYCoor += Units * Me.WaypointYCoor
        End Sub

        Public Sub GetManhattanDistance()
            Log(Math.Abs(Me.ShipYCoor) + Math.Abs(Me.ShipXCoor))
        End Sub

        Public Sub WalkInstructions()
            For Each i In Me.InputFile
                Dim Action As String = i.Remove(1)
                Dim Units As Integer = i.Remove(0, 1)

                If (Action = "N" Or Action = "S" Or Action = "E" Or Action = "W") Then
                    Me.MoveDirection(Action, Units)
                Else If (Action = "L") Then
                    Me.RotateLeft(Units)
                Else If (Action = "R") Then
                    Me.RotateRight(Units)
                Else If (Action = "F") Then
                    Me.MoveTowardsWaypoint(Units)
                End If
            Next i
        End Sub
    End Class

    Sub Main()
        Log("--")
        Dim rr As New RainRisk()
        rr.ReadFile("./day12/day12.txt")

        rr.WalkInstructions()

        rr.GetManhattanDistance()
    End Sub
End Module
```

## Source
[Part 1](./day12/day12-1.vb)
[Part 2](./day12/day12-2.vb)

## Usage
```cmd
vbc.exe .\day12\day12-1.vb
.\day12-1.exe

vbc.exe .\day12\day12-2.vb
.\day12-2.exe
```
