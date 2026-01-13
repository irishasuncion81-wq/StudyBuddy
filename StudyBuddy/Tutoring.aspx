<%@ Page Title="Tutoring" MasterPageFile="~/Site.Master" Language="VB"
    AutoEventWireup="false" CodeBehind="Tutoring.aspx.vb" Inherits="StudyBuddy.Tutoring" %>


<asp:Content ID="MainContentSection" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <style>
        body { 
            background-image: url('bg1.jpg'); 
            background-attachment: fixed;
            background-size: cover;
            font-family: 'Segoe UI', sans-serif;
            color: #2e7d32; 
         }

        .page-title {
             font-size: 50px;
             font-family: "Comic Sans MS", cursive; 
             font-weight: bold;
             color: #1a3a32;
             margin: 0;
             padding: 0;
             letter-spacing: -1px;
         }

         .page-desc { 
             font-size: 18px;
             color: #4a5568; 
             margin-top: 10px;
             font-family: 'Segoe UI', sans-serif;
             opacity: 0.9;
         }

        .buddy-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }

        .user-card {
            background-color: #c8e6c9b0;
            border-radius: 20px;
            padding: 40px 20px;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            border: 1px solid #e2e8f0;
        }
        .profile-img {
            width: 100px;
            height: 100px;
            border-radius: 50%; 
            object-fit: cover;
            border: 2px solid #edf2f7;
            margin-bottom: 15px;
            display: block;
            margin-left: auto;
            margin-right: auto;
        }

        .user-card h3 { font-size: 20px; color: #1a365d; margin: 10px 0 5px; font-weight: 700; }
        .role-label { color: #a0aec0; font-size: 14px; display: block; margin-bottom: 25px; }

        .action-area {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px; 
        }

        .btn-buddy {
            padding: 10px 25px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none !important;
            border: none;
            cursor: pointer;
            display: inline-block;
        }

        .btn-add { background-color: #4fd1c5; color: white !important; }
        .btn-add:hover { background-color: #38b2ac; }

        .btn-cancel {
            color: #f56565 !important;
            font-size: 14px;
            font-weight: 600;
            background: none;
        }

        .status-sent {
            background-color: #edf2f7;
            color: #718096;
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 14px;
        }

        .header-wrapper {
            display: flex;
            justify-content: space-between; 
            align-items: center;
            margin-bottom: 30px;
            padding: 0 20px;
        }

        .search-wrapper {
            display: flex;
            align-items: center;
            background: #ffffff;
            padding: 5px 15px;
            border-radius: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            width: 350px; 
        }

        .search-input {
            border: none;
            outline: none;
            padding: 8px;
            font-size: 13px;
            width: 100%;
        }

        .btn-search-main {
            background-color: #4ecdc4; 
            color: white;
            border: none;
            padding: 6px 15px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
        }

        .btn-clear-main {
            background: none;
            border: none;
            color: #999;
            font-size: 12px;
            margin-left: 10px;
            cursor: pointer;
        }
    </style>

<div class="page-title">Find a Study Buddy</div>
<div class="page-desc">Click a card to view their full profile.</div>

    <div class="search-wrapper">
        <i class="fas fa-search" style="color: #ccc;"></i>
        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search username..."></asp:TextBox>
        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn-search-main" OnClick="btnSearch_Click" />
        <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn-clear-main" OnClick="btnClear_Click" />
    </div>

   <asp:UpdatePanel ID="updMain" runat="server">
        <ContentTemplate>
            <div class="buddy-grid">
                <asp:Repeater ID="rptUsers" runat="server">
                    <ItemTemplate>
                        <div class="user-card">
                            <a href='Profile.aspx?ViewUser=<%# Eval("UserName") %>' 
                               style="text-decoration: none; display: block; color: inherit;">
                            
                                <img src='<%# If(Eval("ProfilePicture") Is DBNull.Value OrElse Eval("ProfilePicture").ToString() = "", "Images/default-profile.png", "Uploads/" & Eval("ProfilePicture").ToString()) %>' 
                                     class="profile-img" />

                                <h3><%# Eval("FullName") %></h3>
                                <span class="role-label"><%# Eval("Role") %></span>
                            </a>

                            <div class="action-area">
                                <asp:PlaceHolder runat="server" Visible='<%# Eval("SentStatus") IsNot DBNull.Value AndAlso Eval("SentStatus").ToString() = "Pending" %>'>
                                    <span class="status-sent">Request Sent</span>
                                    <asp:LinkButton ID="btnCancel" runat="server" CssClass="btn-cancel" Text="Cancel" CommandArgument='<%# Eval("UserID") %>' OnClick="CancelRequest_Click" />
                                </asp:PlaceHolder>

                                <asp:PlaceHolder runat="server" Visible='<%# Eval("ReceivedStatus") IsNot DBNull.Value AndAlso Eval("ReceivedStatus").ToString() = "Pending" %>'>
                                    <asp:LinkButton ID="btnAccept" runat="server" CssClass="btn-buddy btn-add" Text="Accept" CommandArgument='<%# Eval("UserID") %>' OnClick="AcceptRequest_Click" />
                                    <asp:LinkButton ID="btnReject" runat="server" CssClass="btn-cancel" Text="Reject" CommandArgument='<%# Eval("UserID") %>' OnClick="RejectRequest_Click" />
                                </asp:PlaceHolder>

                                <asp:LinkButton ID="btnAdd" runat="server" 
                                    Visible='<%# Eval("SentStatus") Is DBNull.Value AndAlso Eval("ReceivedStatus") Is DBNull.Value %>' 
                                    CssClass="btn-buddy btn-add" 
                                    Text="Add Buddy" 
                                    CommandArgument='<%# Eval("UserID") %>' 
                                    OnClick="AddFriend_Click" />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <asp:Timer ID="RefreshTimer" runat="server" Interval="3000" OnTick="RefreshTimer_Tick" />
</asp:Content>