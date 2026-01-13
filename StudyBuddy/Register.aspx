<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Register.aspx.vb" Inherits="StudyBuddy.Register" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Register - StudyBuddy</title>
    <style>
        body {
            font-family: Arial;
            background: linear-gradient(135deg, #dfffe9, #eafaf7);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .register {
            background: white;
            padding: 40px;
            width: 350px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,.1);
            text-align: center;
        }

        h1 {
            color: #1c6d5a;
            margin-bottom: 25px;
        }

        .field {
            position: relative;
            margin-bottom: 14px;
        }

        .textbox {
            width: 100%;
            height: 45px;
            padding: 0 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 12px;
        }

        select.textbox {
            height: 45px;
            padding: 0 60px 0 12px;
            box-sizing: border-box;
            appearance: none;
            background-color: white;
        }

        .asterisk {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: red;
            pointer-events: none;
        }

        .btn {
            width: 100%;
            padding: 12px;
            margin-top: 15px;
            border-radius: 25px;
            background: #3cbf9a;
            color: white;
            cursor: pointer;
            border: none;
            font-size: 16px;
        }

        .eye {
            position: absolute;
            right: 34px;
            top: 50%;
            transform: translateY(-50%);
            width: 20px;
            height: 20px;
            cursor: pointer;
            display: none;
        }

        .eye::before {
            content: "👁";
            font-size: 18px;
        }

        .eye.hide::after {
            content: "";
            position: absolute;
            top: 9px;
            left: -2px;
            width: 24px;
            height: 2px;
            background: black;
            transform: rotate(-45deg);
        }

  
        .password-hint {
            font-size: 11px;
            color: #666;
            text-align: left;
            margin-top: 6px;
            line-height: 1.4;
            display: none;
        }
    </style>
</head>

<body>
<form id="form1" runat="server">
<div class="register">

    <h1>Create Account</h1>

    <div class="field">
        <asp:TextBox ID="txtFirstName" runat="server" CssClass="textbox" Placeholder="First Name" />
        <span class="asterisk">*</span>
    </div>

    <div class="field">
        <asp:TextBox ID="txtMiddleName" runat="server" CssClass="textbox" Placeholder="Middle Name" />
        <span class="asterisk">*</span>
    </div>

    <div class="field">
        <asp:TextBox ID="txtLastName" runat="server" CssClass="textbox" Placeholder="Last Name" />
        <span class="asterisk">*</span>
    </div>

    <div class="field">
        <asp:TextBox ID="txtEmail" runat="server" CssClass="textbox" Placeholder="Email" />
        <span class="asterisk">*</span>
    </div>

    <div class="field">
        <asp:TextBox ID="txtUsername" runat="server" CssClass="textbox" Placeholder="Username" />
        <span class="asterisk">*</span>
    </div>

    <!-- PASSWORD -->
    <div class="field">
        <asp:TextBox ID="txtPassword" runat="server"
            ClientIDMode="Static"
            CssClass="textbox"
            TextMode="Password"
            Placeholder="Password"
            onfocus="document.getElementById('passHint').style.display='block'; this.nextElementSibling.style.display='block';"
            onblur="if(!this.value){document.getElementById('passHint').style.display='none'; this.nextElementSibling.style.display='none';}" />

        <span class="eye"
              onclick="togglePassword('txtPassword', this)"
              onmousedown="event.preventDefault();"></span>

        <span class="asterisk">*</span>
    </div>


    <div class="password-hint" id="passHint">
        Your password must be <b>8 characters long</b> and include:
        <br />• Lowercase letter
        <br />• Uppercase letter
        <br />• Number
        <br />• Special character
    </div>

    <div class="field">
        <asp:TextBox ID="txtConfirmPassword" runat="server"
            ClientIDMode="Static"
            CssClass="textbox"
            TextMode="Password"
            Placeholder="Confirm Password"
            AutoPostBack="true"
            OnTextChanged="txtConfirmPassword_TextChanged"
            onfocus="this.nextElementSibling.style.display='block';"
            onblur="if(!this.value){this.nextElementSibling.style.display='none';}" />

        <span class="eye"
              onclick="togglePassword('txtConfirmPassword', this)"
              onmousedown="event.preventDefault();"></span>

        <span class="asterisk">*</span>
    </div>

    
    <asp:Panel ID="Questions" runat="server" Visible="False">
        <div class="field">
            <asp:TextBox ID="txtQ1" runat="server" CssClass="textbox" Placeholder="What is your favorite color?" />
            <span class="asterisk">*</span>
        </div>
        <div class="field">
            <asp:TextBox ID="txtQ2" runat="server" CssClass="textbox" Placeholder="What is your favorite game?" />
            <span class="asterisk">*</span>
        </div>
        <div class="field">
            <asp:TextBox ID="txtQ3" runat="server" CssClass="textbox" Placeholder="What is the name of your pet?" />
            <span class="asterisk">*</span>
        </div>
    </asp:Panel>

    <div class="field">
        <asp:DropDownList ID="txtSex" runat="server" CssClass="textbox">
            <asp:ListItem Text="Select Sex" Value="" />
            <asp:ListItem Text="Male" />
            <asp:ListItem Text="Female" />
        </asp:DropDownList>
        <span class="asterisk">*</span>
    </div>

    <div class="field">
        <asp:DropDownList ID="Role" runat="server" CssClass="textbox">
            <asp:ListItem Text="Select Role" Value="" />
            <asp:ListItem Text="Student" />
            <asp:ListItem Text="Tutor" />
        </asp:DropDownList>
        <span class="asterisk">*</span>
    </div>

    <asp:Button ID="btnRegister" runat="server" CssClass="btn" Text="Register" OnClick="btnRegister_Click" />

</div>
</form>

<script>
    function togglePassword(id, icon) {
        var txt = document.getElementById(id);
        if (txt.type === "password") {
            txt.type = "text";
            icon.classList.add("hide");
        } else {
            txt.type = "password";
            icon.classList.remove("hide");
        }
    }
</script>

</body>
</html>
