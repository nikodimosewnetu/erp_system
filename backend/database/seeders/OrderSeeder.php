<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class OrderSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('orders')->insert([
            ['order_number' => 'ORD001', 'amount' => 1000],
            ['order_number' => 'ORD002', 'amount' => 1500],
        ]);
    }
} 