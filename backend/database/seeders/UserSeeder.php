<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        \DB::table('users')->insert([
            [
                'name' => 'Admin User',
                'email' => 'admin@amgholdingsplc.com',
                'password' => bcrypt('password'),
                'role_id' => 1,
                'company_id' => 1,
                'branch_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Demo User',
                'email' => 'demouser@example.com',
                'password' => bcrypt('demoPass456'),
                'role_id' => 1,
                'company_id' => 1,
                'branch_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Test User',
                'email' => 'testuser@example.com',
                'password' => bcrypt('testPass123'),
                'role_id' => 1,
                'company_id' => 1,
                'branch_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Nikodimos',
                'email' => 'nikodimos@gmail.com',
                'password' => bcrypt('niko123'),
                'role_id' => 1,
                'company_id' => 1,
                'branch_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}
