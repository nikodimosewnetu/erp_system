<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class RoleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        \DB::table('roles')->insertOrIgnore([
            ['name' => 'Admin'],
            ['name' => 'Sales Manager'],
            ['name' => 'Salesperson'],
            ['name' => 'Inventory Manager'],
            ['name' => 'Accountant'],
        ]);
    }
}
