<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Selavu.Ai - Add Expense</title>
  
  <!-- External Fonts and Icons -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  
  <style>
    /* Base Styles */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Poppins', sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      padding: 20px;
      position: relative;
      overflow: hidden;
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

    /* Back button */
    .back-btn {
      position: fixed;
      top: 30px;
      left: 30px;
      width: 45px;
      height: 45px;
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(20px);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      text-decoration: none;
      color: #667eea;
      font-size: 1.2rem;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.15);
      transition: all 0.3s ease;
      z-index: 100;
      border: 1px solid rgba(255, 255, 255, 0.3);
    }

    .back-btn:hover {
      transform: translateX(-5px);
      box-shadow: 0 8px 30px rgba(102, 126, 234, 0.3);
      background: rgba(255, 255, 255, 1);
    }
    
    .container {
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(20px);
      padding: 30px 35px;
      border-radius: 25px;
      box-shadow: 0 15px 50px rgba(0, 0, 0, 0.2);
      border: 1px solid rgba(255, 255, 255, 0.3);
      width: 100%;
      max-width: 500px;
      animation: fadeIn 1s ease-in-out;
      position: relative;
      z-index: 1;
    }
    
    /* Logo/Icon at top */
    .logo-icon {
      width: 55px;
      height: 55px;
      margin: 0 auto 12px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.5rem;
      color: #fff;
      box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
    }

    h2 {
      text-align: center;
      margin-bottom: 8px;
      font-size: 1.5rem;
      font-weight: 700;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .subtitle {
      color: #718096;
      font-size: 0.85rem;
      margin-bottom: 25px;
      text-align: center;
    }
    
    .form-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 15px;
    }

    .form-group {
      margin-bottom: 15px;
      position: relative;
    }
    
    .full-width {
      grid-column: 1 / -1;
    }

    label {
      font-weight: 600;
      display: block;
      margin-bottom: 6px;
      font-size: 0.8rem;
      color: #4a5568;
      margin-left: 5px;
    }
    
    .input-wrapper {
      position: relative;
    }

    .input-wrapper i {
      position: absolute;
      left: 16px;
      top: 50%;
      transform: translateY(-50%);
      color: #a0aec0;
      font-size: 0.95rem;
      z-index: 1;
    }
    
    input, select {
      width: 100%;
      padding: 12px 18px 12px 45px;
      box-sizing: border-box;
      background: #f7fafc;
      border: 2px solid #e2e8f0;
      border-radius: 15px;
      color: #2d3748;
      font-size: 0.9rem;
      font-family: 'Poppins', sans-serif;
      transition: all 0.3s;
    }
    
    select {
      padding-left: 18px;
      appearance: none;
      background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23a0aec0%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22%2F%3E%3C%2Fsvg%3E');
      background-repeat: no-repeat;
      background-position: right 16px top 50%;
      background-size: 0.6em auto;
      background-color: #f7fafc;
    }

    input::placeholder {
      color: #a0aec0;
    }
    
    input:focus, select:focus {
      background-color: #fff;
      border-color: #667eea;
      outline: none;
      box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
    }

    .input-wrapper:focus-within i {
      color: #667eea;
    }
    
    .btn-group {
      margin-top: 20px;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    button {
      width: 100%;
      padding: 12px;
      border: none;
      font-weight: 600;
      border-radius: 15px;
      cursor: pointer;
      transition: all 0.3s ease;
      font-size: 0.95rem;
      font-family: 'Poppins', sans-serif;
      position: relative;
      overflow: hidden;
    }
    
    .btn-submit {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: #fff;
      box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
    }

    .btn-submit::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
      transition: left 0.4s ease;
    }

    .btn-submit:hover::before {
      left: 0;
    }

    .btn-submit span {
      position: relative;
      z-index: 1;
    }

    .btn-submit:hover {
      transform: translateY(-3px);
      box-shadow: 0 15px 40px rgba(102, 126, 234, 0.4);
    }
    
    .btn-back {
      background: rgba(102, 126, 234, 0.1);
      color: #667eea;
      border: 2px solid #667eea;
    }

    .btn-back:hover {
      background: rgba(102, 126, 234, 0.15);
      transform: translateY(-2px);
    }
    
    .message {
      text-align: center;
      margin-top: 15px;
      font-weight: 600;
      padding: 12px 16px;
      border-radius: 12px;
      font-size: 0.85rem;
      animation: fadeIn 0.5s ease-in-out;
    }
    
    .message.success {
      background: rgba(72, 187, 120, 0.15);
      color: #2f855a;
      border: 2px solid #48bb78;
    }

    .message.error {
      background: rgba(252, 129, 129, 0.15);
      color: #c53030;
      border: 2px solid #fc8181;
    }

    .divider {
      display: flex;
      align-items: center;
      margin: 15px 0 10px;
      color: #a0aec0;
      font-size: 0.8rem;
    }

    .divider::before,
    .divider::after {
      content: '';
      flex: 1;
      height: 1px;
      background: #e2e8f0;
    }

    .divider span {
      padding: 0 15px;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(30px); }
      to { opacity: 1; transform: translateY(0); }
    }

    /* Responsive Design */
    @media (max-width: 768px) {
      .form-grid {
        grid-template-columns: 1fr;
      }

      .container {
        padding: 30px 25px;
      }

      h2 {
        font-size: 1.5rem;
      }

      .back-btn {
        top: 20px;
        left: 20px;
        width: 40px;
        height: 40px;
        font-size: 1rem;
      }
    }
  </style>
