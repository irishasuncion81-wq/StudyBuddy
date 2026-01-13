Imports MySql.Data.MySqlClient
Imports System.Text.RegularExpressions

Partial Class Register
    Inherits System.Web.UI.Page

    ' ADDED: connection string
    Dim connStr As String = "server=localhost;user id=root;password=;database=study_buddy"

    Protected Sub btnTogglePassword_Click(sender As Object, e As EventArgs)
        If txtPassword.TextMode = TextBoxMode.Password Then
            txtPassword.TextMode = TextBoxMode.SingleLine
        Else
            txtPassword.TextMode = TextBoxMode.Password
        End If

        txtPassword.Attributes("value") = txtPassword.Text
    End Sub

    Protected Sub btnToggleConfirm_Click(sender As Object, e As EventArgs)
        If txtConfirmPassword.TextMode = TextBoxMode.Password Then
            txtConfirmPassword.TextMode = TextBoxMode.SingleLine
        Else
            txtConfirmPassword.TextMode = TextBoxMode.Password
        End If

        txtConfirmPassword.Attributes("value") = txtConfirmPassword.Text
    End Sub

    Protected Sub txtConfirmPassword_TextChanged(sender As Object, e As EventArgs)
        ' Keep password values after postback
        txtPassword.Attributes("value") = txtPassword.Text
        txtConfirmPassword.Attributes("value") = txtConfirmPassword.Text

        ' Show security questions
        Questions.Visible = True
    End Sub

    Protected Sub btnRegister_Click(sender As Object, e As EventArgs)

        ' ===== ADDED: GET VALUES =====
        Dim firstname As String = txtFirstName.Text.Trim()
        Dim middlename As String = txtMiddleName.Text.Trim()
        Dim lastname As String = txtLastName.Text.Trim()
        Dim email As String = txtEmail.Text.Trim()
        Dim username As String = txtUsername.Text.Trim()
        Dim password As String = txtPassword.Text.Trim()
        Dim confirmPassword As String = txtConfirmPassword.Text.Trim()
        Dim sex As String = txtSex.SelectedValue
        Dim roleValue As String = Role.SelectedValue
        Dim q1 As String = txtQ1.Text.Trim()
        Dim q2 As String = txtQ2.Text.Trim()
        Dim q3 As String = txtQ3.Text.Trim()

        ' Keep password values
        txtPassword.Attributes("value") = txtPassword.Text
        txtConfirmPassword.Attributes("value") = txtConfirmPassword.Text

        ' ===== ADDED: VALIDATION =====
        If firstname = "" Or middlename = "" Or lastname = "" Or email = "" Or
           username = "" Or password = "" Or confirmPassword = "" Or
           sex = "" Or roleValue = "" Or q1 = "" Or q2 = "" Or q3 = "" Then

            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
                "alert('Please fill in all required fields.');", True)
            Exit Sub
        End If

        If Not Regex.IsMatch(email, "^[^@\s]+@[^@\s]+\.[^@\s]+$") Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
                "alert('Invalid email address.');", True)
            Exit Sub
        End If

        If password <> confirmPassword Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
                "alert('Passwords do not match.');", True)
            Exit Sub
        End If

        Dim passPattern As String = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$"
        If Not Regex.IsMatch(password, passPattern) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
                "alert('Password does not meet requirements.');", True)
            Exit Sub
        End If


        Using conn As New MySqlConnection(connStr)
            conn.Open()

            Dim checkQuery As String = "SELECT COUNT(*) FROM register WHERE Username=@Username"
            Using checkCmd As New MySqlCommand(checkQuery, conn)
                checkCmd.Parameters.AddWithValue("@Username", username)
                Dim count As Integer = Convert.ToInt32(checkCmd.ExecuteScalar())
                If count > 0 Then
                    ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Username already taken. Choose another.');", True)
                    Exit Sub
                End If
            End Using

            Dim query As String =
                "INSERT INTO register 
                (FirstName, MiddleName, LastName, Email, Username, Password, ConfirmPassword, Q1, Q2, Q3, Sex, Role)
                VALUES
                (@FirstName,@MiddleName,@LastName,@Email,@Username,@Password,@ConfirmPassword, @Q1,@Q2,@Q3,@Sex,@Role)"

            Using cmd As New MySqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@FirstName", firstname)
                cmd.Parameters.AddWithValue("@MiddleName", middlename)
                cmd.Parameters.AddWithValue("@LastName", lastname)
                cmd.Parameters.AddWithValue("@Email", email)
                cmd.Parameters.AddWithValue("@Username", username)
                cmd.Parameters.AddWithValue("@Password", password)
                cmd.Parameters.AddWithValue("@ConfirmPassword", confirmPassword)
                cmd.Parameters.AddWithValue("@Q1", q1)
                cmd.Parameters.AddWithValue("@Q2", q2)
                cmd.Parameters.AddWithValue("@Q3", q3)
                cmd.Parameters.AddWithValue("@Sex", sex)
                cmd.Parameters.AddWithValue("@Role", roleValue)

                cmd.ExecuteNonQuery()
            End Using
        End Using


        ClientScript.RegisterStartupScript(Me.GetType(), "alert",
            "alert('Registration successful!'); window.location='Login.aspx';", True)

    End Sub
End Class

