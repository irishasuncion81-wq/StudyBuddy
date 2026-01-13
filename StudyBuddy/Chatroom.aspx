<%@ Page Title="Chatroom" MasterPageFile="~/Site.Master" Language="VB" AutoEventWireup="true" CodeBehind="Chatroom.aspx.vb" Inherits="StudyBuddy.Chatroom" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<style>
    body { margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; background-image: url('bg1.jpg'); color: #2e7d32; height: 100vh; overflow: hidden; }
    .chatroom-page { padding: 10px 20px 20px 20px; height: 100%; display: flex; flex-direction: column; }
    .page-title {
        font-size: 40px;
        font-family: "Comic Sans MS", cursive;
        font-weight: bold;
        color: #1f2937;
        text-align: center;
        margin-bottom: 0px;
    }
    .page-desc { text-align: center; color: #374151; margin-bottom: 10px; }

    .container {
        display: flex;
        gap: 15px;
        height: calc(100vh - 160px);
        padding: 0 20px 20px 20px;
        margin-top: 5px;
        overflow: hidden;
    }

    .sidebar1 { 
        width: 320px; 
        min-width: 320px; 
        background-color: #c8e6c9b0; 
        padding: 15px; 
        border-radius: 12px; 
        display: flex; 
        flex-direction: column; 
        height: 100%; 
        overflow-y: auto;
        box-sizing: border-box;
    }
    .create-room-btn { background-color: #81c784; color: white; font-weight: bold; padding: 12px; border-radius: 8px; border: none; cursor: pointer; transition: 0.3s; width: 100%; margin-bottom: 10px; }
    .create-room-btn:hover { background-color: #66bb6a; }

    /* CHAT PANEL */
    .lbl { flex: 1; background-color: #d7f1d9; display: flex; flex-direction: column; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 6px rgba(0,0,0,0.1); position: relative; }
    .chat-header-section { background-color: #81c784; border-bottom: 2px solid #66bb6a; display: flex; justify-content: space-between; align-items: center; padding: 0 20px; min-height: 65px; }
    .chat-title { margin-top: 0px; font-size: 20px; font-weight: bold; color: #1b5e20; }
    
    .main { flex: 1; padding: 20px; background-image: url('main_chatroom.jpg'); background-attachment: fixed; background-repeat: no-repeat; background-size: cover; overflow-y: auto; display: flex; flex-direction: column; }

    /* BUBBLES */
    .msg-left-wrapper, .msg-right-wrapper { 
        display: flex; 
        flex-direction: column; 
        width: 100%; 
        margin-bottom: 12px; 
    }

    .chat-bubble { 
        max-width: 65%; 
        padding: 12px 18px; 
        border-radius: 14px; 
        font-size: 15px; 
        word-wrap: break-word; 
        position: relative;
        display: inline-block;
    }

    /* RIGHT BUBBLE */
    .msg-right-wrapper { align-items: flex-end; }
    .msg-right-wrapper .chat-bubble { 
        background-color: #a7d7a9 !important; 
        color: #1b5e20 !important; 
        border-bottom-right-radius: 2px; 
    }

    /* LEFT BUBBLE */
    .msg-left-wrapper { align-items: flex-start; }
    .msg-left-wrapper .chat-bubble { 
        background-color: #ffffff !important; 
        color: #333 !important; 
        border-bottom-left-radius: 2px; 
        border: 1px solid #ddd;
    }

    .timestamp { font-size: 10px; color: #666; margin-top: 5px; display: block; }

    /* INPUT BAR */
    .messenger-inline { display: flex; padding: 14px; border-top: 1px solid #a5d6a7; background-color: #ffffff; gap: 10px; }
    .message-box { flex: 1; padding: 10px 14px; border-radius: 20px; border: 1px solid #ccc; outline: none; }
    .send-button { padding: 10px 25px; background-color: #66bb6a; color: white; border: none; border-radius: 20px; cursor: pointer; font-weight: bold; transition: 0.2s; }
    .send-button:hover { background-color: #2e7d32; }

    .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); display: none; justify-content: center; align-items: center; z-index: 1000; }
    .modal-content { background: white; padding: 25px; border-radius: 15px; width: 400px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); animation: slideDown 0.3s ease; }
    .modal-header { font-size: 20px; font-weight: bold; color: #2e7d32; margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center; }
    .member-list-scroll { max-height: 250px; overflow-y: auto; border: 1px solid #e0e0e0; border-radius: 8px; margin: 10px 0; }
    
    .kick-btn { color: white; background-color: #ef4444; border: none; padding: 4px 10px; border-radius: 5px; font-size: 11px; cursor: pointer; text-decoration: none; font-weight: bold; }
    .kick-btn:hover { background-color: #b91c1c; }

    @keyframes slideDown { from { transform: translateY(-20px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

    .avatar-wrapper { position: relative; width: 40px; height: 40px; flex-shrink: 0; }
    .friend-avatar { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; }
    .status-dot { position: absolute; bottom: 0; right: 0; width: 12px; height: 12px; border-radius: 50%; border: 2px solid white; }
    .online { background-color: #44b700; }
    .offline { background-color: #ff0000; }
    .friend-item-container { display: flex; align-items: center; gap: 12px; padding: 8px; text-decoration: none; color: #2e7d32; border-radius: 8px; flex: 1; }
    .friend-item-container:hover { background-color: #a5d6a7; }

    .msg-left-wrapper {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        margin-bottom: 15px;
    }

    .msg-right-wrapper {
        display: flex;
        flex-direction: column;
        align-items: flex-end;
        margin-bottom: 15px;
    }

    .sender-info {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 4px;
        margin-left: 5px; 
    }

    .mini-avatar {
        width: 24px;
        height: 24px;
        border-radius: 50%;
        object-fit: cover;
        border: 1px solid #ddd;
    }

    .sender-name {
        font-size: 11px;
        font-weight: bold;
        color: #555;
    }

    .chat-mini-avatar {
        width: 25px !important;
        height: 25px !important;
        border-radius: 50%;
        object-fit: cover;
        display: inline-block;
    }

    .sender-header {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 5px;
    }

    .chat-sender-name {
        font-size: 11px;
        font-weight: bold;
        color: #1b5e20; 
    }


    .searchable-item {
        display: block; 
        width: 100%;
        margin-bottom: 2px;
    }

    .friend-item-container {
        display: flex !important; 
        align-items: center;
        gap: 12px;
        padding: 10px;
        width: 100%;
        box-sizing: border-box; 
    }

    .date-separator {
        display: flex;
        align-items: center;
        text-align: center;
        margin: 25px 0 15px 0;
        color: #558b2f; 
        font-size: 11px;
        font-weight: bold;
        text-transform: uppercase;
        letter-spacing: 1px;
        width: 100%;
    }

    .date-separator::before,
    .date-separator::after {
        content: '';
        flex: 1;
        border-bottom: 1px solid #c8e6c9;
    }

    .date-separator span {
        padding: 5px 15px;
        background-color: #f0fdf4;
        border: 1px solid #c8e6c9;
        border-radius: 20px;
    }

@media (max-width: 768px) {
    body { overflow-y: auto !important; height: auto !important; }

    .container {
        flex-direction: column;
        height: auto !important; 
        overflow: visible !important;
    }

    .sidebar1 {
        width: 100% !important;
        max-height: 400px; 
        overflow-y: auto !important;
        -webkit-overflow-scrolling: touch;
    }

    .lbl {
        height: 600px;
        display: flex;
        flex-direction: column;
    }

    .main {
        flex: 1;
        overflow-y: auto !important;
        -webkit-overflow-scrolling: touch;
    }
}</style>

<div class='chatroom-page <%= If(phChatInput.Visible, "active-chat", "") %>'>
    <div class="page-title">Chatroom</div>
    <div class="page-desc">Talk with your buddies!</div>

    <div class="container">
        <div class="sidebar1">
            <button type="button" class="create-room-btn" onclick="openCreateRoom()">➕ Create Group Chat</button>

            <div style="padding: 5px 0; margin-bottom: 10px;">
                <input type="text" id="sidebarSearch" onkeyup="filterSidebar()" 
                       placeholder="🔍 Search buddies or groups..." 
                       class="message-box" style="width: 100%; box-sizing: border-box; font-size: 13px; height: 35px;" />
            </div>

            <h4 style="margin: 10px 0 5px 0; color: #1b5e20;">Study Buddies</h4>
            <asp:Repeater ID="rptFriends" runat="server">
                <ItemTemplate>
                    <div class="searchable-item">
                        <asp:LinkButton ID="lnkFriend" runat="server" OnClick="Friend_Click" 
                            CommandArgument='<%# Eval("FriendUserID") %>' CommandName='<%# Eval("FullName") %>' 
                            CssClass="friend-item-container">
                            <div class="avatar-wrapper">
                                <img src='<%# ResolveUrl("~/Uploads/" & If(Eval("ProfilePicture") Is DBNull.Value OrElse Eval("ProfilePicture").ToString() = "", "default-profile.png", Eval("ProfilePicture").ToString())) %>' 
                                     class="friend-avatar" onerror="this.src='Uploads/default-profile.png';" />
                                <div class='<%# "status-dot " & Eval("OnlineStatus").ToString().ToLower() %>'></div>
                            </div>
                            <span style="font-weight: 500;"><%# Eval("FullName") %></span>
                        </asp:LinkButton>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <h4 style="margin: 20px 0 5px 0; color: #1b5e20;">My Groups</h4>
            <asp:Repeater ID="rptGroups" runat="server">
                <ItemTemplate>
                    <div class="searchable-item">
                        <div style="display: flex; align-items: center; background: rgba(255,255,255,0.3); border-radius: 8px; margin-bottom: 5px; padding-right: 10px;">
                            <asp:LinkButton ID="lnkGroup" runat="server" OnClick="Group_Click" 
                                CommandArgument='<%# Eval("RoomID") %>' CommandName='<%# Eval("RoomName") %>' 
                                CssClass="friend-item-container" style="flex-grow: 1;">
                                <div class="avatar-wrapper">
                                    <img src='<%# ResolveUrl("~/Uploads/" & If(Eval("RoomImage") Is DBNull.Value OrElse String.IsNullOrEmpty(Eval("RoomImage").ToString()), "STUDYBUDDY.png", Eval("RoomImage").ToString())) %>' 
                                         class="friend-avatar" onerror="this.src='Uploads/STUDYBUDDY.png';" />
                                </div>
                                <span style="font-weight: 500;"><%# Eval("RoomName") %></span>
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnLeave" runat="server" Text="Leave" ForeColor="#ef4444" 
                                OnCommand="LeaveGroup_Command" CommandArgument='<%# Eval("RoomID") %>' 
                                OnClientClick="return confirm('Leave group?');" 
                                style="text-decoration:none; font-size: 10px; font-weight: bold; flex-shrink: 0;" />
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div class="lbl">
            <asp:LinkButton ID="btnBackToList" runat="server" OnClick="btnBackToList_Click" 
                CssClass="mobile-back" style="display:none; padding: 15px; background: #2e7d32; color: white; text-decoration: none; font-weight: bold; width: 100%; box-sizing: border-box;">
                ← Back to Buddies
            </asp:LinkButton>
            <div class="chat-header-section">
                <div class="chat-title">
                    <asp:Literal ID="lblFriendName" runat="server" Text="Select a buddy to chat"></asp:Literal>
                </div>
                <asp:LinkButton ID="btnShowMembers" runat="server" OnClientClick="openMembersModal(); return false;" 
                    CssClass="send-button" style="font-size: 12px; padding: 8px 15px; text-decoration:none; background-color: #2e7d32;" 
                    Visible="false">👥 Members</asp:LinkButton>
            </div>
            
            <div class="main" id="chatContainer">
                <asp:Repeater ID="rptMessages" runat="server">
                    <ItemTemplate>
                        <%# ShowDateSeparator(Eval("TimeStamp")) %>

                        <div class='<%# If(Eval("SenderID").ToString() = Session("UserID").ToString(), "msg-right-wrapper", "msg-left-wrapper") %>'>
            
                            <asp:PlaceHolder runat="server" Visible='<%# Eval("SenderID").ToString() <> Session("UserID").ToString() %>'>
                                <div class="sender-header">
                                    <img src='<%# ResolveUrl("~/Uploads/" & If(Eval("ProfilePicture") Is DBNull.Value OrElse Eval("ProfilePicture").ToString() = "", "default-avatar.png", Eval("ProfilePicture").ToString())) %>' class="chat-mini-avatar" />
                                    <span class="chat-sender-name"><%# Eval("SenderName") %></span>
                                </div>
                            </asp:PlaceHolder>

                            <div class="chat-bubble">
                                <p style="margin: 0;"><%# Eval("Content") %></p>
                                <small class="timestamp"><%# Eval("TimeStamp", "{0:t}") %></small>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:PlaceHolder ID="phChatBox" runat="server" Visible="false"></asp:PlaceHolder>
            </div>

            <asp:PlaceHolder ID="phChatInput" runat="server" Visible="false">
                <div class="messenger-inline" style="flex-direction: column; align-items: stretch;">
                    <div style="display: flex; gap: 10px;">
                        <asp:TextBox ID="txtMessage" runat="server" CssClass="message-box" 
                            placeholder="Write a message... 50 characters only :3" 
                            MaxLength="500" onkeyup="checkLength(this)"></asp:TextBox>
                        <asp:Button ID="btnSend" runat="server" Text="Send" CssClass="send-button" OnClick="btnSend_Click" />
                    </div>
                    <span id="charCounter" style="font-size: 11px; margin-top: 5px; margin-left: 15px; color: #666;">
                        0 / 50 characters
                    </span>
                </div>
            </asp:PlaceHolder>
        </div>
    </div>
</div>

<div id="modalMembers" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header">
            <span>Group Members</span>
            <span style="cursor:pointer" onclick="closeMembersModal()">&times;</span>
        </div>

        <div class="member-list-scroll">
            <asp:Repeater ID="rptGroupMembers" runat="server">
                <ItemTemplate>
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; border-bottom: 1px solid #eee;">
                        <span style="color: #333; font-weight: 500;"><%# Eval("FullName") %></span>
                        <asp:LinkButton ID="btnKick" runat="server" Text="Kick" 
                            CssClass="kick-btn" 
                            Visible='<%# IsUserAdmin(Eval("RoomID")) AndAlso Eval("UserID").ToString() <> Session("UserID").ToString() %>'
                            OnCommand="KickMember_Command" 
                            CommandArgument='<%# Eval("RoomID").ToString() & "|" & Eval("UserID").ToString() %>' />
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div style="padding: 15px; background: #f0fdf4; border-radius: 10px; margin-top: 10px; border: 1px dashed #66bb6a;">
            <h4 style="margin: 0 0 10px 0; font-size: 13px; color: #1b5e20;">➕ Add Buddy to Group</h4>
            <div style="display: flex; gap: 8px;">
                <asp:DropDownList ID="ddlAddBuddies" runat="server" CssClass="message-box" style="flex: 2; font-size: 12px; height: 35px;"></asp:DropDownList>
                <asp:Button ID="btnAddMember" runat="server" Text="Add" OnClick="btnAddMember_Click" 
                    style="flex: 1; background: #2e7d32; color: white; border: none; border-radius: 8px; cursor: pointer; font-weight: bold; font-size: 12px;" />
            </div>
        </div>

        <button type="button" onclick="closeMembersModal()" style="width:100%; padding:10px; border:none; border-radius:8px; cursor:pointer; margin-top:10px;">Close</button>
    </div>
</div>

<div id="modalGroup" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header">
            <span>Create New Group Chat</span>
            <span style="cursor:pointer" onclick="closeCreateRoom()">&times;</span>
        </div>
        <asp:TextBox ID="txtNewRoomName" runat="server" CssClass="message-box" placeholder="Group Name" style="width:100%; margin-bottom:15px; box-sizing:border-box;"></asp:TextBox>
        <label style="font-size:12px; font-weight:bold; display:block; margin-bottom:5px;">Group Photo:</label>
        <asp:FileUpload ID="fuGroupPhoto" runat="server" style="margin-bottom:15px; font-size:12px;" />
        
        <label style="font-size:12px; font-weight:bold; display:block; margin-bottom:5px;">Select Buddies:</label>
        <div class="member-list-scroll">
            <asp:CheckBoxList ID="cblMembers" runat="server" DataTextField="FullName" DataValueField="FriendUserID" style="width:100%; padding: 10px;"></asp:CheckBoxList>
        </div>

        <div style="display:flex; gap:10px; margin-top:20px;">
            <asp:Button ID="btnDoCreate" runat="server" Text="Create Group" CssClass="create-room-btn" OnClick="btnCreateRoom_Click" style="flex:2" />
            <button type="button" onclick="closeCreateRoom()" style="flex:1; background:#eee; color:#333; border:none; border-radius:8px; cursor:pointer; font-weight:bold;">Cancel</button>
        </div>
    </div>
</div>


<script src="Scripts/jquery-3.6.0.min.js"></script>
<script src="Scripts/jquery.signalR-2.4.3.min.js"></script>
<script src="signalr/hubs"></script>

<script type="text/javascript">
    function openCreateRoom() { document.getElementById('modalGroup').style.display = 'flex'; }
    function closeCreateRoom() { document.getElementById('modalGroup').style.display = 'none'; }
    function openMembersModal() { document.getElementById('modalMembers').style.display = 'flex'; }
    function closeMembersModal() { document.getElementById('modalMembers').style.display = 'none'; }

    function scrollToBottom() {
        var objDiv = document.getElementById("chatContainer");
        if (objDiv) {
            setTimeout(function () {
                objDiv.scrollTop = objDiv.scrollHeight;
            }, 100);
        }
    }

    function checkLength(textarea) {
        var maxLength = 50;
        var counter = document.getElementById('charCounter');
        if (textarea.value.length > maxLength) {
            textarea.value = textarea.value.substring(0, maxLength);
        }
        var currentLength = textarea.value.length;
        counter.innerText = currentLength + " / " + maxLength + " characters";
        counter.style.color = (currentLength >= maxLength) ? "red" : "#666";
    }

    function filterSidebar() {
        var input = document.getElementById('sidebarSearch');
        var filter = input.value.toLowerCase();
        var items = document.getElementsByClassName('searchable-item');
        for (var i = 0; i < items.length; i++) {
            var text = items[i].innerText || items[i].textContent;
            items[i].style.display = text.toLowerCase().indexOf(filter) > -1 ? "" : "none";
        }
    }

    // --- SIGNALR REAL-TIME LOGIC ---
    $(function () {

        var chat = $.connection.chatHub;

        // RECEIVER: Ito ang function na tinatawag ng SignalR Hub (ChatHub.vb)
        chat.client.broadcastMessage = function (name, message) {
            // 1. I-format ang message bubble (HTML)
            var bubbleHtml =
                '<div class="msg-left-wrapper">' +
                '<div class="sender-header"><span class="chat-sender-name">' + name + '</span></div>' +
                '<div class="chat-bubble">' +
                '<p>' + message + '</p>' +
                '<small class="timestamp">Just now</small>' +
                '</div>' +
                '</div>';


            $('#chatContainer').append(bubbleHtml);

            scrollToBottom();
        };


        $.connection.hub.start().done(function () {
            $('#<%= btnSend.ClientID %>').click(function () {
                var msgBox = $('#<%= txtMessage.ClientID %>');
                var msgText = msgBox.val();
                
                if (msgText.trim() !== "") {
                    // Kunin ang sender name mula sa Session
                    var senderName = '<%= Session("FullName") %>';

                    // I-send sa Server Hub
                    chat.server.sendMessage(senderName, msgText);

                    // Linisin ang input
                    msgBox.val('').focus();
                    document.getElementById('charCounter').innerText = "0 / 50 characters";
                }

                // (Postback)
                return false;
            });
        });
    });

    // Auto-scroll
    window.onload = scrollToBottom;
</script>

</asp:Content>
