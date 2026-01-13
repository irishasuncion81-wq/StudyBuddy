Imports Microsoft.AspNet.SignalR

Public Class Signal
    Inherits Hub

    Public Sub Hello()
        Clients.All.Hello()
    End Sub
End Class
