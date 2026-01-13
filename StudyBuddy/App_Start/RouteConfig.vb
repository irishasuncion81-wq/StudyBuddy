Imports System.Web.Routing
Imports Microsoft.AspNet.FriendlyUrls

Public Module RouteConfig
    Sub RegisterRoutes(ByVal routes As RouteCollection)
        Dim settings As New FriendlyUrlSettings()

        ' Gamitin ang Permanent para siguradong walang error sa VS mo
        settings.AutoRedirectMode = RedirectMode.Permanent

        routes.EnableFriendlyUrls(settings)
    End Sub
End Module