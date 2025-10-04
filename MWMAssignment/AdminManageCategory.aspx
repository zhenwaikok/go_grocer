<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.Master" AutoEventWireup="true" CodeBehind="AdminManageCategory.aspx.cs" Inherits="MWMAssignment.WebForm7" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="AdminManageCategory.css" type="text/css" />
    <script>
        function openCategoryModal() {
            var categoryModal = new bootstrap.Modal(document.getElementById('categoryModal'));
            categoryModal.show();
        }

        function showImagePreview(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    document.getElementById('<%= imagePreview.ClientID %>').src = e.target.result;
                    document.getElementById('<%= imagePreview.ClientID %>').style.display = 'block';
                }

                reader.readAsDataURL(input.files[0]);
            }
        }

        function showSuccessMessage(message) {
            alert(message);
            window.location.href = 'AdminManageCategory.aspx';
        }

        function showNameExistMessage() {
            alert('Category name exists!');
            window.location.href = 'AdminManageCategory.aspx';
        }

        function openToggleModal(categoryId, isActive) {
            document.getElementById('<%= hiddenCategoryId.ClientID %>').value = categoryId;

            var modalTitle = document.getElementById('deactivateModalTitle');
            var modalBodyText = document.getElementById('deactivateModalBody');
            var deactivateModal = new bootstrap.Modal(document.getElementById('deactivateModal'));
            deactivateModal.show();


            if (isActive) {
                modalTitle.textContent = "Deactivate category";
                modalBodyText.textContent = "Are you sure you want to deactive this category?";
            } else {
                modalTitle.textContent = "Activate category";
                modalBodyText.textContent = "Are you sure you want to activate this category?";
            }
        }

        function confirmDeactivation() {
            var toggleButtonId = document.getElementById('confirmDeactivateBtn').getAttribute('data-toggle-button');
            var toggleButton = document.getElementById(toggleButtonId).querySelector('i');

            if (toggleButton.classList.contains('bi-toggle-on')) {
                toggleButton.classList.remove('bi-toggle-on');
                toggleButton.classList.add('bi-toggle-off');
            } else {
                toggleButton.classList.remove('bi-toggle-off');
                toggleButton.classList.add('bi-toggle-on');
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="manageCategoryContainer">
        <div class="categoryTitle d-flex justify-content-between align-items-center">
            <h1>Manage Categories</h1>
            <asp:Button ID="addCategoryBtn" runat="server" Text="+ New Category" CssClass="addCategoryBtn"
                OnClientClick="openCategoryModal(); return false;" />
        </div>

        <div class="filterOption">
            <div class="container-fluid px-2">
                <div class="row gy-2 align-items-center">
                    <div class="col-12 col-md-6">
                        <div class="search-container">
                            <asp:TextBox ID="searchTextBox" runat="server" CssClass="form-control search-input" placeholder="Search..." AutoPostBack="True" OnTextChanged="searchTextBox_TextChanged"></asp:TextBox>
                        </div>
                    </div>

                    <div class="col-12 col-md-6 filter text-md-end">
                        <div class="d-flex align-items-center justify-content-between justify-content-md-end">
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

        <div class="modal" id="categoryModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title modalTitle">Add New Category</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="input-form">
                            <h3 class="form-name">Category Name</h3>
                            <asp:TextBox ID="categoryName" runat="server" TextMode="SingleLine" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="Please enter product name" ControlToValidate="categoryName" ForeColor="Red" ValidationGroup="ModalValidation"></asp:RequiredFieldValidator>
                        </div>

                        <div class="input-form">
                            <h3 class="form-name">Category Image</h3>
                            <asp:FileUpload ID="imageFileUpload" runat="server" accept="image/*" CssClass="form-control" onchange="showImagePreview(this)" />
                            <br />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Please upload category image" ControlToValidate="imageFileUpload" ForeColor="Red" ValidationGroup="ModalValidation"></asp:RequiredFieldValidator>
                            <br />
                            <asp:Image ID="imagePreview" runat="server" CssClass="imagePreview" />
                        </div>

                        <asp:Label ID="errMssg" runat="server" Text="[errMssg]" CssClass="errMsg" Visible="false"></asp:Label>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="cancelBtn" runat="server" Text="Cancel" CssClass="btn btn-secondary" data-bs-dismiss="modal" CausesValidation="false" />
                        <asp:Button ID="addBtn" runat="server" Text="Add" CssClass="addBtn" AutoPostBack="True" OnClick="addBtn_Click" ValidationGroup="ModalValidation" />
                    </div>
                </div>
            </div>
        </div>

        <div class="dataGrid">
            <div class="table-responsive">
                <asp:GridView ID="categoryDataGrid" runat="server" CssClass="categoryDataGrid table table-responsive table-bordered" AutoGenerateColumns="False" DataKeyNames="categoryId"
                    AllowPaging="True" PageSize="5" OnPageIndexChanging="categoryDataGrid_PageIndexChanging" PagerStyle-CssClass="paginationStyle">
                    <Columns>
                        <asp:BoundField DataField="categoryId" HeaderText="Category ID" InsertVisible="False" ReadOnly="True" SortExpression="categoryId" />
                        <asp:TemplateField HeaderText="Image">
                            <ItemTemplate>
                                <asp:Image ID="productImage" runat="server" ImageUrl='<%# ResolveUrl(Eval("image").ToString()) %>'
                                    Width="100px" Height="100px" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="categoryName" HeaderText="Category Name" SortExpression="categoryName" />
                        <asp:BoundField DataField="createdDate" HeaderText="Created Date" SortExpression="createdDate" />

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="d-flex justify-content-center gap-2 align-items-center">
                                    <asp:LinkButton ID="editIconBtn" runat="server" CssClass="editIconBtn"
                                        CommandArgument='<%# Eval("categoryId") %>' OnCommand="editBtn_Click">
                                    <i class="bi bi-pencil-square"></i>
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="toggleIconBtn" runat="server" CssClass="toggleIconBtn"
                                        CommandArgument='<%# Eval("categoryId") %>'
                                        OnClientClick='<%# String.Format("openToggleModal({0}, {1}); return false;", Eval("categoryId"), Convert.ToBoolean(Eval("isActive")).ToString().ToLower()) %>'>
                                    <i class='<%# Convert.ToBoolean(Eval("isActive")) ? "bi bi-toggle-on" : "bi bi-toggle-off" %>'></i>
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

        <div class="modal" id="deactivateModal" tabindex="-1" aria-labelledby="deactivateModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deactivateModalTitle">Deactivate category</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" id="deactivateModalBody">
                        Are you sure you want to deactive this category?
                    </div>
                    <div class="modal-footer">
                        <asp:HiddenField ID="hiddenCategoryId" runat="server" />
                        <asp:Button ID="cancelDeactivateBtn" runat="server" Text="Cancel" CssClass="btn btn-secondary" data-bs-dismiss="modal" />
                        <asp:Button ID="confirmBtn" runat="server" OnClick="confirmBtn_Click" Text="Confirm" CssClass="confirmBtn" />
                    </div>
                </div>
            </div>
        </div>

    </div>
</asp:Content>
