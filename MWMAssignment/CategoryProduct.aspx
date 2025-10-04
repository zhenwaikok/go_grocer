<%@ Page Title="" Language="C#" MasterPageFile="~/UserMasterPage.Master" AutoEventWireup="true" CodeBehind="CategoryProduct.aspx.cs" Inherits="MWMAssignment.WebForm10" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="CategoryProduct.css" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="categoryProductContainer">
        <div class="categoryTitle">
            <asp:Label ID="categoryTitleLabel" runat="server" Text="Category" CssClass="categoryTitleLabel"></asp:Label>
        </div>

        <div class="productsContainer">
            <div class="filterOption">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-12 col-sm-6 col-md-6 filter text-sm-start mb-2">
                            <div class="d-flex align-items-center">
                                <asp:Label ID="Label" runat="server" Text="Sort by:"></asp:Label>
                                <asp:DropDownList ID="filterDropdown" runat="server" CssClass="filterDropdown w-auto" AutoPostBack="True" OnSelectedIndexChanged="filterDropdown_SelectedIndexChanged">
                                    <asp:ListItem Selected="True">All</asp:ListItem>
                                    <asp:ListItem>Name: A-Z</asp:ListItem>
                                    <asp:ListItem>Price: Low-High</asp:ListItem>
                                    <asp:ListItem>Price: High-Low</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="col-12 col-sm-6 col-md-6 text-md-end">
                            <div class="search-container d-flex justify-content-md-end">
                                <div class="col-12 col-sm-12 col-md-4">
                                    <asp:TextBox ID="searchTextBox" runat="server" CssClass="form-control search-input" placeholder="Search..." AutoPostBack="True" OnTextChanged="searchTextBox_TextChanged"></asp:TextBox>
                                </div>

                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <div class="productListContainer">
                <div class="row">
                    <asp:Repeater ID="productListRepeater" runat="server">
                        <ItemTemplate>
                            <div class="productList col-6 col-sm-6 col-md-4 col-lg-2 mb-4">
                                <asp:LinkButton ID="productCardButton" runat="server" 
                                    CssClass="text-decoration-none productCardButton" 
                                    CommandArgument='<%# Eval("productId") %>'
                                    OnCommand="productCardButton_Clicked">
                                    <div class="productCard text-black">
                                        <div class="image">
                                            <asp:Image ID="ProductImage" runat="server" CssClass="productImage" ImageUrl='<%# Eval("image") %>' />
                                        </div>

                                        <div class="name">
                                            <asp:Label ID="ProductName" runat="server" Text='<%# Eval("productName") %>' CssClass="productName"></asp:Label>
                                        </div>

                                        <div class="price">
                                            <asp:Label ID="ProductPrice" runat="server" Text='<%# "RM " + Eval("price") %>' CssClass="productPrice"></asp:Label>
                                        </div>
                                    </div>
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            
            <asp:Panel ID="noResultPanel" runat="server" Visible="false" CssClass="noResultContainer">
                <i class="bi bi-emoji-frown noResultIcon"></i>
                <br />
                <asp:Label ID="noResultText" runat="server" Text="Opps, no result found!" CssClass="noResultText"></asp:Label>
            </asp:Panel>
        </div>
    </div>
</asp:Content>
