<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CompanySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        \DB::table('companies')->insert([
            [
                'name' => 'AMG Holdings PLC',
                'address' => 'Addis Ababa, Ethiopia',
                'email' => 'info@amgholdingsplc.com',
                'phone' => '6080',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}
