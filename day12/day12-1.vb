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
