<%@ Page Title="Resources" Language="vb" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Resources.aspx.vb" Inherits="StudyBuddy.Resources" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<style>
    body {
        background-color: #f4f7f5;
        background-size: cover;
        background-position: center;
        background-repeat: no-repeat;
    }

    .resources-page {
        background-image: url('bg1.jpg');
        padding: 30px;
        border-radius: 20px;
    }

    .page-title { font-size: 50px; font-family: "Comic Sans MS", "Comic Sans", cursive ; position: center; font-weight: bold; margin-bottom: 10px; color: #1f2937; }
    .page-desc { margin-bottom: 25px; color: #374151; }

    /* TABS */
    .category-tabs, .year-tabs { display: flex; gap: 12px; margin-bottom: 20px; }

    .category-tabs button, .year-tabs button {
        padding: 10px 20px;
        border-radius: 12px;
        border: none;
        cursor: pointer;
        font-weight: bold;
        transition: 0.2s;
        background: #a7c7b7;
        color: #1f2937;
    }

    .category-tabs button.active, .year-tabs button.active {
        background: #256d5b !important;
        color: white !important;
    }

    .library-card { background-image: url('download.png'); padding: 25px; border-radius: 20px; margin-bottom: 30px; display: none; }
    .year-block { display: none; flex-wrap: wrap; gap: 14px; }


    .book-row { display: flex; gap: 14px; flex-wrap: wrap; margin-bottom: 15px; width: 100%; }
    .book {
        width: 140px; height: 140px;
        background: #fff url('book.png') no-repeat center center;
        background-size: cover;
        border-radius: 16px;
        text-align: center; font-weight: bold; color: #1f2937;
        text-decoration: none; display: flex; flex-direction: column;
        align-items: center; justify-content: flex-end;
        padding-bottom: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.12);
        transition: 0.2s;
    }
    .book:hover { transform: translateY(-6px); background-color: #eaf4f0; text-decoration: none; color: #256d5b; }

    .upload-form { display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 15px; }
    .upload-form input, .upload-form select { padding: 8px 10px; border-radius: 10px; border: 1px solid #ccc; }
    .search-area { display: flex; gap: 10px; margin-bottom: 20px; }
    .search-box { flex: 1; padding: 10px; border-radius: 10px; border: 1px solid #ccc; }
    
    .reviewer-grid { width: 100%; border-collapse: collapse; background: white; margin-top: 20px;}
    .reviewer-grid th { background: #b7e89280; padding: 14px; text-align: left; }
    .reviewer-grid td { padding: 14px; border-bottom: 8px solid #f4f7f5; background: #eaf4f0; }

    .subject-dropdown option[disabled] {
        display: none;
    }
    
    .subject-dropdown {
        padding: 10px;
        border-radius: 8px;
        border: 1px solid #2e7d32;
        width: 100%;
        cursor: pointer;
    }
    .star-list {
        display: flex !important;
        flex-direction: row-reverse;
        justify-content: flex-end;
        border: none;
    }

    .star-list input[type="radio"] {
        display: none;
    }


    .star-list label {
        font-size: 28px;
        color: #ccc; 
        cursor: pointer;
        padding: 0 2px;
    }

    .star-list input:checked ~ label,
    .star-list label:hover,
    .star-list label:hover ~ label {
        color: #ffca08; 
    }
</style>

<div class="resources-page">
    <div class="page-title">Resources</div>
    <div class="page-desc">Choose your course and year to see subjects.</div>

    <div class="card" style="margin-bottom: 20px;">
        <div class="upload-form">
            <asp:FileUpload ID="fileReviewer" runat="server" accept=".pdf" />
            <asp:DropDownList ID="ddlSubject" runat="server" CssClass="subject-dropdown">
                <asp:ListItem Text="Select Subject" Value="" data-course="all" data-year="all" />
                <asp:ListItem Text="GNED02 - Ethics" Value="GNED02" data-course="cs" data-year="1" />
                <asp:ListItem Text="GNED05 - Purposive Communication" Value="GNED05" data-course="cs" data-year="1" />
                <asp:ListItem Text="GNED11 - Kontekstwalisadong Komunikasyon" Value="GNED11" data-course="cs" data-year="1" />
                <asp:ListItem Text="COSC50 - Discrete Structure" Value="COSC50" data-course="cs" data-year="1" />
                <asp:ListItem Text="DCIT21 - Intro to Computing" Value="DCIT21" data-course="cs" data-year="1" />
                <asp:ListItem Text="DCIT22 - Computer Programming 1" Value="DCIT22" data-course="cs" data-year="1" />
                <asp:ListItem Text="FITT1 - Movement Enhancement" Value="FITT1" data-course="cs" data-year="1" />
                <asp:ListItem Text="NSTP1 - NSTP 1" Value="NSTP1" data-course="cs" data-year="1" />
                <asp:ListItem Text="CVSU101 - Institutional Orientation" Value="CVSU101" data-course="cs" data-year="1" />
                <asp:ListItem Text="NSTP2 - NSTP 2" Value="NSTP2" data-course="cs" data-year="1" />
                <asp:ListItem Text="FITT2 - Fitness Exercises" Value="FITT2" data-course="cs" data-year="1" />
                <asp:ListItem Text="GNED03 - Math in Modern World" Value="GNED03" data-course="cs" data-year="1" />
                <asp:ListItem Text="GNED01 - Arts Appreciation" Value="GNED01" data-course="cs" data-year="1" />
                <asp:ListItem Text="GNED06 - Science, Tech & Society" Value="GNED06" data-course="cs" data-year="1" />
                <asp:ListItem Text="ITEC50 - Web Systems 1" Value="ITEC50" data-course="cs" data-year="1" />
                <asp:ListItem Text="DCIT23 - Programming 2 (CS)" Value="DCIT23" data-course="cs" data-year="1" />
                <asp:ListItem Text="GNED12 - Dalumat ng/sa Filipino" Value="GNED12" data-course="cs" data-year="1" />

                <asp:ListItem Text="GNED04 - Kasaysayan ng Pilipinas" Value="GNED04" data-course="cs" data-year="2" />
                <asp:ListItem Text="MATH1 - Analytic Geometry" Value="MATH1" data-course="cs" data-year="2" />
                <asp:ListItem Text="COSC55 - Discrete Structures II" Value="COSC55" data-course="cs" data-year="2" />
                <asp:ListItem Text="INSY50 - Fundamentals of IS" Value="INSY50" data-course="cs" data-year="2" />
                <asp:ListItem Text="FITT3 - Physical Fitness 1" Value="FITT3" data-course="cs" data-year="2" />
                <asp:ListItem Text="COSC60 - Digital Logic Design" Value="COSC60" data-course="cs" data-year="2" />
                <asp:ListItem Text="DCIT50 - OOP" Value="DCIT50" data-course="cs" data-year="2" />
                <asp:ListItem Text="DCIT24 - Info Mgmt" Value="DCIT24" data-course="cs" data-year="2" />
                <asp:ListItem Text="MATH2 - Calculus" Value="MATH2" data-course="cs" data-year="2" />
                <asp:ListItem Text="COSC65 - Architecture & Org" Value="COSC65" data-course="cs" data-year="2" />
                <asp:ListItem Text="DCIT55 - Adv Database" Value="DCIT55" data-course="cs" data-year="2" />
                <asp:ListItem Text="COSC70 - Software Eng I" Value="COSC70" data-course="cs" data-year="2" />
                <asp:ListItem Text="FITT4 - Physical Fitness 2" Value="FITT4" data-course="cs" data-year="2" />
                <asp:ListItem Text="GNED14 - Panitikang Panlipunan" Value="GNED14" data-course="cs" data-year="2" />
                <asp:ListItem Text="GNED08 - Understanding the Self" Value="GNED08" data-course="cs" data-year="2" />
                <asp:ListItem Text="DCIT25 - Data Structures" Value="DCIT25" data-course="cs" data-year="2" />

                <asp:ListItem Text="COSC75 - Software Eng II" Value="COSC75" data-course="cs" data-year="3" />
                <asp:ListItem Text="MATH3 - Linear Algebra" Value="MATH3" data-course="cs" data-year="3" />
                <asp:ListItem Text="COSC80 - Operating Systems" Value="COSC80" data-course="cs" data-year="3" />
                <asp:ListItem Text="COSC85 - Networks & Comm" Value="COSC85" data-course="cs" data-year="3" />
                <asp:ListItem Text="COSC101 - CS Elective 1" Value="COSC101" data-course="cs" data-year="3" />
                <asp:ListItem Text="DCIT26 - App Dev & Emerging Tech" Value="DCIT26" data-course="cs" data-year="3" />
                <asp:ListItem Text="DCIT65 - Social & Prof Issues" Value="DCIT65" data-course="cs" data-year="3" />
                <asp:ListItem Text="ITEC85 - Info Assurance & Security 1" Value="ITEC85" data-course="cs" data-year="3" />
                <asp:ListItem Text="DCIT60 - Method of Research" Value="DCIT60" data-course="cs" data-year="3" />
                <asp:ListItem Text="GNED10 - Gender & Society" Value="GNED10" data-course="cs" data-year="3" />
                <asp:ListItem Text="COSC106 - CS Elective 2 (Game Dev)" Value="COSC106" data-course="cs" data-year="3" />
                <asp:ListItem Text="COSC90 - Design & Analysis of Algo" Value="COSC90" data-course="cs" data-year="3" />
                <asp:ListItem Text="COSC95 - Programming Languages" Value="COSC95" data-course="cs" data-year="3" />
                <asp:ListItem Text="GNED09 - Rizal’s Life & Works" Value="GNED09" data-course="cs" data-year="3" />
                <asp:ListItem Text="MATH4 - Experimental Statistics" Value="MATH4" data-course="cs" data-year="3" />
                <asp:ListItem Text="COSC199 - Practicum" Value="COSC199" data-course="cs" data-year="3" />

                <asp:ListItem Text="ITEC80 - Human-Computer Interaction" Value="ITEC80" data-course="cs" data-year="4" />
                <asp:ListItem Text="COSC100 - Automata Theory" Value="COSC100" data-course="cs" data-year="4" />
                <asp:ListItem Text="COSC105 - Intelligent Systems" Value="COSC105" data-course="cs" data-year="4" />
                <asp:ListItem Text="COSC111 - CS Elective 3 (IoT)" Value="COSC111" data-course="cs" data-year="4" />
                <asp:ListItem Text="COSC200A - Undergrad Thesis I" Value="COSC200A" data-course="cs" data-year="4" />
                <asp:ListItem Text="GNED07 - Contemporary World" Value="GNED07" data-course="cs" data-year="4" />
                <asp:ListItem Text="COSC110 - Numerical Computation" Value="COSC110" data-course="cs" data-year="4" />
                <asp:ListItem Text="COSC200B - Undergrad Thesis II" Value="COSC200B" data-course="cs" data-year="4" />

                <asp:ListItem Text="GNED02 - Ethics" Value="GNED02" data-course="it" data-year="1" />
                <asp:ListItem Text="GNED05 - Purposive Comm" Value="GNED05" data-course="it" data-year="1" />
                <asp:ListItem Text="GNED11 - Kontekstwalisadong Filipino" Value="GNED11" data-course="it" data-year="1" />
                <asp:ListItem Text="COSC50 - Discrete Structure" Value="COSC50" data-course="it" data-year="1" />
                <asp:ListItem Text="DCIT21 - Intro to Computing" Value="DCIT21" data-course="it" data-year="1" />
                <asp:ListItem Text="DCIT22 - Prog 1" Value="DCIT22" data-course="it" data-year="1" />
                <asp:ListItem Text="FITT1 - Movement Enhancement" Value="FITT1" data-course="it" data-year="1" />
                <asp:ListItem Text="NSTP1 - NSTP 1" Value="NSTP1" data-course="it" data-year="1" />
                <asp:ListItem Text="CVSU101 - Orientation" Value="CVSU101" data-course="it" data-year="1" />
                <asp:ListItem Text="NSTP2 - NSTP 2" Value="NSTP2" data-course="it" data-year="1" />
                <asp:ListItem Text="FITT2 - Movement Enhancement 2" Value="FITT2" data-course="it" data-year="1" />
                <asp:ListItem Text="GNED03 - Math in Modern World" Value="GNED03" data-course="it" data-year="1" />
                <asp:ListItem Text="GNED01 - Arts Appreciation" Value="GNED01" data-course="it" data-year="1" />
                <asp:ListItem Text="GNED06 - Science Tech Society" Value="GNED06" data-course="it" data-year="1" />
                <asp:ListItem Text="ITEC50 - Web System & Tech" Value="ITEC50" data-course="it" data-year="1" />
                <asp:ListItem Text="DCIT25 - Prog 2 (IT)" Value="DCIT25" data-course="it" data-year="1" />
                <asp:ListItem Text="GNED12 - Dalumat ng/sa Filipino" Value="GNED12" data-course="it" data-year="1" />

                <asp:ListItem Text="ITEC65 - Platform Tech" Value="ITEC65" data-course="it" data-year="2" />
                <asp:ListItem Text="GNED14 - Panitikan Panlipunan" Value="GNED14" data-course="it" data-year="2" />
                <asp:ListItem Text="GNED04 - Kasaysayan ng Pilipinas" Value="GNED04" data-course="it" data-year="2" />
                <asp:ListItem Text="GNED07 - Contemporary World" Value="GNED07" data-course="it" data-year="2" />
                <asp:ListItem Text="FITT3 - Physical Fitness 1" Value="FITT3" data-course="it" data-year="2" />
                <asp:ListItem Text="DCIT50 - OOP" Value="DCIT50" data-course="it" data-year="2" />
                <asp:ListItem Text="DCIT24 - Info Mgmt" Value="DCIT24" data-course="it" data-year="2" />
                <asp:ListItem Text="GNED10 - Gender & Society" Value="GNED10" data-course="it" data-year="2" />
                <asp:ListItem Text="ITEC70 - Multimedia Systems" Value="ITEC70" data-course="it" data-year="2" />
                <asp:ListItem Text="ITEC65 - Open Source Tech" Value="ITEC65" data-course="it" data-year="2" />
                <asp:ListItem Text="FITT4 - Physical Fitness 2" Value="FITT4" data-course="it" data-year="2" />
                <asp:ListItem Text="GNED08 - Understanding Self" Value="GNED08" data-course="it" data-year="2" />
                <asp:ListItem Text="DCIT25 - Data Structures" Value="DCIT25" data-course="it" data-year="2" />
                <asp:ListItem Text="ITEC60 - Integrated Prog Tech 1" Value="ITEC60" data-course="it" data-year="2" />

                <asp:ListItem Text="ITEC75 - Sys Integration & Arch 1" Value="ITEC75" data-course="it" data-year="3" />
                <asp:ListItem Text="STAT2 - Applied Statistics" Value="STAT2" data-course="it" data-year="3" />
                <asp:ListItem Text="DCIT26 - App Dev & Emerging Tech" Value="DCIT26" data-course="it" data-year="3" />
                <asp:ListItem Text="ITEC80 - Human-Computer Interaction" Value="ITEC80" data-course="it" data-year="3" />
                <asp:ListItem Text="ITEC85 - Info Assurance & Security 1" Value="ITEC85" data-course="it" data-year="3" />
                <asp:ListItem Text="ITEC90 - Network Fundamentals" Value="ITEC90" data-course="it" data-year="3" />
                <asp:ListItem Text="DCIT60 - Method of Research" Value="DCIT60" data-course="it" data-year="3" />
                <asp:ListItem Text="GNED09 - Rizal’s Life & Works" Value="GNED09" data-course="it" data-year="3" />
                <asp:ListItem Text="ITEC100 - Info Assurance & Security" Value="ITEC100" data-course="it" data-year="3" />
                <asp:ListItem Text="ITEC105 - Network Management" Value="ITEC105" data-course="it" data-year="3" />
                <asp:ListItem Text="ITEC106 - IT Elective 2" Value="ITEC106" data-course="it" data-year="3" />
                <asp:ListItem Text="ITEC200A - Capstone 1" Value="ITEC200A" data-course="it" data-year="3" />
                <asp:ListItem Text="ITEC95 - Quantitative Methods" Value="ITEC95" data-course="it" data-year="3" />

                <asp:ListItem Text="DCIT65 - Social & Prof Issues" Value="DCIT65" data-course="it" data-year="4" />
                <asp:ListItem Text="ITEC11 - Integrated Prog Tech 2" Value="ITEC11" data-course="it" data-year="4" />
                <asp:ListItem Text="ITEC116 - Sys Integration & Agri" Value="ITEC116" data-course="it" data-year="4" />
                <asp:ListItem Text="ITEC110 - Systems Admin & Maintenance" Value="ITEC110" data-course="it" data-year="4" />
                <asp:ListItem Text="ITEC200B - Capstone 2" Value="ITEC200B" data-course="it" data-year="4" />
                <asp:ListItem Text="ITEC199 - Practicum" Value="ITEC199" data-course="it" data-year="4" />
            </asp:DropDownList>
            <asp:DropDownList ID="ddlTeacher" runat="server">
                <asp:ListItem Text="Select Teacher" Value="" />
                <asp:ListItem Text="Mr. Aragoncillo" Value="Mr. Aragoncillo" />
                <asp:ListItem Text="Mr. Papa" Value="Mr. Papa" />
                <asp:ListItem Text="Mr. Toledo" Value="Mr. Toledo" />
            </asp:DropDownList>
        </div>
            <asp:Button ID="btnUpload" runat="server" Text="Upload" OnClick="btnUpload_Click" CssClass="aspButton" style="background:#00b4d8; color:white; border:none; padding:8px 16px; border-radius:10px; cursor:pointer; font-weight:bold;" />
        <asp:Label ID="lblStatus" runat="server" CssClass="upload-status" />
    </div>

    <div id="whole-library-section">
        <div class="category-tabs">
            <button type="button" id="btn-it" class="active" onclick="showLibrary('it', this)">IT</button>
            <button type="button" id="btn-cs" onclick="showLibrary('cs', this)">CS</button>
        </div>
        <div class="year-tabs">
            <button type="button" class="year-tab-btn active" id="y1" onclick="filterYear(1, this)">1st Year</button>
            <button type="button" class="year-tab-btn" id="y2" onclick="filterYear(2, this)">2nd Year</button>
            <button type="button" class="year-tab-btn" id="y3" onclick="filterYear(3, this)">3rd Year</button>
            <button type="button" class="year-tab-btn" id="y4" onclick="filterYear(4, this)">4th Year</button>
        </div>

        <div id="library-it" class="library-card">
            <h3>📘 BS Information Technology Library</h3>
            <div class="year-block" data-year="1">
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED02" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED02'); return true;">GNED02<br>Ethics</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED05" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED05'); return true;">GNED05<br>Purposive Comm</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED11" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED11'); return true;">GNED11<br>Kontekstwalisadong Komunikasyon</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC50" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC50'); return true;">COSC50<br>Discrete Structure</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT21" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT21'); return true;">DCIT21<br>Intro to Computing</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT22" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT22'); return true;">DCIT22<br>Prog 1</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="FITT1" OnClick="FilterBySubject" OnClientClick="preSelectSubject('FITT1'); return true;">FITT1<br>Movement Enhancement</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="NSTP1" OnClick="FilterBySubject" OnClientClick="preSelectSubject('NSTP1'); return true;">NSTP1<br>NSTP 1</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="CVSU101" OnClick="FilterBySubject" OnClientClick="preSelectSubject('CVSU101'); return true;">CVSU101<br>Orientation</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="NSTP2" OnClick="FilterBySubject" OnClientClick="preSelectSubject('NSTP2'); return true;">NSTP2<br>NSTP 2</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="FITT2" OnClick="FilterBySubject" OnClientClick="preSelectSubject('FITT2'); return true;">FITT2<br>Movement Enhancement 2</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED03" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED03'); return true;">GNED03<br>Math in Modern World</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED01" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED01'); return true;">GNED01<br>Arts Appreciation</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED06" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED06'); return true;">GNED06<br>STS</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC50" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC50'); return true;">ITEC50<br>Web Sys & Tech</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT25" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT25'); return true;">DCIT25<br>Prog 2 (IT)</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED12" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED12'); return true;">GNED12<br>Dalumat Filipino</asp:LinkButton>
            </div>

            <div class="year-block" data-year="2">
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC65" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC65'); return true;">ITEC65<br>Platform Tech</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED14" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED14'); return true;">GNED14<br>Panitikan Panlipunan</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED04" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED04'); return true;">GNED04<br>Kasaysayan ng Pilipinas</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED07" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED07'); return true;">GNED07<br>Contemp World</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="FITT3" OnClick="FilterBySubject" OnClientClick="preSelectSubject('FITT3'); return true;">FITT3<br>Physical Fitness 1</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT50" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT50'); return true;">DCIT50<br>OOP</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT24" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT24'); return true;">DCIT24<br>Info Mgmt</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED10" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED10'); return true;">GNED10<br>Gender & Society</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC70" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC70'); return true;">ITEC70<br>Multimedia Systems</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC65" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC65'); return true;">ITEC65<br>Open Source Tech</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="FITT4" OnClick="FilterBySubject" OnClientClick="preSelectSubject('FITT4'); return true;">FITT4<br>Physical Fitness 2</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED08" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED08'); return true;">GNED08<br>Understanding Self</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT25" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT25'); return true;">DCIT25<br>Data Structures</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC60" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC60'); return true;">ITEC60<br>Integrated Prog 1</asp:LinkButton>
            </div>

            <div class="year-block" data-year="3">
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC75" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC75'); return true;">ITEC75<br>SIA 1</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="STAT2" OnClick="FilterBySubject" OnClientClick="preSelectSubject('STAT2'); return true;">STAT2<br>Applied Stat</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT26" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT26'); return true;">DCIT26<br>App Dev</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC80" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC80'); return true;">ITEC80<br>HCI</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC85" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC85'); return true;">ITEC85<br>IAS 1</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC90" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC90'); return true;">ITEC90<br>Networking</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT60" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT60'); return true;">DCIT60<br>Research</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED09" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED09'); return true;">GNED09<br>Rizal</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC100" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC100'); return true;">ITEC100<br>IAS 2</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC105" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC105'); return true;">ITEC105<br>Net Mgmt</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC106" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC106'); return true;">ITEC106<br>Web Sys Elective</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC200A" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC200A'); return true;">ITEC200A<br>Capstone 1</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC95" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC95'); return true;">ITEC95<br>Quant Methods</asp:LinkButton>
            </div>

            <div class="year-block" data-year="4">
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT65" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT65'); return true;">DCIT65<br>Social Issues</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC11" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC11'); return true;">ITEC11<br>IPT 2</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC116" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC116'); return true;">ITEC116<br>SIA Agriculture</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC110" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC110'); return true;">ITEC110<br>Sys Admin</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC200B" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC200B'); return true;">ITEC200B<br>Capstone 2</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC199" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC199'); return true;">ITEC199<br>Practicum</asp:LinkButton>
            </div>
        </div>

        <div id="library-cs" class="library-card">
            <h3>📘 BS Computer Science Library</h3>
            <div class="year-block" data-year="1">
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED02" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED02'); return true;">GNED02<br>Ethics</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED05" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED05'); return true;">GNED05<br>Purposive Comm</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED11" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED11'); return true;">GNED11<br>Kontekstwal. Kom</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC50" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC50'); return true;">COSC50<br>Discrete Structure</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT21" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT21'); return true;">DCIT21<br>Intro to Computing</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT22" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT22'); return true;">DCIT22<br>Prog 1</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="FITT1" OnClick="FilterBySubject" OnClientClick="preSelectSubject('FITT1'); return true;">FITT1<br>Movement Enh.</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="NSTP1" OnClick="FilterBySubject" OnClientClick="preSelectSubject('NSTP1'); return true;">NSTP1<br>NSTP 1</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="CVSU101" OnClick="FilterBySubject" OnClientClick="preSelectSubject('CVSU101'); return true;">CVSU101<br>Orientation</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="NSTP2" OnClick="FilterBySubject" OnClientClick="preSelectSubject('NSTP2'); return true;">NSTP2<br>NSTP 2</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="FITT2" OnClick="FilterBySubject" OnClientClick="preSelectSubject('FITT2'); return true;">FITT2<br>Fitness Exer.</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED03" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED03'); return true;">GNED03<br>Math Modern World</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED01" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED01'); return true;">GNED01<br>Arts App</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED06" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED06'); return true;">GNED06<br>STS</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC50" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC50'); return true;">ITEC50<br>Web Systems 1</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT23" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT23'); return true;">DCIT23<br>Prog 2 (CS)</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED12" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED12'); return true;">GNED12<br>Dalumat Filipino</asp:LinkButton>
            </div>

            <div class="year-block" data-year="2">
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED04" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED04'); return true;">GNED04<br>Kasaysayan</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="MATH1" OnClick="FilterBySubject" OnClientClick="preSelectSubject('MATH1'); return true;">MATH1<br>Analytic Geo</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC55" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC55'); return true;">COSC55<br>Discrete Struct 2</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="INSY50" OnClick="FilterBySubject" OnClientClick="preSelectSubject('INSY50'); return true;">INSY50<br>Fund of IS</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="FITT3" OnClick="FilterBySubject" OnClientClick="preSelectSubject('FITT3'); return true;">FITT3<br>Fitness 1</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC60" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC60'); return true;">COSC60<br>Digital Logic</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT50" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT50'); return true;">DCIT50<br>OOP</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT24" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT24'); return true;">DCIT24<br>Info Mgmt</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="MATH2" OnClick="FilterBySubject" OnClientClick="preSelectSubject('MATH2'); return true;">MATH2<br>Calculus</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC65" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC65'); return true;">COSC65<br>Arch & Org</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT55" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT55'); return true;">DCIT55<br>Adv Database</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC70" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC70'); return true;">COSC70<br>Software Eng 1</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="FITT4" OnClick="FilterBySubject" OnClientClick="preSelectSubject('FITT4'); return true;">FITT4<br>Fitness 2</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED14" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED14'); return true;">GNED14<br>Panitikan</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED08" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED08'); return true;">GNED08<br>Understanding Self</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT25" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT25'); return true;">DCIT25<br>Data Structures</asp:LinkButton>
            </div>

            <div class="year-block" data-year="3">
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC75" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC75'); return true;">COSC75<br>Software Eng 2</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="MATH3" OnClick="FilterBySubject" OnClientClick="preSelectSubject('MATH3'); return true;">MATH3<br>Linear Algebra</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC80" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC80'); return true;">COSC80<br>Operating Sys</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC85" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC85'); return true;">COSC85<br>Networks</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC101" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC101'); return true;">COSC101<br>CS Elective 1</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT26" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT26'); return true;">DCIT26<br>App Dev</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT65" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT65'); return true;">DCIT65<br>Social Issues</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC85" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC85'); return true;">ITEC85<br>IAS 1</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="DCIT60" OnClick="FilterBySubject" OnClientClick="preSelectSubject('DCIT60'); return true;">DCIT60<br>Research</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED10" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED10'); return true;">GNED10<br>Gender & Soc</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC106" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC106'); return true;">COSC106<br>Game Dev</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC90" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC90'); return true;">COSC90<br>Algorithms</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC95" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC95'); return true;">COSC95<br>Prog Lang</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED09" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED09'); return true;">GNED09<br>Rizal</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="MATH4" OnClick="FilterBySubject" OnClientClick="preSelectSubject('MATH4'); return true;">MATH4<br>Exp Stat</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC199" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC199'); return true;">COSC199<br>Practicum</asp:LinkButton>
            </div>

            <div class="year-block" data-year="4">
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="ITEC80" OnClick="FilterBySubject" OnClientClick="preSelectSubject('ITEC80'); return true;">ITEC80<br>HCI</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC100" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC100'); return true;">COSC100<br>Automata</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC105" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC105'); return true;">COSC105<br>Intelligent Sys</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC111" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC111'); return true;">COSC111<br>IoT Elective</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC200A" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC200A'); return true;">COSC200A<br>Thesis 1</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="GNED07" OnClick="FilterBySubject" OnClientClick="preSelectSubject('GNED07'); return true;">GNED07<br>Contemp World</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC110" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC110'); return true;">COSC110<br>Numerical Comp</asp:LinkButton>
                <asp:LinkButton runat="server" CssClass="book" CommandArgument="COSC200B" OnClick="FilterBySubject" OnClientClick="preSelectSubject('COSC200B'); return true;">COSC200B<br>Thesis 2</asp:LinkButton>
            </div>
        </div>
    </div>

    <div id="table-container">
        <asp:GridView ID="GridView1" runat="server" CssClass="reviewer-grid" AutoGenerateColumns="False">
            <Columns>
                 <asp:BoundField DataField="filename" HeaderText="File Name" />
                 <asp:BoundField DataField="Subject" HeaderText="Subject" />
                 <asp:BoundField DataField="Subject_Teacher" HeaderText="Teacher" />
            </Columns>
        </asp:GridView>
    </div>
</div>
    <div class="search-area">
        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-box" placeholder="🔍 Search reviewers..." />
        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CssClass="search-button" />
    </div>

    <asp:GridView ID="gvReviewers" runat="server" AutoGenerateColumns="False" CssClass="reviewer-grid">
        <Columns>
            <asp:BoundField DataField="filename" HeaderText="FILE" />
            <asp:BoundField DataField="Subject" HeaderText="SUBJECT" />
            <asp:BoundField DataField="Subject_Teacher" HeaderText="TEACHER" />
            <asp:BoundField DataField="uploaded_by" HeaderText="UPLOADED BY" />
            <asp:BoundField DataField="upload_date" HeaderText="DATE" DataFormatString="{0:MMM dd, yyyy}" />

            <asp:TemplateField HeaderText="RATING">
                <ItemTemplate>
                    <div class="star-wrapper">
                        <div class="star-rating">
                            <asp:RadioButtonList ID="rblStars" runat="server" 
                                RepeatDirection="Horizontal" 
                                RepeatLayout="Flow"
                                AutoPostBack="true" 
                                OnSelectedIndexChanged="rblStars_SelectedIndexChanged" 
                                CssClass="star-list">
                                <asp:ListItem Value="5">★</asp:ListItem>
                                <asp:ListItem Value="4">★</asp:ListItem>
                                <asp:ListItem Value="3">★</asp:ListItem>
                                <asp:ListItem Value="2">★</asp:ListItem>
                                <asp:ListItem Value="1">★</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="rating-stats">
                            Score: <%# Eval("AvgRating", "{0:F1}") %>/5
                        </div>
                    </div>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="ACTIONS">
                <ItemTemplate>
                    <asp:Button ID="btnView" runat="server" Text="View" 
                        OnClick="btnView_Click" 
                        CommandArgument='<%# Eval("filename") %>' 
                        OnClientClick="window.document.forms[0].target='_blank';" 
                        CssClass="action-btn" />
                    <asp:Button Text="Download" CommandArgument='<%# Eval("filename") %>' OnClick="btnDownload_Click" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

<script>
    var currentCourse = localStorage.getItem('lastCourse') || 'it';
    var currentYear = localStorage.getItem('lastYear') || 1;

    function updateSubjectDropdown() {
        var $ddl = $('.subject-dropdown');

        if (!$ddl.hasClass("select2-hidden-accessible")) {
            $ddl.select2({
                placeholder: "Type to search subject (e.g. DCIT26)",
                allowClear: true,
                width: '100%'
            });
        }

        var options = document.querySelectorAll('.subject-dropdown option');
        options.forEach(opt => {
            var optCourse = opt.getAttribute('data-course');
            var optYear = opt.getAttribute('data-year');

            if (optCourse === "all" || (optCourse === currentCourse && optYear == currentYear)) {
                $(opt).prop('disabled', false);
            } else {
            }
        });

        $ddl.val(null).trigger('change'); 
    }

    function preSelectSubject(subjectCode) {
        var $ddl = $('.subject-dropdown');
        if ($ddl.length > 0) {
            $ddl.val(subjectCode).trigger('change');
        }

        // Smooth scroll pataas sa Upload Section
        var uploadSection = document.querySelector('.upload-form');
        if (uploadSection) {
            uploadSection.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    }

    function showLibrary(course, btn) {
        currentCourse = course;
        localStorage.setItem('lastCourse', course);

        // Update Tab buttons UI
        document.querySelectorAll('.category-tabs button').forEach(b => b.classList.remove('active'));
        if (btn) btn.classList.add('active');

        // Show/Hide Library Cards
        document.querySelectorAll('.library-card').forEach(lib => lib.style.display = 'none');
        var targetLib = document.getElementById('library-' + course);
        if (targetLib) targetLib.style.display = 'block';

        // Tawagin ang filterYear gamit ang huling napiling year
        filterYear(currentYear);
    }

    function hideLibrary() {
        var section = document.getElementById('whole-library-section');
        if (section) {
            section.style.display = 'none';
        }
    }

    function filterYear(year, btn) {
        currentYear = year;
        localStorage.setItem('lastYear', year);

        // Update Year buttons UI
        document.querySelectorAll('.year-tabs button').forEach(b => {
            b.classList.remove('active');
            if (b.innerText.includes(year)) b.classList.add('active');
        });

        // Show/Hide Year Blocks
        document.querySelectorAll('.year-block').forEach(block => block.style.display = 'none');
        var activeBlock = document.querySelector('#library-' + currentCourse + ' .year-block[data-year="' + year + '"]');
        if (activeBlock) {
            activeBlock.style.display = 'flex';
        }

        updateSubjectDropdown();

        if (activeBlock) {
            activeBlock.style.display = 'flex';

            activeBlock.onclick = function () {
                document.getElementById('whole-library-section').style.display = 'none';
            };
        }
    }

    function pageLoad() {
        var courseBtn = document.getElementById('btn-' + currentCourse);
        showLibrary(currentCourse, courseBtn);

        var grid = document.getElementById('<%= GridView1.ClientID %>');

        if (grid && grid.rows.length > 1) {
            hideLibrary();
        }
    }

    type = "text/javascript" >
        function resetTarget() {
            setTimeout(function () {
                window.document.forms[0].target = '_self';
            }, 500);
        }
</script>

    <div id="thankYouModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999;">
        <div style="background:white; width:300px; padding:20px; border-radius:15px; text-align:center; position:absolute; top:50%; left:50%; transform:translate(-50%, -50%); box-shadow: 0 4px 15px rgba(0,0,0,0.2);">
            <h2 style="color:#256d5b;">Thanks, buddy!</h2>
            <p>I appreciate the rating.</p>
            <button type="button" onclick="closeModal()" style="background:#256d5b; color:white; border:none; padding:10px 20px; border-radius:8px; cursor:pointer; font-weight:bold;">Okay!!</button>
        </div>
    </div>

<script>
    function showThankYou() {
        document.getElementById('thankYouModal').style.display = 'block';
    }
    function closeModal() {
        document.getElementById('thankYouModal').style.display = 'none';
    }
</script>



    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

</asp:Content>
