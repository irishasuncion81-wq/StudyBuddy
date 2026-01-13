Public Class Site_Mobile
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Kunin ang data mula sa Session (dapat tugma ito sa login logic mo)
            If Session("UserName") IsNot Nothing Then
                lblMobUsername.Text = Session("UserName").ToString()
            End If

            If Session("UserRole") IsNot Nothing Then
                lblMobRole.Text = Session("UserRole").ToString()
            End If

            ' Kung may profile picture logic ka sa Site.Master, kopyahin din dito:
            ' If Session("ProfilePic") IsNot Nothing Then
            '    imgMobProfile.ImageUrl = Session("ProfilePic").ToString()
            ' End If
        End If
    End Sub

    Protected Sub btnLogout_Click(ByVal sender As Object, ByVal e As EventArgs)
        Session.Clear()
        Session.Abandon()
        Response.Redirect("~/Login.aspx")
    End Sub
End Class