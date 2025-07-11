<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class InventorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        \DB::table('inventories')->insert([
            ['name' => 'Laptop', 'quantity' => 10],
            ['name' => 'Monitor', 'quantity' => 20],
            ['name' => 'Keyboard', 'quantity' => 50],
        ]);
    }
}
