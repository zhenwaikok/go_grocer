<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.Master" AutoEventWireup="true" CodeBehind="AdminManageFeedback.aspx.cs" Inherits="MWMAssignment.WebForm16" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="AdminManageFeedback.css" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="manageFeedbackContainer">
        <div class="feedbackTitle">
            <h1>Manage Feedbacks</h1>
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
                        <div class="d-flex align-items-center justify-content-between justify-content-md-end sortBy">
                            <asp:Label ID="Label" runat="server" Text="Sort by:"></asp:Label>
                            <asp:DropDownList ID="filterDropdown" runat="server" CssClass="filterDropdown w-auto" AutoPostBack="True" OnSelectedIndexChanged="filterDropdown_SelectedIndexChanged">
                                <asp:ListItem Selected="True">Product</asp:ListItem>
                                <asp:ListItem>Website</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="dataGrid">
            <div class="table-responsive">
                <asp:GridView ID="productReviewDataGrid" runat="server" CssClass="productReviewDataGrid table table-bordered" AutoGenerateColumns="False"
                    AllowPaging="True" PageSize="5" OnPageIndexChanging="productReviewDataGrid_PageIndexChanging" PagerStyle-CssClass="paginationStyle">
                    <Columns>
                        <asp:BoundField DataField="productId" HeaderText="Product ID" SortExpression="productId" />
                        <asp:BoundField DataField="productName" HeaderText="Product Name" SortExpression="productName" />
                        <asp:TemplateField HeaderText="Image">
                            <ItemTemplate>
                                <asp:Image ID="productImage" runat="server" ImageUrl='<%# ResolveUrl(Eval("image").ToString()) %>'
                                    Width="100px" Height="100px" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="numOfReviews" HeaderText="Number of reviews" SortExpression="numOfReviews" />

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="d-flex justify-content-center gap-2 align-items-center">
                                    <asp:LinkButton ID="viewIconBtn" runat="server" CssClass="viewIconBtn"
                                        CommandArgument='<%# Eval("productId") %>'
                                        OnCommand="viewIconBtn_Click">
                                    <i class="bi bi-eye-fill"></i>  
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="table gridHeader" />
                </asp:GridView>

                <asp:GridView ID="websiteFeedbackDataGrid" runat="server" CssClass="websiteFeedbackDataGrid table table-bordered"
                    AutoGenerateColumns="False" AllowPaging="True" PageSize="5" Visible="false"
                    OnPageIndexChanging="websiteFeedbackDataGrid_PageIndexChanging" PagerStyle-CssClass="paginationStyle">
                    <Columns>
                        <asp:BoundField DataField="feedbackId" HeaderText="Feedback ID" SortExpression="feedbackId" />
                        <asp:BoundField DataField="feedbackType" HeaderText="Feedback Type" SortExpression="feedbackType" />
                        <asp:BoundField DataField="username" HeaderText="Username" SortExpression="username" />
                        <asp:BoundField DataField="createdDate" HeaderText="Created Date" SortExpression="createdDate" />
                    </Columns>
                    <HeaderStyle CssClass="table gridHeader" />
                </asp:GridView>
            </div>
        </div>


        <asp:Panel ID="noResultPanel" runat="server" Visible="false" CssClass="noResultContainer">
            <i class="bi bi-emoji-frown noResultIcon"></i>
            <p class="noResultText">Opps, no results found.</p>
        </asp:Panel>

        <div class="modal" id="deleteModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">User Account Delete Confirmation</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Do you really want to delete this user? This action can't be undo.</p>
                    </div>
                    <div class="modal-footer">
                        <asp:HiddenField ID="hiddenCustomerId" runat="server" />
                        <asp:Button ID="cancelBtn" runat="server" Text="Cancel" CssClass="btn btn-secondary" data-bs-dismiss="modal" />
                        <asp:Button ID="deleteBtn" runat="server" Text="Delete" CssClass="deleteBtn" />
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
