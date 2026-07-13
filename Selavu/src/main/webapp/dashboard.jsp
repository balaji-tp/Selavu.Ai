<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.NumberFormat, java.util.Locale" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Selavu.Ai - Dashboard</title>

<!-- External Fonts and Icons -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<!-- Chart.js Library -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
/* Base Styles and Reset */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: "Poppins", sans-serif;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
  position: relative;
  overflow-x: hidden;
}

/* Animated background shapes */
body::before {
  content: '';
  position: fixed;
  top: -50%;
  right: -50%;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
  animation: float 20s infinite ease-in-out;
  z-index: 0;
}

body::after {
  content: '';
  position: fixed;
  bottom: -50%;
  left: -50%;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle, rgba(255,255,255,0.08) 0%, transparent 70%);
  animation: float 25s infinite ease-in-out reverse;
  z-index: 0;
}

@keyframes float {
  0%, 100% { transform: translate(0, 0); }
  50% { transform: translate(50px, 50px); }
}

/* Sidebar Navigation */
.sidebar {
  position: fixed;
  left: 0;
  top: 0;
  width: 280px;
  height: 100vh;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  box-shadow: 4px 0 30px rgba(0, 0, 0, 0.1);
  border-right: 1px solid rgba(255, 255, 255, 0.3);
  z-index: 100;
  padding: 30px 0;
  overflow-y: auto;
}

.sidebar-header {
  padding: 0 30px 30px;
  border-bottom: 2px solid rgba(102, 126, 234, 0.1);
}

.sidebar-header h2 {
  font-size: 1.5rem;
  font-weight: 700;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  display: flex;
  align-items: center;
  gap: 12px;
}

.sidebar-header i {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.nav-links {
  list-style: none;
  padding: 20px 0;
}

.nav-links li {
  margin: 5px 0;
}

.nav-links a {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 15px 30px;
  color: #4a5568;
  text-decoration: none;
  font-weight: 500;
  font-size: 0.95rem;
  transition: all 0.3s ease;
  position: relative;
}

.nav-links a::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  height: 100%;
  width: 4px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  transform: scaleY(0);
  transition: transform 0.3s ease;
}

.nav-links a:hover,
.nav-links a.active {
  color: #667eea;
  background: rgba(102, 126, 234, 0.1);
}

.nav-links a:hover::before,
.nav-links a.active::before {
  transform: scaleY(1);
}

.nav-links a i {
  font-size: 1.1rem;
  width: 20px;
  text-align: center;
}

.logout-link {
  margin-top: 20px;
  padding-top: 20px;
  border-top: 2px solid rgba(102, 126, 234, 0.1);
}

.logout-link a {
  color: #e53e3e;
}

.logout-link a:hover {
  color: #c53030;
  background: rgba(229, 62, 62, 0.1);
}

.logout-link a::before {
  background: #e53e3e;
}

/* Main Content Area */
.main-content {
  margin-left: 280px;
  padding: 40px;
  min-height: 100vh;
  position: relative;
  z-index: 1;
}

/* Header Section */
.header {
  margin-bottom: 40px;
  animation: fadeInDown 0.6s ease-out;
}

.header h1 {
  font-size: 2.5rem;
  font-weight: 700;
  color: #fff;
  margin-bottom: 8px;
  text-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}

.header p {
  color: rgba(255, 255, 255, 0.9);
  font-size: 1.1rem;
}

/* Error Message Styling */
.error-alert {
  background: rgba(252, 129, 129, 0.95);
  backdrop-filter: blur(10px);
  border-left: 6px solid #e53e3e;
  color: #fff;
  padding: 18px 20px;
  margin-bottom: 25px;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(229, 62, 62, 0.3);
  animation: fadeInDown 0.6s ease-out;
}

.error-alert strong {
  font-weight: 700;
  margin-right: 8px;
}

/* Statistics Cards Grid */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 25px;
  margin-bottom: 40px;
  animation: fadeInUp 0.6s ease-out;
}

.stat-card {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  padding: 25px;
  display: flex;
  align-items: center;
  gap: 20px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.3);
  transition: all 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 15px 50px rgba(102, 126, 234, 0.2);
}

.icon-container {
  width: 70px;
  height: 70px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.8rem;
  color: #fff;
  flex-shrink: 0;
}

