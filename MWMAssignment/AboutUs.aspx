<%@ Page Title="" Language="C#" MasterPageFile="~/UserMasterPage.Master" AutoEventWireup="true" CodeBehind="AboutUs.aspx.cs" Inherits="MWMAssignment.WebForm18" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="AboutUs.css" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="about">
        <div class="about-content">
            <h1>About GoGrocer</h1>
            <div class="content">
                <p>
                    GoGrocer is your trusted online grocery platform, offering a seamless shopping experience with a wide range of fresh produce, 
                household essentials, and daily necessities. We prioritize quality, convenience, and affordability, 
                ensuring that you get the best products delivered right to your doorstep. With a commitment to sustainability and customer satisfaction, 
                GoGrocer makes grocery shopping easier, faster, and more reliable.
                </p>
            </div>

        </div>
    </div>


    <div class="ourBackground">
        <h1>Our Background</h1>
        <div class="background-content">
            <p>
                GoGrocer was founded with the mission to revolutionize the grocery shopping experience by bringing convenience to customers through an online platform. 
                Understanding the challenges of busy lifestyles, GoGrocer provides a reliable and efficient solution for purchasing fresh produce, 
                pantry staples, and household essentials. With a focus on quality, affordability, and fast delivery, GoGrocer continues to grow, 
                serving communities with a seamless and user-friendly shopping experience.
            </p>
        </div>
    </div>


    <div class="goGrocerWay">
        <h1>Why Choose Us?</h1>
        <div class="goGrocerWay-content">

            <div class="card">
                <img src="Images/convenience.jpg" />
                <div style="text-align: center;">
                    <h2>Convenience & Accessibility</h2>
                    <p>Easily browse and order groceries anytime, anywhere, without the need to visit a store.</p>
                </div>
            </div>

            <div class="card">
                <img src="Images/delivery.jpg" />
                <div style="text-align: center;">
                    <h2>Fast & Reliable Delivery</h2>
                    <p>With same-day and scheduled delivery options, groceries arrive fresh and on time at your doorstep.</p>
                </div>
            </div>

            <div class="card">
                <img src="Images/freshness.jpg" />
                <div style="text-align: center;">
                    <h2>Freshness & Quality Assurance</h2>
                    <p>We source only the best-quality produce, dairy, and pantry staples to ensure freshness</p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
