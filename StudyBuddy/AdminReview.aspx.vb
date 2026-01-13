Imports MySql.Data.MySqlClient
Imports System.IO

Public Class AdminReview
    Inherits System.Web.UI.Page

    Dim connStr As String = "server=localhost;user id=root;password=;database=study_buddy"
    Dim conn As New MySqlConnection(connStr)
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        'ADMIN CHECK
        If Session("role") Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Exit Sub
        End If

        If Session("role").ToString().ToLower() <> "admin" Then
            Response.Redirect("~/AccessDenied.aspx")
            Exit Sub
        End If

        If Not IsPostBack Then
            LoadPendingReviewers()
        End If

    End Sub

    Private Sub LoadPendingReviewers()
        Dim query As String = "SELECT id, filename, Subject, Subject_Teacher, upload_date, uploaded_by FROM reviewers WHERE is_approved = FALSE"
        Dim cmd As New MySqlCommand(query, conn)
        Dim dt As New DataTable()
        Dim da As New MySqlDataAdapter(cmd)

        conn.Open()
        da.Fill(dt)
        conn.Close()

        gvPending.DataSource = dt
        gvPending.DataBind()
    End Sub

    Protected Sub btnApprove_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim reviewerId As Integer = Convert.ToInt32(btn.CommandArgument)

        Dim query As String = "UPDATE reviewers SET is_approved = TRUE WHERE id = @id"
        Dim cmd As New MySqlCommand(query, conn)
        cmd.Parameters.AddWithValue("@id", reviewerId)

        conn.Open()
        cmd.ExecuteNonQuery()
        conn.Close()

        lblStatus.Text = "✅ Reviewer approved!"
        LoadPendingReviewers()
    End Sub

    Protected Sub btnReject_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim reviewerId As Integer = Convert.ToInt32(btn.CommandArgument)

        ' Get filename first
        Dim getFileQuery As String = "SELECT filename FROM reviewers WHERE id = @id"
        Dim getFileCmd As New MySqlCommand(getFileQuery, conn)
        getFileCmd.Parameters.AddWithValue("@id", reviewerId)

        conn.Open()
        Dim fileName As String = Convert.ToString(getFileCmd.ExecuteScalar())
        conn.Close()

        ' Delete file from server
        Dim filePath As String = Server.MapPath("~/Uploads/" & fileName)
        If File.Exists(filePath) Then
            File.Delete(filePath)
        End If

        ' Delete from database
        Dim deleteQuery As String = "DELETE FROM reviewers WHERE id = @id"
        Dim deleteCmd As New MySqlCommand(deleteQuery, conn)
        deleteCmd.Parameters.AddWithValue("@id", reviewerId)

        conn.Open()
        deleteCmd.ExecuteNonQuery()
        conn.Close()

        lblStatus.Text = "❌ Reviewer rejected and deleted."
        LoadPendingReviewers()
    End Sub
End Class