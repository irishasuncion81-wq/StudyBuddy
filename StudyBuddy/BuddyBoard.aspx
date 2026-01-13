<%@ Page Title="Buddy Board" MasterPageFile="~/Site.Master" Language="VB" AutoEventWireup="true" CodeBehind="BuddyBoard.aspx.vb" Inherits="StudyBuddy.BuddyBoard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="main-content">
        <div class="admin-card">
            <div class="page-title">Buddy Board</div>
            <div class="page-desc">Share tips, ask questions, or just say hi to your fellow buddies!</div>

            <div class="post-box">
                <asp:TextBox ID="txtPost" runat="server" TextMode="MultiLine" Rows="3" 
                    CssClass="post-input" Placeholder="What's on your mind, Buddy?"></asp:TextBox>
                <div style="text-align: right; margin-top: 10px;">
                    <asp:Button ID="btnPost" runat="server" Text="Post to Board" 
                        CssClass="btn-action btn-approve" OnClick="btnPost_Click" />
                </div>
            </div>

            <hr style="border: 0; border-top: 1px solid #eee; margin: 30px 0;" />

            <asp:Repeater ID="rptFeed" runat="server">
                <ItemTemplate>
                    <div class="feed-card">
                        <div class="feed-header">
                            <a href='Profile.aspx?ViewUser=<%# Eval("UserName") %>' style="text-decoration:none; display:flex; align-items:center;">
                                <img src='<%# ResolveUrl("~/Uploads/" & Eval("ProfilePicture").ToString()) %>' 
                                     class="user-icon" 
                                     style="width:40px; height:40px; border-radius:50%; object-fit: cover; margin-right: 10px; border: 2px solid #2e7d32;" 
                                     alt="Profile" 
                                     onerror="this.src='Uploads/default-profile.png';" />
        
                                <div class="user-info">
                                    <span class="username"><%# Eval("UserName") %></span>
                                    <span class="post-date"><%# Eval("PostDate", "{0:MMM dd, yyyy - hh:mm tt}") %></span>
                                </div>
                            </a>
                        </div>
                        <div class="feed-content">
                            <%# Eval("Content") %>
                        </div>

                        <div class="post-actions">
                            <asp:LinkButton ID="btnLike" runat="server" CommandName="Like" CommandArgument='<%# Eval("PostID") %>' CssClass="action-link">
                                👍 Like
                            </asp:LinkButton>
                            <span class="count"><%# GetLikeCount(Eval("PostID")) %> Likes</span>

                            <div style="display: inline-block; margin-left: 20px;">
                                <asp:DropDownList ID="ddlReason" runat="server" CssClass="report-select">
                                    <asp:ListItem Text="Select Reason" Value="" />
                                    <asp:ListItem Text="Inappropriate Content" Value="Inappropriate" />
                                    <asp:ListItem Text="Spam" Value="Spam" />
                                    <asp:ListItem Text="Harassment" Value="Harassment" />
                                </asp:DropDownList>
                                <asp:LinkButton ID="btnReport" runat="server" CommandName="Report" 
                                    CommandArgument='<%# Eval("PostID") %>' CssClass="report-link"
                                    OnClientClick="return confirm('Report this post to Admin?');">🚩 Report</asp:LinkButton>
                            </div>
                        </div>

                        <div class="comment-section">
                            <asp:Repeater ID="rptComments" runat="server" DataSource='<%# GetComments(Eval("PostID")) %>'>
                                <ItemTemplate>
                                    <div class="comment">
                                        <strong><%# Eval("UserName") %>:</strong> <%# Eval("CommentText") %>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
    
                            <div class="comment-input-area">
                                <asp:TextBox ID="txtComment" runat="server" placeholder="Write a comment..." CssClass="comment-box"></asp:TextBox>
                                <asp:Button ID="btnSubmitComment" runat="server" Text="Reply" 
                                    CommandName="AddComment" CommandArgument='<%# Eval("PostID") %>' CssClass="btn-reply" />
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <style>
            body { margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; background-image: url('bg1.jpg'); color: #2e7d32; height: 100vh; overflow: hidden; }
            .page-title {
                font-size: 40px;
                font-family: "Comic Sans MS", cursive;
                font-weight: bold;
                color: #1f2937;
                text-align: center;
                margin-bottom: 0px;
            }
            .page-desc { text-align: center; color: #374151; margin-bottom: 10px; }

            .post-box {
                background: #ffffff;
                padding: 20px;
                border: 2px solid #a5d6a7;
                border-radius: 2px;
                box-shadow: 8px 8px 0px #c8e6c9; 
                margin: 20px auto 40px auto;
                max-width: 600px;
            }

            .post-input {
                width: 100%;
                border: 1px solid #c8e6c9;
                background: #f1f8e9; 
                padding: 15px;
                font-family: 'Comic Sans MS', cursive, sans-serif;
                font-size: 14px;
                outline: none;
                box-sizing: border-box;
            }

            .feed-card {
                background: #c8e6c9; 
                border: 1px solid #81c784;
                padding: 20px;
                margin-bottom: 25px;
                position: relative;
                transform: rotate(-0.5deg); 
                box-shadow: 3px 3px 0px rgba(0,0,0,0.05);
            }

            .feed-card:nth-child(odd) {
                background: #dcedc8; 
                transform: rotate(0.7deg);
            }

            .feed-card:nth-child(3n) {
                background: #f1f8e9; 
                transform: rotate(-1deg);
            }
            .feed-card::before {
                content: "";
                position: absolute;
                top: -10px;
                left: 40%;
                width: 60px;
                height: 20px;
                background: rgba(255, 255, 255, 0.5); 
                transform: rotate(2deg);
                border: 1px solid rgba(0,0,0,0.05);
            }

            .feed-header {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
            }

            .user-icon {
                width: 32px;
                height: 32px;
                background: #2e7d32;
                color: #fff;
                border-radius: 50%; 
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                margin-right: 10px;
            }

            .username { 
                font-weight: bold; 
                color: #1b5e20; 
                font-family: 'Comic Sans MS', cursive; 
                font-size: 14px;
            }

            .post-date { 
                font-size: 10px; 
                color: #666; 
                margin-left: auto;
            }

            .feed-content { 
                font-size: 15px; 
                color: #333;
                font-family: 'Segoe UI', Tahoma, sans-serif;
                padding: 5px 0;
            }

            .post-actions { 
                margin-top: 15px; 
                border-top: 1px dashed #81c784;
                padding-top: 10px;
            }

            .action-link { 
                text-decoration: none; 
                color: #2e7d32; 
                font-size: 12px;
                margin-right: 15px;
            }

            .action-link:hover { text-decoration: underline; }
            .comment-section { 
                background: rgba(255,255,255,0.4); 
                padding: 8px; 
                margin-top: 10px;
                border-left: 2px solid #81c784;
            }

            .comment-box { 
                width: 100%; 
                padding: 8px; 
                border: 1px solid #a5d6a7;
                background: #fff;
                font-size: 12px;
                box-sizing: border-box;
            }

            .btn-reply { 
                background: #66bb6a; 
                color: white; 
                border: none; 
                padding: 5px 10px; 
                margin-top: 5px;
                font-size: 11px;
                cursor: pointer;
                border-radius: 3px;
            }

            .report-link { 
                color: #ef5350; 
                font-size: 10px; 
                text-decoration: none;
                opacity: 0.7;
            }

            .report-link:hover { opacity: 1; }        

        </style>
    </div>
</asp:content>
