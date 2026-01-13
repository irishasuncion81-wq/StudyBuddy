Imports MySql.Data.MySqlClient
Imports System.Data.SqlClient
Imports System.Configuration

Public Class AddFriend
    Inherits System.Web.UI.Page
    Dim connStr As String = ConfigurationManager.ConnectionStrings("StudyBuddyDB").ConnectionString
    Dim conn As New MySqlConnection(connStr)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

End Class