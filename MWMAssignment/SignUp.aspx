<%@ Page Title="" Language="C#" MasterPageFile="~/UserMasterPage.Master" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="MWMAssignment.Guest.WebForm2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="LoginRegistration.css" type="text/css">
    <script type="text/javascript">
        function showSuccessMessage() {
            alert('Successfully registered!');
            window.location.href = 'Login.aspx';
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loginRegisterContainer">
        <div class="row">
            <div class="col-xl-6 col-sm-12  d-flex align-items-center justify-content-center">
               <img src="Images/logo.png" />
            </div>
            <div class="col-xl-6 col-sm-12 login-col">
                <h1 class="title">Sign Up</h1>
             <p class="description">Enter your details to be our member!</p>

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
                 <asp:TextBox ID="password" runat="server" TextMode="Password" placeholder="Password" CssClass="form-control"></asp:TextBox>
                  <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ErrorMessage="Please enter password" ControlToValidate="password"  ForeColor="Red"></asp:RequiredFieldValidator>
             </div>

             <div class="input-form">
                <h3 class="form-name">Select your gender:</h3>
                <asp:DropDownList ID="gender" runat="server" CssClass="form-control" style="width:99%;">
                    <asp:ListItem Value="" Disabled="True" Selected="True">Select your gender</asp:ListItem>
                    <asp:ListItem>Male</asp:ListItem>
                    <asp:ListItem>Female</asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ErrorMessage="Please select gender" ControlToValidate="gender"  ForeColor="Red"></asp:RequiredFieldValidator>
             </div>

             <asp:Button ID="registerBtn" runat="server" Text="Register" CssClass="loginRegisterBtn" OnClick="registerBtn_Click"/>

             <asp:Label ID="errMssg" runat="server" Text="[errMssg]" CssClass="errMsg" Visible="false"></asp:Label>
             
             <asp:LinkButton ID="loginBtn" runat="server" CssClass="linkBtn" CausesValidation="false" OnClick="loginBtn_Click"> <span class="first-span">Already have an account?</span> <span class="second-span">Log In</span> </asp:LinkButton>

            </div>
        </div>
    </div>
</asp:Content>