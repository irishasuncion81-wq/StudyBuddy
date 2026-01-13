Imports MySql.Data.MySqlClient

Partial Class Login
    Inherits System.Web.UI.Page

    Protected connStr As String = "server=localhost;user id=root;password=;database=study_buddy"

    Protected Sub btnLogin_Click(sender As Object, e As EventArgs) Handles btnLogin.Click
        Dim username As String = txtUsername.Text.Trim()
        Dim password As String = txtPassword.Text.Trim()

        If username = "" Or password = "" Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Please enter both username and password.');", True)
            Exit Sub
        End If

        ' Isinama natin ang 'status' sa query base sa database screenshot mo
        Dim query As String = "SELECT UserID, FirstName, LastName, Email, UserName, Role, status, ban_until FROM register WHERE UserName = @UserName AND Password = @Password"

        Using conn As New MySqlConnection(connStr)
            Try
                conn.Open()
                Using cmd As New MySqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@UserName", username)
                    cmd.Parameters.AddWithValue("@Password", password)

                    Using reader As MySqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then

                            ' 1. CHECK PERMANENT BAN (Base sa 'status' column)
                            If reader("status").ToString() = "Banned" Then
                                ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Your account is permanently banned.');", True)
                                Exit Sub
                            End If

                            ' 2. CHECK TEMPORARY BAN (Base sa 'ban_until' column)
                            If reader("ban_until") IsNot DBNull.Value Then
                                Dim banUntil As DateTime = Convert.ToDateTime(reader("ban_until"))
                                If banUntil > DateTime.Now Then
                                    Dim remainingTime = banUntil - DateTime.Now
                                    Dim errorMsg As String = $"Restricted until {banUntil:MM/dd/yyyy h:mm tt}. Remaining: {remainingTime.Days}d {remainingTime.Hours}h {remainingTime.Minutes}m."
                                    ClientScript.RegisterStartupScript(Me.GetType(), "alert", $"alert('{errorMsg}');", True)
                                    Exit Sub
                                End If
                            End If

                            ' 3. SUCCESSFUL LOGIN
                            Session("UserID") = Convert.ToInt32(reader("UserID"))
                            Session("UserName") = reader("UserName").ToString()
                            Session("FullName") = reader("FirstName").ToString() & " " & reader("LastName").ToString()
                            Session("Role") = reader("Role").ToString()

                            ' UPDATE LAST SEEN (Para sa Online Status sa Dashboard)
                            UpdateLastSeen(reader("UserID").ToString())

                            If reader("Role").ToString() = "Admin" Then
                                Response.Redirect("AdminDashboard.aspx")
                            Else
                                Response.Redirect("BuddyBoard.aspx")
                            End If

                        Else
                            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Invalid username or password.');", True)
                        End If
                    End Using
                End Using
            Catch ex As Exception
                ClientScript.RegisterStartupScript(Me.GetType(), "alert", $"alert('Error: {ex.Message}');", True)
            End Try
        End Using
    End Sub

    ' Helper function para sa Online Status
    Private Sub UpdateLastSeen(userID As String)
        Using conn As New MySqlConnection(connStr)
            Dim sql As String = "UPDATE register SET last_seen = NOW() WHERE UserID = @uid"
            Dim cmd As New MySqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@uid", userID)
            conn.Open()
            cmd.ExecuteNonQuery()
        End Using
    End Sub
End Class