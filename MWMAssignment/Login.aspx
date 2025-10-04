<%@ Page Title="" Language="C#" MasterPageFile="~/UserMasterPage.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="MWMAssignment.Guest.WebForm1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" href="LoginRegistration.css" type="text/css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loginRegisterContainer">
        <div class="row">
            <div class="col-xl-6 col-sm-12  d-flex align-items-center justify-content-center">
               <img src="Images/logo.png" />
            </div>
            <div class="col-xl-6 col-sm-12 login-col">
                 <h1 class="loginTitle">Log In</h1>
                 <p class="description">Enter your username and password to log in!</p>

                 <div class="input-form">
                     <h3 class="form-name">Username:</h3>
                     <asp:TextBox ID="username" runat="server" TextMode="SingleLine" placeholder="Username" CssClass="form-control"></asp:TextBox>
                     <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Please enter username" ControlToValidate="username" ForeColor="Red"></asp:RequiredFieldValidator>
                 </div>

                  <div class="input-form">
                     <h3 class="form-name">Password:</h3>
                     <asp:TextBox ID="password" runat="server" TextMode="Password" placeholder="Password" CssClass="form-control"></asp:TextBox>
                      <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="Please enter password" ControlToValidate="password" ForeColor="Red"></asp:RequiredFieldValidator>
                 </div>
         
                 <asp:Button ID="loginBtn" runat="server" Text="Log In" CssClass="loginRegisterBtn" OnClick="loginBtn_Click"/>

                 <asp:Label ID="errMssg" runat="server" Text="[errMssg]" CssClass="errMsg" Visible="false"></asp:Label>

                 <asp:LinkButton ID="registerBtn" runat="server" CssClass="linkBtn" CausesValidation="false" OnClick="registerBtn_Click"> <span class="first-span">New customer?</span> <span class="second-span">Register Now</span> </asp:LinkButton>

            </div>
        </div>
    </div>
</asp:Content>
