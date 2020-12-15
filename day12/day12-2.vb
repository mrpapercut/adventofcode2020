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
