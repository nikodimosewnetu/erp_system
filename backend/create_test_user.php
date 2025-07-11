<?php

require_once 'vendor/autoload.php';

$app = require_once 'bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

// First, create required records if they don't exist
DB::table('companies')->insertOrIgnore([
    'id' => 1,
    'name' => 'AMG Holdings',
    'created_at' => now(),
    'updated_at' => now(),
]);

DB::table('roles')->insertOrIgnore([
    'id' => 1,
    'name' => 'Admin',
    'created_at' => now(),
    'updated_at' => now(),
]);

DB::table('branches')->insertOrIgnore([
    'id' => 1,
    'name' => 'Main Branch',
    'company_id' => 1,
    'created_at' => now(),
    'updated_at' => now(),
]);

// Create a test user
$user = User::create([
    'name' => 'Nikodimos',
    'email' => 'nikodimos@gmail.com',
    'password' => Hash::make('niko123'),
    'role_id' => 1,
    'company_id' => 1,
    'branch_id' => 1,
]);

echo "User created successfully!\n";
echo "Email: " . $user->email . "\n";
echo "Password: niko123\n"; 