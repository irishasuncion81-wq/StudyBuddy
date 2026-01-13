Imports Microsoft.AspNet.SignalR
Imports MySql.Data.MySqlClient
Imports System.Configuration

Public Class ChatHub
    Inherits Hub

    Dim connStr As String = ConfigurationManager.ConnectionStrings("StudyBuddyDB").ConnectionString

    Public Sub SendMessage(name As String, message As String)
        ' 1. I-save muna sa MySQL database
        Try
            Using conn As New MySqlConnection(connStr)
                ' Palitan ang 'chat_messages' at columns base sa table mo
                Dim sql As String = "INSERT INTO chat_messages (SenderName, MessageText, Timestamp) VALUES (@name, @msg, NOW())"
                Dim cmd As New MySqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@name", name)
                cmd.Parameters.AddWithValue("@msg", message)

                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        Catch ex As Exception
            ' Dito papasok ang error kung hindi maka-save sa DB
        End Try

        ' 2. I-broadcast sa lahat para makita nila ang message real-time
        Clients.All.broadcastMessage(name, message)
    End Sub
End Class