.icon-total {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.icon-today {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.icon-category {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.stat-card-info h3 {
  font-size: 0.9rem;
  font-weight: 600;
  color: #718096;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-bottom: 8px;
}

.stat-card-info p {
  font-size: 1.8rem;
  font-weight: 700;
  color: #2d3748;
}

/* Chart Container */
.chart-container {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  padding: 30px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.3);
  animation: fadeInUp 0.8s ease-out;
  max-width: 700px;
  margin: 0 auto;
}

.chart-container h2 {
  font-size: 1.3rem;
  font-weight: 700;
  color: #2d3748;
  margin-bottom: 25px;
  text-align: center;
}

.chart-container canvas {
  max-width: 100%;
  max-height: 350px !important;
  height: auto !important;
}

/* Empty State */
.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #a0aec0;
}

.empty-state i {
  font-size: 4rem;
  margin-bottom: 20px;
  opacity: 0.3;
}

.empty-state p {
  font-size: 1.1rem;
  color: #718096;
}

/* Animations */
@keyframes fadeInDown {
  from {
    opacity: 0;
    transform: translateY(-30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Responsive Design */
@media (max-width: 1024px) {
  .sidebar {
    width: 240px;
  }

  .main-content {
    margin-left: 240px;
    padding: 30px;
  }
}

@media (max-width: 768px) {
  .sidebar {
    width: 100%;
    height: auto;
    position: relative;
    border-right: none;
    border-bottom: 1px solid rgba(255, 255, 255, 0.3);
  }

  .main-content {
    margin-left: 0;
    padding: 20px;
  }

  .header h1 {
    font-size: 2rem;
  }

  .stats-grid {
    grid-template-columns: 1fr;
  }

  .stat-card {
    padding: 20px;
  }

  .icon-container {
    width: 60px;
    height: 60px;
    font-size: 1.5rem;
  }

  .stat-card-info p {
    font-size: 1.5rem;
  }

  .chart-container {
    padding: 25px;
  }
}

@media (max-width: 480px) {
  .header h1 {
    font-size: 1.75rem;
  }

  .header p {
    font-size: 1rem;
  }

  .nav-links a {
    padding: 12px 20px;
    font-size: 0.9rem;
  }

  .sidebar-header h2 {
    font-size: 1.3rem;
  }
}

/* Scrollbar Styling */
.sidebar::-webkit-scrollbar {
  width: 6px;
}

.sidebar::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.05);
}

.sidebar::-webkit-scrollbar-thumb {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 10px;
}

.sidebar::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
}
</style>
</head>
<body>

<%
    // --- User Session Check ---
    String username = (String) session.getAttribute("un");
    if (username == null) {
        response.sendRedirect("signin.html");
        return;
    }

    // --- Database Variables ---
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    // --- Data Variables ---
    double totalExpenses = 0.0;
    double todayTotal = 0.0;
    Map<String, Double> categoryMap = new LinkedHashMap<>(); // Use LinkedHashMap to maintain order
    String errorMessage = null;

    // --- Date and Currency Formatting ---
    java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "IN")); // Example: Rupees

    try {
        // --- Database Connection ---
        con = Money.DBCon.getCon();
        
        // --- SQL Query to Fetch Expenses ---
        String sql = "SELECT amount, category, pdate FROM selavu_expenses WHERE uname = ? ORDER BY pdate DESC";
        ps = con.prepareStatement(sql);
        ps.setString(1, username);
        rs = ps.executeQuery();

        // --- Process Query Results ---
        while(rs.next()){
            double amount = rs.getDouble("amount");
            totalExpenses += amount;

            // Check if the expense was made today
            if(today.equals(rs.getDate("pdate"))){
                todayTotal += amount;
            }

            // Aggregate expenses by category
            String category = rs.getString("category");
            categoryMap.put(category, categoryMap.getOrDefault(category, 0.0) + amount);
        }
    } catch(Exception e) {
        errorMessage = "Error connecting to the database. Please try again later.";
        e.printStackTrace(); // Log error to server console
    } finally {
        // --- Close Database Resources ---
        try { if(rs != null) rs.close(); } catch(SQLException e){}
        try { if(ps != null) ps.close(); } catch(SQLException e){}
        try { if(con != null) con.close(); } catch(SQLException e){}
    }
%>

