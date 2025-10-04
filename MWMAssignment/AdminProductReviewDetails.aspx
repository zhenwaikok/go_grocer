<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.Master" AutoEventWireup="true" CodeBehind="AdminProductReviewDetails.aspx.cs" Inherits="MWMAssignment.WebForm17" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="AdminProductReviewDetails.css" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="productReviewDetailsContainer">
        <div class="modal-header">
            <h5 class="modal-title modalTitle">Product Review Details</h5>
        </div>

        <div class="modal-body">
            <div class="image">
                <asp:Image ID="productImage" runat="server" CssClass="productImage" Width="200px" Height="200px" />
            </div>

            <div class="productName">
                <asp:Label ID="productNameLabel" runat="server" CssClass="productNameLabel"></asp:Label>
            </div>

            <div class="reviewTitle">
                <asp:Label ID="reviewTitleLabel" runat="server" Text="Review:" CssClass="reviewTitleLabel"></asp:Label>
            </div>

            <div class="dataGrid">
                <div class="table-responsive">
                    <asp:GridView ID="productReviewDataGrid" runat="server" CssClass="productReviewDataGrid table table-bordered" AutoGenerateColumns="False" DataKeyNames="reviewId"
                        AllowPaging="True" PageSize="5" OnPageIndexChanging="productReviewDataGrid_PageIndexChanging" PagerStyle-CssClass="paginationStyle">
                        <Columns>
                            <asp:BoundField DataField="reviewId" HeaderText="Review ID" SortExpression="reviewId" />
                            <asp:BoundField DataField="username" HeaderText="Username" SortExpression="username" />
                            <asp:BoundField DataField="reviewMssg" HeaderText="Review Message" SortExpression="reviewMssg" />
                            <asp:BoundField DataField="createdDate" HeaderText="Created Date" SortExpression="createdDate" />
                        </Columns>
                        <HeaderStyle CssClass="table gridHeader" />
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
