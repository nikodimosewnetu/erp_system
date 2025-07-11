<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class SimpleSeeder extends Seeder
{
    public function run(): void
    {
        // Create basic data without complex relationships
        DB::table('companies')->insertOrIgnore([
            'id' => 1,
            'name' => 'AMG Holdings PLC',
            'address' => '123 Business Street, Addis Ababa',
            'phone' => '+251911234567',
            'email' => 'info@amgholdings.com',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        DB::table('categories')->insertOrIgnore([
            ['id' => 1, 'name' => 'Electronics', 'created_at' => now(), 'updated_at' => now()],
            ['id' => 2, 'name' => 'Clothing', 'created_at' => now(), 'updated_at' => now()],
            ['id' => 3, 'name' => 'Food & Beverages', 'created_at' => now(), 'updated_at' => now()],
        ]);

        DB::table('products')->insertOrIgnore([
            [
                'id' => 1,
                'name' => 'iPhone 15 Pro',
                'description' => 'Latest iPhone with advanced features',
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
                'description' => 'Premium Android smartphone',
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
                'name' => 'Coffee Beans Premium',
                'description' => 'High-quality Ethiopian coffee beans',
                'category_id' => 3,
                'price' => 1200.00,
                'cost_price' => 800.00,
                'sku' => 'COFFEE001',
                'company_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        DB::table('customers')->insertOrIgnore([
            [
                'id' => 1,
                'name' => 'John Doe',
                'email' => 'john.doe@email.com',
                'phone' => '+251912345678',
                'address' => '456 Customer Street, Addis Ababa',
                'type' => 'individual',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'name' => 'ABC Corporation',
                'email' => 'contact@abccorp.com',
                'phone' => '+251923456789',
                'address' => '789 Business Ave, Addis Ababa',
                'type' => 'business',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        DB::table('finances')->insertOrIgnore([
            [
                'id' => 1,
                'type' => 'income',
                'amount' => 46200.00,
                'description' => 'Sales Revenue - July',
                'date' => now()->subDays(5),
                'category' => 'sales',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'type' => 'expense',
                'amount' => 15000.00,
                'description' => 'Employee Salaries - July',
                'date' => now()->subDays(1),
                'category' => 'payroll',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
} 