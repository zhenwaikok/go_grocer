<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.Master" AutoEventWireup="true" CodeBehind="AdminManageOrder.aspx.cs" Inherits="MWMAssignment.WebForm3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="AdminManageOrder.css" type="text/css" />
    <script>
        function showSuccessMessage() {
            alert('Order marked as shipped!');
            window.location.href = 'AdminManageOrder.aspx';
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="manageOrderContainer">
        <div class="orderTitle">
            <h1>Manage Orders</h1>
        </div>

        <div class="filterOption">
            <div class="container-fluid px-2">
                <div class="row gy-2 align-items-center">
                    <div class="col-12 col-md-6">
                        <div class="search-container">
                            <asp:TextBox ID="searchTextBox" runat="server" CssClass="form-control search-input" placeholder="Search..." AutoPostBack="True" OnTextChanged="searchTextBox_TextChanged"></asp:TextBox>
                        </div>
                    </div>

                    <div class="col-12 col-md-6 text-md-end">
                        <div class="d-flex align-items-center justify-content-between justify-content-md-end">
                            <asp:Label ID="Label" runat="server" Text="Sort by:"></asp:Label>
                            <asp:DropDownList ID="filterDropdown" runat="server" CssClass="filterDropdown w-auto" AutoPostBack="True" OnSelectedIndexChanged="filterDropdown_SelectedIndexChanged">
                                <asp:ListItem Selected="True">All</asp:ListItem>
                                <asp:ListItem>Pending</asp:ListItem>
                                <asp:ListItem>Shipped</asp:ListItem>
                                <asp:ListItem>Completed</asp:ListItem>
                                <asp:ListItem>Recently Created</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="dataGrid">
            <div class="table-responsive">
                <asp:GridView ID="orderDataGrid" runat="server" CssClass="orderDataGrid table table-bordered" AutoGenerateColumns="False" DataKeyNames="itemsOrderId"
                    AllowPaging="True" PageSize="5" OnPageIndexChanging="orderDataGrid_PageIndexChanging" PagerStyle-CssClass="paginationStyle" OnRowDataBound="orderDataGrid_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="itemsOrderId" HeaderText="Order ID" SortExpression="itemsOrderId" />
                        <asp:BoundField DataField="username" HeaderText="Customer" SortExpression="username" />
                        <asp:TemplateField HeaderText="Items" ItemStyle-HorizontalAlign="Left">
                            <ItemTemplate>
                                <asp:Repeater ID="itemsRepeater" runat="server" OnItemDataBound="itemsRepeater_ItemDataBound">
                                    <ItemTemplate>
                                        <div class="repeaterItem">
                                            <asp:Image ID="productImage" runat="server" CssClass="productImage" />
                                            <asp:Label ID="productNameLabel" runat="server" CssClass="productNameLabel"></asp:Label>
                                            <asp:Label ID="productQuantityLabel" runat="server" CssClass="productQuantityLabel"></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="totalPrice" HeaderText="Total" DataFormatString="RM{0:N2}" SortExpression="totalPrice" />
                        <asp:BoundField DataField="status" HeaderText="Status" SortExpression="status" />
                        <asp:BoundField DataField="createdDate" HeaderText="Created Date" SortExpression="createdDate" />

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="d-flex justify-content-center gap-2 align-items-center">
                                    <asp:Button ID="actionBtn" runat="server" Text="ACtion" CssClass="actionBtn"
                                        CommandArgument='<%# Eval("itemsOrderId") %>'
                                        OnCommand="actionBtn_Click" />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="table gridHeader" />
                </asp:GridView>
            </div>
        </div>

    <asp:Panel ID="noResultPanel" runat="server" Visible="false" CssClass="noResultContainer">
        <i class="bi bi-emoji-frown noResultIcon"></i>
        <p class="noResultText">Opps, no results found.</p>
    </asp:Panel>
    </div>
</asp:Content>
