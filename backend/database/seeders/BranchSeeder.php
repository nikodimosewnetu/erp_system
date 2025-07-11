<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class BranchSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        \DB::table('branches')->insert([
            [
                'company_id' => 1,
                'name' => 'Sheger City Gelan sub-city',
                'address' => 'Sheger City Gelan sub-city, Addis Ababa',
                'phone' => '6080',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}
