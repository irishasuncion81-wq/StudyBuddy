Imports MySql.Data.MySqlClient
Imports System.Data

Public Class AdminDashboard
    Inherits System.Web.UI.Page

    Private ReadOnly connStr As String = ConfigurationManager.ConnectionStrings("StudyBuddyDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        ' SECURITY CHECK 
        If Session("Role") Is Nothing AndAlso Session("role") Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Exit Sub
        End If

        Dim userRole As String = If(Session("Role"), Session("role")).ToString()

        If userRole <> "Admin" Then
            Response.Redirect("~/AccessDenied.aspx")
            Exit Sub
        End If

        ' LOAD DATA
        If Not IsPostBack Then
            lblAdminName.Text = If(TryCast(Session("FullName"), String), "Admin")

            LoadPendingResources()
            LoadFlaggedChats()
            LoadUsers()
            LoadReports()
            LoadStats()
        End If
    End Sub

    '  LOADERS

    Private Sub LoadPendingResources()
        Dim query As String =
            "SELECT id, filename, uploaded_by, upload_date, is_approved " &
            "FROM reviewers " &
            "WHERE is_approved = 0 " &
            "ORDER BY upload_date DESC " &
            "LIMIT 5"

        BindGrid(query, gvResources)
    End Sub

    Private Sub LoadFlaggedChats()
        Dim query As String =
        "SELECT MessageID, SenderID, RoomID, Content, TimeStamp " &
        "FROM messages WHERE is_flagged = 1 ORDER BY TimeStamp DESC"

        BindGrid(query, gvChats)
    End Sub

    'Para sa Buddy Board Reports
    Private Sub LoadReports()
        Dim query As String =
            "SELECT p.UserName AS Author, p.Content, r.Reason " &
            "FROM post_reports r JOIN buddy_board p ON r.PostID = p.PostID " &
            "WHERE r.Status = 'Pending' LIMIT 5"

        BindGrid(query, gvReportedPosts)
    End Sub

    Private Sub LoadUsers()
        Dim query As String =
        "SELECT UserID, UserName, Role, 'Online' as Status " &
        "FROM register " &
        "WHERE last_seen >= NOW() - INTERVAL 5 MINUTE AND Role <> 'Admin'"

        BindGrid(query, gvUsers)
    End Sub

    Private Sub LoadStats()
        Using conn As New MySqlConnection(connStr)
            conn.Open()

            ' Count Pending Resources
            Using cmd As New MySqlCommand("SELECT COUNT(*) FROM reviewers WHERE is_approved = FALSE", conn)
                lblPendingCount.Text = cmd.ExecuteScalar().ToString()
            End Using

            ' Count Flagged Chats
            Using cmd As New MySqlCommand("SELECT COUNT(*) FROM messages WHERE is_flagged = 1", conn)
                lblChatCount.Text = cmd.ExecuteScalar().ToString()
            End Using

            ' Count Active Users
            Using cmd As New MySqlCommand("SELECT COUNT(*) FROM register WHERE last_seen >= NOW() - INTERVAL 5 MINUTE", conn)
                lblActiveUsers.Text = cmd.ExecuteScalar().ToString()
            End Using

            ' BAGONG STAT: Count Buddy Board Reports
            Using cmd As New MySqlCommand("SELECT COUNT(*) FROM post_reports WHERE Status = 'Pending'", conn)
                ' Siguraduhin na may Label ID="lblReportCount" ka sa ASPX
                If lblReportCount IsNot Nothing Then
                    lblReportCount.Text = cmd.ExecuteScalar().ToString()
                End If
            End Using
        End Using
    End Sub

    ' GRID BINDER

    Private Sub BindGrid(query As String, grid As GridView)
        If grid Is Nothing Then Return
        Try
            Using conn As New MySqlConnection(connStr)
                Using cmd As New MySqlCommand(query, conn)
                    Using da As New MySqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        da.Fill(dt)
                        grid.DataSource = dt
                        grid.DataBind()
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Trace.Warn("AdminDashboard", ex.Message)
        End Try
    End Sub

    Protected Sub gvResources_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvResources.RowCommand
        If e.CommandName = "Approve" OrElse e.CommandName = "Reject" Then
            Dim resourceID As Integer = Convert.ToInt32(e.CommandArgument)

            Using conn As New MySqlConnection(connStr)
                Dim sql As String = ""

                If e.CommandName = "Approve" Then
                    sql = "UPDATE reviewers SET is_approved = 1 WHERE id = @id"
                Else
                    sql = "DELETE FROM reviewers WHERE id = @id"
                End If

                Dim cmd As New MySqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@id", resourceID)

                conn.Open()
                cmd.ExecuteNonQuery()
                conn.Close()
            End Using

            LoadPendingResources()
            LoadStats()
        End If
    End Sub

    Private Sub UpdateStatus(id As String, approved As Boolean)
        Using conn As New MySqlConnection(connStr)

            Dim sql As String = "UPDATE reviewers SET is_approved = @status WHERE id = @id"
            Using cmd As New MySqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@status", If(approved, 1, 0))
                cmd.Parameters.AddWithValue("@id", id)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        LoadPendingResources()
    End Sub

End Class
