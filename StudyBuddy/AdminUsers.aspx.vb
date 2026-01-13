Imports MySql.Data.MySqlClient
Imports System.Data

Public Class AdminUsersaspx
    Inherits System.Web.UI.Page

    Private ReadOnly connStr As String = "server=localhost;user id=root;password=;database=study_buddy"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadAllUsers()
        End If

        'everytime na nagre-refresh ang page, mag-uupdate ang last_seen ng admin
        If Session("UserID") IsNot Nothing Then
            Using conn As New MySqlConnection(connStr)
                Dim sql As String = "UPDATE register SET last_seen = NOW() WHERE UserID = @uid"
                Dim cmd As New MySqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@uid", Session("UserID"))
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End If
    End Sub
    Private Sub LoadAllUsers()
        ' Ipakita lahat, pero lagyan ng label if Online/Offline/Banned
        Dim query As String =
        "SELECT UserID, UserName, Role, " &
        "CASE " &
        "  WHEN status = 'Banned' THEN 'Banned' " &
        "  WHEN last_seen >= NOW() - INTERVAL 5 MINUTE THEN 'Online' " &
        "  ELSE 'Offline' " &
        "END AS Status " &
        "FROM register " &
        "WHERE Role <> 'Admin'"

        BindGrid(query, gvAllUsers)
    End Sub
    Private Sub BindGrid(query As String, grid As GridView)
        Try
            Using conn As New MySqlConnection(connStr)
                Using cmd As New MySqlCommand(query, conn)
                    Using da As New MySqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        conn.Open()
                        da.Fill(dt)
                        grid.DataSource = dt
                        grid.DataBind()
                    End Using
                End Using
            End Using
        Catch ex As Exception
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", $"alert('Error loading users: {ex.Message}');", True)
        End Try
    End Sub

    ' Button Click logic para sa Ban
    Protected Sub gvAllUsers_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvAllUsers.RowCommand
        If e.CommandName = "BanUser" Then
            Dim uid As String = e.CommandArgument.ToString()

            Using conn As New MySqlConnection(connStr)
                ' Papalitan ang status ng user na 'Banned'
                Dim sql As String = "UPDATE register SET status = 'Banned' WHERE UserID = @uid"
                Using cmd As New MySqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@uid", uid)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            LoadAllUsers()
        End If
    End Sub
End Class