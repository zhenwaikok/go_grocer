<%@ Page Title="" Language="C#" MasterPageFile="~/UserMasterPage.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="MWMAssignment.WebForm12" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Profile.css" type="text/css">
    <script>
        function showSuccessMessage() {
            alert('Successfully updated!');
            window.location.href = 'Profile.aspx';
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="profileContainer">
        <div class="title">
            <h1 class="profileTitle">Profile</h1>
        </div>

        <div class="yourInformation">
            <h1 class="yourInformationTitle">Your Information</h1>
            <hr />
        </div>

        <div class="profileDetails">
            <div class="input-form">
                 <h3 class="form-name">Username:</h3>
                 <asp:TextBox ID="username" runat="server" TextMode="SingleLine" placeholder="Username" CssClass="form-control"></asp:TextBox>
                 <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="Please enter username" ControlToValidate="username"  ForeColor="Red"></asp:RequiredFieldValidator>
             </div>

              <div class="input-form">
                 <h3 class="form-name">Email:</h3>
                 <asp:TextBox ID="email" runat="server" TextMode="Email" placeholder="Email" CssClass="form-control"></asp:TextBox>
                  <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="Please enter email" ControlToValidate="email"  ForeColor="Red"></asp:RequiredFieldValidator>
             </div>

             <div class="input-form">
                 <h3 class="form-name">Phone Number:</h3>
                 <asp:TextBox ID="phoneNum" runat="server" TextMode="Number" placeholder="Phone Number" CssClass="form-control" oninput="this.value = this.value.replace(/[^0-9]/g, '').substring(0,11);"></asp:TextBox>
                 <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ErrorMessage="Please enter phone number" ControlToValidate="phoneNum"  ForeColor="Red"></asp:RequiredFieldValidator>
             </div>

             <div class="input-form">
                 <h3 class="form-name">Password:</h3>
                 <asp:TextBox ID="password" runat="server" TextMode="SingleLine" placeholder="Password" CssClass="form-control"></asp:TextBox>
                  <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ErrorMessage="Please enter phone number" ControlToValidate="password"  ForeColor="Red"></asp:RequiredFieldValidator>
             </div>

             <div class="input-form">
                <h3 class="form-name">Gender:</h3>
                <asp:DropDownList ID="gender" runat="server" CssClass="form-control" style="width:99%;">
                    <asp:ListItem>Male</asp:ListItem>
                    <asp:ListItem>Female</asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ErrorMessage="Please select gender" ControlToValidate="gender"  ForeColor="Red"></asp:RequiredFieldValidator>
             </div>

             <div class="input-form">
                 <h3 class="form-name">Address:</h3>
                 <asp:TextBox ID="address" runat="server" TextMode="SingleLine" placeholder="Address" CssClass="form-control"></asp:TextBox>
                 <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Please enter address or '-' " ControlToValidate="address"  ForeColor="Red"></asp:RequiredFieldValidator>
             </div>

            <div class="saveButton">
                <asp:Button ID="saveBtn" runat="server" Text="Save" CssClass="saveBtn" OnClick="saveBtn_Click"/>
            </div>
        </div>

    </div>
</asp:Content>
