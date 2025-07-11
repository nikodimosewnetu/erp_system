<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class WorkingSeeder extends Seeder
{
    public function run(): void
    {
        // Disable foreign key checks for SQLite
        DB::statement('PRAGMA foreign_keys = OFF');

        // Clear existing data
        DB::table('products')->truncate();
        DB::table('categories')->truncate();
        DB::table('companies')->truncate();
        DB::table('customers')->truncate();
        DB::table('finances')->truncate();
        DB::table('employees')->truncate();
        DB::table('users')->truncate();
        DB::table('roles')->truncate();

        // Create roles first
        DB::table('roles')->insert([
            ['id' => 1, 'name' => 'Admin', 'created_at' => now(), 'updated_at' => now()],
            ['id' => 2, 'name' => 'Manager', 'created_at' => now(), 'updated_at' => now()],
            ['id' => 3, 'name' => 'Accountant', 'created_at' => now(), 'updated_at' => now()],
            ['id' => 4, 'name' => 'Employee', 'created_at' => now(), 'updated_at' => now()],
        ]);

        // Create companies first
        DB::table('companies')->insert([
            'id' => 1,
            'name' => 'AMG Holdings PLC',
            'address' => '123 Business Street, Addis Ababa',
            'phone' => '+251911234567',
            'email' => 'info@amgholdings.com',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        // Create branches
        DB::table('branches')->insert([
            'id' => 1,
            'name' => 'Main Branch',
            'address' => '123 Business Street, Addis Ababa',
            'phone' => '+251911234567',
            'company_id' => 1,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        // Create categories with company_id
        DB::table('categories')->insert([
            ['id' => 1, 'name' => 'Electronics', 'description' => 'Electronic devices and gadgets', 'company_id' => 1, 'created_at' => now(), 'updated_at' => now()],
            ['id' => 2, 'name' => 'Clothing', 'description' => 'Fashion and apparel items', 'company_id' => 1, 'created_at' => now(), 'updated_at' => now()],
            ['id' => 3, 'name' => 'Food & Beverages', 'description' => 'Food products and drinks', 'company_id' => 1, 'created_at' => now(), 'updated_at' => now()],
            ['id' => 4, 'name' => 'Furniture', 'description' => 'Home and office furniture', 'company_id' => 1, 'created_at' => now(), 'updated_at' => now()],
            ['id' => 5, 'name' => 'Books', 'description' => 'Educational and entertainment books', 'company_id' => 1, 'created_at' => now(), 'updated_at' => now()],
            ['id' => 6, 'name' => 'Sports & Fitness', 'description' => 'Sports equipment and fitness gear', 'company_id' => 1, 'created_at' => now(), 'updated_at' => now()],
        ]);

        // Create users
        DB::table('users')->insert([
            [
                'name' => 'Admin User',
                'email' => 'admin@amgholdings.com',
                'password' => Hash::make('password'),
                'role_id' => 1,
                'company_id' => 1,
                'branch_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Nikodimos',
                'email' => 'nikodimos@gmail.com',
                'password' => Hash::make('niko123'),
                'role_id' => 1,
                'company_id' => 1,
                'branch_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        // Create employees
        DB::table('employees')->insert([
            [
                'id' => 1,
                'name' => 'Abebe Kebede',
                'email' => 'abebe.kebede@amgholdings.com',
                'phone' => '+251912345678',
                'position' => 'Sales Manager',
                'department' => 'Sales',
                'salary' => 25000.00,
                'hire_date' => '2023-01-15',
                'company_id' => 1,
                'branch_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'name' => 'Tigist Haile',
                'email' => 'tigist.haile@amgholdings.com',
                'phone' => '+251923456789',
                'position' => 'Accountant',
                'department' => 'Finance',
                'salary' => 22000.00,
                'hire_date' => '2023-03-20',
                'company_id' => 1,
                'branch_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'name' => 'Dawit Mengistu',
                'email' => 'dawit.mengistu@amgholdings.com',
                'phone' => '+251934567890',
                'position' => 'IT Specialist',
                'department' => 'IT',
                'salary' => 28000.00,
                'hire_date' => '2023-02-10',
                'company_id' => 1,
                'branch_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 4,
                'name' => 'Yohannes Tadesse',
                'email' => 'yohannes.tadesse@amgholdings.com',
                'phone' => '+251945678901',
                'position' => 'Warehouse Manager',
                'department' => 'Operations',
                'salary' => 20000.00,
                'hire_date' => '2023-04-05',
                'company_id' => 1,
                'branch_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 5,
                'name' => 'Bethel Assefa',
                'email' => 'bethel.assefa@amgholdings.com',
                'phone' => '+251956789012',
                'position' => 'Marketing Specialist',
                'department' => 'Marketing',
                'salary' => 23000.00,
                'hire_date' => '2023-05-12',
                'company_id' => 1,
                'branch_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        // Add more employees
        DB::table('employees')->insert([
            [
                'name' => 'Sara Tesfaye',
                'email' => 'sara.tesfaye@amgholdings.com',
                'phone' => '+251911111111',
                'position' => 'HR Manager',
                'department' => 'HR',
                'salary' => 18000.00,
                'hire_date' => '2023-06-01',
                'company_id' => 1,
                'branch_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Mulugeta Bekele',
                'email' => 'mulugeta.bekele@amgholdings.com',
                'phone' => '+251922222222',
                'position' => 'Logistics Officer',
                'department' => 'Logistics',
                'salary' => 15000.00,
                'hire_date' => '2023-07-10',
                'company_id' => 1,
                'branch_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        // Create products
        DB::table('products')->insert([
            [
                'id' => 1,
                'name' => 'iPhone 15 Pro',
                'description' => 'Latest iPhone with advanced features and A17 Pro chip',
                'category_id' => 1,
                'price' => 45000.00,
                'cost_price' => 38000.00,
                'sku' => 'IPH15PRO001',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'name' => 'Samsung Galaxy S24',
                'description' => 'Premium Android smartphone with AI features',
                'category_id' => 1,
                'price' => 35000.00,
                'cost_price' => 28000.00,
                'sku' => 'SAMS24GAL001',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'name' => 'MacBook Pro M3',
                'description' => 'Professional laptop for developers and creatives',
                'category_id' => 1,
                'price' => 85000.00,
                'cost_price' => 72000.00,
                'sku' => 'MACPRO001',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 4,
                'name' => 'Coffee Beans Premium',
                'description' => 'High-quality Ethiopian coffee beans from Sidamo region',
                'category_id' => 3,
                'price' => 1200.00,
                'cost_price' => 800.00,
                'sku' => 'COFFEE001',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 5,
                'name' => 'Office Chair',
                'description' => 'Ergonomic office chair with lumbar support',
                'category_id' => 4,
                'price' => 12000.00,
                'cost_price' => 8500.00,
                'sku' => 'CHAIR001',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 6,
                'name' => 'Nike Running Shoes',
                'description' => 'Professional running shoes with cushioning technology',
                'category_id' => 6,
                'price' => 8500.00,
                'cost_price' => 6000.00,
                'sku' => 'NIKE001',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 7,
                'name' => 'Business Suit',
                'description' => 'Professional business suit for formal occasions',
                'category_id' => 2,
                'price' => 15000.00,
                'cost_price' => 10000.00,
                'sku' => 'SUIT001',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 8,
                'name' => 'Programming Book',
                'description' => 'Complete guide to Flutter development',
                'category_id' => 5,
                'price' => 2500.00,
                'cost_price' => 1500.00,
                'sku' => 'BOOK001',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        // Create customers
        DB::table('customers')->insert([
            [
                'id' => 1,
                'name' => 'John Doe',
                'email' => 'john.doe@email.com',
                'phone' => '+251912345678',
                'address' => '456 Customer Street, Addis Ababa',
                'type' => 'individual',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'name' => 'ABC Corporation',
                'email' => 'contact@abccorp.com',
                'phone' => '+251923456789',
                'address' => '789 Business Ave, Addis Ababa',
                'type' => 'corporate',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'name' => 'Tech Solutions Ltd',
                'email' => 'info@techsolutions.com',
                'phone' => '+251945678901',
                'address' => '567 Tech Park, Addis Ababa',
                'type' => 'corporate',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 4,
                'name' => 'Sarah Johnson',
                'email' => 'sarah.johnson@email.com',
                'phone' => '+251956789012',
                'address' => '123 Personal Lane, Addis Ababa',
                'type' => 'individual',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 5,
                'name' => 'Global Trading Co',
                'email' => 'sales@globaltrading.com',
                'phone' => '+251967890123',
                'address' => '890 Trade Center, Addis Ababa',
                'type' => 'corporate',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        // Add more finances
        DB::table('finances')->insert([
            [
                'type' => 'income',
                'amount' => 120000.00,
                'description' => 'Consulting Revenue',
                'date' => now()->subDays(10),
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'type' => 'expense',
                'amount' => 20000.00,
                'description' => 'Office Supplies',
                'date' => now()->subDays(8),
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        // Create suppliers
        DB::table('suppliers')->truncate();
        DB::table('suppliers')->insert([
            [
                'id' => 1,
                'name' => 'Tech Importers PLC',
                'email' => 'info@techimporters.com',
                'phone' => '+251900000001',
                'address' => 'Industrial Zone, Addis Ababa',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'name' => 'Global Foods',
                'email' => 'contact@globalfoods.com',
                'phone' => '+251900000002',
                'address' => 'Food Park, Addis Ababa',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        // Create inventory
        DB::table('inventories')->truncate();
        DB::table('inventories')->insert([
            [
                'id' => 1,
                'product_id' => 1,
                'branch_id' => 1,
                'quantity' => 50,
                'min_stock' => 10,
                'max_stock' => 100,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'product_id' => 2,
                'branch_id' => 1,
                'quantity' => 30,
                'min_stock' => 5,
                'max_stock' => 80,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        // Add more sales orders
        DB::table('sales_orders')->insert([
            [
                'customer_id' => 1,
                'user_id' => 1,
                'branch_id' => 1,
                'order_date' => now()->subDays(3),
                'total_amount' => 50000.00,
                'status' => 'confirmed',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'customer_id' => 2,
                'user_id' => 1,
                'branch_id' => 1,
                'order_date' => now()->subDays(1),
                'total_amount' => 25000.00,
                'status' => 'pending',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        // Create invoices
        DB::table('invoices')->truncate();
        DB::table('invoices')->insert([
            [
                'sales_order_id' => 1,
                'invoice_date' => now()->subDays(2),
                'due_date' => now()->addDays(10),
                'total_amount' => 50000.00,
                'status' => 'paid',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'sales_order_id' => 2,
                'invoice_date' => now()->subDays(1),
                'due_date' => now()->addDays(15),
                'total_amount' => 25000.00,
                'status' => 'unpaid',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        // Create payments
        DB::table('payments')->truncate();
        DB::table('payments')->insert([
            [
                'id' => 1,
                'invoice_id' => 1,
                'amount' => 90000.00,
                'payment_date' => now()->subDays(2),
                'method' => 'bank_transfer',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'invoice_id' => 2,
                'amount' => 15000.00,
                'payment_date' => now()->subDays(1),
                'method' => 'cash',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        // Re-enable foreign key checks
        DB::statement('PRAGMA foreign_keys = ON');

        $this->command->info('Database seeded successfully with comprehensive dummy data!');
    }
} 