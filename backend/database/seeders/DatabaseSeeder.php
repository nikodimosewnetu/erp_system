<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Only run the WorkingSeeder to avoid constraint issues
        $this->call([
            WorkingSeeder::class,
        ]);
    }
}
