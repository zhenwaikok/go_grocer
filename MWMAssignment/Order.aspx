<%@ Page Title="" Language="C#" MasterPageFile="~/UserMasterPage.Master" AutoEventWireup="true" CodeBehind="Order.aspx.cs" Inherits="MWMAssignment.WebForm14" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Order.css" type="text/css" />
    <script>
        function showSuccessMessage(customerId) {
            alert('Order received, thank you!');
            window.location.href = 'Order.aspx?customerId=' + customerId + '&status=' + '';
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="orderContainer">
        <div class="orderTitle">
            <h1 class="orderTitleText">Order</h1>
        </div>

        <hr />
        <div class="orderStatusSelection row justify-content-center d-flex flex-nowrap">
            <div class="col-auto">
                <asp:LinkButton ID="allBtn" runat="server" CssClass="orderStatusSelectionBtn" OnClick="allBtn_Click">All</asp:LinkButton>
            </div>
            <div class="col-auto">
                <asp:LinkButton ID="toShipBtn" runat="server" CssClass="orderStatusSelectionBtn" OnClick="toShipBtn_Click">To Ship</asp:LinkButton>
            </div>
            <div class="col-auto">
                <asp:LinkButton ID="toReceiveBtn" runat="server" CssClass="orderStatusSelectionBtn" OnClick="toReceiveBtn_Click">To Receive</asp:LinkButton>
            </div>
            <div class="col-auto">
                <asp:LinkButton ID="completedBtn" runat="server" CssClass="orderStatusSelectionBtn" OnClick="completedBtn_Click">Completed</asp:LinkButton>
            </div>
        </div>
        <hr />

        <asp:Panel ID="noOrderPanel" runat="server" Visible="false" CssClass="noOrderPanel">
            <asp:Label ID="noOrderLabel" runat="server" Text="You have no any order yet." CssClass="noOrderLabel"></asp:Label>
        </asp:Panel>

        <div class="orderDetails">
            <div class="orderDetails">
                <div class="row">
                    <asp:Repeater ID="orderDetailsRepeater" runat="server" OnItemDataBound="orderDetailsRepeater_ItemDataBound">
                        <ItemTemplate>
                            <div class="col-12 mb-2">
                                <div class="orderCard mb-4">
                                    <div class="orderStatus d-flex justify-content-between">
                                        <asp:Label ID="orderIdTitle" runat="server" Text="Order ID" CssClass="orderIdTitle"></asp:Label>
                                        <asp:Label ID="statusLabel" runat="server" Text='<%# Eval("status") %>' CssClass="statusLabel"></asp:Label>
                                    </div>

                                    <div class="orderId">
                                        <asp:Label ID="orderIdLabel" runat="server" Text='<%# "#" + Eval("itemsOrderId") %>' CssClass="orderIdLabel"></asp:Label>
                                        <br />
                                        <asp:Label ID="orderDateLabel" runat="server" Text='<%# "Order Date: " + Eval("createdDate") %>' CssClass="orderDateLabel"></asp:Label>
                                        <hr />
                                    </div>

                                    <asp:Repeater ID="orderItemsRepeater" runat="server" OnItemDataBound="orderItemsRepeater_ItemDataBound">
                                        <ItemTemplate>
                                            <div class="orderItemDetails d-flex">
                                                <div class="image">
                                                    <asp:Image ID="productImage" runat="server" CssClass="productImage" />
                                                </div>

                                                <div class="itemDetails flex-column">
                                                    <div class="name mb-1">
                                                        <asp:Label ID="productName" runat="server" Text='' CssClass="productname"></asp:Label>
                                                    </div>

                                                    <div class="quantity mb-1">
                                                        <asp:Label ID="productQuantity" runat="server" Text='' CssClass="productQuantity"></asp:Label>
                                                    </div>

                                                    <div class="price">
                                                        <asp:Label ID="productPrice" runat="server" Text='' CssClass="productPrice"></asp:Label>
                                                    </div>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>

                                    <hr />

                                    <div class="orderTotal d-flex justify-content-between">
                                        <div style="margin-right: 10px;">
                                            <asp:Button ID="orderReceivedBtn" runat="server" Text="Order Received" 
                                                CssClass="orderReceivedBtn" 
                                                Visible='<%# Eval("status").ToString() == "Shipped" %>' 
                                                CommandArgument='<%# Eval("itemsOrderId") %>'
                                                OnCommand="orderReceivedBtn_Click"/>
                                        </div>
                                        <div style="align-content: end">
                                            <asp:Label ID="orderTotalTitle" runat="server" Text="Order total:" CssClass="orderTotalTitle"></asp:Label>
                                            <asp:Label ID="orderTotalPrice" runat="server" Text='<%# "RM " + Eval("totalPrice") %>' CssClass="orderTotalPrice"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
