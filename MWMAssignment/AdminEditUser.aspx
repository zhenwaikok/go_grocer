<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.Master" AutoEventWireup="true" CodeBehind="AdminEditUser.aspx.cs" Inherits="MWMAssignment.WebForm15" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="AdminEditUser.css" type="text/css" />
    <script>
        function showSuccessMessage() {
            alert('Successfully updated!');
            window.location.href = 'AdminManageUser.aspx';
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div class="editUserContainer">
        <div class="modal-header">
            <h5 class="modal-title modalTitle">Edit User Details</h5>
        </div>
        <div class="modal-body">
            <div class="input-form">
                 <h3 class="form-name">Username:</h3>
                 <asp:TextBox ID="username" runat="server" TextMode="SingleLine" placeholder="Username" CssClass="form-control" Enabled="false"></asp:TextBox>
                <br />
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
                 <asp:TextBox ID="password" runat="server" TextMode="Singleline"  placeholder="Password" CssClass="form-control"  Enabled="false"></asp:TextBox>
                <br />
             </div>

             <div class="input-form">
                <h3 class="form-name">Gender:</h3>
                <asp:DropDownList ID="gender" runat="server" CssClass="form-control" Enabled="false" style="width:99%;">
                    <asp:ListItem>Male</asp:ListItem>
                    <asp:ListItem>Female</asp:ListItem>
                </asp:DropDownList>
                <br />
             </div>

             <div class="input-form">
                 <h3 class="form-name">Address:</h3>
                 <asp:TextBox ID="address" runat="server" TextMode="SingleLine" placeholder="Address" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Please enter address" ControlToValidate="address"  ForeColor="Red"></asp:RequiredFieldValidator>
             </div>
        </div>
        <div class="modal-footer">
            <asp:Button ID="cancelBtn" runat="server" Text="Cancel" CssClass="btn btn-secondary" CausesValidation="false" OnClick="cancelBtn_Click" />
            <asp:Button ID="saveBtn" runat="server" Text="Save" CssClass="saveBtn" OnClick="saveBtn_Click" />
        </div>
    </div>
</asp:Content>
