<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Selavu.Ai - Detailed Report</title>

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
  display: flex;
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

/* Main Content Area */
.main-content {
  margin-left: 280px;
  padding: 40px;
  min-height: 100vh;
  position: relative;
  z-index: 1;
  width: calc(100% - 280px);
}

/* Header Section */
.header {
  margin-bottom: 30px;
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

.container {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  padding: 30px;
  border-radius: 20px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.3);
  animation: fadeInUp 0.6s ease-out;
}

/* Filter Controls */
.filter-controls {
  display: flex;
  gap: 15px;
  margin-bottom: 25px;
  align-items: flex-end;
  flex-wrap: wrap;
}

.filter-group {
  display: flex;
  flex-direction: column;
}

.filter-group label {
  font-size: 0.85rem;
  margin-bottom: 6px;
  font-weight: 600;
  color: #4a5568;
  margin-left: 5px;
}

.filter-group input {
  border: 2px solid #e2e8f0;
  color: #2d3748;
  padding: 10px 15px;
  border-radius: 12px;
  background: #f7fafc;
  font-family: 'Poppins', sans-serif;
  font-size: 0.9rem;
  transition: all 0.3s;
}

.filter-group input:focus {
  outline: none;
  border-color: #667eea;
  background: #fff;
  box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
}

.search-bar {
  flex-grow: 1;
  min-width: 250px;
}

/* Table Styling */
.table-responsive {
  overflow-x: auto;
  margin-bottom: 20px;
}

table {
  width: 100%;
  border-collapse: collapse;
  border-radius: 12px;
  overflow: hidden;
}

th, td {
  padding: 14px 16px;
  text-align: left;
}

th {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  font-size: 0.85rem;
  text-transform: uppercase;
  cursor: pointer;
  font-weight: 600;
  letter-spacing: 0.5px;
  transition: all 0.3s;
}

th:hover {
  background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
}

th .sort-icon {
  margin-left: 5px;
  opacity: 0.7;
  font-size: 0.75rem;
}

td {
  color: #2d3748;
  border-bottom: 1px solid #e2e8f0;
}

tbody tr {
  transition: all 0.3s;
}

tbody tr:hover {
  background-color: rgba(102, 126, 234, 0.05);
}

/* Report Layout */
.report-layout {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 30px;
}

.report-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 20px;
  flex-wrap: wrap;
  gap: 15px;
}

.total {
  font-weight: 700;
  font-size: 1.3rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 12px;
  text-decoration: none;
  cursor: pointer;
  font-weight: 600;
  font-size: 0.9rem;
  transition: all 0.3s ease;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  box-shadow: 0 5px 20px rgba(102, 126, 234, 0.3);
}

.btn:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 30px rgba(102, 126, 234, 0.4);
}

.btn i {
  font-size: 0.9rem;
}

#clear-filters {
  background: linear-gradient(135deg, #718096 0%, #4a5568 100%);
}

#clear-filters:hover {
  background: linear-gradient(135deg, #4a5568 0%, #718096 100%);
}

/* Chart Section */
.chart-section {
  background: rgba(255, 255, 255, 0.5);
  padding: 25px;
  border-radius: 15px;
  border: 1px solid rgba(255, 255, 255, 0.3);
}

.chart-section h3 {
  margin: 0 0 20px 0;
  font-size: 1.3rem;
  text-align: center;
  color: #2d3748;
  font-weight: 700;
}

.chart-section canvas {
  max-height: 300px;
}

/* Empty State */
.empty-state {
  text-align: center;
  padding: 60px 20px;
  background: rgba(102, 126, 234, 0.05);
  border-radius: 15px;
  border: 2px dashed rgba(102, 126, 234, 0.3);
}