<!-- Sidebar Navigation -->
<aside class="sidebar">
    <div class="sidebar-header">
        <h2><i class="fas fa-wallet"></i>Selavu.Ai</h2>
    </div>
    <ul class="nav-links">
        <li><a href="dashboard.jsp"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
            <li><a href="addExpenses.jsp"><i class="fas fa-plus-circle"></i> <span>Add Expense</span></a></li>
            <li><a href="report.jsp"><i class="fas fa-file-alt"></i> <span>Detailed Reports</span></a></li>
            <li><a href="monthcat.jsp"><i class="fas fa-chart-pie"></i> <span>Category Reports</span></a></li>
            <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></li>
    </ul>
</aside>

<!-- Main Content -->
<main class="main-content">
    <header class="header">
        <h1>Dashboard</h1>
        <p>Welcome back, <%= username %>! Here's your financial summary.</p>
    </header>

    <% if (errorMessage != null) { %>
        <div class="error-alert">
            <strong>Error:</strong> <%= errorMessage %>
        </div>
    <% } %>

    <!-- Statistics Cards -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="icon-container icon-total"><i class="fas fa-coins"></i></div>
            <div class="stat-card-info">
                <h3>Total Spent</h3>
                <p><%= currencyFormatter.format(totalExpenses) %></p>
            </div>
        </div>
        <div class="stat-card">
            <div class="icon-container icon-today"><i class="fas fa-calendar-day"></i></div>
            <div class="stat-card-info">
                <h3>Today's Spending</h3>
                <p><%= currencyFormatter.format(todayTotal) %></p>
            </div>
        </div>
        <div class="stat-card">
            <div class="icon-container icon-category"><i class="fas fa-tags"></i></div>
            <div class="stat-card-info">
                <h3>Categories Used</h3>
                <p><%= categoryMap.size() %></p>
            </div>
        </div>
    </div>

    <!-- Chart Section -->
    <div class="chart-container">
        <h2>Expense Breakdown by Category</h2>
        <% if (!categoryMap.isEmpty()) { %>
            <canvas id="categoryPieChart" height="100"></canvas>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-chart-pie"></i>
                <p>No expense data found. Add your first expense to see a breakdown!</p>
            </div>
        <% } %>
    </div>
</main>

<% if (!categoryMap.isEmpty()) { %>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        // --- Prepare data for the chart ---
        const categoryLabels = [<% for (String key : categoryMap.keySet()) { out.print("'" + key + "',"); } %>];
        const categoryAmounts = [<% for (Double val : categoryMap.values()) { out.print(val + ","); } %>];

        const ctx = document.getElementById('categoryPieChart').getContext('2d');
        
        // --- Create the Chart.js Pie Chart ---
        new Chart(ctx, {
            type: 'doughnut', // Doughnut is a modern alternative to Pie
            data: {
                labels: categoryLabels,
                datasets: [{
                    label: 'Expenses',
                    data: categoryAmounts,
                    backgroundColor: [
                        'rgba(102, 126, 234, 0.8)', 'rgba(118, 75, 162, 0.8)', 'rgba(240, 147, 251, 0.8)', 'rgba(245, 87, 108, 0.8)',
                        'rgba(74, 172, 254, 0.8)', 'rgba(0, 242, 254, 0.8)', 'rgba(255, 159, 64, 0.8)', 'rgba(153, 102, 255, 0.8)'
                    ],
                    borderColor: 'rgba(255, 255, 255, 1)',
                    borderWidth: 3,
                    hoverOffset: 15
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: {
                        position: 'right',
                        labels: {
                            color: '#2d3748',
                            font: {
                                family: 'Poppins',
                                size: 14,
                                weight: '500'
                            },
                            boxWidth: 20,
                            padding: 20
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(45, 55, 72, 0.95)',
                        titleColor: '#fff',
                        bodyColor: '#fff',
                        borderColor: 'rgba(102, 126, 234, 0.5)',
                        borderWidth: 2,
                        padding: 12,
                        cornerRadius: 8,
                        callbacks: {
                            label: function(context) {
                                let label = context.label || '';
                                if (label) {
                                    label += ': ';
                                }
                                if (context.parsed !== null) {
                                    // Format tooltip value as currency
                                    label += new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR' }).format(context.parsed);
                                }
                                return label;
                            }
                        },
                        bodyFont: {
                            family: 'Poppins',
                            size: 13
                        },
                        titleFont: {
                            family: 'Poppins',
                            size: 14,
                            weight: 'bold'
                        }
                    }
                },
                cutout: '65%' // Creates the doughnut hole
            }
        });
    });
</script>
<% } %>

</body>
</html>