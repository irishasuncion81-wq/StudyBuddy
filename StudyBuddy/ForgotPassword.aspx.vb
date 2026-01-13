Imports MySql.Data.MySqlClient

Public Class ForgotPassword
    Inherits System.Web.UI.Page

    ' Connection string - i-adjust ang database name kung kailangan (study_buddy)
    Dim connStr As String = "server=localhost;user=root;password=;database=study_buddy;"

    ' STEP 1: I-check kung existing ang Username
    Protected Sub btnFindUser_Click(sender As Object, e As EventArgs)
        Using conn As New MySqlConnection(connStr)
            ' Hahanapin ang UserName sa register table
            Dim query As String = "SELECT UserName FROM register WHERE UserName = @user"
            Dim cmd As New MySqlCommand(query, conn)
            cmd.Parameters.AddWithValue("@user", txtUsername.Text.Trim())

            conn.Open()
            Dim reader As MySqlDataReader = cmd.ExecuteReader()

            If reader.Read() Then
                ' Kung nahanap, ipakita ang security questions panel
                pnlStep1.Visible = False
                pnlStep2.Visible = True
            Else
                Response.Write("<script>alert('User not found!');</script>")
            End If
        End Using
    End Sub

    ' STEP 2: I-verify ang Q1, Q2, at Q3
    Protected Sub btnVerifyAnswers_Click(sender As Object, e As EventArgs)
        Using conn As New MySqlConnection(connStr)
            ' I-mismatch ang answers sa columns na Q1, Q2, at Q3 sa database
            Dim query As String = "SELECT COUNT(*) FROM register WHERE UserName = @user AND Q1 = @a1 AND Q2 = @a2 AND Q3 = @a3"
            Dim cmd As New MySqlCommand(query, conn)

            cmd.Parameters.AddWithValue("@user", txtUsername.Text.Trim())
            cmd.Parameters.AddWithValue("@a1", txtA1.Text.Trim()) ' Favorite Color
            cmd.Parameters.AddWithValue("@a2", txtA2.Text.Trim()) ' Favorite Game
            cmd.Parameters.AddWithValue("@a3", txtA3.Text.Trim()) ' Pet's Name

            conn.Open()
            Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())

            If count > 0 Then
                ' Tama lahat! Ipakita ang Password Reset panel
                pnlStep2.Visible = False
                pnlStep3.Visible = True
            Else
                ' Bonak logic prevention: Pag mali kahit isa, hindi makaka-proceed
                Response.Write("<script>alert('Incorrect answers to security questions!');</script>")
            End If
        End Using
    End Sub

    ' STEP 3: I-update ang Password
    Protected Sub btnReset_Click(sender As Object, e As EventArgs)
        If txtNewPassword.Text <> txtConfirmPassword.Text Then
            Response.Write("<script>alert('Passwords do not match!');</script>")
            Return
        End If

        Using conn As New MySqlConnection(connStr)
            ' I-update ang Password field para sa user na ito
            Dim query As String = "UPDATE register SET Password = @pass WHERE UserName = @user"
            Dim cmd As New MySqlCommand(query, conn)

            cmd.Parameters.AddWithValue("@pass", txtNewPassword.Text)
            cmd.Parameters.AddWithValue("@user", txtUsername.Text.Trim())

            conn.Open()
            Dim rowsAffected As Integer = cmd.ExecuteNonQuery()

            If rowsAffected > 0 Then
                Response.Write("<script>alert('Password updated! You can now login.'); window.location='Login.aspx';</script>")
            Else
                Response.Write("<script>alert('Error updating password.');</script>")
            End If
        End Using
    End Sub
End Class