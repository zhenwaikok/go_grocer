<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.Master" AutoEventWireup="true" CodeBehind="AdminManageUser.aspx.cs" Inherits="MWMAssignment.WebForm4" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="AdminManageUser.css" type="text/css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <script>
        function openDeleteModal(customerId) {
            document.getElementById('<%= hiddenCustomerId.ClientID %>').value = customerId;
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }

        function showSuccessDltMessage() {
            alert('Deleted successfully!');
            window.location.href = 'AdminManageUser.aspx';
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="manageUserContainer">
        <div class="userTitle">
            <h1>Manage Users</h1>
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
                                <asp:ListItem Selected="True">All</asp:ListItem>
                                <asp:ListItem>Name: A-Z</asp:ListItem>
                                <asp:ListItem>Recently Created</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="dataGrid">
            <div class="table-responsive">
                <asp:GridView ID="userDataGrid" runat="server" CssClass="userDataGrid table table-bordered" AutoGenerateColumns="False" DataKeyNames="customerId"
                    AllowPaging="True" PageSize="5" OnPageIndexChanging="userDataGrid_PageIndexChanging" PagerStyle-CssClass="paginationStyle">
                    <Columns>
                        <asp:BoundField DataField="customerId" HeaderText="Customer ID" InsertVisible="False" ReadOnly="True" SortExpression="customerId" />
                        <asp:BoundField DataField="username" HeaderText="Username" SortExpression="username" />
                        <asp:BoundField DataField="email" HeaderText="Email" SortExpression="email" />
                        <asp:BoundField DataField="phoneNum" HeaderText="Phone Number" SortExpression="phoneNum" />
                        <asp:TemplateField HeaderText="Password">
                            <ItemTemplate>
                                <%# new string('*', Eval("password").ToString().Length) %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="gender" HeaderText="Gender" SortExpression="gender" />
                        <asp:BoundField DataField="address" HeaderText="Address" SortExpression="address" />
                        <asp:BoundField DataField="createdDate" HeaderText="Created Date" SortExpression="createdDate" />

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="d-flex justify-content-center gap-2 align-items-center">
                                    <asp:LinkButton ID="editIconBtn" runat="server" CssClass="editIconBtn"
                                        CommandArgument='<%# Eval("customerId") %>'
                                        OnCommand="editIconBtn_Click">
                                <i class="bi bi-pencil-square"></i>
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="deleteIconBtn" runat="server" CssClass="deleteIconBtn"
                                        CommandArgument='<%# Eval("customerId") %>'
                                        OnClientClick='<%# "openDeleteModal(\"" + Eval("customerId") + "\"); return false;" %>'>
                                <i class="bi bi-trash-fill deleteIcon"></i>
                                    </asp:LinkButton>

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
                        <asp:Button ID="deleteBtn" runat="server" Text="Delete" CssClass="deleteBtn" OnClick="deleteBtn_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
