# 🧾 WageWise Blueprint

## **Overview**

**WageWise** is a comprehensive system for managing employees, production, and salaries, designed with a modern and easy-to-use Arabic interface. It aims to facilitate the monitoring of daily operations within industrial or commercial establishments, with a precise permissions system that organizes access among users.

## **Roles and Permissions**

*   **👑 Admin:**
    *   Full access to all parts of the system.
    *   Manages users (add, edit, delete, and assign roles).
    *   Can access all pages without exception.
*   **🧭 Supervisor:**
    *   Manages employees (add, edit, delete).
    *   Can add and edit production records and expense vouchers.
    *   Can view all reports.
    *   Cannot access the user management page.
*   **👤 User:**
    *   Permissions are precisely defined by the admin.
    *   Can be granted specific permissions (add, edit, delete, view reports).
    *   The interface automatically adapts to show only the pages allowed to them.

## **Pages and Main Functions**

*   **🏠 Dashboard:**
    *   Displays a quick summary of business and statistics.
    *   Includes cards for: **Total Salaries, Number of Employees, Number of Production Operations**.
    *   A table for the latest entered production records.
*   **👨‍🏭 Employee Management:**
    *   For adding, editing, and deleting employee data (Name, ID, Department).
    *   Available only to the admin and supervisor.
*   **🏗️ Production Management:**
    *   For entering daily production records.
    *   The cost of production is calculated automatically based on the type of operation and the size of the container.
    *   Integrates with salary reports to calculate dues.
*   **💵 Expense Voucher Management:**
    *   For recording disbursed financial amounts (advances, discounts).
    *   Directly affects the employee's net salary in the reports.
    *   Available to the admin and supervisor.
*   **📈 Reports:**
    *   **Salary Report:** Displays total dues and net salary for each employee.
    *   **Report Generator:** A tool to create custom reports (production, expenses, salaries) according to a time period or employee.
*   **👥 User Management:**
    *   For adding, editing, and deleting users (username, role).
    *   Available only to the admin.

## **Technical Specifications**

*   **Responsive Design:** Compatible with all screens.
*   **Local Storage (`shared_preferences`):** For secure and fast data storage.
*   **State Management (`provider`):** For managing application state.
*   **Routing (`go_router`):** For navigation and deep linking.
*   **UI:** Modern Arabic interface with Material Design 3 components.

## **Project Status: Completed**

The application has been fully developed according to the specifications. All features have been implemented, including data persistence using `shared_preferences` and state management with `provider`.
