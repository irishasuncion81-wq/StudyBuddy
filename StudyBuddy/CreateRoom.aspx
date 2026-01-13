<%@ Page Title="CreateRoom" MasterPageFile="~/Site.Master" Language="VB" AutoEventWireup="true" CodeBehind="CreateRoom.aspx.vb" Inherits="StudyBuddy.CreateRoom" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfSelectedUsers" runat="server" />

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: #f0fdf4;
            color: #2e7d32;
            height: 100%;
            overflow: hidden;
        }

        .panel1 {
            position: fixed;
            top: 0;
            left: 258px;
            right: 0;
            height: 83px;
            background-color: #c8e6c9;
            padding: 0 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            z-index: 10;
            font-size: 18px;
            color: #2e7d32;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            display: flex;
            margin-top: 83px;
            height: calc(100vh - 83px);
            padding: 20px;
            gap: 20px;
            overflow: hidden;
        }

        .sidebar1 {
            width: 220px;
            background-color: #c8e6c9;
            padding: 20px;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
            border-radius: 12px;
            display: flex;
            max-height: 520px;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            gap: 20px;
        }

        .gc-picture {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: #a5d6a7;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: white;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
        }

        .input-field {
            width: 100%;
            padding: 10px;
            border: 1px solid #a5d6a7;
            border-radius: 8px;
            font-size: 16px;
            background-color: #ffffff;
            color: #2e7d32;
            text-align: center;
        }

        .btn-create {
            padding: 10px;
            width: 100%;
            background-color: #66bb6a;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .btn-create:hover {
            background-color: #4caf50;
        }

        .main {
            flex: 1;
            background-color: #e0f2f1;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            display: flex;
            max-height: 520px;
            flex-direction: column;
            overflow-y: auto;
        }

        .search-field {
            width: 50%;
            padding: 10px;
            border: 1px solid #a5d6a7;
            border-radius: 8px;
            font-size: 16px;
            background-color: #ffffff;
            color: #2e7d32;
            margin-bottom: 15px;
        }

        .user-list {
            width: 100%;
            height: 500px;
            border: 1px solid #a5d6a7;
            border-radius: 8px;
            background-color: #ffffff;
            color: #2e7d32;
            font-size: 16px;
            padding: 8px;
            overflow-y: auto;
        }

        .user-item {
            cursor: pointer;
            padding: 6px;
            border-bottom: 1px solid #c8e6c9;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .user-item:hover {
            background-color: #e8f5e9;
        }

        .remove-btn {
            background-color: transparent;
            border: none;
            color: #d32f2f;
            font-size: 16px;
            cursor: pointer;
        }

        .remove-btn:hover {
            color: #b71c1c;
        }

        .chat-header {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #2e7d32;
        }

        .chat-container {
            padding: 20px;
            background-color: #e0f2f1;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            margin-top: 20px;
        }

        .chat-input {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border-radius: 8px;
            border: 1px solid #a5d6a7;
            margin-top: 10px;
        }

        .send-btn {
            background-color: #66bb6a;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }
    </style>
<!-- Header -->
<div class="panel1">
    <h1>Study Buddy Chatroom</h1>
</div>

<!-- Main Container -->
<div class="container">

    <!-- Sidebar: Create Room -->
    <div class="sidebar1">
        <h3>Create a Room</h3>
        <div class="gc-picture">
            <i class="fas fa-users"></i>
        </div>
        <asp:TextBox ID="txtRoomName" runat="server" CssClass="input-field" placeholder="Enter Room Name" />
        <asp:Button ID="btnCreateRoom" runat="server" Text="Create Room" CssClass="btn-create" OnClick="btnCreateRoom_Click" />
    </div>

    <!-- Main Section -->
    <div class="main">
        <asp:TextBox ID="txtSearchUser" runat="server" CssClass="search-field" placeholder="Search User..." onkeyup="filterUsers()" />

        <!-- ✅ Available Rooms Box with Repeater -->
        <h3 style="margin-top: 20px;">Available Rooms</h3>
        <div class="user-list" id="availableRooms">
            <asp:Repeater ID="rptAvailableRooms" runat="server">
                <ItemTemplate>
                    <div class="user-item">
                        <asp:LinkButton ID="btnJoinRoom" runat="server"
                            CommandArgument='<%# Eval("RoomName") %>'
                            OnClick="JoinRoom_Click"
                            CssClass="room-link">
                            <%# Eval("RoomName") %>
                        </asp:LinkButton>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Selected Users Panel -->
        <h3 style="margin-top: 20px;">Selected Users</h3>
        <div id="selectedUsers" class="user-list" style="margin-bottom: 16px;">
            <!-- Users will be added here dynamically -->
        </div>

        <!-- All Users List -->
        <h3 style="margin-top: 20px;">All Users</h3>
        <div id="userPool" class="user-list">
            <asp:Repeater ID="rptUsers" runat="server">
                <ItemTemplate>
                    <div class="user-item" onclick="addUser('<%# Eval("UserID") %>', '<%# Eval("FullName") %>')">
                        <%# Eval("FullName") %>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</div>
    <script type="text/javascript">
        function filterUsers() {
            const query = document.getElementById("<%= txtSearchUser.ClientID %>").value.toLowerCase();
            const userItems = document.querySelectorAll("#userPool .user-item");
            userItems.forEach(item => {
                const name = item.textContent.toLowerCase();
                item.style.display = name.includes(query) ? "flex" : "none";
            });
        }

        const selectedUserIds = new Set();

        function addUser(userId, fullName) {
            if (selectedUserIds.has(userId)) return;

            selectedUserIds.add(userId);

            const container = document.getElementById("selectedUsers");
            const userDiv = document.createElement("div");
            userDiv.className = "user-item";
            userDiv.setAttribute("data-userid", userId);

            const nameSpan = document.createElement("span");
            nameSpan.textContent = fullName;

            const removeBtn = document.createElement("button");
            removeBtn.textContent = "❌";
            removeBtn.className = "remove-btn";
            removeBtn.onclick = function () {
                selectedUserIds.delete(userId);
                userDiv.remove();

                const bottomList = document.getElementById("userPool");
                const restoredUser = document.createElement("div");
                restoredUser.className = "user-item";
                restoredUser.textContent = fullName;
                restoredUser.onclick = function () {
                    addUser(userId, fullName);
                    restoredUser.remove();
                };
                bottomList.appendChild(restoredUser);

                document.getElementById("<%= hfSelectedUsers.ClientID %>").value = Array.from(selectedUserIds).join(",");
            };

            userDiv.appendChild(nameSpan);
            userDiv.appendChild(removeBtn);
            container.insertBefore(userDiv, container.children[1]);

            document.getElementById("<%= hfSelectedUsers.ClientID %>").value = Array.from(selectedUserIds).join(",");

            const bottomList = document.getElementById("userPool");
            const items = bottomList.querySelectorAll(".user-item");
            items.forEach(item => {
                if (item.textContent.trim() === fullName) {
                    item.remove();
                }
            });
        }
    </script>
</asp:Content>