</head>
<body>
  <!-- Back to Dashboard Button -->
  <a href="dashboard.jsp" class="back-btn" title="Back to Dashboard">
    <i class="fas fa-arrow-left"></i>
  </a>

  <div class="container">
    <div class="logo-icon">
      <i class="fas fa-plus-circle"></i>
    </div>
    <h2>Add New Expense</h2>
    <p class="subtitle">Track your spending and manage your budget</p>
    
    <form method="post" action="addExpenses.jsp">
      <div class="form-grid">
        <div class="form-group">
          <label for="amount">Amount</label>
          <div class="input-wrapper">
            <i class="fas fa-rupee-sign"></i>
            <input type="number" step="0.01" name="amount" required placeholder="0.00">
          </div>
        </div>

        <div class="form-group">
          <label for="qty">Quantity</label>
          <div class="input-wrapper">
            <i class="fas fa-hashtag"></i>
            <input type="text" name="qty" required placeholder="e.g., 1kg, 2 items">
          </div>
        </div>
      </div>
      
      <div class="form-group full-width">
        <label for="iname">Item / Service Name</label>
        <div class="input-wrapper">
          <i class="fas fa-tag"></i>
          <input type="text" name="iname" required placeholder="e.g., Coffee, Bus Ticket">
        </div>
      </div>

      <div class="form-grid">
        <div class="form-group">
          <label for="category">Category</label>
          <select name="category" required>
            <option value="">Select Category</option>
            <option value="Food">Food</option>
            <option value="Transport">Transport</option>
            <option value="Shopping">Shopping</option>
            <option value="Bills">Bills</option>
            <option value="Entertainment">Entertainment</option>
            <option value="Health">Health</option>
            <option value="Other">Other</option>
          </select>
        </div>

        <div class="form-group">
          <label for="pdate">Purchase Date</label>
          <div class="input-wrapper">
            <i class="fas fa-calendar"></i>
            <input type="date" name="pdate" required max="<%= new SimpleDateFormat("yyyy-MM-dd").format(new Date()) %>">
          </div>
        </div>
      </div>

      <div class="btn-group">
        <button type="submit" class="btn-submit">
          <span>Add Expense</span>
        </button>
      </div>
    </form>

    <div class="divider">
      <span>OR</span>
    </div>
    
    <form action="dashboard.jsp" class="btn-group">
      <button type="submit" class="btn-back">Back to Dashboard</button>
    </form>
    
    <%
      String uname = (String) session.getAttribute("un");
      String amount = request.getParameter("amount");
      String iname = request.getParameter("iname");
      String qty = request.getParameter("qty");
      String category = request.getParameter("category");
      String pdate = request.getParameter("pdate");
      String message = "";
      String messageClass = "";

      if(uname != null && amount != null && iname != null && qty != null && category != null && pdate != null) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
           con = Money.DBCon.getCon();
           ps = con.prepareStatement("INSERT INTO selavu_expenses (uname, amount, iname, qty, category, pdate) VALUES (?, ?, ?, ?, ?, ?)");
           ps.setString(1, uname);
           ps.setDouble(2, Double.parseDouble(amount));
           ps.setString(3, iname);
           ps.setString(4, qty);
           ps.setString(5, category);
           ps.setDate(6, java.sql.Date.valueOf(pdate));

           int i = ps.executeUpdate();
           if(i > 0) {
               message = "✓ Expense Added Successfully!";
               messageClass = "success";
           } else {
               message = "✗ Failed to Add Expense.";
               messageClass = "error";
           }
        } catch(Exception e) {
            message = "✗ Error: " + e.getMessage();
            messageClass = "error";
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
    %>
        <div class="message <%= messageClass %>">
            <%= message %>
        </div>
    <%
      }
    %>
   
  </div>
</body>
</html>