Imports MySql.Data.MySqlClient
Imports System.Data

Public Class BuddyBoard
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("StudyBuddyDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadFeed()
        End If
    End Sub

    Private Sub LoadFeed()
        Using conn As New MySqlConnection(connStr)
            Dim query As String = "SELECT b.*, r.ProfilePicture " &
                                 "FROM buddy_board b " &
                                 "LEFT JOIN register r ON b.UserName = r.UserName " &
                                 "ORDER BY b.PostDate DESC"
            Dim cmd As New MySqlCommand(query, conn)
            Dim dt As New DataTable()
            conn.Open()
            dt.Load(cmd.ExecuteReader())
            rptFeed.DataSource = dt
            rptFeed.DataBind()
        End Using
    End Sub

    Protected Sub btnPost_Click(sender As Object, e As EventArgs)
        If String.IsNullOrWhiteSpace(txtPost.Text) Then Return

        Dim currentUser As String = If(Session("UserName"), "Guest Buddy")

        Using conn As New MySqlConnection(connStr)
            Dim query As String = "INSERT INTO buddy_board (UserName, Content) VALUES (@user, @content)"
            Dim cmd As New MySqlCommand(query, conn)
            cmd.Parameters.AddWithValue("@user", currentUser)
            cmd.Parameters.AddWithValue("@content", txtPost.Text)

            conn.Open()
            cmd.ExecuteNonQuery()
        End Using

        txtPost.Text = ""
        LoadFeed()
    End Sub

    Public Function GetLikeCount(postId As Object) As Integer
        Using conn As New MySqlConnection(connStr)
            Dim cmd As New MySqlCommand("SELECT COUNT(*) FROM post_likes WHERE PostID = @pid", conn)
            cmd.Parameters.AddWithValue("@pid", postId)
            conn.Open()
            Return Convert.ToInt32(cmd.ExecuteScalar())
        End Using
    End Function

    Public Function GetComments(postId As Object) As DataTable
        Using conn As New MySqlConnection(connStr)
            Dim cmd As New MySqlCommand("SELECT * FROM post_comments WHERE PostID = @pid ORDER BY CommentDate ASC", conn)
            cmd.Parameters.AddWithValue("@pid", postId)
            Dim dt As New DataTable()
            conn.Open()
            dt.Load(cmd.ExecuteReader())
            Return dt
        End Using
    End Function

    Protected Sub rptFeed_ItemCommand(source As Object, e As RepeaterCommandEventArgs) Handles rptFeed.ItemCommand
        Dim postId As String = e.CommandArgument.ToString()

        If Session("UserName") Is Nothing Then
            Response.Write("<script>alert('Please login to perform this action');</script>")
            Return
        End If

        Dim currentUser As String = Session("UserName").ToString()

        ' FIRST: Get the Owner of the post to notify them
        Dim postOwner As String = ""
        Using conn As New MySqlConnection(connStr)
            Dim cmdOwner As New MySqlCommand("SELECT UserName FROM buddy_board WHERE PostID = @pid", conn)
            cmdOwner.Parameters.AddWithValue("@pid", postId)
            conn.Open()
            Dim result = cmdOwner.ExecuteScalar()
            If result IsNot Nothing Then postOwner = result.ToString()
        End Using

        If e.CommandName = "Like" Then
            Using conn As New MySqlConnection(connStr)
                ' Using IGNORE so they can only like once
                Dim cmd As New MySqlCommand("INSERT IGNORE INTO post_likes (PostID, UserName) VALUES (@pid, @user)", conn)
                cmd.Parameters.AddWithValue("@pid", postId)
                cmd.Parameters.AddWithValue("@user", currentUser)
                conn.Open()
                Dim rowsAffected As Integer = cmd.ExecuteNonQuery()

                ' NOTIFICATION: Only if someone else likes the post
                If rowsAffected > 0 AndAlso postOwner <> "" AndAlso postOwner <> currentUser Then
                    AddNotification(postOwner, currentUser & " liked your board post")
                End If
            End Using
            LoadFeed()

        ElseIf e.CommandName = "AddComment" Then
            Dim txtComment As TextBox = CType(e.Item.FindControl("txtComment"), TextBox)
            If txtComment IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(txtComment.Text) Then
                Using conn As New MySqlConnection(connStr)
                    Dim cmd As New MySqlCommand("INSERT INTO post_comments (PostID, UserName, CommentText) VALUES (@pid, @user, @text)", conn)
                    cmd.Parameters.AddWithValue("@pid", postId)
                    cmd.Parameters.AddWithValue("@user", currentUser)
                    cmd.Parameters.AddWithValue("@text", txtComment.Text)
                    conn.Open()
                    cmd.ExecuteNonQuery()

                    ' NOTIFICATION: Only if someone else comments on the post
                    If postOwner <> "" AndAlso postOwner <> currentUser Then
                        AddNotification(postOwner, currentUser & " commented on your board post")
                    End If
                End Using
                txtComment.Text = ""
                LoadFeed()
            End If

        ElseIf e.CommandName = "Report" Then
            Dim ddlReason As DropDownList = CType(e.Item.FindControl("ddlReason"), DropDownList)
            If ddlReason IsNot Nothing AndAlso ddlReason.SelectedValue <> "" Then
                Using conn As New MySqlConnection(connStr)
                    Dim query As String = "INSERT INTO post_reports (PostID, ReportedBy, Reason) VALUES (@pid, @user, @reason)"
                    Dim cmd As New MySqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@pid", postId)
                    cmd.Parameters.AddWithValue("@user", currentUser)
                    cmd.Parameters.AddWithValue("@reason", ddlReason.SelectedValue)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
                Response.Write("<script>alert('Post has been reported to Admin.');</script>")
            Else
                Response.Write("<script>alert('Please select a reason for reporting.');</script>")
            End If
        End If
    End Sub

    Private Sub AddNotification(ByVal targetUser As String, ByVal message As String)
        Using conn As New MySqlConnection(connStr)
            ' Find UserID based on UserName
            Dim getUserSql As String = "SELECT UserID FROM register WHERE UserName = @un"
            Dim cmdUser As New MySqlCommand(getUserSql, conn)
            cmdUser.Parameters.AddWithValue("@un", targetUser)

            Try
                conn.Open()
                Dim result = cmdUser.ExecuteScalar()
                If result IsNot Nothing Then
                    Dim targetId As Integer = Convert.ToInt32(result)

                    ' Insert into notifications table
                    Dim sql As String = "INSERT INTO notifications (UserID, Message, DateCreated, IsRead) VALUES (@uid, @msg, NOW(), 0)"
                    Dim cmdNotif As New MySqlCommand(sql, conn)
                    cmdNotif.Parameters.AddWithValue("@uid", targetId)
                    cmdNotif.Parameters.AddWithValue("@msg", message)
                    cmdNotif.ExecuteNonQuery()
                End If
            Catch ex As Exception
            End Try
        End Using
    End Sub
End Class