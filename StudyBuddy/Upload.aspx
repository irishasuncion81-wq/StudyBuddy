<%@ Page Title="Resources" Language="vb" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Resources.aspx.vb" Inherits="StudyBuddy.Resources" %>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="main-content">
        <div class="dashboard-container">

    <!-- 📚 Resources Page Content -->
    <h2>📚 Resources</h2>
    <p>Here you can find shared reviewers, study guides, and helpful materials.</p>

    <!-- Optional: Upload Form -->
    <asp:FileUpload ID="fuReviewer" runat="server" />
    <asp:Button ID="btnUpload" runat="server" Text="Upload Reviewer" OnClick="btnUpload_Click" />
    <asp:Label ID="lblStatus" runat="server" CssClass="upload-status" />
        </div>
    </div>
</asp:Content>