.empty-state i {
  font-size: 4rem;
  margin-bottom: 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.empty-state h3 {
  font-size: 1.5rem;
  margin: 0 0 10px 0;
  color: #2d3748;
}

.empty-state p {
  margin: 0;
  color: #718096;
}

/* Error Alert */
.error-alert {
  background: rgba(252, 129, 129, 0.15);
  color: #c53030;
  padding: 15px 20px;
  border-radius: 12px;
  border: 2px solid #fc8181;
  margin-bottom: 20px;
  font-weight: 500;
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
    width: calc(100% - 240px);
    padding: 30px;
  }

  .report-layout {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  body {
    flex-direction: column;
  }

  .sidebar {
    width: 100%;
    height: auto;
    position: relative;
    border-right: none;
    border-bottom: 1px solid rgba(255, 255, 255, 0.3);
    padding: 15px 0;
  }

  .sidebar-header {
    padding: 0 20px 15px;
  }

  .nav-links {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    padding: 10px;
  }

  .nav-links li {
    margin: 5px;
  }

  .nav-links a {
    padding: 10px 15px;
  }

  .nav-links a span {
    display: none;
  }

  .main-content {
    margin-left: 0;
    width: 100%;
    padding: 20px;
  }

  .header h1 {
    font-size: 2rem;
  }

  .filter-controls {
    flex-direction: column;
  }

  .search-bar {
    width: 100%;
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

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <h2><i class="fas fa-wallet"></i><span>Selavu.Ai</span></h2>
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
    <div class="main-content">
        <header class="header">
            <h1>Detailed Expense Report</h1>
            <p>A complete list of all your recorded transactions.</p>
        </header>
        
        <div class="container">
        <%
            String username = (String) session.getAttribute("un");
            if(username == null){
                response.sendRedirect("signin.html");
                return;
            }

            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            List<Map<String, Object>> transactions = new ArrayList<>();
            String errorMessage = null;

            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","system","0900");
                String sql = "SELECT pdate, iname, qty, category, amount FROM selavu_expenses WHERE uname=? ORDER BY pdate DESC";
                ps = con.prepareStatement(sql);
                ps.setString(1, username);
                rs = ps.executeQuery();
                
                while(rs.next()){
                    Map<String, Object> row = new HashMap<>();
                    row.put("pdate", rs.getDate("pdate"));
                    row.put("iname", rs.getString("iname"));
                    row.put("qty", rs.getString("qty"));
                    row.put("category", rs.getString("category"));
                    row.put("amount", rs.getDouble("amount"));
                    transactions.add(row);
                }
            } catch(Exception e){
                errorMessage = "Error connecting to the database. " + e.getMessage();
                e.printStackTrace();
            } finally {
                try { if(rs!=null) rs.close(); } catch(Exception e){}
                try { if(ps!=null) ps.close(); } catch(Exception e){}
                try { if(con!=null) con.close(); } catch(Exception e){}
            }
            
            if (errorMessage != null) {
        %>
            <div class="error-alert"><strong>Error:</strong> <%= errorMessage %></div>
        <%
            } else if (transactions.isEmpty()) {
        %>
            <div class="empty-state">
                <i class="fas fa-folder-open"></i>
                <h3>No Expenses Found</h3>
                <p>You haven't added any expenses yet. Get started by adding one!</p>
            </div>
        <%
            } else {
        %>
            <!-- Filter Controls -->
            <div class="filter-controls">
                <div class="filter-group search-bar">
                    <label for="search-input">Search by Item Name</label>
                    <input type="text" id="search-input" placeholder="e.g., Coffee, Ticket...">
                </div>
                <div class="filter-group">
                    <label for="start-date">Start Date</label>
                    <input type="date" id="start-date">
                </div>
                <div class="filter-group">
                    <label for="end-date">End Date</label>
                    <input type="date" id="end-date">
                </div>
                 <div class="filter-group">
                    <button id="clear-filters" class="btn"><i class="fas fa-times"></i> Clear</button>
                </div>
            </div>

            <div class="report-layout">
                <!-- Table -->
                <div class="table-section">
                    <div class="table-responsive">
                        <table id="report-table">
                            <thead>
                                <tr>
                                    <th data-sort="date">Date <i class="fas fa-sort sort-icon"></i></th>
                                    <th data-sort="item">Item <i class="fas fa-sort sort-icon"></i></th>
                                    <th>Qty</th>
                                    <th data-sort="category">Category <i class="fas fa-sort sort-icon"></i></th>
                                    <th data-sort="amount">Amount <i class="fas fa-sort sort-icon"></i></th>
                                </tr>
                            </thead>
                            <tbody>
                            <%
                                NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
                                for (Map<String, Object> row : transactions) {
                                    java.util.Date pdate = (java.util.Date)row.get("pdate");
                            %>
                                <tr data-date="<%= new SimpleDateFormat("yyyy-MM-dd").format(pdate) %>">
                                    <td><%= new SimpleDateFormat("dd-MMM-yyyy").format(pdate) %></td>
                                    <td><%= row.get("iname") %></td>
                                    <td><%= row.get("qty") %></td>
                                    <td><%= row.get("category") %></td>
                                    <td data-amount="<%= row.get("amount") %>"><%= currencyFormatter.format(row.get("amount")) %></td>
                                </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>

                    <div class="report-actions">
                         <div id="total-spent" class="total"></div>
                         <div>
                            <a href="dashboard.jsp" class="btn"><i class="fas fa-arrow-left"></i> Back</a>
                            <button onclick="window.print()" class="btn"><i class="fas fa-print"></i> Print</button>
                         </div>
                    </div>
                </div>

                <!-- Chart -->
                <div class="chart-section">
                    <h3>Category Breakdown</h3>
                    <canvas id="expenseChart"></canvas>
                </div>
            </div>
        <%
            }
        %>
        </div>
    </div>

    <% if (!transactions.isEmpty()) { %>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const tableRows = document.querySelectorAll("#report-table tbody tr");
            let expenseChart;

            // --- UTILITY FUNCTIONS ---
            const currencyFormatter = new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR' });

            function updateReport(visibleRows) {
                let total = 0;
                const categoryMap = new Map();

                visibleRows.forEach(row => {
                    const amount = parseFloat(row.querySelector('[data-amount]').dataset.amount);
                    total += amount;
                    const category = row.cells[3].textContent;
                    categoryMap.set(category, (categoryMap.get(category) || 0) + amount);
                });

                document.getElementById('total-spent').textContent = `Total Spent: ${currencyFormatter.format(total)}`;
                updateChart(categoryMap);
            }

            function updateChart(categoryMap) {
                const sortedCategories = new Map([...categoryMap.entries()].sort((a, b) => b[1] - a[1]));
                const labels = [...sortedCategories.keys()];
                const data = [...sortedCategories.values()];

                if (expenseChart) {
                    expenseChart.data.labels = labels;
                    expenseChart.data.datasets[0].data = data;
                    expenseChart.update();
                } else {
                    const ctx = document.getElementById('expenseChart').getContext('2d');
                    expenseChart = new Chart(ctx, {
                        type: 'doughnut',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: 'Total Spent',
                                data: data,
                                backgroundColor: [
                                    'rgba(102, 126, 234, 0.8)', 'rgba(118, 75, 162, 0.8)', 
                                    'rgba(240, 147, 251, 0.8)', 'rgba(245, 87, 108, 0.8)',
                                    'rgba(74, 172, 254, 0.8)', 'rgba(0, 242, 254, 0.8)', 
                                    'rgba(255, 159, 64, 0.8)', 'rgba(153, 102, 255, 0.8)'
                                ],
                                borderColor: '#fff',
                                borderWidth: 3,
                                hoverOffset: 15
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: true,
                            plugins: {
                                legend: {
                                    position: 'bottom',
                                    labels: {
                                        color: '#2d3748',
                                        font: {
                                            family: 'Poppins',
                                            size: 12,
                                            weight: '500'
                                        },
                                        padding: 15,
                                        boxWidth: 15
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
                                        label: (context) => `${context.label}: ${currencyFormatter.format(context.raw)}`
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
                            cutout: '65%'
                        }
                    });
                }
            }
            
            // --- FILTERING LOGIC ---
            function applyFilters() {
                const searchTerm = document.getElementById('search-input').value.toLowerCase();
                const startDate = document.getElementById('start-date').value;
                const endDate = document.getElementById('end-date').value;
                const visibleRows = [];

                tableRows.forEach(row => {
                    const itemName = row.cells[1].textContent.toLowerCase();
                    const rowDate = row.dataset.date;
                    
                    const matchesSearch = itemName.includes(searchTerm);
                    const matchesStartDate = !startDate || rowDate >= startDate;
                    const matchesEndDate = !endDate || rowDate <= endDate;

                    if (matchesSearch && matchesStartDate && matchesEndDate) {
                        row.style.display = '';
                        visibleRows.push(row);
                    } else {
                        row.style.display = 'none';
                    }
                });
                updateReport(visibleRows);
            }

            ['search-input', 'start-date', 'end-date'].forEach(id => {
                document.getElementById(id).addEventListener('input', applyFilters);
            });

            document.getElementById('clear-filters').addEventListener('click', () => {
                 document.getElementById('search-input').value = '';
                 document.getElementById('start-date').value = '';
                 document.getElementById('end-date').value = '';
                 applyFilters();
            });

            // --- SORTING LOGIC ---
            document.querySelectorAll("#report-table thead th[data-sort]").forEach(header => {
                header.addEventListener("click", () => {
                    const tbody = document.querySelector("#report-table tbody");
                    const sortKey = header.dataset.sort;
                    const sortDir = header.dataset.sortDir === 'asc' ? 'desc' : 'asc';
                    header.dataset.sortDir = sortDir;
                    
                    const rowsArray = Array.from(tbody.rows);

                    rowsArray.sort((a, b) => {
                        let valA, valB;
                        if (sortKey === 'amount') {
                            valA = parseFloat(a.querySelector('[data-amount]').dataset.amount);
                            valB = parseFloat(b.querySelector('[data-amount]').dataset.amount);
                        } else if (sortKey === 'date') {
                            valA = new Date(a.dataset.date);
                            valB = new Date(b.dataset.date);
                        } else { // item, category
                           valA = a.cells[sortKey === 'item' ? 1 : 3].textContent.toLowerCase();
                           valB = b.cells[sortKey === 'item' ? 1 : 3].textContent.toLowerCase();
                        }
                        return (valA < valB ? -1 : 1) * (sortDir === 'asc' ? 1 : -1);
                    });
                    
                    rowsArray.forEach(row => tbody.appendChild(row));
                });
            });

            // --- INITIAL LOAD ---
            updateReport(Array.from(tableRows));
        });
    </script>
    <% } %>
</body>
</html>