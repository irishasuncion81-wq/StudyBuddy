Imports MySql.Data.MySqlClient
Imports System.Configuration
Imports System.IO
Imports System.Data

Public Class Resources
    Inherits System.Web.UI.Page

    Protected connStr As String = "server=localhost;user id=root;password=;database=study_buddy"
    Dim conn As New MySqlConnection(connStr)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("username") Is Nothing Then
            Response.Redirect("Login.aspx")
            Exit Sub
        End If

        If Not IsPostBack Then
            Dim selectedSubject As String = Request.QueryString("subject")

            If Not String.IsNullOrEmpty(selectedSubject) Then
                LoadReviewers(subjectFilter:=selectedSubject)
            Else
                LoadReviewers()
            End If
        End If
    End Sub
    Private Sub LoadReviewers(Optional subjectFilter As String = "", Optional searchKeyword As String = "")
        Dim query As String = "SELECT r.filename, r.Subject, r.Subject_Teacher, r.upload_date, r.uploaded_by, " &
                         "IFNULL(AVG(rt.rating_value), 0) as AvgRating, " &
                         "COUNT(rt.rating_id) as TotalRaters " &
                         "FROM reviewers r " &
                         "LEFT JOIN reviewer_ratings rt ON r.filename = rt.filename " &
                         "WHERE r.is_approved = TRUE "

        If Not String.IsNullOrEmpty(subjectFilter) Then
            query &= " AND r.Subject = @subject "
        End If

        If Not String.IsNullOrEmpty(searchKeyword) Then
            query &= " AND (r.filename LIKE @kw OR r.Subject LIKE @kw OR r.Subject_Teacher LIKE @kw OR r.uploaded_by LIKE @kw) "
        End If

        query &= " GROUP BY r.filename, r.Subject, r.Subject_Teacher, r.upload_date, r.uploaded_by "
        query &= " ORDER BY r.upload_date DESC"

        Try
            Using cmd As New MySqlCommand(query, conn)
                If Not String.IsNullOrEmpty(subjectFilter) Then
                    cmd.Parameters.AddWithValue("@subject", subjectFilter)
                End If

                If Not String.IsNullOrEmpty(searchKeyword) Then
                    cmd.Parameters.AddWithValue("@kw", "%" & searchKeyword & "%")
                End If

                Dim dt As New DataTable()
                Using da As New MySqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using

                gvReviewers.DataSource = dt
                gvReviewers.DataBind()
            End Using
        Catch ex As Exception
            lblStatus.Text = "Error loading data: " & ex.Message
            lblStatus.ForeColor = Drawing.Color.Red
        End Try
    End Sub

    Protected Sub FilterBySubject(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As LinkButton = CType(sender, LinkButton)
        Dim subjectCode As String = btn.CommandArgument

        LoadReviewers(subjectFilter:=subjectCode)

        Response.Redirect("Resources.aspx?subject=" & subjectCode)
    End Sub

    Private Sub LoadFilteredResources(subjectName As String)
        Dim query As String = "SELECT * FROM reviewers WHERE Subject = @subject AND is_approved = 1"

        Using conn As New MySqlConnection(connStr)
            Using cmd As New MySqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@subject", subjectName)
            End Using
        End Using

    End Sub

    ' SEARCH BUTTON CLICK
    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim keyword As String = txtSearch.Text.Trim()
        LoadReviewers(searchKeyword:=keyword)
    End Sub

    ' UPLOAD FUNCTION
    Protected Sub btnUpload_Click(ByVal sender As Object, ByVal e As EventArgs)
        If fileReviewer.HasFile Then
            Try

                Dim fileExt As String = Path.GetExtension(fileReviewer.FileName).ToLower()
                If fileExt <> ".pdf" Then
                    lblStatus.Text = "❌ Only PDF files are allowed!"
                    lblStatus.ForeColor = Drawing.Color.Red
                    Exit Sub
                End If

                Dim maxFileSize As Integer = 5242880
                If fileReviewer.PostedFile.ContentLength > maxFileSize Then
                    lblStatus.Text = "File too large! Maximum limit is 5MB."
                    lblStatus.ForeColor = Drawing.Color.Red
                    Exit Sub
                End If

                ' END OF VALIDATION

                Dim fileName As String = Path.GetFileName(fileReviewer.FileName)
                Dim savePath As String = Server.MapPath("~/Uploads/" & fileName)

                Dim dirPath As String = Server.MapPath("~/Uploads/")
                If Not Directory.Exists(dirPath) Then
                    Directory.CreateDirectory(dirPath)
                End If

                fileReviewer.SaveAs(savePath)

                Dim uploader As String = Session("username").ToString()
                Dim subject As String = ddlSubject.SelectedValue
                Dim teacher As String = ddlTeacher.SelectedValue

                If subject = "" Or teacher = "" Then
                    lblStatus.Text = "⚠️ Please select both subject and teacher."
                    lblStatus.ForeColor = Drawing.Color.Orange
                    Exit Sub
                End If

                Dim query As String = "INSERT INTO reviewers (filename, Subject, Subject_Teacher, upload_date, uploaded_by, is_approved) " &
                                 "VALUES (@filename, @Subject, @Teacher, NOW(), @uploaded_by, FALSE)"

                Using cmd As New MySqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@filename", fileName)
                    cmd.Parameters.AddWithValue("@Subject", subject)
                    cmd.Parameters.AddWithValue("@Teacher", teacher)
                    cmd.Parameters.AddWithValue("@uploaded_by", uploader)

                    conn.Open()
                    cmd.ExecuteNonQuery()
                    conn.Close()
                End Using

                lblStatus.Text = "✅ Reviewer uploaded successfully! Awaiting admin approval."
                lblStatus.ForeColor = Drawing.Color.Green
                txtSearch.Text = ""
                LoadReviewers()

            Catch ex As Exception
                lblStatus.Text = "❌ Upload failed: " & ex.Message
                lblStatus.ForeColor = Drawing.Color.Red
                If conn.State = ConnectionState.Open Then conn.Close()
            End Try
        Else
            lblStatus.Text = "⚠️ Please select a file to upload."
            lblStatus.ForeColor = Drawing.Color.Orange
        End If
    End Sub

    ' VIEW FILE
    Protected Sub btnView_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim fileName As String = btn.CommandArgument
        Dim filePath As String = Server.MapPath("~/Uploads/" & fileName)

        If File.Exists(filePath) Then
            Response.Clear()
            Response.ContentType = "application/pdf"

            Response.AddHeader("Content-Disposition", "inline; filename=" & fileName)

            Response.TransmitFile(filePath)
            Response.Flush()
            Response.End()
        Else
            lblStatus.Text = "File not found on server."
            lblStatus.ForeColor = Drawing.Color.Red
        End If
    End Sub

    ' DOWNLOAD FILE
    Protected Sub btnDownload_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim fileName As String = btn.CommandArgument
        Dim filePath As String = Server.MapPath("~/Uploads/" & fileName)

        If File.Exists(filePath) Then
            Response.Clear()
            Response.ContentType = "application/octet-stream"
            Response.AddHeader("Content-Disposition", "attachment; filename=" & fileName)
            Response.TransmitFile(filePath)
            Response.End()
        Else
            lblStatus.Text = "❌ File not found on server."
        End If
    End Sub

    ' DELETE FILE 
    Protected Sub btnDelete_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim fileName As String = btn.CommandArgument
        Dim filePath As String = Server.MapPath("~/Uploads/" & fileName)
        Dim currentUser As String = Session("username").ToString()

        Dim query As String = "DELETE FROM reviewers WHERE filename = @filename AND uploaded_by = @uploaded_by"

        Using cmd As New MySqlCommand(query, conn)
            cmd.Parameters.AddWithValue("@filename", fileName)
            cmd.Parameters.AddWithValue("@uploaded_by", currentUser)

            conn.Open()
            Dim rowsAffected As Integer = cmd.ExecuteNonQuery()
            conn.Close()

            If rowsAffected > 0 Then
                If File.Exists(filePath) Then
                    File.Delete(filePath)
                End If
                lblStatus.Text = "File deleted successfully."
            Else
                lblStatus.Text = "You are not allowed to delete this file or it doesn't exist."
            End If
        End Using

        LoadReviewers()
    End Sub

    Protected Sub rblStars_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim rbl = DirectCast(sender, RadioButtonList)
        Dim selectedValue As String = rbl.SelectedValue
        Dim row As GridViewRow = CType(rbl.NamingContainer, GridViewRow)

        Dim btnView As Button = CType(row.FindControl("btnView"), Button)
        Dim fileName As String = btnView.CommandArgument
        Dim ratingValue As String = rbl.SelectedValue
        Dim currentUser As String = Session("username").ToString()

        Try
            Dim query As String = "REPLACE INTO reviewer_ratings (filename, username, rating_value) VALUES (@file, @user, @val)"

            Using cmd As New MySqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@file", fileName)
                cmd.Parameters.AddWithValue("@user", currentUser)
                cmd.Parameters.AddWithValue("@val", ratingValue)
                conn.Open()
                cmd.ExecuteNonQuery()
                conn.Close()
            End Using

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Pop", "showThankYou();", True)

            LoadReviewers()

        Catch ex As Exception
            If conn.State = ConnectionState.Open Then conn.Close()
        End Try
    End Sub

    Protected Sub gvReviewers_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs) Handles gvReviewers.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim rbl As RadioButtonList = CType(e.Row.FindControl("rblStars"), RadioButtonList)
            Dim fileName As String = DataBinder.Eval(e.Row.DataItem, "filename").ToString()
            Dim currentUser As String = Session("username").ToString()

            Dim userRating As Integer = GetUserSpecificRating(fileName, currentUser)

            If userRating > 0 Then
                rbl.SelectedValue = userRating.ToString()
            End If
        End If
    End Sub

    Private Function GetUserSpecificRating(file As String, user As String) As Integer
        Dim rate As Integer = 0
        Dim query As String = "SELECT rating_value FROM reviewer_ratings WHERE filename = @f AND username = @u"
        Using cmd As New MySqlCommand(query, conn)
            cmd.Parameters.AddWithValue("@f", file)
            cmd.Parameters.AddWithValue("@u", user)
            conn.Open()
            Dim result = cmd.ExecuteScalar()
            If result IsNot Nothing Then rate = Convert.ToInt32(result)
            conn.Close()
        End Using
        Return rate
    End Function



End Class
