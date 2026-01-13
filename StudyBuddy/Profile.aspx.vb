Imports MySql.Data.MySqlClient
Imports System.IO

Public Class Profile
    Inherits System.Web.UI.Page

    Dim connStr As String = "server=localhost;user id=root;password=;database=study_buddy"

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("Username") Is Nothing Then Response.Redirect("Default.aspx")

        If Not IsPostBack Then
            Dim targetUser As String = Request.QueryString("ViewUser")
            Dim currentUsername As String = Session("Username").ToString()

            If String.IsNullOrEmpty(targetUser) OrElse targetUser = currentUsername Then

                LoadProfile(currentUsername)
                pnlUpload.Visible = True
                btnEdit.Visible = True
                lnkBack.Visible = False
                btnUnbuddy.Visible = False
                LoadSideBuddies(currentUsername)
            Else

                LoadProfile(targetUser)
                pnlUpload.Visible = False
                btnEdit.Visible = False
                lnkBack.Visible = True

                Try
                    Dim currentUserId As Integer = CInt(Session("UserID"))
                    Dim targetUserId As Integer = GetUserIdFromUserName(targetUser)

                    If CheckIfBuddies(currentUserId, targetUserId) Then
                        btnUnbuddy.Visible = True
                    Else
                        btnUnbuddy.Visible = False
                    End If
                Catch ex As Exception
                    btnUnbuddy.Visible = False
                End Try

                LoadSideBuddies(targetUser)
            End If
        End If
    End Sub

    Private Function GetUserIdFromUserName(un As String) As Integer
        Dim id As Integer = 0
        Using conn As New MySqlConnection(connStr)
            Dim q As String = "SELECT UserID FROM register WHERE UserName = @un"
            Dim cmd As New MySqlCommand(q, conn)
            cmd.Parameters.AddWithValue("@un", un)
            conn.Open()
            Dim result = cmd.ExecuteScalar()
            If result IsNot Nothing Then id = CInt(result)
        End Using
        Return id
    End Function

    Private Function CheckIfBuddies(current As Integer, target As Integer) As Boolean
        Dim isBuddy As Boolean = False
        Using conn As New MySqlConnection(connStr)
            Dim q As String = "SELECT COUNT(*) FROM friendrequests 
                               WHERE Status = 'Accepted' AND 
                               ((FromUserID = @C AND ToUserID = @T) OR (FromUserID = @T AND ToUserID = @C))"
            Dim cmd As New MySqlCommand(q, conn)
            cmd.Parameters.AddWithValue("@C", current)
            cmd.Parameters.AddWithValue("@T", target)
            conn.Open()
            isBuddy = CInt(cmd.ExecuteScalar()) > 0
        End Using
        Return isBuddy
    End Function

    Protected Sub btnUnbuddy_Click(sender As Object, e As EventArgs)
        Dim targetUserName As String = Request.QueryString("ViewUser")
        Dim currentUserId As Integer = CInt(Session("UserID"))

        Using conn As New MySqlConnection(connStr)
            conn.Open()
            Dim q As String = "DELETE FROM friendrequests 
                               WHERE (FromUserID = @Current AND ToUserID = (SELECT UserID FROM register WHERE UserName = @Target)) 
                               OR (FromUserID = (SELECT UserID FROM register WHERE UserName = @Target) AND ToUserID = @Current)"
            Using cmd As New MySqlCommand(q, conn)
                cmd.Parameters.AddWithValue("@Current", currentUserId)
                cmd.Parameters.AddWithValue("@Target", targetUserName)
                cmd.ExecuteNonQuery()
            End Using
        End Using
        Response.Redirect(Request.RawUrl)
    End Sub

    Private Sub LoadProfile(userName As String)
        Using conn As New MySqlConnection(connStr)
            Try
                conn.Open()
                ' LOAD BASIC INFO & PROFILE PICTURE

                Dim query As String = "SELECT UserID, FirstName, MiddleName, LastName, Sex, Email, Role, ProfilePicture FROM register WHERE UserName=@User"
                Dim targetUserId As Integer = 0

                Using cmd As New MySqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@User", userName)
                    Using dr = cmd.ExecuteReader()
                        If dr.Read() Then
                            targetUserId = CInt(dr("UserID"))
                            txtFirstName.Text = dr("FirstName").ToString()
                            txtMiddleName.Text = dr("MiddleName").ToString()
                            txtLastName.Text = dr("LastName").ToString()

                            Dim dbSexValue As String = dr("Sex").ToString()
                            If ddlSex.Items.FindByValue(dbSexValue) IsNot Nothing Then
                                ddlSex.SelectedValue = dbSexValue
                            End If

                            txtEmail.Text = dr("Email").ToString()
                            lblFullName.Text = dr("FirstName").ToString() & " " & dr("LastName").ToString()
                            lblRole.Text = dr("Role").ToString()

                            Dim pic = dr("ProfilePicture").ToString()
                            imgProfile.ImageUrl = If(pic <> "", "~/Uploads/" & pic, "~/Images/default-profile.png")
                        End If
                    End Using
                End Using

                ' STATS: COUNT BUDDIES (Target User's Count)

                Dim buddyCountQuery As String = "SELECT COUNT(*) FROM friendrequests WHERE (FromUserID = @UID OR ToUserID = @UID) AND Status='Accepted'"
                Using cmdBuddyCount As New MySqlCommand(buddyCountQuery, conn)
                    cmdBuddyCount.Parameters.AddWithValue("@UID", targetUserId)
                    lblBuddyCount.Text = cmdBuddyCount.ExecuteScalar().ToString()
                End Using

                ' STATS: COUNT UPLOADED REVIEWERS
                Dim reviewerQuery As String = "SELECT COUNT(*) FROM reviewers WHERE uploaded_by=@User"
                Using cmdRevCount As New MySqlCommand(reviewerQuery, conn)
                    cmdRevCount.Parameters.AddWithValue("@User", userName)
                    lblReviewerCount.Text = cmdRevCount.ExecuteScalar().ToString()
                End Using


                ' LOAD BIO
                Dim bioQuery As String = "SELECT Bio FROM userbio WHERE UserName=@User"
                Using cmdBio As New MySqlCommand(bioQuery, conn)
                    cmdBio.Parameters.AddWithValue("@User", userName)
                    Dim bioValue = cmdBio.ExecuteScalar()
                    txtBio.Text = If(bioValue Is Nothing, "", bioValue.ToString())
                End Using


                ' LOAD BUDDY LIST 

                Dim listQuery As String = "
                SELECT r.FirstName, r.LastName, r.Role, r.ProfilePicture, r.UserName,
                       CONCAT(r.FirstName, ' ', r.LastName) AS FullName
                FROM register r
                INNER JOIN friendrequests f ON (f.FromUserID = r.UserID OR f.ToUserID = r.UserID)
                WHERE ((f.FromUserID = @UID AND f.ToUserID <> @UID) 
                   OR (f.ToUserID = @UID AND f.FromUserID <> @UID))
                AND f.Status = 'Accepted' 
                AND r.UserID <> @UID"

                Using cmdList As New MySqlCommand(listQuery, conn)
                    cmdList.Parameters.AddWithValue("@UID", targetUserId)
                    Dim dt As New DataTable()
                    Using rdr = cmdList.ExecuteReader()
                        dt.Load(rdr)
                    End Using

                    rptBuddies.DataSource = dt
                    rptBuddies.DataBind()
                End Using

            Catch ex As Exception

                Response.Write("<script>alert('Error: " & ex.Message.Replace("'", "") & "');</script>")
            End Try
        End Using
    End Sub

    Private Sub LoadSideBuddies(userName As String)
        Using conn As New MySqlConnection(connStr)

            Dim q As String = "
            SELECT r.UserName, r.FirstName, r.LastName, 
                   CONCAT(r.FirstName, ' ', r.LastName) as FullName, 
                   r.Role, r.ProfilePicture
            FROM register r
            JOIN friendrequests f ON (f.FromUserID = (SELECT UserID FROM register WHERE UserName=@Target) AND f.ToUserID = r.UserID)
                                  OR (f.ToUserID = (SELECT UserID FROM register WHERE UserName=@Target) AND f.FromUserID = r.UserID)
            WHERE f.Status = 'Accepted' AND r.UserName <> @Target"

            Dim cmd As New MySqlCommand(q, conn)
            cmd.Parameters.AddWithValue("@Target", userName)
            conn.Open()

            Dim dt As New DataTable()
            dt.Load(cmd.ExecuteReader())
            rptBuddies.DataSource = dt
            rptBuddies.DataBind()
        End Using
    End Sub
    Protected Sub btnEdit_Click(sender As Object, e As EventArgs)
        txtBio.ReadOnly = False
        ddlSex.Enabled = True
        btnSave.Visible = True
        btnEdit.Visible = False
        txtBio.Focus()
    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs)
        Using conn As New MySqlConnection(connStr)

            conn.Open()

            ' 1. Update Bio
            Dim bioQuery As String = "INSERT INTO userbio (UserName, Bio) VALUES (@Username, @Bio) ON DUPLICATE KEY UPDATE Bio=@Bio"
            Using cmdBio As New MySqlCommand(bioQuery, conn)
                cmdBio.Parameters.AddWithValue("@Username", Session("Username").ToString())
                cmdBio.Parameters.AddWithValue("@Bio", txtBio.Text)
                cmdBio.ExecuteNonQuery()
            End Using

            ' 2. Update Sex sa register table
            Dim sexQuery As String = "UPDATE register SET Sex=@Sex WHERE UserName=@Username"
            Using cmdSex As New MySqlCommand(sexQuery, conn)
                cmdSex.Parameters.AddWithValue("@Sex", ddlSex.SelectedValue)
                cmdSex.Parameters.AddWithValue("@Username", Session("Username").ToString())
                cmdSex.ExecuteNonQuery()
            End Using
        End Using

        txtBio.ReadOnly = True
        ddlSex.Enabled = False
        btnSave.Visible = False
        btnEdit.Visible = True

        ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Profile updated successfully!');", True)
    End Sub

    Protected Sub btnUploadPic_Click(sender As Object, e As EventArgs)
        If fileUploadPic.HasFile Then
            Try
                Dim folderPath As String = Server.MapPath("~/Uploads/")
                If Not Directory.Exists(folderPath) Then
                    Directory.CreateDirectory(folderPath)
                End If


                Dim ext As String = Path.GetExtension(fileUploadPic.FileName)
                Dim fileName As String = Session("Username").ToString() & "_profile" & ext
                fileUploadPic.SaveAs(folderPath & fileName)

                Using conn As New MySqlConnection(connStr)
                    Dim sql As String = "UPDATE register SET ProfilePicture=@Pic WHERE UserName=@Username"
                    Dim cmd As New MySqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@Pic", fileName)
                    cmd.Parameters.AddWithValue("@Username", Session("Username").ToString())
                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using


                imgProfile.ImageUrl = "~/Uploads/" & fileName & "?t=" & DateTime.Now.Ticks.ToString()
                ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Profile picture updated!');", True)

            Catch ex As Exception
                ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Error: " & ex.Message.Replace("'", "") & "');", True)
            End Try
        Else
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Please select a file first.');", True)
        End If
    End Sub
End Class
