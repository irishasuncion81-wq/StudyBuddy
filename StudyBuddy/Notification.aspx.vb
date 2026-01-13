Imports MySql.Data.MySqlClient
Imports System.Data

Public Class Notification
    Inherits System.Web.UI.Page

    Private connStr As String = ConfigurationManager.ConnectionStrings("StudyBuddyDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindNotifications()
        End If
    End Sub

    Private Sub BindNotifications()
        If Session("UserID") Is Nothing Then
            Response.Redirect("Login.aspx")
            Exit Sub
        End If

        Dim currentUserId As Integer = CInt(Session("UserID"))

        Using conn As New MySqlConnection(connStr)
            Dim sql As String = "SELECT NotificationID, Message, DateCreated, IsRead " &
                                "FROM notifications WHERE UserID = @uid " &
                                "ORDER BY DateCreated DESC LIMIT 50"

            Dim cmd As New MySqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@uid", currentUserId)

            Dim dt As New DataTable()
            Dim da As New MySqlDataAdapter(cmd)
            Try
                conn.Open()
                da.Fill(dt)
                rptNotifications.DataSource = dt
                rptNotifications.DataBind()

                phNoNotif.Visible = (dt.Rows.Count = 0)
            Catch ex As Exception
                ' Log error
            End Try
        End Using
    End Sub

    ' This handles clicking a notification in the list
    Protected Sub rptNotifications_ItemCommand(source As Object, e As RepeaterCommandEventArgs)
        If e.CommandName = "Navigate" Then
            ' The CommandArgument usually looks like "ID|Message"
            Dim args As String() = e.CommandArgument.ToString().Split("|"c)
            Dim notifID As Integer = CInt(args(0))
            Dim msgText As String = args(1).ToLower()

            ' 1. Mark as read
            MarkAsRead(notifID)

            ' 2. Redirect based on the message content
            If msgText.Contains("liked your board") Or msgText.Contains("commented on your board") Then
                Response.Redirect("BuddyBoard.aspx")
            ElseIf msgText.Contains("friend") Or msgText.Contains("buddy") Or msgText.Contains("request") Then
                Response.Redirect("Tutoring.aspx")
            ElseIf msgText.Contains("chat") Or msgText.Contains("message") Then
                Response.Redirect("Chatroom.aspx")
            ElseIf msgText.Contains("rate") Or msgText.Contains("review") Then
                Response.Redirect("Reviewers.aspx")
            Else
                ' If no specific page, just refresh the list
                BindNotifications()
            End If
        End If
    End Sub

    Private Sub MarkAsRead(ByVal id As Integer)
        Using conn As New MySqlConnection(connStr)
            Dim sql As String = "UPDATE notifications SET IsRead = 1 WHERE NotificationID = @id"
            Dim cmd As New MySqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@id", id)
            Try
                conn.Open()
                cmd.ExecuteNonQuery()
            Catch ex As Exception
            End Try
        End Using
    End Sub
End Class