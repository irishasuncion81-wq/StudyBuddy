Imports MySql.Data.MySqlClient

Public Class SiteMaster
    Inherits MasterPage

    Dim connStr As String = "server=localhost;user id=root;password=;database=study_buddy"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("Username") IsNot Nothing Then
            Dim currentUser As String = Session("Username").ToString()

            ' Update last seen
            UpdateUserActivity(currentUser)

            ' Load profile details kapag hindi postback
            If Not IsPostBack Then
                LoadNavProfile(currentUser)
            End If
        End If
    End Sub

    Private Sub LoadNavProfile(username As String)
        Using conn As New MySqlConnection(connStr)
            ' Batay sa iyong structure: FirstName, LastName, Role, ProfilePicture
            Dim sql As String = "SELECT FirstName, LastName, Role, ProfilePicture FROM register WHERE UserName = @User"
            Dim cmd As New MySqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@User", username)

            Try
                conn.Open()
                Dim dr As MySqlDataReader = cmd.ExecuteReader()

                If dr.Read() Then
                    ' Pagsamahin ang First at Last Name
                    lblNavUsername.Text = dr("FirstName").ToString() & " " & dr("LastName").ToString()
                    lblNavRole.Text = dr("Role").ToString()

                    ' Profile Picture Logic
                    Dim picFileName As String = dr("ProfilePicture").ToString()
                    If Not String.IsNullOrEmpty(picFileName) Then
                        ' Siguraduhin na ang path ay tama base sa iyong project folder
                        imgNavProfile.ImageUrl = "~/uploads/" & picFileName
                    End If
                End If
            Catch ex As Exception
                ' Error handling (opsyonal)
            End Try
        End Using
    End Sub

    Private Sub UpdateUserActivity(username As String)
        Using conn As New MySqlConnection(connStr)
            Dim sql As String = "UPDATE register SET last_seen = NOW() WHERE UserName = @User"
            Dim cmd As New MySqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@User", username)
            conn.Open()
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Protected Sub btnLogout_Click(sender As Object, e As EventArgs)
        ' Clear all sessions
        Session.Clear()
        Session.Abandon()

        ' Redirect to login page
        Response.Redirect("Login.aspx")
    End Sub
End Class