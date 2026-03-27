<img width="1919" height="871" alt="Screenshot 2026-03-26 235816" src="https://github.com/user-attachments/assets/9f4b3b84-6fb9-4c99-a2b7-205cd1393dde" /># 🏠 Hostel Management System

The Hostel Management System is a web-based application designed to simplify and automate hostel management processes. It is developed using Java (JSP/Servlets) following the MVC architecture and uses MySQL as the backend database.

This system allows students to perform activities such as applying for gate passes, submitting complaints, and viewing fee status. On the other hand, administrators can manage student records, allocate rooms, approve or reject requests, and handle complaints.

The main goal of this project is to reduce manual work, improve efficiency, and provide a centralized system for managing hostel-related operations.

## 📌 Features

### 👨‍🎓 Student

- **Dashboard**: View room number, gate pass status, complaints, and fees
- **Gate Pass Management**: Apply for gate passes and track approval status
- **Complaint System**: Submit and track complaints with priority levels
- **Fee Management**: View fee details, payment status, and outstanding amounts

### 🛠️ Admin

- **Dashboard**: Overview of students, gate passes, complaints, and rooms
- **Student Management**: View all registered students and their details
- **Gate Pass Approval**: Review and approve/reject student gate pass requests
- **Complaint Resolution**: Manage and resolve student complaints
- **Room Management**: View room allocation, capacity, and availability


## 🛠️ Tech Stack

- **Frontend**: HTML5, CSS3, JavaScript, JSP
- **Backend**: Java Servlets
- **Architecture**: MVC (Model-View-Controller)
- **Database**: MySQL
- **Server**: Apache Tomcat 10
- **IDE**: NetBeans

## ⚙️ Installation

1. Clone repository:

```bash
git clone https://github.com/nisarg1604/HostelManagementSystem.git
```

2. Import project in NetBeans

3. Setup MySQL database:

```sql
CREATE DATABASE hostel_management_system;
```

4. Configure DBConnection.java

5. Add MySQL JDBC Driver

6. Run project on Tomcat

## ▶️ Usage

Open in browser:

```
http://localhost:8080/HostelManagementSystem/
```

## 🔐 Login Details

### Admin

* Email: admin@hostel.com
* Password: admin123

### Student

* Email: preet@gmail.com
* Password: pass123


## 🎯 Key Functionalities

### Authentication & Authorization
- Separate login for students and administrators
- Session-based authentication
- Role-based access control

### CRUD Operations
- **Create**: Add gate passes, complaints
- **Read**: View dashboard, lists, and details
- **Update**: Approve/reject gate passes, resolve complaints
- **Delete**: Supported through admin panel

### MVC Architecture
- **Model**: POJO classes in `com.hostel.model`
- **View**: JSP pages in `web/` directory
- **Controller**: Servlets in `com.hostel.controller`

## 🐛 Troubleshooting

### Database Connection Error
- Verify MySQL service is running
- Check database credentials in `DBConnection.java`
- Ensure MySQL JDBC driver is added to project


## 📞 Support

For any issues or questions you can reach out to us anytime via email.
Email : patelnisarg850@gmail.com

## 📌 Note

This is a college project demonstrating CRUD operations with MVC architecture using JSP/Servlets. Make sure to implement proper security measures for production use.
