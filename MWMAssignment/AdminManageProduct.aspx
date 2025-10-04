<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.Master" AutoEventWireup="true" CodeBehind="AdminManageProduct.aspx.cs" Inherits="MWMAssignment.WebForm5" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="AdminManageProduct.css" type="text/css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <script>
        function openProductModal() {
            var productModal = new bootstrap.Modal(document.getElementById('productModal'));
            productModal.show();
        }

        function showSuccessMessage() {
            alert('Successfully added new product!');
            window.location.href = 'AdminManageProduct.aspx';
        }

        function showSuccessDltMessage() {
            alert('Deleted successfully!');
            window.location.href = 'AdminManageProduct.aspx';
        }

        function openDeleteModal(productId) {
            document.getElementById('<%= hiddenProductId.ClientID %>').value = productId;
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div class="manageProductContainer">
        <div class="userTitle d-flex justify-content-between align-items-center">
            <h1>Manage Products</h1>
            <asp:Button ID="addProductBtn" runat="server" Text="+ New Product" CssClass="addProductBtn"
                OnClientClick="openProductModal(); return false;"/>
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
                        <asp:DropDownList ID="filterDropdown" runat="server" CssClass="filterDropdown w-auto" AutoPostBack="True" OnSelectedIndexChanged="filterDropdown_SelectedIndexChanged" >
                            <asp:ListItem Selected="True">All</asp:ListItem>
                            <asp:ListItem>Name: A-Z</asp:ListItem>
                            <asp:ListItem>Recently Created</asp:ListItem>
                            <asp:ListItem>Price: Low-High</asp:ListItem>
                            <asp:ListItem>Price: High-Low</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
              </div>
            </div>
        </div>

         <div class="modal" id="productModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title modalTitle">Add New Product</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="input-form">
                            <h3 class="form-name">Product Name</h3>
                            <asp:TextBox ID="productName" runat="server" TextMode="SingleLine" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="Please enter product name" ControlToValidate="productName"  ForeColor="Red" ValidationGroup="ModalValidation"></asp:RequiredFieldValidator>
                        </div>

                         <div class="input-form">
                            <h3 class="form-name">Description</h3>
                             <asp:TextBox ID="description" runat="server" TextMode="MultiLine" CssClass="descriptionTextBox form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Please enter product description" ControlToValidate="description"  ForeColor="Red" ValidationGroup="ModalValidation"></asp:RequiredFieldValidator>
                         </div>

                        <div class="input-form">
                            <h3 class="form-name">Category</h3>
                            <asp:DropDownList ID="category" runat="server" CssClass="form-control"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ErrorMessage="Please select product category" ControlToValidate="category"  ForeColor="Red" ValidationGroup="ModalValidation"></asp:RequiredFieldValidator>
                         </div>

                        <div class="input-form">
                            <h3 class="form-name">Price</h3>
                            <asp:TextBox ID="price" runat="server" TextMode="Number" CssClass="form-control" step="any"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Please enter product price" ControlToValidate="price"  ForeColor="Red" ValidationGroup="ModalValidation"></asp:RequiredFieldValidator>
                         </div>

                        <div class="input-form">
                            <h3 class="form-name">Product Image</h3>
                            <asp:FileUpload ID="imageFileUpload" runat="server" accept="image/*" CssClass="form-control" onchange="showImagePreview(this)"/>
                            <br />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Please upload product image" ControlToValidate="imageFileUpload"  ForeColor="Red" ValidationGroup="ModalValidation"></asp:RequiredFieldValidator>
                            <br />
                            <asp:Image ID="imagePreview" runat="server" CssClass="imagePreview"/>
                         </div>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="cancelBtn" runat="server" Text="Cancel" CssClass="btn btn-secondary" data-bs-dismiss="modal" CausesValidation="false"/>
                        <asp:Button ID="addBtn" runat="server" Text="Add" CssClass="addBtn" OnClick="addBtn_Click" ValidationGroup="ModalValidation"/>
                    </div>

                    <asp:Label ID="errMssg" runat="server" Text="[errMssg]" CssClass="errMsg" Visible="false"></asp:Label>

                </div>
            </div>
        </div>

        <div class="dataGrid">
            <div class="table-responsive">
            <asp:GridView ID="productDataGrid" runat="server" CssClass="productDataGrid table table-responsive table-bordered" AutoGenerateColumns="False" DataKeyNames="productId"
                AllowPaging="True" PageSize="5" OnPageIndexChanging="productDataGrid_PageIndexChanging" PagerStyle-CssClass="paginationStyle">
                <Columns>
                    <asp:BoundField DataField="productId" HeaderText="Product ID" InsertVisible="False" ReadOnly="True" SortExpression="productId" />
                    <asp:TemplateField HeaderText="Image">
                        <ItemTemplate>
                            <asp:Image ID="productImage" runat="server" ImageUrl='<%# ResolveUrl(Eval("image").ToString()) %>'
                                Width="100px" Height="100px" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="productName" HeaderText="Name" SortExpression="productName" />
                    <asp:BoundField DataField="description" HeaderText="Description" SortExpression="description" />
                    <asp:BoundField DataField="categoryName" HeaderText="Category" SortExpression="categoryName" />
                    <asp:BoundField DataField="price" HeaderText="Price" SortExpression="price" />
                    <asp:BoundField DataField="createdDate" HeaderText="Created Date" SortExpression="createdDate" />

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="d-flex justify-content-center gap-2 align-items-center">
                                <asp:LinkButton ID="editIconBtn" runat="server" CssClass="editIconBtn" 
                                    CommandArgument='<%# Eval("productId") %>' OnCommand="editBtn_Click" >
                                    <i class="bi bi-pencil-square"></i>
                                </asp:LinkButton>

                                <asp:LinkButton ID="deleteIconBtn" runat="server" CssClass="deleteIconBtn" 
                                    CommandArgument='<%# Eval("productId") %>' 
                                    OnClientClick='<%# "openDeleteModal(\"" + Eval("productId") + "\"); return false;" %>'>
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
                        <h5 class="modal-title">Product Delete Confirmation</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Do you really want to delete this product? This action can't be undo.</p>
                    </div>
                    <div class="modal-footer">
                        <asp:HiddenField ID="hiddenProductId" runat="server" />
                        <asp:Button ID="Button1" runat="server" Text="Cancel" CssClass="btn btn-secondary" data-bs-dismiss="modal" />
                        <asp:Button ID="deleteBtn" runat="server" Text="Delete" CssClass="deleteBtn" OnClick="deleteBtn_Click"/>
                    </div>
                </div>
            </div>
        </div>
        
    </div>
</asp:Content>
