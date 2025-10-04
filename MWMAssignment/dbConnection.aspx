<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="dbConnection.aspx.cs" Inherits="MWMAssignment.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:SqlDataSource ID="userDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [customerTable]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="adminDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [adminTable]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="feedbackDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [feedbackTable]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="productDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [productTable]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="categoryDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [categoryTable]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="cartDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [cartTable]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="orderDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [orderTable]"></asp:SqlDataSource>
        </div>
    </form>
</body>
</html>
