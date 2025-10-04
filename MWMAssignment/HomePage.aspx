<%@ Page Title="" Language="C#" MasterPageFile="~/UserMasterPage.Master" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="MWMAssignment.WebForm9" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="HomePage.css" type="text/css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const scrollContainer = document.querySelector('.category-scroll');
            const prevButton = document.querySelector('.prev-btn');
            const nextButton = document.querySelector('.next-btn');

            const scrollAmount = 250;

            prevButton.style.display = 'none';

            prevButton.addEventListener('click', function () {
                scrollContainer.scrollBy({
                    left: -scrollAmount,
                    behavior: 'smooth'
                });
            });

            nextButton.addEventListener('click', function () {
                scrollContainer.scrollBy({
                    left: scrollAmount,
                    behavior: 'smooth'
                });
            });

            scrollContainer.addEventListener('scroll', function () {
                if (scrollContainer.scrollLeft <= 0) {
                    prevButton.style.display = 'none';
                } else {
                    prevButton.style.display = 'block';
                }
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="homePageContainer">
        <div class="weclomeTitle">
            <asp:Label ID="welcomeMessage" runat="server" Text="Welcome" CssClass="welcomeMessage"></asp:Label>
        </div>

        <div id="carouselExampleAutoplaying" class="carousel slide" data-bs-ride="carousel" data-bs-interval="2000">
            <div class="carousel-indicators">
                <button type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
                <button type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide-to="1" aria-label="Slide 2"></button>
            </div>
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="Images/carouselImage1.jpeg" class="d-block w-100 carouselImage" alt="...">
                </div>
                <div class="carousel-item">
                    <img src="Images/carouselImage2.jpeg" class="d-block w-100 carouselImage" alt="...">
                </div>
            </div>
        </div>

        <div class="categoryContainer">
            <div class="categoryTitle">
                <h3 class="title">Our Categories</h3>
            </div>
            <div class="position-relative">
                <div class="category-scroll d-flex overflow-auto">
                    <button class="btn prev-btn position-absolute" type="button" aria-label="Previous">
                        <i class="bi bi-chevron-left"></i>
                    </button>
                    <asp:Repeater ID="categoryList" runat="server">
                        <ItemTemplate>
                            <div class="category-item">
                                <asp:LinkButton ID="categoryLinkButton" runat="server" CssClass="text-decoration-none"
                                    CommandArgument='<%# Eval("categoryId") %>' OnCommand="categoryLinkButton_Click">
                                    <div class="card category-card text-white">
                                        <img src='<%# ResolveUrl(Eval("image").ToString()) %>' alt='<%# Eval("categoryName") %>' class="card-img categoryImage" />
                                        <div class="categoryNameContainer">
                                            <h5 class="categoryName">
                                                <%# Eval("categoryName") %>
                                            </h5>
                                        </div>
                                    </div>
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <button class="btn next-btn position-absolute" type="button" aria-label="Next">
                    <i class="bi bi-chevron-right"></i>
                </button>
            </div>
        </div>

        <div class="bestSellingProductContainer">
            <div class="bestSellingTitle">
                <h3 class="title">Featured Products 👍</h3>
            </div>
            <div class="row">
                <asp:Repeater ID="productListRepeater" runat="server">
                    <ItemTemplate>
                        <div class="productList col-6 col-sm-6 col-md-4 col-lg-2 mb-4">
                            <asp:LinkButton ID="productCardButton" runat="server" CssClass="text-decoration-none productCardButton" 
                                CommandArgument='<%# Eval("productId") %>' OnCommand="productCardButton_Click">
                                <div class="productCard text-black">
                                    <div class="image">
                                        <asp:Image ID="productImage" runat="server" CssClass="productImage" ImageUrl='<%# Eval("image") %>' />
                                    </div>

                                    <div class="name">
                                        <asp:Label ID="productName" runat="server" Text='<%# Eval("productName") %>' CssClass="productName"></asp:Label>
                                    </div>

                                    <div class="price">
                                        <asp:Label ID="productPrice" runat="server" Text='<%# "RM " + Eval("price") %>' CssClass="productPrice"></asp:Label>
                                    </div>
                                </div>
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <div class="alwaysBestToBuyContainer">
            <div class="alwaysBestToBuyTitle d-flex justify-content-between">
                <h3 class="title">Always Best To Buy</h3>
                <asp:LinkButton ID="viewAllBtn" runat="server" CssClass="viewAllBtn" OnClick="viewAllBtn_Click">View All</asp:LinkButton>
            </div>
            <div class="row">
                <asp:Repeater ID="alwaysBestToBuyRepeater" runat="server">
                    <ItemTemplate>
                        <div class="productList col-6 col-sm-6 col-md-4 col-lg-2 mb-4">
                            <asp:LinkButton ID="productCardButton" runat="server" CssClass="text-decoration-none productCardButton"
                                CommandArgument='<%# Eval("productId") %>' OnCommand="productCardButton_Click">
                                <div class="productCard text-black">
                                    <div class="image">
                                        <asp:Image ID="alwaysBestToBuyProductImage" runat="server" CssClass="productImage" ImageUrl='<%# Eval("image") %>' />
                                    </div>

                                    <div class="name">
                                        <asp:Label ID="alwaysBestToBuyProductName" runat="server" Text='<%# Eval("productName") %>' CssClass="productName"></asp:Label>
                                    </div>

                                    <div class="price">
                                        <asp:Label ID="alwaysBestToBuyProductPrice" runat="server" Text='<%# "RM " + Eval("price") %>' CssClass="productPrice"></asp:Label>
                                    </div>
                                </div>
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>
</asp:Content>
