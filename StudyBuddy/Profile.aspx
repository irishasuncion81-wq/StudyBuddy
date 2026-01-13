<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="Profile.aspx.vb" Inherits="StudyBuddy.Profile" %>

<asp:Content ID="MainContentSection" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .main-wrapper {
            display: flex; gap: 20px; max-width: 1200px;
            margin: 35px auto; align-items: flex-start;
        }
        .profile-container {
            flex: 2; background-color: #f0fdf4c8; border-radius: 15px;
            padding: 30px; box-shadow: 0 6px 15px rgba(0,0,0,.08);
        }
        .buddies-side-panel {
            flex: 1; background: #f0fdf4c8; border-radius: 15px;
            padding: 20px; box-shadow: 0 6px 15px rgba(0,0,0,.08);
            max-height: 85vh; overflow-y: auto;
        }
        .profile-header { display: flex; align-items: center; gap: 25px; margin-bottom: 25px; border-bottom: 1px solid #eee; padding-bottom: 20px; }
        .profile-img-circle { width: 130px; height: 130px; border-radius: 50%; object-fit: cover; border: 4px solid #41c39b; }
        
        .profile-stats { display: flex; gap: 40px; margin-top: 15px; }
        .stat-item { text-align: center; }
        .stat-value { display: block; font-size: 22px; font-weight: 800; color: #333; }
        .stat-label { font-size: 12px; color: #888; text-transform: uppercase; }

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


        .buddy-item { display: flex; align-items: center; gap: 12px; padding: 12px; border-radius: 10px; text-decoration: none; color: inherit; transition: 0.2s; margin-bottom: 5px; }
        .buddy-item:hover { background: #f0fdf4; }
        .buddy-img-small { width: 45px; height: 45px; border-radius: 50%; object-fit: cover; }
        .buddy-name { font-weight: bold; font-size: 14px; color: #2f8f6b; }

   
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-top: 20px; }
        .label { font-size: 12px; color: #999; font-weight: bold; margin-bottom: 4px; }
        .textbox { width: 100%; padding: 10px; border: 1px solid #e0e0e0; border-radius: 8px; background: #fafafa; }
        .btn-small { background: #41c39b; color: white; border: none; padding: 8px 18px; border-radius: 6px; cursor: pointer; }
    </style>

    <div class="main-wrapper">
        <div class="profile-container">
            <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="~/Profile.aspx" Text="← Back to My Profile" Visible="false" style="font-size:12px; color:#41c39b; display:block; margin-bottom:10px;" />

            <div class="profile-header">
                <div class="profile-pic-container">
                    <asp:Image ID="imgProfile" runat="server" CssClass="profile-img-circle" />
                    <asp:Panel ID="pnlUpload" runat="server" style="margin-top:10px;">
                        <asp:FileUpload ID="fileUploadPic" runat="server" style="font-size:10px;" /><br />
                        <asp:Button ID="btnUploadPic" runat="server" Text="Update Photo" OnClick="btnUploadPic_Click" CssClass="btn-small" style="padding:4px 10px; font-size:11px; margin-top:5px;" />
                    </asp:Panel>
                </div>
                <div>
                    <h2 style="margin:0;"><asp:Label ID="lblFullName" runat="server" /></h2>
                    <div style="color:#666; font-size: 14px;"><asp:Label ID="lblRole" runat="server" /></div>
                    
                    <div class="profile-stats">
                        <div class="stat-item">
                            <span class="stat-value"><asp:Label ID="lblBuddyCount" runat="server" Text="0" /></span>
                            <span class="stat-label">Buddies</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-value"><asp:Label ID="lblReviewerCount" runat="server" Text="0" /></span>
                            <span class="stat-label">Reviewers</span>
                        </div>
                        <div class="stat-item" style="margin-left: 10px; align-self: center;">
                            <asp:Button ID="btnUnbuddy" runat="server" 
                                Text="Unbuddy" 
                                CssClass="btn-small" 
                                BackColor="#f56565" 
                                Visible="false" 
                                OnClick="btnUnbuddy_Click" 
                                OnClientClick="return confirm('Are you sure you want to remove this buddy?');" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="info-grid">
                <div><div class="label">First Name</div><asp:TextBox ID="txtFirstName" runat="server" CssClass="textbox" ReadOnly="True" /></div>
                <div><div class="label">Last Name</div><asp:TextBox ID="txtLastName" runat="server" CssClass="textbox" ReadOnly="True" /></div>
                <div><div class="label">Middle Name</div><asp:TextBox ID="txtMiddleName" runat="server" CssClass="textbox" ReadOnly="True" /></div>
                <div>
                    <div class="label">Sex</div>
                    <asp:DropDownList ID="ddlSex" runat="server" CssClass="textbox" Enabled="False">
                        <asp:ListItem Text="-- Select --" Value=""></asp:ListItem>
                        <asp:ListItem Text="Male" Value="Male"></asp:ListItem>
                        <asp:ListItem Text="Female" Value="Female"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            
            <div style="margin-top:15px;">
                <div class="label">Email Address</div>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="textbox" ReadOnly="True" />
            </div>

            <div style="margin-top:15px;">
                <div class="label">About Me (Bio)</div>
                <asp:TextBox ID="txtBio" runat="server" CssClass="textbox" TextMode="MultiLine" Height="80px" ReadOnly="True" />
                <asp:Button ID="btnEdit" runat="server" Text="Edit Bio" OnClick="btnEdit_Click" CssClass="btn-small" style="margin-top:10px;" />
                <asp:Button ID="btnSave" runat="server" Text="Save Changes" OnClick="btnSave_Click" CssClass="btn-small" Visible="false" style="margin-top:10px; background:#2f8f6b;" />
            </div>
        </div>

        <div class="buddies-side-panel">
            <h3 style="color: #2f8f6b; margin-top: 0; font-size: 18px; border-bottom: 2px solid #f0fdf4; padding-bottom: 10px;">My Buddies</h3>
            <asp:Repeater ID="rptBuddies" runat="server">
                <ItemTemplate>
                    <a href='Profile.aspx?ViewUser=<%# Eval("UserName") %>' class="buddy-item">
                            <img src='<%# ResolveUrl("~/Uploads/" & Eval("ProfilePicture").ToString()) %>' 
                                 class="buddy-img-small" 
                                 alt="Profile" 
                                 onerror="this.src='Uploads/default-profile.png';" />
                        <div>
                            <div class="buddy-name"><%# Eval("FullName") %></div>
                            <div class="buddy-role"><%# Eval("Role") %></div>
                        </div>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>
